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

> Walter Anacleto Salido de Souza

**Nome escolhido para o banco de dados:**

```
db_raaei
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

> Gestão de Atletas e Colaboradores da Rondonópolis Associação de Atletismo e Esporte Inclusivo (RAAEI)

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> 1. O sistema gerencia as informações cadastrais, esportivas e institucionais da RAAEI, facilitando o acompanhamento dos atletas, suas categorias competitivas, instituições de ensino e a atuação dos colaboradores e diretoria. 
> 2. A administração da associação, treinadores e a tesouraria/secretaria para fins de controle interno e prestação de contas.
> 3. Dados pessoais dos participantes (nome, CPF, data de nascimento, filiação, endereço), vínculo escolar, categorias de atletismo (provas e faixas etárias) e registros de colaboradores/diretoria.
> 4. Cadastros completos, consultas filtradas por escola ou categoria, atualizações cadastrais e relatórios estatísticos de participação.

---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> Centralizar e automatizar o controle interno dos dados dos participantes, atletas e colaboradores do projeto esportivo, garantindo a integridade informacional para suporte a decisões da diretoria e relatórios de desempenho.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Pesquisa rápida de dados cadastrais de atletas e colaboradores.
2. Consulta individual de dados específicos (histórico, filiação, endereço e contatos).
3. Controle e vínculo das escolas em que os atletas estão matriculados.
4. Controle de categorias de cada atleta por idade e modalidade de atletismo.

---

# 6. Identificação das entidades

Identifique as principais entidades necessárias para representar o sistema.

Uma entidade representa algo sobre o qual o banco precisa armazenar informações.

Exemplos:

```text
Nome
Cpf
Data de Nascimento
Nome da Mãe
Nome do Pai
Endereço
Escola em que esta matriculado
```


### Entidades do seu banco

| Nº | Entidade | O que representa? |
|---:|---|---|
| 1 | Escola | Instituição de ensino onde o atleta estuda, armazenando nome, rede (pública/privada) e localização. |
| 2 | Categoria | Faixa etária e/ou modalidade do atletismo (ex: Sub-16, Sub-18, Adulto, PCD) na qual o atleta está inscrito. |
| 3 | Atleta | Participante da associação, contendo dados pessoais (nome, CPF, data de nascimento, filiação, endereço), além de referências para sua Escola e Categoria. |
| 4 | Colaborador | Membro da diretoria, técnico ou voluntário atuante na associação (incluindo cargos administrativos e técnicos). |
| 5 | Modalidade Provas | Especifica as provas de atletismo praticadas (ex: lançamento de dardo, arremesso de peso, corridas de velocidade, saltos) associadas ao atleta. |
| 6 | Registro Atividades | Histórico de participação ou desempenho dos atletas nas atividades e treinamentos da associação. |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```
Escola
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|

| id_escola	| Identificador único da escola | (Chave Primária) | Inteiro (INT) | Sim (PK)

| nome_escola | Nome da instituição de ensino | Texto (VARCHAR) | Sim

| tipo_rede | Rede de ensino (Pública ou Privada) | Texto (VARCHAR) | Sim

| bairro | Bairro onde a escola está localizada | Texto (VARCHAR) |Não

| cidade | Município da escola | Texto (VARCHAR) | Sim

## Entidade 2

**Nome da entidade:**

```
Categoria
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_categoria | Identificador único da categoria (Chave Primária) | Inteiro (INT) | Sim (PK) 

| nome_categoria | Nome da categoria (ex: Sub-16, Sub-18, Adulto, PCD) | Texto (VARCHAR) | Sim

| idade_minima | Idade mínima permitida na categoria | Inteiro (INT) | Sim

| idade_maxima | Idade máxima permitida na categoria | Inteiro (INT) | Sim

| genero_categoria | Gênero da categoria (Masculino, Feminino, Misto) | Texto (VARCHAR) | Sim


## Entidade 3

**Nome da entidade:**

```
Atleta
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_atleta | Identificador único do atleta (Chave Primária) | Inteiro (INT) | Sim (PK)

| nome_completo | Nome completo do atleta | Texto (VARCHAR) | Sim

| cpf | Número de CPF do atleta | Texto/Char (VARCHAR) | Sim

| data_nascimento | Data de nascimento do atleta | Data (DATE) | Sim

| nome_mae | Nome da mãe do atleta | Texto (VARCHAR)| Não

| nome_pai | Nome do pai do atleta | Texto (VARCHAR) | Não

| endereco | Endereço residencial do atleta | Texto (VARCHAR) | Sim

| id_escola | Referência à escola em que estuda (Chave Estrangeira) | Inteiro (INT) | Sim

| id_categoria | Referência à categoria do atleta (Chave Estrangeira) | Inteiro (INT) | Sim

## Entidade 4

**Nome da entidade:**

```
Colaborador
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_colaborador | Identificador único do colaborador (Chave Primária) | Inteiro (INT) Sim (PK)

| nome_completo | Nome completo do colaborador ou dirigente | Texto (VARCHAR) | Sim

| cpf | Número de CPF do colaborador | Texto/Char (VARCHAR) | Sim

| cargo_funcao | Cargo ou função exercida (ex: Presidente, Tesoureiro, Treinador) | Texto (VARCHAR) | Sim

| telefone | Número de telefone/WhatsApp para contato | Texto (VARCHAR) | Sim

| data_cadastro | Data de início ou registro na associação | Data (DATE) | Sim



# 8. Chaves primárias

Cada tabela deverá possuir uma forma de identificar unicamente seus registros.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|

| Escola | id_escola | Identificador numérico exclusivo que evita duplicidade caso existam escolas com nomes ou bairros semelhantes. Será configurado com AUTO_INCREMENT.

| Categoria | id_categoria | Chave numérica sequencial (AUTO_INCREMENT) para garantir a unicidade de cada categoria e faixa etária cadastrada, facilitando o relacionamento com os atletas.

| Atleta | id_atleta | Identificador numérico sequencial (AUTO_INCREMENT) único para cada atleta. Embora o CPF também seja único, o uso de um ID numérico interno é a melhor prática para chave primária em bancos relacionais.

| Colaborador | id_colaborador | Chave numérica primária (AUTO_INCREMENT) que identifica unicamente cada membro da diretoria, técnico ou colaborador da associação no sistema.

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

| Escola | possui | Atleta

| Categoria | agrupa | Atleta

| Colaborador | coordena / gerencia | Atleta

| Colaborador | atua em | Escola

| Atleta | participa de | Categoria
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

|Escola e Atleta | 1:N | Uma escola pode possuir vários atletas matriculados, mas cada atleta individualmente está associado a apenas uma escola principal por vez.

| Categoria e Atleta | 1:N | Uma categoria (ex: Sub-16, Adulto) abrange vários atletas, enquanto cada atleta pertence a uma categoria específica de acordo com sua faixa etária/modalidade.

| Colaborador e Atleta | 1:N| Um colaborador (como um técnico ou treinador) orienta e gerencia vários atletas, e cada atleta é acompanhado por um ou mais responsáveis técnicos/colaboradores da associação.

| Colaborador e Escola | N:N | Um colaborador pode atuar ou representar a associação em múltiplas escolas parceiras, e uma escola pode receber visitas ou atletas orientados por diferentes colaboradores da RAAEI.

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|

| Atleta | id_escola | Escola (id_escola)

| Atleta | id_categoria | Categoria (id_categoria)

| Atleta | id_colaborador | Colaborador (id_colaborador)

| Colaborador_Escola (tabela associativa opcional para N:N) | id_escola e id_colaborador | Escola (id_escola) e Colaborador (id_colaborador)


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

| Escola | id_escola | PRIMARY KEY, AUTO_INCREMENT | Identifica unicamente cada escola de forma automática e sequencial.

| Categoria | id_categoria | PRIMARY KEY, AUTO_INCREMENT | Garante a unicidade de cada categoria cadastrada.

| Atleta | id_atleta | PRIMARY KEY, AUTO_INCREMENT | Atribui um identificador exclusivo para cada atleta registrado.

| Atleta | cpf | UNIQUE, NOT NULL | Evita cadastros duplicados do mesmo atleta e garante que o documento seja obrigatório.

| Colaborador | id_colaborador | PRIMARY KEY, AUTO_INCREMENT | Assegura a identificação unívoca de cada membro ou colaborador da associação.


---

# 13. Regras de negócio

Defina pelo menos **5 regras de negócio** para o sistema.


### Regras do seu banco

1. Um atleta não pode possuir dois cadastros ativos com o mesmo CPF. (Garante a unicidade da pessoa no sistema através do documento de identificação).
2. Todo atleta cadastrado deve estar obrigatoriamente vinculado a uma escola e a uma categoria válidas. (Assegura que nenhum participante fique sem referências institucionais ou de faixa etária/modalidade).
3. Um colaborador (como treinador ou dirigente) não pode possuir cargo em branco ou não especificado. (Garante a clareza sobre as funções exercidas na associação).
4. A data de nascimento do atleta deve resultar em uma idade compatível com a faixa etária permitida na categoria escolhida. (Evita que um atleta seja inscrito em uma categoria inadequada para sua idade).
5. Nenhum registro principal (Escola, Categoria, Atleta ou Colaborador) pode ser excluído caso existam dependências atreladas a ele. (Garante a integridade referencial e evita órfãos no banco de dados).

---

# 14. Esboço da estrutura do banco

Faça uma representação textual inicial das tabelas e relacionamentos.


### Esboço do seu banco

```
ESCOLA
├── id_escola (PK)
├── nome_escola
├── tipo_rede
├── bairro
└── cidade

CATEGORIA
├── id_categoria (PK)
├── nome_categoria
├── idade_minima
├── idade_maxima
└── genero_categoria

COLABORADOR
├── id_colaborador (PK)
├── nome_completo
├── cpf
├── cargo_funcao
├── telefone
└── data_cadastro

ATLETA
├── id_atleta (PK)
├── nome_completo
├── cpf
├── data_nascimento
├── nome_mae
├── nome_pai
├── endereco
├── id_escola (FK)
└── id_categoria (FK)

RELACIONAMENTOS:
ESCOLA      1 ───── N ATLETA
CATEGORIA   1 ───── N ATLETA
COLABORADOR 1 ───── N ATLETA  (Orientação / Acompanhamento Técnico)
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Escolas parceiras da rede pública e privada de Rondonópolis, contendo nomes de instituições de ensino locais, redes de ensino e bairros para a vinculação correta dos estudantes.
2. Categorias oficiais de atletismo e faixas etárias (como Sub-14, Sub-16, Sub-18 e Adulto, tanto no masculino quanto no feminino) para a segmentação dos participantes.
3. Registros cadastrais completos de atletas da RAAEI, com nomes, CPFs válidos, datas de nascimento, filiação, endereços e as respectivas chaves estrangeiras vinculando-os à escola e à categoria correspondentes.
4. Cadastros da equipe técnica e administrativa (colaboradores), especificando os cargos exercidos na associação (como presidente, tesoureiro e treinadores) junto aos seus contatos e datas de ingresso.

---

# 16. Perguntas que o banco deverá ser capaz de responder

Defina pelo menos **5 perguntas** que futuramente deverão ser respondidas por consultas SQL.


### Perguntas do seu projeto

1. Quais são todos os atletas cadastrados e em quais escolas públicas ou privadas eles estudam? (Consulta com JOIN entre Atleta e Escola)
2. Quantos atletas estão cadastrados em cada categoria de atletismo? (Consulta com agrupamento GROUP BY e função de agregação COUNT)
3. Quais atletas pertencem a uma faixa etária ou categoria específica, como o Sub-16? (Consulta com filtro WHERE na tabela de Categoria)
4. Quais colaboradores exercem funções de treinador ou diretoria na associação? (Consulta com filtro de cargo na tabela Colaborador)
5. Qual é o quantitativo total de atletas atendidos por cada escola parceira da RAAEI? (Consulta com agregação e relacionamento entre Escola e Atleta)

---

# 17. Decisões e dúvidas pendentes

Decisão 1: Uso de chaves primárias numéricas auto-incrementais (AUTO_INCREMENT) em todas as tabelas para garantir estabilidade e melhor performance nos relacionamentos.

Decisão 2: Armazenamento do CPF com restrição UNIQUE e NOT NULL para assegurar a unicidade e obrigatoriedade do documento dos atletas e colaboradores.

Decisão 3: Estruturação inicial focada nas 4 principais tabelas essenciais (Escola, Categoria, Atleta e Colaborador), mantendo a escalabilidade para as próximas Sprints.

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
