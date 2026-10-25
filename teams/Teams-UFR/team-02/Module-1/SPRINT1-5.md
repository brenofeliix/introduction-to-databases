# Planejamento do Banco de Dados — Sprint 1/5

**Disciplina:** Laboratório de Banco de Dados  
**Data:** 31/08/2026  
**Modalidade:** Atividade individual  

---

# Objetivo da Sprint 1/5

Nesta primeira etapa, será planejado o banco de dados do sistema imobiliário que será desenvolvido de forma incremental ao longo das cinco Sprints. O planejamento utiliza como base o modelo inicial apresentado no conteúdo de MySQL, composto pelas tabelas `proprietarios` e `imoveis`, e amplia a proposta para contemplar clientes, corretores e visitas em etapas posteriores.

Ao final das próximas etapas, o banco deverá possuir estrutura relacional, chaves primárias e estrangeiras, restrições de integridade, dados de teste, operações de inserção, alteração e exclusão, consultas SQL, funções de agregação, agrupamentos, validações e documentação.

Nesta Sprint 1/5, o foco é exclusivamente o **planejamento do banco de dados**. A implementação dos comandos SQL será realizada a partir da Sprint 2/5.

> **Importante:** o script inicial fornecido já define o banco `imobiliaria` e as tabelas `proprietarios` e `imoveis`. As entidades adicionais descritas neste planejamento deverão ser implementadas nas etapas seguintes, conforme o escopo da atividade.

---

# 1. Identificação do aluno

**Nome completo:**

> RAFAEL TOKASHIKI SOUZA

**Nome escolhido para o banco de dados:**

```text
imobiliaria
```

---

# 2. Tema do banco de dados

O banco de dados representará o funcionamento de uma imobiliária responsável pelo cadastro, organização e consulta de imóveis residenciais, comerciais e terrenos, bem como pelo controle dos proprietários, clientes interessados, corretores e visitas agendadas.

### Tema escolhido

> Sistema de gestão imobiliária

---

# 3. Descrição do sistema

O sistema representa uma imobiliária que precisa organizar os dados de seus imóveis e relacioná-los aos respectivos proprietários. A solução também deverá permitir o cadastro de clientes interessados, corretores responsáveis pelo atendimento e visitas realizadas aos imóveis.

O sistema será utilizado pelos responsáveis administrativos da imobiliária e pelos corretores. As principais informações armazenadas serão os dados dos proprietários, as características dos imóveis, a finalidade do anúncio — venda ou aluguel —, a localização, os valores, a disponibilidade, os clientes interessados, os corretores e o histórico de visitas.

O banco deverá permitir cadastrar, alterar e excluir registros quando permitido pelas regras de integridade. Também deverá possibilitar a consulta de imóveis por finalidade, tipo, cidade e disponibilidade, a ordenação por preço, a contagem de imóveis por tipo e a visualização dos imóveis juntamente com seus proprietários por meio de relacionamentos entre tabelas.

---

# 4. Objetivo do banco de dados

### Objetivo

O objetivo é centralizar e organizar as informações da imobiliária em um banco de dados relacional, facilitando o cadastro e o controle de imóveis, proprietários, clientes, corretores e visitas. O banco deverá reduzir a duplicidade de informações, manter os relacionamentos entre os registros e apoiar consultas administrativas e comerciais.

---

# 5. Escopo inicial

O escopo foi definido a partir do modelo MySQL fornecido, que contém as tabelas `proprietarios` e `imoveis`, seus identificadores, a chave estrangeira entre elas, dados de teste e consultas com `WHERE`, `ORDER BY`, `GROUP BY` e `INNER JOIN`.

### O banco deverá permitir:

1. Criar o banco de dados `imobiliaria`.
2. Cadastrar, alterar e excluir imóveis, respeitando os relacionamentos existentes.
3. Armazenar título, tipo, finalidade, localização, quantidade de quartos, banheiros, vagas, área, preço, disponibilidade e data de cadastro do imóvel.
4. Cadastrar proprietários e relacioná-los aos respectivos imóveis.
5. Cadastrar clientes interessados em imóveis.
6. Cadastrar corretores responsáveis pelo atendimento e pelo acompanhamento das visitas.
7. Registrar visitas relacionando o imóvel, o cliente e o corretor.
8. Consultar imóveis por finalidade, tipo, cidade e disponibilidade.
9. Ordenar imóveis por preço, área ou data de cadastro.
10. Agrupar e contar imóveis por tipo, finalidade ou cidade.
11. Consultar imóveis com os respectivos proprietários utilizando `INNER JOIN`.
12. Validar chaves primárias, chaves estrangeiras e restrições de integridade nas Sprints seguintes.

### Fora do escopo desta atividade

Não fazem parte do escopo inicial a interface gráfica, o desenvolvimento de uma aplicação web ou mobile, o controle financeiro de vendas e aluguéis, pagamentos, contratos jurídicos, autenticação de usuários e a criação de views, procedures ou triggers.

---

# 6. Identificação das entidades

As entidades planejadas para o banco são as seguintes:

| Nº | Entidade | O que representa? |
|---:|---|---|
| 1 | `proprietarios` | Pessoas que possuem um ou mais imóveis cadastrados na imobiliária. |
| 2 | `imoveis` | Casas, apartamentos, sobrados, kitnets, terrenos e salas comerciais anunciados pela imobiliária. |
| 3 | `clientes` | Pessoas interessadas em comprar ou alugar um ou mais imóveis. |
| 4 | `corretores` | Profissionais responsáveis pelo atendimento dos clientes e pelo acompanhamento das visitas. |
| 5 | `visitas` | Registros de visitas realizadas ou agendadas para um imóvel por um cliente e acompanhadas por um corretor. |

As cinco entidades são relacionadas por chaves estrangeiras. A estrutura inicial da atividade concentra-se em `proprietarios` e `imoveis`; `clientes`, `corretores` e `visitas` representam a evolução planejada do banco.

---

# 7. Planejamento dos atributos

## Entidade 1

**Nome da entidade:**

```text
proprietarios
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id` | Identificador único do proprietário. | `INT AUTO_INCREMENT` | Sim |
| `nome` | Nome completo do proprietário. | `VARCHAR(100)` | Sim |
| `telefone` | Número de telefone para contato. | `VARCHAR(20)` | Não |
| `cidade` | Cidade de residência do proprietário. | `VARCHAR(80)` | Não |

## Entidade 2

**Nome da entidade:**

```text
imoveis
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id` | Identificador único do imóvel. | `INT AUTO_INCREMENT` | Sim |
| `titulo` | Título ou nome comercial do anúncio. | `VARCHAR(150)` | Sim |
| `tipo` | Categoria do imóvel, como casa, apartamento ou terreno. | `VARCHAR(30)` | Sim |
| `finalidade` | Operação pretendida: venda ou aluguel. | `VARCHAR(20)` | Sim |
| `bairro` | Bairro onde o imóvel está localizado. | `VARCHAR(80)` | Não |
| `cidade` | Cidade onde o imóvel está localizado. | `VARCHAR(80)` | Sim |
| `quartos` | Quantidade de quartos. | `INT` | Não; padrão `0` |
| `banheiros` | Quantidade de banheiros. | `INT` | Não; padrão `0` |
| `vagas` | Quantidade de vagas de garagem. | `INT` | Não; padrão `0` |
| `area_m2` | Área do imóvel em metros quadrados. | `DECIMAL(8,2)` | Não |
| `preco` | Preço de venda ou valor mensal do aluguel. | `DECIMAL(12,2)` | Sim |
| `disponivel` | Indica se o imóvel está disponível. | `BOOLEAN` | Não; padrão `TRUE` |
| `data_cadastro` | Data em que o imóvel foi cadastrado. | `DATE` | Sim |
| `proprietario_id` | Identificador do proprietário relacionado. | `INT` | Sim no modelo final; o script inicial permite `NULL` |

## Entidade 3

**Nome da entidade:**

```text
clientes
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id` | Identificador único do cliente. | `INT AUTO_INCREMENT` | Sim |
| `nome` | Nome completo do cliente. | `VARCHAR(100)` | Sim |
| `telefone` | Número de telefone para contato. | `VARCHAR(20)` | Sim |
| `email` | Endereço de e-mail do cliente. | `VARCHAR(120)` | Não |
| `cidade` | Cidade de residência ou interesse do cliente. | `VARCHAR(80)` | Não |
| `data_cadastro` | Data de cadastro do cliente. | `DATE` | Sim |

## Entidade 4

**Nome da entidade:**

```text
corretores
```

| Atributo | Informação armazenada | Tipo de dado previsto | Obrigatório? |
|---|---|---|---|
| `id` | Identificador único do corretor. | `INT AUTO_INCREMENT` | Sim |
| `nome` | Nome completo do corretor. | `VARCHAR(100)` | Sim |
| `creci` | Registro profissional do corretor. | `VARCHAR(20)` | Sim |
| `telefone` | Número de telefone profissional. | `VARCHAR(20)` | Não |
| `email` | Endereço de e-mail profissional. | `VARCHAR(120)` | Não |
| `ativo` | Indica se o corretor está ativo na imobiliária. | `BOOLEAN` | Não; padrão `TRUE` |

## Outras entidades

| Entidade | Principais atributos |
|---|---|
| `visitas` | `id`, `imovel_id`, `cliente_id`, `corretor_id`, `data_visita`, `status` e `observacoes`. |

A entidade `visitas` funcionará como registro dos atendimentos realizados, conectando um cliente, um imóvel e um corretor. Dessa forma, será possível registrar diversos clientes interessados no mesmo imóvel e diversas visitas feitas por um cliente.

---

# 8. Chaves primárias

Cada tabela terá um identificador numérico próprio, gerado automaticamente, para evitar duplicidade e facilitar os relacionamentos.

| Entidade/Tabela | Chave primária prevista | Justificativa |
|---|---|---|
| `proprietarios` | `id` | Identifica exclusivamente cada proprietário e será preenchido com `AUTO_INCREMENT`. |
| `imoveis` | `id` | Identifica exclusivamente cada imóvel, mesmo quando dois anúncios possuem títulos semelhantes. |
| `clientes` | `id` | Identifica exclusivamente cada cliente cadastrado. |
| `corretores` | `id` | Identifica exclusivamente cada corretor. |
| `visitas` | `id` | Identifica exclusivamente cada registro de visita. |

Os identificadores serão do tipo `INT AUTO_INCREMENT PRIMARY KEY`, conforme o padrão utilizado no script inicial das tabelas `proprietarios` e `imoveis`.

---

# 9. Relacionamentos entre as entidades

### Relacionamentos planejados

| Entidade A | Relacionamento | Entidade B |
|---|---|---|
| `proprietarios` | possui | `imoveis` |
| `imoveis` | recebe | `visitas` |
| `clientes` | realiza ou agenda | `visitas` |
| `corretores` | acompanha | `visitas` |
| `visitas` | registra o atendimento de | `imoveis`, `clientes` e `corretores` |

O relacionamento principal já apresentado no conteúdo MySQL é entre `imoveis` e `proprietarios`, por meio do campo `imoveis.proprietario_id`. Os demais relacionamentos serão implementados durante a evolução do banco.

---

# 10. Cardinalidade inicial

| Relacionamento | Cardinalidade prevista | Justificativa |
|---|---|---|
| `proprietarios` — `imoveis` | 1:N | Um proprietário pode possuir vários imóveis; cada imóvel deverá estar vinculado a um proprietário. |
| `imoveis` — `visitas` | 1:N | Um imóvel pode receber várias visitas em datas diferentes. |
| `clientes` — `visitas` | 1:N | Um cliente pode realizar ou agendar várias visitas. |
| `corretores` — `visitas` | 1:N | Um corretor pode acompanhar várias visitas. |
| `clientes` — `imoveis`, por meio de `visitas` | N:N | Um cliente pode visitar vários imóveis e um imóvel pode ser visitado por vários clientes; a tabela `visitas` resolve esse relacionamento. |

---

# 11. Chaves estrangeiras previstas

| Tabela | Atributo previsto como FK | Referencia qual tabela? |
|---|---|---|
| `imoveis` | `proprietario_id` | `proprietarios(id)` |
| `visitas` | `imovel_id` | `imoveis(id)` |
| `visitas` | `cliente_id` | `clientes(id)` |
| `visitas` | `corretor_id` | `corretores(id)` |

A chave estrangeira `imoveis.proprietario_id` já está prevista no script inicial e referencia `proprietarios.id`. As demais chaves estrangeiras serão implementadas nas etapas seguintes, depois da criação das tabelas correspondentes.

---

# 12. Restrições de integridade previstas

| Tabela | Atributo | Restrição prevista | Motivo |
|---|---|---|---|
| Todas as tabelas | `id` | `PRIMARY KEY`, `AUTO_INCREMENT` | Impedir registros sem identificação e gerar identificadores únicos. |
| `proprietarios` | `nome` | `NOT NULL` | Todo proprietário deve possuir nome cadastrado. |
| `imoveis` | `titulo`, `tipo`, `finalidade`, `cidade`, `preco`, `data_cadastro` | `NOT NULL` | Esses dados são essenciais para identificar e anunciar o imóvel. |
| `imoveis` | `quartos`, `banheiros`, `vagas` | `DEFAULT 0` | Permitir o cadastro de imóveis sem esses itens, como terrenos e salas comerciais. |
| `imoveis` | `disponivel` | `DEFAULT TRUE` | Considerar o imóvel disponível quando o valor não for informado. |
| `imoveis` | `proprietario_id` | `FOREIGN KEY` e, no modelo final, `NOT NULL` | Garantir que o imóvel esteja relacionado a um proprietário existente. |
| `clientes` | `nome`, `telefone`, `data_cadastro` | `NOT NULL` | Manter as informações mínimas para identificação e contato. |
| `corretores` | `nome`, `creci` | `NOT NULL` e `UNIQUE` para `creci` | Evitar o cadastro de corretor sem identificação ou com registro profissional duplicado. |
| `visitas` | `imovel_id`, `cliente_id`, `corretor_id`, `data_visita` | `NOT NULL` e `FOREIGN KEY` | Impedir visitas sem imóvel, cliente, corretor ou data relacionados. |
| `imoveis` | `preco`, `area_m2`, `quartos`, `banheiros`, `vagas` | Validação de valores não negativos | Evitar valores incompatíveis com as características do imóvel. |

---

# 13. Regras de negócio

1. Cada imóvel deverá estar relacionado a um proprietário existente no banco de dados.
2. Um proprietário poderá possuir um ou vários imóveis cadastrados.
3. A finalidade do imóvel deverá ser informada como `Venda` ou `Aluguel`.
4. O preço do imóvel deverá ser maior que zero e não poderá ser negativo.
5. A área, a quantidade de quartos, banheiros e vagas não poderão assumir valores negativos.
6. Todo imóvel será cadastrado como disponível por padrão, mas poderá ser marcado como indisponível quando for vendido, alugado ou retirado do anúncio.
7. Uma visita somente poderá ser registrada para um imóvel, cliente e corretor existentes.
8. Um corretor não poderá possuir dois cadastros com o mesmo número de CRECI.
9. A exclusão de um proprietário que possua imóveis deverá ser bloqueada ou tratada antes da exclusão dos imóveis relacionados, para preservar a integridade referencial.
10. A tabela `visitas` deverá permitir identificar se a visita está `Agendada`, `Realizada` ou `Cancelada`.

---

# 14. Esboço da estrutura do banco

```text
PROPRIETARIOS
├── id (PK)
├── nome
├── telefone
└── cidade

IMOVEIS
├── id (PK)
├── titulo
├── tipo
├── finalidade
├── bairro
├── cidade
├── quartos
├── banheiros
├── vagas
├── area_m2
├── preco
├── disponivel
├── data_cadastro
└── proprietario_id (FK → PROPRIETARIOS.id)

CLIENTES
├── id (PK)
├── nome
├── telefone
├── email
├── cidade
└── data_cadastro

CORRETORES
├── id (PK)
├── nome
├── creci (UNIQUE)
├── telefone
├── email
└── ativo

VISITAS
├── id (PK)
├── imovel_id (FK → IMOVEIS.id)
├── cliente_id (FK → CLIENTES.id)
├── corretor_id (FK → CORRETORES.id)
├── data_visita
├── status
└── observacoes

PROPRIETARIOS 1 ───── N IMOVEIS
IMOVEIS       1 ───── N VISITAS
CLIENTES      1 ───── N VISITAS
CORRETORES    1 ───── N VISITAS
CLIENTES      N ───── N IMOVEIS, resolvido pela tabela VISITAS
```

---

# 15. Dados que futuramente serão inseridos

1. Proprietários, como João Pereira, Maria Santos e Carlos Oliveira, com telefone e cidade.
2. Imóveis como casa térrea, apartamento, sobrado, kitnet, terreno e sala comercial, utilizando os dados de teste apresentados no script MySQL.
3. Clientes interessados em comprar ou alugar imóveis, com nome, telefone, cidade e data de cadastro.
4. Corretores da imobiliária, com nome, número de CRECI, telefone, e-mail e situação de atividade.
5. Visitas agendadas, realizadas ou canceladas, relacionando imóveis, clientes e corretores.

### Dados de teste já previstos no conteúdo MySQL

| Tipo de registro | Quantidade inicial prevista | Exemplos |
|---|---:|---|
| Proprietários | 3 | João Pereira, Maria Santos e Carlos Oliveira. |
| Imóveis | 6 | Casa térrea, apartamento, sobrado, kitnet, terreno e sala comercial. |
| Finalidades | 2 | Venda e aluguel. |
| Tipos de imóvel | 6 | Casa, apartamento, sobrado, kitnet, terreno e comercial. |

---

# 16. Perguntas que o banco deverá ser capaz de responder

1. Quais imóveis estão cadastrados no banco?
2. Quais imóveis estão disponíveis para venda?
3. Quais imóveis estão disponíveis para aluguel em determinada cidade ou bairro?
4. Quais imóveis possuem os maiores preços, em ordem decrescente?
5. Quantos imóveis existem por tipo, utilizando `GROUP BY`?
6. Qual é o proprietário de cada imóvel, utilizando `INNER JOIN`?
7. Qual é a quantidade de imóveis cadastrados por cidade?
8. Quais clientes realizaram visitas e quais imóveis foram visitados?
9. Quantas visitas foram acompanhadas por cada corretor?
10. Qual é o preço médio dos imóveis por finalidade?

As cinco primeiras consultas deverão ser construídas a partir dos dados e exemplos apresentados no conteúdo MySQL. As demais serão utilizadas quando as tabelas adicionais forem implementadas.

---

# 17. Decisões e dúvidas pendentes

- A primeira versão da implementação deverá manter o nome do banco como `imobiliaria` e preservar os nomes das tabelas e dos campos principais do script fornecido.
- As tabelas `proprietarios` e `imoveis` serão a base da Sprint 2, com criação de banco, tabelas, chaves primárias, chave estrangeira e restrições.
- As tabelas `clientes`, `corretores` e `visitas` serão incluídas na evolução do modelo, caso o cronograma da disciplina exija a implementação de todas as entidades planejadas.
- O script inicial declara `imoveis.proprietario_id` como um campo que permite `NULL`; é necessário confirmar se, na versão final, esse campo deverá ser alterado para `NOT NULL`, conforme a regra de que todo imóvel deve possuir proprietário.
- Deve ser confirmado na Sprint 2 se a tabela de visitas utilizará `DATE` ou `DATETIME` para armazenar o momento do atendimento.
- As validações de valores não negativos para preço, área e quantidades deverão ser confirmadas de acordo com a versão do MySQL utilizada no laboratório.

---

# 18. Checklist da Sprint 1/5

- [x] Identifiquei o aluno responsável.
- [x] Defini o tema do banco de dados.
- [x] Descrevi o sistema.
- [x] Defini o objetivo do banco.
- [x] Defini o escopo inicial.
- [x] Identifiquei pelo menos 4 entidades.
- [x] Planejei os principais atributos.
- [x] Defini as chaves primárias previstas.
- [x] Identifiquei os relacionamentos.
- [x] Defini as cardinalidades iniciais.
- [x] Identifiquei possíveis chaves estrangeiras.
- [x] Planejei restrições de integridade.
- [x] Defini pelo menos 5 regras de negócio.
- [x] Fiz um esboço da estrutura do banco.
- [x] Defini os tipos de dados que futuramente serão cadastrados.
- [x] Defini pelo menos 5 perguntas que o banco deverá responder.
- [x] Registrei decisões e dúvidas pendentes.
- [x] Revisei o arquivo antes de finalizar.

---

# Entrega da Sprint 1/5

O arquivo desta etapa foi salvo com o nome:

```text
SPRINT1-5.md
```

Este arquivo deverá ser mantido como referência para as próximas Sprints. A evolução planejada é:

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

A atividade é individual. O aluno deverá manter seu próprio histórico de desenvolvimento durante as cinco Sprints e trabalhar em uma branch própria durante toda a atividade.

A branch não deverá ser recriada a cada Sprint. Deve ser utilizada a convenção definida pelo professor para identificação individual, desde que o nome seja compatível com a validação automática do repositório.

Cada Sprint deverá gerar pelo menos um commit próprio. Para esta etapa, a mensagem sugerida é:

```text
Conclui Sprint 1 de 5 - planejamento do banco
```

Nas próximas etapas, poderão ser utilizadas as seguintes mensagens:

```text
Conclui Sprint 2 de 5 - estrutura DDL
Conclui Sprint 3 de 5 - operações DML
Conclui Sprint 4 de 5 - consultas SQL
Conclui Sprint 5 de 5 - validação final
```

O Pull Request final deverá ser aberto somente após a conclusão da Sprint 5/5.

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

A Sprint está concluída porque o planejamento apresenta o tema, as tabelas, os atributos, as chaves primárias, os relacionamentos, as cardinalidades, as chaves estrangeiras previstas, as restrições de integridade, as regras de negócio, os tipos de dados, o esboço estrutural e as consultas que o banco deverá responder.

O planejamento também diferencia a estrutura inicial já apresentada no conteúdo MySQL — `proprietarios` e `imoveis` — das entidades que poderão ser implementadas na evolução do banco: `clientes`, `corretores` e `visitas`.

---

# Próxima etapa

Na **Sprint 2/5**, o planejamento será transformado em uma implementação utilizando comandos DDL, incluindo:

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
AUTO_INCREMENT
```

> **Não implementar a Sprint 2/5 neste arquivo.**