module Main (main) where

import SimpleJSON
import Test.Hspec

main :: IO ()
main = hspec $ do
    describe "Funções Acessoras" $ do
        it "getString retorna Just para JString" $ do
            getString (JString "teste") `shouldBe` Just "teste"
        
        it "getString retorna Nothing para outros tipos" $ do
            getString (JNumber 42) `shouldBe` Nothing
            getString (JBool True) `shouldBe` Nothing
            getString JNull `shouldBe` Nothing
        
        it "getNumber retorna Just para JNumber" $ do
            getNumber (JNumber 3.14) `shouldBe` Just 3.14
        
        it "getNumber retorna Nothing para outros tipos" $ do
            getNumber (JString "teste") `shouldBe` Nothing
        
        it "getBool retorna Just para JBool" $ do
            getBool (JBool True) `shouldBe` Just True
            getBool (JBool False) `shouldBe` Just False
        
        it "isNull identifica JNull corretamente" $ do
            isNull JNull `shouldBe` True
            isNull (JString "teste") `shouldBe` False
    
    describe "Renderização JSON" $ do
        it "renderiza strings corretamente" $ do
            renderJValue (JString "hello") `shouldBe` "\"hello\""
        
        it "renderiza números corretamente" $ do
            renderJValue (JNumber 42) `shouldBe` "42.0"
        
        it "renderiza booleanos corretamente" $ do
            renderJValue (JBool True) `shouldBe` "true"
            renderJValue (JBool False) `shouldBe` "false"
        
        it "renderiza null corretamente" $ do
            renderJValue JNull `shouldBe` "null"
        
        it "renderiza arrays vazios" $ do
            renderJValue (JArray []) `shouldBe` "[]"
        
        it "renderiza arrays com elementos" $ do
            renderJValue (JArray [JNumber 1, JNumber 2, JNumber 3]) 
                `shouldBe` "[1.0, 2.0, 3.0]"
        
        it "renderiza objetos vazios" $ do
            renderJValue (JObject []) `shouldBe` "{}"
        
        it "renderiza objetos simples" $ do
            renderJValue (JObject [("nome", JString "João"), ("idade", JNumber 25)])
                `shouldBe` "{\"nome\": \"João\", \"idade\": 25.0}"
        
        it "escapa caracteres especiais em strings" $ do
            renderJValue (JString "linha1\nlinha2") `shouldContain` "\\n"
            renderJValue (JString "tab\there") `shouldContain` "\\t"
            renderJValue (JString "quote\"here") `shouldContain` "\\\""
