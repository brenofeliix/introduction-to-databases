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
-- 3. CRIAÇÃO DAS TABELAS E 4. RESTRIÇÕES/RELACIONAMENTOS
-- ============================================================

CREATE TABLE IF NOT EXISTS paciente (
    id_paciente     INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(120) NOT NULL,
    cpf             CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    sexo            CHAR(1),
    telefone        VARCHAR(20),
    endereco        VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS profissional (
    id_profissional   INT PRIMARY KEY AUTO_INCREMENT,
    nome              VARCHAR(120) NOT NULL,
    registro_conselho VARCHAR(20) UNIQUE,
    cargo             VARCHAR(60) NOT NULL,
    setor             VARCHAR(60) NOT NULL,
    telefone          VARCHAR(20) -- Adicionado via ALTER TABLE na Sprint 2
);

CREATE TABLE IF NOT EXISTS unidade_saude (
    id_unidade  INT PRIMARY KEY AUTO_INCREMENT,
    nome        VARCHAR(120) NOT NULL,
    endereco    VARCHAR(200) NOT NULL,
    tipo        VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS atendimento (
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

CREATE TABLE IF NOT EXISTS prontuario (
    id_prontuario  INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente    INT NOT NULL,
    id_atendimento INT NOT NULL UNIQUE,
    diagnostico    TEXT,
    observacoes    TEXT,
    data_registro  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prontuario_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_prontuario_atendimento FOREIGN KEY (id_atendimento) REFERENCES atendimento(id_atendimento)
);

CREATE TABLE IF NOT EXISTS estoque_item (
    id_item     INT PRIMARY KEY AUTO_INCREMENT,
    id_unidade  INT NOT NULL,
    nome        VARCHAR(120) NOT NULL,
    tipo        VARCHAR(20) NOT NULL,
    quantidade  INT NOT NULL DEFAULT 0,
    validade    DATE,
    CONSTRAINT fk_estoque_unidade FOREIGN KEY (id_unidade) REFERENCES unidade_saude(id_unidade)
);

CREATE TABLE IF NOT EXISTS obito (
    id_obito             INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente          INT NOT NULL UNIQUE,
    data_obito           DATE NOT NULL,
    causa                VARCHAR(200),
    unidade_responsavel  INT,
    CONSTRAINT fk_obito_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
    CONSTRAINT fk_obito_unidade FOREIGN KEY (unidade_responsavel) REFERENCES unidade_saude(id_unidade)
);

-- ============================================================
-- 5. INSERTS (Integração dos dados da Sprint 3)
-- ============================================================

INSERT IGNORE INTO paciente (id_paciente, nome, cpf, data_nascimento, sexo, telefone, endereco) VALUES
(1, 'Maria Aparecida da Silva', '10000000001', '1958-03-12', 'F', '(66) 99901-0001', 'Rua das Palmeiras, 120 - Centro'),
(2, 'José Carlos Pereira',      '10000000002', '1949-07-25', 'M', '(66) 99901-0002', 'Av. Brasil, 845 - Jardim Esperança'),
(3, 'Ana Beatriz Souza',        '10000000003', '1992-11-03', 'F', '(66) 99901-0003', 'Rua Goiás, 310 - Vila Nova'),
(4, 'Pedro Henrique Lima',      '10000000004', '2018-05-20', 'M', '(66) 99901-0004', 'Rua Sete de Setembro, 77 - Vila Nova'),
(5, 'Luciana Ferreira Alves',   '10000000005', '1985-09-14', 'F', '(66) 99901-0005', 'Rua Mato Grosso, 502 - Centro'),
(6, 'Carlos Eduardo Santos',    '10000000006', '1975-01-30', 'M', '(66) 99901-0006', 'Av. das Flores, 1500 - Zona Sul'),
(7, 'Francisca Oliveira Rocha', '10000000007', '1940-12-08', 'F', '(66) 99901-0007', 'Rua Amazonas, 64 - Jardim Esperança');

INSERT IGNORE INTO profissional (id_profissional, nome, registro_conselho, cargo, setor, telefone) VALUES
(1, 'Helena Martins Costa',   'CRM-MT 12345',    'Médica',     'Clínica Geral',          '(66) 98801-0001'),
(2, 'Rafael Oliveira Santos', 'CRM-MT 23456',    'Médico',     'Pediatria',              '(66) 98801-0002'),
(3, 'Camila Ferreira Lima',   'COREN-MT 345678', 'Enfermeira', 'Imunização',             '(66) 98801-0003'),
(4, 'Bruno Almeida Rocha',    'CRM-MT 45678',    'Médico',     'Cardiologia',            '(66) 98801-0004');

INSERT IGNORE INTO unidade_saude (id_unidade, nome, endereco, tipo) VALUES
(1, 'UBS Centro',         'Rua Barão do Rio Branco, 450 - Centro', 'UBS'),
(2, 'UBS Vila Nova',      'Rua Piauí, 200 - Vila Nova',            'UBS'),
(3, 'UPA 24h Zona Sul',   'Av. das Flores, 2100 - Zona Sul',       'UPA'),
(4, 'Hospital Municipal', 'Av. Brasil, 1000 - Jardim Esperança',   'HOSPITAL');

INSERT IGNORE INTO atendimento (id_atendimento, id_paciente, id_profissional, id_unidade, data_hora, tipo_atendimento, status) VALUES
(1, 1, 1, 1, '2026-09-14 08:30:00', 'Consulta', 'REALIZADO'),
(2, 2, 4, 4, '2026-09-02 10:00:00', 'Consulta', 'REALIZADO'),
(3, 3, 1, 1, '2026-09-21 09:15:00', 'Consulta', 'REALIZADO'),
(4, 4, 3, 2, '2026-09-22 14:00:00', 'Vacina',   'REALIZADO'),
(5, 5, 2, 2, '2026-10-28 09:30:00', 'Consulta', 'AGENDADO'),
(6, 6, 4, 4, '2026-11-10 14:00:00', 'Consulta', 'AGENDADO'),
(7, 4, 2, 2, '2026-11-05 10:00:00', 'Consulta', 'AGENDADO'); -- Inserido para teste do profissional com >= 2 atendimentos

INSERT IGNORE INTO prontuario (id_prontuario, id_paciente, id_atendimento, diagnostico, observacoes) VALUES
(1, 1, 1, 'Hipertensão arterial - acompanhamento de rotina', 'PA 130/85 mmHg. Mantida a medicação.'),
(2, 2, 2, 'Insuficiência cardíaca - avaliação cardiológica', 'Relata piora da falta de ar.');

INSERT IGNORE INTO estoque_item (id_item, id_unidade, nome, tipo, quantidade, validade) VALUES
(1, 1, 'Vacina Influenza',        'VACINA',      120, '2027-03-31'),
(2, 1, 'Dipirona 500 mg',         'MEDICAMENTO', 800, '2027-08-15'),
(3, 2, 'Vacina Tríplice Viral',   'VACINA',       60, '2027-01-20'),
(4, 3, 'Soro Fisiológico 0,9%',   'MEDICAMENTO', 150, '2028-01-31'),
(5, 4, 'Insulina NPH 100 UI/mL',  'MEDICAMENTO',  40, '2027-04-30'),
(6, 2, 'Vacina Febre Amarela',    'VACINA',       15, '2027-09-30'); -- Quantidade < 50 para testar a query 3

INSERT IGNORE INTO obito (id_obito, id_paciente, data_obito, causa, unidade_responsavel) VALUES
(1, 2, '2026-09-20', 'Insuficiência cardíaca descompensada', 4),
(2, 7, '2026-09-05', 'Pneumonia com insuficiência respiratória', 4);

-- ============================================================
-- 6. UPDATES
-- ============================================================
-- Reagendamento de atendimento
UPDATE atendimento SET data_hora = '2026-11-05 08:30:00' WHERE id_atendimento = 6;

-- Baixa de stock
UPDATE estoque_item SET quantidade = quantidade - 2 WHERE id_item = 3;

-- ============================================================
-- 7. DELETES
-- ============================================================
-- Descartar atendimento cancelado (hipotético ID 99 inserido e apagado para testes)
-- DELETE FROM atendimento WHERE id_atendimento = 99;

-- ============================================================
-- 8 a 14. CONSULTAS FINAIS (Respondendo às 6 perguntas da Sprint 1)
-- ============================================================

-- PERGUNTA 1: Quais pacientes estão cadastrados em determinada unidade? (ex: Unidade 2)
SELECT DISTINCT id_paciente 
FROM atendimento 
WHERE id_unidade = 2;

-- PERGUNTA 2: Quantos atendimentos cada profissional realizou no mês? (Filtrando >= 2)
SELECT id_profissional, COUNT(*) AS total_atendimentos 
FROM atendimento 
WHERE status = 'REALIZADO' 
GROUP BY id_profissional 
HAVING COUNT(*) >= 2;

-- PERGUNTA 3: Quais unidades têm estoque baixo de determinada vacina?
SELECT id_unidade, nome, quantidade 
FROM estoque_item 
WHERE tipo = 'VACINA' AND quantidade < 50;

-- PERGUNTA 4: Qual o número de óbitos registrados por unidade/período?
SELECT unidade_responsavel, COUNT(*) AS total_obitos 
FROM obito 
GROUP BY unidade_responsavel;

-- PERGUNTA 5: Quais pacientes têm atendimentos agendados para os próximos dias?
SELECT id_paciente, data_hora, tipo_atendimento 
FROM atendimento 
WHERE status = 'AGENDADO' AND data_hora >= '2026-10-26'
ORDER BY data_hora ASC;

-- PERGUNTA 6: Qual o tipo de atendimento mais frequente por unidade?
SELECT id_unidade, tipo_atendimento, COUNT(*) AS frequencia 
FROM atendimento 
GROUP BY id_unidade, tipo_atendimento 
ORDER BY id_unidade, frequencia DESC;

-- EXPRESSÃO SQL: Cálculo de meta de reposição (10% do estoque atual)
SELECT nome, quantidade, (quantidade * 0.10) AS meta_reposicao 
FROM estoque_item;

-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================
SHOW TABLES;