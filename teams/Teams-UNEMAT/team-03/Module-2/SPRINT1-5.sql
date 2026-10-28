-- ============================================================
-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS
-- DISCIPLINA: Laboratório de Banco de Dados
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- INSTITUIÇÃO: UNEMAT
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================
-- Relacionamentos utilizados (todos 1:N com agendamento):
--   cliente.id_cliente           -> agendamento.id_cliente
--   profissional.id_profissional -> agendamento.id_profissional
--   servico.id_servico           -> agendamento.id_servico
-- ============================================================

USE db_salao_beleza;


-- ============================================================
-- 0. CARGA COMPLEMENTAR DE DADOS PARA O MODULE 2
-- Motivo: com 1 agendamento por cliente/profissional, os
-- agrupamentos davam sempre 1 e os LEFT/RIGHT JOIN não
-- mostravam registros sem correspondência.
-- Observação: executar uma única vez após recriar o banco
-- (o CPF é UNIQUE e impede a inserção duplicada).
-- ============================================================

-- Cliente SEM agendamento (aparece com NULL no LEFT JOIN)
-- Recebe id_cliente = 7, pois o AUTO_INCREMENT não reaproveita
-- o id 6, excluído no Module-1.
INSERT INTO cliente (nome, cpf, telefone, email)
VALUES ('Patrícia Almeida', '777.888.999-00', '(65) 99777-8899', 'patricia.almeida@email.com');

-- Profissional SEM agendamento (aparece com NULL no RIGHT JOIN)
INSERT INTO profissional (nome, especialidade, telefone)
VALUES ('Gabriela Torres', 'Designer de Sobrancelhas', '(65) 98666-1006');

-- Novos agendamentos (ids 7 a 10): clientes que voltaram,
-- atendimentos concluídos e um cancelado
INSERT INTO agendamento (id_cliente, id_profissional, id_servico, data_hora, status, forma_pagamento, observacoes)
VALUES
    (1, 2, 3, '2026-09-18 09:00:00', 'Concluído', 'Cartão',   'Retorno da cliente'),
    (2, 1, 1, '2026-09-18 14:00:00', 'Concluído', 'Dinheiro', NULL),
    (3, 5, 6, '2026-09-19 10:00:00', 'Agendado',  NULL,       'Segunda sessão'),
    (1, 3, 5, '2026-09-19 16:00:00', 'Cancelado', NULL,       'Cliente desmarcou');


-- ============================================================
-- 1. INNER JOIN 1
-- Pergunta: Quais clientes possuem agendamento, e quando e em
-- qual situação (status) está cada um?
-- Tabelas: cliente (PK id_cliente) + agendamento (FK id_cliente)
-- ============================================================
SELECT
    c.id_cliente,
    c.nome AS cliente,
    a.id_agendamento,
    a.data_hora,
    a.status
FROM cliente AS c
INNER JOIN agendamento AS a
    ON c.id_cliente = a.id_cliente;


-- ============================================================
-- 2. INNER JOIN 2
-- Pergunta: Quais profissionais possuem agendamentos e quais
-- são as datas desses atendimentos?
-- Tabelas: profissional (PK id_profissional) + agendamento
--          (FK id_profissional)
-- ============================================================
SELECT
    p.id_profissional,
    p.nome AS profissional,
    p.especialidade,
    a.id_agendamento,
    a.data_hora
FROM profissional AS p
INNER JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional;


-- ============================================================
-- 3. LEFT JOIN
-- Pergunta: Quais serviços existem no salão e em quais
-- agendamentos aparecem, inclusive os serviços que ainda não
-- foram agendados por nenhum cliente?
-- Tabelas: servico (esquerda) + agendamento (direita)
-- Resultado esperado: o serviço sem agendamento aparece com
-- NULL nas colunas de agendamento.
-- ============================================================
SELECT
    s.id_servico,
    s.nome_servico,
    s.preco,
    a.id_agendamento,
    a.data_hora,
    a.status
FROM servico AS s
LEFT JOIN agendamento AS a
    ON s.id_servico = a.id_servico
ORDER BY s.id_servico;


-- ============================================================
-- 4. RIGHT JOIN
-- Pergunta: Quais profissionais o salão possui e quais
-- agendamentos cada um tem, incluindo quem ainda não tem
-- nenhum atendimento marcado?
-- Tabelas: agendamento (esquerda) + profissional (direita)
-- Resultado esperado: todos os profissionais aparecem; a
-- profissional sem agendamento exibe NULL nas colunas de
-- agendamento.
-- ============================================================
SELECT
    p.id_profissional,
    p.nome AS profissional,
    p.especialidade,
    a.id_agendamento,
    a.data_hora,
    a.status
FROM agendamento AS a
RIGHT JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
ORDER BY p.id_profissional;


-- ============================================================
-- 5. JOIN COM 3+ TABELAS 1
-- Pergunta: Qual é a agenda completa do salão, com cliente,
-- profissional, serviço, data e valor?
-- Tabelas: agendamento + cliente + profissional + servico
-- ============================================================
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    p.nome AS profissional,
    s.nome_servico AS servico,
    s.preco,
    a.data_hora,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico;


-- ============================================================
-- 6. JOIN COM 3+ TABELAS 2
-- Pergunta: Quais atendimentos já foram concluídos, com o
-- nome do cliente, o serviço realizado e a forma de pagamento?
-- Tabelas: agendamento + cliente + servico
-- ============================================================
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    s.nome_servico AS servico,
    s.preco,
    a.forma_pagamento,
    a.observacoes
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico
WHERE a.status = 'Concluído';


-- ============================================================
-- 7. JOIN + WHERE
-- Pergunta: Quais agendamentos ainda estão com status
-- 'Agendado' e valor de serviço a partir de R$ 80,00?
-- Tabelas: agendamento + cliente + servico
-- ============================================================
SELECT
    a.id_agendamento,
    c.nome AS cliente,
    s.nome_servico AS servico,
    s.preco,
    a.data_hora
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico
WHERE a.status = 'Agendado'
  AND s.preco >= 80.00;


-- ============================================================
-- 8. JOIN + ORDER BY
-- Pergunta: Qual é a ordem cronológica dos atendimentos, com
-- o cliente e o profissional de cada um?
-- Tabelas: agendamento + cliente + profissional
-- ============================================================
SELECT
    a.data_hora,
    c.nome AS cliente,
    p.nome AS profissional,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
INNER JOIN profissional AS p
    ON a.id_profissional = p.id_profissional
ORDER BY a.data_hora ASC;


-- ============================================================
-- 9. JOIN + GROUP BY + AGREGAÇÃO
-- Pergunta: Quantos atendimentos cada profissional tem e qual
-- é o faturamento previsto e o ticket médio, desconsiderando
-- os agendamentos cancelados?
-- Tabelas: profissional + agendamento + servico
-- Funções de agregação: COUNT, SUM e AVG
-- ============================================================
SELECT
    p.nome AS profissional,
    COUNT(a.id_agendamento) AS total_atendimentos,
    SUM(s.preco)            AS faturamento_previsto,
    ROUND(AVG(s.preco), 2)  AS ticket_medio
FROM profissional AS p
INNER JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional
INNER JOIN servico AS s
    ON a.id_servico = s.id_servico
WHERE a.status <> 'Cancelado'
GROUP BY p.id_profissional, p.nome
ORDER BY faturamento_previsto DESC;
