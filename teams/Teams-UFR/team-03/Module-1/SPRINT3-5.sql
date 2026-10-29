-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_restaurante_sabor

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE db_restaurante_sabor;

-- ============================================================
-- INSERTS — CLIENTE
-- ============================================================

INSERT INTO cliente (nome, cpf, telefone, data_cadastro)
VALUES
    ('Ana Souza',      '11122233344', '11988887777', '2026-08-20'),
    ('Carlos Lima',    '22233344455', '11977776666', '2026-08-21'),
    ('Mariana Silva',  '33344455566', '11966665555', '2026-08-22'),
    ('Pedro Santos',   '44455566677', '11955554444', '2026-08-25'),
    ('Juliana Costa',  '55566677788', '11944443333', '2026-08-28');

-- ============================================================
-- INSERTS — FUNCIONARIO
-- ============================================================

INSERT INTO funcionario (nome, cargo, email, ativo)
VALUES
    ('João Pereira',    'Garçom',     'joao.pereira@sabor.com',    TRUE),
    ('Marcos Almeida',  'Garçom',     'marcos.almeida@sabor.com',  TRUE),
    ('Fernanda Dias',   'Gerente',    'fernanda.dias@sabor.com',   TRUE),
    ('Rafael Nunes',    'Garçom',     'rafael.nunes@sabor.com',    TRUE),
    ('Patrícia Rocha',  'Atendente',  'patricia.rocha@sabor.com',  TRUE);

-- ============================================================
-- INSERTS — MESA
-- ============================================================

INSERT INTO mesa (numero, capacidade, status)
VALUES
    (1, 2, 'livre'),
    (2, 4, 'livre'),
    (3, 4, 'livre'),
    (4, 6, 'livre'),
    (5, 2, 'livre');

-- ============================================================
-- INSERTS — PRODUTO
-- ============================================================

INSERT INTO produto (nome, categoria, preco)
VALUES
    ('Feijoada Completa', 'Prato principal', 45.90),
    ('Picanha na Chapa',  'Prato principal', 68.50),
    ('Refrigerante Lata', 'Bebida',           6.00),
    ('Suco Natural',      'Bebida',           8.50),
    ('Pudim de Leite',    'Sobremesa',       12.00);

-- ============================================================
-- VERIFICAÇÕES
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM mesa;
SELECT * FROM produto;

-- ============================================================
-- INSERTS — PEDIDO (dependem de cliente, mesa e funcionario)
-- ============================================================

INSERT INTO pedido (id_cliente, id_mesa, id_funcionario, data_pedido, status)
VALUES
    (1, 1, 1, '2026-09-01', 'aberto'),
    (2, 2, 2, '2026-09-01', 'aberto'),
    (1, 3, 1, '2026-09-02', 'aberto'),
    (3, 4, 4, '2026-09-02', 'aberto'),
    (4, 5, 5, '2026-09-03', 'aberto');

-- ============================================================
-- INSERTS — ITEM_PEDIDO (dependem de pedido e produto)
-- ============================================================

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
    (1, 5, 1, 12.00);   -- item inserido por engano no Pedido 1 (será removido no DELETE 1)

-- ============================================================
-- VERIFICAÇÕES
-- ============================================================

SELECT * FROM pedido;
SELECT * FROM item_pedido;

-- ============================================================
-- TESTE DE RESTRIÇÕES DE INTEGRIDADE (não altera dados)
-- ============================================================

-- Teste 1: CPF duplicado deve falhar (cliente.cpf é UNIQUE)
-- INSERT INTO cliente (nome, cpf, telefone, data_cadastro)
-- VALUES ('Cliente Teste', '11122233344', '11900000000', '2026-09-05');
-- Resultado esperado: Duplicate entry '11122233344' for key 'cpf'

-- Teste 2: excluir um cliente referenciado por pedido deve falhar
-- DELETE FROM cliente WHERE id_cliente = 1;
-- Resultado esperado: Cannot delete or update a parent row: a foreign key
-- constraint fails (cliente id_cliente = 1 é usado nos pedidos 1 e 3)

-- ============================================================
-- UPDATES
-- ============================================================

-- UPDATE 1: atualizar telefone de um cliente
UPDATE cliente
SET telefone = '11999990000'
WHERE id_cliente = 2;

-- UPDATE 2: marcar uma mesa como ocupada
UPDATE mesa
SET status = 'ocupada'
WHERE id_mesa = 1;

-- UPDATE 3: finalizar um pedido
UPDATE pedido
SET status = 'finalizado'
WHERE id_pedido = 1;

-- ============================================================
-- DELETES
-- ============================================================

-- DELETE 1: remover item de pedido inserido por engano
-- (id_item_pedido = 11, último item inserido: Pudim no Pedido 1, duplicado por engano)
DELETE FROM item_pedido
WHERE id_item_pedido = 11;

-- DELETE 2: remover cliente que não possui nenhum pedido vinculado
DELETE FROM cliente
WHERE id_cliente = 5;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM mesa;
SELECT * FROM pedido;
SELECT * FROM item_pedido;
