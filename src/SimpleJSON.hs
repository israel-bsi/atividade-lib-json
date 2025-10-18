module SimpleJSON
    ( JValue(..),
        getString,
        getNumber,
        getBool,
        getObject,
        getArray,
        isNull,
        renderJValue,
        putJValue    
    ) where

import Data.List (intercalate)
import Data.Char (ord)
import Numeric (showHex)

data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String, JValue)]
            | JArray [JValue]
            deriving (Eq, Ord, Show)

getString :: JValue -> Maybe String
getString (JString s) = Just s
getString _           = Nothing

getNumber :: JValue -> Maybe Double
getNumber (JNumber n) = Just n
getNumber _           = Nothing

getBool :: JValue -> Maybe Bool
getBool (JBool b) = Just b
getBool _        = Nothing

getObject :: JValue -> Maybe [(String, JValue)]
getObject (JObject o) = Just o
getObject _           = Nothing

getArray :: JValue -> Maybe [JValue]
getArray (JArray a) = Just a
getArray _         = Nothing

isNull :: JValue -> Bool
isNull JNull = True
isNull _     = False

renderJValue :: JValue -> String
renderJValue (JString s)   = renderString s
renderJValue (JNumber n)   = show n
renderJValue (JBool True)  = "true"
renderJValue (JBool False) = "false"
renderJValue JNull         = "null"
renderJValue (JObject o)   = "{" ++ renderPairs o ++ "}"
renderJValue (JArray a)    = "[" ++ renderValues a ++ "]"

renderString :: String -> String
renderString s = "\"" ++ concatMap escapeChar s ++ "\""

escapeChar :: Char -> String
escapeChar '\b' = "\\b"
escapeChar '\n' = "\\n"
escapeChar '\f' = "\\f"
escapeChar '\r' = "\\r"
escapeChar '\t' = "\\t"
escapeChar '\\' = "\\\\"
escapeChar '\"' = "\\\""
escapeChar '/'  = "\\/"
escapeChar c
    | mustEscape c = "\\u" ++ replicate (4 - length hex) '0' ++ hex
    | otherwise    = [c]
    where
        mustEscape ch = ch < ' ' || ch == '\x7f' || ch > '\xff'
        hex = showHex (ord c) ""

renderPairs :: [(String, JValue)] -> String
renderPairs [] = ""
renderPairs ps = intercalate ", " (map renderPair ps)
    where
        renderPair (key, value) = renderString key ++ ": " ++ renderJValue value

renderValues :: [JValue] -> String
renderValues [] = ""
renderValues vs = intercalate ", " (map renderJValue vs)

putJValue :: JValue -> IO ()
putJValue v = putStrLn (renderJValue v)
