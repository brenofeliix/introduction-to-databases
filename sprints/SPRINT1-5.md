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

> Leslie Bruna pires dos Santos

**Nome escolhido para o banco de dados:**

```text

```db_loja

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

> loja

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

>O meu sistema vai abordar controle de venda e estoque, que vai ser utilizado pelos funcionários como operadores de caixa e a gerente da loja. Principais informações que vão ser armazenadas os dados básicos dos clientes, produtos disponíveis com preços e quantidade no estoque e o registro das vendas realizadas. O sistema vai permitir cadastrar clientes e produtos, registrar as vendas realizadas no caixa.
---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

>Objetivo é substituir as anotações ou ate mesmo planilhas por um banco de dados simples onde podemos ter acesso, a cadastro de clientes, controle de estoque e histórico de vendas.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. 	Cadastro de novos clientes no banco de dados da loja.
2.	Ter acesso ao estoque, quantidade de produtos, rebaixa de preços.
3.	Registrar vendas vinculadas ao cliente e a data da compra.
4.	Pode ter acessa a cada nota de compra com detalhe dos produtos e quantidade e variação.
5.	Relatório do que foi vendido e verificar quais produtos tem menos quantidade


---

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
| 1 | cliente |pessoas cadastradas na loja  |
| 2 | produto | Mercadorias físicas disponíveis para venda. |
| 3 | pedido |registro de venda  |
| 4 | item_pedido| comprovante de compra que mostra cada produto especificado |
| 5 |  |  |
| 6 |  |  |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_cliente|	Identificador único numérico do cliente	|INT	|Sim|
|nome|	Nome completo do cliente|	VARCHAR	|Sim|
|cpf|	Documento de identificação|	VARCHAR	|Sim|
|telefone|	Número de telefone para contato|	VARCHAR	|Não|
|email|	Endereço de e-mail|	VARCHAR	|Não|


## Entidade 2

**Nome da entidade:**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_produto|	Identificador único numérico do produto	|INT	|Sim|
|Nome	|Nome ou descrição do produto|	VARCHAR|	Sim|
|Preço|	Preço atual de venda unitário ou preço produto peça|	DECIMAL|	Sim|
|quantidade_estoque|	Quantidade disponível no estoque|	INT|	Sim|

## Entidade 3

**Nome da entidade:**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_pedido|	Identificador único (número do cupom/venda)|	INT|	Sim|
|id_cliente|Referência de qual cliente fez a compra|	INT|	Sim|
|data_pedido|	Data e hora em que a venda foi registrada|	DATETIME|	Sim
| forma_pagamento |Com o o pedido foi pago (Dinheiro, Pix,Cartão)	|VARCHAR Sim|

## Entidade 4

**Nome da entidade:**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_item	|Identificador  do item vendido|	INT|	Sim|
|id_pedido|	Referência à venda |	INT|	Sim|
|id_produto	|Referência a qual produto foi comprado|	INT|	Sim|
|Quantidade|	Quantas unidades daquele produto saíram	|INT	|Sim|
|preco_unitario|	Valor cobrado pelo produto na hora da venda|	DECIMAL	|Sim|


## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
|  
---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---| 
|Cliente	|id_cliente|	Identificador numérico e sequencial único| (AUTO_INCREMENT)|
|Produto	|id_produto|	Identificador numérico e sequencial único| (AUTO_INCREMENT)|
|Pedido	|id_pedido|	Identificador numérico e sequencial único |(AUTO_INCREMENT)|
|Item_Pedido|	id_item	|Identificador numérico único para cada linha vendida| (AUTO_INCREMENT)|
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
| Cliente|	Realiza|	Pedido|
|Pedido	|Possui|	Item_Pedido|
|Produto|	aparece em|	Item_Pedido|

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
| Cliente x Pedido|	1:N (um para muitos)|	Um mesmo cliente pode fazer diversas compras na mesma loja varias vezes.|
|Pedido x Item_Pedido	|1:N (um para muitos)	|Em uma mesma compra, o cliente pode levar vários produtos diferentes.|
|Produto x Item_Pedido	|1:N (um para muitos)	|O mesmo produto pode ser vendido em vários pedidos diferentes ao longo do tempo.|

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
|  Pedido	|id_cliente|	Cliente (id_cliente)|
|Item_Pedido|	id_pedido|	Pedido (id_pedido)|
|Item_Pedido	|id_produto|	Produto (id_produto)|


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
| Cliente	| cpf	| UNIQUE| 	O sistema não pode aceitar o cadastro do mesmo CPF duas vezes.| 
| Produto| 	preco	| NOT NULL| 	Todo produto deve ter um preço de venda cadastrado.| 
| Pedido| 	data_pedido| 	DEFAULT| 	Se a data não for informada, o banco assumirá a data e hora atual.| 
| Pedido| 	id_cliente| 	FOREIGN KEY	| Uma venda só pode ser associada a um cliente que já existe no banco.| 
| Item_Pedido	| quantidade	| NOT NULL	| A quantidade de produtos vendidos na linha tem que ser informada.| 

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
1.	Um cliente não pode possuir dois cadastros com o mesmo CPF.
2.	O preço de um produto cadastrado nunca pode ser um valor negativo.
3.	Não pode existir um pedido "órfão", ou seja, sem estar vinculado a um cliente válido do banco.
4.	O valor do preco_unitario no Item_Pedido deve ser copiado do cadastro do produto na hora da venda, para que o valor da venda passada não mude caso o produto sofra reajuste futuramente.
5.	A quantidade vendida em um Item_Pedido deve ser obrigatoriamente maior que zero.

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
Escreva aqui a estrutura planejada.
```
├── id_cliente (PK)
├── nome
├── cpf
├── telefone
└── email

PRODUTO
├── id_produto (PK)
├── nome
├── preco
└── quantidade_estoque

PEDIDO
├── id_pedido (PK)
├── id_cliente (FK)
├── data_pedido
└── forma_pagamento

ITEM_PEDIDO
├── id_item (PK)
├── id_pedido (FK)
├── id_produto (FK)
├── quantidade
└── preco_unitario

Relacionamentos:
CLIENTE 1 ───── N PEDIDO
PEDIDO 1 ────── N ITEM_PEDIDO
PRODUTO 1 ───── N ITEM_PEDIDO

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1.	Cadastros de clientes da loja, informando nomes completos, CPFs e telefone de contato.
2.	Cadastros de mercadorias no estoque, com preço e as quantidades em loja.
3.	Cadastros de pedidos vendas que aconteceram no caixa, com datas e formas de pagamento diferentes.
4.	Cadastros dos itens das vendas.

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

1.	Perguntas do seu Quais são todos os clientes cadastrados no sistema da loja?
2.	Quais produtos estão com o estoque zerado (quantidade = 0)?
3.	Quais produtos custam mais de R$ 50,00?
4.	Quais foram todas as compras (pedidos) realizadas por um cliente específico?
5.	Qual é o histórico detalhado dos produtos levados no pedido de número 1?


---

# 17. Decisões e dúvidas pendentes

- 
- 
- 

Caso não existam dúvidas:

> Nenhuma dúvida pendente nesta Sprint.

---

# 18. Checklist da Sprint 1/5

- [x] identifiquei o aluno responsável;
- [x] defini o tema do banco de dados;
- [x] descrevi o sistema;
- [x] defini o objetivo do banco;
- [x] defini o escopo inicial;
- [x] identifiquei pelo menos 4 entidades;
- [x] planejei os principais atributos;
- [x] defini as chaves primárias previstas;
- [x] identifiquei os relacionamentos;
- [x] defini as cardinalidades iniciais;
- [x] identifiquei possíveis chaves estrangeiras;
- [x] planejei restrições de integridade;
- [x] defini pelo menos 5 regras de negócio;
- [x] fiz um esboço da estrutura do banco;
- [x] defini os tipos de dados que futuramente serão cadastrados;
- [x] defini pelo menos 5 perguntas que o banco deverá responder;
- [x] registrei dúvidas ou decisões pendentes;
- [x] revisei o arquivo antes de finalizar.

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
