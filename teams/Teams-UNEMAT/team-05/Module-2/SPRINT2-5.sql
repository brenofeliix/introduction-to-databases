Ylma Cristina Souza Lopes
USE Clinica_Ser;

-- SUBQUERY COM COMPARAÇÃO
SELECT tipo_exame, preco 
FROM Exame 
WHERE preco > (SELECT AVG(preco) FROM Exame);

-- IN
SELECT nome 
FROM Medico 
WHERE id_medico IN (SELECT id_medico FROM Agendamento);

-- NOT IN
SELECT nome 
FROM Paciente 
WHERE id_paciente NOT IN (SELECT id_paciente FROM Agendamento);

-- EXISTS
SELECT nome_convenio 
FROM Convenio c 
WHERE EXISTS (SELECT 1 FROM Paciente p WHERE p.id_convenio = c.id_convenio);

-- NOT EXISTS
SELECT tipo_exame 
FROM Exame e 
WHERE NOT EXISTS (SELECT 1 FROM Resultado r WHERE r.id_exame = e.id_exame);

-- MAX / MIN
SELECT nome, data_nascimento 
FROM Paciente 
WHERE data_nascimento = (SELECT MIN(data_nascimento) FROM Paciente);

-- SUBQUERY CORRELACIONADA
SELECT p.nome, 
       (SELECT COUNT(*) FROM Agendamento a WHERE a.id_paciente = p.id_paciente) AS Total_Agendamentos 
FROM Paciente p;

-- PROBLEMA JOIN
SELECT p.nome, c.nome_convenio 
FROM Paciente p 
INNER JOIN Convenio c ON p.id_convenio = c.id_convenio;

-- PROBLEMA SUBQUERY
SELECT nome, 
       (SELECT nome_convenio FROM Convenio c WHERE c.id_convenio = p.id_convenio) AS Convenio 
FROM Paciente p;