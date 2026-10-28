# SPRINT 3/5 — Views e Abstração de Consultas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# Objetivo da Sprint 3/5

Nesta etapa, cada aluno deverá criar **Views** para representar consultas relevantes e reutilizáveis do seu banco.

Serão trabalhados:

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT
DROP VIEW
SHOW FULL TABLES
```

O aluno deverá compreender que uma `VIEW` representa uma consulta armazenada que pode ser utilizada como uma tabela virtual.

---

# 1. Identificação

**Nome completo:**

> Mariano Lino da Silva Neto

**Banco utilizado:**

```
db_conveniencia
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Detalhe do catalogo com nome dos produtos e também suas categorias | Evita ter que refazer o JOIN entre produto e Categoria | Sim |
| Resumo de vendas e faturamento gerado por cada categoria | Permite acompanhar rapidamente quais categorias dão mais lucro para a loja | Sim |
| Relatório de Produtos com estoque baixo | Permite que o repositor de estoque identifique rapidamente quais itens precisam de reposição | Sim |
|  |  |  |

---

# 3. Criando uma VIEW

Estrutura geral:

```sql
CREATE VIEW nome_view AS
SELECT ...
FROM ...
WHERE ...;
```

Exemplo:

```sql
CREATE VIEW vw_clientes_pedidos AS
SELECT
    c.id_cliente,
    c.nome,
    p.id_pedido,
    p.data_pedido
FROM cliente AS c
INNER JOIN pedido AS p
    ON c.id_cliente = p.id_cliente;
```

---

# 4. VIEW 1 — relacionamento entre tabelas

**Nome da VIEW:**

```
vw_detalhes_produtos
```

**Pergunta que ela representa:**

> Como listar todos os produtos do catalogo exibindo o nome de sua respectiva categoria no lugar do ID numérico?

**SQL:**

```sql
CREATE VIEW vw_detalhes_produtos AS
SELECT
p.id_produto,
p.codigo_barras,
p.nome_produto,
p.preco_venda,
p.quantidade_estoque,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria;
```

**Tabelas utilizadas:**

> Produto e Categoria

**Como consultar essa VIEW?**

```sql
SELECT
nome_produto,
preco_venda,
nome_categoria
FROM vw_detalhes_produtos
WHERE nome_categoria = 'Salgados';
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Qual é a quantidade total de itens vendidos e o faturamento total acumulado agrupado por categoria de produto?

```sql
CREATE VIEW vw_resumo_vendas_categoria AS
SELECT 
    c.nome_categoria,
    COUNT(DISTINCT p.id_produto) AS total_produtos_distintos,
    COALESCE(SUM(iv.quantidade), 0) AS total_itens_vendidos,
    COALESCE(SUM(iv.quantidade * p.preco_venda), 0.00) AS faturamento_total
FROM Categoria AS c
LEFT JOIN Produto AS p 
    ON c.id_categoria = p.id_categoria
LEFT JOIN Item_venda AS iv 
    ON p.id_produto = iv.id_produto
GROUP BY c.id_categoria, c.nome_categoria;
```

**Explique:**

> nossa View vai juntar as tabelas Categoria com produto e Item_venda usando o LEFT JOIN garantindo que nenhuma categoria sem vendas apareça e em seguida ela vai agrupar por categorias usando a COUNT e a SUM multiplicando quantidade x preço para obter a receita bruta por setor

---

# 6. VIEW 3 — consulta operacional do sistema

Crie uma VIEW que represente uma informação útil para um usuário real.

Exemplos:

```text
estoque baixo
empréstimos em aberto
pedidos pendentes
alunos matriculados
consultas futuras
reservas ativas
pagamentos pendentes
```

**Nome da VIEW:**

```
vw_estoque_critico
```

```sql
CREATE VIEW vw_estoque_critico AS
SELECT
p.id_produto,
p.nome_produto,
p.quantidade_estoque,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria
WHERE p.quantidade_estoque < 20;
```

**Por que essa VIEW é útil?**

> é uma ferramenta essencial para o gerenciamento operacional do estoque da conveniencia, assim o nosso gerente não vai precisar digitar comando complexos no sistema, ele só vai precisar saber dar um SELECT basico na view para ver instantaneamente quais produtos tem menos de 20 unidades. 

---

# 7. Consultando uma VIEW

Execute:

```sql
SELECT *
FROM nome_view;
```

Depois faça um filtro:

```sql
SELECT *
FROM nome_view
WHERE ...;
```

**SQL executado:**

```sql
-- Sem filtro --
SELECT * FROM vw_detalhes_produtos;
-- Com Filtro --
SELECT
nome_produto,
quantidade_estoque
FROM vw_detalhes_produtos
wHERE quantidade_estoque >= 50;
```

**Resultado observado:**

> O Workbench trata a view exatamente como se fosse uma tabela que já existia no banco, por isso a consulta retorna apenas os produtos com maior ou igual a 50 unidades.

---

# 8. CREATE OR REPLACE VIEW

Escolha uma VIEW e faça uma alteração coerente.

Pode ser:

- adicionar coluna;
- alterar filtro;
- incluir um `JOIN`;
- adicionar cálculo;
- alterar uma agregação.

**VIEW original:**

```sql
CREATE VIEW vw_estoque_critico AS
SELECT
p.id_produto,
p.nome_produto,
p.quantidade_estoque,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria
WHERE p.quantidade_estoque < 20;
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_estoque_critico AS
SELECT
p.id_produto,
p.codigo_barras,
p.nome_produto,
p.preco_venda,
p.quantidade_estoque,
c.nome_categoria,
CASE
WHEN p.quantidade_estoque = 0 THEN 'SEM ESTOQUE'
WHEN p.quantidade_estoque <= 10 THEN 'ALERTA VERMELHO'
ELSE 'REPOSIÇÃO NECESSARIA'
END AS situacao_estoque
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria 
WHERE p.quantidade_estoque <= 35;
```

**O que mudou?**

> Mudei o limite de 20 para 35, coloquei as colunas codigo_barras e preco_venda e para finalizar colocamos CASE para indicar a colune situacao_estoque

---

# 9. DROP VIEW — exercício controlado

Crie uma VIEW temporária:

```sql
CREATE VIEW vw_teste AS
SELECT ...;
```

Depois remova:

```sql
DROP VIEW vw_teste;
```

**Código utilizado:**

```sql
-- view temporaria --
CREATE VIEW vw_amor_temporario AS
SELECT id_produto, nome_produto FROM Produto;

-- removendo o amor --
DROP VIEW vw_amor_temporario;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> o VIEW apaga apenas a definição da tabela virtual sem perder nenhum dado fisico que seja real visto que esses dados estão na tabela base.
e o TABLE é a tabela onde esses dados realmente estão armazenados na tabela do disco de forma permanente.
---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_detalhes_produtos
2. vw_resumo_vendas_categoria
3. vw_estoque_critico

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```
vw_detalhes_produtos
```

**Alteração realizada:**

```sql
-- consulta inicial --
SELECT nome_produto, preco_venda FROM vw_detalhes_produtos WHERE id_produto = 1;

-- update --
UPDATE Produto
set preco_venda = 10.50
WHERE id_produto = 1;

-- consulta final --
SELECT nome_produto, preco_venda FROM vw_detalhes_produtos WHERE id_produto = 1;
```

**Resultado observado:**

> A gente mudou o valor do produto que ficava no ID 1 de 8 para 10.50 e com isso a gente confirma que a view não guarda copias físicas dos dados só executa a consulta em tempo real na tabela base

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
CREATE VIEW vw_detalhes_produtos AS
SELECT
p.id_produto,
p.codigo_barras,
p.nome_produto,
p.preco_venda,
p.quantidade_estoque,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria;
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> 1. Depende das tabelas Produto e Categoria
 2. Ultiliza INNER JOIN ligando Produto.id_produto com Categoria.id_categoria
 3. Id do produto, codigo de barras, nome do produto, preco de venda, estoque e nome da categoria
 4. Tira a necessidade de ficar repetindo os comandos JOIN.
 5. Qualquer inserção que você fizer nas tabelas bases serão automaticamente refletidas nas respostas da VIEW.

---

# 13. Quantidade mínima exigida

O projeto deverá possuir no mínimo:

```text
3 VIEWs úteis
1 VIEW com relacionamento
1 VIEW com agregação ou resumo
1 CREATE OR REPLACE VIEW
1 teste com DROP VIEW
```

---

# 14. Estrutura recomendada do SPRINT3-5.sql

```sql
-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- VIEW 1

-- VIEW 2

-- VIEW 3

-- CONSULTAS SOBRE AS VIEWS

-- CREATE OR REPLACE VIEW

-- VIEW TEMPORÁRIA

-- DROP VIEW

-- VALIDAÇÃO
```

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 16. Uso de LLMs

O uso de LLMs pode ocorrer como apoio, mas o aluno deverá compreender e validar todo o código.

Fluxo obrigatório:

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei pelo menos 3 Views;
- [x] pelo menos uma View usa JOIN;
- [X] pelo menos uma View usa agregação ou resumo;
- [X] consultei as Views;
- [X] utilizei `CREATE OR REPLACE VIEW`;
- [X] pratiquei `DROP VIEW`;
- [x] validei as Views;
- [x] testei mudança em tabela base;
- [x] compreendo de onde vêm os dados de cada View;
- [x] salvei `SPRINT3-5.md`;
- [x] salvei `SPRINT3-5.sql`.

---

# 18. Git/GitHub

Continue utilizando:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT3-5.md
Module-2/SPRINT3-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 3 de 5 - views
```

**Ainda não abra o Pull Request final.**

---

# Próxima etapa

Na Sprint 4/5 serão trabalhados:

```sql
CREATE PROCEDURE
CALL
IN
OUT
CREATE FUNCTION
RETURN
IF
ELSE
```
