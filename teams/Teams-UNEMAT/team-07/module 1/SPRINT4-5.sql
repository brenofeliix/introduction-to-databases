-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- Aluna: Talita de Oliveira Leite Sete
-- Banco: secretaria_saude

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================
USE secretaria_saude;

-- ============================================================
-- 1. CONSULTAS BÁSICAS E COLUNAS ESPECÍFICAS
-- ============================================================
SELECT * FROM paciente;
SELECT id_paciente, nome, cpf FROM paciente;

-- ============================================================
-- 2. WHERE (Perguntas 1 e 3)
-- ============================================================
-- 1. Quais pacientes estão cadastrados em determinada unidade? (ex: Unidade 2)
-- Usa DISTINCT para não repetir o paciente caso tenha ido 2 vezes na mesma unidade
SELECT DISTINCT id_paciente 
FROM atendimento 
WHERE id_unidade = 2;

-- 3. Quais unidades têm estoque baixo de determinada vacina?
SELECT id_unidade, nome, quantidade 
FROM estoque_item 
WHERE tipo = 'VACINA' AND quantidade < 50;

-- ============================================================
-- 3. ORDER BY (Pergunta 5)
-- ============================================================
-- 5. Quais pacientes têm atendimentos agendados para os próximos dias?
SELECT id_paciente, data_hora, tipo_atendimento 
FROM atendimento 
WHERE status = 'AGENDADO' AND data_hora >= '2026-10-26'
ORDER BY data_hora ASC;

-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================
SELECT COUNT(*) AS total_obitos FROM obito;

SELECT SUM(quantidade) AS total_vacinas_rede 
FROM estoque_item 
WHERE tipo = 'VACINA';

SELECT AVG(quantidade) AS media_estoque_medicamentos 
FROM estoque_item
WHERE tipo = 'MEDICAMENTO';

SELECT MIN(data_hora) AS proximo_atendimento, MAX(data_hora) AS ultimo_agendamento
FROM atendimento 
WHERE status = 'AGENDADO';

-- ============================================================
-- 5. GROUP BY (Perguntas 2, 4 e 6)
-- ============================================================
-- 4. Qual o número de óbitos registrados por unidade/período?
SELECT unidade_responsavel, COUNT(*) AS total_obitos 
FROM obito 
GROUP BY unidade_responsavel;

-- 6. Qual o tipo de atendimento mais frequente por unidade?
SELECT id_unidade, tipo_atendimento, COUNT(*) AS frequencia 
FROM atendimento 
GROUP BY id_unidade, tipo_atendimento 
ORDER BY id_unidade, frequencia DESC;

-- ============================================================
-- 6. HAVING (Filtro sobre a Pergunta 2)
-- ============================================================
-- 2. Quantos atendimentos cada profissional realizou no mês? (Mostrando só os >= 2)
SELECT id_profissional, COUNT(*) AS total_atendimentos 
FROM atendimento 
WHERE status = 'REALIZADO' 
GROUP BY id_profissional 
HAVING COUNT(*) >= 2;

-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================
SELECT nome, quantidade, (quantidade * 0.10) AS meta_reposicao 
FROM estoque_item;