-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2 — SPRINT 3/5 — VIEWS
-- ATIVIDADE INDIVIDUAL
-- ============================================================
-- ALUNO: NICOLAS LINO OLIVEIRA
-- TEMA DO BANCO: Gestão de Imobiliária (Corretores de Imóveis)
-- NOME DO BANCO: banco_imobiliaria
-- ============================================================

USE banco_imobiliaria;


-- ============================================================
-- 1. VIEW 1 — RELACIONAMENTO ENTRE TABELAS
-- ============================================================
-- Pergunta: quem visitou qual imóvel, quando e com qual situação?
-- Tabelas: visitas + clientes + imoveis

CREATE VIEW vw_visitas_detalhadas AS
SELECT
    v.id_visita,
    c.nome AS cliente,
    c.contato,
    i.endereco,
    i.tipo,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel;


-- ============================================================
-- 2. VIEW 2 — AGREGAÇÃO / RESUMO
-- ============================================================
-- Pergunta: quantos contratos, quanto vendido e qual comissão por corretor?
-- Tabelas: corretores + contratos (LEFT JOIN mantém quem não vendeu)

CREATE VIEW vw_resumo_corretores AS
SELECT
    cor.id_corretor,
    cor.nome AS corretor,
    cor.creci,
    cor.comissao_percentual,
    COUNT(ct.id_contrato) AS contratos_fechados,
    COALESCE(SUM(ct.valor_final), 0) AS total_vendido,
    COALESCE(SUM(ct.valor_final * cor.comissao_percentual / 100), 0) AS comissao_total
FROM corretores AS cor
LEFT JOIN contratos AS ct
    ON cor.id_corretor = ct.id_corretor
GROUP BY cor.id_corretor, cor.nome, cor.creci, cor.comissao_percentual;


-- ============================================================
-- 3. VIEW 3 — CONSULTA OPERACIONAL
-- ============================================================
-- Pergunta: quais imóveis estão disponíveis e quem é o corretor responsável?
-- Tabelas: imoveis + gestoes + corretores (somente gestão ativa)

CREATE VIEW vw_imoveis_disponiveis AS
SELECT
    i.id_imovel,
    i.endereco,
    i.tipo,
    i.preco,
    i.observacoes,
    cor.nome AS corretor_responsavel,
    cor.creci
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
WHERE i.status = 'disponível'
  AND g.data_fim IS NULL;


-- ============================================================
-- 4. CONSULTANDO AS VIEWS
-- ============================================================

SELECT * FROM vw_visitas_detalhadas;

-- Com filtro: somente visitas realizadas
SELECT *
FROM vw_visitas_detalhadas
WHERE status_visita = 'realizada';

SELECT * FROM vw_resumo_corretores
ORDER BY comissao_total DESC;

SELECT * FROM vw_imoveis_disponiveis;

-- Com filtro: somente casas disponíveis
SELECT *
FROM vw_imoveis_disponiveis
WHERE tipo = 'casa'
ORDER BY preco ASC;


-- ============================================================
-- 5. CREATE OR REPLACE VIEW
-- ============================================================
-- Alteração: incluir a data em que o corretor assumiu o imóvel (gestao_desde)

CREATE OR REPLACE VIEW vw_imoveis_disponiveis AS
SELECT
    i.id_imovel,
    i.endereco,
    i.tipo,
    i.preco,
    i.observacoes,
    cor.nome AS corretor_responsavel,
    cor.creci,
    g.data_inicio AS gestao_desde
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
WHERE i.status = 'disponível'
  AND g.data_fim IS NULL;

SELECT * FROM vw_imoveis_disponiveis;


-- ============================================================
-- 6. VIEW TEMPORÁRIA E DROP VIEW
-- ============================================================

CREATE VIEW vw_teste AS
SELECT
    id_cliente,
    nome
FROM clientes
WHERE tipo_interesse = 'compra';

SELECT * FROM vw_teste;

DROP VIEW vw_teste;


-- ============================================================
-- 7. VALIDAÇÃO — LISTAR AS VIEWS
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ============================================================
-- 8. TESTE DE ATUALIZAÇÃO DOS DADOS-BASE
-- ============================================================
-- A VIEW não guarda dados: ela executa a consulta toda vez.
-- Ao alterar a tabela base, a VIEW muda automaticamente.

-- Antes (imóvel 3 aparece):
SELECT id_imovel, endereco, tipo
FROM vw_imoveis_disponiveis;

-- Alteração na tabela base:
UPDATE imoveis
SET status = 'alugado'
WHERE id_imovel = 3;

-- Depois (imóvel 3 sumiu da VIEW):
SELECT id_imovel, endereco, tipo
FROM vw_imoveis_disponiveis;

-- Reverter para manter os dados originais:
UPDATE imoveis
SET status = 'disponível'
WHERE id_imovel = 3;

SELECT id_imovel, endereco, tipo
FROM vw_imoveis_disponiveis;
