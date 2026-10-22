-- ============================================================
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS (DML)
-- BANCO DE DADOS: SECRETARIA DE SAÚDE
-- Aluna: Talita de Oliveira Leite Sete
-- ============================================================

USE secretaria_saude;

-- ============================================================
-- INSERTS — UNIDADE_SAUDE (independente)
-- ============================================================
INSERT INTO unidade_saude (nome, endereco, tipo) VALUES
    ('UPA Jardim América', 'Av. das Palmeiras, 450', 'UPA'),
    ('Hospital Municipal', 'Rua Sete de Setembro, 120', 'Hospital'),
    ('Posto de Saúde Vila Rica', 'Rua das Acácias, 88', 'Posto'),
    ('CAPS Central', 'Av. Brasil, 300', 'CAPS'),
    ('UBS Santa Cruz', 'Rua Santa Cruz, 210', 'UBS');

-- ============================================================
-- INSERTS — PACIENTE (independente)
-- ============================================================
INSERT INTO paciente (nome, cpf, data_nascimento, sexo, telefone, endereco) VALUES
    ('Ana Beatriz Souza', '11122233344', '1990-05-12', 'F', '(66) 99911-2233', 'Rua A, 100'),
    ('Carlos Eduardo Lima', '22233344455', '1985-08-23', 'M', '(66) 99922-3344', 'Rua B, 200'),
    ('Mariana Ferreira Silva', '33344455566', '1998-01-30', 'F', '(66) 99933-4455', 'Rua C, 300'),
    ('João Pedro Alves', '44455566677', '1975-11-02', 'M', '(66) 99944-5566', 'Rua D, 400'),
    ('Beatriz Cardoso Rocha', '55566677788', '2002-03-15', 'F', '(66) 99955-6677', 'Rua E, 500');

-- ============================================================
-- INSERTS — PROFISSIONAL (independente)
-- ============================================================
INSERT INTO profissional (nome, registro_conselho, cargo, setor, telefone) VALUES
    ('Rafael Nunes', 'CRM123456', 'Médico', 'Clínica Geral', '(66) 98811-1111'),
    ('Camila Torres', 'COREN654321', 'Enfermeira', 'Vacinação', '(66) 98822-2222'),
    ('Fernando Costa', 'CRM654987', 'Médico', 'Pediatria', '(66) 98833-3333'),
    ('Juliana Martins', NULL, 'Recepcionista', 'Administrativo', '(66) 98844-4444'),
    ('Bruno Azevedo', 'COREN112233', 'Enfermeiro', 'Emergência', '(66) 98855-5555');

-- ============================================================
-- INSERTS — ATENDIMENTO (depende de paciente, profissional, unidade_saude)
-- ============================================================
INSERT INTO atendimento (id_paciente, id_profissional, id_unidade, data_hora, tipo_atendimento, status) VALUES
    (1, 1, 1, '2026-09-01 08:30:00', 'Consulta', 'REALIZADO'),
    (2, 3, 2, '2026-09-02 10:00:00', 'Consulta', 'AGENDADO'),
    (3, 2, 4, '2026-09-03 09:15:00', 'Vacina', 'REALIZADO'),
    (4, 5, 2, '2026-09-04 14:45:00', 'Emergência', 'REALIZADO'),
    (5, 1, 5, '2026-09-05 11:00:00', 'Consulta', 'AGENDADO');

-- ============================================================
-- INSERTS — PRONTUARIO (depende de paciente e atendimento já REALIZADOS)
-- ============================================================
INSERT INTO prontuario (id_paciente, id_atendimento, diagnostico, observacoes) VALUES
    (1, 1, 'Hipertensão leve', 'Paciente orientado sobre dieta e retorno em 30 dias'),
    (3, 3, 'Dose de vacina aplicada', 'Sem reações adversas'),
    (4, 4, 'Fratura no antebraço', 'Encaminhado para ortopedia');

-- ============================================================
-- INSERTS — ESTOQUE_ITEM (depende de unidade_saude)
-- ============================================================
INSERT INTO estoque_item (id_unidade, nome, tipo, quantidade, validade) VALUES
    (1, 'Dipirona 500mg', 'medicamento', 120, '2027-03-01'),
    (2, 'Amoxicilina 500mg', 'medicamento', 80, '2026-12-15'),
    (4, 'Vacina Tríplice Viral', 'vacina', 60, '2027-01-20'),
    (5, 'Soro Fisiológico 500ml', 'medicamento', 200, '2027-06-10'),
    (3, 'Vacina Influenza', 'vacina', 5, '2026-10-05');

-- ============================================================
-- INSERTS — OBITO (depende de paciente e unidade_saude)
-- ============================================================
INSERT INTO obito (id_paciente, data_obito, causa, unidade_responsavel) VALUES
    (4, '2026-09-10', 'Complicações pós-cirúrgicas', 2);

-- ============================================================
-- VERIFICAÇÕES
-- ============================================================
SELECT * FROM unidade_saude;
SELECT * FROM paciente;
SELECT * FROM profissional;
SELECT * FROM atendimento;
SELECT * FROM prontuario;
SELECT * FROM estoque_item;
SELECT * FROM obito;

-- ============================================================
-- UPDATES
-- ============================================================

-- UPDATE 1: marcar atendimento agendado como realizado
UPDATE atendimento
SET status = 'REALIZADO'
WHERE id_atendimento = 2;

-- UPDATE 2: dar baixa no estoque após aplicação de doses
UPDATE estoque_item
SET quantidade = quantidade - 10
WHERE id_item = 1;

-- UPDATE 3: atualizar telefone de contato do paciente
UPDATE paciente
SET telefone = '(66) 99999-1234'
WHERE id_paciente = 3;

-- ============================================================
-- DELETES
-- ============================================================

-- DELETE 1: cancelamento de atendimento agendado (não possui prontuário vinculado)
DELETE FROM atendimento
WHERE id_atendimento = 5;

-- DELETE 2: remoção de item de estoque vencido
DELETE FROM estoque_item
WHERE id_item = 5;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
SELECT * FROM atendimento;
SELECT * FROM estoque_item;