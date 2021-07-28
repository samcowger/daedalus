-- module for parsing unicode characters
import Stdlib

-- CharCode c: encoding of (ASCII) character c as a character code
def CharCode c = {
  high = ^0;
  low = ^c;
}

def highBitIsSet (x : uint 8) = bitIsSet8 x 7

def ASCIIByte = {
  $$ = UInt8;
  Guard (!(highBitIsSet $$))
}

def NonASCIIByte = {
  $$ = UInt8;
  Guard (highBitIsSet $$)
}

-- UTF-8: byte sequences of length 1 <= n <= 4
def UTF8 (bs1 : Bytes1)
  (bs2 : Bytes2)
  (bs3 : Bytes3)
  (bs4 : Bytes4) = Choose {
  utf81 = bs1;
  utf82 = bs2;
  utf83 = bs3;
  utf84 = bs4; -- TODO: refine to check byte values, if needed
}

def UTF81 (bs : Bytes1) : UTF8 = {|
  utf81 = bs
|}

def UTF82 (bs : Bytes2) : UTF8 = {|
  utf82 = bs
|}

def UTF83 (bs : Bytes3) : UTF8 = {|
  utf83 = bs
|}

def UTF84 (bs : Bytes4) : UTF8 = {|
  utf84 = bs
|}

def UTF8AsciiP = UTF81 (Bytes1 ASCIIByte)

def utf8CharBytes (utfChar: UTF8) = case utfChar of
  utf81 cs1 -> bndBytes1 cs1
  utf82 cs2 -> bndBytes2 cs2
  utf83 cs3 -> bndBytes3 cs3
  utf84 cs4 -> bndBytes4 cs4

-- UnicodeBytes utf8Chars: bytes in the sequence of UTF8 chars uniBytes
def utf8Bytes utf8Chars = concat
  (map (uniChar in utf8Chars) (utf8CharBytes uniChar))

def unicodeTailHOBits : uint 8 = 0xC0

-- trunc8: truncate a two-byte value to one byte
def trunc8 (x : uint 16) : uint 8 = (0 : uint 8) <# x

def shiftTail (x : uint 16) (numCells : uint 64) : uint 8 =
  trunc8 (x >> (numCells * 6))

def PointTail1 (x : uint 16) : Bytes1 = Bytes1
  (unicodeTailHOBits .|. (shiftTail x 0))

def PointTail2 (x : uint 16) : Bytes2 = Bytes2
  (unicodeTailHOBits .|. (shiftTail x 1))
  (PointTail1 (x .&. 0x3F))

def PointTail3 (x : uint 16) : Bytes3 = Bytes3
  (unicodeTailHOBits .|. (shiftTail x 2))
  (PointTail2 (x .&. 0x7FF))

-- unicodePoint: construct a code point from a two-byte value
def UnicodePoint (x : uint 16) : UTF8 =
  if x <= 0x7F then UTF81
    (Bytes1 (trunc8 x))
  else if x <= 0x07FF then UTF82
    (Bytes2 (0xC0 .|. (shiftTail x 1)) (PointTail1 (x .&. 0x3F)))
  else if x <= 0xFFFF then UTF83
    (Bytes3 (0xE0 .|. (shiftTail x 2)) (PointTail2 (x .&. 0x7FF)))
  else Void

