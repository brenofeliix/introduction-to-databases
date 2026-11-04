Ylma Cristina Souza Lopes
USE Clinica_Ser;

DELIMITER //

-- PROCEDURE 1
CREATE PROCEDURE sp_agendar_exame (IN p_id_paciente INT, IN p_id_exame INT, IN p_id_medico INT, IN p_data DATETIME)
BEGIN
    INSERT INTO Agendamento (id_paciente, id_exame, id_medico, data_hora)
    VALUES (p_id_paciente, p_id_exame, p_id_medico, p_data);
END //

-- PROCEDURE 2 COM OUT E IF/ELSE
CREATE PROCEDURE sp_verificar_elegibilidade (IN p_id_paciente INT, OUT p_status VARCHAR(50))
BEGIN
    DECLARE v_convenio INT;
    SELECT id_convenio INTO v_convenio FROM Paciente WHERE id_paciente = p_id_paciente;
    
    IF v_convenio IS NOT NULL THEN
        SET p_status = 'Elegível para atendimento via plano';
    ELSE
        SET p_status = 'Atendimento particular';
    END IF;
END //

-- FUNCTION
CREATE FUNCTION fn_calcular_desconto (p_preco DECIMAL(10,2), p_convenio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE desconto DECIMAL(10,2);
    IF p_convenio IS NOT NULL THEN
        SET desconto = p_preco * 0.85; -- 15% de desconto para conveniados
    ELSE
        SET desconto = p_preco;
    END IF;
    RETURN desconto;
END //

DELIMITER ;

-- TESTES COM CALL
CALL sp_agendar_exame(1, 1, 1, '2026-10-15 14:00:00');
CALL sp_verificar_elegibilidade(1, @status);
SELECT @status;

-- TESTES COM SELECT
SELECT tipo_exame, preco, fn_calcular_desconto(preco, 1) AS preco_final FROM Exame;