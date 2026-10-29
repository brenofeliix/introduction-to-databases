-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: João Guilherme Barros de Lima
-- Tema: Site de anúncios imobiliários
-- Banco: real_estate_database


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================

CREATE DATABASE IF NOT EXISTS real_estate_database;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE real_estate_database;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

CREATE TABLE corretor (
    id_corretor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    creci VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    data_nascimento DATE
);

CREATE TABLE imovel (
    id_imovel INT PRIMARY KEY AUTO_INCREMENT,
    id_corretor INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quantidade_comodos INT NOT NULL,
    cidade VARCHAR(100) NOT NULL,

    CONSTRAINT fk_imovel_corretor
        FOREIGN KEY (id_corretor)
        REFERENCES corretor(id_corretor)
);

CREATE TABLE agendamento (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_imovel INT NOT NULL,
    data_visita DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente',

    CONSTRAINT fk_agendamento_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_agendamento_imovel
        FOREIGN KEY (id_imovel)
        REFERENCES imovel(id_imovel)
);


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================

-- As restrições PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL e
-- DEFAULT já foram declaradas junto com a criação das tabelas
-- na seção anterior. Comandos de verificação:

DESCRIBE corretor;
DESCRIBE cliente;
DESCRIBE imovel;
DESCRIBE agendamento;

SHOW CREATE TABLE corretor;
SHOW CREATE TABLE cliente;
SHOW CREATE TABLE imovel;
SHOW CREATE TABLE agendamento;


-- ============================================================
-- 5. INSERTS
-- ============================================================

INSERT INTO corretor (nome, creci, email, telefone)
VALUES
    ('Paulo Roberto de Lima Junior', 'CRECI111', 'paulo@imob.com', '66999991111'),
    ('Isa', 'CRECI222', 'isa@imob.com', '66999992222'),
    ('Jao', 'CRECI333', 'jao@imob.com', '66999993333'),
    ('Amanda', 'CRECI444', 'amanda@imob.com', '66999994444'),
    ('Theus', 'CRECI555', 'theus@imob.com', '66999995555');

INSERT INTO cliente (nome, email, senha, telefone, data_nascimento)
VALUES
    ('João Guilherme Barros de Lima', 'joao@email.com', 'senha123', '66988881111', '2006-11-29'),
    ('Gi', 'gi@email.com', 'senha456', '66988882222', '2005-05-15'),
    ('Carlos Santos', 'carlos@email.com', 'senha789', '66988883333', '1990-08-20'),
    ('Mariana Silva', 'mariana@email.com', 'senha321', '66988884444', '1995-12-10'),
    ('Lucas Almeida', 'lucas@email.com', 'senha654', '66988885555', '1988-03-30');

INSERT INTO imovel (id_corretor, titulo, valor, quantidade_comodos, cidade)
VALUES
    (1, 'Casa com piscina', 450000.00, 4, 'Rondonópolis'),
    (2, 'Apartamento Centro', 250000.00, 3, 'Rondonópolis'),
    (3, 'Chácara para descanso', 600000.00, 5, 'Chapada dos Guimarães'),
    (4, 'Casa na praia', 800000.00, 4, 'Alagoas'),
    (1, 'Terreno amplo', 150000.00, 0, 'Rondônia'),
    (5, 'Cobertura Duplex', 950000.00, 6, 'Rondonópolis');

INSERT INTO agendamento (id_cliente, id_imovel, data_visita, status)
VALUES
    (1, 4, '2026-10-15 10:00:00', 'Pendente'),
    (2, 3, '2026-10-16 14:30:00', 'Pendente'),
    (1, 3, '2026-10-17 09:00:00', 'Pendente'),
    (3, 2, '2026-10-18 11:00:00', 'Pendente'),
    (4, 5, '2026-10-19 15:00:00', 'Cancelado'),
    (5, 1, '2026-10-20 16:00:00', 'Pendente');


-- ============================================================
-- 6. UPDATES
-- ============================================================

UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 1;
UPDATE imovel SET valor = 240000.00 WHERE id_imovel = 2;
UPDATE cliente SET telefone = '66000000000' WHERE id_cliente = 3;


-- ============================================================
-- 7. DELETES
-- ============================================================

DELETE FROM agendamento WHERE id_agendamento = 5;
DELETE FROM imovel WHERE id_imovel = 6;


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================

SELECT * FROM imovel;
SELECT titulo, valor FROM imovel;


-- ============================================================
-- 9. WHERE
-- ============================================================

SELECT titulo, valor, cidade
FROM imovel
WHERE cidade = 'Rondonópolis';

SELECT *
FROM agendamento
WHERE status = 'Pendente'
  AND data_visita > '2026-10-16';


-- ============================================================
-- 10. ORDER BY
-- ============================================================

SELECT titulo, valor, cidade
FROM imovel
WHERE valor < 300000.00
ORDER BY valor ASC;


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

SELECT COUNT(*) AS agendamentos_pendentes
FROM agendamento
WHERE status = 'Pendente';

SELECT SUM(valor) AS soma_total_imoveis
FROM imovel;

SELECT AVG(valor) AS media_precos
FROM imovel;

SELECT MIN(valor) AS imovel_mais_barato,
       MAX(valor) AS imovel_mais_caro
FROM imovel;


-- ============================================================
-- 12. GROUP BY
-- ============================================================

SELECT cidade, COUNT(*) AS total_por_cidade
FROM imovel
GROUP BY cidade;


-- ============================================================
-- 13. HAVING
-- ============================================================

SELECT id_cliente, COUNT(*) AS quantidade_visitas
FROM agendamento
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================

SELECT titulo,
       valor,
       valor * 0.05 AS comissao_corretor
FROM imovel;


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================

SHOW TABLES;

SELECT * FROM corretor;
SELECT * FROM cliente;
SELECT * FROM imovel;
SELECT * FROM agendamento;
