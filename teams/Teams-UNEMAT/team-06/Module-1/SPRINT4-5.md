# SPRINT 4/5 — Consultas SQL e Expressões

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT4-5.md` + `SPRINT4-5.sql`

---

# Objetivo da Sprint 4/5

Nesta etapa, cada aluno deverá utilizar o banco de dados desenvolvido nas Sprints anteriores para consultar, filtrar, ordenar, agrupar e resumir os dados armazenados.

Nesta Sprint serão trabalhados principalmente:

```sql
SELECT
WHERE
ORDER BY
GROUP BY
HAVING
COUNT
SUM
AVG
MIN
MAX
```

Ao final da atividade, o aluno deverá entregar:

```text
SPRINT4-5.md
SPRINT4-5.sql
```

O arquivo `.md` documentará as consultas e o raciocínio utilizado.  
O arquivo `.sql` conterá todas as consultas efetivamente executadas e testadas no MySQL Workbench.

> Utilize obrigatoriamente o mesmo banco criado nas Sprints anteriores.

---

# 1. Antes de começar

1. Abra o MySQL Workbench.
2. Abra sua conexão.
3. Confirme que o banco da Sprint 2/5 existe.
4. Confirme que os dados da Sprint 3/5 estão disponíveis.
5. Selecione o banco:

```sql
USE nome_do_banco;
```

6. Confira os dados:

```sql
SELECT * FROM nome_da_tabela;
```

---

# 2. Crie o arquivo SPRINT4-5.sql

No MySQL Workbench:

```text
File → New Query Tab
```

Depois:

```text
File → Save Script As...
```

Salve exatamente como:

```text
SPRINT4-5.sql
```

---

# 3. Retome as perguntas da Sprint 1/5

Recupere as perguntas que você definiu anteriormente para o banco.

1. Quais categorias estão cadastradas no sistema?
2. Quais produtos estão com a quantidade de estoque zerada ou baixa?
3. Quais produtos custam mais de R$ 10,00?
4. Quantos produtos temos cadastrados por categoria?
5. Qual foi o valor total arrecadado com todas as vendas?

Agora identifique quais delas exigem:

- consulta simples;
- filtro;
- ordenação;
- agregação;
- agrupamento;
- filtro sobre grupos.

---

# 4. SELECT

Consulta básica:

```sql
SELECT *
FROM nome_tabela;
```

Selecionando colunas específicas:

```sql
SELECT campo_1, campo_2
FROM nome_tabela;
```

## Consulta 1

### Pergunta respondida

> Quais categorias estão Cadastradas no Banco?

### SQL

```sql
SELECT nome_categoria
from Categoria;
```

### Explique o resultado

> Nosso banco varre a categoria e procura todas as colunas com nomes sem trazer os IDs de cada um.
---

# 5. WHERE

Utilize `WHERE` para filtrar registros.

Exemplo:

```sql
SELECT *
FROM produto
WHERE preco > 100;
```

Operadores comuns:

```text
=   igual
<>  diferente
>   maior que
<   menor que
>=  maior ou igual
<=  menor ou igual
```

Também podem ser utilizados:

```sql
AND
OR
LIKE
BETWEEN
IN
IS NULL
IS NOT NULL
```

Exemplo:

```sql
SELECT *
FROM produto
WHERE preco > 100
  AND estoque > 0;
```

## Consulta obrigatória com WHERE

### Pergunta respondida

> Quais produtos possuem valor superior a 15 em vendas?

### SQL

```sql
SELECT nome_produto, preco_venda
from Produto
WHERE preco_venda > 15.00;
```

### Explique o filtro

> Vai fazer uma varredura e descobrir quais produtos possuem valor maior que 15 e vai trazer apenas eles, ignorando todos os outros com valor abaixo disso.

---

# 6. ORDER BY

Ordenação crescente:

```sql
SELECT *
FROM produto
ORDER BY preco ASC;
```

Ordenação decrescente:

```sql
SELECT *
FROM produto
ORDER BY preco DESC;
```

Por mais de uma coluna:

```sql
SELECT *
FROM produto
ORDER BY categoria ASC, preco DESC;
```

## Consulta obrigatória com ORDER BY

### Pergunta respondida

> Qual a lista de produtos ordenhada do mais barato pro mais caro.

### SQL

```sql
select nome_produto, preco_venda
from Produto
ORDER BY preco_venda ASC;

```

---

# 7. Funções de agregação

Principais funções:

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

## COUNT

```sql
SELECT COUNT(*) AS total_registros
FROM nome_tabela;
```

## SUM

```sql
SELECT SUM(campo_numerico) AS total
FROM nome_tabela;
```

## AVG

```sql
SELECT AVG(campo_numerico) AS media
FROM nome_tabela;
```

## MIN e MAX

```sql
SELECT MIN(campo_numerico) AS menor_valor,
       MAX(campo_numerico) AS maior_valor
FROM nome_tabela;
```

---

# 8. Consultas obrigatórias com agregação

## COUNT

```sql
SELECT COUNT(*) AS total_produtos
FROM Produto;
```

**Pergunta respondida:**

> Quantos produtos no total estão cadastrados no catalogo da loja de conveniencia.

## SUM

```sql
SELECT SUM(valot_total) AS total_produtos
from Produto;

```

**Pergunta respondida:**

> Qual foi o valor total das vendas que entrou no caixa da loja de conveniencia de todas as vendas realizadas. 

Caso não seja aplicável ao domínio, justifique.

## AVG

```sql
SELECT AVG(valor_total) AS ticke_medio
FROM Venda;
```

**Pergunta respondida:**

> qual é o valor do ticket medio que os clientes costumam gastar em cada compra na loja.

Caso não seja aplicável ao domínio, justifique.

## MIN ou MAX

```sql
SELECT min(valor_total) as menor_venda,
	Max(valor_total) as maior_venda
	from Venda;
```

**Pergunta respondida:**

> Qual foi a venda mais cara e a mais barata registrada no caixa.

---

# 9. GROUP BY

`GROUP BY` permite agrupar registros.

Exemplo:

```sql
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id;
```

Outro exemplo:

```sql
SELECT status,
       COUNT(*) AS quantidade
FROM pedido
GROUP BY status;
```

## Consulta obrigatória com GROUP BY

### Pergunta respondida

> Quantos Produtos Existem em cada categoria?

### SQL

```sql
SELECT id_categoria, COUNT(*) AS quantidade_itens
from Produto
GROUP BY id_categoria;
```

### Explique o agrupamento

> Ele basicamente junta todas as linhas da tabela pacote que possuem o mesmo Id_categoria e forma pacotes.

---

# 10. HAVING

`WHERE` filtra registros antes do agrupamento.

`HAVING` filtra os grupos após o `GROUP BY`.

Exemplo:

```sql
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id
HAVING COUNT(*) > 5;
```

## Consulta obrigatória com HAVING

### Pergunta respondida

> Quais categorias possuem apenas um produto cadastrado?.

### SQL

```sql
SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;
```

### Por que HAVING foi necessário?

> Porque ele filtra as linhas soltas antes de serem agrupadas e como a gente precisa filtrar alguns valores especificos, era bom filtrar essas linhas soltas antes de agrupar elas.

---

# 11. Expressões SQL

É possível realizar cálculos em consultas.

Exemplo:

```sql
SELECT nome,
       preco,
       preco * 0.90 AS preco_com_desconto
FROM produto;
```

Outro exemplo:

```sql
SELECT quantidade,
       valor_unitario,
       quantidade * valor_unitario AS subtotal
FROM item_pedido;
```

## Consulta com expressão

```sql
SELECT nome_produto,
preco_venda,
Preco_venda * 0.90 AS preco_desconto
FROM Produto
WHERE preco_venda is not null;
```

### Explique o cálculo

>O banco pega o preço da coluna atual, que no caso e o produto + venda e depois multiplica o valor por 0.90 que vai dar no total 10% de desconto, e com isso ele mostra o novo valor, mas sem alterar o valor original.

Caso não seja aplicável ao domínio, justifique.

---

# 12. Consultas mínimas exigidas

O arquivo `SPRINT4-5.sql` deverá possuir, no mínimo:

```text
1 SELECT básico
1 SELECT com colunas específicas
1 consulta com WHERE
1 consulta com mais de uma condição
1 consulta com ORDER BY
1 consulta com COUNT
1 consulta com SUM, quando aplicável
1 consulta com AVG, quando aplicável
1 consulta com MIN ou MAX
1 consulta com GROUP BY
1 consulta com HAVING
1 consulta com expressão, quando aplicável
```

As consultas devem responder perguntas reais sobre o banco.

---

# 13. Evite consultas sem significado

Evite:

```sql
SELECT *
FROM produto
WHERE id_produto > 0;
```

se isso não responde nenhuma necessidade real.

Prefira:

```sql
SELECT nome, estoque
FROM produto
WHERE estoque < 5
ORDER BY estoque ASC;
```

Pergunta:

```text
Quais produtos estão com estoque baixo?
```

---

# 14. Modelo genérico para adaptar

**Não entregue este código sem adaptação.**

```sql
USE db_conveniencia;

-- SELECT básico
SELECT nome_categoria
from Categoria;

-- Colunas específicas
SELECT nome_produto, preco_venda
from Produto;

-- WHERE
SELECT nome_produto, preco_venda
from Produto
WHERE preco_venda > 15.00;

-- Duas condições
SELECT nome_produto, preco_venda, quantidade_estoque
FROM Produto
WHERE preco_venda > 10.00
AND quantidade_estoque >= 50;

-- ORDER BY
select nome_produto, preco_venda
from Produto
ORDER BY preco_venda ASC;


-- COUNT
SELECT id_categoria, COUNT(*) AS quantidade_itens
from Produto
GROUP BY id_categoria;

-- SUM
SELECT SUM(valot_total) AS total_produtos
from Produto;

-- AVG
SELECT AVG(valor_total) AS ticke_medio
FROM Venda;

-- MIN / MAX
SELECT min(valor_total) as menor_venda,
	Max(valor_total) as maior_venda
	from Venda;

-- GROUP BY
SELECT id_categoria, COUNT(*) AS quantidade_itens
from Produto
GROUP BY id_categoria;

-- HAVING
SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;

-- Expressão
SELECT nome_produto,
preco_venda,
Preco_venda * 0.90 AS preco_desconto
FROM Produto
WHERE preco_venda is not null;
```

> Substitua `nome_do_banco`, `tabela_a`, `campo_a1`, `campo_numerico`, `campo_categoria` e demais nomes genéricos pelos nomes reais do seu projeto.

---

# 15. Estrutura recomendada do SPRINT4-5.sql

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Mariano Lino da Silva Neto
-- Banco: db_conveniencia

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE db_conveniencia;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================
SELECT * FROM Venda;
SELECT * FROM Item_venda;
SELECT * FROM Produto;
select nome_produto, preco_venda
from Produto
ORDER BY preco_venda ASC;
-- ============================================================
-- 2. WHERE
-- ============================================================
SELECT nome_categoria
from Categoria;
WHERE id_venda IN('2');

SELECT nome_produto, preco_venda
from Produto
WHERE preco_venda > 15.00;

-- ============================================================
-- 3. ORDER BY
-- ============================================================
select nome_produto, preco_venda
from Produto
ORDER BY preco_venda ASC;

-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================
SELECT SUM(valot_total) AS total_produtos
from Produto;

SELECT COUNT(*) AS total_produtos
FROM Produto;

SELECT AVG(valor_total) AS ticke_medio
FROM Venda;

-- ============================================================
-- 5. GROUP BY
-- ============================================================
SELECT id_categoria, COUNT(*) AS quantidade_itens
from Produto
GROUP BY id_categoria;

SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;

-- ============================================================
-- 6. HAVING
-- ============================================================
SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;

-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================
SELECT nome_produto,
preco_venda,
Preco_venda * 0.90 AS preco_desconto
FROM Produto
WHERE preco_venda is not null;

-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================
SELECT nome_produto, preco_venda, quantidade_estoque
FROM Produto
WHERE preco_venda > 10.00
AND quantidade_estoque >= 50;
```

---

# 16. Passo a passo no MySQL Workbench

## Etapa 1 — Selecione o banco

```sql
USE nome_do_banco;
```

## Etapa 2 — Confira as tabelas

```sql
SELECT * FROM nome_tabela;
```

## Etapa 3 — Escolha uma pergunta

Exemplo:

```text
Quais produtos possuem preço acima de R$ 100?
```

## Etapa 4 — Transforme em SQL

```sql
SELECT nome, preco
FROM produto
WHERE preco > 100;
```

## Etapa 5 — Execute

Execute uma consulta por vez e confira o resultado.

## Etapa 6 — Documente no próprio `.sql`

Exemplo:

```sql
-- Consulta 01
-- Pergunta:
-- Quais produtos possuem estoque abaixo de 5 unidades?

SELECT nome, estoque
FROM produto
WHERE estoque < 5
ORDER BY estoque ASC;
```

## Etapa 7 — Salve

Salve frequentemente como:

```text
SPRINT4-5.sql
```

---

# 17. Registro das consultas

| Nº | Pergunta | Recursos SQL utilizados | Funcionou? |
|---:|---|---|---|
| 1 | Quais categorias estão cadastradas | SELECT | Sim |
| 2 | Quais produtos custam mais de 15 | WHERE(>) | Sim |
| 3 | Produtos Ordenados por preço | ORDER BY ASC | Sim |
| 4 | Total de Produtos cadastrados | COUNT | Sim |
| 5 | Qual o faturamento total da Loja | SUM | Sim |
| 6 | QUal o Ticket medio das vendas | AVG | Sim |
| 7 | Maior e menor venda registrada | MIN,MAX | Sim |
| 8 | Quantos itens por categoria | GROUP BY, COUNT | Sim |

---

# 18. Consulta mais útil

### Pergunta

> Se for pra escolher uma eu acho que com toda certeza precisa ser do valor total em dinheiro que entrou no caixa.

### SQL

```sql
SELECT SUM(valor_total) AS faturamente_total
FROM Venda;

```

### Por que ela é útil?

> Ela vai garantir que o gerente da nossa loja fique sabendo o valor total arrecadado e essa informação ajuda ele a escolher quais produtos precisam ser continuados a comprar ou não, e ele também iria precisar calcular os lucros todos os dias depois de terminar o experdiente.

---

# 19. Consulta mais complexa

### Pergunta

> Quais Categorias vão possuir uma quantidade especifica de produtos cadastrados.

### SQL

```sql
SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;
```

### Qual foi a dificuldade?

> Com toda e entender as diferenças mininas que existem em cada um desses malditos, preferencialmente o HAVING que é uma bomba pra entender, pq tem vez que o MYSQL ainda dá errro de Sintaxe, então acaba sendo dificil pra carmaba.

---

# 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 21. Uso de LLMs nesta Sprint

Caso utilize uma LLM, informe:

- tema do banco;
- nomes reais das tabelas;
- estrutura das tabelas;
- dados disponíveis;
- pergunta que deseja responder;
- SQL já tentado;
- mensagem de erro do MySQL, quando houver.

Exemplo de solicitação adequada:

```text
Tenho uma tabela produto com os campos id_produto, nome,
preco, estoque e id_categoria.

Quero responder: "Qual é o preço médio dos produtos de cada
categoria?"

Explique como construir essa consulta usando GROUP BY e AVG.
Depois apresente um exemplo compatível com MySQL.
```

Todo código sugerido por LLM deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

---

# 22. O que deve existir ao final da Sprint 4/5

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql

SPRINT4-5.md
SPRINT4-5.sql
```

Não exclua arquivos anteriores.

---

# 23. Checklist da Sprint 4/5

- [x] utilizei o banco das Sprints anteriores;
- [x] confirmei que existem dados suficientes;
- [x] utilizei `SELECT`;
- [x] selecionei colunas específicas;
- [x] utilizei `WHERE`;
- [x] utilizei mais de uma condição;
- [x] utilizei `ORDER BY`;
- [x] utilizei `COUNT`;
- [X] utilizei `SUM`, quando aplicável;
- [X] utilizei `AVG`, quando aplicável;
- [x] utilizei `MIN` ou `MAX`;
- [x] utilizei `GROUP BY`;
- [x] utilizei `HAVING`;
- [x] utilizei aliases com `AS`;
- [X] utilizei expressão SQL quando aplicável;
- [x] minhas consultas respondem perguntas reais;
- [X] testei as consultas no MySQL Workbench;
- [X] salvei o código em `SPRINT4-5.sql`;
- [X] preenchi completamente o `SPRINT4-5.md`;
- [X] revisei os arquivos antes do commit.

---

# 24. Regras de Git/GitHub

A atividade continua **individual**.

Utilize a mesma branch das Sprints anteriores.

Não crie uma nova branch.

## Arquivos obrigatórios no commit desta Sprint

```text
SPRINT4-5.md
SPRINT4-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 4 de 5 - consultas SQL
```

---

# 25. Pull Request

**Ainda não abra o Pull Request final.**

O PR será aberto somente após a Sprint 5/5.

```text
SPRINT1-5.md
      ↓ commit

SPRINT2-5.md + SPRINT2-5.sql
      ↓ commit

SPRINT3-5.md + SPRINT3-5.sql
      ↓ commit

SPRINT4-5.md + SPRINT4-5.sql
      ↓ commit

SPRINT5-5.md + SPRINT5-5.sql
      ↓ commit

PULL REQUEST FINAL
      ↓
main
```

---

# 26. Critério de conclusão da Sprint 4/5

A Sprint será considerada concluída quando o aluno:

1. utilizar os dados criados anteriormente;
2. elaborar consultas coerentes com o domínio;
3. utilizar corretamente `SELECT`;
4. utilizar `WHERE`;
5. utilizar `ORDER BY`;
6. utilizar funções de agregação;
7. utilizar `GROUP BY`;
8. utilizar `HAVING`;
9. conseguir explicar as perguntas respondidas;
10. executar e validar as consultas no MySQL Workbench;
11. documentar o trabalho no `SPRINT4-5.md`;
12. salvar o código em `SPRINT4-5.sql`;
13. incluir os dois arquivos no commit.

---

# Próxima etapa

Na **Sprint 5/5**, o projeto será revisado, integrado e preparado para a entrega final.

A Sprint final envolverá:

- revisão da estrutura;
- revisão das restrições;
- revisão dos dados;
- revisão das consultas;
- execução completa;
- correção de erros;
- organização dos arquivos;
- preparação do `SPRINT5-5.sql`;
- abertura do Pull Request final.

> **Não abra o Pull Request antes de concluir a Sprint 5/5.**
