-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2
-- SPRINT 5/5 — STORED PROCEDURES E FUNCTIONS
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Anna Beatriz Oliveira Moura
-- TEMA DO BANCO: Locadora
-- NOME DO BANCO: Locação de Filmes
--
-- ============================================================

USE locacao_de_filmes;


-- ============================================================
-- 1. SELECAO E VERIFICACAO DO BANCO
-- ============================================================

SELECT 'cliente' AS tabela, COUNT(*) AS registros FROM cliente
UNION ALL SELECT 'funcionario', COUNT(*) FROM funcionario
UNION ALL SELECT 'genero', COUNT(*) FROM genero
UNION ALL SELECT 'filme', COUNT(*) FROM filme
UNION ALL SELECT 'locacao', COUNT(*) FROM locacao
UNION ALL SELECT 'item_locacao', COUNT(*) FROM item_locacao;


-- ============================================================
-- 2. CONSULTA RELACIONAL FINAL (SPRINT 1: JOIN)
-- ============================================================
--
-- Pergunta:
-- Quais filmes foram alugados, por quais clientes e por quem?
--

SELECT
    l.id_locacao,
    c.nome AS cliente,
    fu.nome AS funcionario,
    fi.titulo AS filme,
    g.nome AS genero,
    l.data_locacao,
    l.data_devolucao,
    i.valor_diaria
FROM locacao AS l
INNER JOIN cliente AS c ON c.id_cliente = l.id_cliente
INNER JOIN funcionario AS fu ON fu.id_funcionario = l.id_funcionario
INNER JOIN item_locacao AS i ON i.id_locacao = l.id_locacao
INNER JOIN filme AS fi ON fi.id_filme = i.id_filme
INNER JOIN genero AS g ON g.id_genero = fi.id_genero
ORDER BY l.id_locacao, fi.titulo;


-- ============================================================
-- 3. SUBCONSULTA FINAL (SPRINT 2)
-- ============================================================
--
-- Pergunta:
-- Quais filmes possuem avaliacao acima da media do catalogo?
--

SELECT f.id_filme, f.titulo, f.avaliacao
FROM filme AS f
WHERE f.avaliacao > (
    SELECT AVG(f2.avaliacao)
    FROM filme AS f2
)
ORDER BY f.avaliacao DESC;


-- ============================================================
-- 4. VIEW FINAL (SPRINT 3)
-- Consulta reutilizavel de locacoes, com cliente e total de itens.
-- A VIEW nao armazena copia dos registros: consulta as tabelas-base.
-- ============================================================

CREATE OR REPLACE VIEW vw_resumo_locacoes_sprint5 AS
SELECT
    l.id_locacao,
    c.nome AS cliente,
    l.data_locacao,
    l.data_devolucao,
    COUNT(i.id_item) AS quantidade_filmes,
    COALESCE(
        SUM(
            CASE
                WHEN l.data_devolucao IS NULL THEN 0
                WHEN l.data_devolucao < l.data_locacao THEN 0
                ELSE DATEDIFF(l.data_devolucao, l.data_locacao)
                     * i.valor_diaria
            END
        ), 0.00
    ) AS valor_total
FROM locacao AS l
INNER JOIN cliente AS c ON c.id_cliente = l.id_cliente
LEFT JOIN item_locacao AS i ON i.id_locacao = l.id_locacao
GROUP BY l.id_locacao, c.nome, l.data_locacao, l.data_devolucao;

SELECT * FROM vw_resumo_locacoes_sprint5 ORDER BY id_locacao;

-- ============================================================
-- 5. PROCEDURES E FUNCTION (SPRINT 4)
-- Recriadas com os mesmos nomes e a mesma logica da Sprint 4 para
-- que este script possa ser executado novamente sem erro de duplicacao.
-- ATENCAO: DROP abaixo remove apenas essas rotinas, nao dados/tabelas.
-- ============================================================

DROP PROCEDURE IF EXISTS sp_listar_filmes_por_genero;
DROP PROCEDURE IF EXISTS sp_calcular_total_locacao;
DROP FUNCTION IF EXISTS fn_calcular_valor_item;

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
        SET v_valor_total = p_valor_diaria * v_quantidade_dias;
    END IF;

    RETURN v_valor_total;
END$$

CREATE PROCEDURE sp_listar_filmes_por_genero(
    IN p_id_genero INT
)
BEGIN
    DECLARE v_genero_existe INT DEFAULT 0;

    SELECT COUNT(*) INTO v_genero_existe
    FROM genero
    WHERE id_genero = p_id_genero;

    IF v_genero_existe > 0 THEN
        SELECT f.id_filme, f.titulo, f.ano_lancamento,
               f.avaliacao, f.diretor, g.nome AS genero
        FROM filme AS f
        INNER JOIN genero AS g ON g.id_genero = f.id_genero
        WHERE g.id_genero = p_id_genero
        ORDER BY f.titulo;
    ELSE
        SELECT 'Genero nao encontrado' AS mensagem;
    END IF;
END$$

CREATE PROCEDURE sp_calcular_total_locacao(
    IN p_id_locacao INT,
    OUT p_valor_total DECIMAL(10,2)
)
BEGIN
    DECLARE v_locacao_existe INT DEFAULT 0;

    SELECT COUNT(*) INTO v_locacao_existe
    FROM locacao
    WHERE id_locacao = p_id_locacao;

    IF v_locacao_existe > 0 THEN
        SELECT COALESCE(
            SUM(fn_calcular_valor_item(
                i.valor_diaria, l.data_locacao, l.data_devolucao
            )), 0.00
        ) INTO p_valor_total
        FROM locacao AS l
        LEFT JOIN item_locacao AS i ON i.id_locacao = l.id_locacao
        WHERE l.id_locacao = p_id_locacao;
    ELSE
        SET p_valor_total = NULL;
    END IF;
END$$

DELIMITER ;


-- ============================================================
-- TESTES DAS ROTINAS DA SPRINT 4
-- ============================================================

CALL sp_listar_filmes_por_genero(4);
CALL sp_listar_filmes_por_genero(2);

SET @total_locacao = NULL;
CALL sp_calcular_total_locacao(1, @total_locacao);
SELECT @total_locacao AS valor_locacao_1;

SET @total_locacao = NULL;
CALL sp_calcular_total_locacao(2, @total_locacao);
SELECT @total_locacao AS valor_locacao_2;

SELECT fn_calcular_valor_item(8.00, '2026-09-01', '2026-09-04')
       AS valor_item_teste_1;
SELECT fn_calcular_valor_item(10.00, '2026-09-02', '2026-09-05')
       AS valor_item_teste_2;


-- ============================================================
-- 6. TRIGGER FINAL (SPRINT 5)
-- Regra: uma diaria deve ser maior que zero ao cadastrar item.
-- BEFORE INSERT: a validacao ocorre ANTES de gravar o registro.
-- ============================================================

DROP TRIGGER IF EXISTS trg_validar_valor_diaria;

DELIMITER $$

CREATE TRIGGER trg_validar_valor_diaria
BEFORE INSERT ON item_locacao
FOR EACH ROW
BEGIN
    IF NEW.valor_diaria IS NULL OR NEW.valor_diaria <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A diaria deve ser maior que zero';
    END IF;
END$$

DELIMITER ;


-- ============================================================
-- 7. TRANSACAO COM COMMIT + TESTE POSITIVO DO TRIGGER
-- Registra uma locacao temporaria usando cliente e funcionario existentes.
-- Insere um item com diaria valida (8.00); o Trigger permite a insercao.
-- O COMMIT confirma as duas insercoes juntas.
-- ============================================================

SET @id_locacao_teste = NULL;
SET @id_filme_teste = (SELECT MIN(id_filme) FROM filme);

START TRANSACTION;

INSERT INTO locacao (
    id_cliente, id_funcionario, data_locacao, data_devolucao
)
SELECT c.id_cliente, fu.id_funcionario, '2026-11-18', '2026-11-21'
FROM cliente AS c
CROSS JOIN funcionario AS fu
ORDER BY c.id_cliente, fu.id_funcionario
LIMIT 1;

SET @id_locacao_teste = LAST_INSERT_ID();

-- ESTADO ANTES: nenhum item associado a esta nova locacao.
SELECT COUNT(*) AS itens_antes
FROM item_locacao
WHERE id_locacao = @id_locacao_teste;

INSERT INTO item_locacao (id_locacao, id_filme, valor_diaria)
VALUES (@id_locacao_teste, @id_filme_teste, 8.00);

-- ESTADO DEPOIS DO INSERT: 1 item valido dentro da transacao.
SELECT id_item, id_locacao, id_filme, valor_diaria
FROM item_locacao
WHERE id_locacao = @id_locacao_teste;

COMMIT;

-- VERIFICACAO APOS COMMIT: a locacao e seu item permanecem gravados.
SELECT l.id_locacao, c.nome AS cliente, f.titulo AS filme,
       i.valor_diaria, l.data_locacao, l.data_devolucao
FROM locacao AS l
JOIN cliente AS c ON c.id_cliente = l.id_cliente
JOIN item_locacao AS i ON i.id_locacao = l.id_locacao
JOIN filme AS f ON f.id_filme = i.id_filme
WHERE l.id_locacao = @id_locacao_teste;


-- ============================================================
-- 8. TESTE NEGATIVO DO TRIGGER (EXECUTAR SEPARADAMENTE)
-- O comando abaixo esta COMENTADO de proposito, porque deve falhar.
-- Executar apenas o INSERT apos o COMMIT acima e ANTES da limpeza final.
-- A resposta deve retornar erro 1644
-- com a mensagem 'A diaria deve ser maior que zero'.
-- Foi escolhido um filme diferente para nao esbarrar na UNIQUE.
-- ============================================================
--
-- INSERT INTO item_locacao (id_locacao, id_filme, valor_diaria)
-- SELECT @id_locacao_teste, f.id_filme, 0.00
-- FROM filme AS f
-- WHERE f.id_filme <> @id_filme_teste
-- ORDER BY f.id_filme
-- LIMIT 1;
--
-- Apos o erro, confira que nenhum item de diaria 0 foi cadastrado:
-- SELECT * FROM item_locacao
-- WHERE id_locacao = @id_locacao_teste;


-- ============================================================
-- 9. TRANSACAO COM ROLLBACK
-- Simula uma alteracao de diaria que sera desfeita.
-- A diaria original do item de teste e 8.00.
-- ============================================================

SELECT valor_diaria AS diaria_antes_do_rollback
FROM item_locacao
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;

START TRANSACTION;

UPDATE item_locacao
SET valor_diaria = 99.00
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;

SELECT valor_diaria AS diaria_durante_transacao
FROM item_locacao
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;

ROLLBACK;

SELECT valor_diaria AS diaria_depois_do_rollback
FROM item_locacao
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;

-- 10. VALIDACAO FINAL
SELECT * FROM vw_resumo_locacoes_sprint5
WHERE id_locacao = @id_locacao_teste;

SET @total_locacao = NULL;
CALL sp_calcular_total_locacao(@id_locacao_teste, @total_locacao);
SELECT @total_locacao AS valor_locacao_teste;

SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW PROCEDURE STATUS WHERE Db = 'locacao_de_filmes';
SHOW FUNCTION STATUS WHERE Db = 'locacao_de_filmes';
SHOW TRIGGERS FROM locacao_de_filmes;


-- ============================================================
-- 11. LIMPEZA CONTROLADA DOS DADOS TEMPORARIOS
-- Executada APOS as verificacoes, para nao deixar locacoes ficticias.
-- A remocao e restrita ao ID criado nesta execucao.
-- ============================================================

START TRANSACTION;

DELETE FROM item_locacao
WHERE id_locacao = @id_locacao_teste;

DELETE FROM locacao
WHERE id_locacao = @id_locacao_teste;

COMMIT;

-- Deve retornar 0 para as duas contagens.
SELECT
    (SELECT COUNT(*) FROM locacao
     WHERE id_locacao = @id_locacao_teste) AS locacoes_teste_restantes,
    (SELECT COUNT(*) FROM item_locacao
     WHERE id_locacao = @id_locacao_teste) AS itens_teste_restantes;

