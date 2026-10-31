-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS COM DML
-- ATIVIDADE INDIVIDUAL
-- ============================================================
--
-- ALUNO: Vinícius Eduardo Lima de Assis
-- TEMA DO BANCO: Viagens
-- NOME DO BANCO: pacote_viagens
--
-- ============================================================


-- ============================================================
-- 1. SELECIONAR O BANCO E CONFIGURAR PERMISSÕES
-- ============================================================

USE pacote_viagens;

-- Desativa temporariamente a trava de segurança de updates/deletes no Workbench
SET SQL_SAFE_UPDATES = 0;

-- ============================================================
-- 2. INSERTS — TABELAS INDEPENDENTES
-- ============================================================

-- ------------------------------------------------------------
-- TABELA 1: destino
-- ------------------------------------------------------------
INSERT INTO destino (
    nome,
    pais,
    estado,
    descricao
)
VALUES
    ('Fernando de Noronha', 'Brasil', 'Pernambuco', 'Arquipélago vulcânico com praias paradisíacas e vida marinha abundante.'),
    ('Gramado', 'Brasil', 'Rio Grande do Sul', 'Cidade turística na Serra Gaúcha famosa pela arquitetura e gastronomia.'),
    ('Salvador', 'Brasil', 'Bahia', 'Capital baiana reconhecida pelo centro histórico do Pelourinho e cultura rica.'),
    ('Foz do Iguaçu', 'Brasil', 'Paraná', 'Famosa pelas Cataratas do Iguaçu e Parque das Aves.'),
    ('Rio de Janeiro', 'Brasil', 'Rio de Janeiro', 'Conhecida pelas praias de Copacabana e Ipanema e a estátua do Cristo Redentor.');

-- ------------------------------------------------------------
-- TABELA 2: cliente
-- ------------------------------------------------------------
INSERT INTO cliente (
    nome,
    cpf,
    email,
    telefone
)
VALUES
    ('Carlos Silva', '123.456.789-01', 'carlos.silva@email.com', '(11) 98765-4321'),
    ('Mariana Oliveira', '234.567.890-12', 'mariana.oliveira@email.com', '(21) 97654-3210'),
    ('Roberto Santos', '345.678.901-23', 'roberto.santos@email.com', '(31) 96543-2109'),
    ('Ana Souza', '456.789.012-34', 'ana.souza@email.com', '(41) 95432-1098'),
    ('Beatriz Lima', '567.890.123-45', 'beatriz.lima@email.com', '(51) 94321-0987');

-- ------------------------------------------------------------
-- TABELA 3: transporte
-- ------------------------------------------------------------
INSERT INTO transporte (
    tipo,
    empresa,
    origem,
    destino
)
VALUES
    ('Aéreo', 'LATAM', 'São Paulo (GRU)', 'Fernando de Noronha (FEN)'),
    ('Aéreo', 'Gol', 'Rio de Janeiro (GIG)', 'Porto Alegre (POA)'),
    ('Rodoviário', 'Viação Cometa', 'São Paulo (Tietê)', 'Curitiba (TRM)'),
    ('Aéreo', 'Azul', 'Belo Horizonte (CNF)', 'Salvador (SSA)'),
    ('Rodoviário', 'Catarinense', 'Florianópolis', 'Foz do Iguaçu');


-- ============================================================
-- 3. INSERTS — TABELAS DEPENDENTES (COM FOREIGN KEY)
-- ============================================================

-- ------------------------------------------------------------
-- TABELA 4: hospedagem (Depende de destino)
-- ------------------------------------------------------------
INSERT INTO hospedagem (
    nome,
    endereco,
    tipo,
    valor_diaria,
    id_destino
)
VALUES
    ('Pousada Zé Maria', 'Rua Maj. José Vicente, 100', 'Pousada', 1200.00, 1),
    ('Hotel Colline de France', 'Rua Nilo Peçanha, 79', 'Hotel Resort', 950.00, 2),
    ('Fera Palace Hotel', 'Rua da Chile, 20', 'Hotel', 650.00, 3),
    ('Belmond Hotel das Cataratas', 'Rodovia BR-469, Km 28', 'Hotel Luxo', 1800.00, 4),
    ('Copacabana Palace', 'Av. Atlântica, 1702', 'Hotel Luxo', 2200.00, 5);

-- ------------------------------------------------------------
-- TABELA 5: reserva_pacote (Tabela associativa - Depende de cliente, hospedagem e transporte)
-- ------------------------------------------------------------
INSERT INTO reserva_pacote (
    id_cliente,
    id_hospedagem,
    id_transporte,
    data_reserva,
    quantidade_pessoas
)
VALUES
    (1, 1, 1, '2026-09-02', 2),
    (2, 2, 2, '2026-09-03', 1),
    (3, 3, 4, '2026-09-04', 4),
    (4, 4, 5, '2026-09-05', 2),
    (5, 5, 1, '2026-09-06', 3);


-- ============================================================
-- 4. VERIFICAÇÃO APÓS OS INSERTS
-- ============================================================

SELECT * FROM destino;
SELECT * FROM cliente;
SELECT * FROM transporte;
SELECT * FROM hospedagem;
SELECT * FROM reserva_pacote;

-- ============================================================
-- 5. OPERAÇÕES DE UPDATE (3 ATUALIZAÇÕES)
-- ============================================================

-- UPDATE 1: Atualização do telefone do cliente 1
SELECT * FROM cliente WHERE id_cliente = 1;

UPDATE cliente
SET telefone = '(11) 99999-8888'
WHERE id_cliente = 1;

SELECT * FROM cliente WHERE id_cliente = 1;

-- UPDATE 2: Reajuste na valor da diária da hospedagem 2
SELECT * FROM hospedagem WHERE id_hospedagem = 2;

UPDATE hospedagem
SET valor_diaria = 1050.00
WHERE id_hospedagem = 2;

SELECT * FROM hospedagem WHERE id_hospedagem = 2;

-- UPDATE 3: Alteração da quantidade de pessoas na reserva 3
SELECT * FROM reserva_pacote WHERE id_reserva = 3;

UPDATE reserva_pacote
SET quantidade_pessoas = 5
WHERE id_reserva = 3;

SELECT * FROM reserva_pacote WHERE id_reserva = 3;


-- ============================================================
-- 6. OPERAÇÕES DE DELETE (2 EXCLUSÕES SEGURAS)
-- ============================================================

-- DELETE 1: Exclusão da reserva 5 (exclui primeiro a reserva associada ao cliente 5)
SELECT * FROM reserva_pacote WHERE id_reserva = 5;

DELETE FROM reserva_pacote
WHERE id_reserva = 5;

-- DELETE 2: Exclusão do cliente 5 (agora seguro pois a reserva associada foi removida)
SELECT * FROM cliente WHERE id_cliente = 5;

DELETE FROM cliente
WHERE id_cliente = 5;


-- ============================================================
-- 7. VERIFICAÇÃO FINAL DAS TABELAS
-- ============================================================

SELECT * FROM destino;
SELECT * FROM cliente;
SELECT * FROM transporte;
SELECT * FROM hospedagem;
SELECT * FROM reserva_pacote;

-- Reativa a trava de segurança de updates/deletes no Workbench
SET SQL_SAFE_UPDATES = 1;

-- ============================================================
-- FIM DA SPRINT 3/5
-- ============================================================
