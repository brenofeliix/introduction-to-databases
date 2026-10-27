-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO E VALIDAÇÃO FINAL

-- Aluno: Vinícius Eduardo Lima de Assis
-- Banco: pacote_viagens

USE pacote_viagens;

-- ============================================================
-- 1. JOINS (CONSULTA RELACIONAL)
-- ============================================================
SELECT 
    r.id_reserva,
    c.nome AS cliente,
    h.nome AS hospedagem,
    h.valor_diaria,
    t.empresa AS transporte,
    d.nome AS destino
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte
INNER JOIN destino AS d ON h.id_destino = d.id_destino;

-- ============================================================
-- 2. SUBCONSULTAS
-- ============================================================
SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria > (
    SELECT AVG(valor_diaria)
    FROM hospedagem
);

-- ============================================================
-- 3. VIEWS
-- ============================================================
CREATE OR REPLACE VIEW vw_detalhes_reservas AS
SELECT 
    r.id_reserva,
    c.nome AS nome_cliente,
    c.email AS email_cliente,
    h.nome AS nome_hospedagem,
    t.empresa AS empresa_transporte,
    t.tipo AS tipo_transporte,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte;

-- Consulta da VIEW
SELECT * FROM vw_detalhes_reservas;

-- ============================================================
-- 4. PROCEDURES E FUNCTIONS (COM DELIMITER)
-- ============================================================
DELIMITER //

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

-- ============================================================
-- 5. TRIGGER (VALIDAÇÃO DE DIÁRIA MAIOR QUE ZERO)
-- ============================================================
DROP TRIGGER IF EXISTS trg_validar_valor_diaria_bi //
CREATE TRIGGER trg_validar_valor_diaria_bi
BEFORE INSERT ON hospedagem
FOR EACH ROW
BEGIN
    IF NEW.valor_diaria <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: O valor da diária deve ser maior que zero.';
    END IF;
END //

DELIMITER ;

-- ============================================================
-- 6. TESTE DE TRIGGER (TESTE DE BLOQUEIO DE VALOR INVÁLIDO)
-- ============================================================
-- Este INSERT deve falhar e ser retido pelo Trigger:
-- INSERT INTO hospedagem (nome, endereco, tipo, valor_diaria, id_destino)
-- VALUES ('Hotel Inválido', 'Rua X', 'Hotel', 0.00, 1);

-- ============================================================
-- 7. TRANSAÇÃO COM COMMIT
-- ============================================================
START TRANSACTION;

INSERT INTO cliente (nome, cpf, email, telefone, ativo)
VALUES ('Fernando Rocha', '987.654.321-99', 'fernando.rocha@email.com', '(11) 91111-2222', TRUE);

SET @novo_id_cliente = LAST_INSERT_ID();

INSERT INTO reserva_pacote (id_cliente, id_hospedagem, id_transporte, data_reserva, quantidade_pessoas)
VALUES (@novo_id_cliente, 1, 1, '2026-11-10', 2);

COMMIT;

-- Verificar inserção confirmada
SELECT * FROM cliente WHERE cpf = '987.654.321-99';

-- ============================================================
-- 8. TRANSAÇÃO COM ROLLBACK
-- ============================================================
START TRANSACTION;

INSERT INTO cliente (nome, cpf, email, telefone, ativo)
VALUES ('Cliente Teste Rollback', '000.111.222-33', 'teste.rollback@email.com', '(00) 00000-0000', TRUE);

-- Desfaz o comando anterior
ROLLBACK;

-- Verificar que o cliente NÃO foi inserido
SELECT * FROM cliente WHERE cpf = '000.111.222-33';

-- ============================================================
-- 9. VALIDAÇÃO FINAL DO SISTEMA
-- ============================================================
CALL sp_buscar_hospedagens_destino(1);
SELECT fn_calcular_valor_total_reserva(1) AS subtotal_reserva_1;
SHOW FULL TABLES WHERE Table_type = 'VIEW';