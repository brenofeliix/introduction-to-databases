-- ============================================================
-- MODULE 2 — SPRINT 4/5
-- STORED PROCEDURES E FUNCTIONS
-- DISCIPLINA: Laboratório de Banco de Dados
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- INSTITUIÇÃO: UNEMAT
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================
-- Pré-requisito: banco do Module-1 + carga complementar da
-- Sprint 1 (Module-2/SPRINT1-5.sql).
-- Executar o arquivo inteiro: a seção 9 restaura os dados
-- alterados pelos testes da seção 8.
-- ============================================================

USE db_salao_beleza;

-- Remove as rotinas caso já existam, para o script poder ser
-- executado mais de uma vez
DROP PROCEDURE IF EXISTS sp_agendamentos_por_cliente;
DROP PROCEDURE IF EXISTS sp_concluir_agendamento;
DROP PROCEDURE IF EXISTS sp_contar_por_status;
DROP FUNCTION  IF EXISTS fn_total_gasto_cliente;


-- O DELIMITER muda o fim de comando de ";" para "//", para o
-- MySQL não encerrar a rotina no primeiro ";" do BEGIN...END
DELIMITER //

-- ============================================================
-- 1. PROCEDURE 1 — PARÂMETRO IN
-- Objetivo: listar o histórico de agendamentos de um cliente
-- Entrada: p_id_cliente (código do cliente)
-- ============================================================
CREATE PROCEDURE sp_agendamentos_por_cliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT
        a.id_agendamento,
        a.data_hora,
        s.nome_servico AS servico,
        p.nome         AS profissional,
        s.preco,
        a.status
    FROM agendamento AS a
    INNER JOIN servico      AS s ON a.id_servico      = s.id_servico
    INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
    WHERE a.id_cliente = p_id_cliente
    ORDER BY a.data_hora;
END //


-- ============================================================
-- 2. PROCEDURE 2 — OPERAÇÃO DO DOMÍNIO COM IF/ELSE
-- Objetivo: concluir um atendimento e registrar o pagamento
-- Regra de negócio: só pode ser concluído um agendamento com
-- status 'Agendado'; cancelados ou já concluídos são bloqueados
-- Entradas: p_id_agendamento e p_forma_pagamento
-- ============================================================
CREATE PROCEDURE sp_concluir_agendamento(
    IN p_id_agendamento  INT,
    IN p_forma_pagamento VARCHAR(20)
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status INTO v_status
    FROM agendamento
    WHERE id_agendamento = p_id_agendamento;

    IF v_status IS NULL THEN
        SELECT CONCAT('Agendamento ', p_id_agendamento,
                      ' não encontrado.') AS mensagem;
    ELSEIF v_status = 'Agendado' THEN
        UPDATE agendamento
        SET status = 'Concluído',
            forma_pagamento = p_forma_pagamento
        WHERE id_agendamento = p_id_agendamento;

        SELECT CONCAT('Agendamento ', p_id_agendamento,
                      ' concluído. Pagamento: ', p_forma_pagamento) AS mensagem;
    ELSE
        SELECT CONCAT('Não é possível concluir: o agendamento ',
                      p_id_agendamento, ' está com status ', v_status, '.') AS mensagem;
    END IF;
END //


-- ============================================================
-- 3. PROCEDURE COM OUT
-- Objetivo: contar quantos agendamentos existem em um status
-- Entrada: p_status | Saída: p_total
-- ============================================================
CREATE PROCEDURE sp_contar_por_status(
    IN  p_status VARCHAR(20),
    OUT p_total  INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM agendamento
    WHERE status = p_status;
END //


-- ============================================================
-- 4. FUNCTION
-- Objetivo: calcular quanto um cliente já pagou no salão
-- (soma dos serviços dos atendimentos concluídos)
-- Entrada: p_id_cliente | Retorno: DECIMAL(10,2)
-- READS SQL DATA: informa ao MySQL que a function só lê dados
-- ============================================================
CREATE FUNCTION fn_total_gasto_cliente(
    p_id_cliente INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(s.preco), 0) INTO v_total
    FROM agendamento AS a
    INNER JOIN servico AS s ON a.id_servico = s.id_servico
    WHERE a.id_cliente = p_id_cliente
      AND a.status = 'Concluído';

    RETURN v_total;
END //

DELIMITER ;


-- ============================================================
-- 5. TESTES — PROCEDURE 1
-- ============================================================
CALL sp_agendamentos_por_cliente(1);   -- Mariana Souza
CALL sp_agendamentos_por_cliente(3);   -- Camila Oliveira


-- ============================================================
-- 6. TESTES — PROCEDURE COM OUT
-- ============================================================
CALL sp_contar_por_status('Agendado', @total);
SELECT @total AS total_agendados;

CALL sp_contar_por_status('Concluído', @total);
SELECT @total AS total_concluidos;


-- ============================================================
-- 7. TESTES — FUNCTION
-- ============================================================
SELECT fn_total_gasto_cliente(1) AS total_mariana;
SELECT fn_total_gasto_cliente(7) AS total_patricia;

-- Uso da function dentro de uma consulta: ranking de clientes
SELECT
    nome,
    fn_total_gasto_cliente(id_cliente) AS total_gasto
FROM cliente
ORDER BY total_gasto DESC, nome;


-- ============================================================
-- 8. TESTES — PROCEDURE 2 (IF/ELSE)
-- ============================================================

-- 8.1 Antes: quanto a Beatriz (id 2) já pagou
SELECT fn_total_gasto_cliente(2) AS beatriz_antes;

-- 8.2 Caso permitido: agendamento 2 está 'Agendado'
CALL sp_concluir_agendamento(2, 'Cartão');

-- 8.3 Depois: a function já enxerga o novo atendimento concluído
SELECT fn_total_gasto_cliente(2) AS beatriz_depois;

-- 8.4 Caso bloqueado: agendamento 10 está 'Cancelado'
CALL sp_concluir_agendamento(10, 'Pix');

-- 8.5 Caso inexistente: agendamento 99 não existe
CALL sp_concluir_agendamento(99, 'Pix');


-- ============================================================
-- 9. RESTAURA OS DADOS PARA A PRÓXIMA SPRINT
-- ============================================================
UPDATE agendamento
SET status = 'Agendado',
    forma_pagamento = NULL
WHERE id_agendamento = 2;

CALL sp_contar_por_status('Agendado', @total);
SELECT @total AS total_agendados_final;
