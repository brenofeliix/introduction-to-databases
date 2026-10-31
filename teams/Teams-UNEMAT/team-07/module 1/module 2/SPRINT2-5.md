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

> Talita de Oliveira Leite Sete 

**Banco utilizado:**

```text
secretaria_saude
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

Defina pelo menos cinco perguntas do seu domínio que possam ser resolvidas com subconsultas.

1. Quais itens do estoque estão abaixo da média geral?
2. Quais pacientes foram atendidos em unidades do tipo UBS?
3. Quais profissionais nunca participaram de um atendimento?
4. Quais unidades possuem vacina em estoque, e quais não têm nenhum atendimento?
5. Qual item vence primeiro, e quais itens estão acima da média da própria unidade?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais itens estão com estoque abaixo da média geral?

```sql
-- ============================================================
-- SUBQUERY COM COMPARAÇÃO
-- Quais itens estão com estoque abaixo da média geral?
-- ============================================================
SELECT e.nome AS item, e.quantidade
FROM estoque_item AS e
WHERE e.quantidade < (SELECT AVG(quantidade) FROM estoque_item)
ORDER BY e.quantidade;
```

**Explique primeiro a consulta interna:**

> SELECT AVG(quantidade) FROM estoque_item roda sozinha e devolve um único valor: 222,1.

**Depois explique a consulta externa:**

> Percorre estoque_item e mantém só as linhas com quantidade < 222,1. Retorna 7 itens, de Influenza do Posto Rural (8) até Fluoxetina (200).

---

# 5. Subconsulta com IN

Exemplo:

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedido
);
```

## Consulta obrigatória

**Pergunta:**

> Quais pacientes foram atendidos em unidades do tipo UBS?

```sql
-- ============================================================
-- IN
-- Quais pacientes foram atendidos em unidades do tipo UBS?
-- ============================================================
SELECT p.id_paciente, p.nome
FROM paciente AS p
WHERE p.id_paciente IN (
    SELECT a.id_paciente
    FROM atendimento AS a
    WHERE a.id_unidade IN (
        SELECT u.id_unidade FROM unidade_saude AS u WHERE u.tipo = 'UBS'
    )
)
ORDER BY p.nome;
```

**Explique:**

> A subconsulta mais interna pega os ids das unidades do tipo UBS (1 e 2). A do meio pega os pacientes atendidos nessas unidades. A externa mostra o nome desses pacientes.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais profissionais nunca participaram de um atendimento?

```sql
-- ============================================================
-- NOT IN
-- Quais profissionais nunca participaram de um atendimento?
-- (atendimento.id_profissional é NOT NULL, então o NOT IN é seguro)
-- ============================================================
SELECT pf.id_profissional, pf.nome, pf.cargo
FROM profissional AS pf
WHERE pf.id_profissional NOT IN (
    SELECT a.id_profissional FROM atendimento AS a
);
```

**Que registros você está procurando?**

> Profissionais cujo id não aparece em atendimento.id_profissional. Retorna Marcos Vinícius (assistente administrativo) e Sandra Regina (coordenadora), o que faz sentido porque são cargos administrativos. O NOT IN só é seguro aqui porque id_profissional é NOT NULL em atendimento: se a subconsulta devolvesse um NULL, o NOT IN não retornaria nenhuma linha.
---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais unidades possuem pelo menos uma vacina em estoque?

```sql
-- ============================================================
-- EXISTS
-- Quais unidades possuem pelo menos uma vacina em estoque?
-- ============================================================
SELECT u.id_unidade, u.nome, u.tipo
FROM unidade_saude AS u
WHERE EXISTS (
    SELECT 1
    FROM estoque_item AS e
    WHERE e.id_unidade = u.id_unidade AND e.tipo = 'VACINA'
);

```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais unidades não possuem nenhum atendimento registrado?

```sql
-- ============================================================
-- NOT EXISTS
-- Quais unidades não possuem nenhum atendimento registrado?
-- ============================================================
SELECT u.id_unidade, u.nome, u.tipo
FROM unidade_saude AS u
WHERE NOT EXISTS (
    SELECT 1 FROM atendimento AS a WHERE a.id_unidade = u.id_unidade
);
```

**Explique a diferença em relação a `EXISTS`:**

> O EXISTS mantém a unidade quando a subconsulta encontra ao menos uma linha. O NOT EXISTS faz o contrário: mantém quando não encontra nenhuma. Aqui retorna só o Posto de Saúde Rural Boa Vista.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Qual item tem a validade mais próxima e em qual unidade está?

```sql
-- ============================================================
-- MAX / MIN
-- Qual item tem a validade mais próxima e em qual unidade está?
-- ============================================================
SELECT u.nome AS unidade, e.nome AS item, e.validade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.validade = (SELECT MIN(validade) FROM estoque_item);
```

**Explique:**

> A subconsulta MIN(validade) devolve 2027-01-20. A externa busca o item com essa validade e junta com unidade_saude para mostrar o nome. Resultado: Vacina Tríplice Viral, na UBS Vila Nova.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quais itens têm quantidade acima da média da própria unidade?

```sql
-- ============================================================
-- SUBQUERY CORRELACIONADA
-- Quais itens têm quantidade acima da média da própria unidade?
-- ============================================================
SELECT u.nome AS unidade, e1.nome AS item, e1.quantidade
FROM estoque_item AS e1
INNER JOIN unidade_saude AS u ON u.id_unidade = e1.id_unidade
WHERE e1.quantidade > (
    SELECT AVG(e2.quantidade)
    FROM estoque_item AS e2
    WHERE e2.id_unidade = e1.id_unidade
)
ORDER BY u.nome;
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> e1.id_unidade. A subconsulta calcula a média dos itens (e2) da mesma unidade da linha externa, então roda uma vez para cada linha. Retorna Dipirona (UBS Centro), Amoxicilina (UBS Vila Nova) e Paracetamol (UPA). Unidades com um único item não aparecem, porque o item é igual à própria média.
---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais profissionais nunca participaram de um atendimento?

### JOIN

```sql
-- ============================================================
-- PROBLEMA 1 - JOIN
-- Quais profissionais nunca participaram de um atendimento?
-- ============================================================
SELECT pf.id_profissional, pf.nome, pf.cargo
FROM profissional AS pf
LEFT JOIN atendimento AS a ON a.id_profissional = pf.id_profissional
WHERE a.id_atendimento IS NULL;
```

### SUBQUERY

```sql
-- PROBLEMA 1 - SUBQUERY
SELECT pf.id_profissional, pf.nome, pf.cargo
FROM profissional AS pf
WHERE pf.id_profissional NOT IN (SELECT a.id_profissional FROM atendimento AS a);
```

### Qual abordagem ficou mais compreensível?

> A subconsulta com NOT IN, porque se lê quase como a pergunta (“id que não está nos atendimentos”). O LEFT JOIN ... IS NULL exige entender que o NULL representa a ausência de correspondência.

---

## Pergunta 2

> Quais unidades possuem vacina em estoque?

### JOIN

```sql
-- ============================================================
-- PROBLEMA 2 - JOIN
-- Quais unidades possuem vacina em estoque?
-- ============================================================
SELECT DISTINCT u.id_unidade, u.nome
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade
WHERE e.tipo = 'VACINA';

```

### SUBQUERY

```sql
-- PROBLEMA 2 - SUBQUERY
SELECT u.id_unidade, u.nome
FROM unidade_saude AS u
WHERE u.id_unidade IN (SELECT e.id_unidade FROM estoque_item AS e WHERE e.tipo = 'VACINA');
```

### Comparação

> As duas retornam as mesmas 3 unidades. No JOIN, o DISTINCT é necessário porque a UBS Vila Nova tem 2 vacinas e apareceria duas vezes. Na subconsulta, o IN já trata isso sozinho. O JOIN é preferível quando preciso mostrar colunas das duas tabelas; a subconsulta, quando só quero filtrar.
---

# 12. Quantidade mínima exigida

O `SPRINT2-5.sql` deverá conter no mínimo:

```text
1 subconsulta com comparação
1 subconsulta com IN
1 subconsulta com NOT IN
1 consulta com EXISTS
1 consulta com NOT EXISTS
1 subconsulta com MAX ou MIN
1 subconsulta correlacionada
2 problemas resolvidos com JOIN e SUBQUERY
```

---

# 13. Validação prática

Escolha uma subconsulta.

```sql
-- ============================================================
-- SUBQUERY CORRELACIONADA
-- Quais itens têm quantidade acima da média da própria unidade?
-- ============================================================
SELECT u.nome AS unidade, e1.nome AS item, e1.quantidade
FROM estoque_item AS e1
INNER JOIN unidade_saude AS u ON u.id_unidade = e1.id_unidade
WHERE e1.quantidade > (
    SELECT AVG(e2.quantidade)
    FROM estoque_item AS e2
    WHERE e2.id_unidade = e1.id_unidade
)
ORDER BY u.nome;
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> 1. A consulta interna, SELECT AVG(quantidade) FROM estoque_item.
> 2.Um único valor: 222,1.
> 3.A consulta externa usa esse valor como limite: o WHERE compara a quantidade de cada item com 222,1 e mantém só os menores.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```sql
-- ============================================================
-- SUBQUERY CORRELACIONADA
-- Quais itens têm quantidade acima da média da própria unidade?
-- ============================================================
SELECT u.nome AS unidade, e1.nome AS item, e1.quantidade
FROM estoque_item AS e1
INNER JOIN unidade_saude AS u ON u.id_unidade = e1.id_unidade
WHERE e1.quantidade > (
    SELECT AVG(e2.quantidade)
    FROM estoque_item AS e2
    WHERE e2.id_unidade = e1.id_unidade
```

**Alteração realizada:**

> Troquei < por > no WHERE.

**Mudança observada:**

> Antes retornava 7 itens (abaixo da média); depois, 3 itens (Dipirona 800, Paracetamol 500, Amoxicilina 300). Os dois conjuntos somam os 10 itens, e nenhum item vale exatamente a média.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 16. Estrutura recomendada do SPRINT2-5.sql

```sql
-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- SUBQUERY COM COMPARAÇÃO

-- IN

-- NOT IN

-- EXISTS

-- NOT EXISTS

-- MAX / MIN

-- SUBQUERY CORRELACIONADA

-- PROBLEMA 1 - JOIN

-- PROBLEMA 1 - SUBQUERY

-- PROBLEMA 2 - JOIN

-- PROBLEMA 2 - SUBQUERY
```

---

# 17. Checklist

- [ ] utilizei o banco do projeto;
- [ ] criei subconsulta com comparação;
- [ ] utilizei `IN`;
- [ ] utilizei `NOT IN`;
- [ ] utilizei `EXISTS`;
- [ ] utilizei `NOT EXISTS`;
- [ ] utilizei `MAX` ou `MIN`;
- [ ] criei subconsulta correlacionada;
- [ ] resolvi duas perguntas usando JOIN e SUBQUERY;
- [ ] expliquei o raciocínio;
- [ ] testei no MySQL Workbench;
- [ ] consigo explicar as consultas presencialmente;
- [ ] salvei `SPRINT2-5.md`;
- [ ] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Continue na mesma branch:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT2-5.md
Module-2/SPRINT2-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 2 de 5 - subconsultas
```

**Não abra o Pull Request final.**

---

# Próxima etapa

Na Sprint 3/5 serão trabalhadas:

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT em VIEW
DROP VIEW
```
