-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 4/5 — CONSULTAS SQL E EXPRESSÕES
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Anna Beatriz Oliveira Moura
-- TEMA DO BANCO: Locadora
-- NOME DO BANCO: Locação de Filmes
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

USE locacao_de_filmes;


-- ============================================================
-- 2. CONSULTA BÁSICA COM SELECT
-- ============================================================
--
-- Pergunta:
-- Quais clientes estão cadastrados na locadora?
--

SELECT *
FROM cliente;


-- ============================================================
-- 3. SELECT COM COLUNAS ESPECÍFICAS
-- ============================================================
--
-- Pergunta:
-- Quais filmes estão cadastrados e quais são suas avaliações?
--

SELECT
    titulo,
    ano_lancamento,
    avaliacao
FROM filme;


-- ============================================================
-- 4. CONSULTA COM WHERE
-- ============================================================
--
-- Pergunta:
-- Quais filmes possuem avaliação igual ou superior a 7,0?
--

SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao >= 7.0;


-- ============================================================
-- 5. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================
--
-- Utilize AND ou OR.
--
-- Pergunta:
-- Quais filmes foram lançados a partir do ano 2000 e possuem avaliação igual ou superior a 7,0?
--

SELECT
    titulo,
    ano_lancamento,
    avaliacao
FROM filme
WHERE ano_lancamento >= 2000
  AND avaliacao >= 7.0;


-- ============================================================
-- 6. CONSULTA COM LIKE
-- ============================================================
--
-- Utilize apenas se fizer sentido no seu banco.
--
-- Pergunta:
-- Quais clientes possuem nome iniciado pela letra T?
--

SELECT
    nome,
    telefone,
    email
FROM cliente
WHERE nome LIKE 'T%';

-- ============================================================
-- 7. CONSULTA COM BETWEEN
-- ============================================================
--
-- Utilize para intervalos numéricos ou datas.
--
-- Pergunta:
-- Quais filmes possuem avaliação entre 7,0 e 9,0?
--

SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao BETWEEN 7.0 AND 9.0;


-- ============================================================
-- 8. CONSULTA COM ORDER BY
-- ============================================================
--
-- Pergunta:
-- Quais filmes possuem as maiores avaliações?
--

SELECT
    titulo,
    avaliacao
FROM filme
ORDER BY avaliacao DESC;


-- ============================================================
-- 9. COUNT
-- ============================================================
--
-- Pergunta:
-- Quantas locações foram realizadas na locadora?
--

SELECT
    COUNT(*) AS total_locacoes
FROM locacao;


-- ============================================================
-- 10. SUM
-- ============================================================
--
-- Utilize quando existir um campo numérico que faça sentido
-- ser somado.
--
-- Pergunta:
-- Qual foi o valor total da locação 1?
--

SELECT
    l.id_locacao,
    SUM(
        DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria
    ) AS valor_total
FROM locacao AS l
JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
WHERE l.id_locacao = 1
GROUP BY l.id_locacao;


-- ============================================================
-- 11. AVG
-- ============================================================
--
-- Pergunta:
-- Qual é a avaliação média dos filmes cadastrados?
--

SELECT
    ROUND(AVG(avaliacao), 2) AS media_avaliacoes
FROM filme;


-- ============================================================
-- 12. MIN E MAX
-- ============================================================
--
-- Pergunta:
-- Quais são a menor e a maior avaliação dos filmes cadastrados?
--

SELECT
    MIN(avaliacao) AS menor_avaliacao,
    MAX(avaliacao) AS maior_avaliacao
FROM filme;


-- ============================================================
-- 13. GROUP BY
-- ============================================================
--
-- Pergunta:
-- Quantas locações cada cliente realizou?
--

SELECT
    c.nome AS cliente,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM cliente AS c
LEFT JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
GROUP BY
    c.id_cliente,
    c.nome;


-- ============================================================
-- 14. HAVING
-- ============================================================
--
-- HAVING filtra grupos após o GROUP BY.
--
-- Pergunta:
-- Quais funcionários registraram mais de uma locação?
--

SELECT
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome
HAVING COUNT(l.id_locacao) > 1;


-- ============================================================
-- 15. EXPRESSÃO SQL
-- ============================================================
--
-- Exemplo de cálculo realizado durante a consulta.
--
-- Pergunta:
-- Qual foi o valor de cada item considerando a quantidade de dias da locação?
--

SELECT
    l.id_locacao,
    f.titulo,
    DATEDIFF(l.data_devolucao, l.data_locacao) AS quantidade_dias,
    i.valor_diaria,
    DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria AS valor_calculado
FROM item_locacao AS i
JOIN locacao AS l
    ON i.id_locacao = l.id_locacao
JOIN filme AS f
    ON i.id_filme = f.id_filme;


-- ============================================================
-- 16. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Qual foi o valor total de cada locação?
--
-- Explique no SPRINT4-5.md por que ela é útil.
--

-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    l.id_locacao,
    c.nome AS cliente,
    SUM(
        DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria
    ) AS valor_total
FROM locacao AS l
JOIN cliente AS c
    ON l.id_cliente = c.id_cliente
JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
GROUP BY
    l.id_locacao,
    c.nome
ORDER BY l.id_locacao;


-- ============================================================
-- 17. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Quais filmes foram mais alugados?
--
-- Explique no SPRINT4-5.md qual foi a dificuldade.
--

-- ESCREVA SUA CONSULTA ABAIXO:

SELECT
    f.titulo,
    g.nome AS genero,
    COUNT(i.id_filme) AS quantidade_locacoes
FROM filme AS f
JOIN genero AS g
    ON f.id_genero = g.id_genero
JOIN item_locacao AS i
    ON f.id_filme = i.id_filme
GROUP BY
    f.id_filme,
    f.titulo,
    g.nome
ORDER BY quantidade_locacoes DESC;


-- ============================================================
-- 18. CONSULTAS EXTRAS
-- ============================================================
--
-- Utilize este espaço para consultas adicionais que façam
-- sentido no seu banco.
--

-- Consulta extra 1: Quais filmes estão cadastrados e quais são seus respectivos gêneros?

SELECT
    f.titulo,
    g.nome AS genero
FROM filme AS f
JOIN genero AS g
    ON f.id_genero = g.id_genero
ORDER BY f.titulo ASC;

-- Consulta extra 2: Quais funcionários registraram locações?

SELECT DISTINCT
    f.nome AS funcionario,
    f.cargo
FROM funcionario AS f
JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
ORDER BY f.nome ASC;

-- Consulta extra 3: Quantos filmes existem cadastrados em cada gênero?

SELECT
    g.nome AS genero,
    COUNT(f.id_filme) AS quantidade_filmes
FROM genero AS g
LEFT JOIN filme AS f
    ON g.id_genero = f.id_genero
GROUP BY
    g.id_genero,
    g.nome;


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
