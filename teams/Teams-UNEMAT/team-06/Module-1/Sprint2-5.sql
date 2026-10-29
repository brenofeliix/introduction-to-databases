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


