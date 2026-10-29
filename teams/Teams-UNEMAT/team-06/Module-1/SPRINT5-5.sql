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

-- VERIFICAÇÕES

SELECT * FROM Venda;
SELECT * FROM Item_venda;
SELECT * FROM Produto;
-- UPDATES

UPDATE Produto
SET preco_venda = 12.50
WHERE id_produto = 1;

UPDATE Produto
SET preco_venda = 23.00
WHERE id_produto = 2;

UPDATE Produto
SET preco_venda = 1000000.00
WHERE id_produto = 4;

-- DELETES

DELETE FROM item_venda 
WHERE id_venda IN('1'); 

DELETE FROM item_venda 


SELECT nome_categoria
from Categoria;
WHERE id_venda IN('2');

SELECT nome_produto, preco_venda
from Produto
WHERE preco_venda > 15.00;

select nome_produto, preco_venda
from Produto
ORDER BY preco_venda ASC;

SELECT SUM(valot_total) AS total_produtos
from Produto;

SELECT COUNT(*) AS total_produtos
FROM Produto;

SELECT AVG(valor_total) AS ticke_medio
FROM Venda;

SELECT min(valor_total) as menor_venda,
	Max(valor_total) as maior_venda
	from Venda;

SELECT id_categoria, COUNT(*) AS quantidade_itens
from Produto
GROUP BY id_categoria;

SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;

SELECT nome_produto,
preco_venda,
Preco_venda * 0.90 AS preco_desconto
FROM Produto
WHERE preco_venda is not null;

SELECT nome_produto, preco_venda, quantidade_estoque
FROM Produto
WHERE preco_venda > 10.00
AND quantidade_estoque >= 50;


ALTER TABLE Produto
ADD COLUMN marca varchar(50);

SHOW TABLES;
DESCRIBE Categoria;
DESCRIBE Produto;
DESCRIBE Venda;
DESCRIBE Item_venda;
