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

1. Quais incidentes de segurança estão atualmente abertos? → filtro (WHERE)
2. Quais incidentes possuem severidade alta ou crítica? → filtro com mais de uma condição (WHERE)
3. Quais incidentes estão sob responsabilidade de cada analista? → junção entre tabelas (JOIN) e agregação (COUNT)
4. Quais dispositivos estão relacionados ao maior número de incidentes? → agrupamento e filtro sobre grupos (GROUP BY + HAVING)
5. Quantos incidentes foram registrados por tipo de ameaça? → agrupamento (GROUP BY)

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

> Quais dados existem, de forma geral, na tabela de incidentes?

### SQL

```sql

   SELECT *
   FROM incidentes;

```

### Explique o resultado

> Retorna todas as colunas e todos os registros da tabela incidentes, servindo como uma visão geral inicial dos dados antes de aplicar qualquer filtro.

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

> Quais incidentes de segurança estão atualmente abertos?

### SQL

```sql
-- 
SELECT titulo, severidade, status, data_identificacao
FROM incidentes
WHERE status = 'ABERTO';

```

### Explique o filtro

> O WHERE status = 'ABERTO' faz o MySQL retornar apenas as linhas em que a coluna status está exatamente igual a 'ABERTO', ignorando incidentes com status EM_ANALISE, RESOLVIDO ou ENCERRADO.

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

> Quais foram os incidentes mais recentes?

### SQL

```sql
-- 
SELECT titulo, severidade, data_identificacao
FROM incidentes
ORDER BY data_identificacao DESC;

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

SELECT COUNT(*) AS total_incidentes
FROM incidentes;

```

**Pergunta respondida:**

> Quantos incidentes já foram registrados no total? COUNT(*) conta o número de linhas retornadas pela consulta nesse caso, todas as linhas da tabela incidentes

## SUM

```sql

SELECT a.nome AS analista,
       SUM(CASE WHEN i.severidade IN ('ALTA', 'CRITICA') THEN 1 ELSE 0 END) AS incidentes_criticos
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
GROUP BY a.id_analista, a.nome;

```

**Pergunta respondida:**

> Quantos incidentes de severidade alta ou crítica cada analista está acompanhando?

Justificativa de uso: o domínio do projeto (segurança da informação) não possui um campo numérico "somável" por natureza, como valor monetário ou quantidade de itens. Por isso, o SUM foi aplicado sobre uma expressão CASE WHEN que transforma cada incidente crítico em 1 e os demais em 0 — somando esses valores, o resultado equivale a "quantos incidentes críticos cada analista tem".


## AVG

```sql
SELECT AVG(quantidade) AS media_incidentes_por_analista
FROM (
    SELECT id_analista, COUNT(*) AS quantidade
    FROM incidentes
    WHERE id_analista IS NOT NULL
    GROUP BY id_analista
) AS incidentes_por_analista;

```

**Pergunta respondida:**

> Em média, quantos incidentes cada analista está acompanhando?

Essa consulta usa uma subconsulta: primeiro conta quantos incidentes cada analista tem (GROUP BY id_analista), e depois calcula a média (AVG) sobre esses totais.

## MIN ou MAX

```sql
SELECT MIN(data_identificacao) AS incidente_mais_antigo,
       MAX(data_identificacao) AS incidente_mais_recente
FROM incidentes;

```

**Pergunta respondida:**

> Qual foi o incidente mais antigo e o mais recente registrado no banco? MIN retorna a menor data (mais antiga) e MAX a maior data (mais recente) da coluna data_identificacao.

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

> Quantos incidentes foram registrados por tipo de ameaça?

### SQL

```sql
-- 
SELECT t.nome_ameaca,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM tipos_ameacas t
LEFT JOIN incidentes i ON i.id_ameaca = t.id_ameaca
GROUP BY t.id_ameaca, t.nome_ameaca
ORDER BY quantidade_incidentes DESC;

```

### Explique o agrupamento

> O GROUP BY t.id_ameaca, t.nome_ameaca faz o MySQL juntar todas as linhas que pertencem ao mesmo tipo de ameaça em um único grupo, e o COUNT(i.id_incidente) conta quantos incidentes existem dentro de cada grupo. Foi usado LEFT JOIN (em vez de JOIN comum) para que tipos de ameaça sem nenhum incidente associado também apareçam no resultado, com contagem igual a zero.

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

> Quais dispositivos estão relacionados ao maior número de incidentes?

### SQL

```sql
-- 
SELECT d.nome_dispositivo,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM dispositivos d
JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(i.id_incidente) > 1
ORDER BY quantidade_incidentes DESC;

```

### Por que HAVING foi necessário?

> O WHERE não pode ser usado aqui porque ele filtra linhas antes de serem agrupadas, e a condição que eu preciso ("mais de 1 incidente") só existe depois de contar quantos incidentes cada dispositivo tem. Por isso é obrigatório usar HAVING COUNT(i.id_incidente) > 1, que filtra os grupos já formados pelo GROUP BY, mostrando apenas os dispositivos que aparecem em mais de um incidente.

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
-- 
SELECT titulo,
       data_identificacao,
       data_encerramento,
       TIMESTAMPDIFF(DAY, data_identificacao, data_encerramento) AS dias_para_resolucao
FROM incidentes
WHERE data_encerramento IS NOT NULL;

```

### Explique o cálculo

> TIMESTAMPDIFF(DAY, data_identificacao, data_encerramento) calcula a diferença, em dias, entre a data em que o incidente foi identificado e a data em que foi encerrado. O WHERE data_encerramento IS NOT NULL garante que a consulta considere apenas incidentes que já foram encerrados (os que ainda estão abertos têm data_encerramento vazia, e o cálculo não faria sentido para eles).

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
| 1 | Visão geral dos incidentes | SELECT * | Sim |
| 2 | Título, severidade e status de cada incidente | SELECT com colunas específicas |Sim  |
| 3 | Incidentes abertos | WHERE |Sim  |
| 4 | Incidentes de severidade alta/crítica ainda não encerrados | WHERE (2 condições), IN, AND | Sim |
| 5 | Incidentes mais recentes | ORDER BY |Sim  |
| 6 | Total de incidentes registrados | ORDER BY |  Sim|
| 7 | Incidentes críticos por analista | SUM (com CASE), JOIN, GROUP BY |Sim  |
| 8 | Média de incidentes por analista | AVG, subconsulta, GROUP BY | Sim |
| 9 | Incidente mais antigo e mais recente| MIN, MAX | Sim |
| 10 | Incidentes por tipo de ameaça | GROUP BY, LEFT JOIN, COUNT | Sim |
| 11 | Dispositivos com mais de 1 incidente | GROUP BY, HAVING, JOIN |Sim  |
| 12 | Dias até a resolução de cada incidente encerrado| Expressão (TIMESTAMPDIFF), WHERE | Sim |
| 13 | Incidentes por analista responsável | JOIN, ORDER BY | Sim |


---

# 18. Consulta mais útil

### Pergunta

> Quais dispositivos estão relacionados ao maior número de incidentes?

### SQL

```sql
--
SELECT d.nome_dispositivo,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM dispositivos d
JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(i.id_incidente) > 1
ORDER BY quantidade_incidentes DESC;

```

### Por que ela é útil?

> Porque ajuda a identificar rapidamente quais equipamentos concentram mais incidentes de segurança, o que pode indicar um dispositivo mal configurado, desatualizado ou mais exposto a ataques.

---

# 19. Consulta mais complexa

### Pergunta

> Em média, quantos incidentes cada analista está acompanhando?

### SQL

```sql
-- 
SELECT AVG(quantidade) AS media_incidentes_por_analista
FROM (
    SELECT id_analista, COUNT(*) AS quantidade
    FROM incidentes
    WHERE id_analista IS NOT NULL
    GROUP BY id_analista
) AS incidentes_por_analista;

```

### Qual foi a dificuldade?

> O banco não tem uma coluna pronta com "quantidade de incidentes por analista" essa informação precisa ser calculada primeiro. A dificuldade foi entender que não dá pra usar AVG(COUNT(*)) diretamente (o MySQL não permite aninhar uma função de agregação dentro da outra na mesma consulta); por isso foi necessário criar uma subconsulta que gera a contagem por analista, e só depois aplicar o AVG sobre esse resultado.

---

# 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Tipos de ameaça sem incidentes não apareciam no relatório de contagem | Uso de JOIN comum, que só traz linhas com correspondência nas duas tabelas | só traz linhas com correspondência nas duas tabelas	Trocado para LEFT JOIN, garantindo que ameaças ainda sem incidentes registrados também apareçam, com contagem zero |
| Erro ao tentar usar AVG(COUNT(*)) diretamente | O MySQL não permite aninhar duas funções de agregação na mesma consulta | Resolvido com uma subconsulta: primeiro agrupa e conta, depois calcula a média sobre o resultad |
| Incidentes sem id_dispositivo (ex.: o de phishing) ficavam de fora da consulta de "dispositivos com mais incidentes" | Uso de JOIN comum, que exclui incidentes com id_dispositivo nulo | Comportamento mantido de propósito nessa consulta específica, pois o objetivo era listar apenas dispositivos com incidentes de fato associados |

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

- [ ] utilizei o banco das Sprints anteriores;
- [ ] confirmei que existem dados suficientes;
- [ ] utilizei `SELECT`;
- [ ] selecionei colunas específicas;
- [ ] utilizei `WHERE`;
- [ ] utilizei mais de uma condição;
- [ ] utilizei `ORDER BY`;
- [ ] utilizei `COUNT`;
- [ ] utilizei `SUM`, quando aplicável;
- [ ] utilizei `AVG`, quando aplicável;
- [ ] utilizei `MIN` ou `MAX`;
- [ ] utilizei `GROUP BY`;
- [ ] utilizei `HAVING`;
- [ ] utilizei aliases com `AS`;
- [ ] utilizei expressão SQL quando aplicável;
- [ ] minhas consultas respondem perguntas reais;
- [ ] testei as consultas no MySQL Workbench;
- [ ] salvei o código em `SPRINT4-5.sql`;
- [ ] preenchi completamente o `SPRINT4-5.md`;
- [ ] revisei os arquivos antes do commit.

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
