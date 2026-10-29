-- ============================================================
-- SPRINT 3/5 — DML (Manipulação de Dados)
-- ALUNO: João Guilherme Barros de Lima
-- BANCO: real_estate_database
-- ============================================================

USE real_estate_database;

-- ============================================================
-- INSERTS — TABELA 1 (corretor)
-- ============================================================
INSERT INTO corretor (nome, creci, email, telefone)
VALUES
    ('Paulo Roberto de Lima Junior', 'CRECI111', 'paulo@imob.com', '66999991111'),
    ('Isa', 'CRECI222', 'isa@imob.com', '66999992222'),
    ('Jao', 'CRECI333', 'jao@imob.com', '66999993333'),
    ('Amanda', 'CRECI444', 'amanda@imob.com', '66999994444'),
    ('Theus', 'CRECI555', 'theus@imob.com', '66999995555');

-- ============================================================
-- INSERTS — TABELA 2 (cliente)
-- ============================================================
INSERT INTO cliente (nome, email, senha, telefone, data_nascimento)
VALUES
    ('João Guilherme Barros de Lima', 'joao@email.com', 'senha123', '66988881111', '2006-11-29'),
    ('Gi', 'gi@email.com', 'senha456', '66988882222', '2005-05-15'),
    ('Carlos Santos', 'carlos@email.com', 'senha789', '66988883333', '1990-08-20'),
    ('Mariana Silva', 'mariana@email.com', 'senha321', '66988884444', '1995-12-10'),
    ('Lucas Almeida', 'lucas@email.com', 'senha654', '66988885555', '1988-03-30');

-- ============================================================
-- INSERTS — TABELA 3 (imovel)
-- ============================================================
INSERT INTO imovel (id_corretor, titulo, valor, quantidade_comodos, cidade)
VALUES
    (1, 'Casa com piscina', 450000.00, 4, 'Rondonópolis'),
    (2, 'Apartamento Centro', 250000.00, 3, 'Rondonópolis'),
    (3, 'Chácara para descanso', 600000.00, 5, 'Chapada dos Guimarães'),
    (4, 'Casa na praia', 800000.00, 4, 'Alagoas'),
    (1, 'Terreno amplo', 150000.00, 0, 'Rondônia'),
    (5, 'Cobertura Duplex', 950000.00, 6, 'Rondonópolis');

-- ============================================================
-- INSERTS — TABELA 4 (agendamento)
-- ============================================================
INSERT INTO agendamento (id_cliente, id_imovel, data_visita, status)
VALUES
    (1, 4, '2026-10-15 10:00:00', 'Pendente'),
    (2, 3, '2026-10-16 14:30:00', 'Pendente'),
    (1, 3, '2026-10-17 09:00:00', 'Pendente'),
    (3, 2, '2026-10-18 11:00:00', 'Pendente'),
    (4, 5, '2026-10-19 15:00:00', 'Cancelado'),
    (5, 1, '2026-10-20 16:00:00', 'Pendente');

-- ============================================================
-- VERIFICAÇÕES
-- ============================================================
SELECT * FROM corretor;
SELECT * FROM cliente;
SELECT * FROM imovel;
SELECT * FROM agendamento;

-- ============================================================
-- UPDATES
-- ============================================================
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 1;
UPDATE imovel SET valor = 240000.00 WHERE id_imovel = 2;
UPDATE cliente SET telefone = '66000000000' WHERE id_cliente = 3;

-- ============================================================
-- DELETES
-- ============================================================
DELETE FROM agendamento WHERE id_agendamento = 5;
DELETE FROM imovel WHERE id_imovel = 6;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
SELECT * FROM agendamento;
SELECT * FROM imovel;