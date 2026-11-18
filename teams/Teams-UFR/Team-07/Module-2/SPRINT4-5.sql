p_id_categoria (INT): Identificador único da categoria esportiva a ser consultada.

DELIMITER //

CREATE PROCEDURE sp_listar_atletas_por_categoria(IN p_id_categoria INT)
BEGIN
    SELECT 
        a.id_atleta,
        a.nome_atleta,
        a.genero,
        a.data_nascimento,
        c.nome_categoria,
        c.faixa_etaria
    FROM atleta AS a
    INNER JOIN categoria AS c 
        ON a.id_categoria = c.id_categoria
    WHERE a.id_categoria = p_id_categoria
    ORDER BY a.nome_atleta;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_atualizar_escola_atleta(
    IN p_id_atleta INT,
    IN p_novo_id_escola INT
)
BEGIN
    UPDATE atleta
    SET id_escola = p_novo_id_escola
    WHERE id_atleta = p_id_atleta;
END //

DELIMITER ;

-- Atualiza a escola do atleta com ID 1 para a nova instituição de ensino (ID 2)
CALL sp_atualizar_escola_atleta(1, 2);

DELIMITER //

CREATE PROCEDURE sp_contar_total_atletas(
    OUT p_total_atletas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_atletas
    FROM atleta;
END //

DELIMITER ;

-- Executando a Procedure e recuperando a variável de saída
CALL sp_contar_total_atletas(@total_cadastrados);
SELECT @total_cadastrados AS total_geral_atletas;

DELIMITER //

CREATE FUNCTION fn_calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_idade INT;
    SET v_idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
    RETURN v_idade;
END //

DELIMITER ;

-- Consultando o nome, data de nascimento e a idade calculada pela função para cada atleta
SELECT 
    nome_atleta,
    data_nascimento,
    fn_calcular_idade(data_nascimento) AS idade_atual
FROM atleta;

DELIMITER //

CREATE PROCEDURE sp_verificar_classificacao_etaria(
    IN p_id_atleta INT,
    OUT p_classificacao VARCHAR(50)
)
BEGIN
    DECLARE v_idade INT;
    
    -- Obtém a idade do atleta utilizando a função auxiliar fn_calcular_idade
    SELECT fn_calcular_idade(data_nascimento) INTO v_idade
    FROM atleta
    WHERE id_atleta = p_id_atleta;
    
    -- Aplicação da estrutura condicional IF / ELSE para definição da faixa competitiva
    IF v_idade < 18 THEN
        SET p_classificacao = 'Atleta de Base (Formação)';
    ELSE
        SET p_classificacao = 'Atleta Principal / Adulto';
    END IF;
END //

DELIMITER ;

-- Exemplo de execução:
-- CALL sp_verificar_classificacao_etaria(1, @status_atleta);
-- SELECT @status_atleta AS classificacao_competitiva;

-- Teste 1: Listando atletas da categoria com ID 1 (Ex: Sub-16)
CALL sp_listar_atletas_por_categoria(1);

-- Teste 2: Listando atletas da categoria com ID 3 (Ex: Sub-18)
CALL sp_listar_atletas_por_categoria(3);

-- Teste 1: Atualizando a escola do atleta ID 1 para a instituição ID 2
CALL sp_atualizar_escola_atleta(1, 2);

-- Teste 2: Atualizando a escola do atleta ID 4 para a instituição ID 1
CALL sp_atualizar_escola_atleta(4, 1);

-- Teste 1: Calculando a idade para uma data de nascimento do ano de 2010
SELECT fn_calcular_idade('2010-05-14') AS idade_atleta_1;

-- Teste 2: Calculando a idade para uma data de nascimento do ano de 2008
SELECT fn_calcular_idade('2008-09-22') AS idade_atleta_2;

DELIMITER //

CREATE PROCEDURE sp_verificar_classificacao_etaria(
    IN p_id_atleta INT,
    OUT p_classificacao VARCHAR(50)
)
BEGIN
    DECLARE v_idade INT;
    
    -- Obtém a idade do atleta utilizando a função auxiliar fn_calcular_idade
    SELECT fn_calcular_idade(data_nascimento) INTO v_idade
    FROM atleta
    WHERE id_atleta = p_id_atleta;
    
    -- Aplicação da estrutura condicional IF / ELSE para definição da faixa competitiva
    IF v_idade < 18 THEN
        SET p_classificacao = 'Atleta de Base (Formação)';
    ELSE
        SET p_classificacao = 'Atleta Principal / Adulto';
    END IF;
END //

DELIMITER ;

-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

DELIMITER //

-- =====================================================================
-- 1. PROCEDURE 1 — Parâmetro IN (Listar atletas por categoria)
-- =====================================================================
CREATE PROCEDURE sp_listar_atletas_por_categoria(IN p_id_categoria INT)
BEGIN
    SELECT 
        a.id_atleta,
        a.nome_atleta,
        a.genero,
        a.data_nascimento,
        c.nome_categoria,
        c.faixa_etaria
    FROM atleta AS a
    INNER JOIN categoria AS c 
        ON a.id_categoria = c.id_categoria
    WHERE a.id_categoria = p_id_categoria
    ORDER BY a.nome_atleta;
END //

-- =====================================================================
-- 2. PROCEDURE 2 — Operação de Domínio / Atualização Cadastral
-- =====================================================================
CREATE PROCEDURE sp_atualizar_escola_atleta(
    IN p_id_atleta INT,
    IN p_novo_id_escola INT
)
BEGIN
    UPDATE atleta
    SET id_escola = p_novo_id_escola
    WHERE id_atleta = p_id_atleta;
END //

-- =====================================================================
-- 3. PROCEDURE COM OUT — Contagem total de atletas
-- =====================================================================
CREATE PROCEDURE sp_contar_total_atletas(
    OUT p_total_atletas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_atletas
    FROM atleta;
END //

-- =====================================================================
-- 4. PROCEDURE COM IF / ELSE — Classificação etária e competitiva
-- =====================================================================
CREATE PROCEDURE sp_verificar_classificacao_etaria(
    IN p_id_atleta INT,
    OUT p_classificacao VARCHAR(50)
)
BEGIN
    DECLARE v_idade INT;
    
    -- Obtém a idade do atleta utilizando a função escalar fn_calcular_idade
    SELECT fn_calcular_idade(data_nascimento) INTO v_idade
    FROM atleta
    WHERE id_atleta = p_id_atleta;
    
    -- Estrutura condicional para definir o perfil competitivo
    IF v_idade < 18 THEN
        SET p_classificacao = 'Atleta de Base (Formação)';
    ELSE
        SET p_classificacao = 'Atleta Principal / Adulto';
    END IF;
END //

-- =====================================================================
-- 5. FUNCTION — Cálculo dinâmico de idade (DETERMINISTIC)
-- =====================================================================
CREATE FUNCTION fn_calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_idade INT;
    SET v_idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
    RETURN v_idade;
END //

DELIMITER ;

-- =====================================================================
-- 6. TESTES COM CALL (Procedures)
-- =====================================================================
-- Testes da Procedure 1 (Listar por Categoria)
CALL sp_listar_atletas_por_categoria(1);
CALL sp_listar_atletas_por_categoria(3);

-- Testes da Procedure 2 (Atualizar Escola do Atleta)
CALL sp_atualizar_escola_atleta(1, 2);
CALL sp_atualizar_escola_atleta(4, 1);

-- Testes da Procedure com OUT (Contagem de Atletas)
CALL sp_contar_total_atletas(@total_cadastrados);
SELECT @total_cadastrados AS total_geral_atletas;

-- Testes da Procedure com IF / ELSE (Classificação Etária)
CALL sp_verificar_classificacao_etaria(1, @status_atleta_1);
SELECT @status_atleta_1 AS classificacao_atleta_1;

CALL sp_verificar_classificacao_etaria(5, @status_atleta_2);
SELECT @status_atleta_2 AS classificacao_atleta_2;

-- =====================================================================
-- 7. TESTES COM SELECT (Functions)
-- =====================================================================
-- Teste 1 da Function (Cálculo de idade para data específica)
SELECT fn_calcular_idade('2010-05-14') AS idade_teste_1;

-- Teste 2 da Function (Cálculo de idade para outra data específica)
SELECT fn_calcular_idade('2008-09-22') AS idade_teste_2;

-- Teste integrando a Function diretamente em uma consulta aos atletas cadastrados
SELECT 
    nome_atleta,
    data_nascimento,
    fn_calcular_idade(data_nascimento) AS idade_atual_atleta
FROM atleta;

