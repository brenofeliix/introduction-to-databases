-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluna: Talita de Oliveira Leite Sete
-- Banco: secretaria_saude

USE secretaria_saude;

DELIMITER //

-- ============================================================
-- PROCEDURE 1 — parâmetro IN
-- Lista os atendimentos de uma unidade de saúde
-- ============================================================
DROP PROCEDURE IF EXISTS sp_atendimentos_por_unidade //
CREATE PROCEDURE sp_atendimentos_por_unidade(IN p_id_unidade INT)
BEGIN
    SELECT a.id_atendimento, a.data_hora, p.nome AS paciente, pf.nome AS profissional,
           a.tipo_atendimento, a.status
    FROM atendimento AS a
    INNER JOIN paciente     AS p  ON p.id_paciente      = a.id_paciente
    INNER JOIN profissional AS pf ON pf.id_profissional = a.id_profissional
    WHERE a.id_unidade = p_id_unidade
    ORDER BY a.data_hora;
END //

-- ============================================================
-- PROCEDURE 2 — operação do domínio, com IF/ELSEIF/ELSE
-- Registra a baixa de uma quantidade de um item do estoque
-- ============================================================
DROP PROCEDURE IF EXISTS sp_baixa_estoque //
CREATE PROCEDURE sp_baixa_estoque(IN p_id_item INT, IN p_quantidade INT)
BEGIN
    DECLARE v_atual INT;

    SELECT quantidade INTO v_atual
    FROM estoque_item
    WHERE id_item = p_id_item;

    IF v_atual IS NULL THEN
        SELECT 'ERRO: item não encontrado' AS resultado;
    ELSEIF p_quantidade <= 0 THEN
        SELECT 'ERRO: a quantidade deve ser maior que zero' AS resultado;
    ELSEIF p_quantidade > v_atual THEN
        SELECT CONCAT('ERRO: estoque insuficiente (disponível: ', v_atual, ')') AS resultado;
    ELSE
        UPDATE estoque_item
        SET quantidade = quantidade - p_quantidade
        WHERE id_item = p_id_item;

        SELECT 'OK: baixa registrada' AS resultado, id_item, nome, quantidade AS quantidade_atual
        FROM estoque_item
        WHERE id_item = p_id_item;
    END IF;
END //

-- ============================================================
-- PROCEDURE 3 — parâmetro OUT
-- Conta os atendimentos de um determinado status
-- ============================================================
DROP PROCEDURE IF EXISTS sp_contar_atendimentos //
CREATE PROCEDURE sp_contar_atendimentos(IN p_status VARCHAR(20), OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM atendimento
    WHERE status = p_status;
END //

-- ============================================================
-- FUNCTION — classifica a situação do estoque
-- ============================================================
DROP FUNCTION IF EXISTS fn_situacao_estoque //
CREATE FUNCTION fn_situacao_estoque(p_quantidade INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE v_situacao VARCHAR(10);

    IF p_quantidade < 50 THEN
        SET v_situacao = 'BAIXO';
    ELSEIF p_quantidade < 200 THEN
        SET v_situacao = 'MÉDIO';
    ELSE
        SET v_situacao = 'ALTO';
    END IF;

    RETURN v_situacao;
END //

DELIMITER ;

-- ============================================================
-- TESTES COM CALL
-- ============================================================

-- Procedure 1 (3 unidades diferentes)
CALL sp_atendimentos_por_unidade(2);
CALL sp_atendimentos_por_unidade(5);
CALL sp_atendimentos_por_unidade(6);

-- Procedure 2 (sucesso e 3 casos de erro)
SELECT id_item, nome, quantidade FROM estoque_item WHERE id_item = 4;
CALL sp_baixa_estoque(4, 5);
CALL sp_baixa_estoque(4, 9999);
CALL sp_baixa_estoque(4, 0);
CALL sp_baixa_estoque(999, 1);

-- Desfaz o teste de baixa (devolve as 5 doses) para não alterar o estoque do projeto
UPDATE estoque_item SET quantidade = quantidade + 5 WHERE id_item = 4;
SELECT id_item, nome, quantidade FROM estoque_item WHERE id_item = 4;

-- Procedure 3 com OUT
CALL sp_contar_atendimentos('REALIZADO', @total);
SELECT @total AS total_realizados;
CALL sp_contar_atendimentos('AGENDADO', @total);
SELECT @total AS total_agendados;
CALL sp_contar_atendimentos('CANCELADO', @total);
SELECT @total AS total_cancelados;

-- ============================================================
-- TESTES COM SELECT (Function)
-- ============================================================
SELECT fn_situacao_estoque(8)   AS qtd_8,
       fn_situacao_estoque(50)  AS qtd_50,
       fn_situacao_estoque(120) AS qtd_120,
       fn_situacao_estoque(800) AS qtd_800;

SELECT nome, quantidade, fn_situacao_estoque(quantidade) AS situacao
FROM estoque_item
ORDER BY quantidade;