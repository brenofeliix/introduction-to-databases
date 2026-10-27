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

> Iuri Bravo Pereira Resmini.

**Nome escolhido para o banco de dados:**

```
gerenciamento_salao_beleza
```

---

# 2. Tema do banco de dados

Escolha um domínio para o banco de dados que será desenvolvido durante toda a atividade.

O tema é livre, desde que permita a criação de um banco relacional com múltiplas tabelas e relacionamentos coerentes.

### Tema escolhido

> Gerenciamento de salão de beleza.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> Esse sistema consite em resolver problemas de agendamentos, financeiro e estoque de salões de beleza. O sistema ficará disponível para colabores, tais como: Cabeleireiro(@), manicure, gerente, caixa, financeiro, entre outros. Para gerenciar o salão de beleza será necessário o armazenamento de tabelas com informações de Colaboradores, Clientes, Preços, Estoque, Financeiro. E operações de agendamento de cliente, registros de produtos, vendas do estoque, registros de clientes e colaboradores e atualização de preço.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> Gerenciamento de todo salão de beleza.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Registro e alteração de cliente; 
2. Agendamento de cliente;   
3. Registro e alteração de colaboradores;
4. Registro e alteração de estoque.

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
| 1 |Clientes|Tabela|
| 2 |Colaboradores|Tabela|
| 3 |Produtos|Tabela|
| 4 |Agendamentos|Tabela|
| 5 |Serviços|Tabela|

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```text
Clientes
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|CPF|IDENTIFICAÇÃO|STRING|SIM|
|ID_CLIENTES|IDENTIFICAÇÃO|STRING|SIM|
|TELEFONE|CONTATO|STRING|SIM|
|NOME|IDENTIFICAÇÃO|STRING|SIM|
|  |  |  |  |

## Entidade 2

**Nome da entidade:**

```text
Colaboradores
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|CPF|IDENTIFICAÇÃO|STRING|SIM|
|ENDEREÇO|LOCAÇÃO|STRING|SIM|
|ID_COLABORADOR|CÓDIGO DE ACESSO|INT|SIM|
|CHAVE_PIX|PAGAMENTOS|STRING|SIM|
|  |  |  |  |

## Entidade 3

**Nome da entidade:**

```text
Produtos
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|PREÇO_DE_COMPRA|VALOR|FLOAT|SIM|
|PREÇO_DE_VENDA|VALOR|FLOAT|SIM|
|DATA_COMPRAS|DATA DE COMPRAS|DATETIME|SIM|
|DATA_VENDAS|DATA DE VENDAS|DATETIME|SIM|
|ID_PRODUTO|IDENTIFICAÇÃO DO PRODUTO|STRING|SIM|

## Entidade 4

**Nome da entidade:**

```text
Agendamentos
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|DATA_AGENDAMENTO|DATA DO AGENDAMENTO|DATETIME|SIM|
||  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
|SERVIÇOS|ID_SERVIÇOS|
|  |  |
|  |  |

---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
|CLIENTE|CPF|IDENTIFICAÇÃO|
|COLABORADOR|ID_COLABORADOR|IDENTIFICAÇÃO|
|PRODUTOS|ID_PRODUTO|IDENTIFICAÇÃO|
|AGENDAMENTOS|DATA_AGENDAMENTO|IDENTIFICAÇÃO|
|SERVIÇOS|ID_SERVIÇOS|IDENTIFICAÇÃO|

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
|CLIENTES|REALIZA|AGENDAMENTOS
|CLIENTES|UTILIZA|SERVIÇOS|
|CLIENTES|COMPRAM|PRODUTOS|
|COLABORADORES|REGISTRAM|PRODUTOS|
|COLABORADORES|REGISTRAM|CLIENTES|

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
|CLIENTES/PRODUTOS|1:N|CLIENTE PODE COMPRAR VÁRIOS PRODUTOS
|CLIENTES/AGENDAMENTOS|1:N|CLIENTE PODE AGENDAR VÁRIAS VEZES
|COLABORADORES/PRODUTOS|N:N|COLABORADOR PODE REGISTRAR VÁRIOS PRODUTOS|
|COLABORADORES/CLIENTES|N:N|COLABORADOR PODE REGISTRAR VÁRIOS PRODUTOS|

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
|AGENDAMENTOS|CPF|CLIENTES|
|PRODUTOS|CPF|CLIENTES|
|CLIENTES|CPF|COLABORADORES|
||  |  |

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
|CLIENTES|CPF|PRIMARY KEY/UNIQUE|IDENTIFICAÇÃO|
|COLABORADORES|ID_COLABORADOR|PRIMARY KEY/AUTO_INCREMENT/UNIQUE|IDENTIFICAÇÃO GERADA PELO SISTEMA|
|PRODUTOS|ID_PRODUTO|PRIMARY KEY/AUTO_INCREMENT/UNIQUE|IDENTIFICAÇÃO GERADA PELO SISTEMA| 
|AGENDAMENTOS|DATA_AGENDAMENTO|PRIMARY KEY|IDENTIFICAÇÃO|
|SERVIÇOS|ID_SERVIÇOS|PRIMARY KEY/UNIQUE|IDENTIFICAÇÃO|


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

1. Um cliente não pode possuir dois cadastros com o mesmo CPF.
2. Um produto não pode possuir preço negativo.
3. Um pedido deve estar associado a um cliente existente.
4. Um colaborador deve ser registrado com apenas um identificador.
5. Um agendamento só pode ser feito para cliente existente.

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
CLIENTE
├── id_cliente
├── NOME
└── CPF (PK)
└── TELEFONE

AGENDAMENTO
├── DATA_AGENDAMENTO (PK)
├── CPF (FK)
└── ID_SERVIÇOS

CLIENTE 1 ───── N AGENDAMENTO

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. CLIENTES REGISTRADOS 
2. COLABORADORES REGISTRADOS
3. PRODUTOS REGISTRADOS
4. DATAS DE AGENDAMENTOS PREENCHIDAS

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

1. Quais clientes estão cadastrados? 
2. Quais produtos tem maior lucro?
3. Quais agendamentos diários?
4. Quais produtos mais está sendo vendidos?
5. Quantos clientes ativos tem registrados?

---

# 17. Decisões e dúvidas pendentes

- 
- 
- 

Caso não existam dúvidas:

> Nenhuma dúvida pendente nesta Sprint.

---

# 18. Checklist da Sprint 1/5

- [V] identifiquei o aluno responsável;
- [V] defini o tema do banco de dados;
- [V] descrevi o sistema;
- [V] defini o objetivo do banco;
- [V] defini o escopo inicial;
- [V] identifiquei pelo menos 4 entidades;
- [V] planejei os principais atributos;
- [V] defini as chaves primárias previstas;
- [V] identifiquei os relacionamentos;
- [V] defini as cardinalidades iniciais;
- [V] identifiquei possíveis chaves estrangeiras;
- [V] planejei restrições de integridade;
- [V] defini pelo menos 5 regras de negócio;
- [V] fiz um esboço da estrutura do banco;
- [V] defini os tipos de dados que futuramente serão cadastrados;
- [V] defini pelo menos 5 perguntas que o banco deverá responder;
- [ ] registrei dúvidas ou decisões pendentes;
- [V] revisei o arquivo antes de finalizar.

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
