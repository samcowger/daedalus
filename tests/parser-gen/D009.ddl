-- Testing constant propagated fixed length stream operations.
-- Should be same output as D008.ddl

def Chunk n P =  {
  @cur  = GetStream;
  @this = Take n cur;
  @next = Drop n cur;
  SetStream this;
  $$ = P;
  SetStream next;
}

def PadWSpaces n P =
  Chunk n {$$ = P; Many $[' ']; END}

def Main =
  { @a = Choose
    { x = PadWSpaces 3 { Match "ab"}
    ; y = PadWSpaces 3 { Match "ac"}
    }
  ; END
  }
