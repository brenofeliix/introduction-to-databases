-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 5/5 — INTEGRAÇÃO, VALIDAÇÃO E ENTREGA FINAL
-- ATIVIDADE INDIVIDUAL
-- ============================================================
-- ALUNO: NICOLAS LINO OLIVEIRA
-- TEMA DO BANCO: Gestão de Imobiliária (Corretores de Imóveis)
-- NOME DO BANCO: banco_imobiliaria
-- ============================================================

-- ============================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ============================================================

CREATE DATABASE IF NOT EXISTS banco_imobiliaria;

-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE banco_imobiliaria;

-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS INDEPENDENTES
-- ============================================================

CREATE TABLE corretores (
    id_corretor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    creci VARCHAR(20) NOT NULL UNIQUE,
    comissao_percentual DECIMAL(5, 2) NOT NULL
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    contato VARCHAR(100) NOT NULL,
    tipo_interesse VARCHAR(50),
    orcamento DECIMAL(12, 2)
);

CREATE TABLE imoveis (
    id_imovel INT PRIMARY KEY AUTO_INCREMENT,
    endereco VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    preco DECIMAL(12, 2) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'disponível'
);

-- ============================================================
-- 4. CRIAÇÃO DAS TABELAS RELACIONADAS
-- ============================================================

CREATE TABLE visitas (
    id_visita INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_imovel INT NOT NULL,
    data_visita DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'confirmada',
    CONSTRAINT fk_visitas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_visitas_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel)
);

CREATE TABLE propostas (
    id_proposta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_imovel INT NOT NULL,
    valor_proposto DECIMAL(12, 2) NOT NULL,
    data_proposta DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'em análise',
    CONSTRAINT fk_propostas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_propostas_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel)
);

CREATE TABLE contratos (
    id_contrato INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel INT NOT NULL,
    id_cliente INT NOT NULL,
    id_corretor INT NOT NULL,
    valor_final DECIMAL(12, 2) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    data_fechamento DATE NOT NULL,
    CONSTRAINT fk_contratos_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel),
    CONSTRAINT fk_contratos_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_contratos_corretores
        FOREIGN KEY (id_corretor) REFERENCES corretores(id_corretor)
);

-- ============================================================
-- 5. TABELA ASSOCIATIVA — HISTÓRICO DE GESTÃO (N:N)
-- ============================================================

CREATE TABLE gestoes (
    id_gestao INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel INT NOT NULL,
    id_corretor INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE DEFAULT NULL,
    CONSTRAINT fk_gestoes_imoveis
        FOREIGN KEY (id_imovel) REFERENCES imoveis(id_imovel),
    CONSTRAINT fk_gestoes_corretores
        FOREIGN KEY (id_corretor) REFERENCES corretores(id_corretor)
);

-- ============================================================
-- 6. ALTER TABLE
-- ============================================================

ALTER TABLE imoveis
ADD COLUMN observacoes TEXT;

-- ============================================================
-- 7. INSERTS — TABELAS INDEPENDENTES
-- ============================================================

INSERT INTO corretores (nome, creci, comissao_percentual)
VALUES
    ('Carlos Eduardo Ramos', 'CRECI-10293-MT', 6.00),
    ('Mariana Albuquerque', 'CRECI-20481-MT', 5.50),
    ('Roberto Silva Prado', 'CRECI-30192-MT', 5.00),
    ('Fernanda Souza Gomes', 'CRECI-40512-MT', 6.50),
    ('Juliano Mendes Santos', 'CRECI-50931-MT', 5.00);

INSERT INTO clientes (nome, contato, tipo_interesse, orcamento)
VALUES
    ('Lucas Henrique Ferreira', 'lucas.ferreira@email.com', 'compra', 450000.00),
    ('Beatriz Lima da Rocha', '(65) 99123-4567', 'aluguel', 3500.00),
    ('Guilherme Antunes', 'guilherme.antunes@email.com', 'compra', 800000.00),
    ('Camila Duarte Ramos', '(65) 98456-1122', 'compra', 600000.00),
    ('Thiago Peixoto', 'thiago.peixoto@email.com', 'aluguel', 2800.00),
    ('Larissa Montenegro', '(65) 99988-7766', 'compra', 320000.00);

INSERT INTO imoveis (endereco, tipo, preco, status, observacoes)
VALUES
    ('Av. do CPA, 1200 - Apto 302', 'apartamento', 420000.00, 'disponível', 'Sol da manhã, sacada gourmet e 2 vagas de garagem.'),
    ('Rua das Camélias, 45 - Bairro Jardim', 'casa', 780000.00, 'disponível', 'Casa térrea com piscina e churrasqueira.'),
    ('Rua Estevão de Mendonça, 500 - Sala 40', 'comercial', 2600.00, 'disponível', 'Sala comercial mobiliada para escritório.'),
    ('Av. Fernando Corrêa, 3500 - Apto 101', 'apartamento', 310000.00, 'disponível', 'Próximo à universidade, ideal para investimento.'),
    ('Rodovia Helder Cândia, Condomínio Solar', 'terreno', 350000.00, 'disponível', 'Lote de 450m² plano em condomínio fechado.'),
    ('Rua das Palmeiras, 88 - Bairro Quilombo', 'casa', 590000.00, 'disponível', 'Imóvel amplo, necessita de pequena reforma.');

-- ============================================================
-- 8. INSERTS — TABELAS RELACIONADAS E ASSOCIATIVAS
-- ============================================================

INSERT INTO gestoes (id_imovel, id_corretor, data_inicio, data_fim)
VALUES
    (1, 1, '2026-01-15', NULL),
    (2, 2, '2026-02-01', NULL),
    (3, 3, '2026-02-10', NULL),
    (4, 4, '2026-03-01', NULL),
    (5, 5, '2026-03-05', NULL),
    (6, 1, '2026-03-10', NULL);

INSERT INTO visitas (id_cliente, id_imovel, data_visita, status)
VALUES
    (1, 1, '2026-03-12', 'realizada'),
    (2, 3, '2026-03-14', 'realizada'),
    (3, 2, '2026-03-15', 'confirmada'),
    (4, 6, '2026-03-18', 'confirmada'),
    (5, 3, '2026-03-20', 'cancelada'),
    (6, 4, '2026-03-22', 'cancelada');

INSERT INTO propostas (id_cliente, id_imovel, valor_proposto, data_proposta, status)
VALUES
    (1, 1, 400000.00, '2026-03-13', 'aceita'),
    (2, 3, 2400.00, '2026-03-15', 'recusada'),
    (3, 2, 750000.00, '2026-03-16', 'em análise'),
    (4, 6, 560000.00, '2026-03-19', 'em análise'),
    (5, 3, 2200.00, '2026-03-21', 'recusada');

INSERT INTO contratos (id_imovel, id_cliente, id_corretor, valor_final, tipo, data_fechamento)
VALUES
    (1, 1, 1, 400000.00, 'venda', '2026-03-14');

-- ============================================================
-- 9. VERIFICAÇÃO INICIAL DOS DADOS
-- ============================================================

SELECT * FROM corretores;
SELECT * FROM clientes;
SELECT * FROM imoveis;
SELECT * FROM gestoes;
SELECT * FROM visitas;
SELECT * FROM propostas;
SELECT * FROM contratos;

-- ============================================================
-- 10. UPDATES
-- ============================================================

UPDATE clientes
SET orcamento = 480000.00
WHERE id_cliente = 1;

UPDATE imoveis
SET status = 'vendido'
WHERE id_imovel = 1;

UPDATE visitas
SET status = 'realizada'
WHERE id_visita = 3;

-- ============================================================
-- 11. DELETES
-- ============================================================

DELETE FROM visitas
WHERE id_visita = 6;

DELETE FROM propostas
WHERE id_proposta = 5;

-- ============================================================
-- 12. CONSULTAS BÁSICAS
-- ============================================================

SELECT *
FROM imoveis;

SELECT
    nome,
    contato,
    orcamento
FROM clientes;

-- ============================================================
-- 13. CONSULTAS COM WHERE
-- ============================================================

SELECT *
FROM imoveis
WHERE preco > 400000.00;

SELECT *
FROM imoveis
WHERE tipo = 'casa';

-- ============================================================
-- 14. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================

SELECT *
FROM imoveis
WHERE tipo = 'casa'
  AND status = 'disponível';

-- ============================================================
-- 15. ORDER BY
-- ============================================================

SELECT *
FROM imoveis
ORDER BY preco ASC;

SELECT *
FROM imoveis
ORDER BY preco DESC;

-- ============================================================
-- 16. COUNT
-- ============================================================

SELECT
    COUNT(*) AS total_clientes
FROM clientes;

-- ============================================================
-- 17. SUM
-- ============================================================

SELECT
    SUM(preco) AS valor_patrimonial_total
FROM imoveis;

-- ============================================================
-- 18. AVG
-- ============================================================

SELECT
    AVG(preco) AS preco_medio_imoveis
FROM imoveis;

-- ============================================================
-- 19. MIN E MAX
-- ============================================================

SELECT
    MIN(orcamento) AS menor_orcamento,
    MAX(orcamento) AS maior_orcamento
FROM clientes;

-- ============================================================
-- 20. GROUP BY
-- ============================================================

SELECT
    tipo,
    COUNT(*) AS quantidade_imoveis
FROM imoveis
GROUP BY tipo;

-- ============================================================
-- 21. HAVING
-- ============================================================

SELECT
    tipo,
    COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
HAVING COUNT(*) > 1;

-- ============================================================
-- 22. EXPRESSÃO SQL
-- ============================================================

SELECT
    id_imovel,
    endereco,
    preco,
    preco * 1.08 AS preco_reajustado_8pct
FROM imoveis;

-- ============================================================
-- 23. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
-- Pergunta: Quais imóveis à venda continuam disponíveis e com valor até R$ 500.000,00?

SELECT
    id_imovel,
    endereco,
    tipo,
    preco,
    observacoes
FROM imoveis
WHERE status = 'disponível'
  AND preco <= 500000.00
ORDER BY preco ASC;

-- ============================================================
-- 24. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
-- Pergunta: Qual o total de propostas e ticket médio filtrando ofertas acima de R$ 10.000 agrupadas por status?

SELECT
    status,
    COUNT(*) AS total_propostas,
    AVG(valor_proposto) AS ticket_medio,
    MIN(valor_proposto) AS menor_oferta,
    MAX(valor_proposto) AS maior_oferta
FROM propostas
WHERE valor_proposto > 10000.00
GROUP BY status
HAVING COUNT(*) >= 1
ORDER BY ticket_medio DESC;

-- ============================================================
-- 25. VALIDAÇÃO — SHOW TABLES
-- ============================================================

SHOW TABLES;

-- ============================================================
-- 26. VALIDAÇÃO — DESCRIBE
-- ============================================================

DESCRIBE corretores;
DESCRIBE clientes;
DESCRIBE imoveis;
DESCRIBE gestoes;
DESCRIBE visitas;
DESCRIBE propostas;
DESCRIBE contratos;

-- ============================================================
-- 27. VALIDAÇÃO — SHOW CREATE TABLE
-- ============================================================

SHOW CREATE TABLE corretores;
SHOW CREATE TABLE clientes;
SHOW CREATE TABLE imoveis;
SHOW CREATE TABLE gestoes;
SHOW CREATE TABLE visitas;
SHOW CREATE TABLE propostas;
SHOW CREATE TABLE contratos;

-- ============================================================
-- 28. TESTES DE INTEGRIDADE — DEIXAR COMENTADOS
-- ============================================================
--
-- Teste UNIQUE:
-- INSERT INTO corretores (nome, creci, comissao_percentual)
-- VALUES ('Corretor Repetido', 'CRECI-10293-MT', 5.00);
--
-- Teste NOT NULL:
-- INSERT INTO imoveis (endereco, tipo, preco)
-- VALUES ('Endereço Teste', 'casa', NULL);
--
-- Teste FOREIGN KEY:
-- INSERT INTO visitas (id_cliente, id_imovel, data_visita)
-- VALUES (99999, 1, '2026-03-30');
--

-- ============================================================
-- 29. CONSULTAS FINAIS DE CONFERÊNCIA
-- ============================================================

SELECT * FROM corretores;
SELECT * FROM clientes;
SELECT * FROM imoveis;
SELECT * FROM gestoes;
SELECT * FROM visitas;
SELECT * FROM propostas;
SELECT * FROM contratos;

-- ============================================================
-- FIM DA SPRINT 5/5
-- ============================================================