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

> Geovanna Gaspar Ribeiro.

**Nome escolhido para o banco de dados:**

```text
gerenciamento_incidentes

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

> Sistema de Gerenciamento de Incidentes de Segurança.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> O sistema representa um ambiente de gerenciamento de incidentes de segurança da informação. Ele poderá ser utilizado por analistas de segurança responsáveis por identificar, investigar, acompanhar e registrar incidentes que possam representar riscos para dispositivos, sistemas ou redes.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> O principal objetivo do banco de dados é organizar e armazenar informações relacionadas aos incidentes de segurança, permitindo que os registros sejam consultados e acompanhados de forma estruturada. O banco deverá facilitar a identificação dos incidentes, dos analistas responsáveis, dos dispositivos envolvidos, dos tipos de ameaças identificadas e das ações realizadas durante o processo de resposta.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar incidentes de segurança identificados.
2. Registrar os analistas responsáveis pelos incidentes.
3. Registrar dispositivos relacionados aos incidentes e alertas.
4. Classificar os incidentes de acordo com tipos de ameaças e níveis de severidade.
5. Registrar ações realizadas para investigar, conter e resolver os incidentes.

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
| 1 | Incidentes | Armazena informações sobre os incidentes de segurança identificados |
| 2 | Analistas | Armazena os profissionais responsáveis pela investigação dos incidentes |
| 3 | Dispositivos | Armazena informações sobre computadores, servidores e outros equipamentos monitorados |
| 4 | Alertas | Armazena alertas de segurança gerados pelo sistema  |
| 5 | Tipos de Ameaças | Armazena as classificações dos tipos de ameaças identificadas  |
| 6 | Ações de Resposta | Armazena as ações realizadas durante o tratamento de um incidente |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```
Incidentes

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_incidente  |Identificador único do incidente  | INT | Sim |
|titulo |Nome ou título do incidente  |VARCHAR(150)  | Sim  |
|descricao  |Informações detalhadas sobre o incidente  |TEXT  |Sim  |
|severidade  |Nível de gravidade do incidente  |VARCHAR(30)  |Sim  |
|status  |Situação atual do incidente  |VARCHAR(30)  |Sim  |

## Entidade 2

**Nome da entidade:**

```
Analistas

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_analista | Identificador único do analista | INT  | SIM |
| nome | Nome do analista | VARCHAR(100) | SIM |
| email | E-mail do analista  | VARCHAR(150) | SIM |
| cargo | Cargo ou função do analista | VARCHAR(100) | NÃO |


## Entidade 3

**Nome da entidade:**

```
Dispositivos

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_dispositivo  | Identificador único do dispositivo  | INT | Sim |
| nome_dispositivo |Nome do dispositivo  | VARCHAR(100) | Sim  |
| tipo_dispositivo |Tipo do equipamento  | VARCHAR(50)  |Sim  |
| ip_adress |Endereço IP do dispositivo  | VARCHAR(45) | Sim |
| ativo | Indica se o dispositivo está ativo | BOOLEAN | Sim |

## Entidade 4

**Nome da entidade:**

```
Alertas

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_alerta | Identificador único do alerta | INT  |Sim  |
| titulo | Título do alerta | VARCHAR(150) | Sim |
| descricao | Descrição do alerta | TEXT | Não |
| data_alerta | Data e horário do alerta |DATETIME  | Sim  |
| status | Situação do alerta | VARCHAR(30) | Sim |

## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
|Tipos de Ameaças  | id_ameaca, nome_ameaca, descricao |
| Ações de Resposta |id_acao, descricao, data_acao, id_incidente  |


---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| Incidentes | id_incidente |Identifica cada incidente de forma única  |
| Analistas | id_analista | Identifica cada analista de forma única |
| Dispositivos | id_dispositivo | Identifica cada dispositivo de forma única |
| Alertas | id_alerta | Identifica cada alerta de forma única |
| Tipos de Ameaças | id_ameaca  | Identifica cada tipo de ameaça de forma única |
| Ações de Resposta| id_acao | Identifica cada ação realizada de forma única | 

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
| Analistas | Investiga e acompanha | Incidentes |
| Dispositivos | Pode estar relacionado a  |Incidentes  |
| Dispositivos | Pode gerar | Alertas  |
| Tipos de Ameaças | Classifica  | Incidentes |
| Alertas | Pode resultar em  | Incidentes |
| Incidentes | Possui | Ações de Resposta |
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
| Analista — Incidentes | 1:N | Um analista pode acompanhar vários incidentes |
| Dispositivo — Incidentes | 1:N | Um dispositivo pode estar relacionado a vários incidentes |
| Dispositivo — Alertas | 1:N | Um dispositivo pode gerar vários alertas |
| Tipo de Ameaça — Incidentes | 1:N | Um tipo de ameaça pode classificar vários incidentes |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Incidentes | id_analista | Analistas |
| Incidentes | id_dispositivo | Dispositivos |
| Incidentes | id_ameaca | Tipos de Ameaças |
| Incidentes | id_alerta | Alertas |

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
| Incidentes |id_incidente  | PRIMARY KEY, AUTO_INCREMENT | Identifica cada incidente de forma única |
| Incidentes | titulo | NOT NULL | Todo incidente deve possuir um título |
| Incidentes | descricao | NOT NULL | É necessário registrar informações sobre o incidente |
| Analistas | email | NOT NULL, UNIQUE | Evita analistas duplicados com o mesmo e-mail |
| Dispositivos | ip_address | NOT NULL, UNIQUE | Evita dispositivos duplicados com o mesmo IP |

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

1. Todo incidente deverá possuir obrigatoriamente um título, descrição, nível de severidade, status e data de identificação.
2. Cada incidente deverá possuir um status para acompanhamento, como Aberto, Em análise, Resolvido ou Encerrado.
3. Um incidente poderá ser associado a um analista responsável pela investigação.
4. A data de encerramento somente deverá ser registrada quando o incidente estiver resolvido ou encerrado.
5. Um dispositivo poderá gerar vários alertas de segurança.
6. Um incidente poderá possuir várias ações de resposta durante sua investigação e resolução.

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
ANALISTAS 
├── id_analista (PK) 
├── nome 
├── email 
└── cargo

DISPOSITIVOS 
├── id_dispositivo (PK) 
├── nome_dispositivo 
├── tipo_dispositivo 
├── ip_address 
└── ativo

TIPOS_AMEACAS 
├── id_ameaca (PK) 
├── nome_ameaca 
└── descricao

ALERTAS 
├── id_alerta (PK) 
├── titulo 
├── descricao 
├── data_alerta 
├── status 
└── id_dispositivo (FK)

INCIDENTES 
├── id_incidente (PK) 
├── titulo 
├── descricao 
├── severidade 
├── status 
├── data_identificacao 
├── data_encerramento 
├── id_analista (FK) 
├── id_dispositivo (FK) 
├── id_ameaca (FK) 
└── id_alerta (FK)

ACOES_RESPOSTA 
├── id_acao (PK) 
├── descricao 
├── data_acao 
└── id_incidente (FK)

ANALISTAS 1 ───── N INCIDENTES 

DISPOSITIVOS 1 ───── N ALERTAS 

DISPOSITIVOS 1 ───── N INCIDENTES 

TIPOS_AMEACAS 1 ───── N INCIDENTES 

ALERTAS 1 ───── N INCIDENTES 

INCIDENTES 1 ───── N ACOES_RESPOSTA


```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Registros de analistas responsáveis pela segurança.
2. Registros de computadores, servidores e outros dispositivos monitorados.
3. Registros de alertas de segurança gerados pelo sistema.
4. Registros de incidentes, ameaças e ações realizadas para sua resolução.

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

1. Quais incidentes de segurança estão atualmente abertos?
2. Quais incidentes possuem severidade alta ou crítica?
3. Quais incidentes estão sob responsabilidade de cada analista?
4. Quais dispositivos estão relacionados ao maior número de incidentes?
5. Quantos incidentes foram registrados por tipo de ameaça?

---

# 17. Decisões e dúvidas pendentes

- Nenhuma dúvida pendente nesta Sprint.
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
