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

> Vinícius Eduardo Lima de Assis.

**Nome escolhido para o banco de dados:**

```text
pacote_viagens
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

> Viagens.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> O sistema de banco de dados de pacotes de viagens representa o contexto de organização e gestão de ofertas turísticas, solucionando o problema de centralizar informações sobre destinos, preços e serviços. Ele será utilizado por agências de turismo, que cadastrarão e administrarão os pacotes, e por clientes interessados em consultar e reservar viagens. As principais informações armazenadas serão destinos, preços, hospedagens, transportes e dados de clientes cadastrados. O sistema permitirá operações como cadastro de pacotes, consulta, reservas, atualização de informações e emissão de relatórios.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

>  O objetivo é centralizar e organizar todas as informações relacionadas às ofertas turísticas, garantindo que agências possam gerenciar seus pacotes de forma eficiente e que clientes tenham acesso rápido e confiável para consultar e reservar viagens e/ou hospedagens.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastro de pacotes
2. Hospedagens
3. Destinos
4. Transportes
5. Reservas
6. Dados do Cliente

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
| 1 | Cliente | dados pessoais do usuário |
| 2 | Destino  | dados do local |
| 3 | Hospedagem | dados das acomodações |
| 4 | Transporte | meio de deslocamento |


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
| id_cliente | Identificação única do cliente | INT | Sim |
| nome | Nome completo do cliente | VARCHAR(100) | Sim |
| cpf | CPF do cliente | VARCHAR(14) | Sim |
| email | E-mail do cliente | VARCHAR(100) | Sim |
| telefone | Número de telefone do cliente | VARCHAR(20) | Não |

## Entidade 2

**Nome da entidade:**

```text
Destino
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_destino | Identificação única do destino | INT | Sim |
| nome | Nome da cidade ou local | VARCHAR(100) | Sim |
| pais | País onde o destino está localizado | VARCHAR(60) | Sim |
| estado | Estado ou região do destino | VARCHAR(60) | Não |
| descricao | Descrição do destino | TEXT | Não |

## Entidade 3

**Nome da entidade:**

```text
Hospedagem
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_hospedagem |Identificação única da hospedagem  | INT | Sim |
| nome | Nome do hotel ou acomodação | VARCHAR(100) | Sim |
| endereco | Endereço da hospedagem | VARCHAR(200) | Sim |
| tipo | Tipo de acomodação | VARCHAR(50) | Sim |
| valor_diaria | Valor da diária | DECIMAL(10,2) | Sim |

## Entidade 4

**Nome da entidade:**

```text
Transporte
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_transporte | Identificação única do transporte | INT | Sim |
| tipo | Tipo de transporte utilizado | VARCHAR(50) | Sim |
| empresa | Nome da empresa de transporte | VARCHAR(100) | Sim |
| origem | Local de partida | VARCHAR(100) | Sim |
| destino | Local de chegada | VARCHAR(100) | Sim |



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
| Cliente | id_cliente | Identifica cada cliente de forma única, não poderá se repetir e será um identificador numérico com AUTO_INCREMENT |
| Destino | id_destino | Identifica cada destino de forma única, não poderá se repetir e será um identificador numérico com AUTO_INCREMENT |
| Hospedagem | id_hospedagem | Identifica cada hospedagem de forma única, não poderá se repetir e será um identificador numérico com AUTO_INCREMENT |
| Transporte | id_transporte | Identifica cada transporte de forma única, não poderá se repetir e será um identificador numérico com AUTO_INCREMENT |

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
| Cliente | escolhe | Destino |
| Cliente | reserva | Hospedagem |
| Cliente | utiliza | Transporte |
| Destino | possui | Hospedagem |
| Destino | utiliza | Transporte |

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
| Cliente escolhe Destino | N:N | Um cliente pode escolher vários destinos, e um mesmo destino pode ser escolhido por vários clientes |
| Cliente reserva Hospedagem | N:N | Um cliente pode reservar várias hospedagens, e uma hospedagem pode receber reservas de vários clientes |
| Cliente utiliza Transporte | N:N | Um cliente pode utilizar diferentes transportes, e um transporte pode ser utilizado por vários clientes |
| Destino possui Hospedagem | 1:N | Um destino pode possuir várias hospedagens, mas cada hospedagem está localizada em um único destino |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Hospedagem | id_destino | Destino |
| Cliente | id_destino | Destino |
| Cliente | id_hospedagem | Hospedagem |
| Cliente | id_transporte | Transporte |

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
| Cliente | id_cliente | PRIMARY KEY, AUTO_INCREMENT | Identificar cada cliente de forma única e gerar o código automaticamente |
| Cliente | cpf | NOT NULL, UNIQUE | O CPF é obrigatório e não pode pertencer a mais de um cliente |
| Cliente | email | NOT NULL, UNIQUE | O e-mail é obrigatório e deve ser único para cada cliente |
| Destino | id_destino | PRIMARY KEY, AUTO_INCREMENT | Identificar cada destino de forma única e gerar o código automaticamente |
| Destino | nome | NOT NULL | O nome do destino é uma informação obrigatória |
| Hospedagem | id_hospedagem | PRIMARY KEY, AUTO_INCREMENT | Identificar cada hospedagem de forma única e gerar o código automaticamente |
| Hospedagem | valor_diaria | NOT NULL | O valor da diária é necessário para registrar o preço da hospedagem |
| Transporte | id_transporte | PRIMARY KEY, AUTO_INCREMENT | Identificar cada transporte de forma única e gerar o código automaticamente |
| Transporte | tipo | NOT NULL | O tipo de transporte é necessário para identificar o serviço utilizado |

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
2. Um cliente não pode possuir dois cadastros com o mesmo e-mail.
3. Uma hospedagem deve estar associada a um destino existente.
4. O valor da diária de uma hospedagem deve ser maior que zero.
5. Todo transporte cadastrado deve possuir uma empresa, uma origem e um destino informados.

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
├── email (UNIQUE)
└── telefone

DESTINO
├── id_destino (PK)
├── nome
├── pais
├── estado
└── descricao

HOSPEDAGEM
├── id_hospedagem (PK)
├── nome
├── endereco
├── tipo
├── valor_diaria
└── id_destino (FK)

TRANSPORTE
├── id_transporte (PK)
├── tipo
├── empresa
├── origem
└── destino


CLIENTE N ───── N DESTINO
CLIENTE N ───── N HOSPEDAGEM
CLIENTE N ───── N TRANSPORTE
DESTINO 1 ───── N HOSPEDAGEM
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Dados de clientes, como nome, CPF, e-mail e telefone.
2. Dados de destinos turísticos, como cidade, país, estado e descrição.
3. Dados de hospedagens, como nome do hotel ou acomodação, endereço, tipo e valor da diária.
4. Dados de transportes, como tipo de transporte, empresa, origem e destino.

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

1. Quais clientes estão cadastrados no sistema?
2. Quais destinos turísticos estão cadastrados e em quais países estão localizados?
3. Quais hospedagens estão disponíveis em cada destino?
4. Quais são os valores das diárias das hospedagens cadastradas?
5. Quais empresas e tipos de transporte estão cadastrados?

---

# 17. Decisões e dúvidas pendentes

- Nenhuma dúvida pendente nesta Sprint.
- Nenhuma dúvida pendente nesta Sprint.
- Nenhuma dúvida pendente nesta Sprint.

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
