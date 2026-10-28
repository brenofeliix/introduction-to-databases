-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- Aluno: Talita de Oliveira Leite Sete
-- Tema: Secretaria Municipal de Saúde
-- Banco: secretaria_saude

-- ============================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ============================================================
CREATE DATABASE IF NOT EXISTS secretaria_saude;

-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================
USE secretaria_saude;
-- ============================================================
-- CRIAÇÃO DAS TABELAS E RESTRIÇÕES (DDL)
-- ============================================================
CREATE TABLE paciente (
    id_paciente     INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(120) NOT NULL,
    cpf             CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE, -- Modificado de NOT NULL para opcional conforme implementação
    sexo            CHAR(1),
    telefone        VARCHAR(20),
    endereco        VARCHAR(200) NOT NULL -- Modificado de opcional para NOT NULL
);

CREATE TABLE profissional (
    id_profissional   INT PRIMARY KEY AUTO_INCREMENT,
    nome              VARCHAR(120) NOT NULL,
    registro_conselho VARCHAR(20) UNIQUE,
    cargo             VARCHAR(60) NOT NULL,
    setor             VARCHAR(60) NOT NULL,
    telefone          VARCHAR(20)
);

CREATE TABLE unidade_saude (
    id_unidade  INT PRIMARY KEY AUTO_INCREMENT,
    nome        VARCHAR(120) NOT NULL,
    endereco    VARCHAR(200) NOT NULL,
    tipo        VARCHAR(30) -- Modificado de NOT NULL para opcional
);

CREATE TABLE atendimento (
    id_atendimento   INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente      INT NOT NULL,
    id_profissional  INT NOT NULL,
    id_unidade       INT NOT NULL,
    data_hora        DATETIME NOT NULL,
    tipo_atendimento VARCHAR(60) NOT NULL,
    status           VARCHAR(20) NOT NULL DEFAULT 'AGENDADO',
    CONSTRAINT fk_atendimento_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_atendimento_profissional FOREIGN KEY (id_profissional) REFERENCES profissional(id_profissional),
    CONSTRAINT fk_atendimento_unidade FOREIGN KEY (id_unidade) REFERENCES unidade_saude(id_unidade)
);

CREATE TABLE prontuario (
    id_prontuario  INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente    INT NOT NULL,
    id_atendimento INT NOT NULL UNIQUE,
    diagnostico    TEXT,
    observacoes    TEXT,
    data_registro  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prontuario_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_prontuario_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento)
);

CREATE TABLE estoque_item (
    id_item     INT PRIMARY KEY AUTO_INCREMENT,
    id_unidade  INT NOT NULL,
    nome        VARCHAR(120) NOT NULL,
    tipo        VARCHAR(20) NOT NULL,
    quantidade  INT NOT NULL DEFAULT 0,
    validade    DATE,
    CONSTRAINT fk_estoque_unidade FOREIGN KEY (id_unidade) REFERENCES unidade_saude(id_unidade)
);

CREATE TABLE obito (
    id_obito             INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente          INT NOT NULL UNIQUE,
    data_obito           DATE NOT NULL,
    causa                VARCHAR(200),
    unidade_responsavel  INT,
    CONSTRAINT fk_obito_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_obito_unidade FOREIGN KEY (unidade_responsavel) REFERENCES unidade_saude(id_unidade)
);

-- ============================================================
-- INSERTS (Integração exata da Sprint 3)
-- ============================================================
INSERT INTO paciente (nome, cpf, data_nascimento, sexo, telefone, endereco) VALUES
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

INSERT INTO profissional (nome, registro_conselho, cargo, setor, telefone) VALUES
('Helena Martins Costa',      'CRM-MT 12345',    'Médica',                    'Clínica Geral',          '(66) 98801-0001'),
('Rafael Oliveira Santos',    'CRM-MT 23456',    'Médico',                    'Pediatria',              '(66) 98801-0002'),
('Camila Ferreira Lima',      'COREN-MT 345678', 'Enfermeira',                'Imunização',             '(66) 98801-0003'),
('Bruno Almeida Rocha',       'CRM-MT 45678',    'Médico',                    'Cardiologia',            '(66) 98801-0004'),
('Juliana Pereira Souza',     'COREN-MT 567890', 'Enfermeira',                'Urgência e Emergência',  '(66) 98801-0005'),
('Patrícia Nunes Barbosa',    'CRP-MT 06/1234',  'Psicóloga',                 'Saúde Mental',           '(66) 98801-0006'),
('Marcos Vinícius Teixeira',  NULL,              'Assistente Administrativo', 'Recepção',               NULL),
('Sandra Regina Gomes',       NULL,              'Coordenadora Administrativa', 'Gestão',               NULL);

INSERT INTO unidade_saude (nome, endereco, tipo) VALUES
('UBS Centro',                       'Rua Barão do Rio Branco, 450 - Centro',        'UBS'),
('UBS Vila Nova',                    'Rua Piauí, 200 - Vila Nova',                   'UBS'),
('UPA 24h Zona Sul',                 'Av. das Flores, 2100 - Zona Sul',              'UPA'),
('Hospital Municipal',               'Av. Brasil, 1000 - Jardim Esperança',          'HOSPITAL'),
('CAPS Esperança',                   'Rua Cuiabá, 35 - Centro',                      'CAPS'),
('Posto de Saúde Rural Boa Vista',   'Estrada Boa Vista, km 12 - Zona Rural',        'POSTO');

INSERT INTO atendimento (id_paciente, id_profissional, id_unidade, data_hora, tipo_atendimento, status) VALUES
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

INSERT INTO atendimento (id_paciente, id_profissional, id_unidade, data_hora, tipo_atendimento) VALUES
(4,  2, 2, '2026-10-28 09:30:00', 'Consulta'),
(9,  1, 2, '2026-11-04 08:30:00', 'Consulta'),
(6,  4, 4, '2026-11-10 14:00:00', 'Consulta'),
(10, 3, 2, '2026-10-30 10:00:00', 'Vacina');

INSERT INTO prontuario (id_paciente, id_atendimento, diagnostico, observacoes, data_registro) VALUES
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

INSERT INTO estoque_item (id_unidade, nome, tipo, quantidade, validade) VALUES
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

INSERT INTO obito (id_paciente, data_obito, causa, unidade_responsavel) VALUES
(2, '2026-09-20', 'Insuficiência cardíaca descompensada',           4),
(7, '2026-09-05', 'Pneumonia com insuficiência respiratória',       4);

-- ============================================================
-- UPDATES & DELETES (Integração exata da Sprint 3)
-- ============================================================
UPDATE atendimento SET data_hora = '2026-11-05 08:30:00' WHERE id_atendimento = 14;
UPDATE paciente SET telefone = '(66) 99905-0555', endereco = 'Rua das Acácias, 88 - Jardim Primavera' WHERE id_paciente = 5;
UPDATE profissional SET telefone = '(66) 98801-0007' WHERE id_profissional = 7;
UPDATE estoque_item SET quantidade = quantidade - 2 WHERE id_item = 3;

DELETE FROM estoque_item WHERE id_item = 9;
DELETE FROM atendimento WHERE id_atendimento = 12;

-- ============================================================
-- CONSULTAS DQL (Ajustadas com JOINs e filtros reais)
-- ============================================================
-- Consulta Básica
SELECT id_paciente, nome, cpf FROM paciente;

-- 1. Quais pacientes foram atendidos em determinada unidade? (Uso de JOIN para o nome)
SELECT DISTINCT p.nome, p.cpf 
FROM atendimento a
JOIN paciente p ON a.id_paciente = p.id_paciente
WHERE a.id_unidade = 2;

-- 2. Quantos atendimentos cada profissional realizou?
SELECT id_profissional, COUNT(*) AS total_atendimentos 
FROM atendimento 
WHERE status = 'REALIZADO' 
GROUP BY id_profissional 
HAVING COUNT(*) >= 2;

-- 3. Quais unidades têm estoque baixo de determinada vacina?
SELECT id_unidade, nome, quantidade 
FROM estoque_item 
WHERE tipo = 'VACINA' AND quantidade < 50;

-- 4. Qual o número de óbitos registrados por unidade?
SELECT unidade_responsavel, COUNT(*) AS total_obitos 
FROM obito 
GROUP BY unidade_responsavel;

-- 5. Quais pacientes têm atendimentos agendados para os próximos dias?
SELECT p.nome, a.data_hora, a.tipo_atendimento 
FROM atendimento a
JOIN paciente p ON a.id_paciente = p.id_paciente
WHERE a.status = 'AGENDADO' AND a.data_hora >= CURDATE()
ORDER BY a.data_hora ASC;

-- 6. Qual a frequência de cada tipo de atendimento por unidade?
SELECT id_unidade, tipo_atendimento, COUNT(*) AS frequencia 
FROM atendimento 
GROUP BY id_unidade, tipo_atendimento 
ORDER BY id_unidade, frequencia DESC;

-- Funções de Agregação e Expressões
SELECT SUM(quantidade) AS total_vacinas_rede FROM estoque_item WHERE tipo = 'VACINA';
SELECT AVG(quantidade) AS media_estoque_medicamentos FROM estoque_item WHERE tipo = 'MEDICAMENTO';
SELECT MIN(data_hora) AS proximo_atendimento, MAX(data_hora) AS ultimo_agendamento FROM atendimento WHERE status = 'AGENDADO';
SELECT nome, quantidade, (quantidade * 0.10) AS meta_reposicao FROM estoque_item;

-- ============================================================
-- VALIDAÇÃO DA ESTRUTURA E TESTES DE RESTRIÇÃO
-- ============================================================
SHOW TABLES;
DESCRIBE paciente;
DESCRIBE atendimento;
SHOW CREATE TABLE prontuario;

-- Testes Comentados (Simulação de Erros para o Markdown):
-- INSERT INTO paciente (nome, cpf, endereco) VALUES ('Teste', '10000000001', 'Rua X'); -- Erro: UNIQUE cpf
-- INSERT INTO atendimento (id_paciente, id_profissional, id_unidade, data_hora, tipo_atendimento) VALUES (99, 1, 1, '2026-10-10', 'Consulta'); -- Erro: FK id_paciente
-- INSERT INTO paciente (cpf, endereco) VALUES ('12345678901', 'Rua Y'); -- Erro: NOT NULL nome
