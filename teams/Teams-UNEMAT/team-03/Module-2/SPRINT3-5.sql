-- ============================================================
-- MODULE 2 — SPRINT 3/5
-- VIEWS E ABSTRAÇÃO DE CONSULTAS
-- DISCIPLINA: Laboratório de Banco de Dados
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- INSTITUIÇÃO: UNEMAT
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================
-- Pré-requisito: banco do Module-1 + carga complementar da
-- Sprint 1 (Module-2/SPRINT1-5.sql).
-- ============================================================

USE db_salao_beleza;

-- Remove as views caso já existam, para o script poder ser
-- executado mais de uma vez sem erro "already exists".
-- Os dados das tabelas não são afetados.
DROP VIEW IF EXISTS vw_agenda_completa;
DROP VIEW IF EXISTS vw_resumo_profissional;
DROP VIEW IF EXISTS vw_agendamentos_pendentes;


-- ============================================================
-- 1. VIEW 1 — RELACIONAMENTO ENTRE TABELAS
-- Pergunta: Qual é a agenda completa do salão, com nomes de
-- cliente, profissional e serviço?
-- Tabelas: agendamento + cliente + profissional + servico
-- ============================================================
CREATE VIEW vw_agenda_completa AS
SELECT
    a.id_agendamento,
    a.data_hora,
    c.nome          AS cliente,
    p.nome          AS profissional,
    p.especialidade,
    s.nome_servico  AS servico,
    s.preco,
    a.status,
    a.forma_pagamento
FROM agendamento AS a
INNER JOIN cliente      AS c ON a.id_cliente      = c.id_cliente
INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
INNER JOIN servico      AS s ON a.id_servico      = s.id_servico;


-- ============================================================
-- 2. VIEW 2 — AGREGAÇÃO / RESUMO
-- Pergunta: Quantos atendimentos (não cancelados) cada
-- profissional tem, qual o faturamento previsto e o ticket
-- médio — incluindo quem ainda não tem atendimento?
-- LEFT JOIN mantém a profissional sem agendamento (Gabriela).
-- O filtro de cancelado fica no ON (e não no WHERE) para não
-- eliminar quem não tem agendamento.
-- ============================================================
CREATE VIEW vw_resumo_profissional AS
SELECT
    p.id_profissional,
    p.nome                              AS profissional,
    p.especialidade,
    COUNT(a.id_agendamento)             AS total_atendimentos,
    COALESCE(SUM(s.preco), 0)           AS faturamento_previsto,
    COALESCE(ROUND(AVG(s.preco), 2), 0) AS ticket_medio
FROM profissional AS p
LEFT JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional
   AND a.status <> 'Cancelado'
LEFT JOIN servico AS s
    ON a.id_servico = s.id_servico
GROUP BY p.id_profissional, p.nome, p.especialidade;


-- ============================================================
-- 3. VIEW 3 — CONSULTA OPERACIONAL
-- Pergunta: Quais atendimentos ainda estão pendentes
-- (status 'Agendado')? Usada pela recepção no dia a dia.
-- ============================================================
CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    a.data_hora,
    c.nome         AS cliente,
    p.nome         AS profissional,
    s.nome_servico AS servico,
    s.preco
FROM agendamento AS a
INNER JOIN cliente      AS c ON a.id_cliente      = c.id_cliente
INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
INNER JOIN servico      AS s ON a.id_servico      = s.id_servico
WHERE a.status = 'Agendado';


-- ============================================================
-- 4. CONSULTAS SOBRE AS VIEWS
-- ============================================================

-- 4.1 Agenda completa
SELECT * FROM vw_agenda_completa ORDER BY data_hora;

-- 4.2 Filtro na view: agenda da cliente Mariana Souza
SELECT * FROM vw_agenda_completa WHERE cliente = 'Mariana Souza';

-- 4.3 Resumo de todos os profissionais
SELECT * FROM vw_resumo_profissional ORDER BY faturamento_previsto DESC;

-- 4.4 Filtro na view: profissionais com 2 ou mais atendimentos
SELECT profissional, total_atendimentos, faturamento_previsto
FROM vw_resumo_profissional
WHERE total_atendimentos >= 2;

-- 4.5 Pendentes em ordem de data
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;


-- ============================================================
-- 5. CREATE OR REPLACE VIEW
-- Alteração: inclui o telefone da cliente (para a recepção
-- confirmar o horário) e a duração do serviço.
-- ============================================================
CREATE OR REPLACE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    a.data_hora,
    c.nome            AS cliente,
    c.telefone        AS telefone_cliente,
    p.nome            AS profissional,
    s.nome_servico    AS servico,
    s.duracao_minutos,
    s.preco
FROM agendamento AS a
INNER JOIN cliente      AS c ON a.id_cliente      = c.id_cliente
INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
INNER JOIN servico      AS s ON a.id_servico      = s.id_servico
WHERE a.status = 'Agendado';

SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;


-- ============================================================
-- 6. DROP VIEW — EXERCÍCIO CONTROLADO
-- ============================================================
CREATE VIEW vw_teste AS
SELECT nome_servico, preco
FROM servico
WHERE preco < 70.00;

SELECT * FROM vw_teste;

DROP VIEW vw_teste;


-- ============================================================
-- 7. VALIDAÇÃO DAS VIEWS
-- ============================================================
SHOW FULL TABLES WHERE Table_type = 'VIEW';


-- ============================================================
-- 8. TESTE DE ATUALIZAÇÃO DOS DADOS-BASE
-- A view não guarda dados: ao alterar a tabela agendamento,
-- o resultado da view muda automaticamente.
-- ============================================================

-- 8.1 Antes: 5 agendamentos pendentes
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;

-- 8.2 Alteração na tabela base: conclui o agendamento 9
UPDATE agendamento
SET status = 'Concluído',
    forma_pagamento = 'Pix'
WHERE id_agendamento = 9;

-- 8.3 Depois: 4 pendentes (o agendamento 9 saiu da view)
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;

-- 8.4 Desfaz a alteração para manter os dados das próximas Sprints
UPDATE agendamento
SET status = 'Agendado',
    forma_pagamento = NULL
WHERE id_agendamento = 9;

-- 8.5 Conferência: volta a ter 5 pendentes
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;
