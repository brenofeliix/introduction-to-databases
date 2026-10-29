-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 5/5 — INTEGRAÇÃO, VALIDAÇÃO E ENTREGA FINAL
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Vinícius Eduardo Lima de Assis
-- TEMA DO BANCO: Viagens
-- NOME DO BANCO: pacote_viagens
--
-- INSTRUÇÕES IMPORTANTES:
-- Script adaptado, integrado e totalmente testado para o banco
-- de dados de pacotes de viagens.
-- ============================================================


-- ============================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ============================================================

CREATE DATABASE IF NOT EXISTS pacote_viagens;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE pacote_viagens;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS INDEPENDENTES
-- ============================================================

CREATE TABLE destino (
    id_destino INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    pais VARCHAR(60) NOT NULL,
    estado VARCHAR(60),
    descricao TEXT
);

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE transporte (
    id_transporte INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL,
    empresa VARCHAR(100) NOT NULL,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL
);


-- ============================================================
-- 4. CRIAÇÃO DAS TABELAS RELACIONADAS
-- ============================================================

CREATE TABLE hospedagem (
    id_hospedagem INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,
    id_destino INT NOT NULL,

    CONSTRAINT fk_hospedagem_destino
        FOREIGN KEY (id_destino)
        REFERENCES destino(id_destino)
);


-- ============================================================
-- 5. TABELA ASSOCIATIVA — EXEMPLO N:N
-- ============================================================

CREATE TABLE reserva_pacote (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_hospedagem INT NOT NULL,
    id_transporte INT NOT NULL,
    data_reserva DATE NOT NULL,
    quantidade_pessoas INT NOT NULL DEFAULT 1,

    CONSTRAINT fk_reserva_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_reserva_hospedagem
        FOREIGN KEY (id_hospedagem)
        REFERENCES hospedagem(id_hospedagem),
        
    CONSTRAINT fk_reserva_transporte
        FOREIGN KEY (id_transporte)
        REFERENCES transporte(id_transporte)
);


-- ============================================================
-- 6. OUTRAS TABELAS DO PROJETO
-- ============================================================
-- Todas as tabelas necessárias foram implementadas nas seções 3, 4 e 5.


-- ============================================================
-- 7. ALTER TABLE
-- ============================================================

-- Adição de campo estrutural para controle de status ativo do cliente
-- (Executado via DDL no CREATE TABLE, demonstrado como registro estrutural):
-- ALTER TABLE cliente ADD COLUMN ativo BOOLEAN NOT NULL DEFAULT TRUE;


-- ============================================================
-- 8. INSERTS — TABELAS INDEPENDENTES
-- ============================================================

INSERT INTO destino (nome, pais, estado, descricao)
VALUES
    ('Fernando de Noronha', 'Brasil', 'Pernambuco', 'Arquipélago vulcânico com praias paradisíacas e vida marinha abundante.'),
    ('Gramado', 'Brasil', 'Rio Grande do Sul', 'Cidade turística na Serra Gaúcha famosa pela arquitetura e gastronomia.'),
    ('Salvador', 'Brasil', 'Bahia', 'Capital baiana reconhecida pelo centro histórico do Pelourinho e cultura rica.'),
    ('Foz do Iguaçu', 'Brasil', 'Paraná', 'Famosa pelas Cataratas do Iguaçu e Parque das Aves.'),
    ('Rio de Janeiro', 'Brasil', 'Rio de Janeiro', 'Conhecida pelas praias de Copacabana e Ipanema e a estátua do Cristo Redentor.');

INSERT INTO cliente (nome, cpf, email, telefone, ativo)
VALUES
    ('Carlos Silva', '123.456.789-01', 'carlos.silva@email.com', '(11) 98765-4321', TRUE),
    ('Mariana Oliveira', '234.567.890-12', 'mariana.oliveira@email.com', '(21) 97654-3210', TRUE),
    ('Roberto Santos', '345.678.901-23', 'roberto.santos@email.com', '(31) 96543-2109', TRUE),
    ('Ana Souza', '456.789.012-34', 'ana.souza@email.com', '(41) 95432-1098', TRUE),
    ('Beatriz Lima', '567.890.123-45', 'beatriz.lima@email.com', '(51) 94321-0987', TRUE);

INSERT INTO transporte (tipo, empresa, origem, destino)
VALUES
    ('Aéreo', 'LATAM', 'São Paulo (GRU)', 'Fernando de Noronha (FEN)'),
    ('Aéreo', 'Gol', 'Rio de Janeiro (GIG)', 'Porto Alegre (POA)'),
    ('Rodoviário', 'Viação Cometa', 'São Paulo (Tietê)', 'Curitiba (TRM)'),
    ('Aéreo', 'Azul', 'Belo Horizonte (CNF)', 'Salvador (SSA)'),
    ('Rodoviário', 'Catarinense', 'Florianópolis', 'Foz do Iguaçu');


-- ============================================================
-- 9. INSERTS — TABELAS RELACIONADAS
-- ============================================================

INSERT INTO hospedagem (nome, endereco, tipo, valor_diaria, id_destino)
VALUES
    ('Pousada Zé Maria', 'Rua Maj. José Vicente, 100', 'Pousada', 1200.00, 1),
    ('Hotel Colline de France', 'Rua Nilo Peçanha, 79', 'Hotel Resort', 950.00, 2),
    ('Fera Palace Hotel', 'Rua da Chile, 20', 'Hotel', 650.00, 3),
    ('Belmond Hotel das Cataratas', 'Rodovia BR-469, Km 28', 'Hotel Luxo', 1800.00, 4),
    ('Copacabana Palace', 'Av. Atlântica, 1702', 'Hotel Luxo', 2200.00, 5);


-- ============================================================
-- 10. INSERTS — TABELA ASSOCIATIVA
-- ============================================================

INSERT INTO reserva_pacote (id_cliente, id_hospedagem, id_transporte, data_reserva, quantidade_pessoas)
VALUES
    (1, 1, 1, '2026-09-02', 2),
    (2, 2, 2, '2026-09-03', 1),
    (3, 3, 4, '2026-09-04', 4),
    (4, 4, 5, '2026-09-05', 2),
    (5, 5, 1, '2026-09-06', 3);


-- ============================================================
-- 11. VERIFICAÇÃO INICIAL DOS DADOS
-- ============================================================

SELECT * FROM destino;
SELECT * FROM cliente;
SELECT * FROM transporte;
SELECT * FROM hospedagem;
SELECT * FROM reserva_pacote;


-- ============================================================
-- 12. UPDATES
-- ============================================================

UPDATE cliente
SET telefone = '(11) 99999-8888'
WHERE id_cliente = 1;

UPDATE hospedagem
SET valor_diaria = 1050.00
WHERE id_hospedagem = 2;

UPDATE reserva_pacote
SET quantidade_pessoas = 5
WHERE id_reserva = 3;


-- ============================================================
-- 13. DELETES
-- ============================================================

DELETE FROM reserva_pacote
WHERE id_reserva = 5;

DELETE FROM cliente
WHERE id_cliente = 5;


-- ============================================================
-- 14. CONSULTAS BÁSICAS
-- ============================================================

SELECT *
FROM destino;

SELECT
    nome,
    email,
    telefone
FROM cliente;


-- ============================================================
-- 15. CONSULTAS COM WHERE
-- ============================================================

SELECT *
FROM cliente
WHERE ativo = TRUE;

SELECT *
FROM hospedagem
WHERE valor_diaria > 1000.00;


-- ============================================================
-- 16. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================

SELECT *
FROM transporte
WHERE tipo = 'Aéreo'
  AND (empresa = 'LATAM' OR empresa = 'Azul');


-- ============================================================
-- 17. ORDER BY
-- ============================================================

SELECT *
FROM destino
ORDER BY nome ASC;

SELECT *
FROM hospedagem
ORDER BY valor_diaria DESC;


-- ============================================================
-- 18. COUNT
-- ============================================================

SELECT
    COUNT(*) AS total_registros_cliente
FROM cliente;


-- ============================================================
-- 19. SUM
-- ============================================================

SELECT
    SUM(quantidade_pessoas) AS soma_pessoas_atendidas
FROM reserva_pacote;


-- ============================================================
-- 20. AVG
-- ============================================================

SELECT
    AVG(valor_diaria) AS media_diaria_hospedagem
FROM hospedagem;


-- ============================================================
-- 21. MIN E MAX
-- ============================================================

SELECT
    MIN(valor_diaria) AS menor_diaria,
    MAX(valor_diaria) AS maior_diaria
FROM hospedagem;


-- ============================================================
-- 22. GROUP BY
-- ============================================================

SELECT
    tipo,
    COUNT(*) AS quantidade_transportes
FROM transporte
GROUP BY tipo;


-- ============================================================
-- 23. HAVING
-- ============================================================

SELECT
    tipo,
    COUNT(*) AS quantidade
FROM transporte
GROUP BY tipo
HAVING COUNT(*) > 1;


-- ============================================================
-- 24. EXPRESSÃO SQL
-- ============================================================

SELECT
    nome,
    valor_diaria,
    valor_diaria * 1.10 AS valor_com_taxa_servico
FROM hospedagem;


-- ============================================================
-- 25. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Quais são todas as hospedagens cadastradas e seus respectivos valores organizados do mais caro para o mais barato?
--

SELECT nome, tipo, valor_diaria 
FROM hospedagem 
ORDER BY valor_diaria DESC;


-- ============================================================
-- 26. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Qual é a média da diária por tipo de hospedagem (considerando apenas diárias acima de R$ 500), mantendo apenas tipos com média superior a R$ 1.000?
--

SELECT tipo, AVG(valor_diaria) AS media 
FROM hospedagem 
WHERE valor_diaria > 500.00 
GROUP BY tipo 
HAVING AVG(valor_diaria) > 1000.00;


-- ============================================================
-- 27. VALIDAÇÃO — SHOW TABLES
-- ============================================================

SHOW TABLES;


-- ============================================================
-- 28. VALIDAÇÃO — DESCRIBE
-- ============================================================

DESCRIBE destino;
DESCRIBE cliente;
DESCRIBE transporte;
DESCRIBE hospedagem;
DESCRIBE reserva_pacote;


-- ============================================================
-- 29. VALIDAÇÃO — SHOW CREATE TABLE
-- ============================================================

SHOW CREATE TABLE destino;
SHOW CREATE TABLE cliente;
SHOW CREATE TABLE transporte;
SHOW CREATE TABLE hospedagem;
SHOW CREATE TABLE reserva_pacote;


-- ============================================================
-- 30. TESTES DE INTEGRIDADE — DEIXAR COMENTADOS
-- ============================================================
--
-- Teste UNIQUE:
-- INSERT INTO cliente (nome, cpf, email) VALUES ('Duplicado', '123.456.789-01', 'dup@email.com');
--
-- Teste NOT NULL:
-- INSERT INTO hospedagem (nome, endereco, tipo, valor_diaria, id_destino) VALUES ('Hotel Sem Preço', 'Rua A', 'Hotel', NULL, 1);
--
-- Teste FOREIGN KEY:
-- INSERT INTO hospedagem (nome, endereco, tipo, valor_diaria, id_destino) VALUES ('Hotel Fantasma', 'Rua B', 'Hotel', 500.00, 9999);


-- ============================================================
-- 31. CONSULTAS FINAIS DE CONFERÊNCIA
-- ============================================================

SELECT * FROM destino;
SELECT * FROM cliente;
SELECT * FROM transporte;
SELECT * FROM hospedagem;
SELECT * FROM reserva_pacote;


-- ============================================================
-- 32. CHECKLIST FINAL
-- ============================================================
--
-- [x] Substituí nome_do_banco.
-- [x] Substituí tabelas e campos genéricos pelos reais.
-- [x] O CREATE DATABASE está correto.
-- [x] O USE está correto.
-- [x] Todas as tabelas são criadas.
-- [x] Todas as PRIMARY KEY estão corretas.
-- [x] Todas as FOREIGN KEY estão corretas.
-- [x] NOT NULL, UNIQUE e DEFAULT estão coerentes.
-- [x] INSERTs executam corretamente.
-- [x] UPDATEs e DELETEs possuem WHERE.
-- [x] SELECT, WHERE, ORDER BY, COUNT, SUM, AVG, MIN/MAX funcionam.
-- [x] GROUP BY e HAVING funcionam.
-- [x] Testei SHOW TABLES, DESCRIBE e SHOW CREATE TABLE.
-- [x] O script executa do início ao fim.
-- [x] Salvei como SPRINT5-5.sql.
--
-- ============================================================
-- FIM DA SPRINT 5/5
-- ============================================================