-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_restaurante_sabor

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE db_restaurante_sabor;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================

-- Consulta 01
-- Pergunta: Quais são todos os produtos cadastrados no cardápio?
SELECT *
FROM produto;

-- Consulta 02 (colunas específicas)
-- Pergunta: Quais são apenas os nomes e preços dos produtos?
SELECT nome, preco
FROM produto;

-- ============================================================
-- 2. WHERE
-- ============================================================

-- Consulta 03
-- Pergunta: Quais produtos são da categoria "Bebida"?
SELECT nome, preco
FROM produto
WHERE categoria = 'Bebida';

-- Consulta 04 (mais de uma condição)
-- Pergunta: Quais pratos principais custam mais de R$ 50,00?
SELECT nome, categoria, preco
FROM produto
WHERE categoria = 'Prato principal'
  AND preco > 50;

-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- Consulta 05
-- Pergunta: Quais são os produtos ordenados do mais caro para o mais barato?
SELECT nome, preco
FROM produto
ORDER BY preco DESC;

-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- COUNT
-- Pergunta: Quantos pedidos cada funcionário atendeu?
SELECT f.nome AS funcionario, COUNT(p.id_pedido) AS total_pedidos
FROM funcionario f
LEFT JOIN pedido p ON p.id_funcionario = f.id_funcionario
GROUP BY f.id_funcionario, f.nome
ORDER BY total_pedidos DESC;

-- SUM
-- Pergunta: Qual é o valor total (em R$) de cada pedido já feito?
SELECT ip.id_pedido, SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM item_pedido ip
GROUP BY ip.id_pedido
ORDER BY ip.id_pedido;

-- AVG
-- Pergunta: Qual é o preço médio dos produtos em cada categoria do cardápio?
SELECT categoria, AVG(preco) AS preco_medio
FROM produto
GROUP BY categoria;

-- MIN / MAX
-- Pergunta: Qual é o produto mais barato e o mais caro do cardápio?
SELECT MIN(preco) AS produto_mais_barato,
       MAX(preco) AS produto_mais_caro
FROM produto;

-- ============================================================
-- 5. GROUP BY
-- ============================================================

-- Consulta obrigatória com GROUP BY
-- Pergunta: Quantos pedidos existem em cada status (aberto / finalizado)?
SELECT status, COUNT(*) AS quantidade
FROM pedido
GROUP BY status;

-- ============================================================
-- 6. HAVING
-- ============================================================

-- Consulta obrigatória com HAVING
-- Pergunta: Quais categorias de produto têm preço médio acima de R$ 10,00?
-- (WHERE não serviria aqui porque o filtro é sobre o resultado do agrupamento,
-- não sobre linhas individuais da tabela produto)
SELECT categoria, AVG(preco) AS preco_medio
FROM produto
GROUP BY categoria
HAVING AVG(preco) > 10;

-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================

-- Consulta com expressão
-- Pergunta: Qual o subtotal (quantidade x preço unitário) de cada item de pedido?
SELECT id_item_pedido,
       id_pedido,
       quantidade,
       preco_unitario,
       quantidade * preco_unitario AS subtotal
FROM item_pedido
ORDER BY id_pedido;

-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

-- Pergunta: Qual é o faturamento total do restaurante somando todos os pedidos?
SELECT SUM(quantidade * preco_unitario) AS faturamento_total
FROM item_pedido;

-- Pergunta: Quais mesas estão atualmente ocupadas?
SELECT numero, capacidade, status
FROM mesa
WHERE status = 'ocupada';
