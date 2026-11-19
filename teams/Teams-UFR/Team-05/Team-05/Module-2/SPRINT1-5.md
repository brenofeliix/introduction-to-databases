# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# 1. Estrutura do repositório

```text
teams/Teams-UFR/team-05/Module-2/
├── SPRINT1-5.md
└── SPRINT1-5.sql
```

Os arquivos do `Module-1` não foram alterados nem apagados.

---

# 2. Identificação

**Nome completo:**

> NICOLAS LINO OLIVEIRA

**Branch:**

```text
team-05
```

**Nome do banco:**

```text
banco_imobiliaria
```

**Tema do projeto:**

> Gestão de Imobiliária (Corretores de Imóveis)

---

# 3. Retomada do banco

Foi utilizado o mesmo banco do Module-1, sem criar um novo.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | corretores | id_corretor | — |
| 2 | clientes | id_cliente | — |
| 3 | imoveis | id_imovel | — |
| 4 | gestoes | id_gestao | id_imovel, id_corretor |
| 5 | visitas | id_visita | id_cliente, id_imovel |
| 6 | propostas | id_proposta | id_cliente, id_imovel |
| 7 | contratos | id_contrato | id_imovel, id_cliente, id_corretor |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| clientes | 1:N | visitas | visitas.id_cliente |
| imoveis | 1:N | visitas | visitas.id_imovel |
| clientes | 1:N | propostas | propostas.id_cliente |
| imoveis | 1:N | propostas | propostas.id_imovel |
| corretores | 1:N | gestoes | gestoes.id_corretor |
| imoveis | 1:N | gestoes | gestoes.id_imovel |
| corretores | 1:N | contratos | contratos.id_corretor |

---

# 5. INNER JOIN

O `INNER JOIN` retorna apenas os registros que possuem correspondência nas duas tabelas.

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Quais visitas foram agendadas e qual é o nome do cliente de cada uma?

**Tabelas utilizadas:**

```text
visitas, clientes
```

**PK/FK utilizadas:**

```text
PK: clientes.id_cliente
FK: visitas.id_cliente
```

**SQL:**

```sql
SELECT
    v.id_visita,
    c.nome AS cliente,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
ORDER BY v.data_visita ASC;
```

**Explique o resultado:**

> Retorna uma linha para cada visita, trocando o número do cliente pelo nome dele. Clientes sem nenhuma visita (como Larissa Montenegro) não aparecem, pois o INNER JOIN só mostra quem tem par nas duas tabelas.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais propostas foram feitas, para qual imóvel e qual a diferença entre o preço anunciado e o valor proposto?

```sql
SELECT
    p.id_proposta,
    i.endereco,
    i.preco AS preco_anunciado,
    p.valor_proposto,
    i.preco - p.valor_proposto AS diferenca,
    p.status AS status_proposta
FROM propostas AS p
INNER JOIN imoveis AS i
    ON p.id_imovel = i.id_imovel
ORDER BY p.id_proposta ASC;
```

**Explique:**

> Liga cada proposta ao imóvel pela FK `propostas.id_imovel`. A coluna `diferenca` é uma expressão que mostra quanto o cliente ofereceu abaixo do preço anunciado. Imóveis sem proposta não aparecem.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela da esquerda, mesmo sem correspondência na direita (as colunas da direita vêm como `NULL`).

## Consulta obrigatória

**Pergunta:**

> Quais são todos os clientes, com suas visitas, incluindo os que ainda não fizeram nenhuma visita?

```sql
SELECT
    c.id_cliente,
    c.nome AS cliente,
    v.data_visita,
    v.status AS status_visita
FROM clientes AS c
LEFT JOIN visitas AS v
    ON c.id_cliente = v.id_cliente
ORDER BY c.id_cliente ASC;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Permite ver os clientes que não têm visita. Larissa Montenegro aparece com `NULL` em `data_visita` e `status_visita`. Com `WHERE v.id_visita IS NULL` (variação no `.sql`), a consulta mostra apenas os clientes que nunca visitaram um imóvel, útil para a equipe de vendas entrar em contato.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo sem correspondência na esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais são todos os imóveis e suas propostas, incluindo os imóveis que nunca receberam proposta?

```sql
SELECT
    i.id_imovel,
    i.endereco,
    i.status AS status_imovel,
    p.valor_proposto,
    p.status AS status_proposta
FROM propostas AS p
RIGHT JOIN imoveis AS i
    ON p.id_imovel = i.id_imovel
ORDER BY i.id_imovel ASC;
```

**Explique o resultado:**

> A tabela da direita é `imoveis`, então todos os 6 imóveis aparecem. Os imóveis 4 e 5 não receberam proposta e ficam com `NULL` em `valor_proposto` e `status_proposta`. É o mesmo resultado de um `LEFT JOIN` com as tabelas em ordem trocada.

---

# 8. JOIN com três ou mais tabelas

## Consulta 1

**Pergunta:**

> Qual cliente visitou qual imóvel, em que data e com qual situação?

```sql
SELECT
    c.nome AS cliente,
    i.endereco,
    i.tipo,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel
ORDER BY v.data_visita ASC;
```

> `visitas` é a tabela central: ela guarda as duas FKs, uma para `clientes` e outra para `imoveis`.

## Consulta 2

**Pergunta:**

> Qual corretor é responsável atualmente (gestão ativa) por cada imóvel?

```sql
SELECT
    i.id_imovel,
    i.endereco,
    i.status AS status_imovel,
    cor.nome AS corretor_responsavel,
    cor.creci,
    g.data_inicio
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
WHERE g.data_fim IS NULL
ORDER BY i.id_imovel ASC;
```

> `gestoes` liga imóveis a corretores. O filtro `data_fim IS NULL` garante só a gestão ativa, conforme a regra de negócio da Sprint 1 do Module-1.

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais clientes têm propostas ainda 'em análise' e de quanto é cada oferta?

```sql
SELECT
    c.nome AS cliente,
    c.contato,
    p.valor_proposto,
    p.data_proposta
FROM propostas AS p
INNER JOIN clientes AS c
    ON p.id_cliente = c.id_cliente
WHERE p.status = 'em análise';
```

**Explique o filtro:**

> O JOIN liga a proposta ao cliente, e o `WHERE` descarta as propostas aceitas ou recusadas. Restam as negociações em aberto, com o contato do cliente.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Quais visitas ocorreram em cada imóvel, da mais recente para a mais antiga?

```sql
SELECT
    v.data_visita,
    i.endereco,
    i.tipo,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel
ORDER BY v.data_visita DESC;
```

---

# 11. JOIN + GROUP BY + agregação

**Pergunta:**

> Quantas visitas cada cliente já fez (incluindo quem não fez nenhuma)?

```sql
SELECT
    c.id_cliente,
    c.nome AS cliente,
    COUNT(v.id_visita) AS total_visitas
FROM clientes AS c
LEFT JOIN visitas AS v
    ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_visitas DESC, c.nome ASC;
```

**Explique o agrupamento:**

> O `GROUP BY` forma um grupo por cliente, e o `COUNT(v.id_visita)` conta quantas visitas existem em cada grupo. Foi usado `COUNT(v.id_visita)` e não `COUNT(*)`, porque o `COUNT(*)` contaria 1 linha para o cliente sem visita (a linha com `NULL` do LEFT JOIN) e mostraria um resultado errado. Esta consulta responde à pergunta 2 da Sprint 1 do Module-1.

---

# 12. Quantidade mínima exigida

| Exigência | Atendida em |
|---|---|
| 2 INNER JOIN | itens 5 (consultas 1 e 2) |
| 1 LEFT JOIN | item 6 |
| 1 RIGHT JOIN | item 7 |
| 2 consultas com 3+ tabelas | item 8 (consultas 1 e 2) |
| 1 JOIN + WHERE | item 9 |
| 1 JOIN + ORDER BY | item 10 |
| 1 JOIN + GROUP BY + agregação | item 11 |

---

# 13. Consulta mais útil

**Pergunta:**

> Quantos contratos cada corretor fechou, qual o total vendido e quanto ele recebe de comissão?

```sql
SELECT
    cor.nome AS corretor,
    cor.creci,
    cor.comissao_percentual,
    COUNT(ct.id_contrato) AS contratos_fechados,
    COALESCE(SUM(ct.valor_final), 0) AS total_vendido,
    COALESCE(SUM(ct.valor_final * cor.comissao_percentual / 100), 0) AS comissao_total
FROM corretores AS cor
LEFT JOIN contratos AS ct
    ON cor.id_corretor = ct.id_corretor
GROUP BY cor.id_corretor, cor.nome, cor.creci, cor.comissao_percentual
ORDER BY comissao_total DESC, cor.nome ASC;
```

**Por que ela é útil?**

> Faz parte dos relatórios previstos desde a Sprint 1 do Module-1 (comissões por corretor). A gestora vê quem mais vende e quanto pagar de comissão. O `LEFT JOIN` mantém corretores que ainda não fecharam contrato, e o `COALESCE` mostra 0 no lugar de `NULL`.

---

# 14. Validação prática obrigatória

Consulta escolhida: **INNER JOIN 1** (visitas + clientes).

```sql
SELECT
    v.id_visita,
    c.nome AS cliente,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
ORDER BY v.data_visita ASC;
```

1. **Tabelas que participam:** `visitas` e `clientes`.
2. **PK utilizada:** `clientes.id_cliente`.
3. **FK utilizada:** `visitas.id_cliente`.
4. **O que o `ON` faz:** define a regra de ligação. Cada visita é emparelhada com o cliente cujo `id_cliente` é igual ao `id_cliente` guardado na visita.
5. **Se a condição estivesse errada:** por exemplo, `ON v.id_visita = c.id_cliente`, as visitas seriam ligadas a clientes que não são os donos delas (dados incorretos). Se o `ON` fosse omitido, o resultado seria um produto cartesiano, combinando cada visita com todos os clientes.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
-- INNER JOIN 1 (visitas + clientes)
SELECT
    v.id_visita,
    c.nome AS cliente,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
ORDER BY v.data_visita ASC;
```

**Resultado esperado:**

> 5 linhas (visitas 1 a 5, ordenadas por data), cada uma com o nome do cliente. Larissa Montenegro não aparece, pois a visita dela foi removida na Sprint 3 do Module-1.

**Resultado obtido:**

> A consulta retornou 5 linhas, ordenadas por data (12/03 a 20/03/2026), cada uma com o nome do cliente (Lucas, Beatriz, Guilherme, Camila e Thiago). Larissa Montenegro não apareceu, como esperado. O resultado confirmou que o `INNER JOIN` só mostra registros com correspondência nas duas tabelas.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Cliente sem visita aparecia com total 1 na contagem | `COUNT(*)` conta a linha com `NULL` gerada pelo `LEFT JOIN` | Usar `COUNT(v.id_visita)`, que ignora `NULL` |
| Erro 1055 (`ONLY_FULL_GROUP_BY`) ao agrupar | Coluna no `SELECT` que não estava no `GROUP BY` nem em função de agregação | Incluir todas as colunas não agregadas no `GROUP BY` |
| Corretores sem imóvel sumiam no `LEFT JOIN` | Condição `g.data_fim IS NULL` no `WHERE` eliminava as linhas `NULL` | Mover a condição para o `ON` do JOIN |

---

# 17. Uso de LLMs

Foi utilizada uma LLM como apoio para estruturar as consultas. O código foi revisado, executado no MySQL Workbench e validado, e consigo explicar presencialmente qualquer consulta entregue.

---

# 18. Checklist

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

# 19. Git/GitHub

```text
Module-2/SPRINT1-5.md
Module-2/SPRINT1-5.sql
```

Mensagem de commit:

```text
Conclui Module 2 Sprint 1 de 5 - JOINs
```

Pull Request final não aberto nesta Sprint.
