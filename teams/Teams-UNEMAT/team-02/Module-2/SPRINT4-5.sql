-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluna: Geovanna Gaspar Ribeiro
-- Banco: gerenciamento_incidentes

USE gerenciamento_incidentes;

DELIMITER //

-- ============================================================
-- PROCEDURE 1 — parâmetro IN
-- Lista incidentes filtrados por status
-- ============================================================
CREATE PROCEDURE listar_incidentes_por_status(
    IN p_status VARCHAR(20)
)
BEGIN
    SELECT i.id_incidente,
           i.titulo,
           i.severidade,
           a.nome AS analista
    FROM incidentes i
    JOIN analistas a ON i.id_analista = a.id_analista
    WHERE i.status = p_status;
END //


-- ============================================================
-- PROCEDURE 2 — operação do domínio + IF/ELSE
-- Encerra um incidente, evitando encerrar um já encerrado
-- ============================================================
CREATE PROCEDURE encerrar_incidente(
    IN p_id_incidente INT
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status INTO v_status
    FROM incidentes
    WHERE id_incidente = p_id_incidente;

    IF v_status = 'ENCERRADO' THEN
        SELECT CONCAT('O incidente ', p_id_incidente, ' já está encerrado.') AS mensagem;
    ELSE
        UPDATE incidentes
        SET status = 'ENCERRADO',
            data_encerramento = NOW()
        WHERE id_incidente = p_id_incidente;

        SELECT CONCAT('Incidente ', p_id_incidente, ' encerrado com sucesso.') AS mensagem;
    END IF;
END //


-- ============================================================
-- PROCEDURE COM OUT
-- Conta incidentes de uma determinada severidade
-- ============================================================
CREATE PROCEDURE contar_incidentes_por_severidade(
    IN p_severidade VARCHAR(20),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM incidentes
    WHERE severidade = p_severidade;
END //


-- ============================================================
-- FUNCTION
-- Calcula há quantos dias um incidente está em aberto (ou
-- quantos dias levou para ser resolvido, se já encerrado)
-- ============================================================
CREATE FUNCTION dias_em_aberto(p_id_incidente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_dias INT;

    SELECT TIMESTAMPDIFF(
               DAY,
               data_identificacao,
               IFNULL(data_encerramento, NOW())
           ) INTO v_dias
    FROM incidentes
    WHERE id_incidente = p_id_incidente;

    RETURN v_dias;
END //

DELIMITER ;


-- ============================================================
-- TESTES COM CALL
-- ============================================================

-- Procedure 1
CALL listar_incidentes_por_status('ABERTO');
CALL listar_incidentes_por_status('ENCERRADO');

-- Procedure 2 
CALL encerrar_incidente(2);
CALL encerrar_incidente(2);

-- Procedure com OUT
CALL contar_incidentes_por_severidade('ALTA', @total_alta);
SELECT @total_alta;

CALL contar_incidentes_por_severidade('CRITICA', @total_critica);
SELECT @total_critica;


-- ============================================================
-- TESTES COM SELECT
-- ============================================================
SELECT dias_em_aberto(2);
SELECT dias_em_aberto(5);


