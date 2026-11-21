-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2 — SPRINT 5/5 — INTEGRAÇÃO FINAL
-- TRIGGERS, TRANSAÇÕES E VALIDAÇÃO
-- ATIVIDADE INDIVIDUAL
-- ============================================================
-- ALUNO: NICOLAS LINO OLIVEIRA
-- TEMA DO BANCO: Gestão de Imobiliária (Corretores de Imóveis)
-- NOME DO BANCO: banco_imobiliaria
-- ============================================================
-- Este script usa o banco criado no Module-1 (não recria tabelas)
-- e pode ser executado mais de uma vez: todos os testes que alteram
-- dados terminam restaurando o estado original.
-- ============================================================

USE banco_imobiliaria;


-- ============================================================
-- 1. JOINS — CONSULTA RELACIONAL FINAL
-- ============================================================
-- Pergunta:
-- Para cada imóvel, quem é o corretor responsável (gestão ativa)
-- e quantas visitas o imóvel já recebeu?
-- (LEFT JOIN em visitas mantém imóveis sem nenhuma visita)

SELECT
    i.id_imovel,
    i.endereco,
    cor.nome AS corretor_responsavel,
    COUNT(v.id_visita) AS total_visitas
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
   AND g.data_fim IS NULL
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
LEFT JOIN visitas AS v
    ON i.id_imovel = v.id_imovel
GROUP BY i.id_imovel, i.endereco, cor.nome
ORDER BY total_visitas DESC, i.id_imovel ASC;


-- ============================================================
-- 2. SUBCONSULTAS — CONSULTA FINAL
-- ============================================================
-- Pergunta:
-- Quais clientes interessados em compra têm orçamento acima do
-- preço médio dos imóveis disponíveis?

SELECT
    nome,
    contato,
    orcamento
FROM clientes
WHERE tipo_interesse = 'compra'
  AND orcamento > (
      SELECT AVG(preco)
      FROM imoveis
      WHERE status = 'disponível'
  )
ORDER BY orcamento DESC;


-- ============================================================
-- 3. VIEWS
-- ============================================================

CREATE OR REPLACE VIEW vw_visitas_detalhadas AS
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

CREATE OR REPLACE VIEW vw_resumo_corretores AS
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

SELECT * FROM vw_visitas_detalhadas;
SELECT * FROM vw_resumo_corretores ORDER BY comissao_total DESC;
SELECT * FROM vw_imoveis_disponiveis;


-- ============================================================
-- 4. PROCEDURES, FUNCTION E TRIGGERS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_listar_imoveis_por_tipo;
DROP PROCEDURE IF EXISTS sp_registrar_proposta;
DROP FUNCTION IF EXISTS fn_calcular_comissao;
DROP TRIGGER IF EXISTS tg_proposta_valida_valor;
DROP TRIGGER IF EXISTS tg_contrato_atualiza_status_imovel;

DELIMITER //

-- PROCEDURE 1 — parâmetro IN: lista imóveis de um tipo
CREATE PROCEDURE sp_listar_imoveis_por_tipo(
    IN p_tipo VARCHAR(50)
)
BEGIN
    SELECT
        id_imovel,
        endereco,
        tipo,
        preco,
        status
    FROM imoveis
    WHERE tipo = p_tipo
    ORDER BY preco ASC;
END //

-- PROCEDURE 2 — registra proposta validando o valor (IF/ELSE)
CREATE PROCEDURE sp_registrar_proposta(
    IN p_id_cliente INT,
    IN p_id_imovel INT,
    IN p_valor DECIMAL(12, 2)
)
BEGIN
    IF p_valor <= 0 THEN
        SELECT 'ERRO: o valor da proposta deve ser maior que zero.' AS mensagem;
    ELSE
        INSERT INTO propostas (id_cliente, id_imovel, valor_proposto, data_proposta, status)
        VALUES (p_id_cliente, p_id_imovel, p_valor, CURDATE(), 'em análise');

        SELECT
            'Proposta registrada com sucesso.' AS mensagem,
            LAST_INSERT_ID() AS id_proposta;
    END IF;
END //

-- FUNCTION — comissão do corretor sobre um valor
CREATE FUNCTION fn_calcular_comissao(
    p_id_corretor INT,
    p_valor DECIMAL(12, 2)
)
RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE v_percentual DECIMAL(5, 2);

    SET v_percentual = (
        SELECT comissao_percentual
        FROM corretores
        WHERE id_corretor = p_id_corretor
    );

    IF v_percentual IS NULL THEN
        RETURN 0;
    ELSE
        RETURN p_valor * v_percentual / 100;
    END IF;
END //

-- TRIGGER 1 — BEFORE INSERT em propostas
-- Regra de negócio: uma proposta não pode ter valor menor ou igual a zero.
-- O banco bloqueia o INSERT mesmo que ele venha de fora da procedure.
CREATE TRIGGER tg_proposta_valida_valor
BEFORE INSERT ON propostas
FOR EACH ROW
BEGIN
    IF NEW.valor_proposto <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Valor da proposta deve ser maior que zero.';
    END IF;
END //

-- TRIGGER 2 — AFTER INSERT em contratos
-- Automação: ao fechar um contrato, o status do imóvel é atualizado
-- sozinho ('vendido' para venda e 'alugado' para aluguel).
CREATE TRIGGER tg_contrato_atualiza_status_imovel
AFTER INSERT ON contratos
FOR EACH ROW
BEGIN
    IF NEW.tipo = 'venda' THEN
        UPDATE imoveis
        SET status = 'vendido'
        WHERE id_imovel = NEW.id_imovel;
    ELSEIF NEW.tipo = 'aluguel' THEN
        UPDATE imoveis
        SET status = 'alugado'
        WHERE id_imovel = NEW.id_imovel;
    END IF;
END //

DELIMITER ;


-- ============================================================
-- 5. TESTES — PROCEDURES E FUNCTION
-- ============================================================

CALL sp_listar_imoveis_por_tipo('casa');
CALL sp_listar_imoveis_por_tipo('apartamento');

-- Valor inválido: a procedure mostra a mensagem e não insere nada
CALL sp_registrar_proposta(6, 4, 0);

SELECT fn_calcular_comissao(1, 500000.00) AS comissao_corretor_1;
SELECT fn_calcular_comissao(99, 100000.00) AS comissao_corretor_inexistente;


-- ============================================================
-- 6. TESTE DO TRIGGER 1 (tg_proposta_valida_valor)
-- ============================================================

-- Teste com valor válido (dentro de uma transação desfeita no final)
SELECT * FROM propostas WHERE id_cliente = 6;      -- antes: vazio

START TRANSACTION;
CALL sp_registrar_proposta(6, 4, 300000.00);
SELECT * FROM propostas WHERE id_cliente = 6;      -- durante: 1 proposta
ROLLBACK;

SELECT * FROM propostas WHERE id_cliente = 6;      -- depois: vazio

-- Teste com valor inválido (descomente para ver o erro; ele interrompe o script):
-- INSERT INTO propostas (id_cliente, id_imovel, valor_proposto, data_proposta, status)
-- VALUES (6, 4, -500.00, CURDATE(), 'em análise');
-- Erro esperado: Error Code: 1644. Valor da proposta deve ser maior que zero.


-- ============================================================
-- 7. TRANSAÇÃO COM COMMIT + TESTE DO TRIGGER 2
-- ============================================================
-- Objetivo: aceitar a proposta 3 e fechar o contrato de venda do
-- imóvel 2. As duas operações devem ocorrer juntas.

-- Antes
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 2;
SELECT id_proposta, status FROM propostas WHERE id_proposta = 3;
SELECT COUNT(*) AS total_contratos FROM contratos;

START TRANSACTION;

UPDATE propostas
SET status = 'aceita'
WHERE id_proposta = 3;

INSERT INTO contratos (id_imovel, id_cliente, id_corretor, valor_final, tipo, data_fechamento)
VALUES (2, 3, 2, 750000.00, 'venda', CURDATE());

COMMIT;

-- Depois (o trigger marcou o imóvel 2 como 'vendido')
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 2;
SELECT id_proposta, status FROM propostas WHERE id_proposta = 3;
SELECT COUNT(*) AS total_contratos FROM contratos;

-- A VIEW já reflete o novo contrato
SELECT * FROM vw_resumo_corretores ORDER BY comissao_total DESC;

-- Restaurar os dados originais
DELETE FROM contratos
WHERE id_imovel = 2
  AND id_cliente = 3
  AND tipo = 'venda';

UPDATE imoveis
SET status = 'disponível'
WHERE id_imovel = 2;

UPDATE propostas
SET status = 'em análise'
WHERE id_proposta = 3;


-- ============================================================
-- 8. TRANSAÇÃO COM ROLLBACK
-- ============================================================
-- Objetivo: simular o fechamento do imóvel 6 e desfazer tudo
-- (por exemplo, o cliente desistiu antes de assinar).

-- Antes
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 6;
SELECT id_proposta, status FROM propostas WHERE id_proposta = 4;
SELECT COUNT(*) AS total_contratos FROM contratos;

START TRANSACTION;

UPDATE propostas
SET status = 'aceita'
WHERE id_proposta = 4;

INSERT INTO contratos (id_imovel, id_cliente, id_corretor, valor_final, tipo, data_fechamento)
VALUES (6, 4, 1, 560000.00, 'venda', CURDATE());

-- Dentro da transação (visível apenas nesta sessão): imóvel 6 'vendido'
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 6;

ROLLBACK;

-- Depois: tudo voltou ao estado anterior
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 6;
SELECT id_proposta, status FROM propostas WHERE id_proposta = 4;
SELECT COUNT(*) AS total_contratos FROM contratos;


-- ============================================================
-- 9. VALIDAÇÃO FINAL
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SHOW PROCEDURE STATUS WHERE Db = 'banco_imobiliaria';
SHOW FUNCTION STATUS WHERE Db = 'banco_imobiliaria';
SHOW TRIGGERS;

-- Conferência: os dados voltaram ao estado original?
SELECT id_imovel, status FROM imoveis ORDER BY id_imovel;
SELECT id_proposta, status FROM propostas ORDER BY id_proposta;
SELECT * FROM contratos;
