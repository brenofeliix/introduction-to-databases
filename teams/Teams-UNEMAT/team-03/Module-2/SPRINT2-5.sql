-- ============================================================
-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS E CONSULTAS AVANÇADAS
-- DISCIPLINA: Laboratório de Banco de Dados
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- INSTITUIÇÃO: UNEMAT
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================
-- Pré-requisito: banco do Module-1 + carga complementar da
-- Sprint 1 (Module-2/SPRINT1-5.sql). Este script contém apenas
-- consultas SELECT e pode ser executado várias vezes.
-- ============================================================

USE db_salao_beleza;


-- ============================================================
-- 1. SUBCONSULTA COM COMPARAÇÃO
-- Pergunta: Quais serviços custam mais do que o preço médio
-- do catálogo do salão?
-- Interna: calcula a média dos preços (AVG)
-- Externa: mostra os serviços com preço acima dessa média
-- ============================================================
SELECT
    nome_servico,
    preco
FROM servico
WHERE preco > (
    SELECT AVG(preco)
    FROM servico
)
ORDER BY preco DESC;


-- ============================================================
-- 2. SUBCONSULTA COM IN
-- Pergunta: Quais clientes têm agendamento (não cancelado) de
-- algum serviço acima de R$ 100,00?
-- Subconsulta mais interna: códigos dos serviços acima de R$ 100
-- Subconsulta do meio: clientes que agendaram esses serviços
-- Externa: nome e telefone desses clientes
-- ============================================================
SELECT
    nome,
    telefone
FROM cliente
WHERE id_cliente IN (
    SELECT a.id_cliente
    FROM agendamento AS a
    WHERE a.status <> 'Cancelado'
      AND a.id_servico IN (
          SELECT s.id_servico
          FROM servico AS s
          WHERE s.preco > 100.00
      )
);


-- ============================================================
-- 3. SUBCONSULTA COM NOT IN
-- Pergunta: Quais serviços do catálogo nunca foram agendados?
-- Interna: lista dos serviços que aparecem em agendamento
-- Externa: serviços que NÃO estão nessa lista
-- ============================================================
SELECT
    id_servico,
    nome_servico,
    preco
FROM servico
WHERE id_servico NOT IN (
    SELECT id_servico
    FROM agendamento
);


-- ============================================================
-- 4. EXISTS
-- Pergunta: Quais profissionais já concluíram pelo menos um
-- atendimento?
-- Para cada profissional, a subconsulta procura um agendamento
-- dele com status 'Concluído'; se encontrar, o profissional
-- aparece no resultado.
-- ============================================================
SELECT
    p.nome,
    p.especialidade
FROM profissional AS p
WHERE EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_profissional = p.id_profissional
      AND a.status = 'Concluído'
);


-- ============================================================
-- 5. NOT EXISTS
-- Pergunta: Quais clientes estão cadastrados mas ainda não
-- fizeram nenhum agendamento?
-- Para cada cliente, a subconsulta procura algum agendamento;
-- o cliente aparece apenas se NÃO encontrar nenhum.
-- ============================================================
SELECT
    c.nome,
    c.telefone,
    c.email
FROM cliente AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_cliente = c.id_cliente
);


-- ============================================================
-- 6. SUBCONSULTA COM MAX
-- Pergunta: Qual é o serviço mais caro do salão?
-- Interna: encontra o maior preço (MAX)
-- Externa: mostra o serviço que tem esse preço
-- ============================================================
SELECT
    nome_servico,
    duracao_minutos,
    preco
FROM servico
WHERE preco = (
    SELECT MAX(preco)
    FROM servico
);


-- ============================================================
-- 7. SUBCONSULTA CORRELACIONADA
-- Pergunta: Quantos agendamentos cada cliente possui?
-- A subconsulta usa c.id_cliente, que vem da consulta externa,
-- e por isso é executada uma vez para cada cliente.
-- ============================================================
SELECT
    c.nome,
    (
        SELECT COUNT(*)
        FROM agendamento AS a
        WHERE a.id_cliente = c.id_cliente
    ) AS total_agendamentos
FROM cliente AS c
ORDER BY total_agendamentos DESC, c.nome;


-- ============================================================
-- 8. PROBLEMA 1 — JOIN
-- Pergunta: Quais clientes já tiveram atendimento concluído?
-- DISTINCT evita repetir a cliente com mais de um concluído.
-- ============================================================
SELECT DISTINCT
    c.nome
FROM cliente AS c
INNER JOIN agendamento AS a
    ON c.id_cliente = a.id_cliente
WHERE a.status = 'Concluído';


-- ============================================================
-- 9. PROBLEMA 1 — SUBQUERY
-- Mesma pergunta do item 8, resolvida com IN
-- ============================================================
SELECT
    nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM agendamento
    WHERE status = 'Concluído'
);


-- ============================================================
-- 10. PROBLEMA 2 — JOIN
-- Pergunta: Quais profissionais já tiveram agendamento com a
-- cliente Mariana Souza?
-- ============================================================
SELECT DISTINCT
    p.nome,
    p.especialidade
FROM profissional AS p
INNER JOIN agendamento AS a
    ON p.id_profissional = a.id_profissional
INNER JOIN cliente AS c
    ON a.id_cliente = c.id_cliente
WHERE c.nome = 'Mariana Souza';


-- ============================================================
-- 11. PROBLEMA 2 — SUBQUERY
-- Mesma pergunta do item 10, com subconsultas encadeadas
-- ============================================================
SELECT
    nome,
    especialidade
FROM profissional
WHERE id_profissional IN (
    SELECT id_profissional
    FROM agendamento
    WHERE id_cliente = (
        SELECT id_cliente
        FROM cliente
        WHERE nome = 'Mariana Souza'
    )
);
