# SPRINT 1/5 — Planejamento do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados  
**Data:** 31/08/2026  
**Modalidade:** Atividade individual / Equipe  

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

> Célia Hiromi Watanabe

**Nome escolhido para o banco de dados:**

```text
db_salao_beleza
```

---

# 2. Tema do banco de dados

Escolha um domínio para o banco de dados que será desenvolvido durante toda a atividade.

O tema é livre, desde que permita a criação de um banco relacional com múltiplas tabelas e relacionamentos coerentes.

### Tema escolhido

> Sistema de Gestão de Atendimentos e Agendamentos para Salão de Beleza.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> 1. **Contexto e problema:** O sistema representa o controle operacional de um Salão de Beleza, resolvendo o problema de organização de horários, alocação de profissionais aos atendimentos e controle dos serviços prestados.
> 2. **Usuários:** Será utilizado pela recepcionista/administradora do salão e pelos profissionais para acompanhar sua agenda diária e serviços realizados.
> 3. **Informações principais:** Dados dos clientes (nome, telefone, email, CPF), dados dos profissionais (nome, especialidade, telefone), catálogo de serviços (nome, preço, duração média em minutos) e os agendamentos realizados (data/hora, cliente, profissional, serviço, status e forma de pagamento).
> 4. **Operações permitidas:** Cadastro e atualização de clientes e profissionais, gerenciamento dos serviços oferecidos, marcação, cancelamento e conclusão de agendamentos, e consultas de faturamento e produtividade por profissional.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> Centralizar e organizar os dados essenciais do salão de beleza em uma estrutura relacional simples e eficiente, permitindo registrar clientes, serviços e profissionais, além de controlar a agenda de atendimentos de forma consistente.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar e consultar os clientes do salão;
2. Manter o catálogo de serviços oferecidos com seus respectivos preços e tempos de duração;
3. Cadastrar os profissionais atendentes e suas áreas de especialidade;
4. Registrar agendamentos vinculando cliente, profissional e serviço com data e horário definidos;
5. Controlar o status do agendamento (ex: 'Agendado', 'Concluído', 'Cancelado') e a forma de pagamento utilizada.

---

# 6. Identificação das entidades

Identifique as principais entidades necessárias para representar o sistema.

Uma entidade representa algo sobre o qual o banco precisa armazenar informações.

### Entidades do seu banco

| Nº | Entidade | O que representa? |
|---:|---|---|
| 1 | `cliente` | Pessoas que frequentam o salão e contratam os procedimentos. |
| 2 | `profissional` | Especialistas e colaboradores do salão (cabeleireiro, manicure, esteticista). |
| 3 | `servico` | Procedimentos disponíveis para contratação com valor e duração média. |
| 4 | `agendamento` | Atendimento marcado relacionando cliente, profissional, serviço, data/hora e pagamento. |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```text
cliente
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id_cliente` | Identificador único do cliente | `INT` | Sim (PK) |
| `nome` | Nome completo do cliente | `VARCHAR(100)` | Sim |
| `cpf` | Cadastro de Pessoa Física | `VARCHAR(14)` | Sim (UNIQUE) |
| `telefone` | Número de telefone/WhatsApp | `VARCHAR(20)` | Sim |
| `email` | E-mail para contato | `VARCHAR(100)` | Não |

## Entidade 2

**Nome da entidade:**

```text
profissional
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id_profissional` | Identificador único do profissional | `INT` | Sim (PK) |
| `nome` | Nome completo do profissional | `VARCHAR(100)` | Sim |
| `especialidade` | Área de atuação (Cabelo, Unha, Estética) | `VARCHAR(50)` | Sim |
| `telefone` | Telefone de contato do profissional | `VARCHAR(20)` | Sim |

## Entidade 3

**Nome da entidade:**

```text
servico
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id_servico` | Identificador único do serviço | `INT` | Sim (PK) |
| `nome_servico` | Nome do serviço (ex: Corte, Escova, Manicure) | `VARCHAR(100)` | Sim |
| `duracao_minutos` | Duração estimada do serviço em minutos | `INT` | Sim |
| `preco` | Valor cobrado pelo procedimento | `DECIMAL(10,2)` | Sim |

## Entidade 4

**Nome da entidade:**

```text
agendamento
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id_agendamento` | Identificador único do agendamento | `INT` | Sim (PK) |
| `id_cliente` | Identificador do cliente atendido | `INT` | Sim (FK) |
| `id_profissional` | Identificador do profissional responsável | `INT` | Sim (FK) |
| `id_servico` | Identificador do serviço agendado | `INT` | Sim (FK) |
| `data_hora` | Data e horário marcados para o atendimento | `DATETIME` | Sim |
| `status` | Situação do atendimento ('Agendado', 'Concluído', 'Cancelado') | `VARCHAR(20)` | Sim (DEFAULT 'Agendado') |
| `forma_pagamento` | Meio de pagamento ('Dinheiro', 'PIX', 'Cartão') | `VARCHAR(20)` | Não |

## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
| *(Nenhuma)* | O modelo foi projetado de forma enxuta com 4 entidades essenciais interligadas. |

---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| `cliente` | `id_cliente` | Identificador numérico com `AUTO_INCREMENT`, único e imutável para cada cliente. |
| `profissional` | `id_profissional` | Identificador numérico com `AUTO_INCREMENT`, exclusivo para cada colaborador. |
| `servico` | `id_servico` | Identificador numérico com `AUTO_INCREMENT` que define unicamente cada serviço. |
| `agendamento` | `id_agendamento` | Identificador sequencial `AUTO_INCREMENT` para rastrear cada atendimento individualmente. |

---

# 9. Relacionamentos entre as entidades

Identifique como as entidades se relacionam.

### Relacionamentos planejados

| Entidade A | Relacionamento | Entidade B |
|---|---|---|
| `cliente` | realiza | `agendamento` |
| `profissional` | executa | `agendamento` |
| `servico` | é prestado em | `agendamento` |

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
| `cliente` - `agendamento` | `1:N` | Um cliente pode ter vários agendamentos, mas cada agendamento pertence a apenas um cliente. |
| `profissional` - `agendamento` | `1:N` | Um profissional pode realizar múltiplos agendamentos em horários distintos, mas cada agendamento é atendido por um profissional. |
| `servico` - `agendamento` | `1:N` | Um mesmo tipo de serviço pode ser contratado em vários agendamentos, mas cada registro de agendamento refere-se a um serviço específico. |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| `agendamento` | `id_cliente` | `cliente (id_cliente)` |
| `agendamento` | `id_profissional` | `profissional (id_profissional)` |
| `agendamento` | `id_servico` | `servico (id_servico)` |

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
| `cliente` | `id_cliente` | `PRIMARY KEY`, `AUTO_INCREMENT` | Garante identificador exclusivo para cada cliente cadastrado. |
| `cliente` | `cpf` | `NOT NULL`, `UNIQUE` | Impede que o mesmo cliente seja cadastrado em duplicidade. |
| `profissional` | `id_profissional` | `PRIMARY KEY`, `AUTO_INCREMENT` | Identificador único para cada profissional do salão. |
| `servico` | `id_servico` | `PRIMARY KEY`, `AUTO_INCREMENT` | Identificador único de cada item do catálogo. |
| `servico` | `preco` | `NOT NULL` | O serviço não pode ser cadastrado sem um preço definido. |
| `agendamento` | `id_agendamento` | `PRIMARY KEY`, `AUTO_INCREMENT` | Identificador sequencial de cada registro de agendamento. |
| `agendamento` | `id_cliente` | `FOREIGN KEY`, `NOT NULL` | Garante que todo agendamento esteja associado a um cliente existente. |
| `agendamento` | `id_profissional` | `FOREIGN KEY`, `NOT NULL` | Garante que todo agendamento possua um profissional responsável. |
| `agendamento` | `id_servico` | `FOREIGN KEY`, `NOT NULL` | Garante que o agendamento aponte para um serviço válido. |
| `agendamento` | `status` | `NOT NULL`, `DEFAULT 'Agendado'` | Garante que o agendamento inicie sempre com situação definida. |

---

# 13. Regras de negócio

Defina pelo menos **5 regras de negócio** para o sistema.

### Regras do seu banco

1. Todo agendamento deve obrigatoriamente estar associado a um cliente, um profissional e um serviço válidos.
2. Cada cliente deve possuir um CPF único cadastrado no sistema.
3. Todo serviço cadastrado deve possuir preço maior que zero e duração em minutos positiva.
4. O status padrão de um novo agendamento deve ser `'Agendado'`.
5. Nenhum agendamento pode ser gravado sem a data e o horário do atendimento.

---

# 14. Esboço da estrutura do banco

Faça uma representação textual inicial das tabelas e relacionamentos.

### Esboço do seu banco

```text
CLIENTE
├── id_cliente (PK)
├── nome
├── cpf (UNIQUE)
├── telefone
└── email

PROFISSIONAL
├── id_profissional (PK)
├── nome
├── especialidade
└── telefone

SERVICO
├── id_servico (PK)
├── nome_servico
├── duracao_minutos
└── preco

AGENDAMENTO
├── id_agendamento (PK)
├── id_cliente (FK -> CLIENTE)
├── id_profissional (FK -> PROFISSIONAL)
├── id_servico (FK -> SERVICO)
├── data_hora
├── status
└── forma_pagamento

RELACIONAMENTOS:
CLIENTE      (1) ───────────< (N) AGENDAMENTO
PROFISSIONAL (1) ───────────< (N) AGENDAMENTO
SERVICO      (1) ───────────< (N) AGENDAMENTO
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. **Clientes:** Cadastros com nomes, CPFs, telefones e emails reais fictícios (ex: "Maria Silva", "João Santos", "Ana Paula").
2. **Profissionais:** Especialistas do salão com suas respectivas áreas (ex: "Carla Mendes - Cabeleireira", "Juliana Souza - Manicure", "Marcos Lima - Esteticista").
3. **Serviços:** Catálogo de serviços com valores e durações (ex: "Corte Feminino - R$ 60.00 - 60 min", "Escova - R$ 45.00 - 45 min", "Manicure - R$ 35.00 - 45 min", "Limpeza de Pele - R$ 120.00 - 90 min").
4. **Agendamentos:** Registros de atendimentos marcados com datas, horários, status ('Agendado', 'Concluído', 'Cancelado') e formas de pagamento ('PIX', 'Cartão', 'Dinheiro').

---

# 16. Perguntas que o banco deverá ser capaz de responder

Defina pelo menos **5 perguntas** que futuramente deverão ser respondidas por consultas SQL.

### Perguntas do seu projeto

1. Quais clientes estão cadastrados no salão, ordenados por nome?
2. Quais serviços possuem valor superior a R$ 50,00?
3. Quais agendamentos foram realizados por um cliente específico, mostrando data e nome do serviço?
4. Quantos agendamentos cada profissional atendeu no total?
5. Qual é o faturamento total acumulado pelos agendamentos com status 'Concluído'?

---

# 17. Decisões e dúvidas pendentes

> Nenhuma dúvida pendente nesta Sprint. O modelo foi simplificado para 4 tabelas fundamentais, facilitando a implementação DDL na Sprint 2/5 e as consultas SQL nas etapas seguintes.

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

Utilize a convenção definida pelo professor para identificação individual / da equipe:

```text
team-03-sprints-1-5
```

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
