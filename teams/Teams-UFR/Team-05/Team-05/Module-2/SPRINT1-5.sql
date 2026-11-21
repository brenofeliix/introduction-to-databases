-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2 — SPRINT 1/5 — JOINS E CONSULTAS RELACIONAIS
-- ATIVIDADE INDIVIDUAL
-- ============================================================
-- ALUNO: NICOLAS LINO OLIVEIRA
-- TEMA DO BANCO: Gestão de Imobiliária (Corretores de Imóveis)
-- NOME DO BANCO: banco_imobiliaria
-- ============================================================

USE banco_imobiliaria;


-- ============================================================
-- 1. INNER JOIN 1
-- ============================================================
-- Pergunta:
-- Quais visitas foram agendadas e qual é o nome do cliente de cada uma?
-- Tabelas: visitas + clientes
-- Relação: visitas.id_cliente (FK) = clientes.id_cliente (PK)

SELECT
    v.id_visita,
    c.nome AS cliente,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
ORDER BY v.data_visita ASC;


-- ============================================================
-- 2. INNER JOIN 2
-- ============================================================
-- Pergunta:
-- Quais propostas foram feitas, para qual imóvel e qual a diferença
-- entre o preço anunciado e o valor proposto?
-- Tabelas: propostas + imoveis
-- Relação: propostas.id_imovel (FK) = imoveis.id_imovel (PK)

SELECT
    p.id_proposta,
    i.endereco,
    i.preco AS preco_anunciado,
    p.valor_proposto,
    i.preco - p.valor_proposto AS diferenca,
    p.status AS status_proposta
FROM propostas AS p
INNER JOIN imoveis AS i
    ON p.id_imovel = i.id_imovel
ORDER BY p.id_proposta ASC;


-- ============================================================
-- 3. LEFT JOIN
-- ============================================================
-- Pergunta:
-- Quais são todos os clientes, com suas visitas, incluindo
-- os clientes que ainda não fizeram nenhuma visita?
-- Tabela da esquerda: clientes (todos os registros são mantidos)

SELECT
    c.id_cliente,
    c.nome AS cliente,
    v.data_visita,
    v.status AS status_visita
FROM clientes AS c
LEFT JOIN visitas AS v
    ON c.id_cliente = v.id_cliente
ORDER BY c.id_cliente ASC;

-- Variação: somente os clientes que NUNCA fizeram visita
SELECT
    c.id_cliente,
    c.nome AS cliente,
    c.contato
FROM clientes AS c
LEFT JOIN visitas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_visita IS NULL;


-- ============================================================
-- 4. RIGHT JOIN
-- ============================================================
-- Pergunta:
-- Quais são todos os imóveis e suas propostas, incluindo
-- os imóveis que nunca receberam proposta?
-- Tabela da direita: imoveis (todos os registros são mantidos)

SELECT
    i.id_imovel,
    i.endereco,
    i.status AS status_imovel,
    p.valor_proposto,
    p.status AS status_proposta
FROM propostas AS p
RIGHT JOIN imoveis AS i
    ON p.id_imovel = i.id_imovel
ORDER BY i.id_imovel ASC;


-- ============================================================
-- 5. JOIN COM 3 OU MAIS TABELAS — CONSULTA 1
-- ============================================================
-- Pergunta:
-- Qual cliente visitou qual imóvel, em que data e com qual situação?
-- Tabelas: visitas + clientes + imoveis

SELECT
    c.nome AS cliente,
    i.endereco,
    i.tipo,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel
ORDER BY v.data_visita ASC;


-- ============================================================
-- 6. JOIN COM 3 OU MAIS TABELAS — CONSULTA 2
-- ============================================================
-- Pergunta:
-- Qual corretor é responsável atualmente (gestão ativa) por cada imóvel?
-- Tabelas: imoveis + gestoes + corretores

SELECT
    i.id_imovel,
    i.endereco,
    i.status AS status_imovel,
    cor.nome AS corretor_responsavel,
    cor.creci,
    g.data_inicio
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
WHERE g.data_fim IS NULL
ORDER BY i.id_imovel ASC;


-- ============================================================
-- 7. JOIN + WHERE
-- ============================================================
-- Pergunta:
-- Quais clientes têm propostas ainda 'em análise' e de quanto é cada oferta?

SELECT
    c.nome AS cliente,
    c.contato,
    p.valor_proposto,
    p.data_proposta
FROM propostas AS p
INNER JOIN clientes AS c
    ON p.id_cliente = c.id_cliente
WHERE p.status = 'em análise';


-- ============================================================
-- 8. JOIN + ORDER BY
-- ============================================================
-- Pergunta:
-- Quais visitas ocorreram em cada imóvel, da mais recente para a mais antiga?

SELECT
    v.data_visita,
    i.endereco,
    i.tipo,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel
ORDER BY v.data_visita DESC;


-- ============================================================
-- 9. JOIN + GROUP BY + AGREGAÇÃO
-- ============================================================
-- Pergunta:
-- Quantas visitas cada cliente já fez (incluindo quem não fez nenhuma)?
-- COUNT(v.id_visita) conta só visitas existentes; COUNT(*) contaria
-- 1 para o cliente sem visita, o que seria um erro.

SELECT
    c.id_cliente,
    c.nome AS cliente,
    COUNT(v.id_visita) AS total_visitas
FROM clientes AS c
LEFT JOIN visitas AS v
    ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_visitas DESC, c.nome ASC;


-- ============================================================
-- 10. CONSULTA MAIS ÚTIL DO MÓDULO
-- ============================================================
-- Pergunta:
-- Quantos contratos cada corretor fechou, qual o total vendido
-- e quanto ele recebe de comissão?
-- Tabelas: corretores + contratos (LEFT JOIN mantém quem não vendeu)

SELECT
    cor.nome AS corretor,
    cor.creci,
    cor.comissao_percentual,
    COUNT(ct.id_contrato) AS contratos_fechados,
    COALESCE(SUM(ct.valor_final), 0) AS total_vendido,
    COALESCE(SUM(ct.valor_final * cor.comissao_percentual / 100), 0) AS comissao_total
FROM corretores AS cor
LEFT JOIN contratos AS ct
    ON cor.id_corretor = ct.id_corretor
GROUP BY cor.id_corretor, cor.nome, cor.creci, cor.comissao_percentual
ORDER BY comissao_total DESC, cor.nome ASC;


-- ============================================================
-- 11. CONSULTAS EXTRAS
-- ============================================================

-- Extra 1: Contrato completo (4 tabelas): imóvel, cliente e corretor
SELECT
    ct.id_contrato,
    i.endereco,
    c.nome AS cliente,
    cor.nome AS corretor,
    ct.tipo,
    ct.valor_final,
    ct.data_fechamento
FROM contratos AS ct
INNER JOIN imoveis AS i
    ON ct.id_imovel = i.id_imovel
INNER JOIN clientes AS c
    ON ct.id_cliente = c.id_cliente
INNER JOIN corretores AS cor
    ON ct.id_corretor = cor.id_corretor;

-- Extra 2: Quantidade de imóveis sob gestão ativa por corretor
-- (a condição data_fim IS NULL fica no ON para não eliminar corretores sem imóveis)
SELECT
    cor.nome AS corretor,
    COUNT(g.id_gestao) AS imoveis_sob_gestao
FROM corretores AS cor
LEFT JOIN gestoes AS g
    ON cor.id_corretor = g.id_corretor
   AND g.data_fim IS NULL
GROUP BY cor.id_corretor, cor.nome
ORDER BY imoveis_sob_gestao DESC, cor.nome ASC;
