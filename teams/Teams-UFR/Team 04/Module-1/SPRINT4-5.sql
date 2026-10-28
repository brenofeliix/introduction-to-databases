USE mercado;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================

-- Consulta 1: mostrar todos os produtos cadastrados
SELECT *
FROM produto;

-- Consulta 2: mostrar nome, categoria e preço dos produtos
SELECT nome, categoria, preco
FROM produto;

-- ============================================================
-- 2. WHERE
-- ============================================================

-- Consulta 3: produtos com preço acima de R$ 10
SELECT nome, preco
FROM produto
WHERE preco > 10;

-- Consulta 4: produtos de alimentos com preço abaixo de R$ 30
SELECT nome, categoria, preco
FROM produto
WHERE categoria = 'Alimentos'
  AND preco < 30;

-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- Consulta 5: ordenar os produtos do mais caro ao mais barato
SELECT nome, preco
FROM produto
ORDER BY preco DESC;

-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- Consulta 6: contar a quantidade de produtos cadastrados
SELECT COUNT(*) AS total_produtos
FROM produto;

-- Consulta 7: calcular o valor total dos itens vendidos
SELECT SUM(quantidade * preco_unitario) AS valor_total_vendas
FROM item_venda;

-- Consulta 8: calcular o preço médio dos produtos
SELECT AVG(preco) AS preco_medio
FROM produto;

-- Consulta 9: mostrar o menor e o maior preço dos produtos
SELECT MIN(preco) AS menor_preco,
       MAX(preco) AS maior_preco
FROM produto;

-- ============================================================
-- 5. GROUP BY
-- ============================================================

-- Consulta 10: contar quantos produtos existem em cada categoria
SELECT categoria,
       COUNT(*) AS quantidade_produtos
FROM produto
GROUP BY categoria;

-- ============================================================
-- 6. HAVING
-- ============================================================

-- Consulta 11: mostrar categorias com mais de um produto
SELECT categoria,
       COUNT(*) AS quantidade_produtos
FROM produto
GROUP BY categoria
HAVING COUNT(*) > 1;

-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================

-- Consulta 12: calcular o preço dos produtos com 10% de desconto
SELECT nome,
       preco,
       ROUND(preco * 0.90, 2) AS preco_com_desconto
FROM produto;

-- Consulta 13: calcular o subtotal de cada item vendido
SELECT id_venda,
       id_produto,
       quantidade,
       preco_unitario,
       quantidade * preco_unitario AS subtotal
FROM item_venda;

-- ============================================================
-- 8. CONSULTAS EXTRAS
-- ============================================================

-- Consulta 14: mostrar as vendas e seus respectivos clientes
SELECT venda.id_venda,
       cliente.nome AS nome_cliente,
       venda.data_venda,
       venda.status
FROM venda
INNER JOIN cliente
    ON venda.id_cliente = cliente.id_cliente;

-- Consulta 15: mostrar o total de cada venda
SELECT id_venda,
       SUM(quantidade * preco_unitario) AS total_venda
FROM item_venda
GROUP BY id_venda
ORDER BY total_venda DESC;

-- Consulta 16: contar quantas vendas cada cliente realizou
SELECT cliente.nome,
       COUNT(venda.id_venda) AS total_vendas
FROM cliente
LEFT JOIN venda
    ON cliente.id_cliente = venda.id_cliente
GROUP BY cliente.id_cliente, cliente.nome
ORDER BY total_vendas DESC;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM produto;
SELECT * FROM venda;
SELECT * FROM item_venda;
```