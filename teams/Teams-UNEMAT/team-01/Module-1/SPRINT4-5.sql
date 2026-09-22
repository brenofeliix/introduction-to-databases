-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- Aluna     : Raquel Silva dos Santos
-- Banco     : series_watchlist_db
-- ============================================================

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE series_watchlist_db;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================

-- 1.1 SELECT básico
-- Pergunta: Quais são todas as plataformas cadastradas no sistema?
SELECT * 
FROM plataforma;

-- 1.2 SELECT com colunas específicas e aliases (Seção 4 do Markdown)
-- Pergunta: Qual é a listagem geral das séries do catálogo com seus títulos, gêneros e anos de lançamento?
SELECT 
    titulo AS nome_da_serie, 
    genero AS categoria, 
    ano_lancamento AS ano_estreia
FROM serie;

-- ============================================================
-- 2. WHERE
-- ============================================================

-- 2.1 WHERE com condição simples (Pergunta 1 da Sprint 1 / Seção 5 do Markdown)
-- Pergunta: Quais séries cadastradas pertencem à plataforma "Netflix" (id_plataforma = 1)?
SELECT id_serie, titulo, genero, ano_lancamento
FROM serie
WHERE id_plataforma = 1;

-- 2.2 WHERE com mais de uma condição (Pergunta 4 da Sprint 1)
-- Pergunta: Quais séries cadastradas são do gênero "Drama" e foram lançadas a partir de 2020?
SELECT titulo, genero, ano_lancamento, pais_origem
FROM serie
WHERE genero LIKE '%Drama%' 
  AND ano_lancamento >= 2020;

-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- 3.1 ORDER BY com múltiplas colunas (Seção 6 do Markdown)
-- Pergunta: Como listar o catálogo de séries ordenado da produção mais recente para a mais antiga e, em caso de empate de ano, em ordem alfabética?
SELECT titulo, ano_lancamento, genero
FROM serie
ORDER BY ano_lancamento DESC, titulo ASC;

-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- 4.1 COUNT com filtro WHERE e agrupamento (Pergunta 3 da Sprint 1 / Seção 8 do Markdown)
-- Pergunta: Quantas séries cada usuário tem marcadas com o status "Finalizada" (registrado como 'Concluído')?
SELECT 
    id_usuario, 
    COUNT(*) AS total_finalizados
FROM item_watchlist
WHERE status_assistindo = 'Finalizado'
GROUP BY id_usuario;

-- 4.2 SUM (Seção 8 do Markdown)
-- Pergunta: Qual é o somatório total de pontos atribuídos pelas notas válidas registradas na plataforma?
SELECT SUM(nota) AS somatorio_pontos_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL;

-- 4.3 AVG com GROUP BY 
-- Pergunta: Qual é a média das notas de cada série calculada a partir das avaliações dos usuários?
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_notas,
    COUNT(nota) AS volume_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie;

-- 4.4 MIN e MAX 
-- Pergunta: Quais foram as notas extremas (menor e maior avaliação) registradas no banco de dados?
SELECT 
    MIN(nota) AS menor_nota,
    MAX(nota) AS maior_nota
FROM item_watchlist;

-- ============================================================
-- 5. GROUP BY
-- ============================================================

-- 5.1 GROUP BY obrigatório 
-- Pergunta: Qual é a média de notas obtida por cada série a partir das resenhas registradas?
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_notas,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie;

-- ============================================================
-- 6. HAVING
-- ============================================================

-- 6.1 HAVING obrigatório 
-- Pergunta: Entre as séries avaliadas, quais obtiveram média de aprovação excelente (nota média maior ou igual a 9.0)?
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_notas,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie
HAVING AVG(nota) >= 9.0;

-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================

-- 7.1 Expressão aritmética com anos 
-- Pergunta: Há quantos anos cada série foi lançada em relação ao ano atual (2026)?
SELECT 
    titulo,
    ano_lancamento,
    (2026 - ano_lancamento) AS anos_desde_lancamento
FROM serie
ORDER BY anos_desde_lancamento ASC;

-- ============================================================
-- CONSULTAS EXTRAS (INTEGRADA)
-- ============================================================

-- Consulta Extra: GROUP BY + AVG + ORDER BY + LIMIT 
-- Pergunta: Qual é o top 3 de séries com as maiores notas médias entre os usuários?
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_final,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie
ORDER BY media_final DESC
LIMIT 3;
