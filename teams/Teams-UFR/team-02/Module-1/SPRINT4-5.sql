-- ============================================================
-- IDENTIFICACAO
-- ============================================================
-- Aluno: Rafael Tokashiki Souza
-- Disciplina: Laboratorio de Banco de Dados
-- Sprint: 4/5 - Consultas SQL e expressoes
-- Banco: imobiliaria
-- ============================================================


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE imobiliaria;


-- ============================================================
-- 1. CONSULTAS BASICAS
-- ============================================================

-- Consulta 01
-- Pergunta: Quais imoveis estao cadastrados na carteira?

SELECT * FROM imoveis;


-- Consulta 02
-- Pergunta: Qual e a lista resumida dos imoveis para o anuncio?
-- Apenas as colunas que interessam ao cliente final.

SELECT titulo,
       tipo,
       bairro,
       quartos,
       preco
FROM imoveis;


-- ============================================================
-- 2. WHERE
-- ============================================================

-- Consulta 03
-- Pergunta da Sprint 1/5 (n.1):
-- Quais imoveis estao disponiveis para venda no bairro Vila Aurora?

SELECT titulo, bairro, preco
FROM imoveis
WHERE finalidade = 'Venda'
  AND bairro = 'Vila Aurora';


-- Consulta 04
-- Pergunta da Sprint 1/5 (n.2):
-- Quais imoveis de aluguel custam ate R$ 2.000,00 e ainda estao disponiveis?
-- Duas condicoes combinadas com AND.

SELECT titulo, bairro, preco, valor_condominio
FROM imoveis
WHERE finalidade = 'Aluguel'
  AND preco <= 2000.00
  AND disponivel = TRUE;


-- Consulta 05
-- Pergunta: Quais imoveis tem preco entre R$ 280.000 e R$ 500.000?
-- Uso de BETWEEN.

SELECT titulo, tipo, preco
FROM imoveis
WHERE preco BETWEEN 280000.00 AND 500000.00;


-- Consulta 06
-- Pergunta: Quais imoveis sao casas, sobrados ou apartamentos?
-- Uso de IN.

SELECT titulo, tipo, quartos, preco
FROM imoveis
WHERE tipo IN ('Casa', 'Sobrado', 'Apartamento');


-- Consulta 07
-- Pergunta: Quais contratos ainda estao em vigor (possuem data de termino)?
-- Uso de IS NOT NULL para separar locacoes de vendas.

SELECT id_contrato, tipo_contrato, valor, data_inicio, data_fim
FROM contratos
WHERE data_fim IS NOT NULL;


-- Consulta 08
-- Pergunta: Quais imoveis ficam em bairros cujo nome contem "Jardim"?
-- Uso de LIKE.

SELECT titulo, bairro, cidade
FROM imoveis
WHERE bairro LIKE '%Jardim%';


-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- Consulta 09
-- Pergunta: Quais sao os imoveis mais caros da carteira?

SELECT titulo, tipo, preco
FROM imoveis
ORDER BY preco DESC;


-- Consulta 10
-- Pergunta: Como fica a carteira organizada por tipo e, dentro de cada
-- tipo, do mais caro para o mais barato?
-- Ordenacao por duas colunas.

SELECT tipo, titulo, preco
FROM imoveis
ORDER BY tipo ASC, preco DESC;


-- ============================================================
-- 4. FUNCOES DE AGREGACAO
-- ============================================================

-- Consulta 11 - COUNT
-- Pergunta: Quantos imoveis existem na carteira?

SELECT COUNT(*) AS total_imoveis
FROM imoveis;


-- Consulta 12 - COUNT com WHERE
-- Pergunta: Quantos imoveis ainda estao disponiveis para negociacao?

SELECT COUNT(*) AS imoveis_disponiveis
FROM imoveis
WHERE disponivel = TRUE;


-- Consulta 13 - SUM
-- Pergunta: Qual e o valor total movimentado pelos contratos fechados?

SELECT SUM(valor) AS valor_total_contratos
FROM contratos;


-- Consulta 14 - AVG
-- Pergunta: Qual e o preco medio dos imoveis a venda?

SELECT ROUND(AVG(preco), 2) AS preco_medio_venda
FROM imoveis
WHERE finalidade = 'Venda';


-- Consulta 15 - MIN e MAX
-- Pergunta: Qual e o imovel mais barato e o mais caro da carteira?

SELECT MIN(preco) AS menor_preco,
       MAX(preco) AS maior_preco
FROM imoveis;


-- ============================================================
-- 5. GROUP BY
-- ============================================================

-- Consulta 16
-- Pergunta da Sprint 1/5 (n.3):
-- Quantos imoveis existem na carteira em cada tipo?

SELECT tipo,
       COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
ORDER BY quantidade DESC;


-- Consulta 17
-- Pergunta da Sprint 1/5 (n.4):
-- Qual e o preco medio dos imoveis por finalidade?

SELECT finalidade,
       COUNT(*) AS quantidade,
       ROUND(AVG(preco), 2) AS preco_medio
FROM imoveis
GROUP BY finalidade;


-- Consulta 18
-- Pergunta: Quantas visitas cada corretor realizou?
-- GROUP BY com JOIN para trazer o nome do corretor.

SELECT corretores.nome AS corretor,
       COUNT(visitas.id_visita) AS total_visitas
FROM visitas
INNER JOIN corretores ON visitas.id_corretor = corretores.id_corretor
GROUP BY corretores.nome
ORDER BY total_visitas DESC;


-- ============================================================
-- 6. HAVING
-- ============================================================

-- Consulta 19
-- Pergunta: Quais tipos de imovel possuem mais de uma unidade na carteira?
-- HAVING filtra os GRUPOS, nao os registros.

SELECT tipo,
       COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
HAVING COUNT(*) > 1;


-- Consulta 20
-- Pergunta: Quais proprietarios possuem 2 ou mais imoveis na carteira?
-- Combina JOIN, GROUP BY e HAVING.

SELECT proprietarios.nome AS proprietario,
       COUNT(imoveis.id_imovel) AS total_imoveis,
       SUM(imoveis.preco) AS valor_total_carteira
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
GROUP BY proprietarios.nome
HAVING COUNT(imoveis.id_imovel) >= 2
ORDER BY valor_total_carteira DESC;


-- ============================================================
-- 7. EXPRESSOES SQL
-- ============================================================

-- Consulta 21
-- Pergunta: Qual seria a comissao da imobiliaria em cada imovel a venda,
-- considerando a taxa de 6% praticada no mercado?

SELECT titulo,
       preco,
       ROUND(preco * 0.06, 2) AS comissao_6_porcento
FROM imoveis
WHERE finalidade = 'Venda'
ORDER BY comissao_6_porcento DESC;


-- Consulta 22
-- Pergunta: Qual e o custo mensal real de cada imovel de aluguel,
-- somando o valor do aluguel ao condominio?

SELECT titulo,
       preco AS aluguel,
       valor_condominio,
       preco + valor_condominio AS custo_mensal_total
FROM imoveis
WHERE finalidade = 'Aluguel'
ORDER BY custo_mensal_total ASC;


-- Consulta 23
-- Pergunta: Qual e o preco por metro quadrado de cada imovel a venda?
-- Permite comparar imoveis de tamanhos diferentes.

SELECT titulo,
       area_m2,
       preco,
       ROUND(preco / area_m2, 2) AS preco_por_m2
FROM imoveis
WHERE finalidade = 'Venda'
  AND area_m2 > 0
ORDER BY preco_por_m2 DESC;


-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

-- Consulta 24
-- Pergunta da Sprint 1/5 (n.5):
-- Quem e o proprietario de cada imovel da carteira?

SELECT imoveis.titulo,
       imoveis.tipo,
       imoveis.preco,
       proprietarios.nome AS proprietario,
       proprietarios.telefone
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
ORDER BY proprietarios.nome;


-- Consulta 25
-- Pergunta: Qual foi o historico completo de visitas, com cliente,
-- imovel e corretor?
-- JOIN entre quatro tabelas.

SELECT visitas.data_visita,
       clientes.nome   AS cliente,
       imoveis.titulo  AS imovel,
       corretores.nome AS corretor,
       visitas.observacao
FROM visitas
INNER JOIN clientes    ON visitas.id_cliente   = clientes.id_cliente
INNER JOIN imoveis     ON visitas.id_imovel    = imoveis.id_imovel
INNER JOIN corretores  ON visitas.id_corretor  = corretores.id_corretor
ORDER BY visitas.data_visita;


-- Consulta 26
-- Pergunta: Quais contratos foram fechados e por qual corretor?

SELECT contratos.tipo_contrato,
       imoveis.titulo   AS imovel,
       clientes.nome    AS cliente,
       corretores.nome  AS corretor,
       contratos.valor,
       contratos.data_inicio
FROM contratos
INNER JOIN imoveis    ON contratos.id_imovel   = imoveis.id_imovel
INNER JOIN clientes   ON contratos.id_cliente  = clientes.id_cliente
INNER JOIN corretores ON contratos.id_corretor = corretores.id_corretor
ORDER BY contratos.data_inicio;


-- Consulta 27
-- Pergunta: Qual e o valor total de contratos fechados por tipo,
-- e quantos contratos de cada tipo existem?

SELECT tipo_contrato,
       COUNT(*) AS quantidade,
       SUM(valor) AS valor_total,
       ROUND(AVG(valor), 2) AS valor_medio
FROM contratos
GROUP BY tipo_contrato;
