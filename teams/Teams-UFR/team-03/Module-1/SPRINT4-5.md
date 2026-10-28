# SPRINT 4/5 — Consultas SQL e Expressões

**Aluno:** Gabriel Sakaizawa Campos
**Banco:** db_restaurante_sabor

---

## 1. Consultas básicas

### Consulta 01 — SELECT básico
**Pergunta:** Quais são todos os produtos cadastrados no cardápio?
```sql
SELECT * FROM produto;
```
Retorna as 5 linhas de `produto` com todas as colunas (id, nome, categoria, preço).

### Consulta 02 — colunas específicas
**Pergunta:** Quais são apenas os nomes e preços dos produtos?
```sql
SELECT nome, preco FROM produto;
```

---

## 2. WHERE

### Consulta 03
**Pergunta:** Quais produtos são da categoria "Bebida"?
**Resultado:** Refrigerante Lata (R$ 6,00) e Suco Natural (R$ 8,50).

### Consulta 04 (duas condições)
**Pergunta:** Quais pratos principais custam mais de R$ 50,00?
**Filtro:** `categoria = 'Prato principal' AND preco > 50`
**Resultado:** Picanha na Chapa (R$ 68,50) — a Feijoada (R$ 45,90) fica de fora por não passar dos R$ 50.

---

## 3. ORDER BY

### Consulta 05
**Pergunta:** Quais são os produtos do mais caro para o mais barato?
**Resultado (ordem):** Picanha (68,50) → Feijoada (45,90) → Pudim (12,00) → Suco (8,50) → Refrigerante (6,00).

---

## 4. Funções de agregação

### COUNT
**Pergunta:** Quantos pedidos cada funcionário atendeu?
**Resultado:** João Pereira: 2 · Marcos Almeida: 1 · Rafael Nunes: 1 · Patrícia Rocha: 1 · Fernanda Dias (gerente): 0.

### SUM
**Pergunta:** Qual o valor total de cada pedido?
**Resultado:** Pedido 1: R$ 103,80 · Pedido 2: R$ 77,00 · Pedido 3: R$ 57,90 · Pedido 4: R$ 149,00 · Pedido 5: R$ 29,00.

### AVG
**Pergunta:** Qual o preço médio dos produtos por categoria?
**Resultado:** Prato principal: R$ 57,20 · Bebida: R$ 7,25 · Sobremesa: R$ 12,00.

### MIN / MAX
**Pergunta:** Qual o produto mais barato e o mais caro do cardápio?
**Resultado:** mais barato = Refrigerante Lata (R$ 6,00); mais caro = Picanha na Chapa (R$ 68,50).

---

## 5. GROUP BY

**Pergunta:** Quantos pedidos existem em cada status?
**Resultado:** aberto: 4 · finalizado: 1 (o Pedido 1 foi finalizado via UPDATE na Sprint 3/5).

---

## 6. HAVING

**Pergunta:** Quais categorias de produto têm preço médio acima de R$ 10,00?
**Resultado:** Prato principal (R$ 57,20) e Sobremesa (R$ 12,00) — a categoria Bebida fica de fora, pois sua média é R$ 7,25.
**Por que HAVING foi necessário:** o filtro é aplicado sobre o resultado já agrupado (a média por categoria), e não sobre linhas individuais da tabela `produto` — por isso não seria possível usar `WHERE` aqui.

---

## 7. Expressões SQL

**Pergunta:** Qual o subtotal (quantidade × preço unitário) de cada item de pedido?
```sql
SELECT quantidade, preco_unitario, quantidade * preco_unitario AS subtotal
FROM item_pedido;
```
Cada linha mostra o cálculo do valor gasto naquele item específico do pedido.

---

## Consultas extras

- **Faturamento total do restaurante:** soma de todos os `quantidade * preco_unitario` de `item_pedido` = **R$ 416,70**.
- **Mesas ocupadas:** apenas a Mesa 1 (capacidade 2), atualizada como "ocupada" na Sprint 3/5.

---

## Consulta mais útil

**Pergunta:** Qual o valor total de cada pedido?
Essa é a consulta mais aplicável ao dia a dia do restaurante: é ela que permite fechar a conta de um cliente, sabendo exatamente quanto cada pedido soma.

## Consulta mais complexa

**Pergunta:** Quantos pedidos cada funcionário atendeu?
A dificuldade aqui foi usar `LEFT JOIN` entre `funcionario` e `pedido` (em vez de `INNER JOIN`), para que funcionários sem nenhum pedido atendido (como a gerente Fernanda) ainda aparecessem no resultado, com contagem zero.

---

## Registro das consultas

| Nº | Pergunta | Recursos SQL utilizados | Funcionou? |
|---:|---|---|---|
| 1 | Quais produtos existem no cardápio? | SELECT | Sim |
| 2 | Quais produtos são bebidas? | SELECT, WHERE | Sim |
| 3 | Quais pratos principais custam mais de R$ 50? | WHERE (2 condições) | Sim |
| 4 | Produtos do mais caro ao mais barato | ORDER BY | Sim |
| 5 | Quantos pedidos cada funcionário atendeu? | COUNT, LEFT JOIN, GROUP BY | Sim |
| 6 | Qual o valor total de cada pedido? | SUM, GROUP BY | Sim (validado no MySQL Workbench) |
| 7 | Preço médio dos produtos por categoria | AVG, GROUP BY | Sim |
| 8 | Categorias com preço médio acima de R$ 10 | HAVING | Sim |

Todas as consultas foram executadas no MySQL Workbench 26.7.0 sem erros. A consulta de `SUM` (linha 6) foi conferida manualmente: os valores retornados (R$ 103,80 / 77,00 / 57,90 / 149,00 / 29,00) bateram exatamente com o cálculo documentado acima.

---

## Checklist da Sprint 4/5

- [x] utilizei o banco das Sprints anteriores;
- [x] confirmei que existem dados suficientes;
- [x] utilizei `SELECT`;
- [x] selecionei colunas específicas;
- [x] utilizei `WHERE`;
- [x] utilizei mais de uma condição;
- [x] utilizei `ORDER BY`;
- [x] utilizei `COUNT`;
- [x] utilizei `SUM`, quando aplicável;
- [x] utilizei `AVG`, quando aplicável;
- [x] utilizei `MIN` ou `MAX`;
- [x] utilizei `GROUP BY`;
- [x] utilizei `HAVING`;
- [x] utilizei aliases com `AS`;
- [x] utilizei expressão SQL quando aplicável;
- [x] minhas consultas respondem perguntas reais;
- [x] testei as consultas no MySQL Workbench;
- [ ] salvei o código em `SPRINT4-5.sql`;
- [ ] preenchi completamente o `SPRINT4-5.md`;
- [ ] revisei os arquivos antes do commit.

---

## Uso de LLM nesta sprint

Utilizei o Claude para gerar as consultas com base na estrutura real das tabelas (DDL da Sprint 2/5) e nos dados inseridos (DML da Sprint 3/5). Cada consulta foi compreendida e adaptada ao domínio do banco antes de ser considerada válida.
