-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluna: Raquel Silva dos Santos
-- Banco: series_watchlist_db

USE series_watchlist_db;

DELIMITER //

-- PROCEDURE 1
-- Lista as séries cadastradas vinculadas a uma plataforma de streaming informada por parâmetro.
DROP PROCEDURE IF EXISTS sp_listar_series_por_plataforma //
CREATE PROCEDURE sp_listar_series_por_plataforma(
    IN p_nome_plataforma VARCHAR(50)
)
BEGIN
    SELECT 
        s.id_serie,
        s.titulo AS nome_serie,
        s.genero,
        s.ano_lancamento,
        s.pais_origem,
        p.nome_plataforma AS plataforma
    FROM serie AS s
    INNER JOIN plataforma AS p
        ON s.id_plataforma = p.id_plataforma
    WHERE p.nome_plataforma = p_nome_plataforma;
END //

-- PROCEDURE 2
-- Atualiza o status e a nota de um item na watchlist com validação condicional de regras de negócio.

DROP PROCEDURE IF EXISTS sp_atualizar_status_watchlist //
CREATE PROCEDURE sp_atualizar_status_watchlist(
    IN p_id_usuario INT,
    IN p_id_serie INT,
    IN p_novo_status VARCHAR(20),
    IN p_nota TINYINT UNSIGNED
)
BEGIN
    IF p_nota IS NOT NULL AND (p_nota < 0 OR p_nota > 10) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A nota deve ser um número inteiro entre 0 e 10.';
    END IF;

    IF p_novo_status = 'Quero Ver' THEN
        UPDATE item_watchlist
        SET status_assistindo = p_novo_status,
            nota = NULL
        WHERE id_usuario = p_id_usuario 
          AND id_serie = p_id_serie;
        SELECT 'Item atualizado para Quero Ver. A nota foi ajustada para NULL.' AS mensagem;
    ELSE
        UPDATE item_watchlist
        SET status_assistindo = p_novo_status,
            nota = p_nota
        WHERE id_usuario = p_id_usuario 
          AND id_serie = p_id_serie;
        SELECT 'Item atualizado com sucesso.' AS mensagem;
    END IF;
END //

-- PROCEDURE COM OUT
-- Retorna em parâmetros de saída a contagem de séries e a média aritmética das notas de um determinado usuário.
DROP PROCEDURE IF EXISTS sp_resumo_usuario //
CREATE PROCEDURE sp_atualizar_status_watchlist(
    IN p_id_usuario INT,
    IN p_id_serie INT,
    IN p_novo_status VARCHAR(20),
    IN p_nota TINYINT
)
BEGIN
    SELECT 
        COUNT(*),
        ROUND(COALESCE(AVG(nota), 0.0), 1)
    INTO 
        p_total_series,
        p_media_pessoal
    FROM item_watchlist
    WHERE id_usuario = p_id_usuario;
END //

-- FUNCTION
-- Calcula a nota média de uma série e devolve um conceito textual categorizado.
DROP FUNCTION IF EXISTS fn_classificar_desempenho_serie //
CREATE FUNCTION fn_classificar_desempenho_serie(
    p_id_serie INT
)
RETURNS VARCHAR(30)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(3,1);
    DECLARE v_resultado VARCHAR(30);

    SELECT AVG(nota)
    INTO v_media
    FROM item_watchlist
    WHERE id_serie = p_id_serie 
      AND nota IS NOT NULL;

    IF v_media IS NULL THEN
        SET v_resultado = 'Sem Avaliações';
    ELSEIF v_media >= 9.0 THEN
        SET v_resultado = 'Excelente';
    ELSEIF v_media >= 7.0 THEN
        SET v_resultado = 'Bom';
    ELSE
        SET v_resultado = 'Regular / Baixo';
    END IF;

    RETURN v_resultado;
END //

DELIMITER ;

-- TESTES COM CALL

-- Testes da Procedure 1
CALL sp_listar_series_por_plataforma('Netflix');
CALL sp_listar_series_por_plataforma('HBO Max');

-- Testes da Procedure 2
CALL sp_atualizar_status_watchlist(1, 5, 'Assistindo', 8);
CALL sp_atualizar_status_watchlist(1, 5, 'Quero Ver', 9);

-- Testes da Procedure com OUT
CALL sp_resumo_usuario(1, @total, @media);
SELECT @total AS total_series_usuario_1, @media AS media_notas_usuario_1;

CALL sp_resumo_usuario(2, @total, @media);
SELECT @total AS total_series_usuario_2, @media AS media_notas_usuario_2;

-- TESTES COM SELECT

-- Testes da Function
SELECT id_serie, titulo, fn_classificar_desempenho_serie(id_serie) AS resultado 
FROM serie 
WHERE id_serie = 2;

SELECT id_serie, titulo, fn_classificar_desempenho_serie(id_serie) AS resultado 
FROM serie 
WHERE id_serie = 4;
