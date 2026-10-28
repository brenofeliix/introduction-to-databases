SPRINT 2/5 — Implementação da Estrutura do Banco de Dados com DDL
Disciplina: Laboratório de Banco de Dados
Modalidade: Atividade individual
Aluno: Gabriel Sakaizawa Campos
Entrega desta Sprint: SPRINT2-5.md + SPRINT2-5.sql

## 1. Antes de começar

Revisão da SPRINT1-5.md: tema (sistema de gerenciamento de restaurante), 6 entidades
(Cliente, Funcionário, Mesa, Produto, Pedido, Item_Pedido), relacionamentos 1:N entre
Cliente/Mesa/Funcionário → Pedido, e Pedido/Produto → Item_Pedido. Nenhuma decisão da
Sprint 1/5 precisou ser alterada.

## 3. Criando o banco de dados

Código utilizado no seu projeto

```sql
CREATE DATABASE IF NOT EXISTS db_restaurante_sabor;
USE db_restaurante_sabor;
```

Nome definitivo do banco: `db_restaurante_sabor`

## 5. Criando as tabelas

Tabelas planejadas

| Nº | Nome da tabela | Finalidade |
|---|---|---|
| 1 | cliente | Armazenar os dados dos clientes do restaurante |
| 2 | funcionario | Armazenar os dados dos funcionários (garçons, gerência) |
| 3 | mesa | Armazenar as mesas do salão |
| 4 | produto | Armazenar os itens do cardápio |
| 5 | pedido | Armazenar os pedidos, vinculando cliente, mesa e funcionário |
| 6 | item_pedido | Armazenar os produtos e quantidades que compõem cada pedido |

## 6. Ordem de criação das tabelas

Ordem definida para o seu projeto:

```text
cliente
funcionario
mesa
produto
    ↓
pedido
    ↓
item_pedido
```

`pedido` depende de `cliente`, `mesa` e `funcionario`; `item_pedido` depende de
`pedido` e `produto`. Por isso as quatro primeiras tabelas (independentes) foram
criadas antes de `pedido`, e `item_pedido` foi criada por último.

## 7. PRIMARY KEY

Chaves primárias implementadas

| Tabela | Chave primária | Utiliza AUTO_INCREMENT? |
|---|---|---|
| cliente | id_cliente | Sim |
| funcionario | id_funcionario | Sim |
| mesa | id_mesa | Sim |
| produto | id_produto | Sim |
| pedido | id_pedido | Sim |
| item_pedido | id_item_pedido | Sim |

## 8. NOT NULL

Campos obrigatórios implementados

| Tabela | Campo | Por que é obrigatório? |
|---|---|---|
| cliente | nome, cpf, data_cadastro | Identificam e datam o cadastro do cliente |
| funcionario | nome, cargo, email, ativo | Necessários para identificar e vincular o funcionário aos pedidos |
| mesa | numero, capacidade, status | Toda mesa precisa ter número e situação conhecida |
| produto | nome, categoria, preco | Todo item do cardápio precisa dessas informações para ser vendido |
| pedido | id_cliente, id_mesa, id_funcionario, data_pedido, status | Um pedido só existe se estiver vinculado a esses três registros e tiver data/situação |
| item_pedido | id_pedido, id_produto, quantidade, preco_unitario | Um item só faz sentido vinculado a um pedido e a um produto, com quantidade e preço definidos |

## 9. UNIQUE

Restrições UNIQUE implementadas

| Tabela | Campo | Por que não pode se repetir? |
|---|---|---|
| cliente | cpf | Evita cadastrar o mesmo cliente duas vezes |
| funcionario | email | Cada funcionário deve ter um e-mail próprio para login/contato |

## 10. DEFAULT

Valores padrão utilizados

| Tabela | Campo | DEFAULT | Justificativa |
|---|---|---|---|
| funcionario | ativo | TRUE | Todo funcionário nasce ativo no sistema |
| mesa | status | 'livre' | Toda mesa começa disponível até ser ocupada |
| produto | preco | 0.00 | Evita erro de NULL antes do preço real ser definido |
| pedido | status | 'aberto' | Todo pedido novo começa como em andamento |

## 11. FOREIGN KEY

Chaves estrangeiras implementadas

| Tabela | Campo FK | Referencia | Relacionamento |
|---|---|---|---|
| pedido | id_cliente | cliente(id_cliente) | Cliente 1:N Pedido |
| pedido | id_mesa | mesa(id_mesa) | Mesa 1:N Pedido |
| pedido | id_funcionario | funcionario(id_funcionario) | Funcionário 1:N Pedido |
| item_pedido | id_pedido | pedido(id_pedido) | Pedido 1:N Item_Pedido |
| item_pedido | id_produto | produto(id_produto) | Produto 1:N Item_Pedido |

## 12. Relacionamento N:N

Seu banco possui relacionamento N:N?
- [x] Não (diretamente)

Explicação: Cliente/Mesa/Funcionário se relacionam com Pedido em 1:N, e Pedido/Produto
se relacionam com Item_Pedido em 1:N. A tabela `item_pedido` funciona, na prática, como
a "tabela associativa" que resolve o relacionamento N:N entre Pedido e Produto (um
pedido pode ter vários produtos, e um produto pode aparecer em vários pedidos).

## 13. ALTER TABLE

ALTER TABLE utilizado no projeto

```sql
ALTER TABLE pedido
ADD COLUMN observacao VARCHAR(200);
```

Explique a alteração: adicionei o campo `observacao` à tabela `pedido` para permitir
registrar pedidos especiais (ex: "sem cebola", "aniversário do cliente"). Esse campo
não estava previsto na Sprint 1/5 e surgiu como necessidade ao implementar a estrutura.

## 14. DROP TABLE — exercício controlado

Código executado

```sql
CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

DROP TABLE tabela_teste;
```

Explique a diferença

`DELETE FROM tabela;` remove apenas os **registros (linhas)** da tabela, mas a
estrutura da tabela continua existindo no banco. Já `DROP TABLE tabela;` remove a
**tabela inteira**, incluindo sua estrutura (colunas, chaves, restrições) — depois
do DROP, a tabela deixa de existir e precisaria ser recriada com CREATE TABLE.

## 18. Validar cada tabela

Validações realizadas

| Tabela | DESCRIBE executado? | Estrutura correta? |
|---|---|---|
| cliente | Sim | Sim |
| funcionario | Sim | Sim |
| mesa | Sim | Sim |
| produto | Sim | Sim |
| pedido | Sim | Sim |
|