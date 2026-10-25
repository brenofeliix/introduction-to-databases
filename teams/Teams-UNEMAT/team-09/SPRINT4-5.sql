-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 4/5 — CONSULTAS SQL E EXPRESSÕES
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Vinícius Eduardo Lima de Assis
-- TEMA DO BANCO: Viagens
-- NOME DO BANCO: pacote_viagens
--
-- INSTRUÇÕES:
-- Script adaptado e testado para o banco de dados pacote_viagens.
-- ============================================================


-- ============================================================
-- 1. SELECIONAR O BANCO
-- ============================================================

USE pacote_viagens;


-- ============================================================
-- 2. CONSULTA BÁSICA COM SELECT
-- ============================================================
--
-- Pergunta:
-- Quais destinos turísticos estão cadastrados no sistema?
--

SELECT *
FROM destino;


-- ============================================================
-- 3. SELECT COM COLUNAS ESPECÍFICAS
-- ============================================================
--
-- Pergunta:
-- Quais são os nomes, e-mails e telefones de todos os clientes cadastrados?
--

SELECT
    nome,
    email,
    telefone
FROM cliente;


-- ============================================================
-- 4. CONSULTA COM WHERE
-- ============================================================
--
-- Pergunta:
-- Quais hospedagens possuem valor de diária superior a R$ 1.000,00?
--

SELECT *
FROM hospedagem
WHERE valor_diaria > 1000.00;


-- ============================================================
-- 5. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================
--
-- Pergunta:
-- Quais transportes aéreos são operados pela empresa LATAM ou Azul?
--

SELECT *
FROM transporte
WHERE tipo = 'Aéreo'
  AND (empresa = 'LATAM' OR empresa = 'Azul');


-- ============================================================
-- 6. CONSULTA COM LIKE
-- ============================================================
--
-- Pergunta:
-- Quais clientes cadastrados possuem o primeiro nome começando com a letra 'C'?
--

SELECT *
FROM cliente
WHERE nome LIKE 'C%';


-- ============================================================
-- 7. CONSULTA COM BETWEEN
-- ============================================================
--
-- Pergunta:
-- Quais hospedagens possuem valor de diária entre R$ 600,00 e R$ 1.500,00?
--

SELECT *
FROM hospedagem
WHERE valor_diaria BETWEEN 600.00 AND 1500.00;


-- ============================================================
-- 8. CONSULTA COM IN
-- ============================================================
--
-- Pergunta:
-- Quais hospedagens são do tipo 'Hotel' ou 'Hotel Luxo'?
--

SELECT *
FROM hospedagem
WHERE tipo IN ('Hotel', 'Hotel Luxo');


-- ============================================================
-- 9. CONSULTA COM IS NULL OU IS NOT NULL
-- ============================================================
--
-- Pergunta:
-- Quais clientes possuem o número de telefone informado (não nulo)?
--

SELECT *
FROM cliente
WHERE telefone IS NOT NULL;


-- ============================================================
-- 10. CONSULTA COM ORDER BY
-- ============================================================
--
-- Pergunta:
-- Quais são os destinos cadastrados ordenados alfabeticamente pelo nome?
--

SELECT *
FROM destino
ORDER BY nome ASC;


-- ============================================================
-- 11. ORDER BY DECRESCENTE
-- ============================================================
--
-- Pergunta:
-- Quais são as hospedagens cadastradas ordenadas da diária mais cara para a mais barata?
--

SELECT *
FROM hospedagem
ORDER BY valor_diaria DESC;


-- ============================================================
-- 12. ORDER BY COM MAIS DE UMA COLUNA
-- ============================================================
--
-- Pergunta:
-- Quais são as hospedagens ordenadas pelo tipo em ordem alfabética e, em seguida, pela diária mais cara?
--

SELECT *
FROM hospedagem
ORDER BY tipo ASC,
         valor_diaria DESC;


-- ============================================================
-- 13. COUNT
-- ============================================================
--
-- Pergunta:
-- Quantos clientes estão cadastrados no sistema?
--

SELECT
    COUNT(*) AS total_registros
FROM cliente;


-- ============================================================
-- 14. COUNT COM WHERE
-- ============================================================
--
-- Pergunta:
-- Quantos clientes estão com o cadastro ativo no sistema?
--

SELECT
    COUNT(*) AS total_filtrado
FROM cliente
WHERE ativo = TRUE;


-- ============================================================
-- 15. SUM
-- ============================================================
--
-- Pergunta:
-- Qual é a quantidade total de pessoas contempladas em todas as reservas efetuadas?
--

SELECT
    SUM(quantidade_pessoas) AS total
FROM reserva_pacote;


-- ============================================================
-- 16. AVG
-- ============================================================
--
-- Pergunta:
-- Qual é o valor médio das diárias entre todas as hospedagens cadastradas?
--

SELECT
    AVG(valor_diaria) AS media
FROM hospedagem;


-- ============================================================
-- 17. MIN E MAX
-- ============================================================
--
-- Pergunta:
-- Qual é a diária mais barata e a diária mais cara entre as hospedagens registradas?
--

SELECT
    MIN(valor_diaria) AS menor_valor,
    MAX(valor_diaria) AS maior_valor
FROM hospedagem;


-- ============================================================
-- 18. GROUP BY
-- ============================================================
--
-- Pergunta:
-- Quantas opções de transporte existem para cada tipo de modal?
--

SELECT
    tipo,
    COUNT(*) AS quantidade
FROM transporte
GROUP BY tipo;


-- ============================================================
-- 19. GROUP BY COM AVG
-- ============================================================
--
-- Pergunta:
-- Qual é o preço médio da diária para cada tipo de acomodação/hospedagem?
--

SELECT
    tipo,
    AVG(valor_diaria) AS media_por_categoria
FROM hospedagem
GROUP BY tipo;


-- ============================================================
-- 20. GROUP BY COM SUM
-- ============================================================
--
-- Pergunta:
-- Qual é a soma total da quantidade de pessoas reservadas por id de hospedagem?
--

SELECT
    id_hospedagem,
    SUM(quantidade_pessoas) AS total_por_categoria
FROM reserva_pacote
GROUP BY id_hospedagem;


-- ============================================================
-- 21. HAVING
-- ============================================================
--
-- Pergunta:
-- Quais tipos de transporte possuem mais de 2 cadastros no sistema?
--

SELECT
    tipo,
    COUNT(*) AS quantidade
FROM transporte
GROUP BY tipo
HAVING COUNT(*) > 1;


-- ============================================================
-- 22. WHERE + GROUP BY + HAVING
-- ============================================================
--
-- Pergunta:
-- Qual é a média da diária por tipo de hospedagem (considerando apenas diárias acima de R$ 500), mantendo apenas tipos com média superior a R$ 1.000?
--

SELECT
    tipo,
    AVG(valor_diaria) AS media
FROM hospedagem
WHERE valor_diaria > 500.00
GROUP BY tipo
HAVING AVG(valor_diaria) > 1000.00;


-- ============================================================
-- 23. EXPRESSÃO SQL
-- ============================================================
--
-- Pergunta:
-- Qual seria o valor estimado da diária de cada hospedagem com um acréscimo de 10% referente a taxas de serviço?
--

SELECT
    nome,
    valor_diaria,
    valor_diaria * 1.10 AS valor_calculado
FROM hospedagem;


-- ============================================================
-- 24. EXPRESSÃO COM DOIS CAMPOS
-- ============================================================
--
-- Pergunta:
-- Qual é a estimativa do valor de 1 diária multiplicada pela quantidade de pessoas em cada reserva?
--

SELECT
    id_reserva,
    quantidade_pessoas,
    id_hospedagem,
    quantidade_pessoas * 500.00 AS subtotal
FROM reserva_pacote;


-- ============================================================
-- 25. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Quais são todas as hospedagens cadastradas e seus respectivos valores organizados do mais caro para o mais barato?
--

SELECT nome, tipo, valor_diaria 
FROM hospedagem 
ORDER BY valor_diaria DESC;


-- ============================================================
-- 26. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Quais modalidades de transporte possuem mais de 2 registros após o agrupamento?
--

SELECT tipo, COUNT(*) AS quantidade 
FROM transporte 
GROUP BY tipo 
HAVING COUNT(*) > 2;


-- ============================================================
-- 27. CONSULTAS EXTRAS
-- ============================================================

-- Consulta extra 1: Quais hospedagens oferecem diárias abaixo de R$ 1.000,00, exibindo o nome, o tipo e o valor ordenados do menor para o maior preço?
SELECT nome, tipo, valor_diaria
FROM hospedagem
WHERE valor_diaria < 1000.00
ORDER BY valor_diaria ASC;

-- Consulta extra 2: Quantas reservas de pacotes foram realizadas para mais de 1 pessoa?
SELECT COUNT(*) AS total_reservas_grupo
FROM reserva_pacote
WHERE quantidade_pessoas > 1;

-- Consulta extra 3: Listar reservas realizadas a partir do mês de setembro de 2026
SELECT id_reserva, id_cliente, data_reserva 
FROM reserva_pacote 
WHERE data_reserva >= '2026-09-01';


-- ============================================================
-- FIM DA SPRINT 4/5
-- ============================================================