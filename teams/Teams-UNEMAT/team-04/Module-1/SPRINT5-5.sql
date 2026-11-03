-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Marcos Aurélio Bastos Stanguerlin
-- Tema: Sorveteria e Açaiteria
-- Banco: Rh_sorveteria


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================

CREATE DATABASE Rh_sorveteria;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE Rh_sorveteria;

-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

CREATE TABLE FILIAL (
	id_filial int AUTO_INCREMENT PRIMARY KEY,
	Modulo varchar(20) NOT NULL,
	Localizacao varchar(100) NOT NULL,
    data_abertura DATE NOT NULL
);

CREATE TABLE CARGO (
	id_cargo int AUTO_INCREMENT PRIMARY KEY,
	nome_cargo Varchar(50) NOT NULL,
	salario_base DECIMAL(10,2) NOT NULL,
	carga_horaria int NOT NULL
);

CREATE TABLE PRODUTO (
	id_produto int AUTO_INCREMENT PRIMARY KEY,
	nome_produto varchar(50) NOT NULL
);

CREATE TABLE SETOR (
	id_setor int AUTO_INCREMENT PRIMARY KEY,
    nome_setor varchar(50) NOT NULL
);

CREATE TABLE FUNCIONARIO (
    id_func int AUTO_INCREMENT PRIMARY KEY,
    nome_func Varchar(100) NOT NULL,
	cpf Varchar(11) NOT NULL UNIQUE,
	data_nascimento DATE NOT NULL,
	data_admissao DATE NOT NULL,
    
    id_cargo int NOT NULL,
    id_setor int NOT NULL,
    id_filial int NOT NULL,
    
    FOREIGN KEY (id_cargo)
        REFERENCES CARGO(id_cargo),
	FOREIGN KEY (id_setor)
		REFERENCES SETOR(id_setor),
	FOREIGN KEY (id_filial)
		REFERENCES FILIAL(id_filial)
);

CREATE TABLE EXPEDIENTE (
	id_expediente int AUTO_INCREMENT PRIMARY KEY,
	data_batimento DATE NOT NULL,
	hora_entrada TIME NOT NULL,
	hora_saida TIME NOT NULL,
	hora_extra VARCHAR(10) default 0,
	justificativas varchar(200),
    
    id_func INT NOT NULL,

    FOREIGN KEY (id_func)
        REFERENCES FUNCIONARIO(id_func)
);

CREATE TABLE ESTOQUE (
	quantidade int NOT NULL,
    
    id_filial int NOT NULL,
	id_produto int NOT NULL,
    
    CONSTRAINT fk_estoque_filial
        FOREIGN KEY (id_filial)
        REFERENCES FILIAL(id_filial),

    CONSTRAINT fk_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES PRODUTO(id_produto),
	PRIMARY KEY (id_filial, id_produto)
);

-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================

ALTER TABLE FUNCIONARIO
CHANGE COLUMN cpf cpf_func VARCHAR(11) NOT NULL;




CREATE TABLE tabela_teste (
    id INT PRIMARY KEY
);

DROP TABLE tabela_teste;

-- ============================================================
-- 5. INSERTS
-- ============================================================

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

-- ============================================================
-- 6. UPDATES
-- ============================================================

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

-- ============================================================
-- 7. DELETES
-- ============================================================

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



------------------------------------------------------------------------------------------------------------------------

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

-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================

SELECT * FROM FUNCIONARIO;

SELECT
f.nome_func AS funcionario,
f.data_admissao AS data_admissao
FROM FUNCIONARIO f;

-- ============================================================
-- 9. WHERE
-- ============================================================

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

-- ============================================================
-- 10. ORDER BY
-- ============================================================

SELECT
c.nome_cargo AS cargo,
c.salario_base AS salario
FROM CARGO c
ORDER BY c.salario_base DESC;

-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

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

-- ============================================================
-- 12. GROUP BY
-- ============================================================

SELECT
c.nome_cargo AS cargo,
COUNT(f.id_func) AS quantidade_funcionarios
FROM CARGO c
LEFT JOIN FUNCIONARIO f
ON c.id_cargo = f.id_cargo
GROUP BY c.id_cargo, c.nome_cargo;

-- ============================================================
-- 13. HAVING
-- ============================================================

SELECT
f.id_filial AS filial,
COUNT(f.id_func) AS quantidade_funcionarios
FROM FUNCIONARIO f
GROUP BY f.id_filial
HAVING COUNT(f.id_func) >= 1;

-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================

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


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================


SELECT * FROM FILIAL;
SELECT * FROM CARGO;
SELECT * FROM PRODUTO;
SELECT * FROM SETOR;
SELECT * FROM FUNCIONARIO;
SELECT * FROM EXPEDIENTE;
SELECT * FROM ESTOQUE;
