-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_restaurante_sabor

USE db_restaurante_sabor;

-- Limpeza para o script poder ser executado varias vezes
DROP VIEW IF EXISTS vw_pedidos_detalhados;
DROP VIEW IF EXISTS vw_faturamento_por_cliente;
DROP VIEW IF EXISTS vw_pedidos_abertos;
DROP VIEW IF EXISTS vw_teste;

-- VIEW 1: relacionamento (pedido + cliente + funcionario + mesa)
CREATE VIEW vw_pedidos_detalhados AS
SELECT p.id_pedido, p.data_pedido, p.status,
       c.nome AS cliente, f.nome AS atendente, m.numero AS mesa
FROM pedido AS p
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa;

-- VIEW 2: agregacao (total gasto por cliente)
CREATE VIEW vw_faturamento_por_cliente AS
SELECT c.id_cliente, c.nome AS cliente,
       COUNT(DISTINCT p.id_pedido) AS qtd_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
GROUP BY c.id_cliente, c.nome;

-- VIEW 3: operacional (pedidos em aberto, o que a cozinha/garcom precisa ver)
CREATE VIEW vw_pedidos_abertos AS
SELECT p.id_pedido, m.numero AS mesa, c.nome AS cliente, f.nome AS atendente
FROM pedido AS p
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
WHERE p.status = 'aberto';

-- CONSULTAS SOBRE AS VIEWS
SELECT * FROM vw_pedidos_detalhados ORDER BY id_pedido;
SELECT * FROM vw_pedidos_detalhados WHERE cliente = 'Ana Souza';
SELECT * FROM vw_faturamento_por_cliente ORDER BY total_gasto DESC;
SELECT * FROM vw_faturamento_por_cliente WHERE total_gasto > 100;
SELECT * FROM vw_pedidos_abertos ORDER BY mesa;

-- CREATE OR REPLACE VIEW: adiciona o total de cada pedido aberto
CREATE OR REPLACE VIEW vw_pedidos_abertos AS
SELECT p.id_pedido, m.numero AS mesa, c.nome AS cliente, f.nome AS atendente,
       SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM pedido AS p
INNER JOIN mesa        AS m  ON p.id_mesa        = m.id_mesa
INNER JOIN cliente     AS c  ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f  ON p.id_funcionario = f.id_funcionario
INNER JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
WHERE p.status = 'aberto'
GROUP BY p.id_pedido, m.numero, c.nome, f.nome;

SELECT * FROM vw_pedidos_abertos ORDER BY mesa;

-- VIEW TEMPORARIA + DROP VIEW
CREATE VIEW vw_teste AS
SELECT nome, preco FROM produto WHERE preco < 10;

SELECT * FROM vw_teste;

DROP VIEW vw_teste;

-- VALIDACAO: so devem restar 3 views
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- TESTE DE ATUALIZACAO DOS DADOS-BASE (feito dentro de transacao e desfeito)
SELECT * FROM vw_faturamento_por_cliente WHERE cliente = 'Pedro Santos';

START TRANSACTION;
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (5, 2, 1, 68.50);
SELECT * FROM vw_faturamento_por_cliente WHERE cliente = 'Pedro Santos';
ROLLBACK;

SELECT * FROM vw_faturamento_por_cliente WHERE cliente = 'Pedro Santos';
