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

> Gabriel Sakaizawa Campos

**Nome escolhido para o banco de dados:**

```db_restaurante_sabor

```

---

# 2. Tema do banco de dados

### Tema escolhido

> Sistema de gerenciamento de restaurante.

---

# 3. Descrição do sistema

### Descrição

O sistema representa a gestão do atendimento de um restaurante: controle de clientes, mesas, funcionários, produtos do cardápio e os pedidos realizados. Ele seria utilizado por garçons, atendentes e pela gerência do restaurante para registrar e acompanhar o fluxo de pedidos do início ao fim.

As informações principais a serem armazenadas são: dados dos clientes, dados dos funcionários, as mesas disponíveis, os produtos do cardápio (com preço) e os pedidos feitos, incluindo quais produtos e quantidades compõem cada pedido.

O sistema deverá permitir: cadastrar clientes, funcionários, mesas e produtos; registrar pedidos vinculados a um cliente, uma mesa e um funcionário responsável; registrar os itens de cada pedido; atualizar o status dos pedidos; e consultar informações como faturamento, produtos mais vendidos e desempenho dos funcionários.

---

# 4. Objetivo do banco de dados

### Objetivo

Organizar de forma estruturada o atendimento do restaurante, garantindo integridade nos dados de clientes, funcionários, mesas e pedidos, e possibilitando consultas gerenciais sobre vendas, produtos e atendimento.

---

# 5. Escopo inicial

### O banco deverá permitir:

1. Cadastro de clientes.
2. Cadastro de funcionários.
3. Cadastro de mesas do salão.
4. Cadastro de produtos do cardápio.
5. Registro de pedidos e dos itens que compõem cada pedido.

---

# 6. Identificação das entidades

### Entidades do seu banco

| Nº | Entidade | O que representa? |
|---:|---|---|
| 1 | Cliente | Pessoa que realiza o pedido no restaurante |
| 2 | Funcionário | Garçom/atendente responsável por atender o pedido |
| 3 | Mesa | Mesa do salão onde o cliente está sentado |
| 4 | Produto | Item do cardápio (prato, bebida etc.) |
| 5 | Pedido | Pedido feito por um cliente, em uma mesa, atendido por um funcionário |
| 6 | Item_Pedido | Cada produto (e quantidade) que compõe um pedido |

> Total: 6 entidades — acima do mínimo de 4 pedido na atividade.

---

# 7. Planejamento dos atributos

## Entidade 1

**Nome da entidade:**

```text
Cliente
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_cliente | Identificador único do cliente | INT (AUTO_INCREMENT) | Sim |
| nome | Nome do cliente | VARCHAR(100) | Sim |
| cpf | CPF do cliente | VARCHAR(11) | Sim |
| telefone | Telefone de contato | VARCHAR(15) | Não |
| data_cadastro | Data em que o cliente foi cadastrado | DATE | Sim |

## Entidade 2

**Nome da entidade:**

```text
Funcionário
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_funcionario | Identificador único do funcionário | INT (AUTO_INCREMENT) | Sim |
| nome | Nome do funcionário | VARCHAR(100) | Sim |
| cargo | Função (garçom, gerente etc.) | VARCHAR(50) | Sim |
| email | E-mail do funcionário | VARCHAR(100) | Sim |
| ativo | Se o funcionário está ativo no sistema | BOOLEAN | Sim |

## Entidade 3

**Nome da entidade:**

```text
Mesa
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_mesa | Identificador único da mesa | INT (AUTO_INCREMENT) | Sim |
| numero | Número da mesa no salão | INT | Sim |
| capacidade | Quantidade de pessoas que a mesa comporta | INT | Sim |
| status | Situação da mesa (livre/ocupada) | VARCHAR(20) | Sim |

## Entidade 4

**Nome da entidade:**

```text
Produto
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_produto | Identificador único do produto | INT (AUTO_INCREMENT) | Sim |
| nome | Nome do produto (prato/bebida) | VARCHAR(100) | Sim |
| categoria | Categoria do produto (entrada, prato principal, bebida etc.) | VARCHAR(50) | Sim |
| preco | Preço unitário do produto | DECIMAL(10,2) | Sim |

## Outras entidades

| Entidade | Principais atributos |
|---|---|
| Pedido | id_pedido (PK), id_cliente (FK), id_mesa (FK), id_funcionario (FK), data_pedido, status |
| Item_Pedido | id_item_pedido (PK), id_pedido (FK), id_produto (FK), quantidade, preco_unitario |

---

# 8. Chaves primárias

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| Cliente | id_cliente | Identificador numérico único, não se repete, com AUTO_INCREMENT |
| Funcionário | id_funcionario | Identificador numérico único, não se repete, com AUTO_INCREMENT |
| Mesa | id_mesa | Identificador numérico único, independente do número físico da mesa |
| Produto | id_produto | Identificador numérico único, evita ambiguidade entre produtos de mesmo nome |
| Pedido | id_pedido | Identificador numérico único para cada pedido realizado |
| Item_Pedido | id_item_pedido | Identificador numérico único para cada linha de item dentro de um pedido |

---

# 9. Relacionamentos entre as entidades

### Relacionamentos planejados

| Entidade A | Relacionamento | Entidade B |
|---|---|---|
| Cliente | realiza | Pedido |
| Funcionário | atende | Pedido |
| Mesa | recebe | Pedido |
| Pedido | possui | Item_Pedido |
| Produto | aparece em | Item_Pedido |

---

# 10. Cardinalidade inicial

| Relacionamento | Cardinalidade prevista | Justificativa |
|---|---|---|
| Cliente → Pedido | 1:N | Um cliente pode fazer vários pedidos, mas cada pedido pertence a um único cliente |
| Funcionário → Pedido | 1:N | Um funcionário pode atender vários pedidos, mas cada pedido tem um único funcionário responsável |
| Mesa → Pedido | 1:N | Uma mesa pode receber vários pedidos ao longo do tempo, mas cada pedido ocorre em uma única mesa |
| Pedido → Item_Pedido | 1:N | Um pedido pode ter vários itens, mas cada item pertence a um único pedido |
| Produto → Item_Pedido | 1:N | Um produto pode aparecer em vários itens de pedidos diferentes, mas cada item referencia um único produto |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Pedido | id_cliente | Cliente |
| Pedido | id_mesa | Mesa |
| Pedido | id_funcionario | Funcionário |
| Item_Pedido | id_pedido | Pedido |
| Item_Pedido | id_produto | Produto |

> As `FOREIGN KEY` serão implementadas posteriormente. Nesta Sprint, apenas planeje os relacionamentos.

---

# 12. Restrições de integridade previstas

| Tabela | Atributo | Restrição prevista | Motivo |
|---|---|---|---|
| Cliente | id_cliente | PRIMARY KEY, AUTO_INCREMENT | Identificação única de cada cliente |
| Cliente | cpf | UNIQUE, NOT NULL | Evitar cadastro duplicado do mesmo cliente |
| Funcionário | email | UNIQUE, NOT NULL | Cada funcionário deve ter um e-mail próprio |
| Produto | preco | NOT NULL, DEFAULT 0.00 | Todo produto precisa ter um preço definido |
| Mesa | status | DEFAULT 'livre' | Toda mesa nasce disponível até ser ocupada |
| Pedido | id_cliente, id_mesa, id_funcionario | FOREIGN KEY, NOT NULL | Garantir que todo pedido esteja vinculado a registros existentes |

---

# 13. Regras de negócio

### Regras do seu banco

1. Um cliente não pode possuir dois cadastros com o mesmo CPF.
2. Um pedido deve estar associado a um cliente, uma mesa e um funcionário existentes.
3. Um produto não pode possuir preço negativo.
4. Um item de pedido deve referenciar um pedido e um produto válidos.
5. Um funcionário inativo não pode ser vinculado a novos pedidos.
6. Uma mesa não pode possuir dois pedidos "em aberto" ao mesmo tempo.

---

# 14. Esboço da estrutura do banco

### Esboço do seu banco

```text
CLIENTE
├── id_cliente (PK)
├── nome
├── cpf
├── telefone
└── data_cadastro

FUNCIONÁRIO
├── id_funcionario (PK)
├── nome
├── cargo
├── email
└── ativo

MESA
├── id_mesa (PK)
├── numero
├── capacidade
└── status

PRODUTO
├── id_produto (PK)
├── nome
├── categoria
└── preco

PEDIDO
├── id_pedido (PK)
├── id_cliente (FK)
├── id_mesa (FK)
├── id_funcionario (FK)
├── data_pedido
└── status

ITEM_PEDIDO
├── id_item_pedido (PK)
├── id_pedido (FK)
├── id_produto (FK)
├── quantidade
└── preco_unitario

CLIENTE 1 ───── N PEDIDO
FUNCIONÁRIO 1 ───── N PEDIDO
MESA 1 ───── N PEDIDO
PEDIDO 1 ───── N ITEM_PEDIDO
PRODUTO 1 ───── N ITEM_PEDIDO
```

---

# 15. Dados que futuramente serão inseridos

1. Clientes cadastrados com nome, CPF e telefone.
2. Funcionários com cargo e status (ativo/inativo).
3. Mesas do salão com número e capacidade.
4. Produtos do cardápio com categoria e preço, e os pedidos realizados com seus itens.

---

# 16. Perguntas que o banco deverá ser capaz de responder

### Perguntas do seu projeto

1. Quais clientes fizeram mais pedidos?
2. Quais são os produtos mais vendidos?
3. Qual o faturamento total por mês?
4. Quantos pedidos cada funcionário atendeu?
5. Qual é o ticket médio por mesa?
6. Quais mesas têm maior rotatividade de pedidos?

---

# 17. Decisões e dúvidas pendentes

- Definir se, em Sprints futuras, será adicionada uma tabela de Pagamento (forma de pagamento, valor pago) — não incluída no escopo inicial.
- Confirmar o nome final do banco de dados (`db_restaurante_sabor`) antes da Sprint 2/5.

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