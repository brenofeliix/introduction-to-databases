-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 4/5 — CONSULTAS SQL E EXPRESSÕES
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO:
-- TEMA DO BANCO:
-- NOME DO BANCO:
--
-- INSTRUÇÕES:
-- 1. Este arquivo é um MODELO GENÉRICO.
-- 2. Substitua todos os nomes genéricos pelos nomes reais
--    do banco desenvolvido nas Sprints anteriores.
-- 3. Utilize os dados inseridos na SPRINT3-5.sql.
-- 4. Cada consulta deve responder uma pergunta real
--    relacionada ao seu sistema.
-- 5. Execute e teste cada consulta no MySQL Workbench.
-- 6. Não entregue este arquivo sem adaptação.
--
-- ============================================================


-- ============================================================
-- 1. SELECIONAR O BANCO
-- ============================================================

USE nome_do_banco;


-- ============================================================
-- 2. CONSULTA BÁSICA COM SELECT
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui o que esta consulta responde]
--

SELECT *
FROM tabela_a;


-- ============================================================
-- 3. SELECT COM COLUNAS ESPECÍFICAS
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    campo_a1,
    campo_a2
FROM tabela_a;


-- ============================================================
-- 4. CONSULTA COM WHERE
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT *
FROM tabela_a
WHERE campo_numerico > 10;


-- ============================================================
-- 5. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================
--
-- Utilize AND ou OR.
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT *
FROM tabela_a
WHERE campo_numerico > 10
  AND campo_status = 'ATIVO';


-- ============================================================
-- 6. CONSULTA COM LIKE
-- ============================================================
--
-- Utilize apenas se fizer sentido no seu banco.
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT *
FROM tabela_a
WHERE campo_texto LIKE 'A%';


-- ============================================================
-- 7. CONSULTA COM BETWEEN
-- ============================================================
--
-- Utilize para intervalos numéricos ou datas.
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT *
FROM tabela_a
WHERE campo_numerico BETWEEN 10 AND 100;


-- ============================================================
-- 8. CONSULTA COM IN
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT *
FROM tabela_a
WHERE campo_status IN ('ATIVO', 'PENDENTE');


-- ============================================================
-- 9. CONSULTA COM IS NULL OU IS NOT NULL
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT *
FROM tabela_a
WHERE campo_opcional IS NOT NULL;


-- ============================================================
-- 10. CONSULTA COM ORDER BY
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT *
FROM tabela_a
ORDER BY campo_a1 ASC;


-- ============================================================
-- 11. ORDER BY DECRESCENTE
-- ============================================================

SELECT *
FROM tabela_a
ORDER BY campo_numerico DESC;


-- ============================================================
-- 12. ORDER BY COM MAIS DE UMA COLUNA
-- ============================================================

SELECT *
FROM tabela_a
ORDER BY campo_status ASC,
         campo_numerico DESC;


-- ============================================================
-- 13. COUNT
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    COUNT(*) AS total_registros
FROM tabela_a;


-- ============================================================
-- 14. COUNT COM WHERE
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    COUNT(*) AS total_filtrado
FROM tabela_a
WHERE campo_status = 'ATIVO';


-- ============================================================
-- 15. SUM
-- ============================================================
--
-- Utilize quando existir um campo numérico que faça sentido
-- ser somado.
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    SUM(campo_numerico) AS total
FROM tabela_a;


-- ============================================================
-- 16. AVG
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    AVG(campo_numerico) AS media
FROM tabela_a;


-- ============================================================
-- 17. MIN E MAX
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    MIN(campo_numerico) AS menor_valor,
    MAX(campo_numerico) AS maior_valor
FROM tabela_a;


-- ============================================================
-- 18. GROUP BY
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    campo_categoria,
    COUNT(*) AS quantidade
FROM tabela_a
GROUP BY campo_categoria;


-- ============================================================
-- 19. GROUP BY COM AVG
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    campo_categoria,
    AVG(campo_numerico) AS media_por_categoria
FROM tabela_a
GROUP BY campo_categoria;


-- ============================================================
-- 20. GROUP BY COM SUM
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    campo_categoria,
    SUM(campo_numerico) AS total_por_categoria
FROM tabela_a
GROUP BY campo_categoria;


-- ============================================================
-- 21. HAVING
-- ============================================================
--
-- HAVING filtra grupos após o GROUP BY.
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    campo_categoria,
    COUNT(*) AS quantidade
FROM tabela_a
GROUP BY campo_categoria
HAVING COUNT(*) > 1;


-- ============================================================
-- 22. WHERE + GROUP BY + HAVING
-- ============================================================
--
-- Exemplo de consulta mais completa.
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    campo_categoria,
    AVG(campo_numerico) AS media
FROM tabela_a
WHERE campo_status = 'ATIVO'
GROUP BY campo_categoria
HAVING AVG(campo_numerico) > 10;


-- ============================================================
-- 23. EXPRESSÃO SQL
-- ============================================================
--
-- Exemplo de cálculo realizado durante a consulta.
--
-- Pergunta:
-- [Escreva aqui]
--

SELECT
    campo_a1,
    campo_numerico,
    campo_numerico * 1.10 AS valor_calculado
FROM tabela_a;


-- ============================================================
-- 24. EXPRESSÃO COM DOIS CAMPOS
-- ============================================================
--
-- Exemplo:
-- quantidade * valor_unitario
--

SELECT
    campo_a1,
    campo_quantidade,
    campo_valor,
    campo_quantidade * campo_valor AS subtotal
FROM tabela_a;


-- ============================================================
-- 25. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--
-- Explique no SPRINT4-5.md por que ela é útil.
--

-- ESCREVA SUA CONSULTA ABAIXO:



-- ============================================================
-- 26. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--
-- Explique no SPRINT4-5.md qual foi a dificuldade.
--

-- ESCREVA SUA CONSULTA ABAIXO:



-- ============================================================
-- 27. CONSULTAS EXTRAS
-- ============================================================
--
-- Utilize este espaço para consultas adicionais que façam
-- sentido no seu banco.
--

-- Consulta extra 1:



-- Consulta extra 2:



-- Consulta extra 3:



-- ============================================================
-- CHECKLIST ANTES DE SALVAR
-- ============================================================
--
-- Confirme:
--
-- [ ] Substituí nome_do_banco.
-- [ ] Substituí tabela_a e outros nomes genéricos.
-- [ ] Substituí campo_a1, campo_a2 etc.
-- [ ] Utilizei SELECT.
-- [ ] Utilizei WHERE.
-- [ ] Utilizei mais de uma condição.
-- [ ] Utilizei ORDER BY.
-- [ ] Utilizei COUNT.
-- [ ] Utilizei SUM, quando aplicável.
-- [ ] Utilizei AVG, quando aplicável.
-- [ ] Utilizei MIN ou MAX.
-- [ ] Utilizei GROUP BY.
-- [ ] Utilizei HAVING.
-- [ ] Utilizei expressão SQL, quando aplicável.
-- [ ] Cada consulta responde uma pergunta real.
-- [ ] Testei todas as consultas no MySQL Workbench.
-- [ ] Corrigi os erros encontrados.
-- [ ] Salvei o arquivo como SPRINT4-5.sql.
--
-- ============================================================
-- FIM DA SPRINT 4/5
-- ============================================================
