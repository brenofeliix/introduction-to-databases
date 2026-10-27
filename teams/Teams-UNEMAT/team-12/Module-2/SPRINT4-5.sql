-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

DROP PROCEDURE IF EXISTS sp_listar_imoveis_por_cidade;
DROP PROCEDURE IF EXISTS sp_atualizar_status_agendamento;
DROP PROCEDURE IF EXISTS sp_contar_agendamentos_por_status;
DROP FUNCTION IF EXISTS fn_comissao_corretor;

DELIMITER //

-- PROCEDURE 1
CREATE PROCEDURE sp_listar_imoveis_por_cidade(
    IN p_cidade VARCHAR(100)
)
BEGIN
    SELECT
        id_imovel,
        titulo,
        valor,
        quantidade_comodos
    FROM imovel
    WHERE cidade = p_cidade
    ORDER BY valor ASC;
END //

-- PROCEDURE 2
CREATE PROCEDURE sp_atualizar_status_agendamento(
    IN p_id_agendamento INT,
    IN p_novo_status VARCHAR(50)
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM agendamento
    WHERE id_agendamento = p_id_agendamento;

    IF v_existe = 0 THEN
        SELECT 'Agendamento não encontrado' AS mensagem;
    ELSEIF p_novo_status NOT IN ('Pendente', 'Confirmado', 'Cancelado') THEN
        SELECT 'Status inválido' AS mensagem;
    ELSE
        UPDATE agendamento
        SET status = p_novo_status
        WHERE id_agendamento = p_id_agendamento;

        SELECT 'Status atualizado com sucesso' AS mensagem;
    END IF;
END //

-- PROCEDURE COM OUT
CREATE PROCEDURE sp_contar_agendamentos_por_status(
    IN p_status VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM agendamento
    WHERE status = p_status;
END //

-- FUNCTION
CREATE FUNCTION fn_comissao_corretor(
    p_valor DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_valor * 0.05, 2);
END //

DELIMITER ;

-- TESTES COM CALL
CALL sp_listar_imoveis_por_cidade('Rondonópolis');
CALL sp_listar_imoveis_por_cidade('Alagoas');

CALL sp_contar_agendamentos_por_status('Pendente', @total);
SELECT @total;

CALL sp_contar_agendamentos_por_status('Confirmado', @total);
SELECT @total;

CALL sp_atualizar_status_agendamento(2, 'Confirmado');
SELECT id_agendamento, status FROM agendamento WHERE id_agendamento = 2;

-- Reversão, para manter os dados originais do banco
CALL sp_atualizar_status_agendamento(2, 'Pendente');
SELECT id_agendamento, status FROM agendamento WHERE id_agendamento = 2;

CALL sp_atualizar_status_agendamento(2, 'Aprovado');
CALL sp_atualizar_status_agendamento(99, 'Confirmado');

-- TESTES COM SELECT
SELECT fn_comissao_corretor(450000.00);
SELECT fn_comissao_corretor(240000.00);

SELECT titulo, valor, fn_comissao_corretor(valor) AS comissao
FROM imovel;
