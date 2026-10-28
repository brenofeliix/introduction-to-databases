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
('Cobras');

INSERT INTO Produto(id_categoria, codigo_barras, nome_produto, quantidade_estoque) VALUES 
(1, '102324232323', 'Pão Frito', 50),
(2, '102324232324', 'Almoço velho', 50),
(3, '142324232325', 'Doces e Legumes', 50),
(4, '102324232326', 'Simplesmente a mulher mais linda do Mundo', 1);

INSERT INTO Venda(valor_total) VALUES
(15.00),
(13.00),
(12.00),
(03.00),
(07.00),
(23.00),
(08.00);

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
    
