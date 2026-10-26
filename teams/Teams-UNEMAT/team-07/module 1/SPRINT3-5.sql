-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- Aluna: Talita de Oliveira Leite Sete
-- Banco: secretaria_saude
-- Disciplina: Laboratório de Banco de Dados

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================
USE secretaria_saude;

-- ============================================================
-- INSERTS — TABELA 1: PACIENTE (independente)
-- ============================================================
INSERT INTO paciente (
    nome,
    cpf,
    data_nascimento,
    sexo,
    telefone,
    endereco
)
VALUES
    ('Maria Aparecida da Silva', '10000000001', '1958-03-12', 'F', '(66) 99901-0001', 'Rua das Palmeiras, 120 - Centro'),
    ('José Carlos Pereira',      '10000000002', '1949-07-25', 'M', '(66) 99901-0002', 'Av. Brasil, 845 - Jardim Esperança'),
    ('Ana Beatriz Souza',        '10000000003', '1992-11-03', 'F', '(66) 99901-0003', 'Rua Goiás, 310 - Vila Nova'),
    ('Pedro Henrique Lima',      '10000000004', '2018-05-20', 'M', '(66) 99901-0004', 'Rua Sete de Setembro, 77 - Vila Nova'),
    ('Luciana Ferreira Alves',   '10000000005', '1985-09-14', 'F', '(66) 99901-0005', 'Rua Mato Grosso, 502 - Centro'),
    ('Carlos Eduardo Santos',    '10000000006', '1975-01-30', 'M', '(66) 99901-0006', 'Av. das Flores, 1500 - Zona Sul'),
    ('Francisca Oliveira Rocha', '10000000007', '1940-12-08', 'F', '(66) 99901-0007', 'Rua Amazonas, 64 - Jardim Esperança'),
    ('Gabriel Almeida Costa',    '10000000008', '2001-06-17', 'M', '(66) 99901-0008', 'Rua Ipê Amarelo, 230 - Zona Sul'),
    ('Rita de Cássia Nunes',     '10000000009', '1968-04-22', 'F', '(66) 99901-0009', 'Rua Tiradentes, 18 - Vila Nova'),
    ('Thiago Martins Barbosa',   '10000000010', '2023-02-09', 'M', '(66) 99901-0010', 'Rua das Acácias, 905 - Vila Nova');

-- ============================================================
-- INSERTS — TABELA 2: PROFISSIONAL (independente)
-- ============================================================
-- Profissionais clínicos possuem registro no conselho;
-- a equipe administrativa fica com registro_conselho NULL.
INSERT INTO profissional (
    nome,
    registro_conselho,
    cargo,
    setor,
    telefone
)
VALUES
    ('Helena Martins Costa',      'CRM-MT 12345',    'Médica',                    'Clínica Geral',          '(66) 98801-0001'),
    ('Rafael Oliveira Santos',    'CRM-MT 23456',    'Médico',                    'Pediatria',              '(66) 98801-0002'),
    ('Camila Ferreira Lima',      'COREN-MT 345678', 'Enfermeira',                'Imunização',             '(66) 98801-0003'),
    ('Bruno Almeida Rocha',       'CRM-MT 45678',    'Médico',                    'Cardiologia',            '(66) 98801-0004'),
    ('Juliana Pereira Souza',     'COREN-MT 567890', 'Enfermeira',                'Urgência e Emergência',  '(66) 98801-0005'),
    ('Patrícia Nunes Barbosa',    'CRP-MT 06/1234',  'Psicóloga',                 'Saúde Mental',           '(66) 98801-0006'),
    ('Marcos Vinícius Teixeira',  NULL,              'Assistente Administrativo', 'Recepção',               NULL),
    ('Sandra Regina Gomes',       NULL,              'Coordenadora Administrativa', 'Gestão',               NULL);

-- ============================================================
-- INSERTS — TABELA 3: UNIDADE_SAUDE (independente)
-- ============================================================
INSERT INTO unidade_saude (
    nome,
    endereco,
    tipo
)
VALUES
    ('UBS Centro',                       'Rua Barão do Rio Branco, 450 - Centro',        'UBS'),
    ('UBS Vila Nova',                    'Rua Piauí, 200 - Vila Nova',                   'UBS'),
    ('UPA 24h Zona Sul',                 'Av. das Flores, 2100 - Zona Sul',              'UPA'),
    ('Hospital Municipal',               'Av. Brasil, 1000 - Jardim Esperança',          'HOSPITAL'),
    ('CAPS Esperança',                   'Rua Cuiabá, 35 - Centro',                      'CAPS'),
    ('Posto de Saúde Rural Boa Vista',   'Estrada Boa Vista, km 12 - Zona Rural',        'POSTO');

-- ============================================================
-- INSERTS — TABELA 4: ATENDIMENTO (depende de paciente, profissional, unidade_saude)
-- ============================================================
-- Atendimentos já realizados ou cancelados (ids 1 a 12)
INSERT INTO atendimento (
    id_paciente,
    id_profissional,
    id_unidade,
    data_hora,
    tipo_atendimento,
    status
)
VALUES
    (1,  1, 1, '2026-09-14 08:30:00', 'Consulta',     'REALIZADO'),
    (2,  4, 4, '2026-09-02 10:00:00', 'Consulta',     'REALIZADO'),
    (3,  1, 1, '2026-09-21 09:15:00', 'Consulta',     'REALIZADO'),
    (4,  3, 2, '2026-09-22 14:00:00', 'Vacina',       'REALIZADO'),
    (5,  6, 5, '2026-09-23 15:30:00', 'Consulta',     'REALIZADO'),
    (6,  5, 3, '2026-10-01 22:10:00', 'Procedimento', 'REALIZADO'),
    (7,  4, 4, '2026-08-30 11:00:00', 'Consulta',     'REALIZADO'),
    (8,  5, 3, '2026-10-05 19:45:00', 'Procedimento', 'REALIZADO'),
    (9,  1, 2, '2026-10-08 08:00:00', 'Consulta',     'REALIZADO'),
    (10, 3, 2, '2026-10-12 10:30:00', 'Vacina',       'REALIZADO'),
    (1,  4, 4, '2026-10-14 13:30:00', 'Consulta',     'REALIZADO'),
    (3,  1, 1, '2026-10-20 09:00:00', 'Consulta',     'CANCELADO');

-- Atendimentos futuros (ids 13 a 16): a coluna status é omitida de
-- propósito, para que o DEFAULT 'AGENDADO' seja aplicado pelo banco.
INSERT INTO atendimento (
    id_paciente,
    id_profissional,
    id_unidade,
    data_hora,
    tipo_atendimento
)
VALUES
    (4,  2, 2, '2026-10-28 09:30:00', 'Consulta'),
    (9,  1, 2, '2026-11-04 08:30:00', 'Consulta'),
    (6,  4, 4, '2026-11-10 14:00:00', 'Consulta'),
    (10, 3, 2, '2026-10-30 10:00:00', 'Vacina');

-- ============================================================
-- INSERTS — TABELA 5: PRONTUARIO (depende de paciente e atendimento)
-- ============================================================
-- Um prontuário para cada atendimento REALIZADO (ids 1 a 11).
-- O id_paciente de cada linha é o mesmo do atendimento correspondente.
INSERT INTO prontuario (
    id_paciente,
    id_atendimento,
    diagnostico,
    observacoes,
    data_registro
)
VALUES
    (1,  1,  'Hipertensão arterial - acompanhamento de rotina',     'PA 130/85 mmHg. Mantida a medicação em uso; retorno em 30 dias.',          '2026-09-14 08:55:00'),
    (2,  2,  'Insuficiência cardíaca - avaliação cardiológica',     'Relata piora da falta de ar. Solicitados exames complementares.',          '2026-09-02 10:30:00'),
    (3,  3,  'Rinofaringite aguda',                                 'Orientado repouso, hidratação e sintomáticos.',                            '2026-09-21 09:40:00'),
    (4,  4,  'Vacinação de rotina',                                 'Dose aplicada sem intercorrências. Carteira de vacinação atualizada.',     '2026-09-22 14:15:00'),
    (5,  5,  'Acompanhamento psicológico - ansiedade',              'Iniciado acompanhamento semanal.',                                         '2026-09-23 16:20:00'),
    (6,  6,  'Laceração em antebraço direito',                      'Realizada sutura simples e curativo. Retorno para retirada de pontos.',    '2026-10-01 22:50:00'),
    (7,  7,  'Pneumonia - avaliação clínica',                       'Paciente com febre e tosse; encaminhada para internação.',                 '2026-08-30 11:40:00'),
    (8,  8,  'Entorse de tornozelo esquerdo',                       'Imobilização com tala e orientação de repouso.',                           '2026-10-05 20:20:00'),
    (9,  9,  'Diabetes mellitus tipo 2 - acompanhamento',           'Glicemia de jejum solicitada. Reforçadas orientações alimentares.',        '2026-10-08 08:35:00'),
    (10, 10, 'Vacinação de rotina',                                 'Primeira dose aplicada. Segunda dose agendada.',                           '2026-10-12 10:50:00'),
    (1,  11, 'Hipertensão arterial - avaliação cardiológica',       'Ecocardiograma sem alterações relevantes. Mantido o tratamento.',          '2026-10-14 14:00:00');

-- ============================================================
-- INSERTS — TABELA 6: ESTOQUE_ITEM (depende de unidade_saude)
-- ============================================================
INSERT INTO estoque_item (
    id_unidade,
    nome,
    tipo,
    quantidade,
    validade
)
VALUES
    (1, 'Vacina Influenza',                   'VACINA',       120, '2027-03-31'),
    (1, 'Dipirona 500 mg (comprimido)',       'MEDICAMENTO',  800, '2027-08-15'),
    (2, 'Vacina Tríplice Viral',              'VACINA',        60, '2027-01-20'),
    (2, 'Vacina Hepatite B',                  'VACINA',        45, '2027-02-28'),
    (2, 'Amoxicilina 500 mg (cápsula)',       'MEDICAMENTO',  300, '2027-06-10'),
    (3, 'Soro Fisiológico 0,9% 500 mL',       'MEDICAMENTO',  150, '2028-01-31'),
    (3, 'Paracetamol 750 mg (comprimido)',    'MEDICAMENTO',  500, '2027-05-05'),
    (4, 'Insulina NPH 100 UI/mL',             'MEDICAMENTO',   40, '2027-04-30'),
    (6, 'Vacina Febre Amarela',               'VACINA',        15, '2026-09-30'),
    (5, 'Fluoxetina 20 mg (cápsula)',         'MEDICAMENTO',  200, '2027-09-30'),
    (6, 'Vacina Influenza',                   'VACINA',         8, '2027-03-31');

-- ============================================================
-- INSERTS — TABELA 7: OBITO (depende de paciente e unidade_saude)
-- ============================================================
-- Os pacientes 2 e 7 não possuem atendimentos agendados nem
-- atendimentos posteriores à data do óbito (regra de negócio 5).
INSERT INTO obito (
    id_paciente,
    data_obito,
    causa,
    unidade_responsavel
)
VALUES
    (2, '2026-09-20', 'Insuficiência cardíaca descompensada',           4),
    (7, '2026-09-05', 'Pneumonia com insuficiência respiratória',       4);

-- ============================================================
-- VERIFICAÇÕES
-- ============================================================
SELECT * FROM paciente;
SELECT * FROM profissional;
SELECT * FROM unidade_saude;
SELECT * FROM atendimento;
SELECT * FROM prontuario;
SELECT * FROM estoque_item;
SELECT * FROM obito;

-- ============================================================
-- UPDATES
-- ============================================================

-- UPDATE 1: reagendamento de um atendimento (nova data/hora)
SELECT * FROM atendimento WHERE id_atendimento = 14;

UPDATE atendimento
SET data_hora = '2026-11-05 08:30:00'
WHERE id_atendimento = 14;

SELECT * FROM atendimento WHERE id_atendimento = 14;

-- UPDATE 2: paciente mudou de telefone e de endereço
SELECT * FROM paciente WHERE id_paciente = 5;

UPDATE paciente
SET telefone = '(66) 99905-0555',
    endereco = 'Rua das Acácias, 88 - Jardim Primavera'
WHERE id_paciente = 5;

SELECT * FROM paciente WHERE id_paciente = 5;

-- UPDATE 3: preenchimento do telefone de um profissional (coluna criada com ALTER TABLE na Sprint 2)
SELECT * FROM profissional WHERE id_profissional = 7;

UPDATE profissional
SET telefone = '(66) 98801-0007'
WHERE id_profissional = 7;

SELECT * FROM profissional WHERE id_profissional = 7;

-- UPDATE 4: baixa no estoque (2 doses de Tríplice Viral aplicadas na UBS Vila Nova)
SELECT * FROM estoque_item WHERE id_item = 3;

UPDATE estoque_item
SET quantidade = quantidade - 2
WHERE id_item = 3;

SELECT * FROM estoque_item WHERE id_item = 3;

-- ============================================================
-- DELETES
-- ============================================================

-- DELETE 1: descarte de lote vencido (Vacina Febre Amarela, validade 2026-09-30)
SELECT * FROM estoque_item WHERE id_item = 9;

DELETE FROM estoque_item
WHERE id_item = 9;

SELECT * FROM estoque_item WHERE id_item = 9;

-- DELETE 2: remoção de atendimento cancelado, sem prontuário vinculado
SELECT * FROM atendimento WHERE id_atendimento = 12;
SELECT * FROM prontuario  WHERE id_atendimento = 12;

DELETE FROM atendimento
WHERE id_atendimento = 12;

SELECT * FROM atendimento WHERE id_atendimento = 12;

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
SELECT * FROM paciente;
SELECT * FROM profissional;
SELECT * FROM unidade_saude;
SELECT * FROM atendimento;
SELECT * FROM prontuario;
SELECT * FROM estoque_item;
SELECT * FROM obito;

-- Contagem de registros por tabela
SELECT 'paciente'      AS tabela, COUNT(*) AS total FROM paciente
UNION ALL SELECT 'profissional',  COUNT(*) FROM profissional
UNION ALL SELECT 'unidade_saude', COUNT(*) FROM unidade_saude
UNION ALL SELECT 'atendimento',   COUNT(*) FROM atendimento
UNION ALL SELECT 'prontuario',    COUNT(*) FROM prontuario
UNION ALL SELECT 'estoque_item',  COUNT(*) FROM estoque_item
UNION ALL SELECT 'obito',         COUNT(*) FROM obito;