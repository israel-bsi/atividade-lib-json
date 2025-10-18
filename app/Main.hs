module Main (main) where

import SimpleJSON

main :: IO ()
main = do
    putStrLn "=== Demonstração da Biblioteca JSON ==="
    putStrLn ""
        
    putStrLn "1. String simples:"
    let str = JString "Hello, Haskell!"
    putJValue str
    putStrLn ""
        
    putStrLn "2. Número:"
    let num = JNumber 42.5
    putJValue num
    putStrLn ""
        
    putStrLn "3. Booleanos:"
    putJValue (JBool True)
    putJValue (JBool False)
    putStrLn ""
        
    putStrLn "4. Null:"
    putJValue JNull
    putStrLn ""
        
    putStrLn "5. Array:"
    let arr = JArray [JNumber 1, JNumber 2, JNumber 3, JBool True, JNull]
    putJValue arr
    putStrLn ""
        
    putStrLn "6. Objeto simples:"
    let obj = JObject [("nome", JString "João"), ("idade", JNumber 25), ("ativo", JBool True)]
    putJValue obj
    putStrLn ""
        
    putStrLn "7. Objeto complexo aninhado:"
    let complexObj = JObject
            [ ("nome", JString "Maria")
            , ("idade", JNumber 30)
            , ("email", JString "maria@example.com")
            , ("endereco", JObject
                [ ("rua", JString "Rua das Flores")
                , ("numero", JNumber 123)
                , ("cidade", JString "São Luís")
                , ("estado", JString "MA")
                ])
            , ("hobbies", JArray [JString "leitura", JString "programação", JString "música"])
            , ("ativo", JBool True)
            ]
    putJValue complexObj
    putStrLn ""
        
    putStrLn "8. Testando funções acessoras:"
    let testValue = JString "Teste"
    putStrLn $ "getString: " ++ show (getString testValue)
    putStrLn $ "getNumber: " ++ show (getNumber testValue)
    putStrLn $ "isNull JNull: " ++ show (isNull JNull)
    putStrLn $ "isNull testValue: " ++ show (isNull testValue)
    putStrLn ""
        
    putStrLn "9. String com escape de caracteres:"
    let specialStr = JString "Linha 1\nLinha 2\tTabulação\r\nBarra: \\ Aspas: \""
    putJValue specialStr
    putStrLn ""
    
    putStrLn "=== Fim da Demonstração ==="
