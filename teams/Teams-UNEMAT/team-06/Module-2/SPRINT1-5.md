# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# Objetivo da Sprint 1/5

Nesta primeira Sprint do **Module-2**, cada aluno deverá continuar utilizando o mesmo banco de dados desenvolvido no `Module-1`.

O foco agora será a consulta de dados relacionados entre duas ou mais tabelas por meio de:

```sql
INNER JOIN
LEFT JOIN
RIGHT JOIN
ON
AS
WHERE
ORDER BY
GROUP BY
COUNT
SUM
AVG
MIN
MAX
```

Ao final da Sprint, o aluno deverá ser capaz de identificar as tabelas necessárias, reconhecer PK e FK envolvidas, construir consultas com `JOIN`, interpretar os resultados e explicar presencialmente como cada consulta funciona.

> **Importante:** não crie um novo banco. Utilize o mesmo projeto desenvolvido no `Module-1`.

---

# 1. Estrutura do repositório

Os arquivos desta Sprint deverão ficar em:

```text
teams/Teams-UNEMAT/team-XX/Module-2/
```

Ao final:

```text
Module-2/
├── SPRINT1-5.md
└── SPRINT1-5.sql
```

Não altere nem apague os arquivos do `Module-1`.

---

# 2. Identificação

**Nome completo:**

> Mariano Lino da Silva Neto

**Branch:**

```text
Team 06
```

**Nome do banco:**

```DB_Conveniencia
```

**Tema do projeto:**

> Sistema de controle de estoque e vendas para uma loja de conveniência.

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | Categoria | id_categoria | Nenhuma |
| 2 | Produto | id_produto | id_categoria |
| 3 | Venda | id_venda | Nenhuma |
| 4 | Item_venda | id_venda, Id_produto | id_venda, Id_produto |
| 5 |  |  |  |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| Categoria | 1:N | Produto | id_categoria |
| Venda | 1:N | item_venda | id_venda |
| Produto | 1:N | item_venda | id_produto |
|  |  |  |  |

---

# 5. INNER JOIN

O `INNER JOIN` retorna registros que possuem correspondência nas tabelas relacionadas.

Exemplo genérico:

```sql
SELECT
    a.campo,
    b.campo
FROM tabela_a AS a
INNER JOIN tabela_b AS b
    ON a.id = b.id_a;
```

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Quais os nomes dos produtos cadastrados e também das categorias que eles pertencem?

**Tabelas utilizadas:**

```
Produto, Categoria
```

**PK/FK utilizadas:**

```
Categoria.id_categoria (PK) = Produto.id_categoria (FK)
```

**SQL:**

```sql
SELECT
p.nome_produto,
c.nome_categoria,
p.preco_venda
FROM Produto AS p
INNER JOIN Categoria as c
ON p.id_categoria = c.id_categoria;
```

**Explique o resultado:**

> A tabela INNER JOIN vai ir na tabela produto e pegar a chave estrangeira de cada item e vai criar uma ponte até a tabela Categoria procurando a chave primaria que corresponda, e o resultado vai ser o nome em forma de texto no lugar de mostrar os numeros de ID.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais produtos estão contidos dentro dos cupons de venda gerados no sistema?

```sql
SELECT
v.id_venda,
v.data_venda,
p.nome_produto
FROM Item_venda as iv
INNER JOIN Venda AS v
ON iv.id_venda = v.id_venda
INNER JOIN Produto AS p
ON iv.id_produto = p.id_produto;
```

**Explique:**

> O INNER JOIN vai traduzir a tabela item_venda e pegar os IDs conectando ela a tabela venda puxando a data e com isso a gente puxa a tabela produto para puxar o nome do item.
---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais são todas as categorias da loja, mostrando todos os produtos que existem nelas.

```
SELECT
p.nome_produto,
c.nome_categoria
FROM Categoria AS c
LEFT JOIN Produto AS p
ON c.id_categoria = p.id_categoria;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Ele ajuda a visualizar categorias que estão vazias pq elas vão aparecer NULL na tela no lugar da coluna de produto.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais são todos os produtos do catalogo e seus registros de venda?

```sql
SELECT
iv.id_venda,
p.nome_produto
FROM Item_venda AS iv
RIGHT JOIN Produto AS p
ON iv.id_produto = p.id_produto;
```

**Explique o resultado:**

> Ele vai mostrar todos os registros da tabela produto e vai garantir que elas apareçam no resultado final, se existir algum produto que nunca foi comprado e passado pelo caixa ele vai aparecer na lista coluna id_venda preenchida como NULL, ajudando a gerência a ver o que está parado no estoque.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Para cada cupom de venda que foi gerado, quais foram as categorias e produtos vendidos, junto com a data de compra?

```sql
SELECT
v.id_venda,
v.data_venda,
c.nome_categoria,
p.nome_produto
FROM Venda AS v
INNER JOIN Item_venda AS iv
ON v.id_venda = iv.id_venda
INNER JOIN Produto as p
ON iv.id_produto = p.id_produto
INNER JOIN Categoria as c
ON p.id_categoria = c.id_categoria;
```

## Consulta 2

**Pergunta:**

> Qual é o detalhe financeiro dos itens? compondo: Categoria, Produto e quantidade de venda na primeira transação.

```sql
SELECT
c.nome_categoria,
p.nome_produto,
iv.quantidade,
v.valor_total
FROM Categoria AS c
INNER JOIN Produto as p
ON c.id_categoria = p.id_categoria
INNER JOIN Item_venda AS iv
ON p.id_produto = iv.id_produto
INNER JOIN Venda as v
ON iv.id_venda = v.id_venda
WHERE v.id_venda = 1;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais produtos da Categoria Cobras já foram vendidos?

```sql
SELECT
v.id_venda,
p.nome_produto,
c.nome_categoria
FROM Item_venda AS iv
INNER JOIN Produto as p
ON iv.id_produto = p.id_produto
INNER JOIN Categoria as c
ON p.id_categoria = c.id_categoria
INNER JOIN Venda AS v
ON iv.id_venda = v.id_venda
WHERE c.nome_categoria = 'Cobras';
```

**Explique o filtro:**

> Dito isso temos uma logica onde o Banco constroi uma tabela temporaria unindo todos os cupons e os produtos e também as categorias do ON e em seguida o WHERE filtra e deixa tudo que não estiver com o nome_categoria = salgado fora da lista final.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Qual a Lista de todos os produtos com suas categorias, ordenada dos mais caros para os mais baratos?

```sql
SELECT 
    p.nome_produto, 
    c.nome_categoria, 
    p.preco_venda
FROM Produto AS p
INNER JOIN Categoria AS c
    ON p.id_categoria = c.id_categoria
ORDER BY p.preco_venda DESC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Qual foi a quantidade total vendida de cada produto registrado nos cupons?

```sql
SELECT 
    p.nome_produto, 
    SUM(iv.quantidade) AS total_unidades_vendidas
FROM Produto AS p
INNER JOIN Item_Venda AS iv
    ON p.id_produto = iv.id_produto
GROUP BY p.nome_produto;
```

**Explique o agrupamento:**

> Como o mesmo produto pode ser vendido em 10 cupons diferentes, a tabela Item_venda terá 10 linhas para ele O GROUP BY aglomera todas as linhas que têm o mesmo nome_produto num bloco só, enquanto a agregação SUM soma os números da coluna de quantidade dentro desse bloco, revelando quantos itens daquele produto sairam da loja total

---

# 12. Quantidade mínima exigida

O `SPRINT1-5.sql` deverá conter, no mínimo:

```text
2 INNER JOIN
1 LEFT JOIN
1 RIGHT JOIN
2 consultas envolvendo 3 ou mais tabelas
1 JOIN + WHERE
1 JOIN + ORDER BY
1 JOIN + GROUP BY + agregação
```

As consultas devem responder perguntas reais sobre o banco.

---

# 13. Consulta mais útil

**Pergunta:**

> Qual é o faturamento total da loja dividido por categorias de produtos?

```sql
SELECT 
    c.nome_categoria, 
    SUM(p.preco_venda * iv.quantidade) AS faturamento_por_categoria
FROM Categoria AS c
INNER JOIN Produto AS p
    ON c.id_categoria = p.id_categoria
INNER JOIN Item_Venda AS iv
    ON p.id_produto = iv.id_produto
GROUP BY c.nome_categoria;
```

**Por que ela é útil?**

>  Ela permite entender de onde está vindo o lucro do estabelecimento enquanto ajuda na reposição inteligente do Estoque
---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
SELECT 
    p.nome_produto, 
    c.nome_categoria 
FROM Produto AS p
INNER JOIN Categoria AS c
    ON p.id_categoria = c.id_categoria;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> Produto(p) e Categoria(c)
id_categoria na tabela Categoria
id_categoria na tabela Produto
ela ensina o banco a verificar cada linha da tabela produto pegando o numero dentro do campo FK e parando na linha da categoria que possui o exato mesmo numero na PK
Se por ventura eu fizesse burrice e erra-se então meu banco iria misturar cada produto com todas as categorias que existem ao mesmo tempo.
---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```
SELECT p.nome_produto, c.nome_categoria 
FROM Produto AS p 
INNER JOIN Categoria AS c ON p.id_categoria = c.id_categoria;
```

**Resultado esperado:**

> Uma tabela com duas colunas onde o pão frito esteja alinhado com pão fresco

**Resultado obtido:**

> Faça o teste de mesa e você vai me dizer oq rolou meu nego.
---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 17. Uso de LLMs

LLMs podem ser utilizadas como apoio, mas todo código deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

O aluno deverá ser capaz de explicar presencialmente qualquer consulta entregue.

---

# 18. Estrutura recomendada do SPRINT1-5.sql

```sql
-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- INNER JOIN 1

-- INNER JOIN 2

-- LEFT JOIN

-- RIGHT JOIN

-- JOIN COM 3+ TABELAS 1

-- JOIN COM 3+ TABELAS 2

-- JOIN + WHERE

-- JOIN + ORDER BY

-- JOIN + GROUP BY + AGREGAÇÃO
```

---

# 19. Checklist

- [x] utilizei o mesmo banco do Module-1;
- [x] identifiquei PKs e FKs;
- [x] produzi 2 `INNER JOIN`;
- [x] produzi 1 `LEFT JOIN`;
- [x] produzi 1 `RIGHT JOIN`;
- [x] produzi consultas com 3 ou mais tabelas;
- [x] utilizei `WHERE`;
- [x] utilizei `ORDER BY`;
- [x] utilizei agregação e `GROUP BY`;
- [x] as consultas respondem perguntas reais;
- [x] testei tudo no MySQL Workbench;
- [x] consigo explicar as consultas;
- [x] salvei `SPRINT1-5.md`;
- [x] salvei `SPRINT1-5.sql`.

---

# 20. Git/GitHub

Continue utilizando:

```text
team-XX
```

Arquivos do commit:

```text
Module-2/SPRINT1-5.md
Module-2/SPRINT1-5.sql
```

Mensagem sugerida:

```text
Conclui Module 2 Sprint 1 de 5 - JOINs
```

**Não abra o Pull Request final nesta Sprint.**

---

# Próxima etapa

Na Sprint 2/5 serão trabalhadas subconsultas:

```sql
IN
NOT IN
EXISTS
NOT EXISTS
subconsultas correlacionadas
```
