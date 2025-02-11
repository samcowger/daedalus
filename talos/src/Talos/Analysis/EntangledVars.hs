{-# LANGUAGE KindSignatures, GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}


module Talos.Analysis.EntangledVars where

import Control.DeepSeq (NFData)
import GHC.Generics (Generic)

import Data.Set (Set)
import qualified Data.Set as Set
import Data.Map (Map)
import qualified Data.Map as Map

import Control.DeepSeq (NFData)
import GHC.Generics (Generic)

import Daedalus.PP

import Daedalus.Core
import Daedalus.Core.TraverseUserTypes

-- Two variables are entangled if information can flow between them
-- --- i.e., the choice of value for one variable may impact the
-- choices for the other.

data BaseEntangledVar = ResultVar | ProgramVar Name
  deriving (Eq, Generic, NFData)

-- data EntangledVar = EntangledVar { baseVar :: BaseEntangledVar, fields :: [Label] }
--   deriving Eq -- We define our own Ord as we want to ensure ResultVar < everything

-- | `isPrefix x y` is true when `y` is a subfield of x, it is also
-- reflexive, transitive, partial (basically a partial <=) 
-- isPrefix :: EntangledVar -> EntangledVar -> Bool
-- isPrefix (EntangledVar bv1 fs1) (EntangledVar bv2 fs2) = bv1 == bv2 && fs1 `isPrefixOf` fs2

--------------------------------------------------------------------------------
-- Field sets, used to represent all subfields for a base entangled var.
--
-- Basically if we have x.a.b then there will be "a" -> "b" -> {}

-- We use empty to mean 'all'
-- FIXME: make this a sum type, e.g. SemanticProjection = IdentityProjection | FieldSet ...
data FieldSet = FieldSet { getFieldSet :: Map Label FieldSet }
  deriving (Ord, Eq, Show, Generic, NFData)

-- Not exactly empty, just has no children
emptyFieldSet :: FieldSet
emptyFieldSet = FieldSet Map.empty

mergeFieldSet :: FieldSet -> FieldSet -> FieldSet
mergeFieldSet (FieldSet fs1) (FieldSet fs2)
  | Map.null fs1 = mempty
  | Map.null fs2 = mempty
  | otherwise    = FieldSet $ Map.unionWith mergeFieldSet fs1 fs2

explodeFieldSet :: FieldSet -> [ [Label] ]
explodeFieldSet fs
  | fs == emptyFieldSet = [ [] ]
  | otherwise           = [ l : ls | (l, fs') <- Map.toList (getFieldSet fs), ls <- explodeFieldSet fs' ]

pathToFieldSet :: [Label] -> FieldSet
pathToFieldSet ls =
  case ls of
    []       -> emptyFieldSet
    (x : xs) -> FieldSet (Map.singleton x (pathToFieldSet xs))

-- | This says whether two sets of fields overlap -- i.e.,
--  exists x : explodeFieldSet fs1, exists y : explodeFieldSet fs2, x `isPrefixOf` y || y `isPrefixOf` x 
overlappingFields :: FieldSet -> FieldSet -> Bool
overlappingFields (FieldSet fs1) (FieldSet fs2)
  | Map.null fs1 = True
  | Map.null fs2 = True
  | otherwise    = or (Map.intersectionWith overlappingFields fs1 fs2) -- c.f. intersects below

instance Semigroup FieldSet where
  (<>) = mergeFieldSet

instance Monoid FieldSet where
  mempty = emptyFieldSet

--------------------------------------------------------------------------------
-- Emtangled vars

newtype EntangledVars = EntangledVars { getEntangledVars :: Map BaseEntangledVar FieldSet }
  deriving (Eq, Ord, Generic, NFData)

instance Semigroup EntangledVars where
  (<>) = mergeEntangledVars

instance Monoid EntangledVars where
  mempty = EntangledVars Map.empty

mergeEntangledVars :: EntangledVars -> EntangledVars -> EntangledVars
mergeEntangledVars evs1 evs2 =
  EntangledVars $ Map.unionWith mergeFieldSet (getEntangledVars evs1) (getEntangledVars evs2)

singletonEntangledVars :: BaseEntangledVar -> FieldSet -> EntangledVars
singletonEntangledVars bv fs = EntangledVars $ Map.singleton bv fs
  -- where
  --   fs' = foldr (\a b -> FieldSet $ Map.singleton a b) emptyFieldSet fs

mergeEntangledVarss :: [EntangledVars] -> EntangledVars
mergeEntangledVarss = mconcat

nullEntangledVars :: EntangledVars -> Bool
nullEntangledVars = Map.null . getEntangledVars

-- insertEntangledVar :: EntangledVar -> EntangledVars -> EntangledVars
-- insertEntangledVar ev evs = singletonEntangledVars ev <> evs

-- entangledVars :: EntangledVars -> [EntangledVar]
-- entangledVars evs = [ EntangledVar bv fs
--                     | (bv, fs0) <- Map.toList (getEntangledVars evs)
--                     , fs <- explodeFieldSet fs0
--                     ]

-- representativeEntangledVar :: EntangledVars -> EntangledVar
-- representativeEntangledVar evs
--   | ev : _ <- entangledVars evs = ev
--   | otherwise = panic "Empty entangled vars" []


lookupBaseEV :: BaseEntangledVar -> EntangledVars -> Maybe FieldSet
lookupBaseEV bv evs = Map.lookup bv (getEntangledVars evs)

deleteBaseEV :: BaseEntangledVar -> EntangledVars -> (Maybe FieldSet, EntangledVars)
deleteBaseEV bv evs =
  ( Map.lookup bv (getEntangledVars evs)
  , EntangledVars (Map.delete bv (getEntangledVars evs)))

-- sizeEntangledVars :: EntangledVars -> Int
-- sizeEntangledVars = Set.size . getEntangledVars

substEntangledVars :: EntangledVars -> (BaseEntangledVar -> FieldSet -> EntangledVars) -> EntangledVars
substEntangledVars (EntangledVars evs) f = Map.foldMapWithKey f evs

intersects :: EntangledVars -> EntangledVars -> Bool
intersects e1 e2 =
  or (Map.intersectionWith overlappingFields (getEntangledVars e1) (getEntangledVars e2))

memberEntangledVars :: BaseEntangledVar -> EntangledVars -> Bool
memberEntangledVars bv evs = bv `Map.member` getEntangledVars evs

programVars :: EntangledVars -> Set Name
programVars (EntangledVars vs) =
  Set.fromList [ v | ProgramVar v <- Map.keys vs ]

hasResultVar :: EntangledVars -> Bool
hasResultVar evs = Map.member ResultVar (getEntangledVars evs)

--------------------------------------------------------------------------------
-- Class instances

instance Ord BaseEntangledVar where
  ev <= ev' =
    case (ev, ev') of
      (ResultVar, _) -> True
      (ProgramVar v, ProgramVar v') -> v <= v'
      _ -> False

-- instance Ord EntangledVar where
--   (EntangledVar bv1 fs1) <= (EntangledVar bv2 fs2)
--     | bv1 == bv2 = fs1 <= fs2
--     | otherwise  = bv1 <= bv2

instance PP BaseEntangledVar where
  pp ResultVar = "$result"
  pp (ProgramVar v) = pp v

-- instance PP EntangledVar where
--   pp (EntangledVar bv []) = pp bv
--   pp (EntangledVar bv fs) = pp bv <> "." <> hcat (punctuate "." (map pp fs))

instance PP EntangledVars where
  pp evs = lbrace <> commaSep (map ppOne (Map.toList (getEntangledVars evs))) <> rbrace
    where
      ppOne (bv, fset) =
        if fset == emptyFieldSet
        then pp bv
        else pp bv <> "." <> pp fset
        
instance PP FieldSet where
  pp fs = lbrace <> commaSep (map (hcat . punctuate "." . map pp) (explodeFieldSet fs)) <> rbrace

instance TraverseUserTypes BaseEntangledVar where
  traverseUserTypes f ev =
    case ev of
      ResultVar -> pure ev
      ProgramVar v -> ProgramVar <$> traverseUserTypes f v

-- instance TraverseUserTypes EntangledVar where
--   traverseUserTypes f (EntangledVar bv fs) = EntangledVar <$> traverseUserTypes f bv <*> pure fs

instance TraverseUserTypes EntangledVars where
  traverseUserTypes f evs =
    EntangledVars . Map.fromList <$> sequenceA [ (,) <$> traverseUserTypes f k <*> pure v | (k, v) <- Map.toList (getEntangledVars evs) ]

