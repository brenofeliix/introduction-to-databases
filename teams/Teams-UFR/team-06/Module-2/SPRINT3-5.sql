-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2
-- SPRINT 3/5 — VIEWS E ABSTRACAO DE CONSULTAS
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
-- 1. PREPARACAO PARA REEXECUCAO
-- Remove somente as Views deste exercicio, se existirem.
-- Nenhuma tabela-base ou registro sera removido.
-- ============================================================

DROP VIEW IF EXISTS vw_teste;
DROP VIEW IF EXISTS vw_filmes_acima_media;
DROP VIEW IF EXISTS vw_detalhes_locacoes;
DROP VIEW IF EXISTS vw_resumo_locacoes_funcionario;
DROP VIEW IF EXISTS vw_filmes_generos;


-- ============================================================
-- 2. VIEW 1 - FILMES E GENEROS
-- Consulta reaproveitada da Sprint 1: INNER JOIN.
-- ============================================================
--
-- Pergunta da VIEW: 
-- Quais filmes estão cadastrados e a qual gênero cada um pertence?
--

CREATE VIEW vw_filmes_generos AS
SELECT
    f.id_filme,
    f.titulo,
    g.nome AS genero
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;


-- Teste da View 1
SELECT *
FROM vw_filmes_generos;


-- ============================================================
-- 3. VIEW 2 - RESUMO DE LOCACOES POR FUNCIONARIO
-- Consulta reaproveitada da Sprint 1:
-- LEFT JOIN + COUNT + GROUP BY.
-- ============================================================
--
-- Pergunta da VIEW:
-- Quantas locações cada funcionário registrou, incluindo aqueles que não registraram nenhuma?
--

CREATE VIEW vw_resumo_locacoes_funcionario AS
SELECT
    f.id_funcionario,
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome;


-- Teste da View 2
SELECT *
FROM vw_resumo_locacoes_funcionario
ORDER BY quantidade_locacoes DESC;


-- ============================================================
-- 4. VIEW 3 - DETALHES DAS LOCACOES
-- Consulta operacional: cliente, filme, funcionario e datas.
-- ============================================================

CREATE VIEW vw_detalhes_locacoes AS
SELECT
    l.id_locacao,
    c.id_cliente,
    c.nome AS cliente,
    fun.id_funcionario,
    fun.nome AS funcionario,
    i.id_item,
    fi.id_filme,
    fi.titulo AS filme,
    l.data_locacao,
    l.data_devolucao,
    i.valor_diaria
FROM locacao AS l
INNER JOIN cliente AS c
    ON l.id_cliente = c.id_cliente
INNER JOIN funcionario AS fun
    ON l.id_funcionario = fun.id_funcionario
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS fi
    ON i.id_filme = fi.id_filme;


-- Teste da View 3
SELECT *
FROM vw_detalhes_locacoes
ORDER BY id_locacao, id_item;


-- ============================================================
-- 5. VIEW COMPLEMENTAR - FILMES ACIMA DA MEDIA
-- Consulta reaproveitada da Sprint 2: subconsulta + AVG.
-- ============================================================

CREATE VIEW vw_filmes_acima_media AS
SELECT
    f.id_filme,
    f.titulo,
    f.avaliacao
FROM filme AS f
WHERE f.avaliacao > (
    SELECT AVG(f2.avaliacao)
    FROM filme AS f2
);


-- Teste da View complementar
SELECT *
FROM vw_filmes_acima_media;


-- ============================================================
-- 6. CONSULTANDO UMA VIEW COM FILTRO
-- ============================================================

SELECT *
FROM vw_filmes_generos
WHERE id_filme = 1;


-- ============================================================
-- 7. CREATE OR REPLACE VIEW
-- Atualiza a View de filmes, acrescentando informacoes.
-- O nome real do campo na tabela genero e classificado
-- no banco anterior como "classificado".
-- ============================================================

CREATE OR REPLACE VIEW vw_filmes_generos AS
SELECT
    f.id_filme,
    f.titulo,
    f.ano_lancamento,
    f.avaliacao,
    f.diretor,
    g.nome AS genero,
    g.classificado AS classificacao
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;


-- Teste da View atualizada
SELECT *
FROM vw_filmes_generos;


-- ============================================================
-- 8. DROP VIEW - EXERCICIO CONTROLADO
-- Cria uma View temporaria e depois a remove.
-- ============================================================

CREATE VIEW vw_teste AS
SELECT
    id_filme,
    titulo
FROM filme;

-- Verifica a View temporaria antes de remove-la
SELECT *
FROM vw_teste;

-- Remove somente a View temporaria
DROP VIEW vw_teste;


-- ============================================================
-- 9. VALIDACAO - LISTA TODAS AS VIEWS DO BANCO
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ============================================================
-- 10. TESTE DE ATUALIZACAO DA TABELA-BASE
-- Execute este bloco por inteiro.
-- A transacao sera desfeita com ROLLBACK.
-- O diretor original sera preservado.
-- ============================================================

-- Confere o valor original
SELECT id_filme, titulo, diretor
FROM vw_filmes_generos
WHERE id_filme = 1;

START TRANSACTION;

-- Altera temporariamente o diretor do filme 1
UPDATE filme
SET diretor = 'DIRETOR TEMPORARIO PARA TESTE'
WHERE id_filme = 1;

-- Confere a mudanca refletida na View
SELECT id_filme, titulo, diretor
FROM vw_filmes_generos
WHERE id_filme = 1;

-- Desfaz a alteracao de teste
ROLLBACK;

-- Confirma que o valor original foi restaurado
SELECT id_filme, titulo, diretor
FROM vw_filmes_generos
WHERE id_filme = 1;

