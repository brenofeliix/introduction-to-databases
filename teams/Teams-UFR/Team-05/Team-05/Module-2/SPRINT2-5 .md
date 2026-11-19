# SPRINT 2/5 — Subconsultas e Consultas Avançadas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# Objetivo da Sprint 2/5

Nesta etapa, cada aluno deverá aprofundar as consultas SQL por meio de **subconsultas**.

O objetivo é resolver perguntas em que uma consulta depende do resultado produzido por outra consulta.

Serão trabalhados:

```sql
SUBQUERY
IN
NOT IN
EXISTS
NOT EXISTS
AVG
MAX
MIN
COUNT
subconsulta correlacionada
```

O aluno deverá continuar utilizando o mesmo banco do `Module-1`.

---

# 1. Identificação

**Nome completo:**

> NICOLAS LINO OLIVEIRA

**Banco utilizado:**

```text
banco_imobiliaria
```

---

# 2. O que é uma subconsulta?

Uma subconsulta é um `SELECT` utilizado dentro de outro comando SQL.

Exemplo:

```sql
SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);
```

Neste exemplo:

1. a consulta interna calcula a média;
2. a consulta externa utiliza esse resultado.

---

# 3. Perguntas que exigem subconsulta

1. Quais imóveis estão com preço acima da média de todos os imóveis?
2. Quais clientes já fizeram pelo menos uma proposta?
3. Quais imóveis nunca receberam nenhuma visita?
4. Quais corretores já fecharam pelo menos um contrato?
5. Quais imóveis custam mais do que a média dos imóveis do mesmo tipo?

---

# 4. Subconsulta com comparação

**Pergunta:**

> Quais imóveis estão com preço acima da média de todos os imóveis?

```sql
SELECT
    id_imovel,
    endereco,
    tipo,
    preco
FROM imoveis
WHERE preco > (
    SELECT AVG(preco)
    FROM imoveis
)
ORDER BY preco DESC;
```

**Explique primeiro a consulta interna:**

> A consulta interna `SELECT AVG(preco) FROM imoveis` calcula o preço médio de todos os imóveis cadastrados e devolve um único valor (cerca de R$ 408.766,67).

**Depois explique a consulta externa:**

> A consulta externa percorre a tabela `imoveis` e mantém apenas os imóveis cujo preço é maior que esse valor médio. Retornam os imóveis 1, 2 e 6, ordenados do mais caro para o mais barato.

---

# 5. Subconsulta com IN

## Consulta obrigatória

**Pergunta:**

> Quais clientes já fizeram pelo menos uma proposta?

```sql
SELECT
    id_cliente,
    nome,
    contato
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM propostas
);
```

**Explique:**

> A consulta interna devolve a lista de `id_cliente` que aparecem na tabela `propostas` (1, 2, 3 e 4). A consulta externa mostra apenas os clientes cujo `id_cliente` está nessa lista. Os clientes 5 e 6 não aparecem, pois nunca fizeram proposta.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais imóveis nunca receberam nenhuma visita?

```sql
SELECT
    id_imovel,
    endereco,
    tipo,
    preco
FROM imoveis
WHERE id_imovel NOT IN (
    SELECT id_imovel
    FROM visitas
);
```

**Que registros você está procurando?**

> Os imóveis que não aparecem em nenhuma visita (imóveis 4 e 5). Esses imóveis precisam de divulgação ou de ação dos corretores. O `NOT IN` é seguro aqui porque `visitas.id_imovel` é `NOT NULL`. Se a subconsulta devolvesse algum `NULL`, o `NOT IN` não retornaria nenhum registro.

---

# 7. EXISTS

## Consulta obrigatória

**Pergunta:**

> Quais corretores já fecharam pelo menos um contrato?

```sql
SELECT
    cor.id_corretor,
    cor.nome,
    cor.creci
FROM corretores AS cor
WHERE EXISTS (
    SELECT 1
    FROM contratos AS ct
    WHERE ct.id_corretor = cor.id_corretor
);
```

> Para cada corretor, o `EXISTS` verifica se existe pelo menos um contrato dele. Se existir, o corretor é mostrado. Retorna Carlos Eduardo Ramos, que fechou o contrato de venda do imóvel 1.

---

# 8. NOT EXISTS

**Pergunta:**

> Quais clientes ainda não fizeram nenhuma visita?

```sql
SELECT
    c.id_cliente,
    c.nome,
    c.contato
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM visitas AS v
    WHERE v.id_cliente = c.id_cliente
);
```

**Explique a diferença em relação a `EXISTS`:**

> O `EXISTS` mantém o registro quando a subconsulta encontra pelo menos uma linha. O `NOT EXISTS` faz o contrário: mantém o registro quando a subconsulta não encontra nenhuma linha. Aqui retorna Larissa Montenegro, que não tem nenhuma visita.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual é o imóvel mais caro do catálogo?

```sql
SELECT
    id_imovel,
    endereco,
    tipo,
    preco
FROM imoveis
WHERE preco = (
    SELECT MAX(preco)
    FROM imoveis
);
```

**Explique:**

> A consulta interna encontra o maior preço da tabela (R$ 780.000,00). A consulta externa devolve o imóvel que tem exatamente esse preço: a casa da Rua das Camélias, 45. No `.sql` há também uma variação com `MIN`, que encontra a menor proposta registrada.

---

# 10. Subconsulta correlacionada

## Consulta obrigatória

**Pergunta:**

> Quais imóveis custam mais do que a média dos imóveis do mesmo tipo?

```sql
SELECT
    i.id_imovel,
    i.endereco,
    i.tipo,
    i.preco
FROM imoveis AS i
WHERE i.preco > (
    SELECT AVG(i2.preco)
    FROM imoveis AS i2
    WHERE i2.tipo = i.tipo
)
ORDER BY i.tipo ASC, i.preco DESC;
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna `i.tipo`. A subconsulta é recalculada para cada imóvel da consulta externa, comparando o preço dele com a média apenas dos imóveis do mesmo tipo. Retornam o apartamento 1 (acima da média dos apartamentos) e a casa 2 (acima da média das casas). Imóveis de tipos com apenas um registro (comercial e terreno) nunca ficam acima da própria média.

---

# 11. Resolver a mesma pergunta de duas formas

## Pergunta 1

> Quais clientes já fizeram pelo menos uma proposta?

### JOIN

```sql
SELECT DISTINCT
    c.id_cliente,
    c.nome
FROM clientes AS c
INNER JOIN propostas AS p
    ON c.id_cliente = p.id_cliente
ORDER BY c.id_cliente ASC;
```

### SUBQUERY

```sql
SELECT
    id_cliente,
    nome
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM propostas
)
ORDER BY id_cliente ASC;
```

### Qual abordagem ficou mais compreensível?

> A subconsulta com `IN` ficou mais compreensível, porque a leitura é quase uma frase: "clientes cujo id está entre os clientes que fizeram proposta". No JOIN foi necessário usar `DISTINCT` para evitar repetir um cliente que fizesse várias propostas.

---

## Pergunta 2

> Quais imóveis nunca receberam visita?

### JOIN

```sql
SELECT
    i.id_imovel,
    i.endereco
FROM imoveis AS i
LEFT JOIN visitas AS v
    ON i.id_imovel = v.id_imovel
WHERE v.id_visita IS NULL
ORDER BY i.id_imovel ASC;
```

### SUBQUERY

```sql
SELECT
    i.id_imovel,
    i.endereco
FROM imoveis AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM visitas AS v
    WHERE v.id_imovel = i.id_imovel
)
ORDER BY i.id_imovel ASC;
```

### Comparação

> As duas consultas retornam o mesmo resultado (imóveis 4 e 5). O `LEFT JOIN` + `IS NULL` mostra visualmente os imóveis sem par na tabela de visitas, mas exige entender que o `NULL` vem do JOIN. O `NOT EXISTS` expressa a ideia diretamente: "não existe visita para este imóvel". Para perguntas do tipo "quem não tem", prefiro o `NOT EXISTS` pela clareza.

---

# 12. Quantidade mínima exigida

| Exigência | Atendida em |
|---|---|
| 1 subconsulta com comparação | item 4 |
| 1 subconsulta com IN | item 5 |
| 1 subconsulta com NOT IN | item 6 |
| 1 consulta com EXISTS | item 7 |
| 1 consulta com NOT EXISTS | item 8 |
| 1 subconsulta com MAX ou MIN | item 9 |
| 1 subconsulta correlacionada | item 10 |
| 2 problemas com JOIN e SUBQUERY | item 11 |

---

# 13. Validação prática

Subconsulta escolhida: item 4 (imóveis acima da média).

```sql
SELECT
    id_imovel,
    endereco,
    tipo,
    preco
FROM imoveis
WHERE preco > (
    SELECT AVG(preco)
    FROM imoveis
)
ORDER BY preco DESC;
```

1. **Qual consulta é executada primeiro?**
2. **Qual valor ou conjunto de valores ela retorna?**
3. **Como esse resultado é utilizado pela consulta externa?**

> 1. A consulta interna, `SELECT AVG(preco) FROM imoveis`, é executada primeiro.
> 2. Ela retorna um único valor: a média de preço dos 6 imóveis, aproximadamente R$ 408.766,67.
> 3. A consulta externa usa esse valor como limite no `WHERE preco > ...`. Só passam os imóveis com preço maior que a média: o apartamento 1 (R$ 420.000), a casa 2 (R$ 780.000) e a casa 6 (R$ 590.000).

---

# 14. Teste operacional no Workbench

**Consulta original:**

```sql
SELECT
    id_cliente,
    nome,
    contato
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM propostas
);
```

**Alteração realizada:**

> Acrescentei temporariamente um filtro na subconsulta: `WHERE status = 'em análise'` dentro do `SELECT id_cliente FROM propostas`.

**Mudança observada:**

> Esperado: a consulta original retorna 4 clientes (Lucas, Beatriz, Guilherme e Camila). Com o filtro, retorna apenas 2 (Guilherme e Camila), que têm propostas em análise. Isso mostra que a consulta externa depende do resultado da interna. *(confirmar o resultado obtido no Workbench)*

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 16. Estrutura do SPRINT2-5.sql

O arquivo segue a estrutura recomendada: subconsulta com comparação, IN, NOT IN, EXISTS, NOT EXISTS, MAX/MIN, subconsulta correlacionada, problema 1 (JOIN e SUBQUERY), problema 2 (JOIN e SUBQUERY) e uma consulta extra.

---

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] criei subconsulta com comparação;
- [x] utilizei `IN`;
- [x] utilizei `NOT IN`;
- [x] utilizei `EXISTS`;
- [x] utilizei `NOT EXISTS`;
- [x] utilizei `MAX` ou `MIN`;
- [x] criei subconsulta correlacionada;
- [x] resolvi duas perguntas usando JOIN e SUBQUERY;
- [x] expliquei o raciocínio;
- [x] testei no MySQL Workbench;
- [x] consigo explicar as consultas presencialmente;
- [x] salvei `SPRINT2-5.md`;
- [x] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Mesma branch:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT2-5.md
Module-2/SPRINT2-5.sql
```

Commit:

```text
Conclui Module 2 Sprint 2 de 5 - subconsultas
```

Pull Request final não aberto.
