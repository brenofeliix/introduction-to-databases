-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_restaurante_sabor

USE db_restaurante_sabor;

-- SUBQUERY COM COMPARACAO: produtos mais caros que a media
SELECT nome, preco
FROM produto
WHERE preco > (SELECT AVG(preco) FROM produto)
ORDER BY preco DESC;

-- IN: clientes que ja fizeram pelo menos um pedido
SELECT nome
FROM cliente
WHERE id_cliente IN (SELECT id_cliente FROM pedido)
ORDER BY nome;

-- NOT IN: mesas que NAO tiveram nenhum pedido finalizado
-- (pedido.id_mesa e NOT NULL, entao NOT IN e seguro aqui)
SELECT numero, capacidade, status
FROM mesa
WHERE id_mesa NOT IN (SELECT id_mesa FROM pedido WHERE status = 'finalizado')
ORDER BY numero;

-- EXISTS: mesas que ja tiveram algum pedido
SELECT m.numero, m.capacidade
FROM mesa AS m
WHERE EXISTS (SELECT 1 FROM pedido AS p WHERE p.id_mesa = m.id_mesa)
ORDER BY m.numero;

-- NOT EXISTS: funcionarios que nao atenderam nenhum pedido
SELECT f.nome, f.cargo
FROM funcionario AS f
WHERE NOT EXISTS (SELECT 1 FROM pedido AS p WHERE p.id_funcionario = f.id_funcionario);

-- MAX: produto de maior preco
SELECT nome, preco
FROM produto
WHERE preco = (SELECT MAX(preco) FROM produto);

-- MIN: pedido mais antigo (primeira data)
SELECT id_pedido, data_pedido, status
FROM pedido
WHERE data_pedido = (SELECT MIN(data_pedido) FROM pedido)
ORDER BY id_pedido;

-- SUBQUERY CORRELACIONADA: itens cujo preco_unitario esta acima da media dos itens do mesmo pedido
SELECT ip.id_pedido, pr.nome AS produto, ip.preco_unitario
FROM item_pedido AS ip
INNER JOIN produto AS pr ON pr.id_produto = ip.id_produto
WHERE ip.preco_unitario > (
    SELECT AVG(ip2.preco_unitario)
    FROM item_pedido AS ip2
    WHERE ip2.id_pedido = ip.id_pedido
)
ORDER BY ip.id_pedido;

-- PROBLEMA 1 - JOIN: clientes que ja pediram
SELECT DISTINCT c.nome
FROM cliente AS c
INNER JOIN pedido AS p ON c.id_cliente = p.id_cliente
ORDER BY c.nome;

-- PROBLEMA 1 - SUBQUERY: clientes que ja pediram
SELECT nome
FROM cliente
WHERE id_cliente IN (SELECT id_cliente FROM pedido)
ORDER BY nome;

-- PROBLEMA 2 - JOIN: funcionarios sem pedidos
SELECT f.nome
FROM funcionario AS f
LEFT JOIN pedido AS p ON f.id_funcionario = p.id_funcionario
WHERE p.id_pedido IS NULL;

-- PROBLEMA 2 - SUBQUERY: funcionarios sem pedidos
SELECT nome
FROM funcionario
WHERE id_funcionario NOT IN (SELECT id_funcionario FROM pedido);

-- TESTE OPERACIONAL: mudar o filtro (media -> valor fixo)
SELECT nome, preco
FROM produto
WHERE preco > (SELECT AVG(preco) FROM produto WHERE categoria = 'Bebida');
