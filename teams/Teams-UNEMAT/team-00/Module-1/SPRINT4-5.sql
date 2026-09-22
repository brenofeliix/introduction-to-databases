-- ============================================================
-- DISCIPLINA: Laboratório de Banco de Dados
-- SPRINT 4/5 — Consultas SQL e Expressões
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================

-- SELEÇÃO DO BANCO DE DADOS
USE db_salao_beleza;


-- ============================================================
-- 1. CONSULTAS BÁSICAS (SELECT)
-- ============================================================

-- Consulta 01: Visualização completa da tabela de clientes
-- Pergunta: Quais são todos os dados dos clientes cadastrados no salão?
SELECT *
FROM cliente;

-- Consulta 02: Projeção de colunas específicas da tabela de serviços
-- Pergunta: Qual é a relação de serviços disponíveis, exibindo apenas nome, duração e preço?
SELECT nome_servico, duracao_minutos, preco
FROM servico;


-- ============================================================
-- 2. FILTROS COM WHERE (SIMPLES E COMPOSTO)
-- ============================================================

-- Consulta 03: Filtro simples utilizando operador relacional
-- Pergunta: Quais serviços do salão possuem valor superior a R$ 70,00?
SELECT nome_servico, preco
FROM servico
WHERE preco > 70.00;

-- Consulta 04: Filtro composto com operador lógico AND
-- Pergunta: Quais agendamentos estão marcados com status 'Agendado' para o dia 15/09/2026?
SELECT id_agendamento, id_cliente, id_profissional, id_servico, data_hora, status
FROM agendamento
WHERE status = 'Agendado'
  AND data_hora >= '2026-09-15 00:00:00'
  AND data_hora <= '2026-09-15 23:59:59';


-- ============================================================
-- 3. ORDENAÇÃO (ORDER BY)
-- ============================================================

-- Consulta 05: Ordenação alfabética crescente (ASC)
-- Pergunta: Quais são os clientes cadastrados em ordem alfabética de nome?
SELECT nome, telefone, email
FROM cliente
ORDER BY nome ASC;

-- Consulta 06: Ordenação decrescente por valor (DESC)
-- Pergunta: Quais procedimentos do salão são os mais caros, ordenados do maior para o menor preço?
SELECT nome_servico, duracao_minutos, preco
FROM servico
ORDER BY preco DESC;


-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO (COUNT, SUM, AVG, MIN, MAX)
-- ============================================================

-- Consulta 07 (COUNT): Contagem total de clientes e atendimentos
-- Pergunta: Quantos clientes ativos e quantos agendamentos existem registrados no salão?
SELECT 
    (SELECT COUNT(*) FROM cliente) AS total_clientes,
    (SELECT COUNT(*) FROM agendamento) AS total_agendamentos;

-- Consulta 08 (SUM): Soma de valores monetários
-- Pergunta: Qual seria o faturamento somado se todos os serviços do catálogo fossem contratados uma vez?
SELECT SUM(preco) AS faturamento_total_catalogo
FROM servico;

-- Consulta 09 (AVG): Média de preços e de duração em minutos
-- Pergunta: Qual é o preço médio e o tempo médio de atendimento dos serviços do salão?
SELECT 
    ROUND(AVG(preco), 2) AS preco_medio_servicos,
    ROUND(AVG(duracao_minutos), 1) AS duracao_media_minutos
FROM servico;

-- Consulta 10 (MIN e MAX): Valores extremos do catálogo
-- Pergunta: Qual é o menor preço (serviço mais acessível) e o maior preço praticado no salão?
SELECT 
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM servico;


-- ============================================================
-- 5. AGRUPAMENTO (GROUP BY)
-- ============================================================

-- Consulta 11: Agrupamento de atendimentos por status
-- Pergunta: Quantos agendamentos existem agrupados por status de atendimento?
SELECT 
    status,
    COUNT(*) AS quantidade_agendamentos
FROM agendamento
GROUP BY status;

-- Consulta 12: Produtividade por profissional
-- Pergunta: Quantos atendimentos cada profissional possui agendados no sistema?
SELECT 
    id_profissional,
    COUNT(*) AS total_atendimentos
FROM agendamento
GROUP BY id_profissional
ORDER BY total_atendimentos DESC;


-- ============================================================
-- 6. FILTRO SOBRE GRUPOS (HAVING)
-- ============================================================

-- Consulta 13: Filtro pós-agregação com HAVING
-- Pergunta: Quais status de agendamento concentram mais de 1 atendimento registrado?
SELECT 
    status,
    COUNT(*) AS quantidade
FROM agendamento
GROUP BY status
HAVING COUNT(*) > 1;


-- ============================================================
-- 7. EXPRESSÕES SQL (CÁLCULOS MATEMÁTICOS)
-- ============================================================

-- Consulta 14: Expressão de cálculo com percentual de desconto
-- Pergunta: Qual será o preço promocional dos serviços aplicando 15% de desconto para clientes fidelidade?
SELECT 
    nome_servico,
    preco AS preco_original,
    ROUND(preco * 0.15, 2) AS valor_desconto_15,
    ROUND(preco * 0.85, 2) AS preco_promocional_com_desconto
FROM servico
ORDER BY preco_original DESC;


-- ============================================================
-- 8. CONSULTA RELACIONAL EXTRA (INTEGRAÇÃO COM INNER JOIN)
-- ============================================================

-- Consulta 15: Relatório executivo completo integrando as 4 tabelas
-- Pergunta: Qual é a lista completa de atendimentos exibindo o nome do cliente, o profissional, o serviço, horário, preço e status?
SELECT 
    a.id_agendamento,
    c.nome AS nome_cliente,
    p.nome AS nome_profissional,
    p.especialidade,
    s.nome_servico,
    s.preco,
    a.data_hora,
    a.status,
    a.forma_pagamento
FROM agendamento a
INNER JOIN cliente c ON a.id_cliente = c.id_cliente
INNER JOIN profissional p ON a.id_profissional = p.id_profissional
INNER JOIN servico s ON a.id_servico = s.id_servico
ORDER BY a.data_hora ASC;
