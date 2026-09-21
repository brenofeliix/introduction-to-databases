-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Leslie bruna pires dos santos
-- Banco: bd_loja

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE bd_loja;

-- ============================================================
-- INSERTS — TABELA 1: Cliente (Independente)
-- ============================================================

-- Removidos os pontos e traços para não dar erro de limite de caracteres (Data too long)
INSERT INTO cliente (nome, cpf, telefone, email)
VALUES 
    ('Maria Silva', '11111111111', '11999991111', 'maria@email.com'),
    ('João Carlos', '22222222222', '11999992222', 'joao@email.com'),
    ('Ana Beatriz', '33333333333', '11999993333', 'ana@email.com'),
    ('Pedro Paulo', '44444444444', '11999994444', 'pedro@email.com'),
    ('Lucas Fernandes', '55555555555', '11999995555', 'lucas@email.com'),
    ('Cliente Para Excluir', '99999999999', '00000000000', 'excluir@email.com');

-- ============================================================
-- INSERTS — TABELA 2: Produto (Independente)
-- ============================================================

INSERT INTO produto (nome, preco, quantidade_estoque)
VALUES
    ('Camiseta Básica', 49.90, 100),
    ('Calça Jeans', 119.90, 50),
    ('Tênis Esportivo', 199.90, 30),
    ('Boné', 29.90, 40),
    ('Meia (Par)', 9.90, 200),
    ('Produto Teste Exclusao', 99.99, 5);

-- ============================================================
-- INSERTS — TABELA 3: Pedido (Depende de cliente)
-- ============================================================

INSERT INTO pedido (id_cliente, data_pedido, forma_pagamento)
VALUES
    (1, '2026-09-10 10:30:00', 'Pix'),
    (2, '2026-09-11 14:15:00', 'Cartão de Crédito'),
    (3, '2026-09-12 09:45:00', 'Dinheiro'),
    (4, '2026-09-13 16:20:00', 'Pix'),
    (1, '2026-09-14 11:00:00', 'Cartão de Débito');

-- ============================================================
-- INSERTS — TABELA 4: Item_Pedido (Depende de pedido e produto)
-- ============================================================

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
    (1, 1, 2, 49.90),  -- Pedido 1: 2 Camisetas
    (1, 4, 1, 29.90),  -- Pedido 1: 1 Boné
    (2, 2, 1, 119.90), -- Pedido 2: 1 Calça Jeans
    (3, 3, 1, 199.90), -- Pedido 3: 1 Tênis Esportivo
    (4, 5, 3, 9.90),   -- Pedido 4: 3 pares de meia
    (5, 1, 1, 49.90);  -- Pedido 5: 1 Camiseta

-- ============================================================
-- VERIFICAÇÕES (Antes das modificações)
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM produto;
SELECT * FROM pedido;
SELECT * FROM item_pedido;

-- ============================================================
-- UPDATES (Pelo menos 3 operações)
-- ============================================================

-- 1. Atualizando o telefone de contato de um cliente específico (sem parênteses e traços)
UPDATE cliente
SET telefone = '11988880000'
WHERE id_cliente = 2;

-- 2. Atualizando o preço de um produto 
UPDATE produto
SET preco = 59.90
WHERE id_produto = 1;

-- 3. Atualizando a forma de pagamento de um pedido feito por engano
UPDATE pedido
SET forma_pagamento = 'Cartão de Débito'
WHERE id_pedido = 3;

-- ============================================================
-- DELETES (Pelo menos 2 operações seguras, sem ferir a FK)
-- ============================================================

-- 1. Removendo um cliente que acabou de ser cadastrado e não possui pedidos (usando o CPF sem pontos)
DELETE FROM cliente
WHERE cpf = '99999999999';

-- 2. Removendo um produto que foi cadastrado errado e não está em nenhum pedido
DELETE FROM produto
WHERE nome = 'Produto Teste Exclusao';

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM produto;
SELECT * FROM pedido;