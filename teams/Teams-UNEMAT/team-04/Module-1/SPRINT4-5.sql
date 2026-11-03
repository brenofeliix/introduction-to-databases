USE Rh_sorveteria;

-- 1. Quem foi contratado no dia 1 de setembro?
SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao
FROM FUNCIONARIO f
WHERE DAY(f.data_admissao) = 1
  AND MONTH(f.data_admissao) = 9
ORDER BY f.data_admissao ASC;

-- 2. Quantos funcionários foram contratados no último mês?
SELECT
    COUNT(*) AS quantidade_funcionarios
FROM FUNCIONARIO f
WHERE f.data_admissao >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 3. Quantas filiais foram abertas nos últimos 4 anos?
SELECT
    COUNT(*) AS quantidade_filiais
FROM FILIAL f
WHERE f.data_abertura >= DATE_SUB(CURDATE(), INTERVAL 4 YEAR);

-- 4. Quem fez mais de 50 horas extras neste ano?
SELECT
    f.nome_func AS funcionario,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras
FROM FUNCIONARIO f
JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
WHERE YEAR(e.data_batimento) = YEAR(CURDATE())
GROUP BY f.id_func, f.nome_func
HAVING SUM(CAST(e.hora_extra AS DECIMAL(10,2))) > 50
ORDER BY total_horas_extras DESC;

-- 5. Quais itens estão quase acabando no estoque?
SELECT
    p.nome_produto AS produto,
    e.quantidade AS quantidade_estoque
FROM ESTOQUE e
JOIN PRODUTO p
    ON e.id_produto = p.id_produto
WHERE e.quantidade < 25
ORDER BY e.quantidade ASC;

-- CONSULTAS BÁSICAS

SELECT * FROM FUNCIONARIO;

SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao
FROM FUNCIONARIO f;

-- WHERE

SELECT
    p.nome_produto AS produto,
    e.quantidade AS quantidade_estoque
FROM ESTOQUE e
JOIN PRODUTO p
    ON e.id_produto = p.id_produto
WHERE e.quantidade < 40;

-- Mais de uma condição
SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao,
    f.id_filial AS filial
FROM FUNCIONARIO f
WHERE f.data_admissao >= '2024-01-01'
  AND f.id_filial IN (1, 2, 4);

-- ORDER BY

SELECT
    c.nome_cargo AS cargo,
    c.salario_base AS salario
FROM CARGO c
ORDER BY c.salario_base DESC;

-- FUNÇÕES DE AGREGAÇÃO

SELECT COUNT(*) AS quantidade_funcionarios
FROM FUNCIONARIO;

SELECT SUM(c.salario_base) AS soma_salarios
FROM CARGO c;

SELECT AVG(c.salario_base) AS salario_medio
FROM CARGO c;

SELECT
    MIN(c.salario_base) AS menor_salario,
    MAX(c.salario_base) AS maior_salario
FROM CARGO c;

-- GROUP BY

SELECT
    c.nome_cargo AS cargo,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo
GROUP BY c.id_cargo, c.nome_cargo;

-- HAVING

SELECT
    f.id_filial AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FUNCIONARIO f
GROUP BY f.id_filial
HAVING COUNT(f.id_func) >= 1;

-- EXPRESSÕES SQL

SELECT
    c.nome_cargo AS cargo,
    c.salario_base AS salario_atual,
    c.salario_base * 1.10 AS salario_com_reajuste
FROM CARGO c;

-- CONSULTA MAIS ÚTIL

SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    s.nome_setor AS setor,
    fi.Localizacao AS filial,
    c.salario_base AS salario
FROM FUNCIONARIO f
JOIN CARGO c
    ON f.id_cargo = c.id_cargo
JOIN SETOR s
    ON f.id_setor = s.id_setor
JOIN FILIAL fi
    ON f.id_filial = fi.id_filial
ORDER BY fi.Localizacao ASC, f.nome_func ASC;

-- CONSULTA MAIS COMPLEXA

SELECT
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(DISTINCT f.id_func) >= 1
ORDER BY total_horas_extras DESC;





SELECT * FROM FILIAL;
SELECT * FROM CARGO;
SELECT * FROM PRODUTO;
SELECT * FROM SETOR;
SELECT * FROM FUNCIONARIO;
SELECT * FROM EXPEDIENTE;
SELECT * FROM ESTOQUE;
