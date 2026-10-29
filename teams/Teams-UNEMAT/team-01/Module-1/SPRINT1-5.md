# SPRINT 1/5 — Planejamento do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados  
**Data:** 01/09/2026  
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

> RAQUEL SILVA DOS SANTOS

**Nome escolhido para o banco de dados:**

```text

series_watchlist_db

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

> Catálogo e lista pessoal de séries com notas e status de exibição (estilo Watchlist / Letterboxd de séries).

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> Usuários precisam de uma forma fácil e centralizada de registrar quais séries estão assistindo, quais já terminaram, dar notas e salvar resenhas curtas.

**Quem utilizaria:** Pessoas que assistem a séries e gostam de organizar suas maratonas e histórico.

**Informações principais:** Dados dos usuários, catálogo de séries, plataformas de streaming onde as séries estão disponíveis e o registro de cada série assistida com nota e status.

**Operações permitidas:** Cadastrar usuários, cadastrar séries e plataformas, adicionar séries à lista pessoal com nota/comentário.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> Gerenciar um catálogo simples de séries associado a plataformas de streaming e permitir que usuários controlem seu histórico e avaliações em uma única lista personalizada.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar usuários com e-mails únicos.
2. Cadastrar plataformas de streaming (Netflix, Prime Video, HBO Max, etc.).
3. Cadastrar séries vinculadas à sua plataforma principal.
4. Adicionar séries à lista do usuário com status ("Quero Ver", "Assistindo", "Finalizada").
5. Registrar notas (0 a 10) e comentários na própria lista.

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
| 1 | Usuário | Pessoa cadastrada que possui uma lista de séries. |
| 2 | Plataforma | Serviço de streaming onde a série é exibida (ex.: Netflix, Max). |
| 3 | Serie | Série catalogada no sistema com título, ano e gênero. |
| 4 | Item_watchlist | Registro que vincula o usuário à série com seu status, nota e comentário. |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```text
USUÁRIO
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_usuario | Código identificador do usuário | INT | Sim |
| nome | Nome completo do usuário | VARCHAR(100) | Sim |
| email | E-mail de cadastro | VARCHAR(100) | Sim |
| data_cadastro | Data de criação da conta | DATE | Sim |


## Entidade 2

**Nome da entidade:**

```text

PLATAFORMA

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_plataforma | Código da plataforma | INT| Sim |
| Nome_plataforma | Nome do streaming (Netflix, Max, etc.) | VARCHAR(50) | Sim |

## Entidade 3

**Nome da entidade:**

```text
SERIE

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_serie | Código identificador da série | INT | sim |
| Titulo | Título da série | VARCHAR(100) | Sim |
| Genero | Gênero da serie (Drama, Comédia, Sci-Fi) | VARCHAR(50) | Sim |
| Ano_lancamento | Ano de estreia da serie | INT | Sim |
| Id_plataforma | Plataforma onde é exibida (FK) | INT | Sim |

## Entidade 4

**Nome da entidade:**

```text
Item_watchlist
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Id_usuário | Usuário dono da lista (FK) |  INT| Sim |
| Id_serie | Série adicionada (FK) | INT | Sim |
| Status_assistindo | Status ("Quero Ver", "Assistindo", "Finalizada") | VARCHAR(20) | Sim |
| Nota | Nota atribuída pelo usuário (0 a 10) | DECIMAL(3,1) | Não |
| Comentário | Breve resenha pessoal | VARCHAR(255) | Não |

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
| Usuario |  Id_usuario | Código numérico sequencial único gerado via AUTO_INCREMENT. |
| Plataforma | Id_plataforma |Código numérico sequencial único via AUTO_INCREMENT.  |
| Serie | Id_serie | Identificador numérico único para evitar duplicidade de títulos. |
| Item_watchlist |(id_usuario, id_serie) | Chave primária composta pelas duas FKs, identificando unicamente a relação N:N sem necessidade de um ID surrogate. | |

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
| Plataforma | disponibiliza | serie |
| usuário | adiciona na lista | item_watchlist |
| serie | é registrada em | item_watchlist |


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
| Plataforma- serie | 1:N | Uma plataforma pode ter várias series cadastradas. |
| Usuario - item_watchlist | 1:N | Um usuário pode ter vários registros na lista. |
| Serie - Item_watchlist | 1:N | Uma serie pode estar na lista de vários usuários. |
|  |  |  |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| SERIE | Id_plataforma | Plataforma (id_plataforma) |
| ITEM_WATCHLIST | Id_usuario | Usuario (Id_usuário) |
| ITEM_WATCHLIST | Id_serie | Serie (Id_serie) |

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
| USUARIO | email | UNIQUE, NOT NULL | Impede que existam dois usuários com o mesmo e-mail. |
| PLATAFORMA | nome_plataforma | UNIQUE, NOT NULL | Evita duplicidade de cadastro da mesma plataforma de streaming. |
| ITEM_WATCHLIST | (id_usuario, id_serie) | PRIMARY KEY | Identifica a linha de forma única e impede que o mesmo usuário repita a mesma série na lista. |
| ITEM_WATCHLIST | status_assistindo | DEFAULT 'Quero Ver' | Caso o usuário não especifique, a série entra automaticamente como "Quero Ver". |
| USUARIO, PLATAFORMA, SERIE | id_* | PRIMARY KEY, AUTO_INCREMENT | Garante a identificação única e o preenchimento automático das chaves primárias das entidades base. |
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

1. Não é permitido cadastrar dois usuários com o mesmo endereço de e-mail.
2. Cada série só pode ser adicionada uma única vez na lista de um mesmo usuário.
3. A nota atribuída deve ser um número entre 0 e 10 (ou nula, se o usuário ainda não assistiu).
4. O status de exibição deve assumir apenas os valores: "Quero Ver", "Assistindo" ou "Finalizada".
5. Uma série obrigatoriamente deve estar vinculada a uma plataforma cadastrada.

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
PLATAFORMA
├── id_plataforma (PK)
└── nome_plataforma

SERIE
├── id_serie (PK)
├── titulo
├── genero
├── ano_lancamento
└── id_plataforma (FK)

USUARIO
├── id_usuario (PK)
├── nome
├── email
└── data_cadastro

ITEM_WATCHLIST
├── id_usuario (PK, FK)
├── id_serie (PK, FK)
├── status_assistindo
├── nota
└── comentario

PLATAFORMA  1 ───── N  SERIE
USUARIO     1 ───── N  ITEM_WATCHLIST
SERIE       1 ───── N  ITEM_WATCHLIST
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Plataformas de streaming: Netflix, Prime Video, HBO Max, Disney+.
2. Séries: Títulos como Breaking Bad, Stranger Things, The Last of Us, com gênero e ano de estreia.
3. Usuários: Perfis de exemplo com nome, e-mail e data de cadastro.
4. Itens na watchlist: Associações com status (ex.: "Finalizada", "Assistindo"), notas (ex.: 9.5, 8.0) e pequenos comentários de resenha.

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

1. Quais séries cadastradas pertencem à plataforma "Netflix"?
2. Qual é a média das notas de cada série calculada a partir das avaliações dos usuários?
3. Quantas séries cada usuário tem marcadas com o status "Finalizada"?
4. Quais séries cadastradas são do gênero "Drama" e foram lançadas a partir de 2020?
5. Qual é o top 3 de séries com as maiores notas médias entre os usuários?

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
