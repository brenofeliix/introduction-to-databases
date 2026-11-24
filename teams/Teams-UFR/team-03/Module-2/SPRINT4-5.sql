-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_restaurante_sabor

USE db_restaurante_sabor;

DROP PROCEDURE IF EXISTS sp_pedidos_do_cliente;
DROP PROCEDURE IF EXISTS sp_alterar_status_pedido;
DROP PROCEDURE IF EXISTS sp_total_do_pedido;
DROP FUNCTION  IF EXISTS fn_total_pedido;
DROP FUNCTION  IF EXISTS fn_faixa_pedido;

DELIMITER //

-- PROCEDURE 1 (parametro IN): lista os pedidos de um cliente com o total de cada um
CREATE PROCEDURE sp_pedidos_do_cliente(IN p_id_cliente INT)
BEGIN
    SELECT p.id_pedido, p.data_pedido, p.status,
           SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
    FROM pedido AS p
    INNER JOIN item_pedido AS ip ON p.id_pedido = ip.id_pedido
    WHERE p.id_cliente = p_id_cliente
    GROUP BY p.id_pedido, p.data_pedido, p.status
    ORDER BY p.id_pedido;
END //

-- PROCEDURE 2 (operacao do dominio + IF/ELSE): altera o status de um pedido
CREATE PROCEDURE sp_alterar_status_pedido(
    IN p_id_pedido INT,
    IN p_novo_status VARCHAR(20)
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM pedido
    WHERE id_pedido = p_id_pedido;

    IF v_existe = 0 THEN
        SELECT CONCAT('Pedido ', p_id_pedido, ' nao encontrado') AS resultado;
    ELSEIF p_novo_status NOT IN ('aberto', 'finalizado', 'cancelado') THEN
        SELECT CONCAT('Status invalido: ', p_novo_status) AS resultado;
    ELSE
        UPDATE pedido
        SET status = p_novo_status
        WHERE id_pedido = p_id_pedido;
        SELECT CONCAT('Pedido ', p_id_pedido, ' agora esta ', p_novo_status) AS resultado;
    END IF;
END //

-- PROCEDURE COM OUT: devolve o total de um pedido em uma variavel
CREATE PROCEDURE sp_total_do_pedido(
    IN  p_id_pedido INT,
    OUT p_total DECIMAL(10,2)
)
BEGIN
    SELECT COALESCE(SUM(quantidade * preco_unitario), 0)
    INTO p_total
    FROM item_pedido
    WHERE id_pedido = p_id_pedido;
END //

-- FUNCTION 1: retorna o total de um pedido
CREATE FUNCTION fn_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(quantidade * preco_unitario), 0)
    INTO v_total
    FROM item_pedido
    WHERE id_pedido = p_id_pedido;

    RETURN v_total;
END //

-- FUNCTION 2 (IF/ELSE): classifica o pedido pela faixa de valor
CREATE FUNCTION fn_faixa_pedido(p_id_pedido INT)
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SET v_total = fn_total_pedido(p_id_pedido);

    IF v_total >= 100 THEN
        RETURN 'Alto';
    ELSEIF v_total >= 50 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Baixo';
    END IF;
END //

DELIMITER ;

-- TESTES COM CALL (2 por rotina)
CALL sp_pedidos_do_cliente(1);
CALL sp_pedidos_do_cliente(4);

CALL sp_alterar_status_pedido(5, 'finalizado');
SELECT id_pedido, status FROM pedido WHERE id_pedido = 5;
CALL sp_alterar_status_pedido(5, 'aberto');
CALL sp_alterar_status_pedido(5, 'xpto');
CALL sp_alterar_status_pedido(99, 'aberto');
SELECT id_pedido, status FROM pedido WHERE id_pedido = 5;

CALL sp_total_do_pedido(4, @total);
SELECT @total AS total_pedido_4;
CALL sp_total_do_pedido(5, @total);
SELECT @total AS total_pedido_5;

-- TESTES COM SELECT (Functions)
SELECT fn_total_pedido(1) AS total_pedido_1, fn_total_pedido(4) AS total_pedido_4;
SELECT id_pedido, fn_total_pedido(id_pedido) AS total, fn_faixa_pedido(id_pedido) AS faixa
FROM pedido
ORDER BY id_pedido;
