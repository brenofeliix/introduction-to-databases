# SPRINT 1/5 — Planejamento do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados  
**Data:** 31/08/2026  
**Modalidade:** Atividade individual  

---

# Objetivo da Sprint 1/5

Nesta primeira etapa, cada aluno deverá **planejar individualmente um banco de dados completo**, que será desenvolvido de forma incremental ao longo das cinco Sprints.

O banco escolhido nesta Sprint será o mesmo utilizado nas próximas etapas da atividade.

Ao final da semana, cada aluno deverá possuir um banco de dados funcional contendo:

- estrutura de tabelas;
- chaves primárias;
- chaves estrangeiras;
- restrições de integridade;
- dados cadastrados;
- operações de inserção, alteração e exclusão;
- consultas SQL;
- funções de agregação;
- agrupamentos;
- validação e documentação final.

Nesta Sprint 1/5, o foco é exclusivamente o **planejamento do banco de dados**.

> **Importante:** ainda não é necessário implementar o banco em SQL. A implementação começará na Sprint 2/5.

---

# 1. Identificação do aluno

**Nome completo:**

> Mariano Lino da Silva Neto.

**Nome escolhido para o banco de dados: BD_Conveniencia**

```text

```
---

# 2. Tema do banco de dados

Escolha um domínio para o banco de dados que será desenvolvido durante toda a atividade.

O tema é livre, desde que permita a criação de um banco relacional com múltiplas tabelas e relacionamentos coerentes.

Alguns exemplos:

- sistema acadêmico;
- biblioteca;
- clínica;
- loja;
- restaurante;
- academia;
- hotel;
- oficina;
- locadora;
- e-commerce;
- sistema de eventos;
- sistema de transporte;
- imobiliária;
- pet shop;
- escola;
- campeonato esportivo;
- outro domínio de interesse do aluno.

### Tema escolhido

> Vendas e Produtos (Loja de Conveniência).
---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> O Módulo de Produtos atua como o catalogo central da loja de conveniência. Ele vai ser responsável por armazenar todas as informações dos itens que a loja vende, desde a identificação e a categorização até o preço de venda e a quantidade disponível. 
---

# 4. Objetivo do banco de dados

### Objetivo

> Recriar num banco de dados como funciona o controle de estoque de uma pequena loja de conveniência, pensei nessa ideia vendo os vídeos de Simulador de mercado do Roblox.
---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar e Classificar produtor por categorias.
3. Manter um registro das empresas fornecedoras de cada mercadoria.
4. Controlar a quantidade de produtos disponíveis no estoque.
5. Regstrar as vendas realizadas no caixa(Data, Hora e Valor total.
6. Armazenar Exatamente quais produots e quantas unidades sairam de cada venda(nota Fiscal)

### Objetivo

# 6. Identificação das entidades

Identifique as principais entidades necessárias para representar o sistema.

Uma entidade representa algo sobre o qual o banco precisa armazenar informações.

Exemplos:

```text
Aluno
Curso
Matrícula
Professor
Disciplina
```

ou:

```text
Cliente
Produto
Pedido
Item_Pedido
Pagamento
```

### Entidades do seu banco

| Nº | Entidade | O que representa? |
|---:|---|---|
| 1 | Categoria  | Bebidas, Doces e outras coisas |
| 2 | Produto | Coca Cola, basicamente os produtos que vão conter o ID e o codigo de barras |
| 3 | Venda | que vai garantir a parte da nota fiscal |
| 4 | item_venda | lista de tudo oq a gente vendeu |
| 5 |  |  |
| 6 |  |  |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade: Categoria**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_categoria | identificador unico numerico | INT | Sim |
| nome_categoria | descrição | VARCHAR(50) | Sim |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

## Entidade 2

**Nome da entidade: Produto**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_produto | identificador unico do sistema | INT | Sim |
| id_categoria | referencia á categoria do item | INT | Sim |
| codigo_barras | codigo lido pelo scanner do caixa | VARCHAR(50) | Sim |
| nome_produto | descricao do item para o cliente | VARCHAR(100) | Sim |
| preco_venda | o valor que será cobrado | DECIMAL(10,2) | Sim |
| quantidade_estoque |quantidade atual nas prateleiras | INT | SIM |
## Entidade 3

**Nome da entidade: Venda**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_venda | identificador da nota fiscal | INT | Sim |
| data_venda | Dia e hora em que a compra ocorreu | DATETIME | Sim |
| valor_total | Soma final cobrada do cliente | DECIMAL(10,2) | Sim |
|  |  |  |  |
|  |  |  |  |

## Entidade 4

**Nome da entidade: Item_Venda**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_venda | referencia a qual venda pertence | INT | Sim |
| id_produto | referencia a qual produto saiu | INT | Sim |
| quantidade | Quantas unidades foram levadas | INT | Sim |
|  |  |  |  |
|  |  |  |  |

## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
|  |  |
|  |  |
|  |  |

---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| Categoria | id_categoria | valor unico inteiro e imutavel que vai ser gerenciado pelo sistema | 
| Produto | id_produto | vamos usar ele pra não precisar usar o codigo de barras visto que ele não pode ser afetado pelo fabricante | 
| Venda | id_venda | identifica unicamente cada cupom gerado no caixa | 
| Item_Venda | id_venda, id_produto | Chave composta. Garante que o mesmo produto não se repita em linhas separadas no mesmo cupom | 

Considere:

- o valor identifica cada registro de forma única?
- o valor poderá se repetir?
- será utilizado um identificador numérico?
- será necessário `AUTO_INCREMENT`?

---

# 9. Relacionamentos entre as entidades

Identifique como as entidades se relacionam.

### Exemplo

```text
Cliente realiza Pedido
Pedido possui Item_Pedido
Produto aparece em Item_Pedido
```

### Relacionamentos planejados

| Entidade A | Relacionamento | Entidade B |
|---|---|---|
| Categoria | possui | produto |
| Venda | contem | item_venda |
| Produto | aparece em | item_Venda |
|  |  |  |
|  |  |  |

---

# 10. Cardinalidade inicial

Utilize:

```text
1:1  → um para um
1:N  → um para muitos
N:N  → muitos para muitos
```

| Relacionamento | Cardinalidade prevista | Justificativa |
|---|---|---|
| Categoria/Produto | 1:N | uma categoria pode ter varios produtos mas um produto só pertence a uma categoria |
| Venda/Item_venda | 1:N | Na mesma venda podemos ter diferentes itens no carrinho |
| Produto/item_venda | 1:N | o mesmo produto pode estar sendo vendido em diferentes carrinhos |
|  |  |  |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Produto | id_categoria | Categoria |
| item_venda | id_venda | Venda |
| item_venda | id_produto | Produto |
|  |  |  |

> As `FOREIGN KEY` serão implementadas posteriormente. Nesta Sprint, apenas planeje os relacionamentos.

---

# 12. Restrições de integridade previstas

Podem ser consideradas:

```sql
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
DEFAULT
AUTO_INCREMENT
```

| Tabela | Atributo | Restrição prevista | Motivo |
|---|---|---|---|
| Produto | codigo_barras | UNIQUE | não vai permitir que dois produtos diferentes tenham o mesmo codigo |
| Produto | preco_venda | CHECK(>=0) | Vai garantir que a gente não tenha um valor com numero negativo |
| Produto | quantidade_estoque | CHECK(>=0) | Evitar que alguém compre alguma coisa que não tenha no estoque |
| Venda | data_venda | DEFAULT | isso vai manter a hora do caixa guardado automaticamente |
|  |  |  |  |

---

# 13. Regras de negócio

Defina pelo menos **5 regras de negócio** para o sistema.

### Exemplos

```text
Um cliente não pode possuir dois cadastros com o mesmo CPF.
Um pedido deve estar associado a um cliente existente.
Um produto não pode possuir preço negativo.
Uma matrícula deve estar associada a um aluno e a uma disciplina.
Um empréstimo deve possuir uma data de realização.
```

### Regras do seu banco

1. Um produto não pode ser cadastrado com preço de venda negativo.
2. Dois Produtos diferentes não podem possuir o mesmo codigo de barras.
3. A quantidade em estoque de um produto não pode ser negativa.
4. Todo produto cadastrado deve pertencer obrigatoriamente a uma categoria valida.
5. Uma categoria não pode ser excluida do sistema se ja possuir produtos vinculados a ela.

---

# 14. Esboço da estrutura do banco

Faça uma representação textual inicial das tabelas e relacionamentos.

### Exemplo

```text
CLIENTE
├── id_cliente (PK)
├── nome
└── email

PEDIDO
├── id_pedido (PK)
├── id_cliente (FK)
└── data_pedido

CLIENTE 1 ───── N PEDIDO
```

### Esboço do seu banco

```text
CATEGORIA
|-- id_categoria(PK)
|--- nome_categoria

PRODUTO
|-- id_produto(PK)
|-- id_categoria(FK)
|-- codigo_barras
|-- nome_produto
|-- preco_venda
|-- quantidade_estoque

ITEM_VENDA
|-- id_venda (PK/FK)
|-- id_produto(PK/FK)
|-- quantidade

CATEGORIA 1 ----- N PRODUTO
VENDA 1 ---------- N ITEM_VENDA
PRODUTO 1 --------- N ITEM_VENDA
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Categorias da loja
2. Produtos com Preços e codigos de barras validos
3. Simulações de registros de vendas realizadas
4. itens associando os produtos comprados a cada uma dessas vendas

---

# 16. Perguntas que o banco deverá ser capaz de responder

Defina pelo menos **5 perguntas** que futuramente deverão ser respondidas por consultas SQL.

### Exemplos

```text
Quais clientes estão cadastrados?
Quais produtos custam mais de R$ 100?
Quantos pedidos foram realizados por cliente?
Qual é o valor médio dos produtos?
Quais categorias possuem mais de 5 produtos?
```

### Perguntas do seu projeto

1. Quais categorias estão cadastradas no sistema?
2. Quais produtos estão com a quantidade de estoque zerada no momento?
3. Quais produtos custam mais de R$ 10,00?
4. Quais produtos pertecem a categoria "bebidas"?
5. Qual foi o valor total arrecadado em uma determinada venda

---

# 17. Decisões e dúvidas pendentes

- Nenhuma dúvida pendente nesta Sprint.
- 
- 

Caso não existam dúvidas:

> Nenhuma dúvida pendente nesta Sprint.

---

# 18. Checklist da Sprint 1/5

- [X] identifiquei o aluno responsável;
- [X] defini o tema do banco de dados;
- [X] descrevi o sistema;
- [X] defini o objetivo do banco;
- [X] defini o escopo inicial;
- [X] identifiquei pelo menos 4 entidades;
- [X] planejei os principais atributos;
- [X] defini as chaves primárias previstas;
- [X] identifiquei os relacionamentos;
- [X] defini as cardinalidades iniciais;
- [X] identifiquei possíveis chaves estrangeiras;
- [X] planejei restrições de integridade;
- [X] defini pelo menos 5 regras de negócio;
- [X] fiz um esboço da estrutura do banco;
- [X] defini os tipos de dados que futuramente serão cadastrados;
- [X] defini pelo menos 5 perguntas que o banco deverá responder;
- [X] registrei dúvidas ou decisões pendentes;
- [X] revisei o arquivo antes de finalizar.

---

# Entrega da Sprint 1/5

O arquivo desta etapa deverá ser salvo com o nome:

```text
SPRINT1-5.md
```

O aluno deverá manter este arquivo, pois ele será utilizado como referência para as próximas Sprints.

A evolução será:

```text
SPRINT1-5.md
    ↓
Planejamento do banco
    ↓
SPRINT2-5.md
    ↓
Criação da estrutura com DDL
    ↓
SPRINT3-5.md
    ↓
Inserção e manipulação de dados
    ↓
SPRINT4-5.md
    ↓
Consultas SQL
    ↓
SPRINT5-5.md
    ↓
Validação e entrega do banco completo
```

---

# Regras de Git/GitHub

A atividade é **individual**.

Cada aluno deverá manter seu próprio histórico de desenvolvimento durante as cinco Sprints.

## Branch

O aluno deverá trabalhar em uma branch própria durante toda a atividade.

A branch não deverá ser recriada a cada Sprint.

Utilize a convenção definida pelo professor para identificação individual.

> A convenção definitiva do nome da branch deverá ser compatível com a validação automática do repositório.

## Commit

Cada Sprint deverá gerar pelo menos um commit próprio.

Mensagem sugerida para hoje:

```text
Conclui Sprint 1 de 5 - planejamento do banco
```

Nas próximas etapas:

```text
Conclui Sprint 2 de 5 - estrutura DDL
Conclui Sprint 3 de 5 - operações DML
Conclui Sprint 4 de 5 - consultas SQL
Conclui Sprint 5 de 5 - validação final
```

## Pull Request

**Não abrir o Pull Request final nesta Sprint.**

O Pull Request será realizado somente após a conclusão da Sprint 5/5.

```text
SPRINT1-5.md → commit
SPRINT2-5.md → commit
SPRINT3-5.md → commit
SPRINT4-5.md → commit
SPRINT5-5.md → commit
                         ↓
                  Pull Request final
                         ↓
                        main
```

---

# Critério de conclusão da Sprint 1/5

A Sprint será considerada concluída quando o aluno apresentar um planejamento suficientemente detalhado para permitir que, na próxima etapa, consiga transformar sua proposta em um banco de dados relacional utilizando SQL.

Não basta informar apenas o tema.

O planejamento deverá demonstrar:

- quais tabelas existirão;
- quais informações serão armazenadas;
- como as tabelas se relacionarão;
- quais regras deverão ser respeitadas;
- quais consultas o banco deverá permitir ao final da atividade.

---

# Próxima etapa

Na **Sprint 2/5**, o planejamento será transformado em uma implementação utilizando comandos DDL.

Serão trabalhados:

```sql
CREATE DATABASE
CREATE TABLE
ALTER TABLE
DROP TABLE
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
DEFAULT
```

> **Não implemente a Sprint 2/5 neste arquivo.**
