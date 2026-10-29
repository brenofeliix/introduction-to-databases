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

1. Um paciente não pode possuir dois cadastros com o mesmo CPF.
2. Um agendamento deve estar associado a um paciente existente.
3. Um exame não pode possuir preço negativo.
4. Um resultado deve estar vinculado a um exame realizado.
5. Um resultado deve estar vinculado a um exame realizado.

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

> Escreva aqui.
Listar todos os pacientes cadastrados.
### SQL

```sql
-- Cole aqui.
SELECT *
FROM paciente;

```

### Explique o resultado

> Escreva aqui.
Essa consulta retorna todos os registros da tabela paciente, exibindo todas as colunas disponíveis.
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

> Escreva aqui.
Quais exames possuem preço negativo?
### SQL

```sql
-- Cole aqui.
SELECT *
FROM exame
WHERE preco < 0;

```

### Explique o filtro

> Escreva aqui.
Aqui usamos WHERE preco < 0 para filtrar apenas os exames cujo preço foi cadastrado incorretamente (valores negativos). Isso ajuda a validar a regra de integridade.
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

> Escreva aqui.
Quais exames cadastrados, ordenados pelo preço do menor para o maior?
### SQL

```sql
-- Cole aqui.
SELECT *
FROM exame
ORDER BY preco ASC;

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
-- Cole aqui.
SELECT COUNT(*) AS total_pacientes
FROM paciente;

```

**Pergunta respondida:**

> Escreva aqui.
Quantos pacientes estão cadastrados no sistema?
## SUM

```sql
-- Cole aqui.
SELECT SUM(preco) AS valor_total_exames
FROM exame;

```

**Pergunta respondida:**

> Escreva aqui.
Qual é o valor total de todos os exames cadastrados?
Caso não seja aplicável ao domínio, justifique.
Aqui somamos todos os preços dos exames cadastrados. Isso pode ser útil para ter uma visão geral do faturamento potencial.
## AVG

```sql
-- Cole aqui.
SELECT AVG(preco) AS preco_medio
FROM exame;

```

**Pergunta respondida:**

> Escreva aqui.
Qual é o preço médio dos exames?
Caso não seja aplicável ao domínio, justifique.
Essa consulta calcula a média dos preços dos exames, ajudando a entender o valor médio praticado.
## MIN ou MAX

```sql
-- Cole aqui.
SELECT MIN(preco) AS menor_preco,
       MAX(preco) AS maior_preco
FROM exame;

```

**Pergunta respondida:**

> Escreva aqui.
Qual é o menor e o maior preço de exame?
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

> Escreva aqui.
Quantos agendamentos existem por paciente?
### SQL

```sql
-- Cole aqui.
SELECT id_paciente,
       COUNT(*) AS total_agendamentos
FROM agendamento
GROUP BY id_paciente;

```

### Explique o agrupamento

> Escreva aqui.
Aqui agrupamos os registros da tabela agendamento pelo campo id_paciente. Para cada paciente, a consulta retorna quantos agendamentos estão vinculados a ele. Isso ajuda a verificar a frequência de consultas de cada paciente.
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

> Escreva aqui.
Quais pacientes possuem mais de 3 agendamentos?
### SQL

```sql
-- Cole aqui.
SELECT id_paciente,
       COUNT(*) AS total_agendamentos
FROM agendamento
GROUP BY id_paciente
HAVING COUNT(*) > 3;

```

### Por que HAVING foi necessário?

> Escreva aqui.
O HAVING é usado porque o filtro ocorre após o agrupamento. Primeiro agrupamos os agendamentos por paciente, depois filtramos apenas os grupos (pacientes) que têm mais de 3 registros. Se usássemos WHERE, não funcionaria, pois WHERE atua antes do GROUP BY.
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
-- Cole aqui.
SELECT id_exame,
       preco,
       quantidade,
       preco * quantidade AS valor_total
FROM exame_realizado;

```

### Explique o cálculo

> Escreva aqui.
A expressão preco * quantidade calcula o valor total de cada exame realizado, considerando o preço unitário e a quantidade. Isso é útil para relatórios financeiros e controle de faturamento.

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
| 1 |Listar todos os pacientes cadastrados|SELECT básico|Sim|
| 2 |Mostrar nome e CPF dos pacientes|SELECT colunas específicas|Sim|
| 3 |Quais exames possuem preço negativo?|WHERE|Sim|
| 4 |Quais exames custam mais de 100 e estão ativos?|WHERE com duas condições|Sim|
| 5 |Quais exames estão ordenados do mais barato para o mais caro?|ORDER BY|Sim|
| 6 |Quantos pacientes estão cadastrados?|COUNT|Sim|
| 7 |Qual é o preço médio dos exames?|AVG|Sim|
| 8 |Quais pacientes possuem mais de 3 agendamentos?|GROUP BY + HAVING|Sim|

---

# 18. Consulta mais útil

### Pergunta

> Escreva aqui.
Quais pacientes possuem mais de 3 agendamentos?
### SQL

```sql
-- Cole aqui.
SELECT id_paciente,
       COUNT(*) AS total_agendamentos
FROM agendamento
GROUP BY id_paciente
HAVING COUNT(*) > 3;

```

### Por que ela é útil?

> Escreva aqui.
Essa consulta ajuda a identificar pacientes que demandam maior atenção da clínica, permitindo priorizar recursos e organizar melhor a agenda médica.
---

# 19. Consulta mais complexa

### Pergunta

> Escreva aqui.
Detectar CPFs duplicados entre pacientes.
### SQL

```sql
-- Cole aqui.
SELECT cpf,
       COUNT(*) AS qtd
FROM paciente
GROUP BY cpf
HAVING COUNT(*) > 1;

```

### Qual foi a dificuldade?

> Escreva aqui.
A dificuldade foi entender que WHERE não funciona nesse caso, pois o filtro precisa ser aplicado após o agrupamento. Por isso foi necessário usar HAVING.
---

# 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
|Consulta sem significado (exemplo: WHERE id > 0)|Pergunta não estava clara|Reformulei as perguntas para necessidades reais do sistema|
|Dúvida entre usar WHERE ou HAVING|Confusão sobre ordem de execução|Usei HAVING para filtrar grupos após o GROUP BY|
|Campos genéricos no modelo inicial|Modelo não adaptado ao banco real|Substituí por nomes reais: paciente, exame, agendamento|

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

- [V] utilizei o banco das Sprints anteriores;
- [V] confirmei que existem dados suficientes;
- [V] utilizei `SELECT`;
- [V] selecionei colunas específicas;
- [V] utilizei `WHERE`;
- [V] utilizei mais de uma condição;
- [V] utilizei `ORDER BY`;
- [V] utilizei `COUNT`;
- [V] utilizei `SUM`, quando aplicável;
- [V] utilizei `AVG`, quando aplicável;
- [V] utilizei `MIN` ou `MAX`;
- [V] utilizei `GROUP BY`;
- [V] utilizei `HAVING`;
- [V] utilizei aliases com `AS`;
- [V] utilizei expressão SQL quando aplicável;
- [V] minhas consultas respondem perguntas reais;
- [V] testei as consultas no MySQL Workbench;
- [V] salvei o código em `SPRINT4-5.sql`;
- [V] preenchi completamente o `SPRINT4-5.md`;
- [V] revisei os arquivos antes do commit.

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
