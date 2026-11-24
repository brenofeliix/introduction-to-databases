-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2 — SPRINT 2/5 — SUBCONSULTAS
-- ATIVIDADE INDIVIDUAL
-- ============================================================
-- ALUNO: NICOLAS LINO OLIVEIRA
-- TEMA DO BANCO: Gestão de Imobiliária (Corretores de Imóveis)
-- NOME DO BANCO: banco_imobiliaria
-- ============================================================

USE banco_imobiliaria;


-- ============================================================
-- 1. SUBCONSULTA COM COMPARAÇÃO
-- ============================================================
-- Pergunta:
-- Quais imóveis estão com preço acima da média de todos os imóveis?
-- Consulta interna: calcula a média de preço (um único valor).
-- Consulta externa: devolve os imóveis com preço maior que essa média.

SELECT
    id_imovel,
    endereco,
    tipo,
    preco
FROM imoveis
WHERE preco > (
    SELECT AVG(preco)
    FROM imoveis
)
ORDER BY preco DESC;


-- ============================================================
-- 2. SUBCONSULTA COM IN
-- ============================================================
-- Pergunta:
-- Quais clientes já fizeram pelo menos uma proposta?
-- Consulta interna: lista os id_cliente que aparecem em propostas.

SELECT
    id_cliente,
    nome,
    contato
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM propostas
);


-- ============================================================
-- 3. SUBCONSULTA COM NOT IN
-- ============================================================
-- Pergunta:
-- Quais imóveis nunca receberam nenhuma visita?
-- Obs.: visitas.id_imovel é NOT NULL, então o NOT IN é seguro
-- (se a subconsulta devolvesse algum NULL, o NOT IN não retornaria nada).

SELECT
    id_imovel,
    endereco,
    tipo,
    preco
FROM imoveis
WHERE id_imovel NOT IN (
    SELECT id_imovel
    FROM visitas
);


-- ============================================================
-- 4. EXISTS
-- ============================================================
-- Pergunta:
-- Quais corretores já fecharam pelo menos um contrato?

SELECT
    cor.id_corretor,
    cor.nome,
    cor.creci
FROM corretores AS cor
WHERE EXISTS (
    SELECT 1
    FROM contratos AS ct
    WHERE ct.id_corretor = cor.id_corretor
);


-- ============================================================
-- 5. NOT EXISTS
-- ============================================================
-- Pergunta:
-- Quais clientes ainda não fizeram nenhuma visita?

SELECT
    c.id_cliente,
    c.nome,
    c.contato
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM visitas AS v
    WHERE v.id_cliente = c.id_cliente
);


-- ============================================================
-- 6. SUBCONSULTA COM MAX
-- ============================================================
-- Pergunta:
-- Qual é o imóvel mais caro do catálogo?

SELECT
    id_imovel,
    endereco,
    tipo,
    preco
FROM imoveis
WHERE preco = (
    SELECT MAX(preco)
    FROM imoveis
);

-- Variação com MIN: qual é a menor proposta já registrada?
SELECT
    id_proposta,
    id_cliente,
    id_imovel,
    valor_proposto,
    status
FROM propostas
WHERE valor_proposto = (
    SELECT MIN(valor_proposto)
    FROM propostas
);


-- ============================================================
-- 7. SUBCONSULTA CORRELACIONADA
-- ============================================================
-- Pergunta:
-- Quais imóveis custam mais do que a média dos imóveis do MESMO tipo?
-- A subconsulta usa i.tipo (coluna da consulta externa), então ela é
-- recalculada para cada imóvel avaliado.

SELECT
    i.id_imovel,
    i.endereco,
    i.tipo,
    i.preco
FROM imoveis AS i
WHERE i.preco > (
    SELECT AVG(i2.preco)
    FROM imoveis AS i2
    WHERE i2.tipo = i.tipo
)
ORDER BY i.tipo ASC, i.preco DESC;


-- ============================================================
-- 8. MESMA PERGUNTA COM JOIN E COM SUBQUERY — PROBLEMA 1
-- ============================================================
-- Pergunta:
-- Quais clientes já fizeram pelo menos uma proposta?

-- a) JOIN (DISTINCT evita repetir o cliente que fez várias propostas)
SELECT DISTINCT
    c.id_cliente,
    c.nome
FROM clientes AS c
INNER JOIN propostas AS p
    ON c.id_cliente = p.id_cliente
ORDER BY c.id_cliente ASC;

-- b) SUBQUERY
SELECT
    id_cliente,
    nome
FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente
    FROM propostas
)
ORDER BY id_cliente ASC;


-- ============================================================
-- 9. MESMA PERGUNTA COM JOIN E COM SUBQUERY — PROBLEMA 2
-- ============================================================
-- Pergunta:
-- Quais imóveis nunca receberam visita?

-- a) JOIN (LEFT JOIN + IS NULL)
SELECT
    i.id_imovel,
    i.endereco
FROM imoveis AS i
LEFT JOIN visitas AS v
    ON i.id_imovel = v.id_imovel
WHERE v.id_visita IS NULL
ORDER BY i.id_imovel ASC;

-- b) SUBQUERY (NOT EXISTS)
SELECT
    i.id_imovel,
    i.endereco
FROM imoveis AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM visitas AS v
    WHERE v.id_imovel = i.id_imovel
)
ORDER BY i.id_imovel ASC;


-- ============================================================
-- 10. CONSULTA EXTRA
-- ============================================================
-- Pergunta:
-- Quais imóveis estão sob gestão ativa de corretores que já fecharam contrato?

SELECT
    i.id_imovel,
    i.endereco,
    i.status
FROM imoveis AS i
WHERE i.id_imovel IN (
    SELECT g.id_imovel
    FROM gestoes AS g
    WHERE g.data_fim IS NULL
      AND g.id_corretor IN (
          SELECT ct.id_corretor
          FROM contratos AS ct
      )
);
