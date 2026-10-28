-- ============================================================
-- MODULE 2 — SPRINT 5/5
-- TRIGGERS, TRANSAÇÕES E INTEGRAÇÃO FINAL
-- DISCIPLINA: Laboratório de Banco de Dados
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- INSTITUIÇÃO: UNEMAT
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================
-- Pré-requisitos: banco do Module-1 + carga complementar da
-- Sprint 1, views da Sprint 3 e rotinas da Sprint 4 já criadas.
-- ATENÇÃO: executar o arquivo UMA VEZ. A transação com COMMIT
-- (seção 6) grava um agendamento novo de forma definitiva.
-- ============================================================

USE db_salao_beleza;


-- ============================================================
-- 1. JOIN FINAL
-- Pergunta: Quanto cada serviço já faturou com atendimentos
-- concluídos, incluindo os serviços nunca concluídos?
-- O filtro de status fica no ON para o LEFT JOIN manter os
-- serviços sem atendimento concluído (com 0).
-- ============================================================
SELECT
    s.nome_servico,
    s.preco,
    COUNT(a.id_agendamento)           AS vezes_concluido,
    COUNT(a.id_agendamento) * s.preco AS faturamento
FROM servico AS s
LEFT JOIN agendamento AS a
    ON s.id_servico = a.id_servico
   AND a.status = 'Concluído'
GROUP BY s.id_servico, s.nome_servico, s.preco
ORDER BY faturamento DESC, s.nome_servico;


-- ============================================================
-- 2. SUBCONSULTA FINAL
-- Pergunta: Quais clientes têm agendamento pendente e nunca
-- tiveram um atendimento concluído? (clientes novos a fidelizar)
-- ============================================================
SELECT c.nome, c.telefone
FROM cliente AS c
WHERE c.id_cliente IN (
        SELECT id_cliente
        FROM agendamento
        WHERE status = 'Agendado'
      )
  AND NOT EXISTS (
        SELECT 1
        FROM agendamento AS a2
        WHERE a2.id_cliente = c.id_cliente
          AND a2.status = 'Concluído'
      )
ORDER BY c.nome;


-- ============================================================
-- 3. VIEWS (criadas na Sprint 3)
-- ============================================================
SELECT * FROM vw_agenda_completa ORDER BY data_hora;
SELECT * FROM vw_resumo_profissional ORDER BY faturamento_previsto DESC;


-- ============================================================
-- 4. PROCEDURES E FUNCTION (criadas na Sprint 4)
-- ============================================================
CALL sp_agendamentos_por_cliente(2);   -- Beatriz Santos

CALL sp_contar_por_status('Concluído', @total);
SELECT @total AS total_concluidos;

SELECT
    nome,
    fn_total_gasto_cliente(id_cliente) AS total_gasto
FROM cliente
ORDER BY total_gasto DESC, nome;


-- ============================================================
-- 5. TRIGGER — HISTÓRICO DE MUDANÇAS DE STATUS
-- Regra: toda mudança de status de um agendamento é registrada
-- automaticamente na tabela historico_status (auditoria).
-- CREATE TABLE e CREATE TRIGGER ficam fora das transações,
-- porque comandos DDL fazem COMMIT implícito.
-- ============================================================

-- Remove trigger e tabela caso já existam (histórico começa vazio)
DROP TRIGGER IF EXISTS trg_historico_status;
DROP TABLE   IF EXISTS historico_status;

CREATE TABLE historico_status (
    id_historico    INT PRIMARY KEY AUTO_INCREMENT,
    id_agendamento  INT NOT NULL,
    status_anterior VARCHAR(20) NOT NULL,
    status_novo     VARCHAR(20) NOT NULL,
    data_alteracao  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_historico_agendamento
        FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento)
);

DELIMITER //

CREATE TRIGGER trg_historico_status
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    -- OLD = valores antes do UPDATE | NEW = valores depois
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_status (id_agendamento, status_anterior, status_novo)
        VALUES (NEW.id_agendamento, OLD.status, NEW.status);
    END IF;
END //

DELIMITER ;


-- 5.1 Antes: histórico vazio
SELECT * FROM historico_status;

-- 5.2 A procedure da Sprint 4 faz o UPDATE e o trigger dispara
CALL sp_concluir_agendamento(9, 'Pix');
SELECT * FROM historico_status;   -- 1 linha: Agendado -> Concluído

-- 5.3 Muda só a forma de pagamento: o IF do trigger não registra
UPDATE agendamento
SET forma_pagamento = 'Cartão'
WHERE id_agendamento = 9;
SELECT * FROM historico_status;   -- continua 1 linha

-- 5.4 Restaura o agendamento 9: o trigger registra a volta
UPDATE agendamento
SET status = 'Agendado',
    forma_pagamento = NULL
WHERE id_agendamento = 9;
SELECT * FROM historico_status;   -- 2 linhas: Concluído -> Agendado


-- ============================================================
-- 6. TRANSAÇÃO COM COMMIT
-- Situação: atendimento de encaixe da Patrícia Almeida (id 7).
-- Registrar o agendamento e concluí-lo com pagamento formam
-- uma unidade: o atendimento só vale se as duas operações
-- forem gravadas.
-- ============================================================
SELECT fn_total_gasto_cliente(7) AS patricia_antes;

START TRANSACTION;

-- Ana Paula Nogueira (1) — Escova e Hidratação (4)
INSERT INTO agendamento (id_cliente, id_profissional, id_servico, data_hora, status)
VALUES (7, 1, 4, '2026-09-22 10:00:00', 'Agendado');

-- LAST_INSERT_ID() devolve o id gerado pelo INSERT acima
UPDATE agendamento
SET status = 'Concluído',
    forma_pagamento = 'Pix'
WHERE id_agendamento = LAST_INSERT_ID();

COMMIT;

-- Depois do COMMIT: o atendimento está gravado definitivamente
SELECT * FROM vw_agenda_completa WHERE cliente = 'Patrícia Almeida';
SELECT fn_total_gasto_cliente(7) AS patricia_depois;
SELECT * FROM historico_status;   -- 3 linhas (trigger registrou)


-- ============================================================
-- 7. TRANSAÇÃO COM ROLLBACK
-- Situação: a recepção cancela por engano os agendamentos
-- 3 e 9 e percebe o erro antes de confirmar.
-- ============================================================

-- 7.1 Antes: agendamentos pendentes
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;

START TRANSACTION;

UPDATE agendamento
SET status = 'Cancelado'
WHERE id_agendamento IN (3, 9);

-- 7.2 Dentro da transação: 2 pendentes a menos e 2 linhas
-- novas no histórico (gravadas pelo trigger)
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;
SELECT * FROM historico_status;

ROLLBACK;

-- 7.3 Depois do ROLLBACK: pendentes e histórico voltam ao
-- estado anterior (o que o trigger gravou também foi desfeito)
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;
SELECT * FROM historico_status;


-- ============================================================
-- 8. VALIDAÇÃO FINAL
-- ============================================================
SHOW TRIGGERS;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
SHOW PROCEDURE STATUS WHERE Db = 'db_salao_beleza';
SHOW FUNCTION STATUS WHERE Db = 'db_salao_beleza';

-- Histórico da Patrícia, agora com o atendimento de encaixe
CALL sp_agendamentos_por_cliente(7);

-- Agendamentos por status ao final do Module-2
SELECT status, COUNT(*) AS quantidade
FROM agendamento
GROUP BY status
ORDER BY status;
