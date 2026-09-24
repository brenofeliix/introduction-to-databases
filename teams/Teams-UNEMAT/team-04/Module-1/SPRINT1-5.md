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

> Marcos Aurélio Bastos Stanguerlin.

**Nome escolhido para o banco de dados:**

```
Rh_sorveteria
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

> Recusos Humanos de uma multifilial (sorveteria).

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> Um sistema de banco de dados que gerencia todos os funcionarios e suas funções dentro de uma sorveteria e açaiteria. Essa empresa possui multiplas filiais e com esse banco de dado buscamos estar organizando todos os dados relacionados aos funcioarios, seus cargos e permissões relacionadas ao cargo, carga horaria. Esse banco será utilizado pelo RH e Administração, em sua maior parte sera mais utilizado para verificação da ponto batido

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> Organizar e estruturar todos os dados dos funcionários da empresa. facilitar acesso esses dados e auxiliar durante o pagamento e fechamento de ponto no final do mês.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Puxar horaras trabalhadas do funcionario
2. Puxar o salario base do funcionario
3. Puxar qual o setor e filial de qualquer funcionario
4. Adicionar e atualizar dados dos funcionarios
5. Adicionar e verificar sobre horas extras dos colaboradores

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
|---|---|---|
| 1 | Funcionário | Funcionário no nível individual sem duplicamento |
| 2 | Cargo | Quais atividade o funcionário pratica na empresa |
| 3 | Setor | Em qual local o funcionário atua |
| 4 | Filial | Em qual cidade o funcionário trabalho |
| 5 | Estoque | Estoque interno da filial |
| 6 | Expediente | Horario trabalho pelo funcionario |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```Funcionário

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| Nome | Nome do funcionário | VARCHAR | SIM |
| data_nascimento | data de nascimento do func | INT | SIM |
| CPF_func | Cpf do func | VARCHAR | SIM |
| Tempo_empresa | Tempo de empresa do func | INT | SIM |
| Id_func | Id usado internamente do func | INT | SIM |
| id_cargo | Qual a funcao desse func na empresa | FK | SIM |

## Entidade 2

**Nome da entidade:**

```Filial

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| data_abertura | Quando foi aberta a filial | INT | SIM |
| Modulo | Qual o proposito da filial? (estoque, loja, adm, etc.) | VARCHAR | SIM |
| Localizacao | Aonde está localizado a filial | VARCHAR | SIM |
| Id_Filial | Id de identificação da filial | INT | SIM |
|  |  |  |  |

## Entidade 3

**Nome da entidade:**

```Expediente

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_expediente | Identificação da jornada de trabalho | PK | SIM |
| Func_funcionario | Qual a sua função na empresa | Chave_estrangeira | SIM |
| Jornada_trabalho | Qual foi a jornada realizada nesse dia | INT | SIM |
| Hora_extra | hora extra realizada em data especifica | INT | NÃO |
| Hora_extra_justificativa | Justificativa sobre hora extra | VARCHAR | NÃO |

## Entidade 4

**Nome da entidade:**

```Estoque

```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_estoque | Id do estoque |  |  |
| id_filial | Id da filial que está guardando o item | FK | SIM |
| id_produto | Id do produto | FK | SIM |
| Qtd_item | Quantidade do produto no estoque | INT | SIM |

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
| Funcionário | Id_func | Identificador do funcionario |
| Filial | id_filial | Identificador da filial |
| Expediente | id_expediente | Identificador da jornada de trabalho |
| Estoque | Id_estoque | Identificador do estoque em especifico |

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
| Funcionário | trabalaha em | Filial |
| Funcionário | exerce | Tablea de expediente |
| Filial | possui | estoque |
| Estoque | possui | Produtos |
|  |  |  |

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
| Funcionario - Filial | N:1 | Multiplos funcionarios trabalham em cada filial |
| Funcionario - Expediente | 1:N | Cada funcionario possuie um expediente a comprir |
| Filial - Estoque | 1:1 | Todas as filials precisam de um estoque de materiais |
| Produto - Estoque | N:N | Um produto pode existir em multiplos estoques diferentes |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Funcionario | id_filial id_cargo id_setor | Filial, Cargo e Setor |
| Expediente | Id_func | Funcionario |
| Estoque | id_filial id_produto | Filial e Filiais |
|  |  |  |

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
| id_fun - id_estoque - id_item - id_expediente | Primary Key AUTO_INCREMENT UNIQUE | NOT NULL | Ids propostos como PK, sempre incrementão e não são nulos |
| Jornada_trabalho | AUTO_INCREMENT DEFAULT (0) |  | Caso não seja adicionado valor, ele não trabalhou, volta para default 0 |
| Func_funcionario |  | NOT NULL | Sempre deve haver um valor dentro dessa chave |
|  |  |  |  |
|  |  |  |  |

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

1. Hora extra deve sempre ser adicionada com justificativa
2. Funcionario não deve existir sem todos os dados preenchidos
3. Filiais não devem existir sem um modulo
4. Nenhum ID deve ser duplicado
5. Hora extra deve ser apenas preenchida caso o horario trabalhado seja maior que o expediente da função

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
FUNCIONARIO
├── id_func (PK)
├── nome
├── cpf
├── data_nascimento
├── data_admissao
├── id_cargo (FK)
├── id_setor (FK)
└── id_filial (FK)

Filial
├── id_filial (PK)
├── Moludo
├── Localizaação
└── QTD_Funcionario

CARGO
├── id_cargo (PK)
├── nome_cargo
├── salario_base
└── carga_horaria

EXPEDIENTE
├── id_expediente (PK)
├── id_funcionario (FK)
├── data
├── hora_entrada
├── hora_saida
├── hora_extra
└── justificativa_hora_extra

PRODUTO
├── id_produto
├── nome
└── unidade_medida

ESTOQUE
├── id_estoque
├── id_filial
├── id_produto
└── quantidade
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Dados pessoais dos funcionarios
2. Dados base referente a profissão exercida pelos funcionarios
3. Dados relacionados aos locais de trabalho
4. Dados referente aos items dentro das filiais

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

1. Quem Foi contratado no dia 1° de setembro?
2. Quantos funcionarios foram contratados no ultimo mês?
3. Quantas filiais foram abertas nos ultimos 4 anos?
4. Quem fez mais de 50 horas extras nesse ano?
5. Quais items estão quase acabando no estoque?

---

# 17. Decisões e dúvidas pendentes

- Nenhuma dúvida pendente nesta Sprint.
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
