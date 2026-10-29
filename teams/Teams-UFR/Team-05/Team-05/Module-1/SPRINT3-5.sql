-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS COM DML
-- ATIVIDADE INDIVIDUAL
-- ============================================================
-- ALUNO: NICOLAS LINO OLIVEIRA
-- TEMA DO BANCO: Gestão de Imobiliária (Corretores de Imóveis)
-- NOME DO BANCO: banco_imobiliaria
-- ============================================================

-- ============================================================
-- 1. SELECIONAR O BANCO
-- ============================================================
USE banco_imobiliaria;

-- ============================================================
-- 2. INSERTS — TABELAS INDEPENDENTES
-- ============================================================

-- Tabela: corretores (mínimo 5 registros)
INSERT INTO corretores (nome, creci, comissao_percentual)
VALUES
    ('Carlos Eduardo Ramos', 'CRECI-10293-MT', 6.00),
    ('Mariana Albuquerque', 'CRECI-20481-MT', 5.50),
    ('Roberto Silva Prado', 'CRECI-30192-MT', 5.00),
    ('Fernanda Souza Gomes', 'CRECI-40512-MT', 6.50),
    ('Juliano Mendes Santos', 'CRECI-50931-MT', 5.00);

-- Tabela: clientes (mínimo 5 registros)
INSERT INTO clientes (nome, contato, tipo_interesse, orcamento)
VALUES
    ('Lucas Henrique Ferreira', 'lucas.ferreira@email.com', 'compra', 450000.00),
    ('Beatriz Lima da Rocha', '(65) 99123-4567', 'aluguel', 3500.00),
    ('Guilherme Antunes', 'guilherme.antunes@email.com', 'compra', 800000.00),
    ('Camila Duarte Ramos', '(65) 98456-1122', 'compra', 600000.00),
    ('Thiago Peixoto', 'thiago.peixoto@email.com', 'aluguel', 2800.00),
    ('Larissa Montenegro', '(65) 99988-7766', 'compra', 320000.00);

-- Tabela: imoveis (mínimo 5 registros)
INSERT INTO imoveis (endereco, tipo, preco, status, observacoes)
VALUES
    ('Av. do CPA, 1200 - Apto 302', 'apartamento', 420000.00, 'disponível', 'Sol da manhã, sacada gourmet e 2 vagas de garagem.'),
    ('Rua das Camélias, 45 - Bairro Jardim', 'casa', 780000.00, 'disponível', 'Casa térrea com piscina e churrasqueira.'),
    ('Rua Estevão de Mendonça, 500 - Sala 40', 'comercial', 2600.00, 'disponível', 'Sala comercial mobiliada para escritório.'),
    ('Av. Fernando Corrêa, 3500 - Apto 101', 'apartamento', 310000.00, 'disponível', 'Próximo à universidade, ideal para investimento.'),
    ('Rodovia Helder Cândia, Condomínio Solar', 'terreno', 350000.00, 'disponível', 'Lote de 450m² plano em condomínio fechado.'),
    ('Rua das Palmeiras, 88 - Bairro Quilombo', 'casa', 590000.00, 'disponível', 'Imóvel amplo, necessita de pequena reforma.');

-- ============================================================
-- 3. INSERTS — TABELAS DEPENDENTES / ASSOCIATIVAS
-- ============================================================

-- Tabela: gestoes (Histórico de corretores responsáveis)
INSERT INTO gestoes (id_imovel, id_corretor, data_inicio, data_fim)
VALUES
    (1, 1, '2026-01-15', NULL),
    (2, 2, '2026-02-01', NULL),
    (3, 3, '2026-02-10', NULL),
    (4, 4, '2026-03-01', NULL),
    (5, 5, '2026-03-05', NULL),
    (6, 1, '2026-03-10', NULL);

-- Tabela: visitas (Agendamentos)
INSERT INTO visitas (id_cliente, id_imovel, data_visita, status)
VALUES
    (1, 1, '2026-03-12', 'realizada'),
    (2, 3, '2026-03-14', 'realizada'),
    (3, 2, '2026-03-15', 'confirmada'),
    (4, 6, '2026-03-18', 'confirmada'),
    (5, 3, '2026-03-20', 'cancelada'),
    (6, 4, '2026-03-22', 'cancelada'); -- Registro auxiliar para teste de DELETE

-- Tabela: propostas (Ofertas formais)
INSERT INTO propostas (id_cliente, id_imovel, valor_proposto, data_proposta, status)
VALUES
    (1, 1, 400000.00, '2026-03-13', 'aceita'),
    (2, 3, 2400.00, '2026-03-15', 'recusada'),
    (3, 2, 750000.00, '2026-03-16', 'em análise'),
    (4, 6, 560000.00, '2026-03-19', 'em análise'),
    (5, 3, 2200.00, '2026-03-21', 'recusada'); -- Registro auxiliar para teste de DELETE

-- Tabela: contratos (Fechamentos consolidados)
INSERT INTO contratos (id_imovel, id_cliente, id_corretor, valor_final, tipo, data_fechamento)
VALUES
    (1, 1, 1, 400000.00, 'venda', '2026-03-14');

-- ============================================================
-- 4. VERIFICAÇÃO APÓS OS INSERTS
-- ============================================================
SELECT * FROM corretores;
SELECT * FROM clientes;
SELECT * FROM imoveis;
SELECT * FROM gestoes;
SELECT * FROM visitas;
SELECT * FROM propostas;
SELECT * FROM contratos;

-- ============================================================
-- 5. UPDATES (Mínimo 3 operações com WHERE)
-- ============================================================

-- UPDATE 1: Atualizar o orçamento do cliente 1 após negociação
SELECT * FROM clientes WHERE id_cliente = 1;

UPDATE clientes
SET orcamento = 480000.00
WHERE id_cliente = 1;

SELECT * FROM clientes WHERE id_cliente = 1;

-- UPDATE 2: Atualizar o status do imóvel 1 para 'vendido' após contrato
SELECT * FROM imoveis WHERE id_imovel = 1;

UPDATE imoveis
SET status = 'vendido'
WHERE id_imovel = 1;

SELECT * FROM imoveis WHERE id_imovel = 1;

-- UPDATE 3: Concluir uma visita reagendada alterando status para 'realizada'
SELECT * FROM visitas WHERE id_visita = 3;

UPDATE visitas
SET status = 'realizada'
WHERE id_visita = 3;

SELECT * FROM visitas WHERE id_visita = 3;

-- ============================================================
-- 6. DELETES (Mínimo 2 operações seguras com WHERE)
-- ============================================================

-- DELETE 1: Remover visita cancelada de teste que não gerou histórico
SELECT * FROM visitas WHERE id_visita = 6;

DELETE FROM visitas
WHERE id_visita = 6;

SELECT * FROM visitas WHERE id_visita = 6;

-- DELETE 2: Excluir proposta antiga rejeitada sem vínculo contratual
SELECT * FROM propostas WHERE id_proposta = 5;

DELETE FROM propostas
WHERE id_proposta = 5;

SELECT * FROM propostas WHERE id_proposta = 5;

-- ============================================================
-- 7. VERIFICAÇÃO FINAL DAS TABELAS
-- ============================================================
SELECT * FROM visitas;
SELECT * FROM propostas;
SELECT * FROM imoveis;
SELECT * FROM clientes;