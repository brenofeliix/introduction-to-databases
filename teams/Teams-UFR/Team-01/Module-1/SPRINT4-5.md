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

1. Quais clientes estão cadastrados? 
2. Quais produtos tem maior lucro?
3. Quais agendamentos diários?
4. Quais produtos mais está sendo vendidos?
5. Quantos clientes ativos tem registrados?

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

> Quantos clientes registrados.

### SQL

```sql
SELECT *
FROM CLIENTES;

```

### Explique o resultado

> MOSTROU QUE ATUALMENTE POSSUEM 5 CLIENTES REGISTRADOS

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

> QUAL PRODUTO TEM MAIOR LUCRO.

### SQL

```sql
-- Cole aqui.
SELECT *, (PRECO_VENDA - PRECO_COMPRA) AS LUCRO
FROM PRODUTOS
WHERE (PRECO_VENDA - PRECO_COMPRA) > 0
ORDER BY LUCRO DESC;
```

### Explique o filtro

> Em vez de filtrar apenas por preco, fiz a subtração (PRECO_VENDA - PRECO_COMPRA) para filtrar diretamente pelo valor do lucro!.

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

> Qual produto está sendo mais vendido.

### SQL

```sql
-- SELECT 
    NOME_PRODUTO, 
    PRECO_VENDA, 
    DATA_VENDA
FROM PRODUTOS
ORDER BY DATA_VENDA DESC;

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
-- SELECT 
    COUNT(*) AS TOTAL_CLIENTES_REGISTRADOS
FROM CLIENTES;
```

**Pergunta respondida:**

> Quantos clientes ativos tem registrados?

## SUM

```sql
-- SELECT 
    SUM(PRECO_VENDA - PRECO_COMPRA) AS LUCRO_TOTAL 
FROM PRODUTOS;    
```

**Pergunta respondida:**

> Qual é o valor total de lucro estimado obtido com a venda de todos os produtos cadastrados? 

Caso não seja aplicável ao domínio, justifique.

## AVG

```sql
-- SELECT 
    AVG(PRECO_SERVICOS) AS MEDIA_PRECO_SERVICOS
FROM SERVICOS;

```

**Pergunta respondida:**

> Qual é o preço médio dos serviços oferecidos pelo salão de beleza?

Caso não seja aplicável ao domínio, justifique.

## MIN ou MAX

```sql
-- SELECT 
    MIN(PRECO_SERVICOS) AS SERVICO_MAIS_BARATO,
    MAX(PRECO_SERVICOS) AS SERVICO_MAIS_CARO
FROM SERVICOS;

```

**Pergunta respondida:**

> Quais são os valores do serviço mais barato e do serviço mais caro oferecidos pelo salão?

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

> Quantos agendamentos foram realizados para cada tipo de serviço no salão?

### SQL

```sql
-- SELECT 
    NOME_SERVICO, 
    COUNT(*) AS TOTAL_AGENDAMENTOS
FROM AGENDAMENTO
GROUP BY NOME_SERVICO;

```

### Explique o agrupamento

> O comando GROUP BY NOME_SERVICO agrupa as linhas da tabela AGENDAMENTO que possuem o mesmo serviço. A função COUNT(*) depois conta quantos agendamentos existem dentro de cada grupo criado.

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

>  Quais serviços possuem mais de 1 agendamento realizado? 

### SQL

```sql
-- SELECT 
    NOME_SERVICO, 
    COUNT(*) AS TOTAL_AGENDAMENTOS
FROM AGENDAMENTO
GROUP BY NOME_SERVICO
HAVING COUNT(*) > 0;

```

### Por que HAVING foi necessário?

>  O HAVING foi necessário porque o filtro é aplicado sobre o resultado de uma função de agregação. O comando WHERE não pode filtrar dados já agrupados/agregados, sendo obrigatório o uso do HAVING logo após o GROUP BY para filtrar apenas os grupos que atendem ao critério de ter mais de 1 agendamento.

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
--SELECT 
    NOME_PRODUTO,
    PRECO_COMPRA,
    PRECO_VENDA,
    (PRECO_VENDA - PRECO_COMPRA) AS LUCRO_UNITARIO
FROM PRODUTOS;

```

### Explique o cálculo

> Explique o cálculo
A expressão (PRECO_VENDA - PRECO_COMPRA) realiza uma operação matemática de subtração entre o valor de venda do produto e o seu preço de compra. O resultado dessa expressão é exibido sob a coluna calculada LUCRO_UNITARIO, permitindo identificar a margem de lucro de cada item.
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
USE nome_do_banco;

-- SELECT básico
SELECT *
FROM tabela_a;

-- Colunas específicas
SELECT campo_a1, campo_a2
FROM tabela_a;

-- WHERE
SELECT *
FROM tabela_a
WHERE campo_numerico > 10;

-- Duas condições
SELECT *
FROM tabela_a
WHERE campo_numerico > 10
  AND campo_status = 'ATIVO';

-- ORDER BY
SELECT *
FROM tabela_a
ORDER BY campo_a1 ASC;

-- COUNT
SELECT COUNT(*) AS total_registros
FROM tabela_a;

-- SUM
SELECT SUM(campo_numerico) AS total
FROM tabela_a;

-- AVG
SELECT AVG(campo_numerico) AS media
FROM tabela_a;

-- MIN / MAX
SELECT MIN(campo_numerico) AS menor_valor,
       MAX(campo_numerico) AS maior_valor
FROM tabela_a;

-- GROUP BY
SELECT campo_categoria,
       COUNT(*) AS quantidade
FROM tabela_a
GROUP BY campo_categoria;

-- HAVING
SELECT campo_categoria,
       COUNT(*) AS quantidade
FROM tabela_a
GROUP BY campo_categoria
HAVING COUNT(*) > 1;

-- Expressão
SELECT campo_a1,
       campo_numerico,
       campo_numerico * 1.10 AS valor_calculado
FROM tabela_a;
```

> Substitua `nome_do_banco`, `tabela_a`, `campo_a1`, `campo_numerico`, `campo_categoria` e demais nomes genéricos pelos nomes reais do seu projeto.

---

# 15. Estrutura recomendada do SPRINT4-5.sql

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno:
-- Banco:

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE nome_do_banco;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================


-- ============================================================
-- 2. WHERE
-- ============================================================


-- ============================================================
-- 3. ORDER BY
-- ============================================================


-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================


-- ============================================================
-- 5. GROUP BY
-- ============================================================


-- ============================================================
-- 6. HAVING
-- ============================================================


-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================


-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

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
| 1 | Quais clientes estão cadastrados|FROM CLIENTES;|SIM
| 2 |Quais produtos tem maior lucro?|FROM - WHERE|SIM|
| 3 |Quais agendamentos diários?|COUNT|SIM|
| 4 |Quais produtos mais está sendo vendidos| ORDER BY| SIM  |
| 5 |Quantos clientes ativos tem registrados?|COUNT - FROM|SIM  |
| 6 |  |  |  |
| 7 |  |  |  |
| 8 |  |  |  |

---

# 18. Consulta mais útil

### Pergunta

> Qual é a margem de lucro individual de cada produto cadastrado no salão?

### SQL

```sql
-- SELECT 
    NOME_PRODUTO,
    PRECO_COMPRA,
    PRECO_VENDA,
    (PRECO_VENDA - PRECO_COMPRA) AS LUCRO_UNITARIO
FROM PRODUTOS
ORDER BY LUCRO_UNITARIO DESC;

```

### Por que ela é útil?

> Esta consulta é extremamente útil para a gestão do negócio, pois permite ao gestor visualizar diretamente a rentabilidade real de cada item comercializado

---

# 19. Consulta mais complexa

### Pergunta

> Quais serviços do salão possuem mais de um agendamento registrado?

### SQL

```sql
-- SELECT 
    NOME_SERVICO, 
    COUNT(*) AS TOTAL_AGENDAMENTOS
FROM AGENDAMENTO
GROUP BY NOME_SERVICO
HAVING COUNT(*) > 1;

```

### Qual foi a dificuldade?

> A principal dificuldade residia na necessidade de combinar o agrupamento de dados (GROUP BY) com a filtragem do resultado agregado (HAVING). Como o comando WHERE não pode ser aplicado sobre funções de agregação como COUNT(*), foi necessário compreender a diferença conceitual e sintática para utilizar corretamente o HAVING após o agrupamento das linhas.

---

# # 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Erro de Sintaxe (1064) | Palavras reservadas do SQL grudadas no comando (`LUCRO_TOTALFROM`) | Adicionados os espaços corretos entre os identificadores e a cláusula `FROM` |
| Erro ao filtrar agregação | Uso indevido da cláusula `WHERE` para filtrar resultados do `COUNT(*)` | Substituição do `WHERE` por `HAVING` logo após o agrupamento com `GROUP BY` |
| Erro de Chave Duplicada (1062) | Re-execução do script de inserção sem resetar a base de dados | Inclusão de `DROP TABLE IF EXISTS` no início do script principal de reset |
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

- [X] utilizei o banco das Sprints anteriores;
- [X] confirmei que existem dados suficientes;
- [X] utilizei `SELECT`;
- [X] selecionei colunas específicas;
- [X] utilizei `WHERE`;
- [X] utilizei mais de uma condição;
- [X] utilizei `ORDER BY`;
- [X] utilizei `COUNT`;
- [X] utilizei `SUM`, quando aplicável;
- [X] utilizei `AVG`, quando aplicável;
- [X] utilizei `MIN` ou `MAX`;
- [X] utilizei `GROUP BY`;
- [X] utilizei `HAVING`;
- [X] utilizei aliases com `AS`;
- [X] utilizei expressão SQL quando aplicável;
- [X] minhas consultas respondem perguntas reais;
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
