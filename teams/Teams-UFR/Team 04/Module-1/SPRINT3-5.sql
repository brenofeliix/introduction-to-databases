
USE mercado;

-- ============================================================
-- INSERTS — CLIENTE
-- ============================================================

INSERT INTO cliente (nome, cpf, telefone, data_cadastro)
VALUES
    ('Ana Souza',     '11122233344', '11988887777', '2026-08-20'),
    ('Carlos Lima',   '22233344455', '11977776666', '2026-08-21'),
    ('Mariana Silva', '33344455566', '11966665555', '2026-08-22'),
    ('Pedro Santos',  '44455566677', '11955554444', '2026-08-25'),
    ('Juliana Costa', '55566677788', '11944443333', '2026-08-28');

-- ============================================================
-- INSERTS — FUNCIONARIO
-- ============================================================

INSERT INTO funcionario (nome, cargo, email, ativo)
VALUES
    ('João Pereira',   'Caixa',      'joao.pereira@mercado.com', TRUE),
    ('Marcos Almeida', 'Repositor',  'marcos.almeida@mercado.com', TRUE),
    ('Fernanda Dias',  'Gerente',    'fernanda.dias@mercado.com', TRUE),
    ('Rafael Nunes',   'Estoquista', 'rafael.nunes@mercado.com', TRUE),
    ('Patrícia Rocha', 'Atendente',  'patricia.rocha@mercado.com', TRUE);

-- ============================================================
-- INSERTS — PRODUTO
-- ============================================================

INSERT INTO produto (nome, categoria, preco)
VALUES
    ('Arroz 5kg',       'Alimentos',  28.90),
    ('Feijão 1kg',      'Alimentos',   8.50),
    ('Leite Integral',  'Laticínios',  5.50),
    ('Refrigerante 2L', 'Bebidas',     9.00),
    ('Sabão em Pó',     'Limpeza',    14.00);

-- ============================================================
-- VERIFICAÇÕES
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM produto;

-- ============================================================
-- INSERTS — VENDA
-- ============================================================

INSERT INTO venda (id_cliente, id_funcionario, data_venda, status)
VALUES
    (1, 1, '2026-09-01', 'aberta'),
    (2, 1, '2026-09-01', 'aberta'),
    (1, 1, '2026-09-02', 'aberta'),
    (3, 5, '2026-09-02', 'aberta'),
    (4, 1, '2026-09-03', 'aberta');

-- ============================================================
-- INSERTS — ITEM_VENDA
-- ============================================================

INSERT INTO item_venda (id_venda, id_produto, quantidade, preco_unitario)
VALUES
    (1, 1, 2, 28.90),  -- Venda 1: 2x Arroz
    (1, 3, 2, 5.50),   -- Venda 1: 2x Leite
    (2, 2, 1, 8.50),   -- Venda 2: 1x Feijão
    (2, 4, 1, 9.00),   -- Venda 2: 1x Refrigerante
    (3, 1, 1, 28.90),  -- Venda 3: 1x Arroz
    (3, 5, 1, 14.00),  -- Venda 3: 1x Sabão em Pó
    (4, 2, 2, 8.50),   -- Venda 4: 2x Feijão
    (4, 3, 2, 5.50),   -- Venda 4: 2x Leite
    (5, 4, 2, 9.00),   -- Venda 
