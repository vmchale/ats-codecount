{- | This is a doc cömment.
 - -}
module Pathological ( håskell ) where



-- this is a line comment {-

{- This is a nested comment.
 - It should be handled appropriately {---}
 -}
{- this is a second block comment -}

str :: String
str = "This is not the beginning of a doc comment {- "

-- | This is a doc comment {-
håskell :: Int
håskell = 3 -- not {-

longAssIdentifier :: String
longAssIdentifier = {- inline block comment -} "this string has a long-ass identifier"
