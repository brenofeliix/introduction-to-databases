-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- SPRINT 4/5 — CONSULTAS SQL E EXPRESSÕES
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
-- 2. CONSULTA BÁSICA COM SELECT
-- ============================================================
-- Pergunta:
-- Quais são todos os imóveis cadastrados no sistema e seus dados completos?

SELECT *
FROM imoveis;


-- ============================================================
-- 3. SELECT COM COLUNAS ESPECÍFICAS
-- ============================================================
-- Pergunta:
-- Qual é o nome, contato e orçamento disponível de cada cliente cadastrado?

SELECT
    nome,
    contato,
    orcamento
FROM clientes;


-- ============================================================
-- 4. CONSULTA COM WHERE
-- ============================================================
-- Pergunta:
-- Quais imóveis possuem valor de anúncio superior a R$ 400.000,00?

SELECT *
FROM imoveis
WHERE preco > 400000.00;


-- ============================================================
-- 5. CONSULTA COM MAIS DE UMA CONDIÇÃO
-- ============================================================
-- Pergunta:
-- Quais imóveis do tipo 'casa' continuam com status 'disponível'?

SELECT *
FROM imoveis
WHERE tipo = 'casa'
  AND status = 'disponível';


-- ============================================================
-- 6. CONSULTA COM LIKE
-- ============================================================
-- Pergunta:
-- Quais imóveis estão localizados em avenidas (endereços iniciados por 'Av.')?

SELECT *
FROM imoveis
WHERE endereco LIKE 'Av.%';


-- ============================================================
-- 7. CONSULTA COM BETWEEN
-- ============================================================
-- Pergunta:
-- Quais propostas formais tiveram valores ofertados entre R$ 200.000,00 e R$ 600.000,00?

SELECT *
FROM propostas
WHERE valor_proposto BETWEEN 200000.00 AND 600000.00;


-- ============================================================
-- 8. CONSULTA COM IN
-- ============================================================
-- Pergunta:
-- Quais visitas constam com situação de 'confirmada' ou 'realizada'?

SELECT *
FROM visitas
WHERE status IN ('confirmada', 'realizada');


-- ============================================================
-- 9. CONSULTA COM IS NULL OU IS NOT NULL
-- ============================================================
-- Pergunta:
-- Quais contratos de gestão de imóveis ainda se encontram ativos (sem data de encerramento definida)?

SELECT *
FROM gestoes
WHERE data_fim IS NULL;


-- ============================================================
-- 10. CONSULTA COM ORDER BY
-- ============================================================
-- Pergunta:
-- Como listar os corretores em ordem alfabética de seus nomes?

SELECT *
FROM corretores
ORDER BY nome ASC;


-- ============================================================
-- 11. ORDER BY DECRESCENTE
-- ============================================================
-- Pergunta:
-- Quais são os imóveis cadastrados ordenados do mais caro ao mais barato?

SELECT *
FROM imoveis
ORDER BY preco DESC;


-- ============================================================
-- 12. ORDER BY COM MAIS DE UMA COLUNA
-- ============================================================
-- Pergunta:
-- Como ordenar os imóveis por tipo em ordem alfabética e, para o mesmo tipo, pelo menor preço primeiro?

SELECT *
FROM imoveis
ORDER BY tipo ASC,
         preco ASC;


-- ============================================================
-- 13. COUNT
-- ============================================================
-- Pergunta:
-- Quantos clientes totais estão cadastrados na base de dados?

SELECT
    COUNT(*) AS total_clientes
FROM clientes;


-- ============================================================
-- 14. COUNT COM WHERE
-- ============================================================
-- Pergunta:
-- Quantas visitas já foram de fato concluídas ('realizada')?

SELECT
    COUNT(*) AS total_visitas_realizadas
FROM visitas
WHERE status = 'realizada';


-- ============================================================
-- 15. SUM
-- ============================================================
-- Pergunta:
-- Qual é o valor financeiro total de todos os imóveis no catálogo?

SELECT
    SUM(preco) AS valor_patrimonial_total
FROM imoveis;


-- ============================================================
-- 16. AVG
-- ============================================================
-- Pergunta:
-- Qual é o preço médio dos imóveis cadastrados?

SELECT
    AVG(preco) AS preco_medio_imoveis
FROM imoveis;


-- ============================================================
-- 17. MIN E MAX
-- ============================================================
-- Pergunta:
-- Qual é o menor e o maior orçamento disponível informado pelos clientes interessados?

SELECT
    MIN(orcamento) AS menor_orcamento,
    MAX(orcamento) AS maior_orcamento
FROM clientes;


-- ============================================================
-- 18. GROUP BY
-- ============================================================
-- Pergunta:
-- Quantos imóveis existem cadastrados por categoria (tipo)?

SELECT
    tipo,
    COUNT(*) AS quantidade_imoveis
FROM imoveis
GROUP BY tipo;


-- ============================================================
-- 19. GROUP BY COM AVG
-- ============================================================
-- Pergunta:
-- Qual é a média de preço dos imóveis de acordo com o seu tipo?

SELECT
    tipo,
    AVG(preco) AS media_preco
FROM imoveis
GROUP BY tipo;


-- ============================================================
-- 20. GROUP BY COM SUM
-- ============================================================
-- Pergunta:
-- Qual é a soma total de valor ofertado nas propostas agrupadas por status?

SELECT
    status,
    SUM(valor_proposto) AS total_valor_propostas
FROM propostas
GROUP BY status;


-- ============================================================
-- 21. HAVING
-- ============================================================
-- Pergunta:
-- Quais tipos de imóveis possuem mais de 1 imóvel cadastrado no catálogo?

SELECT
    tipo,
    COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
HAVING COUNT(*) > 1;


-- ============================================================
-- 22. WHERE + GROUP BY + HAVING
-- ============================================================
-- Pergunta:
-- Dentre os imóveis disponíveis, quais tipos possuem valor médio superior a R$ 300.000,00?

SELECT
    tipo,
    AVG(preco) AS preco_medio
FROM imoveis
WHERE status = 'disponível'
GROUP BY tipo
HAVING AVG(preco) > 300000.00;


-- ============================================================
-- 23. EXPRESSÃO SQL
-- ============================================================
-- Pergunta:
-- Qual seria o novo valor de cada imóvel caso sofresse um reajuste de 8% em seu preço de anúncio?

SELECT
    id_imovel,
    endereco,
    preco AS preco_atual,
    preco * 1.08 AS preco_reajustado_8pct
FROM imoveis;


-- ============================================================
-- 24. EXPRESSÃO COM DOIS CAMPOS
-- ============================================================
-- Pergunta:
-- Qual o valor exato em reais que cada corretor receberia se vendesse um imóvel de R$ 500.000,00 baseado na sua alíquota de comissão?

SELECT
    nome,
    creci,
    comissao_percentual,
    500000.00 * (comissao_percentual / 100) AS comissao_calculada_reais
FROM corretores;


-- ============================================================
-- 25. CONSULTA MAIS ÚTIL DO PROJETO
-- ============================================================
-- Pergunta:
-- Quais imóveis à venda continuam disponíveis e se enquadram na faixa de preço de maior liquidez (até R$ 500.000,00)?

SELECT
    id_imovel,
    endereco,
    tipo,
    preco,
    observacoes
FROM imoveis
WHERE status = 'disponível'
  AND preco <= 500000.00
ORDER BY preco ASC;


-- ============================================================
-- 26. CONSULTA MAIS COMPLEXA DO PROJETO
-- ============================================================
-- Pergunta:
-- Qual a quantidade de propostas registradas e a média dos valores propostos por status, considerando apenas propostas de valor superior a R$ 10.000,00 e filtrando status que possuam ao menos uma oferta?

SELECT
    status,
    COUNT(*) AS total_propostas,
    AVG(valor_proposto) AS ticket_medio,
    MIN(valor_proposto) AS menor_oferta,
    MAX(valor_proposto) AS maior_oferta
FROM propostas
WHERE valor_proposto > 10000.00
GROUP BY status
HAVING COUNT(*) >= 1
ORDER BY ticket_medio DESC;


-- ============================================================
-- 27. CONSULTAS EXTRAS
-- ============================================================

-- Consulta extra 1: Relação de clientes que buscam especificamente compra e possuem orçamento acima de R$ 400.000,00
SELECT
    nome,
    contato,
    orcamento
FROM clientes
WHERE tipo_interesse = 'compra'
  AND orcamento >= 400000.00
ORDER BY orcamento DESC;

-- Consulta extra 2: Balanço de visitas realizadas por dia de agendamento
SELECT
    data_visita,
    COUNT(*) AS total_visitas_no_dia
FROM visitas
GROUP BY data_visita
ORDER BY data_visita ASC;

-- Consulta extra 3: Apuração da receita gerada no contrato fechado
SELECT
    id_contrato,
    valor_final,
    tipo,
    data_fechamento
FROM contratos
WHERE tipo = 'venda';