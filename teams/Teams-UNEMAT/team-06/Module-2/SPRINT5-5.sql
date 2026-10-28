CREATE DATABASE IF NOT EXISTS db_conveniencia;
USE db_conveniencia;
  
CREATE TABLE Categoria(
id_categoria INT PRIMARY KEY auto_increment,
nome_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE Produto(
id_produto INT PRIMARY KEY auto_increment,
id_categoria INT,
codigo_barras VARCHAR(50) UNIQUE,
nome_produto VARCHAR(100) NOT NULL,
preco_venda DECIMAL(10,2) CHECK (preco_venda >= 0),
quantidade_estoque INT CHECK (quantidade_estoque >=0),
FOREIGN KEY (id_categoria) references Categoria(id_categoria)
);

CREATE TABLE Venda(
id_venda INT auto_increment PRIMARY KEY,
data_venda DATETIME DEFAULT current_timestamp,
valor_total DECIMAL(10,2)
);

CREATE TABLE Item_venda(
quantidade int,
id_venda INT,
id_produto int,
PRIMARY KEY (id_venda, id_produto),
FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

INSERT INTO Categoria(nome_categoria) VALUES
('Salgados'),
('Doces e Bolachas'),
('Pão fresco'),
('Bebidas');


INSERT INTO Produto(id_categoria, codigo_barras, nome_produto, preco_venda, quantidade_estoque) VALUES 
(1, '102324232323', 'Pão Frito', 8.50, 50),
(1, '102324232324', 'Salgado Assado', 12.00, 50),
(2, '142324232325', 'Bolacha Recheada', 5.00, 50),
(2, '102324232326', 'Chocolate Especial', 25.00, 10),
(3, '102324232327', 'Pão Francês 1kg', 15.00, 32),
(3, '102324232328', 'Pão de Queijo', 22.50, 78),
(4, '142324232329', 'Suco Natural', 9.00, 98),
(4, '102324232330', 'Refrigerante 2L', 10.00, 4);


INSERT INTO Venda(valor_total) VALUES
(15.00), (13.00), (12.00), (03.00), (07.00),
(23.00), (08.00), (45.00), (56.00), (93.00);


INSERT INTO Item_venda(quantidade, id_venda, id_produto) VALUES
(1, 1, 1),
(1, 1, 2),
(1, 2, 3),
(2, 3, 4),
(1, 5, 2);

INSERT INTO Item_venda(quantidade, id_venda,id_produto) VALUES
(1,1,1),
(1,1,2),
(1,2,3),
(2,3,4),
(1,5,2);

SELECT
    a.campo,
    b.campo
FROM tabela_a AS a
INNER JOIN tabela_b AS b
    ON a.id = b.id_a;
    
    SELECT
p.nome_produto,
c.nome_categoria,
p.preco_venda
FROM Produto AS p
INNER JOIN Categoria as c
ON p.id_categoria = c.id_categoria;

SELECT
v.id_venda,
v.data_venda,
p.nome_produto
FROM Item_venda as iv
INNER JOIN Venda AS v
ON iv.id_venda = v.id_venda
INNER JOIN Produto AS p
ON iv.id_produto = p.id_produto;

SELECT
p.nome_produto,
c.nome_categoria
FROM Categoria AS c
LEFT JOIN Produto AS p
ON c.id_categoria = p.id_categoria;

SELECT
iv.id_venda,
p.nome_produto
FROM Item_venda AS iv
RIGHT JOIN Produto AS p
ON iv.id_produto = p.id_produto;

SELECT
v.id_venda,
v.data_venda,
c.nome_categoria,
p.nome_produto
FROM Venda AS v
INNER JOIN Item_venda AS iv
ON v.id_venda = iv.id_venda
INNER JOIN Produto as p
ON iv.id_produto = p.id_produto
INNER JOIN Categoria as c
ON p.id_categoria = c.id_categoria;

SELECT
c.nome_categoria,
p.nome_produto,
iv.quantidade,
v.valor_total
FROM Categoria AS c
INNER JOIN Produto as p
ON c.id_categoria = p.id_categoria
INNER JOIN Item_venda AS iv
ON p.id_produto = iv.id_produto
INNER JOIN Venda as v
ON iv.id_venda = v.id_venda
WHERE v.id_venda = 1;

SELECT
v.id_venda,
p.nome_produto,
c.nome_categoria
FROM Item_venda AS iv
INNER JOIN Produto as p
ON iv.id_produto = p.id_produto
INNER JOIN Categoria as c
ON p.id_categoria = c.id_categoria
INNER JOIN Venda AS v
ON iv.id_venda = v.id_venda
WHERE c.nome_categoria = 'Cobras';

SELECT 
    p.nome_produto, 
    c.nome_categoria, 
    p.preco_venda
FROM Produto AS p
INNER JOIN Categoria AS c
    ON p.id_categoria = c.id_categoria
ORDER BY p.preco_venda DESC;

SELECT 
    p.nome_produto, 
    SUM(iv.quantidade) AS total_unidades_vendidas
FROM Produto AS p
INNER JOIN Item_Venda AS iv
    ON p.id_produto = iv.id_produto
GROUP BY p.nome_produto;

SELECT 
    c.nome_categoria, 
    SUM(p.preco_venda * iv.quantidade) AS faturamento_por_categoria
FROM Categoria AS c
INNER JOIN Produto AS p
    ON c.id_categoria = p.id_categoria
INNER JOIN Item_Venda AS iv
    ON p.id_produto = iv.id_produto
GROUP BY c.nome_categoria;

SELECT p.nome_produto, c.nome_categoria 
FROM Produto AS p 
INNER JOIN Categoria AS c ON p.id_categoria = c.id_categoria;
    
    SELECT 
nome_produto,
preco_venda
FROM Produto
WHERE preco_venda > (
SELECT AVG(preco_venda)
FROM Produto
);

SELECT
nome_produto,
preco_venda
FROM Produto
WHERE id_produto IN (
SELECT DISTINCT id_produto
FROM Item_venda
);

SELECT
nome_produto,
preco_venda
FROM Produto
WHERE id_produto NOT IN (
SELECT distinct id_produto
FROM Item_venda
WHERE id_produto is NOT NULL
);

SELECT
c.nome_categoria
FROM Categoria AS c
WHERE EXISTS (
SELECT 1
FROM Produto AS p
WHERE p.id_categoria = c.id_categoria
AND p.preco_venda > 20.00
);

SELECT
c.nome_categoria
FROM Categoria AS c
WHERE NOT EXISTS (
SELECT 1
FROM Produto AS p
WHERE p.id_categoria = c.id_categoria
);

SELECT
nome_produto,
preco_venda
FROM Produto
WHERE preco_venda = (
SELECT MAX(preco_venda)
FROM Produto
);

SELECT
p1.nome_produto,
p1.preco_venda,
p1.id_categoria
FROM Produto as p1
WHERE p1.preco_venda > (
SELECT AVG(p2.preco_venda)
FROM Produto AS p2
WHERE p2.id_categoria = p1.id_categoria
);

-- JOIN -- 
SELECT
p.nome_produto,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria
WHERE c.nome_categoria = 'Salgados';

-- Subquery --
SELECT 
nome_produto
FROM Produto
WHERE id_categoria IN (
SELECT id_categoria
FROM Categoria
WHERE nome_categoria = 'Salgados'
);

-- JOIN pergunta 2--
SELECT 
p.nome_produto
FROM Produto AS p
LEFT JOIN Item_venda AS iv
ON p.id_produto = iv.id_produto
WHERE iv.id_produto is NULL;

-- SUBQUERY pergunta 2--
SELECT
p.nome_produto
FROM Produto AS p
WHERE NOT EXISTS (
SELECT 1
FROM Item_venda AS iv
WHERE iv.id_produto = p.id_produto
);

SELECT nome_produto, preco_venda
FROM Produto
WHERE preco_venda > (
SELECT AVG(preco_venda)
FROM Produto
);

SELECT nome_produto, preco_venda
FROM Produto
WHERE preco_venda > (
SELECT AVG(preco_venda) + 10.00 FROM Produto
);

CREATE VIEW vw_detalhes_produtos AS
SELECT
p.id_produto,
p.codigo_barras,
p.nome_produto,
p.preco_venda,
p.quantidade_estoque,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria;

SELECT
nome_produto,
preco_venda,
nome_categoria
FROM vw_detalhes_produtos
WHERE nome_categoria = 'Salgados';

CREATE VIEW vw_resumo_vendas_categoria AS
SELECT 
    c.nome_categoria,
    COUNT(DISTINCT p.id_produto) AS total_produtos_distintos,
    COALESCE(SUM(iv.quantidade), 0) AS total_itens_vendidos,
    COALESCE(SUM(iv.quantidade * p.preco_venda), 0.00) AS faturamento_total
FROM Categoria AS c
LEFT JOIN Produto AS p 
    ON c.id_categoria = p.id_categoria
LEFT JOIN Item_venda AS iv 
    ON p.id_produto = iv.id_produto
GROUP BY c.id_categoria, c.nome_categoria;

CREATE VIEW vw_estoque_critico AS
SELECT
p.id_produto,
p.nome_produto,
p.quantidade_estoque,
c.nome_categoria
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria
WHERE p.quantidade_estoque < 20;

-- Sem filtro --
SELECT * FROM vw_detalhes_produtos;
-- Com Filtro --
SELECT
nome_produto,
quantidade_estoque
FROM vw_detalhes_produtos
wHERE quantidade_estoque >= 50;

CREATE OR REPLACE VIEW vw_estoque_critico AS
SELECT
p.id_produto,
p.codigo_barras,
p.nome_produto,
p.preco_venda,
p.quantidade_estoque,
c.nome_categoria,
CASE
WHEN p.quantidade_estoque = 0 THEN 'SEM ESTOQUE'
WHEN p.quantidade_estoque <= 10 THEN 'ALERTA VERMELHO'
ELSE 'REPOSIÇÃO NECESSARIA'
END AS situacao_estoque
FROM Produto AS p
INNER JOIN Categoria AS c
ON p.id_categoria = c.id_categoria 
WHERE p.quantidade_estoque <= 35;

-- view temporaria --
CREATE VIEW vw_amor_temporario AS
SELECT id_produto, nome_produto FROM Produto;

-- removendo o amor --
DROP VIEW vw_amor_temporario;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- consulta inicial --
SELECT nome_produto, preco_venda FROM vw_detalhes_produtos WHERE id_produto = 1;

-- update --
UPDATE Produto
set preco_venda = 10.50
WHERE id_produto = 1;

-- consulta final --
SELECT nome_produto, preco_venda FROM vw_detalhes_produtos WHERE id_produto = 1;

DELIMITER //
CREATE PROCEDURE sp_baixar_estoque(IN p_id_produto INT, IN p_qtd_comprada INT)
BEGIN
DECLARE v_estoque_atual INT;

SELECT quantidade_estoque INTO v_estoque_atual
FROM Produto
WHERE id_produto = p_id_produto;

IF v_estoque_atual >= p_qtd_comprada THEN
UPDATE Produto
SET quantidade_estoque = quantidade_estoque - p_qtd_comprada
WHERE id_produto = p_id_produto;
SELECT 'Sucesso: Estoque atualizado!' AS Status_Operacao;
ELSE
SELECT 'Erro: Estoque insuficiente para realizar essa venda.' AS Status_Operacao;
END IF;
END //
DELIMITER ;

CALL sp_baixar_estoque(1, 5); 


DELIMITER //
CREATE PROCEDURE sp_produtos_por_categoria(IN p_nome_categoria VARCHAR(50))
BEGIN
SELECT 
p.id_produto,
p.nome_produto,
p.preco_venda,
p.quantidade_estoque
FROM Produto p
INNER JOIN Categoria c ON p.id_categoria = c.id_categoria
WHERE c.nome_categoria = p_nome_categoria;
END //

DELIMITER ;

CALL sp_produtos_por_categoria('Salgados');

DELIMITER //
CREATE PROCEDURE sp_total_vendas_periodo(OUT p_total_arrecadado DECIMAL(10,2))
BEGIN
SELECT SUM(valor_total) INTO p_total_arrecadado
FROM Venda;
END //
DELIMITER ;

CALL sp_total_vendas_periodo(@meu_faturamento);
SELECT @meu_faturamento AS Faturamento_Total_Loja;


DELIMITER //
CREATE FUNCTION fn_aplicar_desconto(p_valor DECIMAL(10,2), p_porcentagem DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE v_valor_final DECIMAL(10,2);

IF p_porcentagem > 0 THEN
SET v_valor_final = p_valor - (p_valor *(p_porcentagem / 100));
ELSE 
SET v_valor_final = p_valor;
END IF;
RETURN v_valor_final;
END //
DELIMITER ;

SELECT 
nome_produto,
preco_venda AS preco_original,
fn_aplicar_desconto(preco_venda, 10.00) AS preco_com_10_porcento_desconto
FROM Produto; 

CALL sp_baixar_estoque(1, 5);
CALL sp_baixar_estoque(1, 99999);

CALL sp_produtos_por_categoria('Salgados');
CALL sp_produtos_por_categoria('Bebidas');


SELECT fn_aplicar_desconto(100.00,15.00) AS Teste_15_Porcento;
SELECT fn_aplicar_desconto(50.00, 0.00) AS Teste_Zero_Porcento;



DELIMITER //
CREATE TRIGGER trg_atualiza_estoque_venda
AFTER INSERT ON Item_venda
FOR EACH ROW
BEGIN
UPDATE Produto
SET quantidade_estoque = quantidade_estoque - NEW.quantidade
WHERE id_produto = NEW.id_produto;
END //

DELIMITER ;

SELECT nome_produto, quantidade_estoque FROM Produto WHERE id_produto = 1;

INSERT INTO Item_venda(quantidade, id_venda, id_produto) VALUES (3, 2, 1);

SELECT nome_produto, quantidade_estoque FROM Produto WHERE id_produto = 1;

START TRANSACTION;

INSERT INTO Venda(valor_total) VALUES(20.00);

SET @id_nova_venda = LAST_INSERT_ID();

INSERT INTO Item_venda(quantidade, id_venda, id_produto) VALUES(2,@id_nova_venda,4);

COMMIT;

START TRANSACTION;

INSERT INTO Venda(valor_total) VALUES(150.00);
SET @id_venda_cancelada = LAST_INSERT_ID();

ROLLBACK;

SELECT MAX(id_venda) AS ultima_venda FROM Venda;

SELECT 
v.id_venda,
v.data_venda,
c.nome_categoria,
p.nome_produto,
iv.quantidade
FROM Venda AS v
INNER JOIN Item_venda AS iv ON v.id_venda = iv.id_venda
INNER JOIN Produto AS p ON iv.id_produto = p.id_produto
INNER JOIN Categoria AS c ON p.id_categoria = c.id_categoria
ORDER BY v.data_venda DESC;

SELECT nome_categoria
FROM Categoria
WHERE id_categoria IN (
SELECT DISTINCT id_categoria
FROM Produto
WHERE preco_venda > (SELECT AVG(preco_venda) FROM Produto)
);

