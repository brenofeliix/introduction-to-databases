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

> João Guilherme Barros de Lima.

**Nome escolhido para o banco de dados:**

```Real-states-database```

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

> Site de anúncios imobiliários.

---

# 3. Descrição do sistema

Explique brevemente o sistema que será representado pelo banco de dados.

A descrição deve responder:

1. Qual problema ou contexto o sistema representa?
2. Quem utilizaria esse sistema?
3. Quais informações principais precisarão ser armazenadas?
4. Quais operações o sistema deverá permitir?

### Descrição

> Esse é um sistema de anúncios de imóveis que será utilizado por corretores que queiram anunciar seu imóvel de forma fácil e rápida e por pessoas que estejam procurando imoveis para alugar ou comprar.
> O sistema será como um cardápio de imóveis sendo anunciados na pagina principal. Esse sistema contaram com informações como: titulo, valor, localização, quantidade de cômodos, imagens e um cadastro único e distinto de corretor e cliente armazenados em um banco de dados feito pelo MySQL.
> O sistema permitirá realizar um cadastro autenticado por e-mail. 
>
---

# 4. Objetivo do banco de dados

Explique qual é o principal objetivo do banco de dados proposto.

### Objetivo

> Armazenar os dados dos imoveis, corretores e clientes de forma segura.

---

# 5. Escopo inicial

Defina o que fará parte do banco de dados.

Liste as principais funcionalidades ou informações que deverão ser contempladas.

### O banco deverá permitir:

1. Cadastrar, alterar e excluir perfis de corretores e clientes.
2. Cadastrar imóveis com seus respectivos detalhes (valor, cômodos, localização).
3. Associar cada imóvel cadastrado a um corretor responsável.
4. Permitir que clientes demosntrem interesse/agendem uma visita para um imóvel específico.
5. Listar todos os imóveis disponíveis no "cardápio" principal.

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
| 1 | imovel | Representa o anúncio em si, contendo as características do local (valor, cômodos, localização). |
| 2 | cliente | Armazena os dados dos usuários comuns que acessarão o sistema para buscar imóveis. |
| 3 | corretor | Armazena os dados dos profissionais que criarão e gerenciarão os anúncios. |
| 4 | interesse | Representa a intenção de visita, ligando o cliente interessado ao imóvel anunciado. |
| 5 |  |  |
| 6 |  |  |

> Como referência para esta atividade, planeje **pelo menos 4 tabelas relacionadas**.

---

# 7. Planejamento dos atributos

Para cada entidade, identifique os principais atributos que deverão ser armazenados.

## Entidade 1

**Nome da entidade:**

```
Imovel
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_imovel | identificador único do anúncio | int | sim |
| id_corretor | identificador de qual corretor é o dono do anúncio | int | sim |
| titulo | chamada do anúncio (ex: "Casa com 3 quartos") | varchar | sim |
| valor | preço do imóvel para venda ou aluguel | decimal | sim |
| qunatidade_comodos | número total de cômodos do imóvel | int | sim |

## Entidade 2

**Nome da entidade:**

```
Cliente
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_cliente | Identificador único do cliente | int | sim |
| nome | Nome completo do cliente | varchar | sim |
| email | E-mail usado no cadastro e login | varchar | sim |
| senha | Senha de acesso ao sistema | varchar | sim |
| telefone | Número de contato do cliente | varchar | sim |

## Entidade 3

**Nome da entidade:**

```
Corretor
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_corretor | Identificador único do corretor | int | sim |
| nome | Nome completo do corretor | varchar | sim |
| creci | Número de registro do corretor (documento) | varchar | sim |
| email | E-mail para acesso ao sistema | varchar | sim |
| telefone | Número de contato celular/WhatsApp | varchar | sim |

## Entidade 4

**Nome da entidade:**

```
Agendamento
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_agendamento | Identificador único da visita | int | sim |
| id_cliente | Identificador de qual cliente quer visitar | int | sim |
| id_imovel | Identificador de qual imóvel será visitado | int | sim |
| data_visita | Dia e horário marcados para a visita | datetime | sim |
| status | Situação do agendamento (ex: Pendente, Confirmado) | varchar | sim |

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
| Corretor | id_corretor | Valor numérico único que identifica cada corretor. Não se repete e usará AUTO_INCREMENT. |
| Cliente | id_cliente | Valor numérico único que identifica cada cliente. Não se repete e usará AUTO_INCREMENT. |
| Imovel | id_imovel | Valor numérico único que identifica cada imóvel. Não se repete e usará AUTO_INCREMENT. |
| Agendamento | id_agendamento | Valor numérico único que identifica cada visita agendada. Não se repete e usará AUTO_INCREMENT. |

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
| Corretor | anuncia / é responsável por | Imovel |
| Cliente | realiza | Agendamento |
| Imovel | recebe | Agendamento |
|  |  |  |
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
| Corretor - Imovel | 1:N | Um corretor pode anunciar vários imóveis, mas cada imóvel é de responsabilidade de apenas um corretor. | 
| Cliente - Agendamento | 1:N | Um cliente pode marcar várias visitas (agendamentos), mas um agendamento específico pertence a um único cliente. |
| Imovel - Agendamento | 1:N | Um imóvel pode ter várias visitas agendadas (em dias/horários diferentes), mas cada agendamento é referente a apenas um imóvel. |
|  |  |  |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Imovel | id_corretor | Corretor |
| Agendamento | id_cliente | Cliente |
| Agendamento | id_imovel | Imovel |
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
| Corretor | email | UNIQUE | Não permitir dois corretores com o mesmo e-mail |
| Cliente | id_cliente | PRIMARY KEY | Identificar o cliente de forma única no sistema| 
| Imovel | valor| NOT NULL | Não permitir cadastro de imóvel sem um preço |
| Agendamento | status| DEFAULT | Preencher automaticamente o status como pendente |
| Imóvel | id_corretor | FOREIGN KEY | Garantir que o imóvel pertença a um corretor |

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

1. Um cliente não pode possuir dois cadastros utilizando o mesmo endereço de e-mail.
2. Um corretor não pode se cadastrar no sistema utilizando um número de CRECI já existente.
3. O valor cadastrado para um imóvel não pode ser negativo nem igual a zero.
4. Um agendamento deve estar obrigatoriamente associado a um cliente existente e a um imóvel existente.
5. Um imóvel não pode ser cadastrado sem ter um corretor responsável associado a ele.

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
CORRETOR
├── id_corretor (PK)
├── nome
├── creci
├── email
└── telefone

CLIENTE
├── id_cliente (PK)
├── nome
├── email
├── senha
└── telefone

IMOVEL
├── id_imovel (PK)
├── id_corretor (FK)
├── titulo
├── valor
├── quantidade_comodos
└── cidade

AGENDAMENTO
├── id_agendamento (PK)
├── id_cliente (FK)
├── id_imovel (FK)
├── data_visita
└── status

CORRETOR 1 ───── N IMOVEL
CLIENTE 1 ───── N AGENDAMENTO
IMOVEL 1 ───── N AGENDAMENTO
```

---

# 15. Dados que futuramente serão inseridos

Descreva que tipos de registros deverão existir no banco quando ele for populado.

1. Registros de corretores reais com nome, contato e número de CRECI.
2. Registros de clientes interessados em alugar ou comprar imóveis.
3. Cadastros de imóveis disponíveis (casas, apartamentos, terrenos) com seus respectivos valores e descrições.
4. Histórico de visitas agendadas, contendo a data, hora e a situação da visita (Pendente, Confirmado, Cancelado).

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

1. Quais imóveis estão cadastrados na cidade de Rondonópolis?
2. Quais imóveis custam menos de R$ 300.000,00?
3. Quantos agendamentos estão marcados para a próxima semana?
4. Quantos imóveis temos anunciados?
5. Quais clientes agendaram visitas para o imóvel de ID 50?

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
