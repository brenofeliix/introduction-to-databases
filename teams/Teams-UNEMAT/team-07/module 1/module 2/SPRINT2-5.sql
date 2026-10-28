-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluna: Talita de Oliveira Leite Sete
-- Banco: secretaria_saude

USE secretaria_saude;

-- ============================================================
-- SUBQUERY COM COMPARAÇÃO
-- Quais itens estão com estoque abaixo da média geral?
-- ============================================================
SELECT e.nome AS item, e.quantidade
FROM estoque_item AS e
WHERE e.quantidade < (SELECT AVG(quantidade) FROM estoque_item)
ORDER BY e.quantidade;

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

-- ============================================================
-- NOT EXISTS
-- Quais unidades não possuem nenhum atendimento registrado?
-- ============================================================
SELECT u.id_unidade, u.nome, u.tipo
FROM unidade_saude AS u
WHERE NOT EXISTS (
    SELECT 1 FROM atendimento AS a WHERE a.id_unidade = u.id_unidade
);

-- ============================================================
-- MAX / MIN
-- Qual item tem a validade mais próxima e em qual unidade está?
-- ============================================================
SELECT u.nome AS unidade, e.nome AS item, e.validade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.validade = (SELECT MIN(validade) FROM estoque_item);

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

-- ============================================================
-- PROBLEMA 1 - JOIN
-- Quais profissionais nunca participaram de um atendimento?
-- ============================================================
SELECT pf.id_profissional, pf.nome, pf.cargo
FROM profissional AS pf
LEFT JOIN atendimento AS a ON a.id_profissional = pf.id_profissional
WHERE a.id_atendimento IS NULL;

-- PROBLEMA 1 - SUBQUERY
SELECT pf.id_profissional, pf.nome, pf.cargo
FROM profissional AS pf
WHERE pf.id_profissional NOT IN (SELECT a.id_profissional FROM atendimento AS a);

-- ============================================================
-- PROBLEMA 2 - JOIN
-- Quais unidades possuem vacina em estoque?
-- ============================================================
SELECT DISTINCT u.id_unidade, u.nome
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade
WHERE e.tipo = 'VACINA';

-- PROBLEMA 2 - SUBQUERY
SELECT u.id_unidade, u.nome
FROM unidade_saude AS u
WHERE u.id_unidade IN (SELECT e.id_unidade FROM estoque_item AS e WHERE e.tipo = 'VACINA');