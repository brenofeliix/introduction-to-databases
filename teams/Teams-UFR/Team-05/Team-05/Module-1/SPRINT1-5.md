# SPRINT 1/5 — Planejamento do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados  
**Data:** 31/08/2026  
**Modalidade:** Atividade individual  

---

# Objetivo da Sprint 1/5

Nesta primeira etapa, cada aluno deverá **planejar individualmente um banco de dados completo**, que será desenvolvido de forma incremental ao longo das cinco Sprints.

---

# 1. Identificação do aluno

**Nome completo:**

> NICOLAS LINO OLIVEIRA

**Nome escolhido para o banco de dados:**
Banco_de_Imobiliária

---

# 2. Tema do banco de dados

### Tema escolhido

> Gestão de Imobiliária (Corretores de Imóveis)

---

# 3. Descrição do sistema

### Descrição

> 1. O contexto é a gestão de uma imobiliária. Normalmente isso é feito de forma manual, com planilhas ou WhatsApp. Com o sistema, o objetivo é deixar esse processo mais automático e organizado.
> 2. Gestores e corretores de uma imobiliária.
> 3. Imóveis, Clientes, Corretores, Visitas, Propostas, Contratos e Gestões (histórico de qual corretor gerencia cada imóvel).
> 4. O sistema deverá permitir:
> - Cadastrar, editar e remover imóveis, clientes e corretores;
> - Agendar, remarcar e cancelar visitas;
> - Registrar propostas e atualizar seu status;
> - Fechar contratos vinculando cliente + imóvel + corretor;
> - Consultar imóveis por filtros (preço, bairro, tipo, status);
> - Gerar relatórios: histórico de visitas por cliente, comissões por corretor, imóveis vendidos vs. disponíveis.

---

# 4. Objetivo do banco de dados

### Objetivo

> Organizar a gestão de uma imobiliária de forma digital, moderna e automatizada, substituindo o controle manual feito em planilhas ou WhatsApp.

---

# 5. Escopo inicial

### O banco deverá permitir:

1. Cadastro de imóveis, clientes e corretores
2. Agendamento e controle de visitas
3. Registro e acompanhamento de propostas
4. Fechamento de contratos (venda/aluguel)
5. Consultas e relatórios (imóveis por filtro, comissões, histórico de visitas)

---

# 6. Identificação das entidades

| Nº | Entidade | O que representa? |
|---:|---|---|
| 1 | Imoveis | Cada imóvel disponível para venda ou aluguel |
| 2 | Clientes | Pessoas interessadas em comprar ou alugar |
| 3 | Corretores | Profissionais responsáveis pelos imóveis |
| 4 | Visitas | Agendamentos de visita a um imóvel por um cliente |
| 5 | Propostas | Ofertas de valor feitas por clientes a um imóvel |
| 6 | Contratos | Registro do fechamento de venda/aluguel |
| 7 | Gestoes | Histórico de qual corretor gerencia cada imóvel ao longo do tempo |

---

# 7. Planejamento dos atributos

## Entidade 1

**Nome da entidade:**
Imóveis

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_imovel | identificador único | INT | Sim |
| endereco | endereço do imóvel | VARCHAR | Sim |
| tipo | casa/apto/terreno | VARCHAR | Sim |
| preco | valor do imóvel | DECIMAL | Sim |
| status | disponível/vendido/alugado | VARCHAR | Sim |

## Entidade 2

**Nome da entidade:**
Clientes

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_cliente | identificador único | INT | Sim |
| nome | nome completo | VARCHAR | Sim |
| contato | telefone/e-mail | VARCHAR | Sim |
| tipo_interesse | compra/aluguel | VARCHAR | Não |
| orcamento | valor disponível | DECIMAL | Não |

## Entidade 3

**Nome da entidade:**
Corretores
| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_corretor | identificador único | INT | Sim |
| nome | nome completo | VARCHAR | Sim |
| creci | registro profissional | VARCHAR | Sim |
| comissao_percentual | % de comissão | DECIMAL | Sim |

## Entidade 4

**Nome da entidade:**
VIsitas

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| id_visita | identificador único | INT | Sim |
| id_cliente | referência ao cliente | INT (FK) | Sim |
| id_imovel | referência ao imóvel | INT (FK) | Sim |
| data_visita | data agendada | DATE | Sim |
| status | confirmada/cancelada/realizada | VARCHAR | Sim |

## Outras entidades

| Entidade | Principais atributos |
|---|---|
| Propostas | id_proposta (PK), id_cliente (FK), id_imovel (FK), valor_proposto, data, status |
| Contratos | id_contrato (PK), id_imovel (FK), id_cliente (FK), id_corretor (FK), valor_final, tipo, data_fechamento |
| Gestoes | id_gestao (PK), id_imovel (FK), id_corretor (FK), data_inicio, data_fim |

---

# 8. Chaves primárias

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| Imoveis | id_imovel | Identificador numérico único, AUTO_INCREMENT |
| Clientes | id_cliente | Identificador numérico único, AUTO_INCREMENT |
| Corretores | id_corretor | Identificador numérico único, AUTO_INCREMENT |
| Visitas | id_visita | Identificador numérico único, AUTO_INCREMENT |
| Propostas | id_proposta | Identificador numérico único, AUTO_INCREMENT |
| Contratos | id_contrato | Identificador numérico único, AUTO_INCREMENT |
| Gestoes | id_gestao | Identificador numérico único, AUTO_INCREMENT |

---

# 9. Relacionamentos entre as entidades

| Entidade A | Relacionamento | Entidade B |
|---|---|---|
| Corretores | gerencia | Imoveis |
| Clientes | realiza | Visitas |
| Imoveis | recebe | Visitas |
| Clientes | faz | Propostas |
| Imoveis | recebe | Propostas |
| Contratos | vincula | Imoveis, Clientes, Corretores |
| Corretores | possui histórico em | Gestoes |
| Imoveis | possui histórico em | Gestoes |

---

# 10. Cardinalidade inicial

| Relacionamento | Cardinalidade prevista | Justificativa |
|---|---|---|
| Corretor → Imóvel | 1:N | Um corretor pode gerenciar vários imóveis atualmente |
| Cliente → Visita | 1:N | Um cliente pode agendar várias visitas |
| Imóvel → Visita | 1:N | Um imóvel pode receber várias visitas |
| Cliente → Proposta | 1:N | Um cliente pode fazer várias propostas |
| Corretor → Gestão | 1:N | Um corretor pode ter gerenciado vários imóveis ao longo do tempo |
| Imóvel → Gestão | 1:N | Um imóvel pode ter tido vários corretores ao longo do tempo, mas só um por vez |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| Imoveis | id_corretor | Corretores |
| Visitas | id_cliente | Clientes |
| Visitas | id_imovel | Imoveis |
| Propostas | id_cliente | Clientes |
| Propostas | id_imovel | Imoveis |
| Contratos | id_imovel | Imoveis |
| Contratos | id_cliente | Clientes |
| Contratos | id_corretor | Corretores |
| Gestoes | id_imovel | Imoveis |
| Gestoes | id_corretor | Corretores |

---

# 12. Restrições de integridade previstas

| Tabela | Atributo | Restrição prevista | Motivo |
|---|---|---|---|
| Corretores | creci | UNIQUE | Não pode haver dois corretores com o mesmo registro |
| Imoveis | preco | NOT NULL | Todo imóvel precisa ter valor definido |
| Imoveis | status | DEFAULT 'disponível' | Todo imóvel nasce disponível |
| Visitas | id_cliente, id_imovel | NOT NULL, FOREIGN KEY | Visita só existe ligada a cliente e imóvel reais |
| Contratos | valor_final | NOT NULL | Contrato precisa ter valor fechado |
| Gestoes | data_fim | DEFAULT NULL | Gestão ativa não possui data de encerramento |

---

# 13. Regras de negócio

1. Um imóvel não pode ter status "vendido" sem um contrato associado.
2. Um corretor não pode ter dois cadastros com o mesmo CRECI.
3. Uma visita deve estar associada a um cliente e um imóvel existentes.
4. Uma proposta não pode ter valor menor ou igual a zero.
5. Um contrato só pode ser criado a partir de uma proposta com status "aceita".
6. Um imóvel só pode ter um corretor com gestão ativa (data_fim = NULL) por vez.

---

# 14. Esboço da estrutura do banco

```text
CORRETORES
├── id_corretor (PK)
├── nome
├── creci
└── comissao_percentual

IMOVEIS
├── id_imovel (PK)
├── endereco
├── tipo
├── preco
├── status
└── id_corretor (FK)

CLIENTES
├── id_cliente (PK)
├── nome
├── contato
├── tipo_interesse
└── orcamento

VISITAS
├── id_visita (PK)
├── id_cliente (FK)
├── id_imovel (FK)
├── data_visita
└── status

PROPOSTAS
├── id_proposta (PK)
├── id_cliente (FK)
├── id_imovel (FK)
├── valor_proposto
├── data
└── status

CONTRATOS
├── id_contrato (PK)
├── id_imovel (FK)
├── id_cliente (FK)
├── id_corretor (FK)
├── valor_final
├── tipo
└── data_fechamento

GESTOES
├── id_gestao (PK)
├── id_imovel (FK)
├── id_corretor (FK)
├── data_inicio
└── data_fim

CORRETORES 1───N IMOVEIS
CLIENTES   1───N VISITAS
IMOVEIS    1───N VISITAS
CLIENTES   1───N PROPOSTAS
IMOVEIS    1───N PROPOSTAS
CORRETORES 1───N GESTOES
IMOVEIS    1───N GESTOES
```

---

# 15. Dados que futuramente serão inseridos

1. Imóveis com endereço, preço e status reais (ex: apartamento no Centro, R$ 250.000, disponível)
2. Clientes interessados em compra ou aluguel
3. Corretores com CRECI e comissão
4. Visitas e propostas de exemplo, ligando clientes a imóveis

---

# 16. Perguntas que o banco deverá ser capaz de responder

1. Quais imóveis estão disponíveis abaixo de determinado preço?
2. Quantas visitas cada cliente já realizou?
3. Qual corretor tem mais contratos fechados?
4. Qual o valor médio dos imóveis vendidos?
5. Quantas propostas foram aceitas versus recusadas?

---

# 17. Decisões e dúvidas pendentes

- Decidido: a entidade Gestões será mantida, para registrar o histórico de qual corretor já gerenciou cada imóvel.
- Decidido: apenas um corretor pode ter gestão ativa sobre um imóvel por vez.

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