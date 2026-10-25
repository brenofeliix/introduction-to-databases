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

1. Quais clientes estão cadastrados no sistema?
2. Quais destinos turísticos estão cadastrados e em quais países estão localizados?
3. Quais hospedagens estão disponíveis em cada destino?
4. Quais são os valores das diárias das hospedagens cadastradas?
5. Quais empresas e tipos de transporte estão cadastrados?

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

> Quais destinos turísticos estão cadastrados no sistema?

### SQL

```sql
SELECT *
FROM destino;

```

### Explique o resultado

> Retorna todos os registros e colunas da tabela destino, exibindo o ID, nome, país, estado e descrição de cada localidade cadastrada no sistema.

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

> Quais hospedagens possuem valor de diária superior a R$ 1.000,00?

### SQL

```sql
SELECT *
FROM hospedagem
WHERE valor_diaria > 1000.00;

```

### Explique o filtro

> A condição WHERE valor_diaria > 1000.00 filtra a tabela de hospedagens para retornar somente os estabelecimentos cujo custo por diária seja estritamente maior que mil reais.

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

> Quais são as hospedagens cadastradas ordenadas da diária mais cara para a mais barata?

### SQL

```sql
SELECT *
FROM hospedagem
ORDER BY valor_diaria DESC;

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
SELECT
    COUNT(*) AS total_registros
FROM cliente;

```

**Pergunta respondida:**

> Quantos clientes estão cadastrados no sistema?

## SUM

```sql
SELECT
    SUM(quantidade_pessoas) AS total
FROM reserva_pacote;

```

**Pergunta respondida:**

> Qual é a quantidade total de pessoas contempladas em todas as reservas efetuadas?

Caso não seja aplicável ao domínio, justifique.

## AVG

```sql
SELECT
    AVG(valor_diaria) AS media
FROM hospedagem;

```

**Pergunta respondida:**

> Qual é o valor médio das diárias entre todas as hospedagens cadastradas?

Caso não seja aplicável ao domínio, justifique.

## MIN ou MAX

```sql
SELECT
    MIN(valor_diaria) AS menor_valor,
    MAX(valor_diaria) AS maior_valor
FROM hospedagem;

```

**Pergunta respondida:**

> Qual é a diária mais barata e a diária mais cara entre as hospedagens registradas?

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

> Quantas opções de transporte existem para cada tipo de modal?

### SQL

```sql
SELECT
    tipo,
    COUNT(*) AS quantidade
FROM transporte
GROUP BY tipo;

```

### Explique o agrupamento

> O GROUP BY tipo consolida os dados da tabela transporte de acordo com a sua categoria (Aéreo, Rodoviário, etc.) e aplica a função COUNT(*) para contabilizar quantas opções cadastradas pertencem a cada tipo.

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

> Quais tipos de transporte possuem mais de 2 cadastros no sistema?

### SQL

```sql
SELECT
    tipo,
    COUNT(*) AS quantidade
FROM transporte
GROUP BY tipo
HAVING COUNT(*) > 2;

```

### Por que HAVING foi necessário?

> A cláusula HAVING foi necessária porque o filtro precisa ser aplicado sobre o resultado de uma função agregada (COUNT(*)), o que só é possível de ser realizado após o agrupamento promovido pelo GROUP BY. O WHERE não pode ser utilizado para filtrar agregações.

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
    nome,
    valor_diaria,
    valor_diaria * 1.10 AS valor_calculado
FROM hospedagem;

```

### Explique o cálculo

> A expressão valor_diaria * 1.10 simula a adição de uma taxa de serviço de 10% sobre o valor original da diária de cada hospedagem, exibindo o resultado final na coluna valor_calculado.

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
| 1 | Quais destinos turísticos estão cadastrados no sistema? | SELECT * | Sim |
| 2 | Quais são os nomes, e-mails e telefones de todos os clientes? | SELECT colunas específicas | Sim |
| 3 | Quais hospedagens possuem diária superior a R$ 1.000,00? | WHERE | Sim |
| 4 | Quais transportes aéreos são operados pela LATAM ou Azul? | WHERE, AND, OR | Sim |
| 5 | Quais são as hospedagens ordenadas da diária mais cara para a mais barata? | ORDER BY DESC | Sim |
| 6 | Quantos clientes estão cadastrados no sistema? | COUNT | Sim |
| 7 | Qual é a quantidade total de pessoas contempladas em todas as reservas? | SUM | Sim |
| 8 | Qual é o valor médio das diárias entre todas as hospedagens? | AVG | Sim |

---

# 18. Consulta mais útil

### Pergunta

> Quais são todas as hospedagens cadastradas e seus respectivos valores organizados do mais caro para o mais barato?

### SQL

```sql
SELECT nome, tipo, valor_diaria
FROM hospedagem
ORDER BY valor_diaria DESC;

```

### Por que ela é útil?

> Permite identificar rapidamente a faixa de preços das opções de hospedagem, auxiliando na gestão de catálogo e na recomendação de acomodações aos clientes de acordo com o perfil financeiro.

---

# 19. Consulta mais complexa

### Pergunta

> Quais modalidades de transporte possuem mais de 2 registros após o agrupamento?

### SQL

```sql
SELECT tipo, COUNT(*) AS quantidade
FROM transporte
GROUP BY tipo
HAVING COUNT(*) > 2;

```

### Qual foi a dificuldade?

> Entender a diferença no fluxo de execução do MySQL entre filtrar linhas antes do agrupamento com WHERE e aplicar a condição sobre os resultados agregados usando HAVING.

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
- [x] utilizei `SUM`, quando aplicável;
- [x] utilizei `AVG`, quando aplicável;
- [x] utilizei `MIN` ou `MAX`;
- [x] utilizei `GROUP BY`;
- [x] utilizei `HAVING`;
- [x] utilizei aliases com `AS`;
- [x] utilizei expressão SQL quando aplicável;
- [x] minhas consultas respondem perguntas reais;
- [x] testei as consultas no MySQL Workbench;
- [x] salvei o código em `SPRINT4-5.sql`;
- [x] preenchi completamente o `SPRINT4-5.md`;
- [x] revisei os arquivos antes do commit.

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
