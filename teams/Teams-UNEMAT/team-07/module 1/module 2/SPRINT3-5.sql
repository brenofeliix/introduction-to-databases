-- Aluna: Talita de Oliveira Leite Sete
-- Banco: secretaria_saude

USE secretaria_saude;

-- ============================================================
-- VIEW 1 — relacionamento entre tabelas
-- Atendimentos com nome do paciente, profissional e unidade
-- ============================================================
DROP VIEW IF EXISTS vw_atendimentos_detalhados;
CREATE VIEW vw_atendimentos_detalhados AS
SELECT a.id_atendimento, p.nome AS paciente, pf.nome AS profissional, pf.setor,
       u.nome AS unidade, a.data_hora, a.tipo_atendimento, a.status
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade;

-- ============================================================
-- VIEW 2 — agregação / resumo
-- Resumo do estoque por unidade
-- ============================================================
DROP VIEW IF EXISTS vw_resumo_estoque_unidade;
CREATE VIEW vw_resumo_estoque_unidade AS
SELECT u.id_unidade, u.nome AS unidade,
       COUNT(*)          AS itens_cadastrados,
       SUM(e.quantidade) AS total_unidades_em_estoque,
       MIN(e.validade)   AS validade_mais_proxima
FROM unidade_saude AS u
INNER JOIN estoque_item AS e ON e.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome;

-- ============================================================
-- VIEW 3 — consulta operacional
-- Agenda de atendimentos agendados (consultas futuras)
-- ============================================================
DROP VIEW IF EXISTS vw_agenda_agendada;
CREATE VIEW vw_agenda_agendada AS
SELECT a.id_atendimento, a.data_hora, p.nome AS paciente, p.telefone,
       pf.nome AS profissional, u.nome AS unidade, a.tipo_atendimento
FROM atendimento AS a
INNER JOIN paciente      AS p  ON p.id_paciente      = a.id_paciente
INNER JOIN profissional  AS pf ON pf.id_profissional = a.id_profissional
INNER JOIN unidade_saude AS u  ON u.id_unidade       = a.id_unidade
WHERE a.status = 'AGENDADO';

-- ============================================================
-- VIEW 4 — estoque baixo (usada no CREATE OR REPLACE)
-- ============================================================
DROP VIEW IF EXISTS vw_estoque_baixo;
CREATE VIEW vw_estoque_baixo AS
SELECT u.nome AS unidade, e.nome AS item, e.quantidade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.quantidade < 50;

-- ============================================================
-- CONSULTAS SOBRE AS VIEWS
-- ============================================================
SELECT * FROM vw_atendimentos_detalhados;

SELECT * FROM vw_atendimentos_detalhados
WHERE status = 'REALIZADO' AND unidade = 'UBS Vila Nova'
ORDER BY data_hora;

SELECT * FROM vw_resumo_estoque_unidade;

SELECT * FROM vw_agenda_agendada ORDER BY data_hora;

SELECT * FROM vw_agenda_agendada
WHERE data_hora < '2026-11-01'
ORDER BY data_hora;

SELECT * FROM vw_estoque_baixo;

-- ============================================================
-- CREATE OR REPLACE VIEW
-- Nova versão da vw_estoque_baixo: tipo, validade e quanto falta para o mínimo
-- ============================================================
CREATE OR REPLACE VIEW vw_estoque_baixo AS
SELECT u.nome AS unidade, e.nome AS item, e.tipo, e.quantidade,
       (50 - e.quantidade) AS faltam_para_minimo, e.validade
FROM estoque_item AS e
INNER JOIN unidade_saude AS u ON u.id_unidade = e.id_unidade
WHERE e.quantidade < 50;

SELECT * FROM vw_estoque_baixo ORDER BY faltam_para_minimo DESC;

-- ============================================================
-- VIEW TEMPORÁRIA + DROP VIEW
-- ============================================================
DROP VIEW IF EXISTS vw_teste;
CREATE VIEW vw_teste AS
SELECT id_paciente, nome FROM paciente;

SELECT COUNT(*) AS linhas_vw_teste FROM vw_teste;

DROP VIEW vw_teste;

-- ============================================================
-- VALIDAÇÃO
-- ============================================================
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- ============================================================
-- TESTE: alteração na tabela base reflete na VIEW
-- (o último UPDATE desfaz o teste, para não alterar o estoque do projeto)
-- ============================================================
SELECT * FROM vw_resumo_estoque_unidade WHERE id_unidade = 1;
UPDATE estoque_item SET quantidade = quantidade + 100 WHERE id_item = 1;
SELECT * FROM vw_resumo_estoque_unidade WHERE id_unidade = 1;
UPDATE estoque_item SET quantidade = quantidade - 100 WHERE id_item = 1;
SELECT * FROM vw_resumo_estoque_unidade WHERE id_unidade = 1;