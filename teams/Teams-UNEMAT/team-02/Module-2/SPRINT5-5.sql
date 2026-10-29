-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluna: Geovanna Gaspar Ribeiro
-- Banco: gerenciamento_incidentes

USE gerenciamento_incidentes;

-- ============================================================
-- JOINS (revisão da Sprint 1)
-- Pergunta: quais incidentes de severidade crítica estão sob
-- responsabilidade de qual analista?
-- ============================================================
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.severidade
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.severidade = 'CRITICA';


-- ============================================================
-- SUBCONSULTAS (revisão da Sprint 2)
-- Pergunta: para cada analista, qual foi o incidente mais
-- recente atribuído a ele?
-- ============================================================
SELECT a.nome AS analista,
       i.titulo AS incidente_mais_recente,
       i.data_identificacao
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.data_identificacao = (
    SELECT MAX(i2.data_identificacao)
    FROM incidentes i2
    WHERE i2.id_analista = a.id_analista
);


-- ============================================================
-- VIEWS (revisão da Sprint 3)
-- ============================================================
SELECT * FROM vw_incidentes_detalhados;
SELECT * FROM vw_incidentes_por_analista;
SELECT * FROM vw_incidentes_em_aberto;


-- ============================================================
-- PROCEDURES E FUNCTIONS (revisão da Sprint 4)
-- ============================================================
CALL listar_incidentes_por_status('ABERTO');

CALL contar_incidentes_por_severidade('ALTA', @total_alta);
SELECT @total_alta;

SELECT dias_em_aberto(3);


-- ============================================================
-- TRIGGER
-- Tabela de auditoria de mudanças de status
-- ============================================================
CREATE TABLE IF NOT EXISTS historico_status_incidentes (
    id_historico     INT AUTO_INCREMENT PRIMARY KEY,
    id_incidente     INT NOT NULL,
    status_anterior  VARCHAR(20),
    status_novo      VARCHAR(20),
    data_alteracao   DATETIME,
    FOREIGN KEY (id_incidente) REFERENCES incidentes(id_incidente)
);

DELIMITER //

CREATE TRIGGER trg_historico_status_incidentes
AFTER UPDATE ON incidentes
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_status_incidentes (
            id_incidente, status_anterior, status_novo, data_alteracao
        )
        VALUES (
            OLD.id_incidente, OLD.status, NEW.status, NOW()
        );
    END IF;
END //

DELIMITER ;


-- ============================================================
-- TESTE DO TRIGGER
-- ============================================================
SELECT * FROM historico_status_incidentes;

UPDATE incidentes
SET status = 'RESOLVIDO'
WHERE id_incidente = 3;

SELECT * FROM historico_status_incidentes;


-- ============================================================
-- TRANSAÇÃO COM COMMIT
-- Registra um novo incidente e sua ação de resposta juntos
-- ============================================================
START TRANSACTION;

INSERT INTO incidentes (
    titulo, descricao, severidade, status,
    id_analista, id_dispositivo, id_ameaca, id_alerta
)
VALUES (
    'Escaneamento de portas não autorizado',
    'Ferramenta de scan identificada tentando mapear portas abertas no firewall.',
    'MEDIA', 'ABERTO', 4, 3, 4, NULL
);

INSERT INTO acoes_resposta (descricao, id_incidente)
VALUES ('Bloqueio do IP de origem do escaneamento no firewall.', LAST_INSERT_ID());

COMMIT;


-- ============================================================
-- TRANSAÇÃO COM ROLLBACK
-- Simula uma exclusão acidental de um alerta e desfaz a operação
-- ============================================================
SELECT * FROM acoes_resposta WHERE id_alerta = 6;

START TRANSACTION;

DELETE FROM acoes_resposta
WHERE id_incidente = 6;

ROLLBACK;

SELECT * FROM acoes_resposta WHERE id_alerta = 6;


-- ============================================================
-- VALIDAÇÃO FINAL
-- ============================================================
SELECT COUNT(*) AS total_incidentes FROM incidentes;
SELECT COUNT(*) AS total_alertas FROM alertas;
SELECT COUNT(*) AS total_historico FROM historico_status_incidentes;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
