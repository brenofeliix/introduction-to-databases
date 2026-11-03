
-- parametro in

DROP PROCEDURE IF EXISTS sp_listar_funcionarios_filial;

DELIMITER //
CREATE PROCEDURE sp_listar_funcionarios_filial(IN p_id_filial INT)
BEGIN
    SELECT
        f.id_func,
        f.nome_func,
        c.nome_cargo,
        f.id_filial
    FROM FUNCIONARIO f
    JOIN CARGO c ON c.id_cargo = f.id_cargo
    WHERE f.id_filial = p_id_filial
    ORDER BY f.nome_func;
END //
DELIMITER ;

CALL sp_listar_funcionarios_filial(1);
CALL sp_listar_funcionarios_filial(3);

-- Operação do dominio

DROP PROCEDURE IF EXISTS sp_consultar_funcionario;

DELIMITER //
CREATE PROCEDURE sp_consultar_funcionario(IN p_id_func INT)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM FUNCIONARIO
        WHERE id_func = p_id_func
    ) THEN
        SELECT
            f.id_func,
            f.nome_func,
            c.nome_cargo,
            s.nome_setor,
            fi.Localizacao AS filial
        FROM FUNCIONARIO f
        JOIN CARGO c ON c.id_cargo = f.id_cargo
        JOIN SETOR s ON s.id_setor = f.id_setor
        JOIN FILIAL fi ON fi.id_filial = f.id_filial
        WHERE f.id_func = p_id_func;
    ELSE
        SELECT 'Funcionário não encontrado' AS mensagem;
    END IF;
END //
DELIMITER ;

CALL sp_consultar_funcionario(1);
CALL sp_consultar_funcionario(99);

-- Procedure OUT

DROP PROCEDURE IF EXISTS sp_contar_funcionarios_filial;

DELIMITER //
CREATE PROCEDURE sp_contar_funcionarios_filial(
    IN p_id_filial INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM FUNCIONARIO
    WHERE id_filial = p_id_filial;
END //
DELIMITER ;

CALL sp_contar_funcionarios_filial(1, @total);
SELECT @total AS total_funcionarios;

CALL sp_contar_funcionarios_filial(3, @total);
SELECT @total AS total_funcionarios;

-- Function

DROP FUNCTION IF EXISTS fn_salario_base_cargo;

DELIMITER //
CREATE FUNCTION fn_salario_base_cargo(p_id_cargo INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_salario DECIMAL(10,2);

    SELECT salario_base INTO v_salario
    FROM CARGO
    WHERE id_cargo = p_id_cargo;

    IF v_salario IS NULL THEN
        RETURN 0.00;
    ELSE
        RETURN v_salario;
    END IF;
END //
DELIMITER ;

SELECT fn_salario_base_cargo(1) AS salario;
SELECT fn_salario_base_cargo(2) AS salario;

-- IF ELSE

CALL sp_consultar_funcionario(1);
CALL sp_consultar_funcionario(99);
SELECT fn_salario_base_cargo(5) AS salario;
