Ylma Cristina Souza Lopes
USE Clinica_Ser;

-- Criação de tabela auxiliar para o Trigger
CREATE TABLE Log_Laudo (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    id_resultado INT,
    data_emissao DATETIME,
    usuario VARCHAR(50)
);

-- TRIGGER
DELIMITER //
CREATE TRIGGER trg_log_resultado
AFTER INSERT ON Resultado
FOR EACH ROW
BEGIN
    INSERT INTO Log_Laudo (id_resultado, data_emissao, usuario)
    VALUES (NEW.id_resultado, NOW(), CURRENT_USER());
END //
DELIMITER ;

-- TRANSAÇÃO COM COMMIT
START TRANSACTION;
INSERT INTO Paciente (nome, cpf, data_nascimento, telefone, endereco, id_convenio) 
VALUES ('Lucas Fernandes', '09876543210', '1992-08-20', '66 99999-5555', 'Av B', 1);
SET @novo_paciente = LAST_INSERT_ID();
INSERT INTO Agendamento (id_paciente, id_exame, id_medico, data_hora) 
VALUES (@novo_paciente, 1, 1, '2026-11-10 10:00:00');
COMMIT;

-- TRANSAÇÃO COM ROLLBACK
START TRANSACTION;
UPDATE Exame SET preco = 5000.00 WHERE id_exame = 1; -- Aumento abusivo acidental
ROLLBACK; -- Desfaz a alteração

-- VALIDAÇÃO FINAL (Consultas base integrando JOINS e subconsultas)
SELECT * FROM vw_agendamentos_detalhados;
SELECT * FROM Log_Laudo;