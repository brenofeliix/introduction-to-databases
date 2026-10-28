-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 5/5 — INTEGRAÇÃO, VALIDAÇÃO E ENTREGA FINAL
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Anna Beatriz Oliveira Moura
-- TEMA DO BANCO: Locadora
-- NOME DO BANCO: Locação de Filmes
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

CREATE DATABASE IF NOT EXISTS locacao_de_filmes;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE locacao_de_filmes;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS INDEPENDENTES
-- ============================================================
--
-- Crie primeiro as tabelas que não dependem de FOREIGN KEY.
--

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),

    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE genero (
    id_genero INT PRIMARY KEY AUTO_INCREMENT,

    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200),
    classificado VARCHAR(50),
    
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- 4. CRIAÇÃO DAS TABELAS RELACIONADAS
-- ============================================================
--
-- Esta tabela depende de genero.
--

CREATE TABLE filme (
    id_filme INT PRIMARY KEY AUTO_INCREMENT,

    titulo VARCHAR(150) NOT NULL,
    ano_lancamento YEAR NOT NULL,
    avaliacao DECIMAL(3,1),
    diretor VARCHAR(100) NOT NULL,
    id_genero INT NOT NULL,

    CONSTRAINT fk_filme_genero
        FOREIGN KEY (id_genero)
        REFERENCES genero(id_genero)
);

--
-- Esta tabela depende de cliente e funcionario.
--

CREATE TABLE locacao (
    id_locacao INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_locacao DATE NOT NULL DEFAULT (CURRENT_DATE),
    data_devolucao DATE,

    CONSTRAINT fk_locacao_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_locacao_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionario(id_funcionario)
        
);


-- ============================================================
-- 5. TABELA ASSOCIATIVA — EXEMPLO N:N
-- ============================================================
--
-- Criação de tabela associativa item_locacao
--

CREATE TABLE item_locacao (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_locacao INT NOT NULL,
    id_filme INT NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_item_locacao
        FOREIGN KEY (id_locacao)
        REFERENCES locacao(id_locacao),

    CONSTRAINT fk_item_filme
        FOREIGN KEY (id_filme)
        REFERENCES filme(id_filme),
        
    CONSTRAINT uq_item_locacao_filme
        UNIQUE (id_locacao, id_filme)
        
);


-- ============================================================
-- 6. OUTRAS TABELAS DO PROJETO
-- ============================================================
--
-- Todas as tabelas necessárias para o banco de dados foram colocadas;
--


-- ============================================================
-- 7. ALTER TABLE
-- ============================================================
--
-- Mantenha pelo menos uma alteração estrutural coerente,
-- caso tenha sido utilizada no projeto.
--

ALTER TABLE filme
MODIFY COLUMN titulo VARCHAR(150) NOT NULL;


-- ============================================================
-- 8. INSERTS — TABELAS INDEPENDENTES
-- ============================================================
--
-- Insira primeiro os dados das tabelas que não dependem de FK.
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
-- 9. INSERTS — TABELAS RELACIONADAS
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
-- 10. INSERTS — TABELA ASSOCIATIVA
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
-- 11. VERIFICAÇÃO INICIAL DOS DADOS
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM genero;
SELECT * FROM filme;
SELECT * FROM locacao;
SELECT * FROM item_locacao;


-- ============================================================
-- 12. UPDATES
-- ============================================================
--
-- Todos os UPDATEs devem possuir WHERE adequado.
--

UPDATE funcionario
SET cargo = 'Atendente'
WHERE id_funcionario = 2;

UPDATE filme
SET avaliacao = 7.5
WHERE id_filme = 5;

UPDATE cliente
SET telefone = '(66) 99999-7777'
WHERE id_cliente = 2;


-- ============================================================
-- 13. DELETES
-- ============================================================
--
-- Todos os DELETEs devem possuir WHERE adequado.
-- Garanta que a exclusão não viole FOREIGN KEY.
--

DELETE FROM cliente
WHERE id_cliente = 6;

DELETE FROM item_locacao
WHERE id_locacao = 1
  AND id_filme = 2;

-- ============================================================
-- 14. CONSULTAS BÁSICAS
-- ============================================================
--
-- Pergunta:
-- Quais clientes estão cadastrados na locadora?

SELECT *
FROM cliente;

-- Pergunta:
-- Quais filmes estão cadastrados e quais são suas avaliações?

SELECT
    titulo,
    ano_lancamento,
    avaliacao
FROM filme;


-- ============================================================
-- 15. CONSULTAS COM WHERE
-- ============================================================
--
-- Pergunta:
-- Quais filmes possuem avaliação igual ou superior a 7,0?

SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao >= 7.0;


-- ============================================================
-- 16. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================
--
-- Pergunta:
-- Quais filmes foram lançados a partir do ano 2000 e possuem avaliação igual ou superior a 7,0?

SELECT
    titulo,
    ano_lancamento,
    avaliacao
FROM filme
WHERE ano_lancamento >= 2000
  AND avaliacao >= 7.0;

-- Pergunta:
-- Quais clientes possuem nome iniciado pela letra T?

SELECT
    nome,
    telefone,
    email
FROM cliente
WHERE nome LIKE 'T%';

-- Pergunta:
-- Quais filmes possuem avaliação entre 7,0 e 9,0?

SELECT
    titulo,
    avaliacao
FROM filme
WHERE avaliacao BETWEEN 7.0 AND 9.0;


-- ============================================================
-- 17. ORDER BY
-- ============================================================
--
-- Pergunta:
-- Quais filmes possuem as maiores avaliações?

SELECT
    titulo,
    avaliacao
FROM filme
ORDER BY avaliacao DESC;


-- ============================================================
-- 18. COUNT
-- ============================================================
--
-- Pergunta:
-- Quantas locações foram realizadas na locadora?

SELECT
    COUNT(*) AS total_locacoes
FROM locacao;


-- ============================================================
-- 19. SUM
-- ============================================================
--
-- Pergunta:
-- Qual foi o valor total da locação 1?

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
-- 20. AVG
-- ============================================================
--
-- Pergunta:
-- Qual é a avaliação média dos filmes cadastrados?

SELECT
    ROUND(AVG(avaliacao), 2) AS media_avaliacoes
FROM filme;


-- ============================================================
-- 21. MIN E MAX
-- ============================================================
--
-- Pergunta:
-- Quais são a menor e a maior avaliação dos filmes cadastrados?

SELECT
    MIN(avaliacao) AS menor_avaliacao,
    MAX(avaliacao) AS maior_avaliacao
FROM filme;


-- ============================================================
-- 22. GROUP BY
-- ============================================================
--
-- Pergunta:
-- Quantas locações cada cliente realizou?

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
-- 23. HAVING
-- ============================================================
--
-- Pergunta:
-- Quais funcionários registraram mais de uma locação?

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
-- 24. EXPRESSÃO SQL
-- ============================================================
--
-- Pergunta:
-- Qual foi o valor de cada item considerando a quantidade de dias da locação?

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
-- 25. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Qual foi o valor total de cada locação?
--

-- ESCREVA SUA CONSULTA REAL ABAIXO:

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
-- 26. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
--
-- Pergunta:
-- Quais filmes foram mais alugados?
--

-- ESCREVA SUA CONSULTA REAL ABAIXO:

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
--  CONSULTAS EXTRAS
-- ============================================================
--
-- Essa parte foi adcionada, pois ela responde as perguntas planejadas na SPRINT1-5
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
-- 27. VALIDAÇÃO — SHOW TABLES
-- ============================================================

SHOW TABLES;


-- ============================================================
-- 28. VALIDAÇÃO — DESCRIBE
-- ============================================================

DESCRIBE cliente;
DESCRIBE funcionario;
DESCRIBE genero;
DESCRIBE filme;
DESCRIBE locacao;
DESCRIBE item_locacao;


-- ============================================================
-- 29. VALIDAÇÃO — SHOW CREATE TABLE
-- ============================================================

SHOW CREATE TABLE cliente;
SHOW CREATE TABLE funcionario;
SHOW CREATE TABLE genero;
SHOW CREATE TABLE filme;
SHOW CREATE TABLE locacao;
SHOW CREATE TABLE item_locacao;


-- ============================================================
-- 30. TESTES DE INTEGRIDADE — DEIXAR COMENTADOS
-- ============================================================
--
-- Os exemplos abaixo servem apenas para verificar restrições.
-- Eles NÃO devem permanecer ativos no script final caso
-- provoquem erros de propósito.
--
-- Teste UNIQUE:
-- tenta cadastrar um CPF que já existe.
--
-- INSERT INTO cliente (nome, cpf)
-- VALUES ('Cliente Teste', '022.015.504-12');
--
--
-- Teste NOT NULL:
-- tenta cadastrar um gênero sem nome.
--
-- INSERT INTO genero (nome)
-- VALUES (NULL);
--
--
-- Teste FOREIGN KEY:
-- tenta criar uma locação para um cliente inexistente.
--
-- INSERT INTO locacao (
--     id_cliente,
--     id_funcionario,
--     data_locacao
-- )
-- VALUES (
--     999999,
--     1,
--     '2026-09-10'
-- );
--


-- ============================================================
-- 31. CONSULTAS FINAIS DE CONFERÊNCIA
-- ============================================================

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM genero;
SELECT * FROM filme;
SELECT * FROM locacao;
SELECT * FROM item_locacao;


-- ============================================================
-- 32. CHECKLIST FINAL
-- ============================================================
--
-- Antes da entrega, confirme:
--
-- [x] Substituí nome_do_banco.
-- [x] Substituí tabela_a, tabela_b, tabela_c e tabela_d.
-- [x] Substituí todos os nomes genéricos de campos.
-- [x] O CREATE DATABASE está correto.
-- [x] O USE está correto.
-- [x] Todas as tabelas são criadas.
-- [x] Todas as PRIMARY KEY estão corretas.
-- [x] Todas as FOREIGN KEY estão corretas.
-- [x] NOT NULL está coerente.
-- [x] UNIQUE está coerente.
-- [x] DEFAULT está coerente.
-- [x] INSERTs executam corretamente.
-- [x] UPDATEs possuem WHERE.
-- [x] DELETEs possuem WHERE.
-- [x] SELECT funciona.
-- [x] WHERE funciona.
-- [x] ORDER BY funciona.
-- [x] COUNT funciona.
-- [x] SUM funciona, quando aplicável.
-- [x] AVG funciona, quando aplicável.
-- [x] MIN/MAX funcionam.
-- [x] GROUP BY funciona.
-- [x] HAVING funciona.
-- [x] Testei SHOW TABLES.
-- [x] Testei DESCRIBE.
-- [x] Testei SHOW CREATE TABLE.
-- [x] O script executa do início ao fim.
-- [x] Removi trechos genéricos que não pertencem ao projeto.
-- [x] Não deixei credenciais ou senhas no arquivo.
-- [x] Salvei como SPRINT5-5.sql.
--
-- ============================================================
-- FIM DA SPRINT 5/5
-- ============================================================
