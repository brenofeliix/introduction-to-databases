
USE Rh_sorveteria;

INSERT INTO FILIAL (
    Modulo,
    Localizacao,
    data_abertura
)
VALUES
    ('VAREJO', 'Centro - Rondonópolis', '2022-03-15'),
    ('VAREJO', 'Vila Operária - Rondonópolis', '2023-07-20'),
    ('ADMINISTRAÇÃO', 'Centro - Rondonópolis', '2021-01-10'),
    ('VAREJO', 'Jardim Atlântico - Rondonópolis', '2024-05-12'),
    ('ADMINISTRAÇÃO', 'Jardim Europa - Rondonópolis', '2025-02-18');

INSERT INTO CARGO (
    nome_cargo,
    salario_base,
    carga_horaria
)
VALUES
    ('Gerente', 4500.00, 44),
    ('Atendente', 2200.00, 44),
    ('Caixa', 2100.00, 44),
    ('Auxiliar de Estoque', 2000.00, 44),
    ('Supervisor', 3200.00, 44);

INSERT INTO PRODUTO (
    nome_produto
)
VALUES
    ('Açaí 500ml'),
    ('Sorvete de Chocolate'),
    ('Sorvete de Morango'),
    ('Açaí 700ml'),
    ('Sorvete de Baunilha');

INSERT INTO SETOR (
    nome_setor
)
VALUES
    ('Atendimento'),
    ('Caixa'),
    ('Estoque'),
    ('Produção'),
    ('Administração');

-- FUNCIONARIO deve ser inserido antes de EXPEDIENTE,
-- pois EXPEDIENTE possui FK para FUNCIONARIO.

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
    ('Carlos Henrique', '12345678901', '1988-04-12', '2022-03-20', 1, 5, 3),
    ('Ana Paula', '23456789012', '1995-08-25', '2023-09-01', 2, 1, 1),
    ('Lucas Mendes', '34567890123', '1999-02-10', '2024-01-15', 3, 2, 2),
    ('Mariana Souza', '45678901234', '1992-11-30', '2024-06-01', 4, 3, 4),
    ('Rafael Oliveira', '56789012345', '1985-06-18', '2025-02-25', 5, 4, 5);

INSERT INTO EXPEDIENTE (
    data_batimento,
    hora_entrada,
    hora_saida,
    hora_extra,
    justificativas,
    id_func
)
VALUES
    ('2026-09-01', '08:00:00', '17:00:00', 0, NULL, 1),
    ('2026-09-02', '08:00:00', '18:00:00', 1, 'Aumento de demanda na filial', 2),
    ('2026-09-03', '09:00:00', '18:00:00', 0, NULL, 3),
    ('2026-09-04', '08:00:00', '19:00:00', 2, 'Organização do estoque', 4),
    ('2026-09-05', '07:00:00', '17:00:00', 1, 'Atendimento de demanda extra', 5);

INSERT INTO ESTOQUE (
    quantidade,
    id_filial,
    id_produto
)
VALUES
    (35, 1, 1),
    (20, 2, 2),
    (50, 3, 3),
    (15, 4, 4),
    (40, 5, 5);

-- UPDATES

UPDATE FUNCIONARIO
SET nome_func = 'Anna Paula'
WHERE id_func = 2;

UPDATE CARGO
SET salario_base = 4700.00
WHERE id_cargo = 1;

UPDATE ESTOQUE
SET quantidade = 30
WHERE id_filial = 2
  AND id_produto = 2;

-- TESTES

INSERT INTO FUNCIONARIO (
    nome_func,
    cpf_func,
    data_nascimento,
    data_admissao,
    id_cargo,
    id_setor,
    id_filial
)
VALUES (
    'Teste CPF',
    '12345678901',
    '1990-01-01',
    '2026-09-01',
    1,
    1,
    1
);

INSERT INTO PRODUTO (
    nome_produto
)
VALUES (
    NULL
);

INSERT INTO EXPEDIENTE (
    data_batimento,
    hora_entrada,
    hora_saida,
    hora_extra,
    justificativas,
    id_func
)
VALUES (
    '2026-09-10',
    '08:00:00',
    '17:00:00',
    0,
    NULL,
    999
);

-- DELETE

DELETE FROM EXPEDIENTE
WHERE id_func = 1;

DELETE FROM FUNCIONARIO
WHERE id_func = 1;




SELECT * FROM FILIAL;
SELECT * FROM CARGO;
SELECT * FROM PRODUTO;
SELECT * FROM SETOR;
SELECT * FROM FUNCIONARIO;
SELECT * FROM EXPEDIENTE;
SELECT * FROM ESTOQUE;
