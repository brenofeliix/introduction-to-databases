
-- Subconsulta comparação

SELECT
    f.nome_func AS funcionario,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE c.salario_base > (
    SELECT AVG(salario_base)
    FROM CARGO
)
ORDER BY c.salario_base DESC;

-- Subconsulta IN

SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE f.id_cargo IN (
    SELECT id_cargo
    FROM CARGO
    WHERE nome_cargo IN ('Caixa', 'Atendente')
)
ORDER BY c.nome_cargo, f.nome_func;

-- Subconsulta NOT IN

SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE f.id_func NOT IN (
    SELECT e.id_func
    FROM EXPEDIENTE e
)
ORDER BY f.nome_func;

-- Exists

SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
)
ORDER BY f.nome_func;

-- NOT EXISTS

SELECT
    f.id_func,
    f.nome_func
FROM FUNCIONARIO f
WHERE NOT EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
)
ORDER BY f.nome_func;

-- MAX e MIN

SELECT
    nome_cargo,
    salario_base
FROM CARGO
WHERE salario_base = (
    SELECT MAX(salario_base)
    FROM CARGO
);

-- Subconsulta coreacionada

SELECT
    f.id_func,
    f.nome_func,
    (
        SELECT COUNT(*)
        FROM EXPEDIENTE e
        WHERE e.id_func = f.id_func
    ) AS quantidade_expedientes
FROM FUNCIONARIO f
ORDER BY quantidade_expedientes DESC, f.nome_func;

-- Mesma pergunta de duas formas

SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
ORDER BY f.nome_func;

-- e 

SELECT
    f.nome_func AS funcionario,
    (
        SELECT c.nome_cargo
        FROM CARGO c
        WHERE c.id_cargo = f.id_cargo
    ) AS cargo
FROM FUNCIONARIO f
ORDER BY f.nome_func;

-- Mesma pergunta de duas formas

SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(f.id_func) = (
    SELECT MAX(contagem)
    FROM (
        SELECT COUNT(*) AS contagem
        FROM FUNCIONARIO
        GROUP BY id_filial
    ) AS totais
);

-- e

SELECT
    fi.id_filial,
    fi.Localizacao AS filial
FROM FILIAL fi
WHERE (
    SELECT COUNT(*)
    FROM FUNCIONARIO f
    WHERE f.id_filial = fi.id_filial
) = (
    SELECT MAX(contagem)
    FROM (
        SELECT COUNT(*) AS contagem
        FROM FUNCIONARIO
        GROUP BY id_filial
    ) AS totais
);

SELECT
    f.nome_func AS funcionario,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE c.salario_base > 2000
ORDER BY c.salario_base DESC;