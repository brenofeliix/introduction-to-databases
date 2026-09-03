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

**Pedro Gustavo Macena da Silva**

> Preencha aqui.

**sistema escolar**

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

> sistema escolar.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> O sistema escolar será utilizado para organizar as informações de uma escola. Ele permitirá o cadastro de alunos, professores, disciplinas e turmas, além do gerenciamento de matrículas. O sistema será utilizado pela secretaria e pelos professores para consultá, cadastrá, alterá e excluí informações quando necessário.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> O objetivo deste banco de dados é armazenar e organizar as informações da escola, incluindo alunos, professores, disciplinas, turmas e matrículas. O sistema permitirá cadastrar, consultar, atualizar e excluir registros de forma organizada, garantindo a integridade dos dados.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar Alunos 
2. Cadastrar Professores
3. Cadastrrar Disciplinas
4. Cadastrar Turmas
5. Gerenciamento de Matriculas

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

| Nº| Entidade  | O que representa?              |
|---|-----------|--------------------------------|
| 1 |ALUNO      |DADOS DOS ALUNOS                |
| 2 |PROFESSOR  |DADOS DOS PROFESSORES           |
| 3 |DISCIPLINA |DADOS DA DISCIPLINAS            |
| 4 |TURMA      |DADOS DAS TURMAS                |
| 5 |MATRICULA  |DADOS DAS MATRICULAS DOS ALUNOS |
| 6 |SECRETARIA |DADOS DA SECRETARIA ESCOLAR     |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**ALUNO:**

```text

```

| Atributo  | Informação armazenada        | Tipo de dado previsto | Obrigatório? |
|-----------|------------------------------|-----------------------|--------------|
|MATRICULA  |NOME COMPLETO DO ALUNO        |TEXTO                  |SIM           |
|TELEFONE   |PEDRO GUSTAVO MACENA DA SILVA |TEXTO                  |SIM           |
|NOME       |TEXTO NOME DO ALUNO           |TEXTO                  |SIM           |
|TURMA      |DADOS DA TURMA                |TEXTO                  |SIM           |
|SECRETARIA |DADOS DA SECRETARIA           |TEXTO                  |SIM           |

## Entidade 2

**PROFESSOR:**

```text

```

| Atributo | Informação armazenada   | Tipo de dado previsto | Obrigatório? |
|----------|-------------------------|-----------------------|--------------|
|NOME      |NOME DO PROFESSOR        |TEXTO                  |SIM           |
|CPF       |CPF DO PROFESSOR         |TEXTO                  |SIM           |
|EMAIL     |EMAIL DO PROFESSOR       |TEXTO                  |SIM           |
|TEFONE    |TELEFONE DO PROFESSOR    |TEXTO                  |SIM           |
|DISCIPLINA|DISCIPLINA DO PROFESSOR  |TEXTO                  |SIM           |

## Entidade 3

**DISCIPLINA:**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|CODIGO  |CODIGO DA DISCIPLINA |TEXTO |SIM |
|NOME  |NOME DA DICIPLINA  |TEXTO |SIM |
|CARGA HORARIA  |CARGA HORARIA DA DICIPLINA  |INTEIRO  |SIM  |
|DESCRIÇÃO  |DESCRIÇÃO DA DICIPLINA  |TEXTO |SIM  |
|PROFESSOR RESPONSAVEL  |NOME DO PROFESSOR RESPONSAVEL  |TEXTO |SIM |

## Entidade 4

**TURMA:**

```text

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|----------|-----------------------|-----------------------|--------------|
|CODIGO    |CODIGO DA TURMA        |TEXTO                  |SIM           |
|ATRIBUTO  |NOME DA TURMA          |TEXTO                  |SIM           |
|TURNO     |TURNO DA TURMA         |TEXTO                  |SIM           |
|ATRIBUTO  |ATRIBNUTO DA TURMA     |TEXTO                  |SIM           |
|SALA      |SALA DA TURMA          |TEXTO                  |SIM           |

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

| Entidade/Tabela | Chave primária prevista | Justificativa                           |
|-----------------|-------------------------|-----------------------------------------|
|ALUNO            |MATRICULA                |IDENTIFICA CADA ALUNO DE FORMA UNICA     |
|PROFESSOR        |CPF                      |IDENTIFICA CADA PROFESSOR DE FORMA UNICA |
|DICIPLINA        |CODIGO                   |IDENTIFICA CADA DICIPLINA DE3 FORMA UNICA|
|TURMA            |CODIGO                   |IDENTIFICA CADA ALUNO DE FORMA UNICA     |

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
Aluno pertence a turma
Professor ministra a disciplina
Turma cursa diciplina
```

### Relacionamentos planejados

| Entidade A | Relacionamento | Entidade B |
|------------|----------------|------------|
|ALUNO       |PERTENCE        |DICIPLINA   |
|PROFESSOR   |CURSA           |DICIPLINA   |
|ALUNO       |REALISA         |MATRICULA   |
|MATRICULA   |REFERENTE       |DICIPLINA   |
|PROFESSOR   |LECION          |DICIPLINA   |

---

# 10. Cardinalidade inicial

Utilize:

```text
1:1  → um para um
1:N  → um para muito
N:N  → muitos para muitos
```

| Relacionamento                | Cardinalidade prevista | Justificativa                                  |
|-------------------------------|------------------------|------------------------------------------------|
|ALUNO PERTENCE A DICIPLINA     |N:N                     |UM ALUNO PODE PERTENCER A VARIAS DICIPLINAS     |
|PROPFESSOR LECIONA DISCIPLINA  |1:N                     |UM PARA MUITOS                                  |
|ALUNO REALIZA MATRICULA        |1:N                     |UM PARA MUITOS                                  |
|MATRICULA REFENRETE A DICIPLINA|N:1                     |VARIAS MATRICULAS PODEM SER DA MESMA DICIPLINA  |

---

# 11. Chaves estrangeiras previstas
 
| Tabela   | Atributo previsto como FK        |Referencia qual tabela?|
|----------|----------------------------------|-----------------------|
|MATRICULA |ID ALUNO COMO CHAVE ESTRAGEIRA    |TABELA ALUNO           |
|MATRICULA |ID DICIPLINA COMO CHAVE ESTRAGEIRA|TABELA DICIPLINA       |
|DICIPLINA |ID PROFESSOR COMO CHAVE ESTRAGEIRA|TABELA PROFESSOR       |
|          |                                  |                       |

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

| Tabela   | Atributo     | Restrição prevista           | Motivo                                                                                                    |
|----------|--------------|------------------------------|-----------------------------------------------------------------------------------------------------------|
|ALUNO     |ID ALUNO      |PRIMARY KEY                   |IDENTIFICA CADA ALUNO DE FORMA UNICA                                                                       |
|PROFESSOR |ID PROFESSOR  |PRIMARY KEY                   |IDENTIFICA CADA DICIPLINA DE FORMA UNICA                                                                   |
|DICPLINA  |ID DICIPLINA  |PRIMARY KEY                   |IDENTIFICA CADA DICIPLINA DE FORMA UNICA                                                                   |
|MATRICULA |ID MATRICULA  |PRIMARY KEY                   |IDENTIFICA CADA MATRICULA DE FORMA UNICA                                                                   |
|ID ALUNO  |ID DICIPLINA  |PRIMARY KEY PARA ID MATRICULA |Identifica cada aluno de forma única, permitindo relacionar matrículas ao aluno e à disciplina corretamente|

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

1. UM ALUNO PODE ESTAR MATRICULADO EM VARIAS DICIPLINAS
2. UMA DICIPLINA P´DODE TER VARIOS ALUNOS MATRICULADOS
3. CADA MATRICULA DEVE ESTAR VINCULADA A UM ALUNO VINCULADA E A UMA DICIPLINA
4. UM PROFESSOR PODE LECIONAR MAIS DE UMA DICIPLINA  
5. CADA DICIPLINA DEVE POSSUIR UM PROFESSOR RESPONSAVEL

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
ALUNO
├── id_aluno (PK)
├── nome
└── email

PROFESSOR
├── id_professor (PK)
└── nome

DICIPLINA
├── id_diciplina (PK)
├── nome
└── id_professor (FK)

MATRICULA
├── id_matricula (PK)
├── id_aluno (FK)
└── id_diciplina (FK)

PROFESSOR 1 ───── N DICIPLINAS
ALUNO     1 ───── N MATRICULAS
DICIPLINA 1 ───── N MATRICULAS



```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. REGISTROS DE ALUNO
2. REGISTROS DE PROFESSORES
3. REGISTROS DE DICIPLINAS
4. REGISTROS DE MATRICULAS

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

1. QUAIS ALUNOS QUE ESTÃO CADASTRADOS NO SISTEMAS
2. QUAIS PROFESSORES ESTÃO CADASTRADOS
3. QUAIS DICIPLINAS CADA PROFESSOR LECIONA
4. QUAIS DICIPLINAS EM QUE CADA ALUNO ESTA MATRICULADO
5. QUANTOS ALUNOS ESTÃO MATRICULADOS EM CADA DICIPLINA

---

# 17. Decisões e dúvidas pendentes

- NENHUMA DUVIDA PENDENTE NO MOMENT0
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
