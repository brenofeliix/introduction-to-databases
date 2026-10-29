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

> Talita de Oliveira Leite Sete.
> 
**Nome escolhido para o banco de dados:**

```text
secretaria_saude
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

> Secretaria Municipal de Saúde — gestão de pacientes, atendimentos e unidades de saúde.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> Esse banco de dados representa uma secretaria de saúde, do sistema público de saúde da cidade. Apenas funcionários de dentro da própria secretaria podem usar o sistema e, dependendo do nível de uso a ser liberado, apenas cargos altos ou de segurança teriam acesso a tudo. As principais informações dentro desse banco de dados seriam dados dos pacientes, prontuários, agendamentos de consultas, informações sobre vacinas, estoques de vacinas e remédios. As principais operações seriam agendar consultas, desmarcar, gerar óbito, transferir paciente entre unidades, gerar relatórios e estatísticas.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> Organizar e centralizar as informações de pacientes e atendimentos da rede municipal de saúde, garantindo rastreabilidade do histórico clínico-administrativo e apoiando a gestão da secretaria..

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastro de pacientes
2. Cadastro de profissionais de saúde
3. Cadastro de unidades de saúde
4. Registro de atendimentos/consultas
5. Acesso ao prontuário.
6. Acesso ao estoque de vacinas e medicamentos.
7. Geração de relatórios e estatísticas.
8. Registro de óbitos.
9. Registro de procedimentos.

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
| 1 | Paciente | Pessoa atendida pela rede de saúde |
| 2 | Profissional | Médico, enfermeiro, etc. |
| 3 | Unidade_Saude | UBS, hospital, posto, CAPS |
| 4 | Atendimento | Consulta/atendimento realizado |
| 5 | Prontuario | Registro clínico gerado a partir de um atendimento | 
| 6 | Estoque_Item | Controle de vacinas e medicamentos por unidade |
| 7 | Obito | Registro de óbito vinculado a um paciente |


> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```text
Paciente 
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_paciente | Identificador único | INT (PK, AUTO_INCREMENT)	 | Sim |
| nome | Nome completo | VARCHAR | Sim |
| cpf | CPF | VARCHAR(11) | Sim |
| data_nascimento | Data de nascimento | DATE | Sim |
| sexo | Sexo | CHAR(1) | Não |
| telefone | Contato | VARCHAR | Não |
| endereço | Endereço | VARCHAR | Não |

## Entidade 2

**Nome da entidade:**

```text
Profissional 
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_profissional | Identificador único | INT (PK) | Sim |
| nome | Nome completo | VARCHAR |	Sim  |
| registro_conselho | CRM/COREN | VARCHAR | Não (NULL para administrativo) |
| cargo | Cargo | VARCHAR | Sim |
| setor | Setor em que atua | VARCHAR | Sim |
| telefone | Contato | VARCHAR | Não |

## Entidade 3

**Nome da entidade:**

```text
Unidade_Saude
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_unidade | Identificador único | INT (PK) | Sim |
| nome | Nome da unidade | VARCHAR | Sim |
| endereço | Nome da unidade | VARCHAR | Sim |
| tipo | UBS/HOSPITAL/POSTO/CAPS | VARCHAR | Sim |


## Entidade 4

**Nome da entidade:**

```text
Atendimento
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_atendimento | Identificador único | INT(PK, AUTO_INCREMENT) | Sim |
| id_profissional | Profissional responsável | INT (FK) | Sim |
| id_paciente | Paciente atendido | INT (FK) | Sim |
| id_unidade | Unidade onde ocorreu | INT (FK) | Sim |
| data_hora | Data/hora do atendimento | DATETIME | Sim |
| tipo_atendimento | Consulta/procedimento/vacina | VARCHAR | Sim |
| status | Agendado/Realizado/Cancelado | VARCHAR | Sim |

## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
| Prontuario | id_prontuario, id_paciente, id_atendimento, diagnostico |
| Estoque_Item | id_item, id_unidade, nome, tipo, quantidade, validade |
| Obito | id_obito, id_paciente, data_obito, causa, unidade_responsavel |

---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| Paciente | id_paciente | Identificador numérico único; evita duplicidade mesmo com nomes repetidos |
| Profissional | id_profissional | CRM/COREN pode ser nulo (equipe administrativa), então um ID interno é mais seguro |
| Unidade_saude | id_saude | Nome/endereço podem se repetir ou mudar; o ID garante unicidade  |
| Atendimento | id_atendimento | Um paciente pode ter vários atendimentos; precisa de identificador próprio |
| Prontuario | id_prontuario | Cada registro clínico deve ser único e rastreável |
| Estoque_Item | id_item | Permite controlar entradas/saídas do mesmo insumo ao longo do tempo |
| Obito | id_obito | Registro único e formal do evento |

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
| Paciente | realiza | Atendimento |
| Profissional | realiza | Atendimento |
| Unidade_Saude | sedia | Atendimento |
| Paciente | possui | Prontuario |
| Atendimento | gera | Prontuario |
| Unidade_saude | controla | Estoque_Item |
| Paciente | pode ter | Obito |
| Unidade_saude | resgistra | Obito |

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
| Paciente → Atendimento | 	1:N | Um paciente pode ter vários atendimentos ao longo do tempo |
| Profissional → Atendimento | 1:N | Um profissional atende vários pacientes |
| Unidade_Saude → Atendimento | 1:N | 	Uma unidade concentra vários atendimentos |
| Atendimento → Prontuario | 1:1 | Cada atendimento gera exatamente um registro de prontuário |
| Unidade_Saude → Estoque_Item | 1:N | Cada unidade controla vários itens de estoque | 
| Paciente → Obito | 1:1 | Um paciente só pode ter um registro de óbito |
---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Atendimento | id_paciente | Paciente |
| Atendimento | id_profissional | Profissional |
| Atendimento | id_unidade | Unidade_saude|
| Prontuario | id_paciente | Paciente |
| Prontuario | id_atendimento | Atendimento | 
| Estoque_Item | id_unidade | Unidade_Saude |
| Obito | id_paciente | Paciente |
| Obito | unidade_responsavel | Unidade_Saude |

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
| Paciente | cpf | UNIQUE, NOT NULL | Evitar cadastro duplicado da mesma pessoa |
| Profissional | registro_conselho | UNIQUE | Um CRM/COREN não pode pertencer a dois cadastros |
| Atendimento | id_paciente, id_profissional, id_unidade | FOREIGN KEY, NOT NULL | Todo atendimento precisa estar vinculado a registros existentes |
| Atendimento | status | DEFAULT 'AGENDADO' | Todo atendimento nasce como agendado |
| Prontuario | id_atendimento | UNIQUE | Cada atendimento gera só um prontuário |
| Estoque_Item | quantidade | 	DEFAULT 0, NOT NULL | Controle de estoque não pode ficar nulo |
| Obito | id_paciente | UNIQUE | Um paciente só pode ter um registro de óbito |

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

1. Um paciente não pode possuir dois cadastros com o mesmo CPF.
2. Um atendimento deve estar associado a um paciente, um profissional e uma unidade existentes.
3. Um profissional só pode ser cadastrado com CRM/COREN válido, caso exerça função clínica.
4. A quantidade em estoque de vacinas/medicamentos não pode ser negativa.
5. Um paciente com registro de óbito não pode ter novos atendimentos agendados.
6. A data do atendimento não pode ser anterior à data de nascimento do paciente.

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
PACIENTE
├── id_paciente (PK)
├── nome
├── cpf
└── data_nascimento

PROFISSIONAL
├── id_profissional (PK)
├── nome
├── registro_conselho
└── cargo

UNIDADE_SAUDE
├── id_unidade (PK)
├── nome
└── tipo

ATENDIMENTO
├── id_atendimento (PK)
├── id_paciente (FK)
├── id_profissional (FK)
├── id_unidade (FK)
└── data_hora

PRONTUARIO
├── id_prontuario (PK)
├── id_paciente (FK)
├── id_atendimento (FK)
└── diagnostico

ESTOQUE_ITEM
├── id_item (PK)
├── id_unidade (FK)
├── tipo
└── quantidade

OBITO
├── id_obito (PK)
├── id_paciente (FK)
└── data_obito

PACIENTE 1───N ATENDIMENTO
PROFISSIONAL 1───N ATENDIMENTO
UNIDADE_SAUDE 1───N ATENDIMENTO
ATENDIMENTO 1───1 PRONTUARIO
UNIDADE_SAUDE 1───N ESTOQUE_ITEM
PACIENTE 1───1 OBITO
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Pacientes cadastrados com dados pessoais e endereço.
2. Profissionais de saúde (médicos, enfermeiros) e da equipe administrativa.
3. Unidades de saúde (UPA, hospital, posto, CAPS) com endereço.
4. Atendimentos/consultas realizados, com data e status.
5. Itens de estoque (vacinas e medicamentos) por unidade.

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

1. Quais pacientes estão cadastrados em determinada unidade?
2. Quantos atendimentos cada profissional realizou no mês?
3. Quais unidades têm estoque baixo de determinada vacina?
4. Qual o número de óbitos registrados por unidade/período?
5. Quais pacientes têm atendimentos agendados para os próximos dias?
6. Qual o tipo de atendimento mais frequente por unidade?

---

# 17. Decisões e dúvidas pendentes

- 
- 
- 

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
