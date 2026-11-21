-- ============================================================
-- LABORATÓRIO DE BANCO DE DADOS
-- MODULE 2 — SPRINT 4/5 — PROCEDURES E FUNCTIONS
-- ATIVIDADE INDIVIDUAL
-- ============================================================
-- ALUNO: NICOLAS LINO OLIVEIRA
-- TEMA DO BANCO: Gestão de Imobiliária (Corretores de Imóveis)
-- NOME DO BANCO: banco_imobiliaria
-- ============================================================

USE banco_imobiliaria;

-- Remove rotinas antigas (permite executar o script mais de uma vez)
DROP PROCEDURE IF EXISTS sp_listar_imoveis_por_tipo;
DROP PROCEDURE IF EXISTS sp_registrar_proposta;
DROP PROCEDURE IF EXISTS sp_contar_visitas_cliente;
DROP FUNCTION IF EXISTS fn_calcular_comissao;

DELIMITER //

-- ============================================================
-- PROCEDURE 1 — PARÂMETRO IN
-- ============================================================
-- Objetivo: listar os imóveis de um determinado tipo.
-- Entrada: p_tipo (casa, apartamento, comercial, terreno)

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


-- ============================================================
-- PROCEDURE 2 — OPERAÇÃO DO DOMÍNIO (COM IF/ELSE)
-- ============================================================
-- Objetivo: registrar uma proposta aplicando a regra de negócio
-- "uma proposta não pode ter valor menor ou igual a zero".
-- A data é a data atual e o status inicial é 'em análise'.

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


-- ============================================================
-- PROCEDURE 3 — PARÂMETRO OUT
-- ============================================================
-- Objetivo: devolver (via OUT) quantas visitas um cliente já tem.

CREATE PROCEDURE sp_contar_visitas_cliente(
    IN p_id_cliente INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM visitas
    WHERE id_cliente = p_id_cliente;
END //


-- ============================================================
-- FUNCTION — COMISSÃO DO CORRETOR
-- ============================================================
-- Objetivo: calcular a comissão (em reais) de um corretor sobre um valor.
-- Recebe: p_id_corretor, p_valor
-- Retorna: valor * percentual / 100 (ou 0 se o corretor não existir)

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

DELIMITER ;


-- ============================================================
-- TESTES — PROCEDURE 1 (sp_listar_imoveis_por_tipo)
-- ============================================================

CALL sp_listar_imoveis_por_tipo('casa');
CALL sp_listar_imoveis_por_tipo('terreno');


-- ============================================================
-- TESTES — PROCEDURE 2 (sp_registrar_proposta)
-- ============================================================

-- Teste 1: valor inválido (nada é inserido)
CALL sp_registrar_proposta(6, 4, 0);

-- Teste 2: valor válido (insere a proposta)
CALL sp_registrar_proposta(6, 4, 300000.00);

SELECT * FROM propostas;

-- Limpeza do registro de teste (mantém os dados originais do projeto)
DELETE FROM propostas
WHERE id_cliente = 6
  AND id_imovel = 4
  AND valor_proposto = 300000.00;

SELECT * FROM propostas;


-- ============================================================
-- TESTES — PROCEDURE 3 (sp_contar_visitas_cliente, com OUT)
-- ============================================================

CALL sp_contar_visitas_cliente(1, @total);
SELECT @total AS visitas_do_cliente_1;

CALL sp_contar_visitas_cliente(6, @total);
SELECT @total AS visitas_do_cliente_6;


-- ============================================================
-- TESTES — FUNCTION (fn_calcular_comissao)
-- ============================================================

SELECT fn_calcular_comissao(1, 500000.00) AS comissao_corretor_1;
SELECT fn_calcular_comissao(2, 400000.00) AS comissao_corretor_2;
SELECT fn_calcular_comissao(99, 100000.00) AS comissao_corretor_inexistente;

-- Uso da função dentro de uma consulta
SELECT
    id_contrato,
    id_corretor,
    valor_final,
    fn_calcular_comissao(id_corretor, valor_final) AS comissao
FROM contratos;


-- ============================================================
-- VALIDAÇÃO — ROTINAS CRIADAS
-- ============================================================

SHOW PROCEDURE STATUS WHERE Db = 'banco_imobiliaria';
SHOW FUNCTION STATUS WHERE Db = 'banco_imobiliaria';
