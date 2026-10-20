-- Aluno: Iuri Bravo Carvalho
-- Banco:gerenciamento_salao_beleza

USE gerenciamento_salao_beleza;

INSERT INTO CLIENTES (NOME, CPF, TELEFONE) 
VALUES 
    ('Lara da Silva', '13221654881', '66992445588'),
    ('Nina Novais', '55522244477', '62982554488'),
    ('Maia Prado', '85274196388', '65999885545'),
    ('Sara Silveira', '14523698745', '64999885522'),
    ('Noah Meireles', '11122233345', '6199885522');

INSERT INTO SERVICOS (NOME_SERVICO, PRECO_SERVICOS) 
VALUES 
    ('Corte Feminino', 80.00),
    ('Manicure', 35.00),
    ('Escova Progressiva', 200.00),
    ('Pedicure', 40.00),
    ('Design de Sobrancelhas', 50.00);

INSERT INTO COLABORADORES (NOME_COLABORADOR, TELEFONE, ENDEREÇO) 
VALUES 
    ('Elizabeth da Silva', '66992445588', 'Av ruibos'),
    ('Michonne Novais', '62982554488', 'Rua clementina'),
    ('Sofia Prado', '65999885545', 'Av da silva'),
    ('Carol Silveira', '64999885522', 'Av das flores'),
    ('Daryl Meireles', '6199885522', 'Rua do carmo,1155'),
    ('Rick Grimes', '6199885522', 'Av Carvalho');

INSERT INTO PRODUTOS (NOME_PRODUTO, PRECO_COMPRA, PRECO_VENDA, DATA_COMPRA, DATA_VENDA)
 VALUES 
    ('Shampoo Kerastase', 380.00, 450.00, '2026-10-01 10:00:00', '2026-10-02 14:30:00'),
    ('Máscara Keune', 195.00, 280.00, '2026-10-01 10:00:00', '2026-10-03 11:15:00'),
    ('Mascara de Reconstrucao Kerastase', 450.00, 600.00, '2026-10-05 09:00:00', '2026-10-06 16:00:00'),
    ('Joias', 80.00, 100.00, '2026-10-10 08:00:00', '2026-10-11 12:00:00'),
    ('Oleo Reparador', 120.00, 200.00, '2026-10-10 08:00:00', '2026-10-12 15:00:00');

INSERT INTO AGENDAMENTO (DATA_AGENDAMENTO, CPF, NOME_SERVICO) 
VALUES 
    ('2026-10-15 14:00:00', '13221654881', 'Corte Feminino'),
    ('2026-10-15 15:30:00', '55522244477', 'Manicure'),
    ('2026-10-16 10:00:00', '85274196388', 'Escova Progressiva'),
    ('2026-10-16 11:00:00', '14523698745', 'Design de Sobrancelhas'),
    ('2026-10-17 09:00:00', '11122233345', 'Pedicure');
    
    
SELECT * FROM CLIENTES;
SELECT * FROM AGENDAMENTO;

    UPDATE CLIENTES 
SET TELEFONE = '66999991111' 
WHERE CPF = '13221654881';

UPDATE SERVICOS 
SET PRECO_SERVICOS = 90.00 
WHERE NOME_SERVICO = 'Corte Feminino';

UPDATE COLABORADORES 
SET ENDEREÇO = 'Rua dos Girassóis, 500' 
WHERE ID_COLABORADOR = 1;

UPDATE PRODUTOS 
SET PRECO_VENDA = 38.00 
WHERE ID_PRODUTO = 1;

DELETE FROM CLIENTES
WHERE ID_CLIENTES = 5;

DELETE FROM COLABORADORES
WHERE ID_COLABORADOR = 1;

SELECT * FROM CLIENTES;
SELECT * FROM SERVICOS;
SELECT * FROM COLABORADORES;
SELECT * FROM PRODUTOS;
SELECT * FROM AGENDAMENTO;