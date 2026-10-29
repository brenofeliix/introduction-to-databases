-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluna: Raquel Silva dos Santos
-- Banco: series_watchlist_db

USE series_watchlist_db;

-- JOINS

-- Listagem analítica de séries com plataforma e contagem de adesão/avaliações
SELECT 
    s.titulo AS serie,
    p.nome_plataforma AS plataforma,
    COUNT(w.id_usuario) AS total_watchlist,
    COUNT(w.nota) AS total_avaliacoes
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY s.id_serie, s.titulo, p.nome_plataforma
ORDER BY total_watchlist DESC;


-- SUBCONSULTAS

-- Lista usuários que atribuíram notas acima da média global do sistema
SELECT 
    u.id_usuario, 
    u.nome, 
    w.id_serie, 
    w.nota
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
WHERE w.nota > (
    SELECT AVG(nota)
    FROM item_watchlist
    WHERE nota IS NOT NULL
);


-- VIEWS

-- Criação da View de painel estatístico por série
CREATE OR REPLACE VIEW vw_estatisticas_series AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    p.nome_plataforma AS plataforma,
    COUNT(w.id_usuario) AS total_watchlist,
    COUNT(w.nota) AS total_avaliacoes,
    MIN(w.nota) AS menor_nota,
    MAX(w.nota) AS maior_nota,
    ROUND(AVG(w.nota), 2) AS media_nota
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY s.id_serie, s.titulo, p.nome_plataforma;


-- PROCEDURES E FUNCTIONS

DELIMITER //

-- Procedure de atualização do status com regra condicional de negócio
DROP PROCEDURE IF EXISTS sp_atualizar_status_watchlist //
CREATE PROCEDURE sp_atualizar_status_watchlist(
    IN p_id_usuario INT,
    IN p_id_serie INT,
    IN p_novo_status VARCHAR(20),
    IN p_nota TINYINT
)
BEGIN
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

-- Function para classificação conceitual do desempenho da série
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


-- TRIGGER

DELIMITER //

-- Triggers para zerar a nota (NULL) caso o status seja 'Quero Ver'
DROP TRIGGER IF EXISTS trg_validar_status_nota_bi //
CREATE TRIGGER trg_validar_status_nota_bi
BEFORE INSERT ON item_watchlist
FOR EACH ROW
BEGIN
    IF NEW.status_assistindo = 'Quero Ver' THEN
        SET NEW.nota = NULL;
    END IF;
END //

DROP TRIGGER IF EXISTS trg_validar_status_nota_bu //
CREATE TRIGGER trg_validar_status_nota_bu
BEFORE UPDATE ON item_watchlist
FOR EACH ROW
BEGIN
    IF NEW.status_assistindo = 'Quero Ver' THEN
        SET NEW.nota = NULL;
    END IF;
END //

DELIMITER ;


-- TRANSAÇÃO COM COMMIT

START TRANSACTION;

-- Cadastro simultâneo de novo usuário e seu primeiro item na watchlist
INSERT INTO usuario (nome, email, data_cadastro)
VALUES ('Juliana Ferreira', 'juliana.f@email.com', '2026-05-10');

SET @id_novo_usuario = LAST_INSERT_ID();

INSERT INTO item_watchlist (id_usuario, id_serie, status_assistindo, nota, comentario)
VALUES (@id_novo_usuario, 1, 'Quero Ver', NULL, 'Adicionada na criação da conta');

COMMIT;


-- TRANSAÇÃO COM ROLLBACK

START TRANSACTION;

-- Operação de teste para ser descartada
INSERT INTO usuario (nome, email, data_cadastro)
VALUES ('Teste Rollback', 'teste.rollback@email.com', '2026-05-10');

DELETE FROM item_watchlist WHERE id_usuario = 1;

ROLLBACK;


-- VALIDAÇÃO FINAL

-- 1. Validação da View
SELECT * FROM vw_estatisticas_series;

-- 2. Validação da Procedure
CALL sp_atualizar_status_watchlist(1, 2, 'Assistindo', 9);

-- 3. Validação da Function
SELECT id_serie, titulo, fn_classificar_desempenho_serie(id_serie) AS classificacao FROM serie;

-- 4. Validação dos Triggers (Tenta atribuir nota 10 em item 'Quero Ver')
UPDATE item_watchlist
SET status_assistindo = 'Quero Ver', nota = 10
WHERE id_usuario = 5 AND id_serie = 5;

SELECT * FROM item_watchlist WHERE id_usuario = 5 AND id_serie = 5;

-- 5. Validação do COMMIT e ROLLBACK
SELECT * FROM usuario WHERE email = 'juliana.f@email.com'; -- Retorna o registro criado pelo COMMIT
SELECT * FROM usuario WHERE email = 'teste.rollback@email.com'; -- Retorna vazio devido ao ROLLBACK
SELECT COUNT(*) AS total_itens_usuario_1 FROM item_watchlist WHERE id_usuario = 1; -- Mantém os itens restaurados pelo ROLLBACK
