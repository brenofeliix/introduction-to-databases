Ylma Cristina Souza Lopes
USE Clinica_Ser;

-- VIEW 1
CREATE VIEW vw_agendamentos_detalhados AS
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, m.nome AS medico, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

-- VIEW 2
CREATE VIEW vw_faturamento_por_exame AS
SELECT e.tipo_exame, COUNT(a.id_agendamento) AS qtd_realizada, SUM(e.preco) AS faturamento_total
FROM Exame e
LEFT JOIN Agendamento a ON e.id_exame = a.id_exame
GROUP BY e.tipo_exame;

-- VIEW 3
CREATE VIEW vw_laudos_pendentes AS
SELECT a.data_hora, p.nome, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Exame e ON a.id_exame = e.id_exame
LEFT JOIN Resultado r ON a.id_exame = r.id_exame
WHERE r.id_resultado IS NULL AND a.data_hora < NOW();

-- CREATE OR REPLACE VIEW
CREATE OR REPLACE VIEW vw_agendamentos_detalhados AS
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, m.nome AS medico, m.especialidade, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

-- VIEW TEMPORÁRIA
CREATE VIEW vw_teste AS SELECT * FROM Convenio;

-- DROP VIEW
DROP VIEW vw_teste;

-- VALIDAÇÃO
SHOW FULL TABLES WHERE Table_type = 'VIEW';