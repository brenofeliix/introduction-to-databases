Ylma Cristina Souza Lopes 
USE Clinica_Ser;

-- INNER JOIN 1
SELECT p.nome AS Paciente, c.nome_convenio AS Convenio
FROM Paciente p
INNER JOIN Convenio c ON p.id_convenio = c.id_convenio;

-- INNER JOIN 2
SELECT e.tipo_exame, r.laudo_texto
FROM Exame e
INNER JOIN Resultado r ON e.id_exame = r.id_exame;

-- LEFT JOIN
SELECT c.nome_convenio, p.nome
FROM Convenio c
LEFT JOIN Paciente p ON c.id_convenio = p.id_convenio;

-- RIGHT JOIN
SELECT e.tipo_exame, r.laudo_texto
FROM Resultado r
RIGHT JOIN Exame e ON r.id_exame = e.id_exame;

-- JOIN COM 3+ TABELAS 1
SELECT a.data_hora, p.nome AS Paciente, m.nome AS Medico, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

-- JOIN COM 3+ TABELAS 2
SELECT p.nome AS Paciente, e.tipo_exame, r.laudo_texto
FROM Resultado r
INNER JOIN Exame e ON r.id_exame = e.id_exame
INNER JOIN Agendamento a ON e.id_exame = a.id_exame
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente;

-- JOIN + WHERE
SELECT a.data_hora, p.nome AS Paciente, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
WHERE m.nome = 'Dr. João Pereira';

-- JOIN + ORDER BY
SELECT p.nome, a.data_hora
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
ORDER BY a.data_hora DESC;

-- JOIN + GROUP BY + AGREGAÇÃO
SELECT c.nome_convenio, SUM(e.preco) AS Total_Arrecadado
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Convenio c ON p.id_convenio = c.id_convenio
INNER JOIN Exame e ON a.id_exame = e.id_exame
GROUP BY c.nome_convenio;