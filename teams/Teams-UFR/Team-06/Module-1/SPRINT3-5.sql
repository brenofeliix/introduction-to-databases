-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS COM DML
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Anna Beatriz Oliveira Moura
-- TEMA DO BANCO: Locadora
-- NOME DO BANCO: Locação de Filmes
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

USE locacao_de_filmes;


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

INSERT INTO cliente (
    nome,
    cpf,
    telefone,
    email
)
VALUES 
    ('Tatum Riley', '022.015.504-12', '(66) 99999-1111', 'tatum@email.com'),
    ('Stiles Stilinski', '078.780.868-77', '(66) 99999-2222', 'stiles@email.com'),
    ('Kirby Reed', '759.033.418-96', '(66) 99999-3333', 'kirby@email.com'),
    ('John Snow', '441.696.558-34', '(66) 99999-4444', 'john@email.com'),
    ('Beatrice Prior', '578.768.538-54', '(66) 99999-5555', 'beatrice@email.com'),
    ('Hannah Klinkers', '321.654.987-00', '(66) 99999-6262', 'hannah@email.com');


-- ============================================================
-- 3. INSERTS — TABELA 2
-- ============================================================

INSERT INTO funcionario (
    nome,
    cpf,
    cargo,
    telefone
)
VALUES
    ('Randy Meeks', '560.816.798-88', 'Gerente', '(66) 98888-1111'),
    ('Steve Harrington', '662.069.598-13', 'Atendete', '(66) 98888-2222'),
    ('Robin Buckley', '287.234.808-58', 'Atendente', '(66) 98888-3333'),
    ('Noah Foster', '402.531.878-42', 'Atendente', '(66) 98888-4444'),
    ('Karen Kolchak', '091.750.158-62', 'Gerente', '(66) 98888-5555');


-- ============================================================
-- 4. INSERTS — TABELA 3
-- ============================================================

INSERT INTO genero (
    nome,
    descricao,
    classificado
)
VALUES
    ('Ação', 'Filmes com ritmo acelerado, lutas, perseguições e conflitos físicos', '12 anos'),
    ('Comédia', 'Filmes feitos para divertir e provocar o riso no público', 'Livre'),
    ('Drama', 'Filmes com narrativas sérias que exploram conflitos emocionais e dilemas humanos profundos', '12 anos'),
    ('Terror', 'Filmes criados para gerar medo, tensão e sustos nos espectadores', '16 anos'),
    ('Ficção Científica', 'Filmes com tramas baseadas em avanços tecnológicos, espaço ou futuros alternativos', '12 anos'),
    ('Romance', 'Filmes com histórias centradas em paixões, relacionamentos e laços afetivos', '14 anos');


-- ============================================================
-- 5. INSERTS — TABELA 4
-- ============================================================
    
INSERT INTO filme (
    titulo,
    ano_lancamento,
    avaliacao,
    diretor,
    id_genero
)
VALUES
    ('A Chance', 1983, 6.0, 'Michael Chapman', 3),
	('Orgulho e Preconceito', 2005, 7.8, 'Joe Wright', 6),
	('Star Wars: Episódio V - O Império Contra-Ataca', 1980, 8.7, 'Irvin Kershner', 5),
    ('Psicose', 1960, 8.5, 'Alfred Hitchcock', 4),
    ('Transformers', 2007, 7.1, 'Michael Bay', 1),
    ('Perdido pra Cachorro', 2008, 4.0, 'Raja Gosnell', 2);


-- ============================================================
-- 6. INSERTS — TABELA 5
-- ============================================================

INSERT INTO locacao (
    id_cliente,
    id_funcionario,
    data_locacao,
    data_devolucao
)
VALUES
    (1, 3, '2026-09-01', '2026-09-04'),
    (2, 2, '2026-09-02', '2026-09-05'),
    (3, 1, '2026-09-03', '2026-09-06'),
    (4, 3, '2026-09-04', '2026-09-07'),
    (5, 4, '2026-09-05', '2026-09-08');


-- ============================================================
-- 7. INSERTS - TABELA 6
-- ============================================================
--

INSERT INTO item_locacao (
    id_locacao,
    id_filme,
    valor_diaria
)
VALUES
    (1, 1, 8.00),
    (1, 2, 8.00),
    (2, 3, 10.00),
    (3, 4, 9.00),
    (4, 5, 8.00),
    (5, 6, 7.00);
    

-- ============================================================
-- 7. VERIFICAÇÃO APÓS OS INSERTS
-- ============================================================
--
-- Utilize SELECT apenas para conferir os dados nesta Sprint.
--

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM genero;
SELECT * FROM filme;
SELECT * FROM locacao;
SELECT * FROM item_locacao;


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

-- Verificar o registro antes da alteração.
SELECT *
FROM funcionario
WHERE id_funcionario = 2;

-- Corrigir o cargo do funcionário Steve Harrington.
UPDATE funcionario
SET cargo = 'Atendente'
WHERE id_funcionario = 2;

-- Verificar o registro após a alteração.
SELECT *
FROM funcionario
WHERE id_funcionario = 2;


-- ============================================================
-- 10. UPDATE 2
-- ============================================================

-- Verificar a avaliação atual do filme.
SELECT *
FROM filme
WHERE id_filme = 5;

-- Atualizar a avaliação de Transformers.
UPDATE filme
SET avaliacao = 7.5
WHERE id_filme = 5;

-- Conferir a alteração.
SELECT *
FROM filme
WHERE id_filme = 5;


-- ============================================================
-- 11. UPDATE 3
-- ============================================================

-- Verificar o telefone atual do cliente.
SELECT *
FROM cliente
WHERE id_cliente = 2;

-- Atualizar o telefone de Stiles Stilinski.
UPDATE cliente
SET telefone = '(66) 99999-7777'
WHERE id_cliente = 2;

-- Conferir a alteração.
SELECT *
FROM cliente
WHERE id_cliente = 2;


-- ============================================================
-- 12. UPDATE EXTRA
-- ============================================================
--
-- Opcional: utilize este espaço para outros UPDATEs coerentes.
--

-- UPDATE nome_tabela
-- SET campo = novo_valor
-- WHERE condicao;

-- Não foram necessárias outras alterações.


-- ============================================================
-- 13. DELETE 1
-- ============================================================
--
-- Antes de excluir, consulte o registro.
--

-- Verificar se o cliente está cadastrado.
SELECT *
FROM cliente
WHERE id_cliente = 6;

-- Conferir se ele possui alguma locação vinculada.
SELECT *
FROM locacao
WHERE id_cliente = 6;

-- Excluir o cliente sem locações.
DELETE FROM cliente
WHERE id_cliente = 6;

-- Conferir se a exclusão foi realizada.
SELECT *
FROM cliente
WHERE id_cliente = 6;


-- ============================================================
-- 14. DELETE 2
-- ============================================================
--
-- Escolha um registro cuja exclusão seja segura.
--

-- Verificar o item antes da exclusão.
SELECT *
FROM item_locacao
WHERE id_locacao = 1
AND id_filme = 2;

-- Excluir o filme 2 da locação 1.
DELETE FROM item_locacao
WHERE id_locacao = 1
AND id_filme = 2;

-- Conferir os itens restantes da locação.
SELECT *
FROM item_locacao
WHERE id_locacao = 1;


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

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM genero;
SELECT * FROM filme;
SELECT * FROM locacao;
SELECT * FROM item_locacao;

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
