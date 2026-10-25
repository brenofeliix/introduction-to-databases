-- ============================================================
-- SPRINT 4/5 — Consultas SQL e Expressões
-- ALUNO: João Guilherme Barros de Lima
-- BANCO: real_estate_database
-- ============================================================

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE real_estate_database;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================

-- Consulta 1
-- Pergunta: Quais são todos os imóveis cadastrados no sistema?
SELECT * FROM imovel;

-- Colunas específicas
SELECT titulo, valor FROM imovel;

-- ============================================================
-- 2. WHERE
-- ============================================================

-- Consulta obrigatória com WHERE
-- Pergunta: Quais imóveis estão localizados na cidade de Rondonópolis?
SELECT titulo, valor, cidade
FROM imovel
WHERE cidade = 'Rondonópolis';

-- Consulta com mais de uma condição
-- Pergunta: Quais agendamentos estão pendentes e marcados para depois de 16/10/2026?
SELECT *
FROM agendamento
WHERE status = 'Pendente'
  AND data_visita > '2026-10-16';

-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- Consulta obrigatória com ORDER BY
-- Pergunta: Quais imóveis custam menos de R$ 300.000,00, do mais barato ao mais caro?
SELECT titulo, valor, cidade
FROM imovel
WHERE valor < 300000.00
ORDER BY valor ASC;

-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- COUNT
-- Pergunta: Quantos agendamentos estão atualmente com o status "Pendente"?
SELECT COUNT(*) AS agendamentos_pendentes
FROM agendamento
WHERE status = 'Pendente';

-- SUM
-- Pergunta: Qual é a soma total em dinheiro de todos os imóveis em catálogo?
SELECT SUM(valor) AS soma_total_imoveis
FROM imovel;

-- AVG
-- Pergunta: Qual é a média de preço dos imóveis anunciados no sistema?
SELECT AVG(valor) AS media_precos
FROM imovel;

-- MIN / MAX
-- Pergunta: Qual é o valor do imóvel mais barato e do mais caro anunciados?
SELECT MIN(valor) AS imovel_mais_barato,
       MAX(valor) AS imovel_mais_caro
FROM imovel;

-- ============================================================
-- 5. GROUP BY
-- ============================================================

-- Consulta obrigatória com GROUP BY
-- Pergunta: Quantos imóveis temos anunciados divididos por cada cidade?
SELECT cidade, COUNT(*) AS total_por_cidade
FROM imovel
GROUP BY cidade;

-- ============================================================
-- 6. HAVING
-- ============================================================

-- Consulta obrigatória com HAVING
-- Pergunta: Quais clientes possuem mais de 1 agendamento de visita registrado?
SELECT id_cliente, COUNT(*) AS quantidade_visitas
FROM agendamento
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================

-- Consulta com expressão
-- Pergunta: Qual seria a comissão do corretor (5%) sobre o valor de cada imóvel?
SELECT titulo,
       valor,
       valor * 0.05 AS comissao_corretor
FROM imovel;

-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

-- Pergunta: Quais as datas de visita agendadas para o imóvel de ID 3 (Chácara)?
SELECT id_cliente, data_visita, status
FROM agendamento
WHERE id_imovel = 3
ORDER BY data_visita ASC;

-- Pergunta: Quantos imóveis temos anunciados no total?
SELECT COUNT(*) AS total_imoveis
FROM imovel;
