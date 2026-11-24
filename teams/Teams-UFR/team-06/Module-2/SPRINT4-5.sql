-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2
-- SPRINT 4/5 — STORED PROCEDURES E FUNCTIONS
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Anna Beatriz Oliveira Moura
-- TEMA DO BANCO: Locadora
-- NOME DO BANCO: Locação de Filmes
--
-- Objetivo:
-- Criar rotinas reutilizaveis para consultar filmes,
-- calcular valores de locacoes e calcular valores de itens.
--
-- ============================================================

USE locacao_de_filmes;


-- ============================================================
-- 1. PREPARACAO PARA REEXECUCAO
-- ============================================================
-- Remove somente as rotinas deste arquivo, se ja existirem.
-- Nao remove tabelas nem registros do banco.

DROP PROCEDURE IF EXISTS sp_listar_filmes_por_genero;
DROP PROCEDURE IF EXISTS sp_calcular_total_locacao;
DROP FUNCTION IF EXISTS fn_calcular_valor_item;


-- 2. FUNCTION - CALCULAR VALOR DE UM ITEM
-- ============================================================
-- Recebe o valor da diaria e as datas da locacao.
-- Retorna o valor total daquele item.
--
-- A funcao sera utilizada pela Procedure de calculo
-- do valor total da locacao.

DELIMITER $$

CREATE FUNCTION fn_calcular_valor_item(
    p_valor_diaria DECIMAL(10,2),
    p_data_locacao DATE,
    p_data_devolucao DATE
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_quantidade_dias INT DEFAULT 0;
    DECLARE v_valor_total DECIMAL(10,2) DEFAULT 0.00;

    IF p_valor_diaria IS NULL
       OR p_valor_diaria < 0
       OR p_data_locacao IS NULL
       OR p_data_devolucao IS NULL
       OR p_data_devolucao < p_data_locacao
    THEN
        SET v_valor_total = 0.00;

    ELSE
        SET v_quantidade_dias =
            DATEDIFF(p_data_devolucao, p_data_locacao);

        SET v_valor_total =
            p_valor_diaria * v_quantidade_dias;
    END IF;

    RETURN v_valor_total;
END$$


-- 3. PROCEDURE 1 - LISTAR FILMES POR GENERO
-- ============================================================
-- Recebe o ID de um genero.
-- Verifica se o genero existe.
-- Se existir, lista os filmes relacionados.
-- Caso contrario, apresenta uma mensagem.

CREATE PROCEDURE sp_listar_filmes_por_genero(
    IN p_id_genero INT
)
BEGIN
    DECLARE v_genero_existe INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_genero_existe
    FROM genero
    WHERE id_genero = p_id_genero;

    IF v_genero_existe > 0 THEN

        SELECT
            f.id_filme,
            f.titulo,
            f.ano_lancamento,
            f.avaliacao,
            f.diretor,
            g.nome AS genero
        FROM filme AS f
        INNER JOIN genero AS g
            ON f.id_genero = g.id_genero
        WHERE g.id_genero = p_id_genero
        ORDER BY f.titulo;

    ELSE

        SELECT
            'Genero nao encontrado' AS mensagem;

    END IF;
END$$


-- 4. PROCEDURE 2 - CALCULAR TOTAL DE UMA LOCACAO
-- ============================================================
-- Recebe o ID da locacao (IN).
-- Devolve o valor total calculado (OUT).
-- Utiliza a Function fn_calcular_valor_item.

CREATE PROCEDURE sp_calcular_total_locacao(
    IN p_id_locacao INT,
    OUT p_valor_total DECIMAL(10,2)
)
BEGIN
    DECLARE v_locacao_existe INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_locacao_existe
    FROM locacao
    WHERE id_locacao = p_id_locacao;

    IF v_locacao_existe > 0 THEN

        SELECT
            COALESCE(
                SUM(
                    fn_calcular_valor_item(
                        i.valor_diaria,
                        l.data_locacao,
                        l.data_devolucao
                    )
                ),
                0.00
            )
        INTO p_valor_total
        FROM locacao AS l
        LEFT JOIN item_locacao AS i
            ON l.id_locacao = i.id_locacao
        WHERE l.id_locacao = p_id_locacao;

    ELSE

        SET p_valor_total = NULL;

    END IF;
END$$


-- 5. FINALIZAR A DEFINICAO DAS ROTINAS
-- ============================================================

DELIMITER ;


-- ============================================================
-- 6. TESTES DA PROCEDURE 1
-- Listar filmes de generos diferentes.
-- ============================================================

-- Teste 1: genero Terror
CALL sp_listar_filmes_por_genero(4);

-- Teste 2: genero Comedia
CALL sp_listar_filmes_por_genero(2);

-- Teste adicional: ID de genero inexistente
CALL sp_listar_filmes_por_genero(999);


-- ============================================================
-- 7. TESTES DA PROCEDURE 2 - PARAMETRO OUT
-- ============================================================

-- Teste 1: calcular o valor da locacao 1

SET @total_locacao = 0;

CALL sp_calcular_total_locacao(1, @total_locacao);

SELECT @total_locacao AS valor_total_locacao_1;


-- Teste 2: calcular o valor da locacao 2

SET @total_locacao = 0;

CALL sp_calcular_total_locacao(2, @total_locacao);

SELECT @total_locacao AS valor_total_locacao_2;


-- Teste adicional: ID de locacao inexistente

SET @total_locacao = 0;

CALL sp_calcular_total_locacao(999, @total_locacao);

SELECT @total_locacao AS valor_locacao_inexistente;


-- ============================================================
-- 8. TESTES DA FUNCTION
-- ============================================================

-- Teste 1: diaria de R$ 8,00 por 3 dias

SELECT
    fn_calcular_valor_item(
        8.00,
        '2026-09-01',
        '2026-09-04'
    ) AS valor_item_1;


-- Teste 2: diaria de R$ 10,00 por 3 dias

SELECT
    fn_calcular_valor_item(
        10.00,
        '2026-09-02',
        '2026-09-05'
    ) AS valor_item_2;


-- Teste adicional: datas de devolucao invalidas

SELECT
    fn_calcular_valor_item(
        8.00,
        '2026-09-04',
        '2026-09-01'
    ) AS valor_com_datas_invalidas;


-- ============================================================
-- 9. FUNCTION APLICADA AOS DADOS DO BANCO
-- ============================================================
-- Demonstra o uso da Function em uma consulta real.

SELECT
    l.id_locacao,
    f.titulo,
    i.valor_diaria,
    l.data_locacao,
    l.data_devolucao,
    fn_calcular_valor_item(
        i.valor_diaria,
        l.data_locacao,
        l.data_devolucao
    ) AS valor_item
FROM locacao AS l
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS f
    ON i.id_filme = f.id_filme
ORDER BY l.id_locacao, f.titulo;


-- ============================================================
-- 10. VALIDACAO DAS ROTINAS CRIADAS
-- ============================================================

SHOW PROCEDURE STATUS
WHERE Db = 'locacao_de_filmes';

SHOW FUNCTION STATUS
WHERE Db = 'locacao_de_filmes';

