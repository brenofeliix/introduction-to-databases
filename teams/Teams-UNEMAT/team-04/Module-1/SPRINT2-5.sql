DROP DATABASE IF EXISTS Rh_sorveteria;

CREATE DATABASE Rh_sorveteria;

USE Rh_sorveteria;

CREATE TABLE FILIAL (
	id_filial int AUTO_INCREMENT PRIMARY KEY,
	Modulo varchar(20) NOT NULL,
	Localizacao varchar(100) NOT NULL,
    data_abertura DATE NOT NULL
);

CREATE TABLE CARGO (
	id_cargo int AUTO_INCREMENT PRIMARY KEY,
	nome_cargo Varchar(50) NOT NULL,
	salario_base DECIMAL(10,2) NOT NULL,
	carga_horaria int NOT NULL
);

CREATE TABLE PRODUTO (
	id_produto int AUTO_INCREMENT PRIMARY KEY,
	nome_produto varchar(50) NOT NULL
);

CREATE TABLE SETOR (
	id_setor int AUTO_INCREMENT PRIMARY KEY,
    nome_setor varchar(50) NOT NULL
);

CREATE TABLE FUNCIONARIO (
    id_func int AUTO_INCREMENT PRIMARY KEY,
    nome_func Varchar(100) NOT NULL,
	cpf Varchar(11) NOT NULL UNIQUE,
	data_nascimento DATE NOT NULL,
	data_admissao DATE NOT NULL,
    
    id_cargo int NOT NULL,
    id_setor int NOT NULL,
    id_filial int NOT NULL,
    
    FOREIGN KEY (id_cargo)
        REFERENCES CARGO(id_cargo),
	FOREIGN KEY (id_setor)
		REFERENCES SETOR(id_setor),
	FOREIGN KEY (id_filial)
		REFERENCES FILIAL(id_filial)
);

CREATE TABLE EXPEDIENTE (
	id_expediente int AUTO_INCREMENT PRIMARY KEY,
	data_batimento DATE NOT NULL,
	hora_entrada TIME NOT NULL,
	hora_saida TIME NOT NULL,
	hora_extra VARCHAR(10) default 0,
	justificativas varchar(200),
    
    id_func INT NOT NULL,

    FOREIGN KEY (id_func)
        REFERENCES FUNCIONARIO(id_func)
);

CREATE TABLE ESTOQUE (
	quantidade int NOT NULL,
    
    id_filial int NOT NULL,
	id_produto int NOT NULL,
    
    CONSTRAINT fk_estoque_filial
        FOREIGN KEY (id_filial)
        REFERENCES FILIAL(id_filial),

    CONSTRAINT fk_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES PRODUTO(id_produto),
	PRIMARY KEY (id_filial, id_produto)
);

ALTER TABLE FUNCIONARIO
rename column cpf to cpf_func;

CREATE TABLE tabela_teste (
    id INT PRIMARY KEY
);

DROP TABLE tabela_teste;

describe ESTOQUE;
SHOW CREATE TABLE EXPEDIENTE;