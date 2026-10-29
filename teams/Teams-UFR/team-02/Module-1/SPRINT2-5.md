# SPRINT 2/5 — Implementação da Estrutura do Banco de Dados com DDL

**Disciplina:** Laboratório de Banco de Dados
**Modalidade:** Atividade individual
**Aluno:** Rafael Tokashiki Souza
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# 1. Antes de começar

Revisei a `SPRINT1-5.md` antes de implementar. O tema (imobiliária), as seis
entidades, as chaves primárias, os relacionamentos e as restrições planejadas
foram mantidos.

### Alterações em relação à Sprint 1/5

| Decisão da Sprint 1/5 | O que mudou | Motivo |
|---|---|---|
| Chave primária chamada `id` em todas as tabelas | Passou a se chamar `id_proprietario`, `id_cliente`, `id_imovel` etc. | Com seis tabelas e sete chaves estrangeiras, nomes específicos deixam os `JOIN` mais legíveis e evitam ambiguidade |
| Tabela `imoveis` sem valor de condomínio | Foi adicionada a coluna `valor_condominio` via `ALTER TABLE` | Apartamentos e salas comerciais possuem essa cobrança, e ela influencia a decisão do cliente |
| Campo `interesse` da tabela `clientes` sem valor padrão | Recebeu `DEFAULT 'Compra'` | A maior parte dos cadastros da carteira é de interessados em compra |

---

# 3. Criando o banco de dados

## Código utilizado no seu projeto

```sql
CREATE DATABASE IF NOT EXISTS imobiliaria;

USE imobiliaria;
```

Utilizei `IF NOT EXISTS` para que o script possa ser executado novamente sem
gerar o erro `Can't create database; database exists`.

## Nome definitivo do banco

```text
imobiliaria
```

---

# 5. Criando as tabelas

## Tabelas planejadas

| Nº | Nome da tabela | Finalidade |
|---:|---|---|
| 1 | proprietarios | Armazena os donos dos imóveis administrados pela imobiliária |
| 2 | clientes | Armazena as pessoas interessadas em comprar ou alugar |
| 3 | corretores | Armazena os profissionais responsáveis pelo atendimento |
| 4 | imoveis | Armazena as unidades da carteira e suas características |
| 5 | visitas | Registra cada visita de um cliente a um imóvel com um corretor |
| 6 | contratos | Registra os negócios de venda e locação fechados |

---

# 6. Ordem de criação das tabelas

## Ordem definida para o seu projeto

1. `proprietarios` — independente
2. `clientes` — independente
3. `corretores` — independente
4. `imoveis` — depende de `proprietarios`
5. `visitas` — depende de `imoveis`, `clientes` e `corretores`
6. `contratos` — depende de `imoveis`, `clientes` e `corretores`

A ordem segue a regra de criar primeiro as tabelas sem dependência. Se eu
tentasse criar `imoveis` antes de `proprietarios`, a chave estrangeira falharia,
porque a tabela referenciada ainda não existiria.

---

# 7. PRIMARY KEY

## Chaves primárias implementadas

| Tabela | Chave primária | Utiliza `AUTO_INCREMENT`? |
|---|---|---|
| proprietarios | id_proprietario | Sim |
| clientes | id_cliente | Sim |
| corretores | id_corretor | Sim |
| imoveis | id_imovel | Sim |
| visitas | id_visita | Sim |
| contratos | id_contrato | Sim |

Todas as tabelas usam identificador numérico com `AUTO_INCREMENT`. Mesmo nas
tabelas em que existe um atributo naturalmente único (CPF, CNPJ, CRECI),
preferi manter o id sequencial como chave primária e marcar esses atributos
como `UNIQUE`. Isso mantém as chaves estrangeiras curtas e evita usar documento
pessoal como referência entre tabelas.

---

# 8. NOT NULL

## Campos obrigatórios implementados

| Tabela | Campo | Por que é obrigatório? |
|---|---|---|
| proprietarios | nome | Não é possível identificar um proprietário sem nome |
| proprietarios | cpf_cnpj | É o documento que garante que o proprietário não seja cadastrado duas vezes |
| clientes | nome | Mesmo motivo do proprietário |
| clientes | cpf | Necessário para evitar cadastro duplicado |
| clientes | data_cadastro | Permite saber há quanto tempo o cliente está na base |
| corretores | creci | Registro profissional obrigatório para exercer a função |
| imoveis | titulo | Todo imóvel precisa de descrição para ser anunciado |
| imoveis | preco | Um imóvel na carteira sem valor não pode ser negociado |
| imoveis | id_proprietario | Regra de negócio 1: nenhum imóvel existe sem proprietário |
| visitas | data_visita | Uma visita sem data não serve para histórico |
| visitas | id_imovel, id_cliente, id_corretor | Regra de negócio 4: a visita só existe se os três registros existirem |
| contratos | valor, data_inicio | Um contrato sem valor ou sem início é inválido |

Não apliquei `NOT NULL` em campos como `telefone`, `email` e `bairro`, porque
nem sempre a informação está disponível no momento do cadastro. `data_fim`, na
tabela `contratos`, também aceita nulo: contratos de venda não possuem data de
término.

---

# 9. UNIQUE

## Restrições `UNIQUE` implementadas

| Tabela | Campo | Por que não pode se repetir? |
|---|---|---|
| proprietarios | cpf_cnpj | Cada pessoa física ou jurídica possui um único documento; impede cadastro duplicado do mesmo proprietário |
| clientes | cpf | Mesmo motivo; garante um cadastro por cliente |
| corretores | creci | O registro no conselho é individual e não se repete entre profissionais |

Essas três restrições implementam diretamente a regra de negócio 2 e a regra 7
definidas na Sprint 1/5.

---

# 10. DEFAULT

## Valores padrão utilizados

| Tabela | Campo | DEFAULT | Justificativa |
|---|---|---|---|
| imoveis | disponivel | TRUE | Todo imóvel entra na carteira disponível; só deixa de estar após um contrato |
| imoveis | quartos | 0 | Terrenos e salas comerciais não possuem quartos; o padrão evita nulos |
| imoveis | banheiros | 0 | Mesmo motivo, aplicável a terrenos |
| imoveis | vagas | 0 | Nem todo imóvel possui garagem |
| imoveis | valor_condominio | 0.00 | Casas e terrenos não têm condomínio; o valor zero é mais adequado que nulo em um campo usado em somas |
| clientes | interesse | 'Compra' | A maior parte dos interessados cadastrados busca compra |

---

# 11. FOREIGN KEY

## Chaves estrangeiras implementadas

| Tabela | Campo FK | Referencia | Relacionamento |
|---|---|---|---|
| imoveis | id_proprietario | proprietarios(id_proprietario) | Um proprietário possui vários imóveis (1:N) |
| visitas | id_imovel | imoveis(id_imovel) | Um imóvel recebe várias visitas (1:N) |
| visitas | id_cliente | clientes(id_cliente) | Um cliente realiza várias visitas (1:N) |
| visitas | id_corretor | corretores(id_corretor) | Um corretor acompanha várias visitas (1:N) |
| contratos | id_imovel | imoveis(id_imovel) | Um imóvel pode ter vários contratos ao longo do tempo (1:N) |
| contratos | id_cliente | clientes(id_cliente) | Um cliente pode fechar vários contratos (1:N) |
| contratos | id_corretor | corretores(id_corretor) | Um corretor intermedia vários contratos (1:N) |

Nomeei todas as constraints (`fk_imoveis_proprietarios`,
`fk_visitas_clientes`, etc.) em vez de deixar o MySQL gerar nomes automáticos.
Isso torna as mensagens de erro compreensíveis: ao violar uma restrição, o
banco informa exatamente qual relacionamento foi quebrado.

---

# 12. Relacionamento N:N

Existe um relacionamento muitos-para-muitos entre `clientes` e `imoveis`: um
cliente pode visitar vários imóveis e um imóvel pode ser visitado por vários
clientes. O mesmo vale para os contratos.

Esse N:N foi resolvido por duas tabelas associativas:

```text
CLIENTES                        CLIENTES
   1                               1
   |                               |
   N                               N
VISITAS                        CONTRATOS
   N                               N
   |                               |
   1                               1
IMOVEIS                         IMOVEIS
```

Optei por dar a cada uma delas chave primária própria (`id_visita`,
`id_contrato`) em vez de chave composta `(id_imovel, id_cliente)`. O motivo é
que o mesmo cliente pode visitar o mesmo imóvel mais de uma vez, e o mesmo
imóvel pode ser alugado repetidamente pelo mesmo cliente em períodos
diferentes. Com chave composta, o segundo registro seria recusado pelo banco.

As duas tabelas também possuem atributos próprios (`data_visita`,
`observacao`, `valor`, `data_inicio`, `data_fim`), o que confirma que são
entidades com informação própria, e não apenas ligações entre tabelas.

---

# 13. ALTER TABLE

```sql
ALTER TABLE imoveis
ADD COLUMN valor_condominio DECIMAL(10,2) DEFAULT 0.00;
```

Durante a implementação percebi que o planejamento não previa o valor de
condomínio, informação relevante para apartamentos e salas comerciais e que
pesa na decisão do cliente. Em vez de refazer o `CREATE TABLE`, usei
`ALTER TABLE` para acrescentar a coluna — que é exatamente o propósito do
comando: modificar a estrutura de uma tabela já existente sem perder os dados.

---

# 14. DROP TABLE

```sql
CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

DROP TABLE tabela_teste;
```

Criei uma tabela temporária apenas para praticar o comando e removi em
seguida. `DROP TABLE` apaga a tabela e todos os seus dados de forma
irreversível, por isso não foi aplicado a nenhuma tabela do projeto.

---

# 18. Validar cada tabela

## Validações realizadas

| Tabela | `DESCRIBE` executado? | Estrutura correta? |
|---|---|---|
| proprietarios | Sim | Sim |
| clientes | Sim | Sim |
| corretores | Sim | Sim |
| imoveis | Sim | Sim |
| visitas | Sim | Sim |
| contratos | Sim | Sim |

---

# 19. Visualizar o CREATE TABLE gerado pelo MySQL

Executei `SHOW CREATE TABLE` nas tabelas `imoveis`, `visitas` e `contratos`
para confirmar que as chaves estrangeiras foram criadas com os nomes de
constraint definidos no script e que os tipos das colunas referenciadas são
compatíveis.

---

# 21. Registro de problemas encontrados

| Problema | Causa identificada | Como foi resolvido |
|---|---|---|
| `Can't create database 'imobiliaria'; database exists` | O banco já havia sido criado em uma execução anterior | Uso de `CREATE DATABASE IF NOT EXISTS` no início do script |
| `Cannot add foreign key constraint` ao criar `imoveis` | A tabela `proprietarios` ainda não existia na primeira tentativa | Reorganização do script para criar as tabelas independentes antes das dependentes |

---

# 23. Como salvar no MySQL Workbench

O script foi desenvolvido e executado no MySQL Workbench e salvo através de
`File → Save Script As...` com o nome `SPRINT2-5.sql`.

---

# 24. O que deve existir ao final desta Sprint

```text
SPRINT1-5.md
SPRINT2-5.md
SPRINT2-5.sql
```

---

# 25. Checklist técnico da Sprint 2/5

- [x] utilizei como base a `SPRINT1-5.md`;
- [x] criei um banco de dados;
- [x] utilizei `USE`;
- [x] criei pelo menos 4 tabelas relacionadas;
- [x] todas as tabelas possuem chave primária;
- [x] utilizei tipos de dados coerentes;
- [x] apliquei `NOT NULL` quando necessário;
- [x] apliquei `UNIQUE` quando necessário;
- [x] apliquei `DEFAULT` quando necessário;
- [x] implementei as chaves estrangeiras necessárias;
- [x] respeitei a ordem de criação das tabelas;
- [x] tratei corretamente relacionamentos N:N, caso existam;
- [x] executei pelo menos um `ALTER TABLE`;
- [x] pratiquei `DROP TABLE` em tabela temporária;
- [x] executei `DESCRIBE` nas tabelas;
- [x] verifiquei as tabelas no painel Schemas;
- [x] corrigi erros de execução;
- [x] organizei o script final;
- [x] salvei o script como `SPRINT2-5.sql`;
- [x] preenchi completamente este `SPRINT2-5.md`.
