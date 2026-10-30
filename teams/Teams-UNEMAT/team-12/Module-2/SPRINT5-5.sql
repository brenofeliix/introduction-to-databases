-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

-- ============================================================
-- LIMPEZA PARA PERMITIR EXECUTAR O SCRIPT MAIS DE UMA VEZ
-- (a ordem importa: o trigger sai antes da tabela de histórico)
-- ============================================================

DROP TRIGGER IF EXISTS trg_agendamento_historico_status;
DROP TABLE IF EXISTS historico_agendamento;
DROP VIEW IF EXISTS vw_agendamentos_detalhados;
DROP VIEW IF EXISTS vw_resumo_imoveis_corretor;
DROP VIEW IF EXISTS vw_agendamentos_pendentes;
DROP PROCEDURE IF EXISTS sp_listar_imoveis_por_cidade;
DROP PROCEDURE IF EXISTS sp_atualizar_status_agendamento;
DROP PROCEDURE IF EXISTS sp_contar_agendamentos_por_status;
DROP FUNCTION IF EXISTS fn_comissao_corretor;


-- ============================================================
-- JOINS
-- ============================================================

-- Consulta relacional final: cliente, imóvel e corretor de cada visita
SELECT
    cl.nome AS cliente,
    i.titulo AS imovel,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;

-- Corretores com ou sem imóvel
SELECT
    c.nome AS corretor,
    i.titulo AS imovel
FROM imovel AS i
RIGHT JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;


-- ============================================================
-- SUBCONSULTAS
-- ============================================================

-- Subconsulta final: imóveis que nunca receberam visita
SELECT titulo
FROM imovel AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);

-- Subconsulta correlacionada: imóveis acima da média do próprio corretor
SELECT i.titulo, i.valor, i.id_corretor
FROM imovel AS i
WHERE i.valor > (
    SELECT AVG(i2.valor)
    FROM imovel AS i2
    WHERE i2.id_corretor = i.id_corretor
);


-- ============================================================
-- VIEWS
-- ============================================================

CREATE VIEW vw_agendamentos_detalhados AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    i.titulo AS imovel,
    i.cidade,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;

CREATE VIEW vw_resumo_imoveis_corretor AS
SELECT
    c.id_corretor,
    c.nome AS corretor,
    COUNT(i.id_imovel) AS total_imoveis,
    SUM(i.valor) AS valor_total,
    AVG(i.valor) AS valor_medio
FROM corretor AS c
LEFT JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.id_corretor, c.nome;

CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    cl.email AS email_cliente,
    i.titulo AS imovel,
    i.valor AS valor_imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';

SELECT * FROM vw_agendamentos_detalhados;
SELECT * FROM vw_resumo_imoveis_corretor;
SELECT * FROM vw_agendamentos_pendentes;


-- ============================================================
-- PROCEDURES E FUNCTIONS
-- ============================================================

DELIMITER //

CREATE PROCEDURE sp_listar_imoveis_por_cidade(
    IN p_cidade VARCHAR(100)
)
BEGIN
    SELECT
        id_imovel,
        titulo,
        valor,
        quantidade_comodos
    FROM imovel
    WHERE cidade = p_cidade
    ORDER BY valor ASC;
END //

CREATE PROCEDURE sp_atualizar_status_agendamento(
    IN p_id_agendamento INT,
    IN p_novo_status VARCHAR(50)
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM agendamento
    WHERE id_agendamento = p_id_agendamento;

    IF v_existe = 0 THEN
        SELECT 'Agendamento não encontrado' AS mensagem;
    ELSEIF p_novo_status NOT IN ('Pendente', 'Confirmado', 'Cancelado') THEN
        SELECT 'Status inválido' AS mensagem;
    ELSE
        UPDATE agendamento
        SET status = p_novo_status
        WHERE id_agendamento = p_id_agendamento;

        SELECT 'Status atualizado com sucesso' AS mensagem;
    END IF;
END //

CREATE PROCEDURE sp_contar_agendamentos_por_status(
    IN p_status VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM agendamento
    WHERE status = p_status;
END //

CREATE FUNCTION fn_comissao_corretor(
    p_valor DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_valor * 0.05, 2);
END //

DELIMITER ;

CALL sp_listar_imoveis_por_cidade('Rondonópolis');

CALL sp_contar_agendamentos_por_status('Pendente', @total);
SELECT @total;

SELECT titulo, valor, fn_comissao_corretor(valor) AS comissao
FROM imovel;


-- ============================================================
-- TRIGGER
-- Regra: todo UPDATE que muda o status de um agendamento
-- gera uma linha na tabela de histórico.
-- ============================================================

CREATE TABLE historico_agendamento (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_agendamento INT NOT NULL,
    status_anterior VARCHAR(50) NOT NULL,
    status_novo VARCHAR(50) NOT NULL,
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_agendamento_historico_status
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_agendamento
            (id_agendamento, status_anterior, status_novo)
        VALUES
            (OLD.id_agendamento, OLD.status, NEW.status);
    END IF;
END //

DELIMITER ;

-- Teste do trigger: estado antes
SELECT * FROM historico_agendamento;
SELECT id_agendamento, status FROM agendamento WHERE id_agendamento = 2;

-- Operação: o status muda e o trigger registra
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 2;

-- Estado depois
SELECT * FROM historico_agendamento;

-- UPDATE sem mudança de status: o IF impede o registro
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 2;
SELECT COUNT(*) AS linhas_no_historico FROM historico_agendamento;

-- Reversão para manter os dados originais do banco
UPDATE agendamento SET status = 'Pendente' WHERE id_agendamento = 2;
SELECT * FROM historico_agendamento;


-- ============================================================
-- TRANSAÇÃO COM COMMIT
-- Confirmar as duas visitas da Chácara (agendamentos 2 e 3)
-- como uma única unidade de trabalho
-- ============================================================

SELECT COUNT(*) AS pendentes_antes FROM vw_agendamentos_pendentes;

START TRANSACTION;

CALL sp_atualizar_status_agendamento(2, 'Confirmado');
CALL sp_atualizar_status_agendamento(3, 'Confirmado');

COMMIT;

SELECT COUNT(*) AS pendentes_depois FROM vw_agendamentos_pendentes;

-- Reversão para manter os dados originais do banco
UPDATE agendamento SET status = 'Pendente' WHERE id_agendamento IN (2, 3);


-- ============================================================
-- TRANSAÇÃO COM ROLLBACK
-- Exclusão e alteração desfeitas antes de serem gravadas
-- ============================================================

SELECT COUNT(*) AS agendamentos_antes FROM agendamento;
SELECT COUNT(*) AS historico_antes FROM historico_agendamento;

START TRANSACTION;

DELETE FROM agendamento WHERE id_cliente = 1;
UPDATE agendamento SET status = 'Cancelado' WHERE id_agendamento = 4;

SELECT COUNT(*) AS agendamentos_durante FROM agendamento;
SELECT COUNT(*) AS historico_durante FROM historico_agendamento;

ROLLBACK;

SELECT COUNT(*) AS agendamentos_depois FROM agendamento;
SELECT COUNT(*) AS historico_depois FROM historico_agendamento;


-- ============================================================
-- VALIDAÇÃO FINAL
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT routine_type, routine_name
FROM information_schema.routines
WHERE routine_schema = 'real_estate_database'
ORDER BY routine_type, routine_name;

SELECT trigger_name, event_manipulation, event_object_table, action_timing
FROM information_schema.triggers
WHERE trigger_schema = 'real_estate_database';

SELECT id_agendamento, status FROM agendamento ORDER BY id_agendamento;
SELECT * FROM historico_agendamento;
