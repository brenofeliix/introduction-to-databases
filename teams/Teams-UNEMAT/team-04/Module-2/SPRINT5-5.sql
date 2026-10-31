-- Implementação de trigger

DROP TRIGGER IF EXISTS trg_validar_expediente;
DELIMITER //
CREATE TRIGGER trg_validar_expediente
BEFORE INSERT ON EXPEDIENTE
FOR EACH ROW
BEGIN
    IF NEW.hora_saida <= NEW.hora_entrada THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A hora de saida deve ser posterior a hora de entrada';
    END IF;
END //
DELIMITER ;

-- Teste do Trigger, deve aparecer a mensagem dentro de "set Message..."

INSERT INTO EXPEDIENTE
    (data_batimento, hora_entrada, hora_saida, hora_extra, justificativas, id_func)
VALUES
    (CURDATE(), '10:00:00', '09:00:00', '0', 'Teste de trigger', 1);
    
-- Test com commit

SELECT id_cargo, nome_cargo, salario_base
FROM CARGO
WHERE id_cargo = 1;

START TRANSACTION;
UPDATE CARGO
SET salario_base = salario_base + 1.00
WHERE id_cargo = 1;
COMMIT;

SELECT id_cargo, nome_cargo, salario_base
FROM CARGO
WHERE id_cargo = 1;

-- Teste com Rollback

SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;

START TRANSACTION;

UPDATE ESTOQUE
SET quantidade = 200
WHERE id_filial = 1 AND id_produto = 1;

SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;

ROLLBACK;

SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;

-- Consulta final

SELECT f.nome_func, c.nome_cargo, s.nome_setor, fi.Localizacao
FROM FUNCIONARIO f
JOIN CARGO c ON c.id_cargo = f.id_cargo
JOIN SETOR s ON s.id_setor = f.id_setor
JOIN FILIAL fi ON fi.id_filial = f.id_filial;

-- Subconsulta final

SELECT f.nome_func, c.nome_cargo, c.salario_base
FROM FUNCIONARIO f
JOIN CARGO c ON c.id_cargo = f.id_cargo
WHERE c.salario_base > (
    SELECT AVG(salario_base) FROM CARGO
);

