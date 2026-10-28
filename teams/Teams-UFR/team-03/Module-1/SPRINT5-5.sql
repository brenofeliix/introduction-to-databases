-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Gabriel Sakaizawa Campos
-- Tema: Sistema de gerenciamento de restaurante
-- Banco: db_restaurante_sabor


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================

CREATE DATABASE IF NOT EXISTS db_restaurante_sabor;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE db_restaurante_sabor;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

CREATE TABLE cliente (
    id_cliente     INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cpf            VARCHAR(11) NOT NULL UNIQUE,
    telefone       VARCHAR(15),
    data_cadastro  DATE NOT NULL
);

CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cargo          VARCHAR(50) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    ativo          BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE mesa (
    id_mesa     INT PRIMARY KEY AUTO_INCREMENT,
    numero      INT NOT NULL,
    capacidade  INT NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'livre'
);

CREATE TABLE produto (
    id_produto  INT PRIMARY KEY AUTO_INCREMENT,
    nome        VARCHAR(100) NOT NULL,
    categoria   VARCHAR(50) NOT NULL,
    preco       DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE pedido (
    id_pedido       INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente      INT NOT NULL,
    id_mesa         INT NOT NULL,
    id_funcionario  INT NOT NULL,
    data_pedido     DATE NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'aberto',

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),

    CONSTRAINT fk_pedido_mesa
        FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa),

    CONSTRAINT fk_pedido_funcionario
        FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

CREATE TABLE item_pedido (
    id_item_pedido  INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido       INT NOT NULL,
    id_produto      INT NOT NULL,
    quantidade      INT NOT NULL,
    preco_unitario  DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),

    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================

-- Campo adicional de observação do pedido (ex.: "sem cebola"),
-- identificado como necessário já durante a Sprint 2/5.
ALTER TABLE pedido
ADD COLUMN observacao VARCHAR(200);

-- Todas as demais restrições (PRIMARY KEY, FOREIGN KEY, NOT NULL,
-- UNIQUE, DEFAULT, AUTO_INCREMENT) já estão declaradas na criação
-- de cada tabela acima.


-- ============================================================
-- 5. INSERTS
-- ============================================================

INSERT INTO cliente (nome, cpf, telefone, data_cadastro)
VALUES
    ('Ana Souza',      '11122233344', '11988887777', '2026-08-20'),
    ('Carlos Lima',    '22233344455', '11977776666', '2026-08-21'),
    ('Mariana Silva',  '33344455566', '11966665555', '2026-08-22'),
    ('Pedro Santos',   '44455566677', '11955554444', '2026-08-25'),
    ('Juliana Costa',  '55566677788', '11944443333', '2026-08-28');

INSERT INTO funcionario (nome, cargo, email, ativo)
VALUES
    ('João Pereira',    'Garçom',     'joao.pereira@sabor.com',    TRUE),
    ('Marcos Almeida',  'Garçom',     'marcos.almeida@sabor.com',  TRUE),
    ('Fernanda Dias',   'Gerente',    'fernanda.dias@sabor.com',   TRUE),
    ('Rafael Nunes',    'Garçom',     'rafael.nunes@sabor.com',    TRUE),
    ('Patrícia Rocha',  'Atendente',  'patricia.rocha@sabor.com',  TRUE);

INSERT INTO mesa (numero, capacidade, status)
VALUES
    (1, 2, 'livre'),
    (2, 4, 'livre'),
    (3, 4, 'livre'),
    (4, 6, 'livre'),
    (5, 2, 'livre');

INSERT INTO produto (nome, categoria, preco)
VALUES
    ('Feijoada Completa', 'Prato principal', 45.90),
    ('Picanha na Chapa',  'Prato principal', 68.50),
    ('Refrigerante Lata', 'Bebida',           6.00),
    ('Suco Natural',      'Bebida',           8.50),
    ('Pudim de Leite',    'Sobremesa',       12.00);

INSERT INTO pedido (id_cliente, id_mesa, id_funcionario, data_pedido, status)
VALUES
    (1, 1, 1, '2026-09-01', 'aberto'),
    (2, 2, 2, '2026-09-01', 'aberto'),
    (1, 3, 1, '2026-09-02', 'aberto'),
    (3, 4, 4, '2026-09-02', 'aberto'),
    (4, 5, 5, '2026-09-03', 'aberto');

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
    (1, 1, 2, 45.90),   -- Pedido 1: 2x Feijoada
    (1, 3, 2, 6.00),    -- Pedido 1: 2x Refrigerante
    (2, 2, 1, 68.50),   -- Pedido 2: 1x Picanha
    (2, 4, 1, 8.50),    -- Pedido 2: 1x Suco Natural
    (3, 1, 1, 45.90),   -- Pedido 3: 1x Feijoada
    (3, 5, 1, 12.00),   -- Pedido 3: 1x Pudim
    (4, 2, 2, 68.50),   -- Pedido 4: 2x Picanha
    (4, 3, 2, 6.00),    -- Pedido 4: 2x Refrigerante
    (5, 4, 2, 8.50),    -- Pedido 5: 2x Suco Natural
    (5, 5, 1, 12.00),   -- Pedido 5: 1x Pudim
    (1, 5, 1, 12.00);   -- item inserido por engano no Pedido 1 (removido no DELETE abaixo)


-- ============================================================
-- 6. UPDATES
-- ============================================================

-- Atualiza telefone de um cliente
UPDATE cliente
SET telefone = '11999990000'
WHERE id_cliente = 2;

-- Marca uma mesa como ocupada
UPDATE mesa
SET status = 'ocupada'
WHERE id_mesa = 1;

-- Finaliza um pedido
UPDATE pedido
SET status = 'finalizado'
WHERE id_pedido = 1;


-- ============================================================
-- 7. DELETES
-- ============================================================

-- Remove item de pedido inserido por engano (Pudim duplicado no Pedido 1)
DELETE FROM item_pedido
WHERE id_item_pedido = 11;

-- Remove cliente sem nenhum pedido vinculado
DELETE FROM cliente
WHERE id_cliente = 5;


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================

-- Quais são todos os produtos cadastrados?
SELECT * FROM produto;

-- Quais são apenas os nomes e preços dos produtos?
SELECT nome, preco FROM produto;


-- ============================================================
-- 9. WHERE
-- ============================================================

-- Quais produtos são da categoria "Bebida"?
SELECT nome, preco
FROM produto
WHERE categoria = 'Bebida';

-- Quais pratos principais custam mais de R$ 50,00?
SELECT nome, categoria, preco
FROM produto
WHERE categoria = 'Prato principal'
  AND preco > 50;


-- ============================================================
-- 10. ORDER BY
-- ============================================================

-- Produtos do mais caro para o mais barato
SELECT nome, preco
FROM produto
ORDER BY preco DESC;


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- COUNT: pedidos atendidos por funcionário
SELECT f.nome AS funcionario, COUNT(p.id_pedido) AS total_pedidos
FROM funcionario f
LEFT JOIN pedido p ON p.id_funcionario = f.id_funcionario
GROUP BY f.id_funcionario, f.nome
ORDER BY total_pedidos DESC;

-- SUM: valor total de cada pedido
SELECT ip.id_pedido, SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM item_pedido ip
GROUP BY ip.id_pedido
ORDER BY ip.id_pedido;

-- AVG: preço médio por categoria
SELECT categoria, AVG(preco) AS preco_medio
FROM produto
GROUP BY categoria;

-- MIN / MAX: produto mais barato e mais caro
SELECT MIN(preco) AS produto_mais_barato,
       MAX(preco) AS produto_mais_caro
FROM produto;


-- ============================================================
-- 12. GROUP BY
-- ============================================================

-- Quantos pedidos existem em cada status?
SELECT status, COUNT(*) AS quantidade
FROM pedido
GROUP BY status;


-- ============================================================
-- 13. HAVING
-- ============================================================

-- Categorias com preço médio acima de R$ 10,00
SELECT categoria, AVG(preco) AS preco_medio
FROM produto
GROUP BY categoria
HAVING AVG(preco) > 10;


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================

-- Subtotal (quantidade x preço unitário) de cada item de pedido
SELECT id_item_pedido, id_pedido, quantidade, preco_unitario,
       quantidade * preco_unitario AS subtotal
FROM item_pedido
ORDER BY id_pedido;

-- Faturamento total do restaurante
SELECT SUM(quantidade * preco_unitario) AS faturamento_total
FROM item_pedido;


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================

-- Confirma que todas as 6 tabelas foram criadas
SHOW TABLES;

-- Confirma estrutura de cada tabela
DESCRIBE cliente;
DESCRIBE funcionario;
DESCRIBE mesa;
DESCRIBE produto;
DESCRIBE pedido;
DESCRIBE item_pedido;

-- Confirma chaves primárias, estrangeiras e demais restrições
SHOW CREATE TABLE pedido;
SHOW CREATE TABLE item_pedido;

-- Confirma estado final dos dados após INSERT/UPDATE/DELETE
SELECT * FROM cliente;
SELECT * FROM mesa;
SELECT * FROM pedido;
SELECT * FROM item_pedido;

-- Teste de integridade referencial (comentado — não deve ser executado
-- em produção, apenas usado para validar que a restrição funciona):
-- DELETE FROM cliente WHERE id_cliente = 1;
-- Resultado esperado: erro de FOREIGN KEY, pois o cliente 1 possui
-- pedidos vinculados (Pedido 1 e Pedido 3).
