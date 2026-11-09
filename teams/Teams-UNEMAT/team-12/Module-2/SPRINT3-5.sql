-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

-- ============================================================
-- VIEW 1 — relacionamento entre tabelas
-- Pergunta: Quais são todos os agendamentos de visita, com cliente,
-- imóvel, cidade, corretor responsável, data e status?
-- ============================================================

CREATE VIEW vw_agendamentos_detalhados AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    i.titulo AS imovel,
    i.cidade,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;


-- ============================================================
-- VIEW 2 — agregação ou resumo
-- Pergunta: Quantos imóveis cada corretor possui, qual o valor
-- total e qual o valor médio desses imóveis?
-- ============================================================

CREATE VIEW vw_resumo_imoveis_corretor AS
SELECT
    c.id_corretor,
    c.nome AS corretor,
    COUNT(i.id_imovel) AS total_imoveis,
    SUM(i.valor) AS valor_total,
    AVG(i.valor) AS valor_medio
FROM corretor AS c
LEFT JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.id_corretor, c.nome;


-- ============================================================
-- VIEW 3 — consulta operacional do sistema
-- Pergunta: Quais visitas ainda estão pendentes de confirmação?
-- ============================================================

CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    i.titulo AS imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';


-- ============================================================
-- CONSULTAS SOBRE AS VIEWS
-- ============================================================

SELECT * FROM vw_agendamentos_detalhados;

SELECT cliente, imovel, data_visita, status
FROM vw_agendamentos_detalhados
WHERE cidade = 'Rondonópolis';

SELECT * FROM vw_resumo_imoveis_corretor;

SELECT * FROM vw_agendamentos_pendentes;


-- ============================================================
-- CREATE OR REPLACE VIEW
-- Alteração: adicionar e-mail do cliente e valor do imóvel
-- ============================================================

CREATE OR REPLACE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    cl.email AS email_cliente,
    i.titulo AS imovel,
    i.valor AS valor_imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';

SELECT * FROM vw_agendamentos_pendentes;


-- ============================================================
-- VIEW TEMPORÁRIA
-- ============================================================

CREATE VIEW vw_teste AS
SELECT titulo, valor
FROM imovel
WHERE valor < 300000;

SELECT * FROM vw_teste;


-- ============================================================
-- DROP VIEW
-- ============================================================

DROP VIEW vw_teste;


-- ============================================================
-- VALIDAÇÃO
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ============================================================
-- TESTE DE ATUALIZAÇÃO DOS DADOS-BASE
-- ============================================================

SELECT * FROM vw_agendamentos_pendentes;

UPDATE agendamento
SET status = 'Confirmado'
WHERE id_agendamento = 2;

SELECT * FROM vw_agendamentos_pendentes;

-- Reversão, para manter os dados originais do banco
UPDATE agendamento
SET status = 'Pendente'
WHERE id_agendamento = 2;
