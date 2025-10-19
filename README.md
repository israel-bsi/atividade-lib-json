# Biblioteca JSON em Haskell

## Informações do Grupo

**Integrantes:**
- Israel Barbosa Silva - RA: 2020018383
- Helton Alves Sá - RA: 2019014022
- Amanda Cristina Roxo Felix - RA: 2022030879

**Repositório GitHub:** [atividade-lib-json](https://github.com/israel-bsi/atividade-lib-json)

## Sobre o Projeto

Este projeto implementa uma biblioteca em Haskell para representação e manipulação de dados no formato JSON (JavaScript Object Notation). O trabalho foi desenvolvido como parte da disciplina de Programação Funcional, com base no Capítulo 5 do livro **Real World Haskell**.

### Objetivos

- Utilizar **Tipos de Dados Algébricos (ADTs)** para representar dados JSON
- Demonstrar a **separação clara entre código puro e impuro**
- Implementar funções de serialização (renderização) de JSON
- Criar funções acessoras seguras usando o tipo `Maybe`

## Estrutura do Projeto

```
lib-json/
├── src/
│   └── SimpleJSON.hs      # Módulo principal da biblioteca
├── app/
│   └── Main.hs            # Aplicação de demonstração
├── test/
│   └── Spec.hs            # Testes (opcional)
├── package.yaml           # Configuração do Stack
├── stack.yaml
├── lib-json.cabal
└── README.md
```

## Funcionalidades Implementadas

### 1. Tipo de Dados Algébrico `JValue`

Representa todos os tipos de valores JSON:

```haskell
data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String, JValue)]
            | JArray [JValue]
```

### 2. Funções Acessoras Seguras (Pure Functions)

Todas retornam `Maybe` para evitar erros em tempo de execução:

- `getString :: JValue -> Maybe String`
- `getNumber :: JValue -> Maybe Double`
- `getBool :: JValue -> Maybe Bool`
- `getObject :: JValue -> Maybe [(String, JValue)]`
- `getArray :: JValue -> Maybe [JValue]`
- `isNull :: JValue -> Bool`

### 3. Serialização

#### Função Pura (Pure)
```haskell
renderJValue :: JValue -> String
```
Converte um `JValue` para sua representação em formato JSON (String). Esta função é **pura** e não realiza operações de entrada/saída.

Características:
- Escapa corretamente caracteres especiais em strings
- Formata objetos e arrays com pontuação adequada
- Gera JSON válido conforme especificação

#### Função Impura (I/O)
```haskell
putJValue :: JValue -> IO ()
```
Imprime um `JValue` no terminal. Esta função realiza **operações de E/S** e utiliza internamente a função pura `renderJValue`.

## Como Compilar e Executar

### Pré-requisitos

- GHC (Glasgow Haskell Compiler)
- Stack

### Compilação

```bash
# Compilar o projeto
stack build

# Executar o programa de demonstração
stack run

# Executar os testes (se implementados)
stack test
```

### Usando o GHCi (Interpretador Interativo)

```bash
stack ghci
```

Exemplos de uso no GHCi:

```haskell
-- Criar um objeto JSON
let pessoa = JObject [("nome", JString "João"), ("idade", JNumber 25)]

-- Renderizar para string
renderJValue pessoa
-- Saída: "{\"nome\": \"João\", \"idade\": 25.0}"

-- Imprimir no terminal
putJValue pessoa

-- Usar funções acessoras
getString (JString "teste")  -- Just "teste"
getNumber (JString "teste")  -- Nothing
```

## Exemplos de Uso

### Valores Simples

```haskell
-- String
JString "Hello, World!"

-- Número
JNumber 42.5

-- Booleano
JBool True

-- Null
JNull
```

### Arrays

```haskell
JArray [JNumber 1, JNumber 2, JNumber 3, JBool True]
```

### Objetos

```haskell
JObject 
    [ ("nome", JString "Maria")
    , ("idade", JNumber 30)
    , ("ativo", JBool True)
    ]
```

### Estruturas Aninhadas

```haskell
JObject
    [ ("pessoa", JObject 
        [ ("nome", JString "Carlos")
        , ("endereco", JObject
            [ ("rua", JString "Rua A")
            , ("numero", JNumber 100)
            ])
        ])
    , ("hobbies", JArray [JString "leitura", JString "música"])
    ]
```

## Conceitos de Programação Funcional Aplicados

### 1. Tipos de Dados Algébricos (ADTs)
O tipo `JValue` é um ADT que usa múltiplos construtores para representar diferentes tipos de valores JSON de forma type-safe.

### 2. Pattern Matching
As funções acessoras usam pattern matching para extrair valores de forma segura:

```haskell
getString (JString s) = Just s
getString _           = Nothing
```

### 3. Separação Puro/Impuro
- **Código Puro**: `renderJValue`, funções acessoras (não têm efeitos colaterais)
- **Código Impuro**: `putJValue` (realiza E/S)

### 4. Uso de Maybe
Representa computações que podem falhar, evitando exceções e tornando o código mais seguro.

### 5. Recursão
Usada para processar estruturas aninhadas (objetos e arrays).

## Referências

- [Real World Haskell - Chapter 5](http://book.realworldhaskell.org/read/writing-a-library-working-with-json-data.html)

**Disciplina:** Programação Funcional  
**Instituição:** UFMA  
**Ano:** 2025
