-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS COM DML
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO:
-- TEMA DO BANCO:
-- NOME DO BANCO:
--
-- INSTRUÇÕES:
-- 1. Este arquivo é um MODELO GENÉRICO.
-- 2. Utilize o MESMO banco criado na SPRINT2-5.sql.
-- 3. Substitua todos os nomes genéricos pelos nomes reais
--    das tabelas e colunas do seu projeto.
-- 4. Insira dados coerentes com o domínio do seu banco.
-- 5. Respeite a ordem de inserção quando houver FOREIGN KEY.
-- 6. Execute e teste cada comando no MySQL Workbench.
-- 7. Não entregue este arquivo sem adaptação.
--
-- ============================================================


-- ============================================================
-- 1. SELECIONAR O BANCO
-- ============================================================

USE nome_do_banco;


-- ============================================================
-- 2. INSERTS — TABELA 1
-- ============================================================
--
-- Insira primeiro dados em tabelas independentes.
-- Exemplo de estrutura:
--
-- INSERT INTO tabela_a (campo_a1, campo_a2)
-- VALUES ('Valor 1', 'Valor 2');
--

INSERT INTO tabela_a (
    campo_a1,
    campo_a2
)
VALUES (
    'Valor 1',
    'Valor 2'
);

INSERT INTO tabela_a (
    campo_a1,
    campo_a2
)
VALUES
    ('Valor 3', 'Valor 4'),
    ('Valor 5', 'Valor 6'),
    ('Valor 7', 'Valor 8'),
    ('Valor 9', 'Valor 10');


-- ============================================================
-- 3. INSERTS — TABELA 2
-- ============================================================

INSERT INTO tabela_b (
    campo_b1,
    campo_b2
)
VALUES
    ('Valor B1', 10.00),
    ('Valor B2', 20.00),
    ('Valor B3', 30.00),
    ('Valor B4', 40.00),
    ('Valor B5', 50.00);


-- ============================================================
-- 4. INSERTS — TABELA 3
-- ============================================================
--
-- Exemplo de tabela dependente com FOREIGN KEY.
-- Certifique-se de que o registro referenciado já existe.
--

INSERT INTO tabela_c (
    id_a,
    campo_c1
)
VALUES
    (1, '2026-09-02'),
    (2, '2026-09-03'),
    (3, '2026-09-04'),
    (4, '2026-09-05'),
    (5, '2026-09-06');


-- ============================================================
-- 5. INSERTS — TABELA 4
-- ============================================================
--
-- Exemplo de tabela associativa.
--

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
-- 6. OUTRAS TABELAS DO PROJETO
-- ============================================================
--
-- Caso seu banco possua mais tabelas, continue abaixo.
--
-- Exemplo:
--
-- INSERT INTO tabela_e (
--     campo_e1
-- )
-- VALUES
--     ('Valor E1'),
--     ('Valor E2'),
--     ('Valor E3');
--


-- ============================================================
-- 7. VERIFICAÇÃO APÓS OS INSERTS
-- ============================================================
--
-- Utilize SELECT apenas para conferir os dados nesta Sprint.
--

SELECT * FROM tabela_a;
SELECT * FROM tabela_b;
SELECT * FROM tabela_c;
SELECT * FROM tabela_d;


-- ============================================================
-- 8. TESTES DE RESTRIÇÕES
-- ============================================================
--
-- IMPORTANTE:
-- Os exemplos abaixo devem ser utilizados apenas para compreender
-- o comportamento das restrições.
--
-- Não mantenha comandos propositalmente inválidos no arquivo final.
--
-- Exemplos de testes possíveis:
--
-- UNIQUE:
-- INSERT INTO cliente (email)
-- VALUES ('email_ja_existente@email.com');
--
-- NOT NULL:
-- INSERT INTO cliente (nome)
-- VALUES (NULL);
--
-- FOREIGN KEY:
-- INSERT INTO pedido (id_cliente)
-- VALUES (999999);
--
-- Registre no SPRINT3-5.md o que foi testado e o resultado.
--


-- ============================================================
-- 9. UPDATE 1
-- ============================================================
--
-- Antes de atualizar, consulte o registro.
--

SELECT *
FROM tabela_a
WHERE id_a = 1;

UPDATE tabela_a
SET campo_a1 = 'Valor atualizado'
WHERE id_a = 1;

SELECT *
FROM tabela_a
WHERE id_a = 1;


-- ============================================================
-- 10. UPDATE 2
-- ============================================================

SELECT *
FROM tabela_a
WHERE id_a = 2;

UPDATE tabela_a
SET campo_a2 = 'Outro valor atualizado'
WHERE id_a = 2;

SELECT *
FROM tabela_a
WHERE id_a = 2;


-- ============================================================
-- 11. UPDATE 3
-- ============================================================

SELECT *
FROM tabela_b
WHERE id_b = 1;

UPDATE tabela_b
SET campo_b2 = 99.90
WHERE id_b = 1;

SELECT *
FROM tabela_b
WHERE id_b = 1;


-- ============================================================
-- 12. UPDATE EXTRA
-- ============================================================
--
-- Opcional: utilize este espaço para outros UPDATEs coerentes.
--

-- UPDATE nome_tabela
-- SET campo = novo_valor
-- WHERE condicao;


-- ============================================================
-- 13. DELETE 1
-- ============================================================
--
-- Antes de excluir, consulte o registro.
--

SELECT *
FROM tabela_d
WHERE id_c = 4
  AND id_b = 5;

DELETE FROM tabela_d
WHERE id_c = 4
  AND id_b = 5;


-- ============================================================
-- 14. DELETE 2
-- ============================================================
--
-- Escolha um registro cuja exclusão seja segura.
--

SELECT *
FROM tabela_b
WHERE id_b = 5;

DELETE FROM tabela_b
WHERE id_b = 5;


-- ============================================================
-- 15. DELETE EXTRA
-- ============================================================
--
-- Opcional.
--

-- DELETE FROM nome_tabela
-- WHERE condicao;


-- ============================================================
-- 16. VERIFICAÇÃO FINAL DAS TABELAS
-- ============================================================

SELECT * FROM tabela_a;
SELECT * FROM tabela_b;
SELECT * FROM tabela_c;
SELECT * FROM tabela_d;


-- ============================================================
-- 17. ESPAÇO PARA O CÓDIGO FINAL DO ALUNO
-- ============================================================
--
-- Depois de adaptar e testar:
--
-- 1. remova os exemplos que não pertencem ao seu projeto;
-- 2. mantenha apenas os nomes reais do seu banco;
-- 3. mantenha os INSERTs organizados por tabela;
-- 4. respeite a ordem das FOREIGN KEY;
-- 5. mantenha pelo menos 3 UPDATEs;
-- 6. mantenha pelo menos 2 DELETEs;
-- 7. confira todos os WHERE;
-- 8. execute novamente o script no Workbench;
-- 9. salve como SPRINT3-5.sql.
--


-- ============================================================
-- CHECKLIST FINAL
-- ============================================================
--
-- [ ] Substituí nome_do_banco.
-- [ ] Substituí tabela_a, tabela_b, tabela_c e tabela_d.
-- [ ] Substituí campo_a1, campo_a2 etc.
-- [ ] Utilizei o banco da Sprint 2/5.
-- [ ] Inseri dados nas tabelas independentes primeiro.
-- [ ] Respeitei as FOREIGN KEY.
-- [ ] Procurei inserir pelo menos 5 registros por tabela principal.
-- [ ] Executei pelo menos 3 UPDATEs.
-- [ ] Todos os UPDATEs possuem WHERE adequado.
-- [ ] Executei pelo menos 2 DELETEs.
-- [ ] Todos os DELETEs possuem WHERE adequado.
-- [ ] Verifiquei os dados com SELECT.
-- [ ] Testei o script no MySQL Workbench.
-- [ ] Corrigi os erros encontrados.
-- [ ] Salvei o arquivo como SPRINT3-5.sql.
--
-- ============================================================
-- FIM DA SPRINT 3/5
-- ============================================================
