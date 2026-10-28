-- ============================================================
-- IDENTIFICACAO
-- ============================================================
-- Aluno: Rafael  Tokashiki Souza
-- Instituicao: UFR
-- Disciplina: Laboratorio de Banco de Dados
-- Sprint: 5/5 - Script integrado e validacao final
-- Tema: Imobiliaria
-- Banco: imobiliaria
--
-- Este arquivo reune o projeto completo desenvolvido nas
-- Sprints 2/5, 3/5 e 4/5. Executa do inicio ao fim e
-- reconstroi o banco inteiro.
-- ============================================================


-- ============================================================
-- 1. CRIACAO DO BANCO
-- ============================================================
-- DROP DATABASE remove o banco e todos os seus dados.
-- Esta linha existe para permitir que o script seja executado
-- novamente do zero. Execute somente sobre o banco desta
-- disciplina.

DROP DATABASE IF EXISTS imobiliaria;

CREATE DATABASE imobiliaria;


-- ============================================================
-- 2. SELECAO DO BANCO
-- ============================================================

USE imobiliaria;


-- ============================================================
-- 3. CRIACAO DAS TABELAS
-- ============================================================
-- Ordem obrigatoria: as tabelas independentes vem primeiro,
-- porque as demais possuem chaves estrangeiras que as
-- referenciam.

-- ------------------------------------------------------------
-- 3.1 - proprietarios (independente)
-- ------------------------------------------------------------

CREATE TABLE proprietarios (
    id_proprietario INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(100) NOT NULL,
    cpf_cnpj        VARCHAR(18)  NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    email           VARCHAR(100),
    cidade          VARCHAR(80)
);


-- ------------------------------------------------------------
-- 3.2 - clientes (independente)
-- ------------------------------------------------------------

CREATE TABLE clientes (
    id_cliente     INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    cpf            VARCHAR(14)  NOT NULL UNIQUE,
    telefone       VARCHAR(20),
    email          VARCHAR(100),
    interesse      VARCHAR(20)  NOT NULL DEFAULT 'Compra',
    data_cadastro  DATE         NOT NULL
);


-- ------------------------------------------------------------
-- 3.3 - corretores (independente)
-- ------------------------------------------------------------

CREATE TABLE corretores (
    id_corretor    INT PRIMARY KEY AUTO_INCREMENT,
    nome           VARCHAR(100) NOT NULL,
    creci          VARCHAR(20)  NOT NULL UNIQUE,
    telefone       VARCHAR(20),
    email          VARCHAR(100),
    data_admissao  DATE
);


-- ------------------------------------------------------------
-- 3.4 - imoveis (depende de proprietarios)
-- A coluna valor_condominio foi acrescentada na Sprint 2/5
-- por ALTER TABLE e esta incorporada aqui.
-- ------------------------------------------------------------

CREATE TABLE imoveis (
    id_imovel         INT PRIMARY KEY AUTO_INCREMENT,
    titulo            VARCHAR(150)  NOT NULL,
    tipo              VARCHAR(30)   NOT NULL,
    finalidade        VARCHAR(20)   NOT NULL,
    bairro            VARCHAR(80),
    cidade            VARCHAR(80)   NOT NULL,
    quartos           INT           NOT NULL DEFAULT 0,
    banheiros         INT           NOT NULL DEFAULT 0,
    vagas             INT           NOT NULL DEFAULT 0,
    area_m2           DECIMAL(8,2),
    preco             DECIMAL(12,2) NOT NULL,
    disponivel        BOOLEAN       NOT NULL DEFAULT TRUE,
    data_cadastro     DATE          NOT NULL,
    valor_condominio  DECIMAL(10,2) DEFAULT 0.00,
    id_proprietario   INT           NOT NULL,

    CONSTRAINT fk_imoveis_proprietarios
        FOREIGN KEY (id_proprietario)
        REFERENCES proprietarios(id_proprietario)
);


-- ------------------------------------------------------------
-- 3.5 - visitas (tabela associativa)
-- Resolve o relacionamento N:N entre clientes e imoveis.
-- ------------------------------------------------------------

CREATE TABLE visitas (
    id_visita    INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel    INT  NOT NULL,
    id_cliente   INT  NOT NULL,
    id_corretor  INT  NOT NULL,
    data_visita  DATE NOT NULL,
    observacao   TEXT,

    CONSTRAINT fk_visitas_imoveis
        FOREIGN KEY (id_imovel)    REFERENCES imoveis(id_imovel),
    CONSTRAINT fk_visitas_clientes
        FOREIGN KEY (id_cliente)   REFERENCES clientes(id_cliente),
    CONSTRAINT fk_visitas_corretores
        FOREIGN KEY (id_corretor)  REFERENCES corretores(id_corretor)
);


-- ------------------------------------------------------------
-- 3.6 - contratos (tabela associativa)
-- data_fim aceita NULL: contratos de venda nao tem termino.
-- ------------------------------------------------------------

CREATE TABLE contratos (
    id_contrato    INT PRIMARY KEY AUTO_INCREMENT,
    id_imovel      INT           NOT NULL,
    id_cliente     INT           NOT NULL,
    id_corretor    INT           NOT NULL,
    tipo_contrato  VARCHAR(20)   NOT NULL,
    valor          DECIMAL(12,2) NOT NULL,
    data_inicio    DATE          NOT NULL,
    data_fim       DATE,

    CONSTRAINT fk_contratos_imoveis
        FOREIGN KEY (id_imovel)   REFERENCES imoveis(id_imovel),
    CONSTRAINT fk_contratos_clientes
        FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente),
    CONSTRAINT fk_contratos_corretores
        FOREIGN KEY (id_corretor) REFERENCES corretores(id_corretor)
);


-- ============================================================
-- 4. RESTRICOES E RELACIONAMENTOS
-- ============================================================
-- Resumo do que foi implementado na secao 3:
--
-- PRIMARY KEY      : 6 (uma por tabela, todas AUTO_INCREMENT)
-- FOREIGN KEY      : 7 (1 em imoveis, 3 em visitas, 3 em contratos)
-- UNIQUE           : 3 (cpf_cnpj, cpf, creci)
-- NOT NULL         : nos campos obrigatorios ao negocio
-- DEFAULT          : disponivel=TRUE, quartos/banheiros/vagas=0,
--                    valor_condominio=0.00, interesse='Compra'


-- ============================================================
-- 5. INSERTS
-- ============================================================
-- Mesma regra de ordem do CREATE TABLE: as tabelas
-- independentes sao populadas primeiro.

-- ------------------------------------------------------------
-- 5.1 - proprietarios
-- ------------------------------------------------------------

INSERT INTO proprietarios (nome, cpf_cnpj, telefone, email, cidade)
VALUES
    ('Joao Pereira da Silva',  '123.456.789-01',     '66999990001', 'joao.pereira@email.com',  'Rondonopolis'),
    ('Maria Santos Oliveira',  '234.567.890-12',     '66999990002', 'maria.santos@email.com',  'Rondonopolis'),
    ('Carlos Alberto Moraes',  '345.678.901-23',     '66999990003', 'carlos.moraes@email.com', 'Cuiaba'),
    ('Construtora Horizonte',  '12.345.678/0001-90', '66999990004', 'contato@horizonte.com',   'Rondonopolis'),
    ('Ana Lucia Ferreira',     '456.789.012-34',     '66999990005', 'ana.ferreira@email.com',  'Primavera do Leste');


-- ------------------------------------------------------------
-- 5.2 - clientes
-- A cliente Juliana e inserida SEM o campo interesse,
-- para demonstrar o DEFAULT 'Compra'.
-- ------------------------------------------------------------

INSERT INTO clientes (nome, cpf, telefone, email, interesse, data_cadastro)
VALUES
    ('Bruno Almeida Costa',   '567.890.123-45', '66988880001', 'bruno.almeida@email.com',  'Compra',  '2026-02-10'),
    ('Fernanda Ribeiro Lima', '678.901.234-56', '66988880002', 'fernanda.lima@email.com',  'Aluguel', '2026-03-05'),
    ('Ricardo Tanaka',        '789.012.345-67', '66988880003', 'ricardo.tanaka@email.com', 'Compra',  '2026-04-18');

INSERT INTO clientes (nome, cpf, telefone, email, data_cadastro)
VALUES
    ('Juliana Prado Mendes',  '890.123.456-78', '66988880004', 'juliana.prado@email.com',  '2026-05-22');

INSERT INTO clientes (nome, cpf, telefone, email, interesse, data_cadastro)
VALUES
    ('Marcos Vinicius Souza', '901.234.567-89', '66988880005', 'marcos.souza@email.com',   'Aluguel', '2026-06-30');


-- ------------------------------------------------------------
-- 5.3 - corretores
-- ------------------------------------------------------------

INSERT INTO corretores (nome, creci, telefone, email, data_admissao)
VALUES
    ('Paulo Henrique Dias',  'CRECI-MT 12345', '66977770001', 'paulo.dias@imobiliaria.com',       '2022-01-15'),
    ('Camila Rocha Barbosa', 'CRECI-MT 23456', '66977770002', 'camila.rocha@imobiliaria.com',     '2023-03-20'),
    ('Eduardo Nakamura',     'CRECI-MT 34567', '66977770003', 'eduardo.nakamura@imobiliaria.com', '2023-08-01'),
    ('Patricia Gomes Reis',  'CRECI-MT 45678', '66977770004', 'patricia.reis@imobiliaria.com',    '2024-02-12'),
    ('Rafael Tokashiki',     'CRECI-MT 56789', '66977770005', 'rafael.tokashiki@imobiliaria.com', '2024-07-01');


-- ------------------------------------------------------------
-- 5.4 - imoveis (depende de proprietarios)
-- ------------------------------------------------------------

INSERT INTO imoveis
    (titulo, tipo, finalidade, bairro, cidade, quartos, banheiros, vagas,
     area_m2, preco, data_cadastro, valor_condominio, id_proprietario)
VALUES
    ('Casa terrea com quintal amplo', 'Casa',        'Venda',   'Vila Aurora',          'Rondonopolis', 3, 2, 2, 180.00,  450000.00, '2026-01-10',   0.00, 1),
    ('Apartamento mobiliado centro',  'Apartamento', 'Aluguel', 'Centro',               'Rondonopolis', 2, 1, 1,  68.50,    1800.00, '2026-01-25', 350.00, 1),
    ('Sobrado alto padrao',           'Sobrado',     'Venda',   'Jardim Atlantico',     'Rondonopolis', 4, 4, 3, 320.00, 1250000.00, '2026-02-08',   0.00, 2),
    ('Kitnet mobiliada proxima UFR',  'Kitnet',      'Aluguel', 'Vila Birigui',         'Rondonopolis', 1, 1, 0,  32.00,     950.00, '2026-02-20', 180.00, 2),
    ('Terreno em condominio fechado', 'Terreno',     'Venda',   'Parque Universitario', 'Rondonopolis', 0, 0, 0, 400.00,  280000.00, '2026-03-12',   0.00, 3),
    ('Sala comercial avenida',        'Comercial',   'Aluguel', 'Centro',               'Rondonopolis', 0, 1, 1,  45.00,    2200.00, '2026-03-30', 420.00, 3),
    ('Casa nova tres quartos',        'Casa',        'Venda',   'Residencial Sao Jose', 'Rondonopolis', 3, 2, 2, 150.00,  380000.00, '2026-04-15',   0.00, 4),
    ('Apartamento dois quartos',      'Apartamento', 'Venda',   'Jardim Guanabara',     'Rondonopolis', 2, 2, 1,  75.00,  295000.00, '2026-05-02', 290.00, 5);


-- ------------------------------------------------------------
-- 5.5 - visitas (depende de imoveis, clientes e corretores)
-- ------------------------------------------------------------

INSERT INTO visitas (id_imovel, id_cliente, id_corretor, data_visita, observacao)
VALUES
    (1, 1, 1, '2026-03-14', 'Cliente gostou do quintal, achou o preco alto'),
    (3, 1, 1, '2026-03-21', 'Cliente considerou o imovel acima do orcamento'),
    (2, 2, 2, '2026-04-02', 'Cliente aprovou a localizacao'),
    (4, 2, 3, '2026-04-10', 'Kitnet pequena para a necessidade do cliente'),
    (7, 3, 2, '2026-05-18', 'Cliente pediu segunda visita com a familia'),
    (8, 4, 4, '2026-06-05', 'Cliente questionou o valor do condominio');


-- ------------------------------------------------------------
-- 5.6 - contratos (depende de imoveis, clientes e corretores)
-- ------------------------------------------------------------

INSERT INTO contratos
    (id_imovel, id_cliente, id_corretor, tipo_contrato, valor, data_inicio, data_fim)
VALUES
    (7, 3, 2, 'Venda',   380000.00, '2026-05-30', NULL),
    (2, 2, 2, 'Aluguel',   1800.00, '2026-04-15', '2027-04-14'),
    (4, 2, 3, 'Aluguel',    950.00, '2026-04-25', '2027-04-24');


-- ============================================================
-- 6. UPDATES
-- ============================================================
-- Todos possuem WHERE. Sem ele, a alteracao atingiria
-- a tabela inteira.

-- UPDATE 1 - o proprietario autorizou reducao de preco do sobrado
UPDATE imoveis
SET preco = 1150000.00
WHERE id_imovel = 3;

-- UPDATE 2 - imovel 7 vendido (contrato 1): sai da carteira ativa
UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 7;

-- UPDATE 3 - imovel 2 alugado (contrato 2): sai da carteira ativa
UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 2;

-- UPDATE 4 - cliente 1 trocou de telefone e passou a buscar aluguel
UPDATE clientes
SET telefone  = '66988889999',
    interesse = 'Aluguel'
WHERE id_cliente = 1;


-- ============================================================
-- 7. DELETES
-- ============================================================
-- Ambos possuem WHERE e atingem registros sem dependentes.

-- DELETE 1 - visita cancelada
-- Nenhuma tabela referencia visitas, entao a exclusao e direta.
DELETE FROM visitas
WHERE id_visita = 4;

-- DELETE 2 - cliente solicitou exclusao do cadastro
-- O cliente 5 nao possui visitas nem contratos vinculados.
DELETE FROM clientes
WHERE id_cliente = 5;


-- ============================================================
-- 8. CONSULTAS BASICAS
-- ============================================================

-- Todos os imoveis da carteira
SELECT * FROM imoveis;

-- Lista resumida para anuncio
SELECT titulo, tipo, bairro, quartos, preco
FROM imoveis;


-- ============================================================
-- 9. WHERE
-- ============================================================

-- Pergunta 1: imoveis a venda na Vila Aurora
SELECT titulo, bairro, preco
FROM imoveis
WHERE finalidade = 'Venda'
  AND bairro = 'Vila Aurora';

-- Pergunta 2: alugueis ate R$ 2.000 que ainda estao disponiveis
SELECT titulo, bairro, preco, valor_condominio
FROM imoveis
WHERE finalidade = 'Aluguel'
  AND preco <= 2000.00
  AND disponivel = TRUE;

-- BETWEEN: imoveis na faixa de R$ 280.000 a R$ 500.000
SELECT titulo, tipo, preco
FROM imoveis
WHERE preco BETWEEN 280000.00 AND 500000.00;

-- IN: apenas residenciais de alvenaria
SELECT titulo, tipo, quartos, preco
FROM imoveis
WHERE tipo IN ('Casa', 'Sobrado', 'Apartamento');

-- IS NOT NULL: contratos com prazo (locacoes)
SELECT id_contrato, tipo_contrato, valor, data_inicio, data_fim
FROM contratos
WHERE data_fim IS NOT NULL;

-- LIKE: bairros cujo nome contem "Jardim"
SELECT titulo, bairro, cidade
FROM imoveis
WHERE bairro LIKE '%Jardim%';


-- ============================================================
-- 10. ORDER BY
-- ============================================================

-- Imoveis do mais caro para o mais barato
SELECT titulo, tipo, preco
FROM imoveis
ORDER BY preco DESC;

-- Agrupado por tipo e, dentro de cada tipo, por preco
SELECT tipo, titulo, preco
FROM imoveis
ORDER BY tipo ASC, preco DESC;


-- ============================================================
-- 11. FUNCOES DE AGREGACAO
-- ============================================================

-- COUNT: total de imoveis
SELECT COUNT(*) AS total_imoveis
FROM imoveis;

-- COUNT com filtro: imoveis ainda disponiveis
SELECT COUNT(*) AS imoveis_disponiveis
FROM imoveis
WHERE disponivel = TRUE;

-- SUM: valor total movimentado em contratos
SELECT SUM(valor) AS valor_total_contratos
FROM contratos;

-- AVG: preco medio dos imoveis a venda
-- ROUND evita as casas decimais extras que o AVG gera
SELECT ROUND(AVG(preco), 2) AS preco_medio_venda
FROM imoveis
WHERE finalidade = 'Venda';

-- MIN e MAX: extremos da carteira
SELECT MIN(preco) AS menor_preco,
       MAX(preco) AS maior_preco
FROM imoveis;


-- ============================================================
-- 12. GROUP BY
-- ============================================================

-- Pergunta 3: quantos imoveis existem de cada tipo
SELECT tipo,
       COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
ORDER BY quantidade DESC;

-- Pergunta 4: preco medio por finalidade
SELECT finalidade,
       COUNT(*) AS quantidade,
       ROUND(AVG(preco), 2) AS preco_medio
FROM imoveis
GROUP BY finalidade;

-- Pergunta 6: visitas realizadas por cada corretor
SELECT corretores.nome AS corretor,
       COUNT(visitas.id_visita) AS total_visitas
FROM visitas
INNER JOIN corretores ON visitas.id_corretor = corretores.id_corretor
GROUP BY corretores.nome
ORDER BY total_visitas DESC;


-- ============================================================
-- 13. HAVING
-- ============================================================
-- WHERE filtra LINHAS antes do agrupamento.
-- HAVING filtra GRUPOS depois do agrupamento.

-- Tipos de imovel com mais de uma unidade na carteira
SELECT tipo,
       COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
HAVING COUNT(*) > 1;

-- Pergunta 7: proprietarios com 2 ou mais imoveis conosco
SELECT proprietarios.nome AS proprietario,
       COUNT(imoveis.id_imovel) AS total_imoveis,
       SUM(imoveis.preco) AS valor_total_carteira
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
GROUP BY proprietarios.nome
HAVING COUNT(imoveis.id_imovel) >= 2
ORDER BY valor_total_carteira DESC;


-- ============================================================
-- 14. EXPRESSOES SQL
-- ============================================================

-- Comissao de 6% sobre cada imovel a venda
SELECT titulo,
       preco,
       ROUND(preco * 0.06, 2) AS comissao_6_porcento
FROM imoveis
WHERE finalidade = 'Venda'
ORDER BY comissao_6_porcento DESC;

-- Custo mensal real do aluguel (aluguel + condominio)
SELECT titulo,
       preco AS aluguel,
       valor_condominio,
       preco + valor_condominio AS custo_mensal_total
FROM imoveis
WHERE finalidade = 'Aluguel'
ORDER BY custo_mensal_total ASC;

-- Preco por metro quadrado
-- O filtro area_m2 > 0 evita divisao por zero
SELECT titulo,
       area_m2,
       preco,
       ROUND(preco / area_m2, 2) AS preco_por_m2
FROM imoveis
WHERE finalidade = 'Venda'
  AND area_m2 > 0
ORDER BY preco_por_m2 DESC;


-- ============================================================
-- 15. CONSULTAS COM JOIN
-- ============================================================

-- Pergunta 5: quem e o proprietario de cada imovel
SELECT imoveis.titulo,
       imoveis.tipo,
       imoveis.preco,
       proprietarios.nome     AS proprietario,
       proprietarios.telefone
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
ORDER BY proprietarios.nome;

-- Historico completo de visitas (JOIN entre 4 tabelas)
SELECT visitas.data_visita,
       clientes.nome   AS cliente,
       imoveis.titulo  AS imovel,
       corretores.nome AS corretor,
       visitas.observacao
FROM visitas
INNER JOIN clientes   ON visitas.id_cliente  = clientes.id_cliente
INNER JOIN imoveis    ON visitas.id_imovel   = imoveis.id_imovel
INNER JOIN corretores ON visitas.id_corretor = corretores.id_corretor
ORDER BY visitas.data_visita;

-- Pergunta 8: contratos fechados, com cliente e corretor
SELECT contratos.tipo_contrato,
       imoveis.titulo  AS imovel,
       clientes.nome   AS cliente,
       corretores.nome AS corretor,
       contratos.valor,
       contratos.data_inicio
FROM contratos
INNER JOIN imoveis    ON contratos.id_imovel   = imoveis.id_imovel
INNER JOIN clientes   ON contratos.id_cliente  = clientes.id_cliente
INNER JOIN corretores ON contratos.id_corretor = corretores.id_corretor
ORDER BY contratos.data_inicio;

-- Resumo financeiro por tipo de contrato
SELECT tipo_contrato,
       COUNT(*) AS quantidade,
       SUM(valor) AS valor_total,
       ROUND(AVG(valor), 2) AS valor_medio
FROM contratos
GROUP BY tipo_contrato;


-- ============================================================
-- 16. VALIDACAO FINAL
-- ============================================================

-- Conferir que as 6 tabelas foram criadas
SHOW TABLES;

-- Conferir a estrutura de cada tabela
DESCRIBE proprietarios;
DESCRIBE clientes;
DESCRIBE corretores;
DESCRIBE imoveis;
DESCRIBE visitas;
DESCRIBE contratos;

-- Conferir chaves e restricoes criadas pelo MySQL
SHOW CREATE TABLE imoveis;
SHOW CREATE TABLE visitas;
SHOW CREATE TABLE contratos;

-- Conferir os totais apos INSERTs, UPDATEs e DELETEs
SELECT 'proprietarios' AS tabela, COUNT(*) AS registros FROM proprietarios
UNION ALL
SELECT 'clientes',      COUNT(*) FROM clientes
UNION ALL
SELECT 'corretores',    COUNT(*) FROM corretores
UNION ALL
SELECT 'imoveis',       COUNT(*) FROM imoveis
UNION ALL
SELECT 'visitas',       COUNT(*) FROM visitas
UNION ALL
SELECT 'contratos',     COUNT(*) FROM contratos;


-- ============================================================
-- 17. TESTES DE INTEGRIDADE (DOCUMENTADOS, NAO EXECUTAVEIS)
-- ============================================================
-- Os comandos abaixo foram executados durante a Sprint 3/5 e
-- TODOS foram recusados pelo banco, confirmando que as
-- restricoes funcionam. Permanecem comentados porque sao
-- propositalmente invalidos e nao devem rodar no script final.
--
-- TESTE UNIQUE - CPF duplicado: recusado
-- INSERT INTO clientes (nome, cpf, telefone, data_cadastro)
-- VALUES ('Cliente Duplicado', '567.890.123-45', '66900000000', '2026-09-24');
--
-- TESTE NOT NULL - imovel sem preco: recusado
-- INSERT INTO imoveis (titulo, tipo, finalidade, cidade, data_cadastro, id_proprietario)
-- VALUES ('Imovel sem preco', 'Casa', 'Venda', 'Rondonopolis', '2026-09-24', 1);
--
-- TESTE FOREIGN KEY em INSERT - proprietario inexistente: recusado
-- INSERT INTO imoveis (titulo, tipo, finalidade, cidade, preco, data_cadastro, id_proprietario)
-- VALUES ('Imovel sem dono', 'Casa', 'Venda', 'Rondonopolis', 300000.00, '2026-09-24', 999);
--
-- TESTE FOREIGN KEY em DELETE - proprietario com imoveis: bloqueado
-- DELETE FROM proprietarios WHERE id_proprietario = 1;
--
-- FIM DO SCRIPT
-- ============================================================
