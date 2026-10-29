-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Ylma
-- Banco: Clinica_Ser


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE Clinica_Ser;


-- ============================================================
-- INSERTS — TABELA 1 (Convenio)
-- ============================================================

INSERT INTO Convenio (nome)
VALUES
    ('Unimed'),
    ('Amil'),
    ('Bradesco Saúde'),
    ('SulAmérica'),
    ('CASSI');


-- ============================================================
-- INSERTS — TABELA 2 (Medico)
-- ============================================================

INSERT INTO Medico (nome_completo, cro, especialidade)
VALUES
    ('Dr. João Almeida', 'CRO12345', 'Odontologista'),
    ('Dra. Maria Santos', 'CRO23456', 'Implandontista'),
    ('Dr. Pedro Oliveira', 'CRO34567', 'Odontopediatra'),
    ('Dra. Ana Costa', 'CRO45678', 'Otorinolaringologista'),
    ('Dr. Lucas Pereira', 'CRO56789', 'Bucomaxilofacial');


-- ============================================================
-- INSERTS — TABELA 3 (Paciente)
-- ============================================================

INSERT INTO Paciente (nome_completo, data_nascimento, telefone, sexo, cpf, imagem, id_convenio)
VALUES
    ('Ana Souza', '1990-05-10', '66999990001', 'F', '12345678901', 'ana.jpg', 1),
    ('Carlos Lima', '1985-03-22', '66999990002', 'M', '23456789012', 'carlos.jpg', 2),
    ('Mariana Silva', '1992-11-15', '66999990003', 'F', '34567890123', 'mariana.jpg', 3),
    ('João Pereira', '1988-07-30', '66999990004', 'M', '45678901234', 'joao.jpg', 4),
    ('Fernanda Costa', '1995-01-05', '66999990005', 'F', '56789012345', 'fernanda.jpg', 5);


-- ============================================================
-- INSERTS — TABELA 4 (Exame)
-- ============================================================

INSERT INTO Exame (tipo, preco)
VALUES
    ('Tomografia Completa', 430.00),
    ('Raio-X Panorâmico', 130.00),
    ('Fotografia', 120.00),
    ('Modelo estudo', 120.00),
    ('Escaneamento', 230.00);


-- ============================================================
-- INSERTS — TABELA 5 (Agendamento)
-- ============================================================

INSERT INTO Agendamento (data_agendamento, id_paciente, id_medico, id_exame)
VALUES
    ('2026-09-10 09:00:00', 1, 1, 1),
    ('2026-09-11 10:30:00', 2, 2, 2),
    ('2026-09-12 14:00:00', 3, 3, 3),
    ('2026-09-13 08:45:00', 4, 4, 4),
    ('2026-09-14 11:15:00', 5, 5, 5);


-- ============================================================
-- INSERTS — TABELA 6 (Resultado)
-- ============================================================

INSERT INTO Resultado (laudo_pdf, id_exame)
VALUES
    ('Tomografia_ana.pdf', 1),
    ('raiox_carlos.pdf', 2),
    ('Modelo_mariana.pdf', 3),
    ('Fotos_joao.pdf', 4),
    ('Escaneamento_fernanda.pdf', 5);


-- ============================================================
-- VERIFICAÇÕES
-- ============================================================

-- Testar UNIQUE (cpf duplicado)
-- Testar NOT NULL (nome_completo em Medico)
-- Testar FOREIGN KEY (paciente inexistente em Agendamento)


-- ============================================================
-- UPDATES
-- ============================================================

-- UPDATE 1: alterar telefone de paciente
UPDATE Paciente SET telefone = '66999990099' WHERE id_paciente = 3;

-- UPDATE 2: corrigir especialidade de médico
UPDATE Medico SET especialidade = 'Ginecologia' WHERE cro = 'CRO45678';

-- UPDATE 3: reajustar preço de exame
UPDATE Exame SET preco = preco * 1.15 WHERE tipo = 'Escaneamento';


-- ============================================================
-- DELETES
-- ============================================================

-- DELETE 1: remover convênio sem pacientes vinculados
DELETE FROM Convenio WHERE id_convenio = 5;

-- DELETE 2: tentativa de remover paciente com agendamento (deve falhar)
DELETE FROM Paciente WHERE id_paciente = 1;


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

-- SELECT para confirmar dados atualizados
SELECT * FROM Paciente;
SELECT * FROM Medico;
SELECT * FROM Exame;
SELECT * FROM Agendamento;
SELECT * FROM Resultado;

SELECT 
    a.id_agendamento,
    a.data_agendamento,
    p.nome_completo AS paciente,
    m.nome_completo AS medico,
    m.especialidade,
    e.tipo AS exame,
    e.preco
FROM Agendamento a
JOIN Paciente p ON a.id_paciente = p.id_paciente
JOIN Medico m ON a.id_medico = m.id_medico
JOIN Exame e ON a.id_exame = e.id_exame;
