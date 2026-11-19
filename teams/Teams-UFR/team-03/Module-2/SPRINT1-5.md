# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# Objetivo da Sprint 1/5

Continuar usando o banco do `Module-1` (`db_restaurante_sabor`) e consultar dados espalhados em várias tabelas com `INNER JOIN`, `LEFT JOIN` e `RIGHT JOIN`, combinando com `WHERE`, `ORDER BY`, `GROUP BY` e funções de agregação.

---

# 1. Estrutura do repositório

```text
teams/Teams-UFR/team-03/Module-2/
├── SPRINT1-5.md
└── SPRINT1-5.sql
```

Os arquivos do `Module-1` não foram alterados.

---

# 2. Identificação

**Nome completo:**

> Gabriel Sakaizawa Campos

**Branch:**

```text
team-03
```

**Nome do banco:**

```text
db_restaurante_sabor
```

**Tema do projeto:**

> Sistema de gerenciamento do restaurante "Sabor": clientes, mesas, funcionários, produtos, pedidos e itens de cada pedido.

---

# 3. Retomada do banco

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | `cliente` | `id_cliente` | — |
| 2 | `funcionario` | `id_funcionario` | — |
| 3 | `mesa` | `id_mesa` | — |
| 4 | `produto` | `id_produto` | — |
| 5 | `pedido` | `id_pedido` | `id_cliente`, `id_mesa`, `id_funcionario` |
| 6 | `item_pedido` | `id_item_pedido` | `id_pedido`, `id_produto` |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| `cliente` | 1:N | `pedido` | `pedido.id_cliente` |
| `mesa` | 1:N | `pedido` | `pedido.id_mesa` |
| `funcionario` | 1:N | `pedido` | `pedido.id_funcionario` |
| `pedido` | 1:N | `item_pedido` | `item_pedido.id_pedido` |
| `produto` | 1:N | `item_pedido` | `item_pedido.id_produto` |

(`pedido` e `produto` têm relação N:M, resolvida pela tabela `item_pedido`.)

---

# 5. INNER JOIN

O `INNER JOIN` retorna apenas os registros que têm correspondência nas duas tabelas.

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Qual é o cliente de cada pedido?

**Tabelas utilizadas:**

```text
pedido, cliente
```

**PK/FK utilizadas:**

```text
cliente.id_cliente (PK) = pedido.id_cliente (FK)
```

**SQL:**

```sql
SELECT p.id_pedido, c.nome AS cliente, p.data_pedido, p.status
FROM pedido AS p
INNER JOIN cliente AS c ON p.id_cliente = c.id_cliente
ORDER BY p.id_pedido;
```

**Explique o resultado:**

> Cada linha é um pedido com o nome do cliente que o fez. Foram 5 linhas: Ana Souza aparece duas vezes (pedidos 1 e 3), porque um cliente pode ter vários pedidos.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais produtos estão em cada pedido e quanto custa cada item?

```sql
SELECT ip.id_pedido, pr.nome AS produto, ip.quantidade, ip.preco_unitario,
       ip.quantidade * ip.preco_unitario AS subtotal
FROM item_pedido AS ip
INNER JOIN produto AS pr ON ip.id_produto = pr.id_produto
ORDER BY ip.id_pedido, pr.nome;
```

**Explique:**

> Liga `item_pedido` a `produto` pelo `id_produto` para trocar o número do produto pelo nome. Também calcula `quantidade * preco_unitario` como subtotal. Retornou os 10 itens do banco.

---

# 6. LEFT JOIN

## Consulta obrigatória

**Pergunta:**

> Quais pedidos cada funcionário atendeu, incluindo funcionários que não atenderam nenhum?

```sql
SELECT f.id_funcionario, f.nome AS funcionario, f.cargo, p.id_pedido
FROM funcionario AS f
LEFT JOIN pedido AS p ON f.id_funcionario = p.id_funcionario
ORDER BY f.id_funcionario, p.id_pedido;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Mantém todos os funcionários (tabela da esquerda). A Fernanda Dias (Gerente) não atendeu pedido nenhum e aparece com `NULL` em `id_pedido`. Com `INNER JOIN` ela sumiria do resultado.

---

# 7. RIGHT JOIN

## Consulta obrigatória

**Pergunta:**

> Quais pedidos cada mesa recebeu, incluindo mesas sem pedido?

```sql
SELECT m.numero AS mesa, m.status, p.id_pedido
FROM pedido AS p
RIGHT JOIN mesa AS m ON p.id_mesa = m.id_mesa
ORDER BY m.numero, p.id_pedido;
```

**Explique o resultado:**

> O `RIGHT JOIN` mantém todas as linhas da tabela da direita (`mesa`). Hoje todas as 5 mesas têm exatamente um pedido, então nenhum `NULL` aparece, mas se uma mesa não tivesse pedido ela continuaria na lista.

---

# 8. JOIN com três ou mais tabelas

## Consulta 1

**Pergunta:**

> Qual cliente, atendente e mesa de cada pedido?

```sql
SELECT p.id_pedido, c.nome AS cliente, f.nome AS atendente, m.numero AS mesa
FROM pedido AS p
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa
ORDER BY p.id_pedido;
```

## Consulta 2

**Pergunta:**

> O que cada cliente consumiu, produto por produto?

```sql
SELECT c.nome AS cliente, p.id_pedido, pr.nome AS produto, ip.quantidade,
       ip.quantidade * ip.preco_unitario AS subtotal
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
INNER JOIN produto     AS pr ON ip.id_produto = pr.id_produto
ORDER BY c.nome, p.id_pedido;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais itens estão em pedidos que ainda estão abertos?

```sql
SELECT p.id_pedido, pr.nome AS produto, ip.quantidade
FROM pedido AS p
INNER JOIN item_pedido AS ip ON p.id_pedido = ip.id_pedido
INNER JOIN produto     AS pr ON ip.id_produto = pr.id_produto
WHERE p.status = 'aberto'
ORDER BY p.id_pedido;
```

**Explique o filtro:**

> O `JOIN` junta as tabelas e o `WHERE p.status = 'aberto'` descarta o pedido 1 (finalizado). Sobram 8 itens, dos pedidos 2, 3, 4 e 5.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Quais produtos foram vendidos, do mais caro ao mais barato?

```sql
SELECT pr.nome AS produto, pr.preco, ip.id_pedido, ip.quantidade
FROM produto AS pr
INNER JOIN item_pedido AS ip ON pr.id_produto = ip.id_produto
ORDER BY pr.preco DESC, ip.id_pedido;
```

---

# 11. JOIN + GROUP BY + agregação

**Pergunta:**

> Quantos pedidos e quanto cada cliente gastou no total?

```sql
SELECT c.nome AS cliente,
       COUNT(DISTINCT p.id_pedido) AS qtd_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC;
```

**Explique o agrupamento:**

> O `GROUP BY` junta todas as linhas do mesmo cliente em uma só. `COUNT(DISTINCT p.id_pedido)` conta os pedidos (o `DISTINCT` evita contar o mesmo pedido uma vez por item) e `SUM(...)` soma o valor dos itens. Resultado: Ana Souza 2 pedidos / R$ 161,70; Mariana Silva R$ 149,00; Carlos Lima R$ 77,00; Pedro Santos R$ 29,00.

---

# 12. Quantidade mínima exigida

| Exigência | Atendida em |
|---|---|
| 2 INNER JOIN | seção 5 |
| 1 LEFT JOIN | seção 6 |
| 1 RIGHT JOIN | seção 7 |
| 2 consultas com 3+ tabelas | seção 8 |
| 1 JOIN + WHERE | seção 9 |
| 1 JOIN + ORDER BY | seção 10 |
| 1 JOIN + GROUP BY + agregação | seção 11 (e 2 outras no `.sql`) |

---

# 13. Consulta mais útil

**Pergunta:**

> Quanto cada funcionário faturou, incluindo quem não vendeu nada?

```sql
SELECT f.nome AS funcionario, f.cargo,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0) AS faturamento
FROM funcionario AS f
LEFT JOIN pedido      AS p  ON f.id_funcionario = p.id_funcionario
LEFT JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
GROUP BY f.id_funcionario, f.nome, f.cargo
ORDER BY faturamento DESC;
```

**Por que ela é útil?**

> O gerente consegue comparar o desempenho da equipe. O `LEFT JOIN` mantém a Fernanda (R$ 0,00) e o `COALESCE` troca o `NULL` por 0. Resultado: João R$ 161,70; Rafael R$ 149,00; Marcos R$ 77,00; Patrícia R$ 29,00; Fernanda R$ 0,00.

---

# 14. Validação prática obrigatória

Seção 14, Validação prática (consulta de total gasto por cliente)

Participam as tabelas cliente, pedido e item_pedido.
As PKs usadas são cliente.id_cliente e pedido.id_pedido.
As FKs usadas são pedido.id_cliente e item_pedido.id_pedido.
O ON diz como as linhas de duas tabelas se encontram: ele compara a FK de uma com a PK da outra, e assim cada pedido é ligado ao cliente certo.
Se a condição estivesse errada, o banco juntaria linhas que não têm a ver. Sem condição nenhuma, cada cliente seria combinado com todos os itens (produto cartesiano) e os totais ficariam falsos.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
SELECT f.nome AS funcionario, f.cargo,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0) AS faturamento
FROM funcionario AS f
LEFT JOIN pedido      AS p  ON f.id_funcionario = p.id_funcionario
LEFT JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
GROUP BY f.id_funcionario, f.nome, f.cargo
ORDER BY faturamento DESC;
```

**Resultado esperado:**

> 5 linhas, uma por funcionário, com a Fernanda com 0 pedidos e faturamento 0,00.

**Resultado obtido:**

> Igual ao esperado: João Pereira 2 pedidos / 161,70; Rafael Nunes 1 / 149,00; Marcos Almeida 1 / 77,00; Patrícia Rocha 1 / 29,00; Fernanda Dias 0 / 0,00. O script inteiro foi executado sem erros (testado em MySQL 8.0 com `ONLY_FULL_GROUP_BY` ligado).

---

# 16. Problemas encontrados

Ana apareceu com 4 pedidos em vez de 2	COUNT(p.id_pedido) conta uma vez por item, e cada pedido tem 2 itens	Usar COUNT(DISTINCT p.id_pedido)
Erro 1055 ao incluir p.status no SELECT	Coluna fora do GROUP BY com ONLY_FULL_GROUP_BY ligado	Colocar a coluna no GROUP BY ou tirá-la do SELECT
Fernanda (gerente) sumia do resultado	INNER JOIN descarta quem não tem pedido	Trocar por LEFT JOIN

---

# 17. Uso de LLMs

Usei uma LLM para me sugerir as consultas e tirar dúvidas. Depois li cada uma, troquei os nomes pelos das minhas tabelas, rodei no MySQL e conferi o resultado com os dados que eu inseri. Sei explicar o que cada JOIN e cada ON fazem.

---

# 18. Estrutura do SPRINT1-5.sql

O arquivo segue a ordem: `USE`, INNER JOIN 1 e 2, LEFT JOIN, RIGHT JOIN, JOIN com 3+ tabelas (2), JOIN + WHERE, JOIN + ORDER BY, JOIN + GROUP BY + agregação e a consulta mais útil.

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
- [x] testei tudo no MySQL;
- [x] consigo explicar as consultas;
- [x] salvei `SPRINT1-5.md`;
- [x] salvei `SPRINT1-5.sql`.

---

# 20. Git/GitHub

Branch `team-03`. Arquivos: `Module-2/SPRINT1-5.md` e `Module-2/SPRINT1-5.sql`.

```text
Conclui Module 2 Sprint 1 de 5 - JOINs
```
