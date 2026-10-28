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