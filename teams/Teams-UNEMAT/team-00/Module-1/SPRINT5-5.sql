-- ============================================================
-- DISCIPLINA: Laboratório de Banco de Dados
-- SPRINT 5/5 — Validação Final, Integração e Entrega do Banco de Dados
-- ALUNA: Célia Hiromi Watanabe (Team 03)
-- INSTITUIÇÃO: UNEMAT
-- TEMA: Sistema de Gestão de Atendimentos para Salão de Beleza
-- BANCO DE DADOS: db_salao_beleza
-- ============================================================

-- ============================================================
-- 1. CRIAÇÃO E SELEÇÃO DO BANCO DE DADOS
-- ============================================================

CREATE DATABASE IF NOT EXISTS db_salao_beleza;
USE db_salao_beleza;


-- ============================================================
-- 2. CRIAÇÃO DAS TABELAS INDEPENDENTES (TABELAS PAI)
-- ============================================================

-- Tabela: cliente
-- Armazena dados cadastrais e de contato dos clientes do salão
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100)
);

-- Tabela: profissional
-- Registra os colaboradores do salão e suas especialidades de atendimento
CREATE TABLE profissional (
    id_profissional INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(50) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

-- Tabela: servico
-- Catálogo de serviços disponíveis com tempo de execução e preço em reais
CREATE TABLE servico (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    nome_servico VARCHAR(100) NOT NULL,
    duracao_minutos INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);


-- ============================================================
-- 3. CRIAÇÃO DA TABELA DEPENDENTE (COM CHAVES ESTRANGEIRAS)
-- ============================================================

-- Tabela: agendamento
-- Gerencia os atendimentos marcados conectando cliente, profissional e serviço
CREATE TABLE agendamento (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_profissional INT NOT NULL,
    id_servico INT NOT NULL,
    data_hora DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Agendado',
    forma_pagamento VARCHAR(20),

    CONSTRAINT fk_agendamento_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),

    CONSTRAINT fk_agendamento_profissional
        FOREIGN KEY (id_profissional) REFERENCES profissional(id_profissional),

    CONSTRAINT fk_agendamento_servico
        FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);


-- ============================================================
-- 4. EVOLUÇÃO ESTRUTURAL (ALTER TABLE)
-- ============================================================

-- Adiciona a coluna 'observacoes' para registrar preferências e detalhes dos clientes
ALTER TABLE agendamento
ADD COLUMN observacoes VARCHAR(255);


-- ============================================================
-- 5. EXERCÍCIO CONTROLADO DE EXCLUSÃO (DROP TABLE)
-- ============================================================

-- Demonstração segura da instrução DDL DROP TABLE em tabela temporária
CREATE TABLE tabela_teste_exclusao (
    id_teste INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(50)
);

DROP TABLE tabela_teste_exclusao;


-- ============================================================
-- 6. CARGA DE DADOS (DML — INSERT INTO)
-- ============================================================

-- 6.1 Inserções na tabela cliente
INSERT INTO cliente (nome, cpf, telefone, email)
VALUES
    ('Mariana Souza', '111.222.333-44', '(65) 99111-2233', 'mariana.souza@email.com'),
    ('Beatriz Santos', '222.333.444-55', '(65) 99222-3344', 'beatriz.santos@email.com'),
    ('Camila Oliveira', '333.444.555-66', '(65) 99333-4455', 'camila.oliveira@email.com'),
    ('Juliana Costa', '444.555.666-77', '(65) 99444-5566', 'juliana.costa@email.com'),
    ('Fernanda Lima', '555.666.777-88', '(65) 99555-6677', 'fernanda.lima@email.com'),
    ('Lucas Ribeiro (Teste)', '666.777.888-99', '(65) 99666-7788', 'lucas.teste@email.com');

-- 6.2 Inserções na tabela profissional
INSERT INTO profissional (nome, especialidade, telefone)
VALUES
    ('Ana Paula Nogueira', 'Cabeleireira', '(65) 98111-1001'),
    ('Carla Mendes', 'Manicure e Pedicure', '(65) 98222-1002'),
    ('Daniela Rocha', 'Maquiadora', '(65) 98333-1003'),
    ('Eduardo Martins', 'Barbeiro', '(65) 98444-1004'),
    ('Fabiana Silveira', 'Esteticista', '(65) 98555-1005');

-- 6.3 Inserções na tabela servico
INSERT INTO servico (nome_servico, duracao_minutos, preco)
VALUES
    ('Corte Feminino', 45, 80.00),
    ('Corte Masculino', 30, 50.00),
    ('Manicure e Pedicure', 60, 65.00),
    ('Escova e Hidratação', 50, 90.00),
    ('Maquiagem Social', 60, 150.00),
    ('Limpeza de Pele', 75, 120.00);

-- 6.4 Inserções na tabela agendamento
INSERT INTO agendamento (id_cliente, id_profissional, id_servico, data_hora, status, forma_pagamento, observacoes)
VALUES
    (1, 1, 1, '2026-09-15 09:00:00', 'Agendado', NULL, 'Cliente prefere corte na tesoura'),
    (2, 2, 3, '2026-09-15 10:30:00', 'Agendado', NULL, 'Trazer esmalte próprio'),
    (3, 3, 5, '2026-09-15 14:00:00', 'Agendado', NULL, 'Evento à noite, maquiagem marcante'),
    (4, 4, 2, '2026-09-16 11:00:00', 'Agendado', NULL, 'Acabamento com navalha'),
    (5, 5, 6, '2026-09-16 15:30:00', 'Agendado', NULL, 'Pele sensível'),
    (1, 2, 3, '2026-09-17 16:00:00', 'Cancelado', NULL, 'Cliente cancelou com antecedência por imprevisto');


-- ============================================================
-- 7. MANIPULAÇÃO DE DADOS (DML — UPDATE)
-- ============================================================

-- UPDATE 1: Atualização de telefone e e-mail da cliente Beatriz Santos
UPDATE cliente
SET telefone = '(65) 99999-3344',
    email = 'beatriz.nova@email.com'
WHERE id_cliente = 2;

-- UPDATE 2: Reajuste do preço da 'Escova e Hidratação' de R$ 90.00 para R$ 95.00
UPDATE servico
SET preco = 95.00
WHERE id_servico = 4;

-- UPDATE 3: Conclusão do agendamento 1 com registro de forma de pagamento e observação
UPDATE agendamento
SET status = 'Concluído',
    forma_pagamento = 'Pix',
    observacoes = 'Atendimento concluído com sucesso, cliente satisfeita'
WHERE id_agendamento = 1;


-- ============================================================
-- 8. EXCLUSÕES CONTROLADAS (DML — DELETE)
-- ============================================================

-- DELETE 1: Exclusão segura do agendamento cancelado (id_agendamento = 6)
DELETE FROM agendamento
WHERE id_agendamento = 6;

-- DELETE 2: Exclusão do cliente de testes sem agendamentos (id_cliente = 6)
-- Comprova a integridade referencial sem violação de chave estrangeira
DELETE FROM cliente
WHERE id_cliente = 6;


-- ============================================================
-- 9. CONSULTAS BÁSICAS E PROJEÇÃO ESPECÍFICA
-- ============================================================

-- Consulta 01: Visualização cadastral completa
SELECT *
FROM cliente;

-- Consulta 02: Catálogo simplificado com colunas selecionadas
SELECT nome_servico, duracao_minutos, preco
FROM servico;


-- ============================================================
-- 10. FILTROS COM WHERE (SIMPLES E COMPOSTO)
-- ============================================================

-- Consulta 03: Serviços com valor superior a R$ 70,00
SELECT nome_servico, preco
FROM servico
WHERE preco > 70.00;

-- Consulta 04: Agendamentos pendentes para data específica com operador AND
SELECT id_agendamento, id_cliente, id_profissional, id_servico, data_hora, status
FROM agendamento
WHERE status = 'Agendado'
  AND data_hora >= '2026-09-15 00:00:00'
  AND data_hora <= '2026-09-15 23:59:59';


-- ============================================================
-- 11. ORDENAÇÃO COM ORDER BY
-- ============================================================

-- Consulta 05: Clientes em ordem alfabética crescente (ASC)
SELECT nome, telefone, email
FROM cliente
ORDER BY nome ASC;

-- Consulta 06: Catálogo de serviços ordenado por preço decrescente (DESC)
SELECT nome_servico, duracao_minutos, preco
FROM servico
ORDER BY preco DESC;


-- ============================================================
-- 12. FUNÇÕES DE AGREGAÇÃO (COUNT, SUM, AVG, MIN, MAX)
-- ============================================================

-- Consulta 07: Contagem total de clientes ativos e de agendamentos
SELECT 
    (SELECT COUNT(*) FROM cliente) AS total_clientes,
    (SELECT COUNT(*) FROM agendamento) AS total_agendamentos;

-- Consulta 08: Soma total do catálogo de serviços
SELECT SUM(preco) AS faturamento_total_catalogo
FROM servico;

-- Consulta 09: Preço médio e duração média dos serviços
SELECT 
    ROUND(AVG(preco), 2) AS preco_medio_servicos,
    ROUND(AVG(duracao_minutos), 1) AS duracao_media_minutos
FROM servico;

-- Consulta 10: Menor e maior preço praticados no catálogo
SELECT 
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM servico;


-- ============================================================
-- 13. AGRUPAMENTO COM GROUP BY E FILTRO COM HAVING
-- ============================================================

-- Consulta 11: Total de agendamentos distribuídos por status
SELECT 
    status,
    COUNT(*) AS quantidade_agendamentos
FROM agendamento
GROUP BY status;

-- Consulta 12: Produtividade e total de atendimentos por profissional
SELECT 
    id_profissional,
    COUNT(*) AS total_atendimentos
FROM agendamento
GROUP BY id_profissional
ORDER BY total_atendimentos DESC;

-- Consulta 13: Filtro em grupos agregados com HAVING
SELECT 
    status,
    COUNT(*) AS quantidade
FROM agendamento
GROUP BY status
HAVING COUNT(*) > 1;


-- ============================================================
-- 14. EXPRESSÕES E CÁLCULOS EM SQL
-- ============================================================

-- Consulta 14: Simulação de política promocional com 15% de desconto fidelidade
SELECT 
    nome_servico,
    preco AS preco_original,
    ROUND(preco * 0.15, 2) AS valor_desconto_15,
    ROUND(preco * 0.85, 2) AS preco_promocional_com_desconto
FROM servico
ORDER BY preco_original DESC;


-- ============================================================
-- 15. CONSULTA RELACIONAL INTEGRADA (INNER JOIN)
-- ============================================================

-- Consulta 15: Relatório executivo integrado conectando as 4 tabelas
SELECT 
    a.id_agendamento,
    c.nome AS nome_cliente,
    p.nome AS nome_profissional,
    p.especialidade,
    s.nome_servico,
    s.preco,
    a.data_hora,
    a.status,
    a.forma_pagamento
FROM agendamento a
INNER JOIN cliente c ON a.id_cliente = c.id_cliente
INNER JOIN profissional p ON a.id_profissional = p.id_profissional
INNER JOIN servico s ON a.id_servico = s.id_servico
ORDER BY a.data_hora ASC;


-- ============================================================
-- 16. COMANDOS DE VALIDAÇÃO E AUDITORIA ESTRUTURAL FINAL
-- ============================================================

-- Verificação da existência de todas as tabelas no schema
SHOW TABLES;

-- Verificação da estrutura detalhada de cada tabela
DESCRIBE cliente;
DESCRIBE profissional;
DESCRIBE servico;
DESCRIBE agendamento;

-- Verificação da geração das chaves estrangeiras e engine InnoDB
SHOW CREATE TABLE agendamento;
