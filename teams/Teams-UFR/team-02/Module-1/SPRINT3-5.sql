-- ============================================================
-- IDENTIFICACAO
-- ============================================================
-- Aluno: Rafael Tokashiki Souza
-- Disciplina: Laboratorio de Banco de Dados
-- Sprint: 3/5 - Manipulacao de dados com DML
-- Banco: imobiliaria
-- ============================================================


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE imobiliaria;


-- ============================================================
-- INSERTS - TABELA proprietarios
-- Tabela independente: inserida primeiro.
-- ============================================================

INSERT INTO proprietarios (nome, cpf_cnpj, telefone, email, cidade)
VALUES
    ('Joao Pereira da Silva',   '123.456.789-01',     '66999990001', 'joao.pereira@email.com',  'Rondonopolis'),
    ('Maria Santos Oliveira',   '234.567.890-12',     '66999990002', 'maria.santos@email.com',  'Rondonopolis'),
    ('Carlos Alberto Moraes',   '345.678.901-23',     '66999990003', 'carlos.moraes@email.com', 'Cuiaba'),
    ('Construtora Horizonte',   '12.345.678/0001-90', '66999990004', 'contato@horizonte.com',   'Rondonopolis'),
    ('Ana Lucia Ferreira',      '456.789.012-34',     '66999990005', 'ana.ferreira@email.com',  'Primavera do Leste');


-- ============================================================
-- INSERTS - TABELA clientes
-- Tabela independente.
-- O campo interesse possui DEFAULT 'Compra'.
-- No terceiro registro o campo foi omitido para testar o DEFAULT.
-- ============================================================

INSERT INTO clientes (nome, cpf, telefone, email, interesse, data_cadastro)
VALUES
    ('Bruno Almeida Costa',    '567.890.123-45', '66988880001', 'bruno.almeida@email.com',  'Compra',  '2026-02-10'),
    ('Fernanda Ribeiro Lima',  '678.901.234-56', '66988880002', 'fernanda.lima@email.com',  'Aluguel', '2026-03-05'),
    ('Ricardo Tanaka',         '789.012.345-67', '66988880003', 'ricardo.tanaka@email.com', 'Compra',  '2026-04-18');

INSERT INTO clientes (nome, cpf, telefone, email, data_cadastro)
VALUES
    ('Juliana Prado Mendes',   '890.123.456-78', '66988880004', 'juliana.prado@email.com',  '2026-05-22');

INSERT INTO clientes (nome, cpf, telefone, email, interesse, data_cadastro)
VALUES
    ('Marcos Vinicius Souza',  '901.234.567-89', '66988880005', 'marcos.souza@email.com',   'Aluguel', '2026-06-30');


-- ============================================================
-- INSERTS - TABELA corretores
-- Tabela independente.
-- ============================================================

INSERT INTO corretores (nome, creci, telefone, email, data_admissao)
VALUES
    ('Paulo Henrique Dias',   'CRECI-MT 12345', '66977770001', 'paulo.dias@imobiliaria.com',    '2022-01-15'),
    ('Camila Rocha Barbosa',  'CRECI-MT 23456', '66977770002', 'camila.rocha@imobiliaria.com',  '2023-03-20'),
    ('Eduardo Nakamura',      'CRECI-MT 34567', '66977770003', 'eduardo.nakamura@imobiliaria.com', '2023-08-01'),
    ('Patricia Gomes Reis',   'CRECI-MT 45678', '66977770004', 'patricia.reis@imobiliaria.com', '2024-02-12'),
    ('Rafael Tokashiki',      'CRECI-MT 56789', '66977770005', 'rafael.tokashiki@imobiliaria.com', '2024-07-01');


-- ============================================================
-- INSERTS - TABELA imoveis
-- Depende de proprietarios (chave estrangeira id_proprietario).
-- Inserida somente apos os proprietarios existirem.
-- ============================================================

INSERT INTO imoveis
    (titulo, tipo, finalidade, bairro, cidade, quartos, banheiros, vagas,
     area_m2, preco, data_cadastro, id_proprietario, valor_condominio)
VALUES
    ('Casa terrea com quintal amplo', 'Casa',        'Venda',   'Vila Aurora',          'Rondonopolis', 3, 2, 2, 180.00,  450000.00, '2026-01-10', 1,   0.00),
    ('Apartamento mobiliado centro',  'Apartamento', 'Aluguel', 'Centro',               'Rondonopolis', 2, 1, 1,  68.50,    1800.00, '2026-01-25', 1, 350.00),
    ('Sobrado alto padrao',           'Sobrado',     'Venda',   'Jardim Atlantico',     'Rondonopolis', 4, 4, 3, 320.00, 1250000.00, '2026-02-08', 2,   0.00),
    ('Kitnet mobiliada proxima UFR',  'Kitnet',      'Aluguel', 'Vila Birigui',         'Rondonopolis', 1, 1, 0,  32.00,     950.00, '2026-02-20', 2, 180.00),
    ('Terreno em condominio fechado', 'Terreno',     'Venda',   'Parque Universitario', 'Rondonopolis', 0, 0, 0, 400.00,  280000.00, '2026-03-12', 3,   0.00),
    ('Sala comercial avenida',        'Comercial',   'Aluguel', 'Centro',               'Rondonopolis', 0, 1, 1,  45.00,    2200.00, '2026-03-30', 3, 420.00),
    ('Casa nova tres quartos',        'Casa',        'Venda',   'Residencial Sao Jose', 'Rondonopolis', 3, 2, 2, 150.00,  380000.00, '2026-04-15', 4,   0.00),
    ('Apartamento dois quartos',      'Apartamento', 'Venda',   'Jardim Guanabara',     'Rondonopolis', 2, 2, 1,  75.00,  295000.00, '2026-05-02', 5, 290.00);


-- ============================================================
-- INSERTS - TABELA visitas
-- Tabela associativa: depende de imoveis, clientes e corretores.
-- Inserida apos as tres tabelas referenciadas.
-- ============================================================

INSERT INTO visitas (id_imovel, id_cliente, id_corretor, data_visita, observacao)
VALUES
    (1, 1, 1, '2026-03-14', 'Cliente gostou do quintal, achou o preco alto'),
    (3, 1, 1, '2026-03-21', 'Cliente considerou o imovel acima do orcamento'),
    (2, 2, 2, '2026-04-02', 'Cliente aprovou a localizacao'),
    (4, 2, 3, '2026-04-10', 'Kitnet pequena para a necessidade do cliente'),
    (7, 3, 2, '2026-05-18', 'Cliente pediu segunda visita com a familia'),
    (8, 4, 4, '2026-06-05', 'Cliente questionou o valor do condominio');


-- ============================================================
-- INSERTS - TABELA contratos
-- Tabela associativa: depende de imoveis, clientes e corretores.
-- Contratos de venda nao possuem data_fim (valor NULL).
-- ============================================================

INSERT INTO contratos
    (id_imovel, id_cliente, id_corretor, tipo_contrato, valor, data_inicio, data_fim)
VALUES
    (7, 3, 2, 'Venda',   380000.00, '2026-05-30', NULL),
    (2, 2, 2, 'Aluguel',   1800.00, '2026-04-15', '2027-04-14'),
    (4, 2, 3, 'Aluguel',    950.00, '2026-04-25', '2027-04-24');


-- ============================================================
-- VERIFICACOES APOS OS INSERTS
-- ============================================================

SELECT * FROM proprietarios;
SELECT * FROM clientes;
SELECT * FROM corretores;
SELECT * FROM imoveis;
SELECT * FROM visitas;
SELECT * FROM contratos;


-- ============================================================
-- UPDATES
-- ============================================================

-- ------------------------------------------------------------
-- UPDATE 1
-- O proprietario do sobrado autorizou reducao de preco.
-- ------------------------------------------------------------

SELECT id_imovel, titulo, preco FROM imoveis WHERE id_imovel = 3;

UPDATE imoveis
SET preco = 1150000.00
WHERE id_imovel = 3;

SELECT id_imovel, titulo, preco FROM imoveis WHERE id_imovel = 3;


-- ------------------------------------------------------------
-- UPDATE 2
-- O imovel 7 foi vendido (contrato 1) e sai da carteira ativa.
-- ------------------------------------------------------------

SELECT id_imovel, titulo, disponivel FROM imoveis WHERE id_imovel = 7;

UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 7;

SELECT id_imovel, titulo, disponivel FROM imoveis WHERE id_imovel = 7;


-- ------------------------------------------------------------
-- UPDATE 3
-- O imovel 2 foi alugado (contrato 2) e tambem sai da carteira.
-- ------------------------------------------------------------

UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 2;


-- ------------------------------------------------------------
-- UPDATE 4
-- O cliente 1 trocou de telefone e passou a buscar aluguel.
-- ------------------------------------------------------------

SELECT id_cliente, nome, telefone, interesse FROM clientes WHERE id_cliente = 1;

UPDATE clientes
SET telefone = '66988889999',
    interesse = 'Aluguel'
WHERE id_cliente = 1;

SELECT id_cliente, nome, telefone, interesse FROM clientes WHERE id_cliente = 1;


-- ============================================================
-- DELETES
-- ============================================================

-- ------------------------------------------------------------
-- DELETE 1
-- A visita 4 foi cancelada e nao deve constar no historico.
-- Nenhuma tabela depende de visitas, entao a exclusao e direta.
-- ------------------------------------------------------------

SELECT * FROM visitas WHERE id_visita = 4;

DELETE FROM visitas
WHERE id_visita = 4;

SELECT * FROM visitas;


-- ------------------------------------------------------------
-- DELETE 2
-- O cliente 5 solicitou a exclusao do cadastro.
-- Ele nao possui visitas nem contratos vinculados,
-- portanto nenhuma chave estrangeira impede a remocao.
-- ------------------------------------------------------------

SELECT * FROM clientes WHERE id_cliente = 5;

DELETE FROM clientes
WHERE id_cliente = 5;

SELECT * FROM clientes;


-- ============================================================
-- VERIFICACAO FINAL
-- ============================================================

SELECT COUNT(*) AS total_proprietarios FROM proprietarios;
SELECT COUNT(*) AS total_clientes      FROM clientes;
SELECT COUNT(*) AS total_corretores    FROM corretores;
SELECT COUNT(*) AS total_imoveis       FROM imoveis;
SELECT COUNT(*) AS total_visitas       FROM visitas;
SELECT COUNT(*) AS total_contratos     FROM contratos;

SELECT * FROM imoveis;
SELECT * FROM clientes;
SELECT * FROM visitas;
