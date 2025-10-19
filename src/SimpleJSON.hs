-- | Módulo SimpleJSON
-- Biblioteca para representação e manipulação de dados JSON em Haskell
-- Demonstra o uso de Tipos de Dados Algébricos (ADTs) e separação entre código puro e impuro

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

-- | Tipo de dados algébrico para representar valores JSON
-- Cobre todos os tipos básicos da especificação JSON
data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String, JValue)]
            | JArray [JValue]
            deriving (Eq, Ord, Show)

-- ============================================================================
-- FUNÇÕES ACESSORAS SEGURAS (SAFE ACCESSORS)
-- Estas são funções puras que extraem valores de forma segura usando Maybe
-- ============================================================================

-- | Extrai uma String de um JValue, retornando Nothing se não for JString
getString :: JValue -> Maybe String
getString (JString s) = Just s
getString _           = Nothing

-- | Extrai um número de um JValue, retornando Nothing se não for JNumber
getNumber :: JValue -> Maybe Double
getNumber (JNumber n) = Just n
getNumber _           = Nothing

-- | Extrai um booleano de um JValue, retornando Nothing se não for JBool
getBool :: JValue -> Maybe Bool
getBool (JBool b) = Just b
getBool _        = Nothing

-- | Extrai um objeto de um JValue, retornando Nothing se não for JObject
getObject :: JValue -> Maybe [(String, JValue)]
getObject (JObject o) = Just o
getObject _           = Nothing

-- | Extrai um array de um JValue, retornando Nothing se não for JArray
getArray :: JValue -> Maybe [JValue]
getArray (JArray a) = Just a
getArray _         = Nothing

-- | Verifica se um JValue é JNull
isNull :: JValue -> Bool
isNull JNull = True
isNull _     = False

-- ============================================================================
-- SERIALIZAÇÃO - CÓDIGO PURO
-- Função pura que converte JValue para String (representação JSON)
-- ============================================================================

-- | Renderiza um JValue para sua representação em formato JSON
-- Esta é uma função PURA - não realiza nenhuma operação de E/S
renderJValue :: JValue -> String
renderJValue (JString s)   = renderString s
renderJValue (JNumber n)   = show n
renderJValue (JBool True)  = "true"
renderJValue (JBool False) = "false"
renderJValue JNull         = "null"
renderJValue (JObject o)   = "{" ++ renderPairs o ++ "}"
renderJValue (JArray a)    = "[" ++ renderValues a ++ "]"

-- ============================================================================
-- FUNÇÕES AUXILIARES INTERNAS (NÃO EXPORTADAS)
-- Estas funções são privadas ao módulo e auxiliam na renderização
-- ============================================================================

-- | Renderiza uma string JSON com escape adequado
renderString :: String -> String
renderString s = "\"" ++ concatMap escapeChar s ++ "\""

-- | Escapa caracteres especiais conforme especificação JSON
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

-- | Renderiza os pares chave-valor de um objeto JSON
renderPairs :: [(String, JValue)] -> String
renderPairs [] = ""
renderPairs ps = intercalate ", " (map renderPair ps)
    where
        renderPair (key, value) = renderString key ++ ": " ++ renderJValue value

-- | Renderiza os valores de um array JSON
renderValues :: [JValue] -> String
renderValues [] = ""
renderValues vs = intercalate ", " (map renderJValue vs)

-- ============================================================================
-- CÓDIGO IMPURO - OPERAÇÕES DE E/S
-- Esta função realiza efeitos colaterais (impressão no terminal)
-- ============================================================================

-- | Imprime um JValue no terminal
-- Esta é uma função IMPURA - realiza operação de E/S
-- Utiliza a função pura renderJValue internamente
putJValue :: JValue -> IO ()
putJValue v = putStrLn (renderJValue v)