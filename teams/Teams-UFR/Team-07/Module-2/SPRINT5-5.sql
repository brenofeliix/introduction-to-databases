-- Criação prévia da tabela de auditoria para armazenar o histórico de alterações
CREATE TABLE IF NOT EXISTS auditoria_atleta (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_atleta INT,
    nome_antigo VARCHAR(150),
    nome_novo VARCHAR(150),
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100)
);

DELIMITER //

CREATE TRIGGER trg_auditar_atualizacao_atleta
AFTER UPDATE ON atleta
FOR EACH ROW
BEGIN
    -- Verifica se houve alteração no nome do atleta para registrar na auditoria
    IF OLD.nome_atleta <> NEW.nome_atleta THEN
        INSERT INTO auditoria_atleta (id_atleta, nome_antigo, nome_novo, usuario)
        VALUES (OLD.id_atleta, OLD.nome_atleta, NEW.nome_atleta, USER());
    END IF;
END //

DELIMITER ;

-- Consultando o cadastro do atleta e verificando a tabela de auditoria vazia antes da alteração
SELECT id_atleta, nome_atleta FROM atleta WHERE id_atleta = 1;
SELECT * FROM auditoria_atleta;

-- Realizando a atualização do nome do atleta para disparar o trigger AFTER UPDATE
UPDATE atleta 
SET nome_atleta = 'Giovana Santana Reia da Silva' 
WHERE id_atleta = 1;

-- Consultando novamente a tabela de atletas e a tabela de auditoria para verificar o registro gerado
SELECT id_atleta, nome_atleta FROM atleta WHERE id_atleta = 1;
SELECT * FROM auditoria_atleta;

-- Iniciando a transação controlada
START TRANSACTION;

-- Operação 1: Atualizar a instituição de ensino vinculada ao atleta ID 2
UPDATE atleta 
SET id_escola = 2 
WHERE id_atleta = 2;

-- Operação 2: Inserir o registro correspondente na tabela de auditoria operacional
INSERT INTO auditoria_atleta (id_atleta, nome_antigo, nome_novo, usuario)
VALUES (2, 'ALTERAÇÃO INSTITUCIONAL', 'VÍNCULO ATUALIZADO PARA ESCOLA ID 2', USER());

-- Salvando e efetivando permanentemente as alterações no banco de dados
COMMIT;

-- Consultando o estado original dos registros antes de iniciar a transação
SELECT id_atleta, nome_atleta, genero 
FROM atleta 
WHERE id_atleta <= 3;

-- Consultando novamente a tabela após a execução do ROLLBACK para confirmar a reversão
SELECT id_atleta, nome_atleta, genero 
FROM atleta 
WHERE id_atleta <= 3;

