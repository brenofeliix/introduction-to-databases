-- MODULE 2 — SPRINT 5/5
-- INTEGRACAO FINAL

-- Aluno: Gabriel Sakaizawa Campos
-- Banco: db_restaurante_sabor

USE db_restaurante_sabor;

-- =====================================================
-- JOINS
-- =====================================================

-- Consulta relacional final: detalhe completo de cada pedido com total
SELECT p.id_pedido, c.nome AS cliente, f.nome AS atendente, m.numero AS mesa,
       p.status, SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM pedido AS p
INNER JOIN cliente     AS c  ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f  ON p.id_funcionario = f.id_funcionario
INNER JOIN mesa        AS m  ON p.id_mesa        = m.id_mesa
INNER JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
GROUP BY p.id_pedido, c.nome, f.nome, m.numero, p.status
ORDER BY p.id_pedido;

-- LEFT JOIN: funcionarios sem nenhum pedido aparecem com NULL
SELECT f.nome AS funcionario, COUNT(p.id_pedido) AS pedidos
FROM funcionario AS f
LEFT JOIN pedido AS p ON f.id_funcionario = p.id_funcionario
GROUP BY f.id_funcionario, f.nome
ORDER BY pedidos DESC, f.nome;

-- =====================================================
-- SUBCONSULTAS
-- =====================================================

-- Subconsulta final: pedidos com total acima da media dos pedidos
SELECT ip.id_pedido, SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM item_pedido AS ip
GROUP BY ip.id_pedido
HAVING SUM(ip.quantidade * ip.preco_unitario) > (
    SELECT AVG(t.total)
    FROM (
        SELECT SUM(quantidade * preco_unitario) AS total
        FROM item_pedido
        GROUP BY id_pedido
    ) AS t
)
ORDER BY total_pedido DESC;

-- NOT EXISTS: funcionarios que nao atenderam nenhum pedido
SELECT f.nome
FROM funcionario AS f
WHERE NOT EXISTS (SELECT 1 FROM pedido AS p WHERE p.id_funcionario = f.id_funcionario);

-- =====================================================
-- VIEWS
-- =====================================================

CREATE OR REPLACE VIEW vw_pedidos_detalhados AS
SELECT p.id_pedido, p.data_pedido, p.status,
       c.nome AS cliente, f.nome AS atendente, m.numero AS mesa
FROM pedido AS p
INNER JOIN cliente     AS c ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f ON p.id_funcionario = f.id_funcionario
INNER JOIN mesa        AS m ON p.id_mesa        = m.id_mesa;

CREATE OR REPLACE VIEW vw_faturamento_por_cliente AS
SELECT c.id_cliente, c.nome AS cliente,
       COUNT(DISTINCT p.id_pedido) AS qtd_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS total_gasto
FROM cliente AS c
INNER JOIN pedido      AS p  ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido AS ip ON p.id_pedido  = ip.id_pedido
GROUP BY c.id_cliente, c.nome;

CREATE OR REPLACE VIEW vw_pedidos_abertos AS
SELECT p.id_pedido, m.numero AS mesa, c.nome AS cliente, f.nome AS atendente,
       SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM pedido AS p
INNER JOIN mesa        AS m  ON p.id_mesa        = m.id_mesa
INNER JOIN cliente     AS c  ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f  ON p.id_funcionario = f.id_funcionario
INNER JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
WHERE p.status = 'aberto'
GROUP BY p.id_pedido, m.numero, c.nome, f.nome;

SELECT * FROM vw_pedidos_abertos ORDER BY mesa;
SELECT * FROM vw_faturamento_por_cliente ORDER BY total_gasto DESC;

-- =====================================================
-- PROCEDURES, FUNCTION E TRIGGER
-- =====================================================

DROP PROCEDURE IF EXISTS sp_pedidos_do_cliente;
DROP PROCEDURE IF EXISTS sp_alterar_status_pedido;
DROP FUNCTION  IF EXISTS fn_total_pedido;
DROP TRIGGER   IF EXISTS trg_item_valida_quantidade;
DROP TRIGGER   IF EXISTS trg_pedido_libera_mesa;

DELIMITER //

-- PROCEDURE final mais util: pedidos de um cliente com total
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

-- PROCEDURE com IF/ELSE: altera status do pedido
CREATE PROCEDURE sp_alterar_status_pedido(
    IN p_id_pedido INT,
    IN p_novo_status VARCHAR(20)
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe FROM pedido WHERE id_pedido = p_id_pedido;

    IF v_existe = 0 THEN
        SELECT CONCAT('Pedido ', p_id_pedido, ' nao encontrado') AS resultado;
    ELSEIF p_novo_status NOT IN ('aberto', 'finalizado', 'cancelado') THEN
        SELECT CONCAT('Status invalido: ', p_novo_status) AS resultado;
    ELSE
        UPDATE pedido SET status = p_novo_status WHERE id_pedido = p_id_pedido;
        SELECT CONCAT('Pedido ', p_id_pedido, ' agora esta ', p_novo_status) AS resultado;
    END IF;
END //

-- FUNCTION final: total de um pedido
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

-- TRIGGER 1 (BEFORE INSERT): impede item com quantidade invalida
CREATE TRIGGER trg_item_valida_quantidade
BEFORE INSERT ON item_pedido
FOR EACH ROW
BEGIN
    IF NEW.quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantidade deve ser maior que zero';
    END IF;
END //

-- TRIGGER 2 (AFTER UPDATE): ao finalizar um pedido, libera a mesa
CREATE TRIGGER trg_pedido_libera_mesa
AFTER UPDATE ON pedido
FOR EACH ROW
BEGIN
    IF NEW.status = 'finalizado' AND OLD.status <> 'finalizado' THEN
        UPDATE mesa SET status = 'livre' WHERE id_mesa = NEW.id_mesa;
    END IF;
END //

DELIMITER ;

-- Testes das rotinas
CALL sp_pedidos_do_cliente(1);
SELECT id_pedido, fn_total_pedido(id_pedido) AS total FROM pedido ORDER BY id_pedido;

-- =====================================================
-- TESTE DO TRIGGER 2 (AFTER UPDATE) — dentro de transacao, desfeito no fim
-- =====================================================

START TRANSACTION;
UPDATE mesa SET status = 'ocupada' WHERE id_mesa = 2;
SELECT 'ANTES' AS momento, p.id_pedido, p.status AS status_pedido, m.status AS status_mesa
FROM pedido AS p INNER JOIN mesa AS m ON p.id_mesa = m.id_mesa WHERE p.id_pedido = 2;

UPDATE pedido SET status = 'finalizado' WHERE id_pedido = 2;
SELECT 'DEPOIS' AS momento, p.id_pedido, p.status AS status_pedido, m.status AS status_mesa
FROM pedido AS p INNER JOIN mesa AS m ON p.id_mesa = m.id_mesa WHERE p.id_pedido = 2;
ROLLBACK;

-- =====================================================
-- TRANSACAO COM COMMIT: registra um novo pedido completo
-- =====================================================

START TRANSACTION;
INSERT INTO pedido (id_cliente, id_mesa, id_funcionario, data_pedido, status)
VALUES (2, 3, 2, CURDATE(), 'aberto');
SET @novo_pedido = LAST_INSERT_ID();
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (@novo_pedido, 1, 1, 45.90),
       (@novo_pedido, 4, 1, 8.50);
COMMIT;

-- Depois do COMMIT o pedido ja e permanente:
SELECT p.id_pedido, c.nome AS cliente, fn_total_pedido(p.id_pedido) AS total
FROM pedido AS p INNER JOIN cliente AS c ON p.id_cliente = c.id_cliente
WHERE p.id_pedido = @novo_pedido;

-- =====================================================
-- TRANSACAO COM ROLLBACK: cria um pedido e desfaz
-- =====================================================

SELECT COUNT(*) AS pedidos_antes FROM pedido;

START TRANSACTION;
INSERT INTO pedido (id_cliente, id_mesa, id_funcionario, data_pedido, status)
VALUES (3, 4, 4, CURDATE(), 'aberto');
SELECT COUNT(*) AS pedidos_dentro_da_transacao FROM pedido;
ROLLBACK;

SELECT COUNT(*) AS pedidos_depois FROM pedido;

-- =====================================================
-- LIMPEZA: remove o pedido criado no teste de COMMIT (volta ao estado do Module-1)
-- =====================================================

DELETE FROM item_pedido WHERE id_pedido = @novo_pedido;
DELETE FROM pedido WHERE id_pedido = @novo_pedido;

-- =====================================================
-- VALIDACAO FINAL
-- =====================================================

SHOW FULL TABLES WHERE Table_type = 'VIEW';
SELECT TRIGGER_NAME, EVENT_MANIPULATION AS evento, ACTION_TIMING AS momento, EVENT_OBJECT_TABLE AS tabela
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'db_restaurante_sabor';
SELECT COUNT(*) AS total_pedidos FROM pedido;
SELECT COUNT(*) AS total_itens FROM item_pedido;

-- =====================================================
-- TESTE DE ERRO DO TRIGGER 1 (BEFORE INSERT)
-- ATENCAO: este comando DEVE gerar o erro 1644
-- "Quantidade deve ser maior que zero". O erro e o resultado esperado.
-- Por isso ele fica por ultimo no arquivo.
-- =====================================================

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (5, 3, 0, 6.00);
