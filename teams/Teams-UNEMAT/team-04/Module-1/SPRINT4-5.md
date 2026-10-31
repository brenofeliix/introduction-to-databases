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

Na Sprint 1/5, o campo destinado às perguntas ficou sem preenchimento. Para dar continuidade ao projeto, foram definidas nesta Sprint perguntas coerentes com o objetivo original do banco:

1. Quem foi contratado no dia 1 de setembro?
2. Quantos funcionários foram contratados no último mês?
3. Quantas filiais foram abertas nos últimos 4 anos?
4. Quem fez mais de 50 horas extras neste ano?
5. Quais itens estão quase acabando no estoque?

Essas perguntas permitem trabalhar consultas simples, filtros, ordenação, agregações, agrupamentos e filtros sobre grupos.

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

> Quais funcionários estão cadastrados e quais são suas datas de admissão?

### SQL

```sql
SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao
FROM FUNCIONARIO f;
```

### Explique o resultado

> A consulta retorna o nome de cada funcionário e sua respectiva data de admissão. Foram selecionadas apenas as colunas necessárias para facilitar a leitura.

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

> Quais produtos possuem menos de 40 unidades em estoque?

### SQL

```sql
SELECT
    p.nome_produto AS produto,
    e.quantidade AS quantidade_estoque
FROM ESTOQUE e
JOIN PRODUTO p
    ON e.id_produto = p.id_produto
WHERE e.quantidade < 40;
```

### Explique o filtro

> O `WHERE` limita o resultado aos produtos cuja quantidade em estoque seja menor que 40 unidades. O `JOIN` foi utilizado para exibir o nome do produto em vez de apenas seu identificador.

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

> Quais cargos possuem os maiores salários?

### SQL

```sql
SELECT
    c.nome_cargo AS cargo,
    c.salario_base AS salario
FROM CARGO c
ORDER BY c.salario_base DESC;
```

> O resultado é ordenado do maior salário para o menor através de `ORDER BY ... DESC`.

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
SELECT
    COUNT(*) AS quantidade_funcionarios
FROM FUNCIONARIO;
```

**Pergunta respondida:**

> Quantos funcionários estão cadastrados no banco?

## SUM

```sql
SELECT
    SUM(c.salario_base) AS soma_salarios
FROM CARGO c;
```

**Pergunta respondida:**

> Qual é a soma dos salários base cadastrados para os cargos?

## AVG

```sql
SELECT
    AVG(c.salario_base) AS salario_medio
FROM CARGO c;
```

**Pergunta respondida:**

> Qual é o salário base médio dos cargos?

## MIN ou MAX

```sql
SELECT
    MIN(c.salario_base) AS menor_salario,
    MAX(c.salario_base) AS maior_salario
FROM CARGO c;
```

**Pergunta respondida:**

> Qual é o menor e o maior salário base cadastrados?

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

> Quantos funcionários existem em cada cargo?

### SQL

```sql
SELECT
    c.nome_cargo AS cargo,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo
GROUP BY c.id_cargo, c.nome_cargo;
```

### Explique o agrupamento

> Os registros são agrupados por cargo e a função `COUNT` contabiliza quantos funcionários estão associados a cada um. O `LEFT JOIN` mantém também cargos que eventualmente não possuam funcionários.

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

> Quais filiais possuem pelo menos um funcionário cadastrado?

### SQL

```sql
SELECT
    f.id_filial AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FUNCIONARIO f
GROUP BY f.id_filial
HAVING COUNT(f.id_func) >= 1;
```

### Por que HAVING foi necessário?

> O `HAVING` é utilizado porque a condição depende do resultado da função `COUNT`, ou seja, o filtro é aplicado após o agrupamento dos funcionários por filial.

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
SELECT
    c.nome_cargo AS cargo,
    c.salario_base AS salario_atual,
    c.salario_base * 1.10 AS salario_com_reajuste
FROM CARGO c;
```

### Explique o cálculo

> A expressão `salario_base * 1.10` calcula como ficaria o salário de cada cargo após um reajuste de 10%, sem alterar os valores armazenados na tabela.

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
| 1 | Quem foi contratado no dia 1 de setembro? | SELECT, WHERE, DAY, MONTH, ORDER BY | Sim |
| 2 | Quantos funcionários foram contratados no último mês? | COUNT, WHERE, DATE_SUB, CURDATE | Sim |
| 3 | Quantas filiais foram abertas nos últimos 4 anos? | COUNT, WHERE, DATE_SUB | Sim |
| 4 | Quem fez mais de 50 horas extras neste ano? | JOIN, SUM, WHERE, GROUP BY, HAVING, ORDER BY | Sim, porém os dados atuais não possuem funcionário com mais de 50 horas extras |
| 5 | Quais itens estão quase acabando no estoque? | JOIN, WHERE, ORDER BY | Sim |
| 6 | Quantos funcionários existem em cada cargo? | LEFT JOIN, COUNT, GROUP BY | Sim |
| 7 | Qual é o salário médio dos cargos? | AVG | Sim |
| 8 | Qual seria o salário dos cargos com reajuste de 10%? | Expressão aritmética, AS | Sim |

---

# 18. Consulta mais útil

### Pergunta

> Quais são os funcionários cadastrados, seus cargos, setores, filiais e salários?

### SQL

```sql
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    s.nome_setor AS setor,
    fi.Localizacao AS filial,
    c.salario_base AS salario
FROM FUNCIONARIO f
JOIN CARGO c
    ON f.id_cargo = c.id_cargo
JOIN SETOR s
    ON f.id_setor = s.id_setor
JOIN FILIAL fi
    ON f.id_filial = fi.id_filial
ORDER BY fi.Localizacao ASC, f.nome_func ASC;
```

### Por que ela é útil?

> Essa consulta reúne em uma única visualização as principais informações necessárias para RH e administração, permitindo identificar o funcionário, sua função, setor, filial e salário base.

---

# 19. Consulta mais complexa

### Pergunta

> Quantos funcionários existem em cada filial, qual o total de horas extras e qual o salário médio dos funcionários de cada unidade?

### SQL

```sql
SELECT
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(DISTINCT f.id_func) >= 1
ORDER BY total_horas_extras DESC;
```

### Qual foi a dificuldade?

> A consulta exige relacionar quatro tabelas, evitar contagem duplicada de funcionários com `COUNT(DISTINCT ...)`, calcular agregações diferentes e aplicar `HAVING` depois do agrupamento.

---

# 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| A consulta de mais de 50 horas extras pode retornar vazia | Os dados cadastrados possuem somente 0, 1 ou 2 horas extras por registro | A consulta foi mantida porque está correta; foi documentado que os dados atuais não atingem o limite |
| `hora_extra` foi criado como `VARCHAR` na Sprint 2 | Funções como `SUM` trabalham melhor com campos numéricos | Foi utilizado `CAST(... AS DECIMAL(10,2))` nas consultas da Sprint 4 |
| Consultas envolvendo nomes de cargo, setor, filial e produto exigem dados de várias tabelas | O banco é relacional e armazena esses dados separadamente | Foram utilizados `JOIN` e `LEFT JOIN` conforme a necessidade |

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
- [x] utilizei `SUM`, quando aplicável;
- [x] utilizei `AVG`, quando aplicável;
- [x] utilizei `MIN` ou `MAX`;
- [x] utilizei `GROUP BY`;
- [x] utilizei `HAVING`;
- [x] utilizei aliases com `AS`;
- [x] utilizei expressão SQL quando aplicável;
- [x] minhas consultas respondem perguntas reais;
- [X] testei as consultas no MySQL Workbench
- [x] salvei o código em `SPRINT4-5.sql`;
- [x] preenchi completamente o `SPRINT4-5.md`;
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
