import Stdlib
import Map

import Glyph

-- Std encodings of glyphs, based on Table D.2
def stdEncodings = [
  mapEntry (octalTriple 1 0 1) (glyph "A")
, mapEntry (octalTriple 3 4 1) (glyph "AE")
, mapEntry (octalTriple 1 0 2) (glyph "B")
, mapEntry (octalTriple 1 0 3) (glyph "C")
, mapEntry (octalTriple 1 0 4) (glyph "D")
, mapEntry (octalTriple 1 0 5) (glyph "E")
, mapEntry (octalTriple 1 0 6) (glyph "F")
, mapEntry (octalTriple 1 0 7) (glyph "G")
, mapEntry (octalTriple 1 1 0) (glyph "H")
, mapEntry (octalTriple 1 1 1) (glyph "I")
, mapEntry (octalTriple 1 1 2) (glyph "J")
, mapEntry (octalTriple 1 1 3) (glyph "K")
, mapEntry (octalTriple 1 1 4) (glyph "L")
, mapEntry (octalTriple 3 5 0) (glyph "Lslash")
, mapEntry (octalTriple 1 1 5) (glyph "M")
, mapEntry (octalTriple 1 1 6) (glyph "N")
, mapEntry (octalTriple 1 1 7) (glyph "O")
, mapEntry (octalTriple 3 5 2) (glyph "OE")
, mapEntry (octalTriple 3 5 1) (glyph "Oslash")
, mapEntry (octalTriple 1 2 0) (glyph "P")
, mapEntry (octalTriple 1 2 1) (glyph "Q")
, mapEntry (octalTriple 1 2 2) (glyph "R")
, mapEntry (octalTriple 1 2 3) (glyph "S")
, mapEntry (octalTriple 1 2 4) (glyph "T")
, mapEntry (octalTriple 1 2 5) (glyph "U")
, mapEntry (octalTriple 1 2 6) (glyph "V")
, mapEntry (octalTriple 1 2 7) (glyph "W")
, mapEntry (octalTriple 1 3 0) (glyph "X")
, mapEntry (octalTriple 1 3 1) (glyph "Y")
, mapEntry (octalTriple 1 3 2) (glyph "Z")
, mapEntry (octalTriple 1 4 1) (glyph "a")
, mapEntry (octalTriple 3 0 2) (glyph "acute")
, mapEntry (octalTriple 3 6 1) (glyph "ae")
, mapEntry (octalTriple 0 4 6) (glyph "ampersand")
, mapEntry (octalTriple 1 3 6) (glyph "asciicircum")
, mapEntry (octalTriple 1 7 6) (glyph "asciitilde")
, mapEntry (octalTriple 0 5 2) (glyph "asterisk")
, mapEntry (octalTriple 1 0 0) (glyph "at")
, mapEntry (octalTriple 1 4 2) (glyph "b")
, mapEntry (octalTriple 1 3 4) (glyph "backslash")
, mapEntry (octalTriple 1 7 4) (glyph "bar")
, mapEntry (octalTriple 1 7 3) (glyph "braceleft")
, mapEntry (octalTriple 1 7 5) (glyph "braceright")
, mapEntry (octalTriple 1 3 3) (glyph "bracketleft")
, mapEntry (octalTriple 1 3 5) (glyph "bracketright")
, mapEntry (octalTriple 3 0 6) (glyph "breve")
, mapEntry (octalTriple 2 6 7) (glyph "bullet")
, mapEntry (octalTriple 1 4 3) (glyph "c")
, mapEntry (octalTriple 3 1 7) (glyph "caron")
, mapEntry (octalTriple 3 1 3) (glyph "cedilla")
, mapEntry (octalTriple 2 4 2) (glyph "cent")
, mapEntry (octalTriple 3 0 3) (glyph "circumflex")
, mapEntry (octalTriple 0 7 2) (glyph "colon")
, mapEntry (octalTriple 0 5 4) (glyph "comma")
, mapEntry (octalTriple 2 5 0) (glyph "currency")
, mapEntry (octalTriple 1 4 4) (glyph "d")
, mapEntry (octalTriple 2 6 2) (glyph "dagger")
, mapEntry (octalTriple 2 6 3) (glyph "daggerdbl")
, mapEntry (octalTriple 3 1 0) (glyph "dieresis")
, mapEntry (octalTriple 0 4 4) (glyph "dollar")
, mapEntry (octalTriple 3 0 7) (glyph "dotaccent")
, mapEntry (octalTriple 3 6 5) (glyph "dotlessi")
, mapEntry (octalTriple 1 4 5) (glyph "e")
, mapEntry (octalTriple 0 7 0) (glyph "eight")
, mapEntry (octalTriple 2 7 4) (glyph "ellipsis")
, mapEntry (octalTriple 3 2 0) (glyph "emdash")
, mapEntry (octalTriple 2 6 1) (glyph "endash")
, mapEntry (octalTriple 0 7 5) (glyph "equal")
, mapEntry (octalTriple 0 4 1) (glyph "exclam")
, mapEntry (octalTriple 2 4 1) (glyph "exclamdown")
, mapEntry (octalTriple 1 4 6) (glyph "f")
, mapEntry (octalTriple 2 5 6) (glyph "fi")
, mapEntry (octalTriple 0 6 5) (glyph "five")
, mapEntry (octalTriple 2 5 7) (glyph "fl")
, mapEntry (octalTriple 2 4 6) (glyph "florin")
, mapEntry (octalTriple 0 6 4) (glyph "four")
, mapEntry (octalTriple 2 4 4) (glyph "fraction")
, mapEntry (octalTriple 1 4 7) (glyph "g")
, mapEntry (octalTriple 3 7 3) (glyph "germandbls")
, mapEntry (octalTriple 3 0 1) (glyph "grave")
, mapEntry (octalTriple 0 7 6) (glyph "greater")
, mapEntry (octalTriple 2 5 3) (glyph "guillemotleft")
, mapEntry (octalTriple 2 7 3) (glyph "guillemotright")
, mapEntry (octalTriple 2 5 4) (glyph "guilsinglleft")
, mapEntry (octalTriple 2 5 5) (glyph "guilsinglright")
, mapEntry (octalTriple 1 5 0) (glyph "h")
, mapEntry (octalTriple 3 1 5) (glyph "hungarumlaut")
, mapEntry (octalTriple 0 5 5) (glyph "hyphen")
, mapEntry (octalTriple 1 5 1) (glyph "i")
, mapEntry (octalTriple 1 5 2) (glyph "j")
, mapEntry (octalTriple 1 5 3) (glyph "k")
, mapEntry (octalTriple 1 5 4) (glyph "l")
, mapEntry (octalTriple 0 7 4) (glyph "less")
, mapEntry (octalTriple 3 7 0) (glyph "lslash")
, mapEntry (octalTriple 1 5 5) (glyph "m")
, mapEntry (octalTriple 3 0 5) (glyph "macron")
, mapEntry (octalTriple 1 5 6) (glyph "n")
, mapEntry (octalTriple 0 7 1) (glyph "nine")
, mapEntry (octalTriple 0 4 3) (glyph "numbersign")
, mapEntry (octalTriple 1 5 7) (glyph "o")
, mapEntry (octalTriple 3 7 2) (glyph "oe")
, mapEntry (octalTriple 3 1 6) (glyph "ogonek")
, mapEntry (octalTriple 0 6 1) (glyph "one")
, mapEntry (octalTriple 3 4 3) (glyph "ordfeminine")
, mapEntry (octalTriple 3 5 3) (glyph "ordmasculine")
, mapEntry (octalTriple 3 7 1) (glyph "oslash")
, mapEntry (octalTriple 1 6 0) (glyph "p")
, mapEntry (octalTriple 2 6 6) (glyph "paragraph")
, mapEntry (octalTriple 0 5 0) (glyph "parenleft")
, mapEntry (octalTriple 0 5 1) (glyph "parenright")
, mapEntry (octalTriple 0 4 5) (glyph "percent")
, mapEntry (octalTriple 0 5 6) (glyph "period")
, mapEntry (octalTriple 2 6 4) (glyph "periodcentered")
, mapEntry (octalTriple 2 7 5) (glyph "perthousand")
, mapEntry (octalTriple 0 5 3) (glyph "plus")
, mapEntry (octalTriple 1 6 1) (glyph "q")
, mapEntry (octalTriple 0 7 7) (glyph "question")
, mapEntry (octalTriple 2 7 7) (glyph "questiondown")
, mapEntry (octalTriple 0 4 2) (glyph "quotedbl")
, mapEntry (octalTriple 2 7 1) (glyph "quotedblbase")
, mapEntry (octalTriple 2 5 2) (glyph "quotedblleft")
, mapEntry (octalTriple 2 7 2) (glyph "quotedblright")
, mapEntry (octalTriple 1 4 0) (glyph "quoteleft")
, mapEntry (octalTriple 0 4 7) (glyph "quoteright")
, mapEntry (octalTriple 2 7 0) (glyph "quotesinglbase")
, mapEntry (octalTriple 2 5 1) (glyph "quotesingle")
, mapEntry (octalTriple 1 6 2) (glyph "r")
, mapEntry (octalTriple 3 1 2) (glyph "ring")
, mapEntry (octalTriple 1 6 3) (glyph "s")
, mapEntry (octalTriple 2 4 7) (glyph "section")
, mapEntry (octalTriple 0 7 3) (glyph "semicolon")
, mapEntry (octalTriple 0 6 7) (glyph "seven")
, mapEntry (octalTriple 0 6 6) (glyph "six")
, mapEntry (octalTriple 0 4 0) (glyph "space")
, mapEntry (octalTriple 0 5 7) (glyph "slash")
, mapEntry (octalTriple 2 4 3) (glyph "sterling")
, mapEntry (octalTriple 1 6 4) (glyph "t")
, mapEntry (octalTriple 0 6 3) (glyph "three")
, mapEntry (octalTriple 3 0 4) (glyph "tilde")
, mapEntry (octalTriple 0 6 2) (glyph "two")
, mapEntry (octalTriple 1 6 5) (glyph "u")
, mapEntry (octalTriple 1 3 7) (glyph "underscore")
, mapEntry (octalTriple 1 6 6) (glyph "v")
, mapEntry (octalTriple 1 6 7) (glyph "w")
, mapEntry (octalTriple 1 7 0) (glyph "x")
, mapEntry (octalTriple 1 7 1) (glyph "y")
, mapEntry (octalTriple 2 4 5) (glyph "yen")
, mapEntry (octalTriple 1 7 2) (glyph "z")
, mapEntry (octalTriple 0 6 0) (glyph "zero")
]

def StdEncoding : [ uint 8 -> glyph ] = ListToMap stdEncodings
