-- ============================================================
-- DISCIPLINA: Laboratório de Banco de Dados
-- SPRINT 3/5 — Manipulação de Dados com DML (INSERT, UPDATE, DELETE)
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================

-- 1. SELEÇÃO DO BANCO DE DADOS
USE db_salao_beleza;


-- ============================================================
-- 2. INSERTS — TABELAS INDEPENDENTES (TABELAS PAI)
-- ============================================================

-- 2.1 INSERTS NA TABELA: cliente
-- (Campos: nome, cpf, telefone, email)
INSERT INTO cliente (nome, cpf, telefone, email)
VALUES
    ('Mariana Souza', '111.222.333-44', '(65) 99111-2233', 'mariana.souza@email.com'),
    ('Beatriz Santos', '222.333.444-55', '(65) 99222-3344', 'beatriz.santos@email.com'),
    ('Camila Oliveira', '333.444.555-66', '(65) 99333-4455', 'camila.oliveira@email.com'),
    ('Juliana Costa', '444.555.666-77', '(65) 99444-5566', 'juliana.costa@email.com'),
    ('Fernanda Lima', '555.666.777-88', '(65) 99555-6677', 'fernanda.lima@email.com'),
    ('Lucas Ribeiro (Teste)', '666.777.888-99', '(65) 99666-7788', 'lucas.teste@email.com');

-- 2.2 INSERTS NA TABELA: profissional
-- (Campos: nome, especialidade, telefone)
INSERT INTO profissional (nome, especialidade, telefone)
VALUES
    ('Ana Paula Nogueira', 'Cabeleireira', '(65) 98111-1001'),
    ('Carla Mendes', 'Manicure e Pedicure', '(65) 98222-1002'),
    ('Daniela Rocha', 'Maquiadora', '(65) 98333-1003'),
    ('Eduardo Martins', 'Barbeiro', '(65) 98444-1004'),
    ('Fabiana Silveira', 'Esteticista', '(65) 98555-1005');

-- 2.3 INSERTS NA TABELA: servico
-- (Campos: nome_servico, duracao_minutos, preco)
INSERT INTO servico (nome_servico, duracao_minutos, preco)
VALUES
    ('Corte Feminino', 45, 80.00),
    ('Corte Masculino', 30, 50.00),
    ('Manicure e Pedicure', 60, 65.00),
    ('Escova e Hidratação', 50, 90.00),
    ('Maquiagem Social', 60, 150.00),
    ('Limpeza de Pele', 75, 120.00);


-- ============================================================
-- 3. INSERTS — TABELA DEPENDENTE (COM CHAVES ESTRANGEIRAS)
-- ============================================================

-- 3.1 INSERTS NA TABELA: agendamento
-- (Campos: id_cliente, id_profissional, id_servico, data_hora, status, forma_pagamento, observacoes)
INSERT INTO agendamento (id_cliente, id_profissional, id_servico, data_hora, status, forma_pagamento, observacoes)
VALUES
    (1, 1, 1, '2026-09-15 09:00:00', 'Agendado', NULL, 'Cliente prefere corte na tesoura'),
    (2, 2, 3, '2026-09-15 10:30:00', 'Agendado', NULL, 'Trazer esmalte próprio'),
    (3, 3, 5, '2026-09-15 14:00:00', 'Agendado', NULL, 'Evento à noite, maquiagem marcante'),
    (4, 4, 2, '2026-09-16 11:00:00', 'Agendado', NULL, 'Acabamento com navalha'),
    (5, 5, 6, '2026-09-16 15:30:00', 'Agendado', NULL, 'Pele sensível'),
    (1, 2, 3, '2026-09-17 16:00:00', 'Cancelado', NULL, 'Cliente cancelou com antecedência por imprevisto');


-- ============================================================
-- 4. VERIFICAÇÕES INTERMEDIÁRIAS (SELECT)
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM profissional;
SELECT * FROM servico;
SELECT * FROM agendamento;


-- ============================================================
-- 5. OPERAÇÕES UPDATE (MÍNIMO 3 OBRIGATÓRIAS)
-- ============================================================

-- UPDATE 1: Atualização de telefone e e-mail da cliente Beatriz Santos
UPDATE cliente
SET telefone = '(65) 99999-3344',
    email = 'beatriz.nova@email.com'
WHERE id_cliente = 2;

-- UPDATE 2: Reajuste do preço do serviço 'Escova e Hidratação' de 90.00 para 95.00
UPDATE servico
SET preco = 95.00
WHERE id_servico = 4;

-- UPDATE 3: Conclusão do agendamento 1 com registro de forma de pagamento e observação adicional
UPDATE agendamento
SET status = 'Concluído',
    forma_pagamento = 'Pix',
    observacoes = 'Atendimento concluído com sucesso, cliente satisfeita'
WHERE id_agendamento = 1;


-- ============================================================
-- 6. OPERAÇÕES DELETE (MÍNIMO 2 OBRIGATÓRIAS)
-- ============================================================

-- DELETE 1: Exclusão segura do agendamento cancelado (id_agendamento = 6)
DELETE FROM agendamento
WHERE id_agendamento = 6;

-- DELETE 2: Exclusão segura do cliente cadastrado para teste sem agendamentos (id_cliente = 6)
-- Demonstra a integridade referencial: pode ser excluído sem violar FK pois não tem agendamentos dependentes
DELETE FROM cliente
WHERE id_cliente = 6;


-- ============================================================
-- 7. VERIFICAÇÃO FINAL APÓS MANIPULAÇÕES DML
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM profissional;
SELECT * FROM servico;
SELECT * FROM agendamento;
