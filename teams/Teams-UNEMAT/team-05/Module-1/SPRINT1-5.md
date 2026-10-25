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

> Ylma Cristina Souza Lopes.

**Nome escolhido para o banco de dados:**

```Clinica

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

> Escreva aqui.
Clinica_Ser

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

>Ele é a representação de uma clinica que realiza exames radiologicos, apenas colaboradores e diretoria, Nome completo, data de nascimento, telefone, sexo, cpf e imgens.
Pesquisa, arquivamento de imagens em jpg, laudos em pdf e agendamento.
---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

>  Este banco de dados será responsável por armazenar e organizar os dados cadastrais básicos dos pacientes atendidos pela clinica.
essas informações identificam de forma única cada cidadão dentro do sistema e servem como base para os demais módulos operacionais presentes, como agendamento
exames, laudos e resultados. O cadastro de pacientes é o ponto de partida de qualquer atendimento: sem ele, nenhum outro módulo consegue vincular um serviço e uma pessoa especifica. 

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Nome
2. Telefone
3. Data de nascimento
4. Permição de acesso para anexo
5. Pesquisa

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
| 1 | Paciente | Pessoa que realiza os exames |
| 2 | Médico | Profissional responsável por solicitar ou interpretar exames|
| 3 | Exame | Procedimento radiológico realizado |
| 4 | Agendamento  | Registro da data e hora do exame |
| 5 | Resultado  | Laudo e imagens gerados após o exame |
| 6 | Convênio | Plano de saúde ou forma de pagamento |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```text

```Paciente

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|id_paciente|Identificador único|Inteiro|Sim|
|nome  |Nome Completo  |Texto  | Sim |
|cpf  | Documento de identificação  |Texto  |Sim  |
|data_nascimento  |Data de nascimento  |Data  |Sim  |
|telefone  |Contato  |Texto  |Sim  |
|  |  |  |  

## Entidade 2

**Nome da entidade:**

```text

```Médico

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_medico  |Identificador único  |Inteiro  | Sim  |
|nome  |Nome completo  |Texto  |Sim  |
|Cro  |Registro profissional  |Texto  |Sim  |
|telefone  |Contato  |Texto  |Sim  |
|endereço  |Endereço profissional  |Texto  |Sim  |

## Entidade 3

**Nome da entidade:**

```text

```Exame

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_exame  |identificador único  |Inteiro  | Sim  |
|tipo_exame  |Tipo (Raio-X, Tomografia, Modelo,Fotos)  |Texto  |Sim  |
|descrição  |Detalhes do exame  |Texto  |Sim  |
|preco  |Valor do exame  |Decimal  | Sim  |
|  |  |  |  |

## Entidade 4

**Nome da entidade:**

```text

```Agendamento

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
|id_agendamento  |Identificador único  |Inteiro  |Sim  |
|id_paciente  |Paciente vinculado  |Inteiro(FK)  |Sim  |
|id_exame  |Exame vinculado  |Inteiro(FK)  |Sim  |
|data_hora  |Data e hora do exame  |Data/Hora  |Sim  |
|id_medico  |Médico solicitante  |Inteiro(FK)  |Sim  |

## Outras entidades

Caso o projeto possua mais de quatro entidades, registre-as abaixo.

| Entidade | Principais atributos |
|---|---|
|Resultado  |id_paciente, id_exame, laudo_texto, imagem_url, data_emissao  |
|Convenio  |id_convenio, nome_conveno, tipo_plano, cobertura  |
|  |  |

---

# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|Paciente|id_paciente|Identificador único, numérico, AUTO_INCREMENT para evitar duplicidade de pacientes|
|médico  |id_medico  |Cada médico precisa de um identificador exclusivo, numérico e sequencial  |
|Exame  |id_exame  | Garante que cada tipo de exame seja único, mesmo que nomes se repitam |
|Agendamento  |id_agendamento  |Cada agendamento é único, precisa de chave numérica sequencial  |
|Resultado  |id_resultado  |Cada laudo é único, vinculado a um exame específico  |
|Convênio  |id_convenio  |Identificador único para cada plano de saúde  |


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
|Paciente  |realiza  | Agendamento |
|Agendamento  | refere-se a | Exame |
|Médico  | solicita |Agendamento  |
|Exame  |gera  |Resultado  |
|Paciente  |possui  |Convênio  |

---

# 10. Cardinalidade inicial

Utilize:

```text
1:1  → um para um
1:N  → um para muitos
N:N  → muitos para muitos
```

| Relacionamento | Cardinalidade prevista | Justificativa |
|Paciente → Agendamento|1:N|Um paciente pode ter vários agendamentos, mas cada agendamento pertence a um único paciente|
|Agendamento → Exame  | 1:1  |Cada agendamento refere-se a um exame específico  |
|Médico → Agendamento  | 1:N  | Um médico pode solicitar vários exames, mas cada agendamento tem apenas um médico solicitante |
|Exame → Resultado  | 1:1 |Cada exame gera um resultado único  |
|Paciente → Convênio  | N:1 | Vários pacientes podem estar vinculados ao mesmo convênio |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|Agendamento|id_paciente|Paciente|
|Agendamento  |id_exame  |Exame  |
|Agendamento  |id_medico  |Médico  |
|Resultado  |id_exame  |Exame  |
|Paciente  |id_convenio  |Convênio  |

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
|Paciente|id_paciente|PRIMARY KEY, AUTO_INCREMENT|Identificação única de cada paciente
|Paciente|cpf  |UNIQUE, NOT NULL  | Evitar duplicidade de cadastros |
|Médico  |id-medico  |PRIMARY KEY, AUTO_INCREMENT  |Identificação única de cada médico  |
|Exame  |id_exame  |PRIMARY KEY, AUTO_INCREMENT  |Cada exame precisa ser único  |
|Exame  |preco  |NOT NULL  |Não pode existir exame sem preço  |
|agendamento  |id_agendamento  |PRIMARY KEY, AUTO_INCREMENT  |Cada agendamento é único  |
|Agendamento  |id_paciente, id_exame, id_medico  |FOREIGN KEY  | Garantir integridade referencial  |
|Resultado  |id_resultado  |PRIMARY KEY, AUTO_INCREMENT  | Cada laudo é único |
|Resultado  |id_exame  |FOREIGN KEY  |Associar resultado ao exame correto  |
|Convênio  |id_convenio  | PRIMARY KEY, AUTO_INCREMENT |Identificação única de cada convênio  |

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
2. Um agendamento deve estar associado a um paciente existente.
3. Um exame não pode possuir preço negativo.
4. Um resultado deve estar vinculado a um exame realizado.
5. Um paciente pode estar associado a apenas um convênio por vez.

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
Escreva aqui a estrutura planejada.
```PACIENTE
├── id_paciente (PK)
├── nome
├── cpf (UNIQUE)
├── data_nascimento
├── telefone
├── endereco
└── id_convenio (FK)

MÉDICO
├── id_medico (PK)
├── nome
├── crm (UNIQUE)
├── especialidade
└── telefone

EXAME
├── id_exame (PK)
├── tipo_exame
├── descricao
└── preco

AGENDAMENTO
├── id_agendamento (PK)
├── id_paciente (FK)
├── id_exame (FK)
├── id_medico (FK)
└── data_hora

RESULTADO
├── id_resultado (PK)
├── id_exame (FK)
├── laudo_texto
├── imagem_url
└── data_emissao

CONVÊNIO
├── id_convenio (PK)
├── nome_convenio
├── tipo_plano
└── cobertura

PACIENTE 1 ───── N AGENDAMENTO  
MÉDICO 1 ───── N AGENDAMENTO  
EXAME 1 ───── 1 RESULTADO  
CONVÊNIO 1 ───── N PACIENTE


---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Pacientes cadastrados com nome, CPF e convênio.
2. Médicos com CRO e especialidade.
3. Exames disponíveis (Raio-X, Tomografia, Modelos, Fotos).
4. Agendamentos realizados com data e hora.
5.Resultados com laudos e imagens anexadas.
6.Convênios aceitos pela clínica.

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

1. Quais pacientes estão cadastrados na clínica?
2. Quantos agendamentos cada médico solicitou?
3. Qual é o convênio mais utilizado pelos pacientes?
4. Quais exames foram realizados em determinado período?
5. Quais resultados já foram emitidos para um paciente específico?

---

# 17. Decisões e dúvidas pendentes

- 
- 
- 

Caso não existam dúvidas:

> Nenhuma dúvida pendente nesta Sprint.

---Nenhuma dúvida

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
- [V] registrei dúvidas ou decisões pendentes;
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
