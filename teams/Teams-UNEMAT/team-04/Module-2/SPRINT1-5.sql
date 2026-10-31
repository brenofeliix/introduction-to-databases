-- Inner Join 1
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo;

-- Inner Join 2
SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao,
    c.nome_cargo AS cargo
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
WHERE MONTH(f.data_admissao) = 9
ORDER BY f.data_admissao ASC;

-- Left Join
SELECT
    c.nome_cargo AS cargo,
    f.nome_func AS funcionario
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo;
    
-- Right Join
SELECT
    c.nome_cargo AS cargo,
    f.nome_func AS funcionario
FROM FUNCIONARIO f
RIGHT JOIN CARGO c
    ON f.id_cargo = c.id_cargo;
    
-- Join com 3 tabelas
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    s.nome_setor AS setor,
    fi.Localizacao AS filial,
    c.salario_base AS salario
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
INNER JOIN SETOR s
    ON f.id_setor = s.id_setor
INNER JOIN FILIAL fi
    ON f.id_filial = fi.id_filial
ORDER BY fi.Localizacao ASC, f.nome_func ASC;

-- Join com 3 tabelas 2
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

-- Join Where
SELECT
    p.nome_produto AS produto,
    e.quantidade AS quantidade_estoque
FROM ESTOQUE e
INNER JOIN PRODUTO p
    ON e.id_produto = p.id_produto
WHERE e.quantidade < 40;

-- Join order by
SELECT
    f.nome_func AS funcionario,
    c.nome_cargo AS cargo,
    f.data_admissao AS data_admissao
FROM FUNCIONARIO f
INNER JOIN CARGO c
    ON f.id_cargo = c.id_cargo
ORDER BY c.nome_cargo ASC, f.nome_func ASC;

-- Join Group by Agregação
SELECT
    c.nome_cargo AS cargo,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM CARGO c
LEFT JOIN FUNCIONARIO f
    ON c.id_cargo = f.id_cargo
GROUP BY c.id_cargo, c.nome_cargo;




-- Extenção das tabelas originais para estar que faça mais sentido algumas pesquisas novas, 5 são poucas e acho que faz sentido adicionar mais.

-- DROP DATABASE IF EXISTS Rh_sorveteria;

INSERT INTO PRODUTO (nome_produto)
VALUES
    ('Açaí com Morango 300ml'),
    ('Açaí com Banana 500ml'),
    ('Açaí com Leite em Pó 700ml'),
    ('Sorvete de Creme'),
    ('Sorvete de Flocos'),
    ('Sorvete de Limão'),
    ('Sorvete de Pistache'),
    ('Milkshake de Chocolate'),
    ('Milkshake de Morango'),
    ('Casquinha de Baunilha');
    
    INSERT INTO FUNCIONARIO (
    nome_func,
    cpf_func,
    data_nascimento,
    data_admissao,
    id_cargo,
    id_setor,
    id_filial
)
VALUES
    ('Beatriz Almeida', '67890128883', '1998-03-14', '2025-03-10', 2, 1, 1),
    ('Pedro Santos', '97890123452', '1994-07-22', '2025-04-15', 3, 2, 1),
    ('Camila Ferreira', '77890123453', '2000-01-09', '2025-05-05', 2, 1, 2),
    ('Gabriel Costa', '17890123454', '1996-12-18', '2025-05-20', 4, 3, 2),
    ('Juliana Ribeiro', '27890123455', '1993-05-27', '2025-06-02', 5, 4, 3),
    ('Matheus Carvalho', '88890123456', '2001-09-11', '2025-06-16', 2, 1, 4),
    ('Larissa Gomes', '84890123457', '1997-02-06', '2025-07-01', 3, 2, 4),
    ('Felipe Martins', '22890123458', '1990-10-30', '2025-07-14', 1, 5, 3),
    ('Amanda Barbosa', '33890123459', '1999-04-19', '2025-08-04', 2, 1, 5),
    ('Bruno Lima', '33890123460', '1995-06-23', '2025-08-18', 4, 3, 1),
    ('Isabela Rocha', '24890123461', '2002-11-02', '2025-09-01', 3, 2, 2),
    ('Thiago Nunes', '66890123462', '1992-08-15', '2025-09-15', 5, 4, 4),
    ('Letícia Dias', '96890123463', '1998-12-07', '2025-10-06', 2, 1, 5),
    ('Eduardo Monteiro', '67670123464', '1991-03-25', '2025-10-20', 4, 3, 3),
    ('Sofia Cardoso', '67860123465', '2000-07-13', '2025-11-03', 3, 2, 1);
       
    INSERT INTO ESTOQUE (
    quantidade,
    id_filial,
    id_produto
)
VALUES
    (25, 2, 6),
    (30, 3, 7),
    (20, 4, 8),
    (35, 5, 9),
    (40, 4, 10),
    (18, 2, 11),
    (22, 3, 12),
    (15, 4, 13),
    (28, 5, 14),
    (32, 4, 15);
    
SELECT id_func, nome_func
FROM FUNCIONARIO
ORDER BY id_func;
    
INSERT INTO EXPEDIENTE (
    data_batimento,
    hora_entrada,
    hora_saida,
    hora_extra,
    justificativas,
    id_func
)
SELECT
    '2026-10-01',
    '08:00:00',
    '17:00:00',
    '0',
    NULL,
    id_func
FROM FUNCIONARIO
WHERE nome_func IN (
    'Beatriz Almeida',
    'Pedro Santos',
    'Camila Ferreira',
    'Gabriel Costa',
    'Juliana Ribeiro',
    'Matheus Carvalho',
    'Larissa Gomes',
    'Felipe Martins',
    'Amanda Barbosa',
    'Bruno Lima',
    'Isabela Rocha',
    'Thiago Nunes',
    'Letícia Dias',
    'Eduardo Monteiro',
    'Sofia Cardoso'
);