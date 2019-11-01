module Pathological

%default total

%access public export

multiString : String
multiString =
  """
  {- This is a multiline string, not a comment
  """ {- This the beginning of a multiline string
      ... and then end -}

charLit : Char
charLit = '"' -- this is not the beginning of a string

-- Ergo this line comment counts
-- As does this line comment!

charLit2 : Char
charLit2 =
  '"' -- char lit at beginning of line

-- line comment
||| doc comment
someCode : ()
someCode = ()
