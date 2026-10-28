-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluno: Vinícius Eduardo Lima de Assis
-- Banco: pacote_viagens

USE pacote_viagens;

-- ============================================================
-- DEFINIÇÃO DAS ROTINAS (DELIMITER //)
-- ============================================================

DELIMITER //

-- ------------------------------------------------------------
-- PROCEDURE 1: Buscar Hospedagens por Destino (Parâmetro IN)
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_buscar_hospedagens_destino //

CREATE PROCEDURE sp_buscar_hospedagens_destino(
    IN p_id_destino INT
)
BEGIN
    SELECT 
        h.id_hospedagem,
        h.nome AS hospedagem,
        h.tipo,
        h.valor_diaria,
        d.nome AS destino
    FROM hospedagem AS h
    INNER JOIN destino AS d ON h.id_destino = d.id_destino
    WHERE h.id_destino = p_id_destino;
END //

-- ------------------------------------------------------------
-- PROCEDURE 2: Resumo de Reservas do Cliente (Operação do Domínio)
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_resumo_cliente //

CREATE PROCEDURE sp_resumo_cliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        c.nome AS cliente,
        r.id_reserva,
        r.data_reserva,
        r.quantidade_pessoas,
        h.nome AS hospedagem,
        t.empresa AS transporte
    FROM reserva_pacote AS r
    INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
    INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
    INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte
    WHERE c.id_cliente = p_id_cliente;
END //

-- ------------------------------------------------------------
-- PROCEDURE 3: Contar Reservas do Cliente (Uso de OUT)
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_contar_reservas_cliente //

CREATE PROCEDURE sp_contar_reservas_cliente(
    IN p_id_cliente INT,
    OUT p_total_reservas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_reservas
    FROM reserva_pacote
    WHERE id_cliente = p_id_cliente;
END //

-- ------------------------------------------------------------
-- FUNCTION 1: Calcular Valor Total da Reserva por Pessoas
-- ------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_calcular_valor_total_reserva //

CREATE FUNCTION fn_calcular_valor_total_reserva(
    p_id_reserva INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_valor_diaria DECIMAL(10,2);
    DECLARE v_qtd_pessoas INT;
    DECLARE v_total DECIMAL(10,2);

    SELECT h.valor_diaria, r.quantidade_pessoas
    INTO v_valor_diaria, v_qtd_pessoas
    FROM reserva_pacote AS r
    INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
    WHERE r.id_reserva = p_id_reserva;

    SET v_total = v_valor_diaria * v_qtd_pessoas;

    RETURN v_total;
END //

-- ------------------------------------------------------------
-- FUNCTION 2: Classificar Categoria da Hospedagem (IF / ELSE)
-- ------------------------------------------------------------
DROP FUNCTION IF EXISTS fn_classificar_hospedagem //

CREATE FUNCTION fn_classificar_hospedagem(
    p_id_hospedagem INT
)
RETURNS VARCHAR(30)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_valor DECIMAL(10,2);
    DECLARE v_categoria VARCHAR(30);

    SELECT valor_diaria INTO v_valor
    FROM hospedagem
    WHERE id_hospedagem = p_id_hospedagem;

    IF v_valor IS NULL THEN
        SET v_categoria = 'Não Encontrada';
    ELSEIF v_valor <= 700.00 THEN
        SET v_categoria = 'Econômica';
    ELSEIF v_valor <= 1500.00 THEN
        SET v_categoria = 'Intermediária';
    ELSE
        SET v_categoria = 'Alto Padrão / Luxo';
    END IF;

    RETURN v_categoria;
END //

DELIMITER ;

-- ============================================================
-- TESTES COM CALL (PROCEDURES)
-- ============================================================

-- Teste 1 da Procedure 1
CALL sp_buscar_hospedagens_destino(1);
-- Teste 2 da Procedure 1
CALL sp_buscar_hospedagens_destino(2);

-- Teste 1 da Procedure 2
CALL sp_resumo_cliente(1);
-- Teste 2 da Procedure 2
CALL sp_resumo_cliente(3);

-- Teste 1 da Procedure 3 (com parâmetro OUT)
CALL sp_contar_reservas_cliente(1, @total_c1);
SELECT @total_c1 AS reservas_cliente_1;

-- Teste 2 da Procedure 3 (com parâmetro OUT)
CALL sp_contar_reservas_cliente(2, @total_c2);
SELECT @total_c2 AS reservas_cliente_2;

-- ============================================================
-- TESTES COM SELECT (FUNCTIONS)
-- ============================================================

-- Testes da Function 1 (Cálculo total da reserva)
SELECT 
    id_reserva, 
    id_cliente, 
    fn_calcular_valor_total_reserva(id_reserva) AS subtotal_calculado
FROM reserva_pacote
WHERE id_reserva = 1;

SELECT 
    id_reserva, 
    id_cliente, 
    fn_calcular_valor_total_reserva(id_reserva) AS subtotal_calculado
FROM reserva_pacote
WHERE id_reserva = 3;

-- Testes da Function 2 (Classificação IF/ELSE)
SELECT 
    nome, 
    valor_diaria, 
    fn_classificar_hospedagem(id_hospedagem) AS categoria
FROM hospedagem
WHERE id_hospedagem = 3;

SELECT 
    nome, 
    valor_diaria, 
    fn_classificar_hospedagem(id_hospedagem) AS categoria
FROM hospedagem
WHERE id_hospedagem = 5;