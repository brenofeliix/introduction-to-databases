-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 5/5 — INTEGRAÇÃO, VALIDAÇÃO E ENTREGA FINAL
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO:
-- TEMA DO BANCO:
-- NOME DO BANCO:
--
-- INSTRUÇÕES IMPORTANTES:
-- 1. Este arquivo é um MODELO GENÉRICO.
-- 2. Ele deve reunir o projeto completo desenvolvido nas Sprints.
-- 3. Substitua TODOS os nomes genéricos pelos nomes reais.
-- 4. Remova trechos que não façam sentido no seu projeto.
-- 5. Mantenha somente código necessário, organizado e testado.
-- 6. Execute este arquivo do início ao fim no MySQL Workbench.
-- 7. O objetivo é que o banco possa ser reconstruído integralmente.
-- 8. Não entregue este arquivo sem adaptação.
--
-- ============================================================


-- ============================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ============================================================
--
-- Substitua nome_do_banco pelo nome real.
--

CREATE DATABASE IF NOT EXISTS nome_do_banco;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE nome_do_banco;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS INDEPENDENTES
-- ============================================================
--
-- Crie primeiro as tabelas que não dependem de FOREIGN KEY.
--

CREATE TABLE tabela_a (
    id_a INT PRIMARY KEY AUTO_INCREMENT,
    campo_a1 VARCHAR(100) NOT NULL,
    campo_a2 VARCHAR(150) UNIQUE,
    campo_a3 DATE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE tabela_b (
    id_b INT PRIMARY KEY AUTO_INCREMENT,
    campo_b1 VARCHAR(100) NOT NULL,
    campo_b2 DECIMAL(10,2) NOT NULL,
    campo_b3 TEXT
);


-- ============================================================
-- 4. CRIAÇÃO DAS TABELAS RELACIONADAS
-- ============================================================
--
-- Esta tabela depende da tabela_a.
--

CREATE TABLE tabela_c (
    id_c INT PRIMARY KEY AUTO_INCREMENT,
    id_a INT NOT NULL,
    campo_c1 DATE NOT NULL,
    campo_c2 VARCHAR(100),

    CONSTRAINT fk_tabela_c_tabela_a
        FOREIGN KEY (id_a)
        REFERENCES tabela_a(id_a)
);


-- ============================================================
-- 5. TABELA ASSOCIATIVA — EXEMPLO N:N
-- ============================================================
--
-- Utilize apenas se seu projeto possuir relacionamento N:N.
--

CREATE TABLE tabela_d (
    id_c INT NOT NULL,
    id_b INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,

    PRIMARY KEY (id_c, id_b),

    CONSTRAINT fk_tabela_d_tabela_c
        FOREIGN KEY (id_c)
        REFERENCES tabela_c(id_c),

    CONSTRAINT fk_tabela_d_tabela_b
        FOREIGN KEY (id_b)
        REFERENCES tabela_b(id_b)
);


-- ============================================================
-- 6. OUTRAS TABELAS DO PROJETO
-- ============================================================
--
-- Adicione abaixo as demais tabelas reais do seu banco.
--
-- Exemplo:
--
-- CREATE TABLE tabela_e (
--     id_e INT PRIMARY KEY AUTO_INCREMENT,
--     campo_e1 VARCHAR(100) NOT NULL
-- );
--


-- ============================================================
-- 7. ALTER TABLE
-- ============================================================
--
-- Mantenha pelo menos uma alteração estrutural coerente,
-- caso tenha sido utilizada no projeto.
--

ALTER TABLE tabela_a
ADD COLUMN campo_novo VARCHAR(100);


-- ============================================================
-- 8. INSERTS — TABELAS INDEPENDENTES
-- ============================================================
--
-- Insira primeiro os dados das tabelas que não dependem de FK.
--

INSERT INTO tabela_a (
    campo_a1,
    campo_a2,
    campo_a3,
    ativo,
    campo_novo
)
VALUES
    ('Valor A1', 'a1@email.com', '2026-01-10', TRUE, 'Extra 1'),
    ('Valor A2', 'a2@email.com', '2026-02-15', TRUE, 'Extra 2'),
    ('Valor A3', 'a3@email.com', '2026-03-20', TRUE, 'Extra 3'),
    ('Valor A4', 'a4@email.com', '2026-04-25', FALSE, 'Extra 4'),
    ('Valor A5', 'a5@email.com', '2026-05-30', TRUE, 'Extra 5');

INSERT INTO tabela_b (
    campo_b1,
    campo_b2,
    campo_b3
)
VALUES
    ('Valor B1', 10.00, 'Descrição B1'),
    ('Valor B2', 20.00, 'Descrição B2'),
    ('Valor B3', 30.00, 'Descrição B3'),
    ('Valor B4', 40.00, 'Descrição B4'),
    ('Valor B5', 50.00, 'Descrição B5');


-- ============================================================
-- 9. INSERTS — TABELAS RELACIONADAS
-- ============================================================

INSERT INTO tabela_c (
    id_a,
    campo_c1,
    campo_c2
)
VALUES
    (1, '2026-06-01', 'Registro C1'),
    (2, '2026-06-02', 'Registro C2'),
    (3, '2026-06-03', 'Registro C3'),
    (4, '2026-06-04', 'Registro C4'),
    (5, '2026-06-05', 'Registro C5');


-- ============================================================
-- 10. INSERTS — TABELA ASSOCIATIVA
-- ============================================================

INSERT INTO tabela_d (
    id_c,
    id_b,
    quantidade
)
VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 3, 4),
    (3, 4, 2),
    (4, 5, 3);


-- ============================================================
-- 11. VERIFICAÇÃO INICIAL DOS DADOS
-- ============================================================

SELECT * FROM tabela_a;
SELECT * FROM tabela_b;
SELECT * FROM tabela_c;
SELECT * FROM tabela_d;


-- ============================================================
-- 12. UPDATES
-- ============================================================
--
-- Todos os UPDATEs devem possuir WHERE adequado.
--

UPDATE tabela_a
SET campo_a1 = 'Valor A1 Atualizado'
WHERE id_a = 1;

UPDATE tabela_b
SET campo_b2 = 99.90
WHERE id_b = 2;

UPDATE tabela_c
SET campo_c2 = 'Registro C3 Atualizado'
WHERE id_c = 3;


-- ============================================================
-- 13. DELETES
-- ============================================================
--
-- Todos os DELETEs devem possuir WHERE adequado.
-- Garanta que a exclusão não viole FOREIGN KEY.
--

DELETE FROM tabela_d
WHERE id_c = 4
  AND id_b = 5;

DELETE FROM tabela_d
WHERE id_c = 1
  AND id_b = 2;


-- ============================================================
-- 14. CONSULTAS BÁSICAS
-- ============================================================

SELECT *
FROM tabela_a;

SELECT
    campo_a1,
    campo_a2
FROM tabela_a;


-- ============================================================
-- 15. CONSULTAS COM WHERE
-- ============================================================

SELECT *
FROM tabela_a
WHERE ativo = TRUE;

SELECT *
FROM tabela_b
WHERE campo_b2 > 20;


-- ============================================================
-- 16. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================

SELECT *
FROM tabela_a
WHERE ativo = TRUE
  AND campo_a3 >= '2026-03-01';


-- ============================================================
-- 17. ORDER BY
-- ============================================================

SELECT *
FROM tabela_b
ORDER BY campo_b2 ASC;

SELECT *
FROM tabela_b
ORDER BY campo_b2 DESC;


-- ============================================================
-- 18. COUNT
-- ============================================================

SELECT
    COUNT(*) AS total_registros_a
FROM tabela_a;


-- ============================================================
-- 19. SUM
-- ============================================================

SELECT
    SUM(campo_b2) AS soma_valores
FROM tabela_b;


-- ============================================================
-- 20. AVG
-- ============================================================

SELECT
    AVG(campo_b2) AS media_valores
FROM tabela_b;


-- ============================================================
-- 21. MIN E MAX
-- ============================================================

SELECT
    MIN(campo_b2) AS menor_valor,
    MAX(campo_b2) AS maior_valor
FROM tabela_b;


-- ============================================================
-- 22. GROUP BY
-- ============================================================
--
-- Adapte este exemplo a uma coluna categórica real do seu banco.
--

SELECT
    ativo,
    COUNT(*) AS quantidade
FROM tabela_a
GROUP BY ativo;


-- ============================================================
-- 23. HAVING
-- ============================================================

SELECT
    ativo,
    COUNT(*) AS quantidade
FROM tabela_a
GROUP BY ativo
HAVING COUNT(*) > 1;


-- ============================================================
-- 24. EXPRESSÃO SQL
-- ============================================================

SELECT
    campo_b1,
    campo_b2,
    campo_b2 * 1.10 AS valor_com_acrescimo
FROM tabela_b;


-- ============================================================
-- 25. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

-- ESCREVA SUA CONSULTA REAL ABAIXO:



-- ============================================================
-- 26. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
--
-- Pergunta:
-- [Escreva aqui]
--

-- ESCREVA SUA CONSULTA REAL ABAIXO:



-- ============================================================
-- 27. VALIDAÇÃO — SHOW TABLES
-- ============================================================

SHOW TABLES;


-- ============================================================
-- 28. VALIDAÇÃO — DESCRIBE
-- ============================================================

DESCRIBE tabela_a;
DESCRIBE tabela_b;
DESCRIBE tabela_c;
DESCRIBE tabela_d;


-- ============================================================
-- 29. VALIDAÇÃO — SHOW CREATE TABLE
-- ============================================================

SHOW CREATE TABLE tabela_a;
SHOW CREATE TABLE tabela_b;
SHOW CREATE TABLE tabela_c;
SHOW CREATE TABLE tabela_d;


-- ============================================================
-- 30. TESTES DE INTEGRIDADE — DEIXAR COMENTADOS
-- ============================================================
--
-- Os exemplos abaixo servem apenas para verificar restrições.
-- Eles NÃO devem permanecer ativos no script final caso
-- provoquem erros de propósito.
--
-- Teste UNIQUE:
--
-- INSERT INTO tabela_a (
--     campo_a1,
--     campo_a2
-- )
-- VALUES (
--     'Duplicado',
--     'a1@email.com'
-- );
--
-- Teste NOT NULL:
--
-- INSERT INTO tabela_a (
--     campo_a1
-- )
-- VALUES (
--     NULL
-- );
--
-- Teste FOREIGN KEY:
--
-- INSERT INTO tabela_c (
--     id_a,
--     campo_c1
-- )
-- VALUES (
--     999999,
--     '2026-09-03'
-- );
--


-- ============================================================
-- 31. CONSULTAS FINAIS DE CONFERÊNCIA
-- ============================================================

SELECT * FROM tabela_a;
SELECT * FROM tabela_b;
SELECT * FROM tabela_c;
SELECT * FROM tabela_d;


-- ============================================================
-- 32. CHECKLIST FINAL
-- ============================================================
--
-- Antes da entrega, confirme:
--
-- [ ] Substituí nome_do_banco.
-- [ ] Substituí tabela_a, tabela_b, tabela_c e tabela_d.
-- [ ] Substituí todos os nomes genéricos de campos.
-- [ ] O CREATE DATABASE está correto.
-- [ ] O USE está correto.
-- [ ] Todas as tabelas são criadas.
-- [ ] Todas as PRIMARY KEY estão corretas.
-- [ ] Todas as FOREIGN KEY estão corretas.
-- [ ] NOT NULL está coerente.
-- [ ] UNIQUE está coerente.
-- [ ] DEFAULT está coerente.
-- [ ] INSERTs executam corretamente.
-- [ ] UPDATEs possuem WHERE.
-- [ ] DELETEs possuem WHERE.
-- [ ] SELECT funciona.
-- [ ] WHERE funciona.
-- [ ] ORDER BY funciona.
-- [ ] COUNT funciona.
-- [ ] SUM funciona, quando aplicável.
-- [ ] AVG funciona, quando aplicável.
-- [ ] MIN/MAX funcionam.
-- [ ] GROUP BY funciona.
-- [ ] HAVING funciona.
-- [ ] Testei SHOW TABLES.
-- [ ] Testei DESCRIBE.
-- [ ] Testei SHOW CREATE TABLE.
-- [ ] O script executa do início ao fim.
-- [ ] Removi trechos genéricos que não pertencem ao projeto.
-- [ ] Não deixei credenciais ou senhas no arquivo.
-- [ ] Salvei como SPRINT5-5.sql.
--
-- ============================================================
-- FIM DA SPRINT 5/5
-- ============================================================
