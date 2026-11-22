
-- View 1

CREATE VIEW vw_funcionarios_sem_expediente AS
SELECT
    f.id_func,
    f.nome_func,
    f.id_filial
FROM FUNCIONARIO f
WHERE NOT EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
);
-- Validação
SELECT *
FROM vw_funcionarios_sem_expediente;

-- View 2

CREATE VIEW vw_resumo_filiais AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    COALESCE(SUM(e.total_horas_extras), 0) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN (
    SELECT
        id_func,
        SUM(CAST(hora_extra AS DECIMAL(10,2))) AS total_horas_extras
    FROM EXPEDIENTE
    GROUP BY id_func
) e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao;

-- Validação
SELECT *
FROM vw_resumo_filiais;

-- View 3

-- DROP VIEW vw_funcionarios_por_filial;

CREATE VIEW vw_funcionarios_por_filial AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao;

-- Validação
SELECT *
FROM vw_funcionarios_por_filial;

-- https://www.youtube.com/watch?v=LuM0KFukml0


-- Replace View

CREATE OR REPLACE VIEW vw_funcionarios_por_filial AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(f.id_func) > 3;
-- Validação
SELECT *
FROM vw_funcionarios_por_filial;

-- DROP VIEW

CREATE VIEW vw_teste AS
SELECT id_produto, nome_produto
FROM PRODUTO;

SELECT *
FROM vw_teste;

DROP VIEW vw_teste;

SELECT *
FROM vw_teste;

-- Validando as View
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- Teste de atualização

START TRANSACTION;

UPDATE FUNCIONARIO
SET id_filial = 2
WHERE id_func = 2;

SELECT *
FROM vw_funcionarios_por_filial;

ROLLBACK;

-- Pratica obrigatoria

CREATE OR REPLACE VIEW  vw_resumo_filiais AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    COALESCE(SUM(e.total_horas_extras), 0) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN (
    SELECT
        id_func,
        SUM(CAST(hora_extra AS DECIMAL(10,2))) AS total_horas_extras
    FROM EXPEDIENTE
    GROUP BY id_func
) e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao;

SELECT *
FROM vw_resumo_filiais;