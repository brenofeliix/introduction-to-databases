-- MODULE 2 — SPRINT 1/5
-- JOINS

-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_restaurante_sabor

USE db_restaurante_sabor;

-- INNER JOIN 1: pedidos com o nome do cliente
SELECT p.id_pedido, c.nome AS cliente, p.data_pedido, p.status
FROM pedido AS p
INNER JOIN cliente AS c ON p.id_cliente = c.id_cliente
ORDER BY p.id_pedido;

-- INNER JOIN 2: itens de cada pedido com o nome do produto
SELECT ip.id_pedido, pr.nome AS produto, ip.quantidade, ip.preco_unitario,
       ip.quantidade * ip.preco_unitario AS subtotal
FROM item_pedido AS ip
INNER JOIN produto AS pr ON ip.id_produto = pr.id_produto
ORDER BY ip.id_pedido, pr.nome;

-- LEFT JOIN: todos os funcionarios e seus pedidos (inclui quem nao atendeu nenhum)
SELECT f.id_funcionario, f.nome AS funcionario, f.cargo, p.id_pedido
FROM funcionario AS f
LEFT JOIN pedido AS p ON f.id_funcionario = p.id_funcionario
ORDER BY f.id_funcionario, p.id_pedido;

-- RIGHT JOIN: mesmo resultado, escrito do outro lado (mesas e seus pedidos)
SELECT m.numero AS mesa, m.status, p.id_pedido
FROM pedido AS p
RIGHT JOIN mesa AS m ON p.id_mesa = m.id_mesa
ORDER BY m.numero, p.id_pedido;

-- JOIN com 3+ tabelas (1): pedido + cliente + funcionario + mesa
SELECT p.id_pedido, c.nome AS cliente, f.nome AS atendente, m.numero AS mesa
FROM pedido AS p
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa
ORDER BY p.id_pedido;

-- JOIN com 3+ tabelas (2): detalhe completo do consumo
SELECT c.nome AS cliente, p.id_pedido, pr.nome AS produto, ip.quantidade,
       ip.quantidade * ip.preco_unitario AS subtotal
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
INNER JOIN produto     AS pr ON ip.id_produto = pr.id_produto
ORDER BY c.nome, p.id_pedido;

-- JOIN + WHERE: itens de pedidos ainda abertos
SELECT p.id_pedido, pr.nome AS produto, ip.quantidade
FROM pedido AS p
INNER JOIN item_pedido AS ip ON p.id_pedido = ip.id_pedido
INNER JOIN produto     AS pr ON ip.id_produto = pr.id_produto
WHERE p.status = 'aberto'
ORDER BY p.id_pedido;

-- JOIN + ORDER BY: produtos vendidos do mais caro ao mais barato
SELECT pr.nome AS produto, pr.preco, ip.id_pedido, ip.quantidade
FROM produto AS pr
INNER JOIN item_pedido AS ip ON pr.id_produto = ip.id_produto
ORDER BY pr.preco DESC, ip.id_pedido;

-- JOIN + GROUP BY + agregacao: total gasto por cliente
SELECT c.nome AS cliente,
       COUNT(DISTINCT p.id_pedido) AS qtd_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC;

-- JOIN + GROUP BY (2): quantidade vendida por produto
SELECT pr.nome AS produto, SUM(ip.quantidade) AS qtd_vendida
FROM produto AS pr
INNER JOIN item_pedido AS ip ON pr.id_produto = ip.id_produto
GROUP BY pr.id_produto, pr.nome
ORDER BY qtd_vendida DESC, pr.nome;

-- CONSULTA MAIS UTIL: faturamento por funcionario (LEFT JOIN mantem quem nao vendeu)
SELECT f.nome AS funcionario, f.cargo,
       COUNT(DISTINCT p.id_pedido) AS pedidos,
       COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0) AS faturamento
FROM funcionario AS f
LEFT JOIN pedido      AS p  ON f.id_funcionario = p.id_funcionario
LEFT JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
GROUP BY f.id_funcionario, f.nome, f.cargo
ORDER BY faturamento DESC;
