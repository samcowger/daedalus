import System.Environment
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as BS8
import qualified Data.Text as Text
import Data.Text.Encoding(encodeUtf8)
import qualified Data.List.NonEmpty as NE
import RTS.Input(newInput)
import RTS.Parser(runParser)
import RTS.JSON(toJSON,jsonToBytes,jsArray)
import RTS

main :: IO ()
main =
  do args <- getArgs
     (nm,bs) <- case args of
                   [] -> pure ("(empty)", BS.empty)
                   file : _ ->
                     do bs <- BS.readFile file
                        pure (file, bs)
     let input = newInput (encodeUtf8 (Text.pack nm)) bs
     case runParser pMain input of
       NoResults err -> print err
       Results rs -> BS8.putStrLn
                    $ jsonToBytes
                    $ jsArray
                    $ map toJSON
                    $ NE.toList rs

