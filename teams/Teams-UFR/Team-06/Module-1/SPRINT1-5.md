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

> Anna Beatriz Oliveira Moura

**Nome escolhido para o banco de dados:**

```text
Locação de Filmes

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

> Locadora

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> O sistema representa uma locadora de filmes, considerando um contexto anterior à popularização dos serviços de streaming. A locadora possui clientes, funcionários e um catálogo de filmes disponíveis para locação. Cada filme possui informações como título, ano de lançamento, avaliação, gênero e diretor. O sistema deverá permitir o cadastro e gerenciamento dos clientes, funcionários, filmes e gêneros, além do registro das locações realizadas. Dessa forma, será possível controlar quais filmes foram alugados, por quais clientes, qual funcionário realizou o atendimento e as informações relacionadas a cada locação.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> O principal objetivo do banco de dados é organizar e armazenar as informações de uma locadora de filmes, permitindo controlar o cadastro de clientes, funcionários, filmes e gêneros, além de registrar as locações realizadas. O banco deverá possibilitar a consulta e o gerenciamento dessas informações de forma estruturada, mantendo os relacionamentos entre os diferentes dados da locadora e garantindo a integridade das informações cadastradas.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar e armazenar informações dos clientes da locadora.
2. Cadastrar e armazenar informações dos funcionários responsáveis pelo atendimento.
3. Cadastrar filmes e suas principais informações, como título, ano, avaliação, diretor e gênero.
4. Registrar as locações realizadas pelos clientes e os funcionários responsáveis pelo atendimento.
5. Consultar informações sobre filmes, clientes, funcionários, gêneros e histórico de locações.

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
| 1 | Cliente | Pessoas cadastradas que podem realizar locações de filmes. |
| 2 | Funcionário | Funcionários responsáveis pelo atendimento e registro das locações. |
| 3 | Filme | Filmes disponíveis no catálogo da locadora. |
| 4 | Gênero | Categorias utilizadas para classificar os filmes. |
| 5 | Locação | Registro de uma locação realizada por um cliente e atendida por um funcionário. |
| 6 | Item_Locação | Representa cada filme incluído em uma determinada locação. |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```text
Cliente
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_cliente | Identificador único do cliente | INT | Sim |
| nome | Nome completo do cliente | VARCHAR(100) | Sim |
| cpf | CPF do cliente | VARCHAR(14) | Sim |
| telefone | Telefone de contato | VARCHAR(20) | Não |
| email | E-mail do cliente | VARCHAR(100) | Não |

## Entidade 2

**Nome da entidade:**

```text
Funcionário
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_funcionario | Identificador único do funcionário | INT | Sim |
| nome | Nome completo do funcionário | VARCHAR(100) | Sim |
| cpf | CPF do funcionário | VARCHAR(14) | Sim |
| cargo | Função exercida na locadora | VARCHAR(50) | Sim |
| telefone | Telefone de contato | VARCHAR(20) | Não |

## Entidade 3

**Nome da entidade:**

```text
Filme
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_filme | Identificador único do filme | INT | Sim |
| titulo | Título do filme | VARCHAR(150) | SIM |
| ano_lancamento | Ano de lançamento do filme | YEAR | Sim |
| avaliacao | Avaliação atribuída ao filme | DECIMAL(3,1) | Não |
| diretor | Nome do diretor do filme | VARCHAR(100) | Sim |
| id_genero | Identificador do gênero do filme | INT | Sim |

## Entidade 4

**Nome da entidade:**

```text
Gênero
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_genero | Identificador único do gênero | INT | Sim |
| nome | Nome do gênero cinematográfico | VARCHAR(50) | Sim |
| descricao | Descrição do gênero | VARCHAR(200) | Não |
| classificado | Classificação ou característica do gênero | VARCHAR(50) | Não |
| ativo | Indica se o gênero está disponível para uso | BOOLEAN | Sim |

## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
| Locação | id_locacao, id_cliente, id_funcionario, data_locacao, data_devolucao |
| Item_Locação | id_item, id_locacao, id_filme, valor_diaria |
|  |  |

---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| Cliente | id_cliente | Identifica cada cliente de forma única e não depende de informações pessoais que podem ser alteradas. |
| Funcionário | id_funcionario | Identifica cada funcionário individualmente de forma única dentro da locadora. |
| Filme | id_filme | Identifica cada gênero de forma única. |
| Gênero | id_genero | Identifica cada gênero de forma única. |
| Locação | id_locacao | Identifica cada operação de locação realizada. |
| Item_Locação | id_item | Identifica cada item de filme associado a uma locação. |

Considere:

- o valor identifica cada registro de forma única?
- o valor poderá se repetir?
- será utilizado um identificador numérico?
- será necessário `AUTO_INCREMENT`?]

> Os identificadores serão numéricos e está previsto o uso de AUTO_INCEMENT para gerar automaticamente os valores das chaves primárias.

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
| Cliente | realiza | Locação |
| Funcionário | registra | Locação |
| Locação | possui | Item_Locação |
| Filme | aparece em | Item_Locação |
| Gênero | classifica | Filme |

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
| Cliente realiza Locação | 1 | Um cliente pode realizar várias locações, enquanto cada locação pertence a um único cliente. |
| Funcionário registra Locação | 1 | Um funcionário pode registrar várias locações, enquanto cada locação é registrada por um único funcionário. |
| Locação possui Item_Locação | 1 | Uma locação pode possuir um ou mais filmes, e cada item pertence a uma única locação. |
| Filme aparece em Item_Locação | 1 | Um mesmo filme pode aparecer em várias locações ao longo do tempo, enquanto cada item de locação se refere a um único filme. |
| Gênero classifica Filme | 1 | Um gênero pode estar associado a vários filmes, enquanto cada filme possui um gênero definido. |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Filme | id_genero | Gênero(id_genero) |
| Locação | id_cliente | Cliente(id_cliente) |
| Locação | id_funcionario | Funcionário(id_funcionario) |
| Item_Locação | id_locacao | Locação(id_locacao) |
| Item_Locação | id_filme | Filme(id_filme) |

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
| Cliente | id_cliente | PRIMARY KEY, AUTO_INCRMENT | Identificar cada cliente de forma única e gerar o identificador automaticamente. |
| Cliente | cpf | UNIQUE, NOT NULL | Evitar o cadastro de dois clientes com o mesmo CPF. |
| Funcionário | id_funcionario | PRIMARY KEY, AUTO_INCREMENT | Identificar cada funcionário de forma única. |
| Funcionário | cpf | UNIQUE, NOT NULL | Evitar o cadastro de dois funcionários com o mesmo CPF. |
| Filme | id_genero | FOREGEIN KEY, NOT NULL | Garantir que o gênero informado exista na tabela Gênero. |
| Filme | titulo | NOT NULL | Garantir que todo filme possua um título.|
| Gênero | nome | UNIQUE, NOT NULL | Evitar gêneros duplicados e garantir que todo gênero possua um nome. |
| Locação | id_cliente | FOREGEIN KEY, NOT NULL | Garantir que a locação esteja associada a um cliente existente. |
| Locação | id_funcionario | FOREGEIN KEY, NOT NULL | Garantir que a locação esteja associada a um funcionário existente. |
| Item_Locação | id_filme | FOREGEIN KEY, NOT NULL | Garantir que o item esteja associado a um filme existente. | 

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

1. Um cliente deve estar cadastrado no sistema para poder realizar uma locação.
2. Uma locação deve estar associada a um cliente e a um funcionário cadastrados.
3. Um filme deve estar associado a um gênero existente na tabela de gêneros.
4. O CPF não pode ser repetido entre os clientes e também não pode ser repetido entre os funcionários. 
5. Uma locação deve possuir pelo menos um filme associado por meio da tabela Item_Locação.
6. Um filme pode participar de várias locações ao longo do tempo.
7. O ano de lançamento de um filme deve representar um ano válido de lançamento.
8. A avaliação de um filme deve estar dentro de uma faixa previamente definida pela aplicação da locadora.

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
├── id_cliente (PK)
├── nome
├── cpf (UNIQUE)
├── telefone
└── email

FUNCIONÁRIO
├── id_funcionario (PK)
├── nome
├── cpf (UNIQUE)
├── cargo
└── telefone

GÊNERO
├── id_genero (PK)
├── nome (UNIQUE)
├── descricao
├── classificado
└── ativo

FILME
├── id_filme (PK)
├── titulo
├── ano_lancamento
├── avaliacao
├── diretor
└── id_genero (FK)

LOCAÇÃO
├── id_locacao (PK)
├── id_cliente (FK)
├── id_funcionario (FK)
├── data_locacao
└── data_devolucao

ITEM_LOCAÇÃO
├── id_item (PK)
├── id_locacao (FK)
├── id_filme (FK)
└── valor_diaria

RELACIONAMENTOS

CLIENTE 1 ───── N LOCAÇÃO

FUNCIONÁRIO 1 ───── N LOCAÇÃO

LOCAÇÃO 1 ───── N ITEM_LOCAÇÃO

FILME 1 ───── N ITEM_LOCAÇÃO

GÊNERO 1 ───── N FILME
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Dados cadastrais dos clientes, como nome, CPF, telefone, e e-mail.
2. Dados dos funcionários, como nome, CPF, cargo e telefone.
3. Informações dos filmes disponíveis na locadora, incluindo título, ano de lançamento, avaliação, diretor e gênero.
4. Registros das locações realizadas, contendo cliente, funcionário, datas e filmes alugados.

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

1. Quais clientes estão cadastrados na locadora?
2. Quais filmes estão cadastrados e quais são seus respectivos gêneros?
3. Quantas locações cada cliente realizou?
4. Quais filmes foram mais alugados?
5. Quantos filmes existem cadastrados em cada gênero?
6. Quais funcionários registraram locações?
7. Qual foi o valor total de uma determinada locação? 

---

# 17. Decisões e dúvidas pendentes

- O banco será desenvolvido inicialmente com foco no cadastro de filmes, clientes, funcionários, gêneros e no registro das locações.
- A disponibilidade física de cópias de cada filme poderá ser definida ou acrescentada em uma etapa posterior, caso seja necessária para o funcionamento da locadora.
- Os valores de diária e outras regras comerciais poderão ser ajustados durante a implementação das próximas Sprints.

Caso não existam dúvidas:

> Nenhuma dúvida pendente nesta Sprint.

---

# 18. Checklist da Sprint 1/5

- [ ] identifiquei o aluno responsável;
- [ ] defini o tema do banco de dados;
- [ ] descrevi o sistema;
- [ ] defini o objetivo do banco;
- [ ] defini o escopo inicial;
- [ ] identifiquei pelo menos 4 entidades;
- [ ] planejei os principais atributos;
- [ ] defini as chaves primárias previstas;
- [ ] identifiquei os relacionamentos;
- [ ] defini as cardinalidades iniciais;
- [ ] identifiquei possíveis chaves estrangeiras;
- [ ] planejei restrições de integridade;
- [ ] defini pelo menos 5 regras de negócio;
- [ ] fiz um esboço da estrutura do banco;
- [ ] defini os tipos de dados que futuramente serão cadastrados;
- [ ] defini pelo menos 5 perguntas que o banco deverá responder;
- [ ] registrei dúvidas ou decisões pendentes;
- [ ] revisei o arquivo antes de finalizar.

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
