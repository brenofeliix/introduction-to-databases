db_raaei — Gestão de Associação Atlética e Inclusiva de Atletismo (RAAEI)
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
DEFAULT
AUTO_INCREMENT

-- Atualização de observações médicas para um atleta específico
UPDATE atleta 
SET observacoes_medicas = 'Atestado liberado para competições de alta intensidade.' 
WHERE id_atleta = 3;

-- Atualização do turno de funcionamento de uma escola parceira
UPDATE escola 
SET turno = 'Integral' 
WHERE nome_escola = 'Escola Estadual Dom Aquino';

-- Remoção controlada de um registro de colaborador inativo que não possui dependências críticas
DELETE FROM colaborador 
WHERE id_colaborador = 8;

-- Remoção de um registro de teste na tabela de atletas antes da consolidação final das consultas
DELETE FROM atleta 
WHERE id_atleta = 15;

SELECT
WHERE
ORDER BY
COUNT
SUM
AVG
MIN
MAX
GROUP BY
HAVING

SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria;

SELECT a.nome_atleta, e.nome_escola, a.observacoes_medicas
FROM atleta a
JOIN escola e ON a.id_escola = e.id_escola
WHERE a.observacoes_medicas IS NOT NULL AND a.observacoes_medicas <> 'Nenhuma';

SELECT DISTINCT e.nome_escola, e.tipo_rede
FROM escola e
JOIN atleta a ON e.id_escola = a.id_escola;

SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 2;

SELECT nome_colaborador, funcao, contato
FROM colaborador
ORDER BY nome_colaborador ASC;


-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Walter Anacleto Salido de Souza
-- Tema: Banco de Dados da Associação Atlética e Inclusiva de Atletismo (RAAEI)
-- Banco: db_raaei


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================
DROP DATABASE IF EXISTS db_raaei;
CREATE DATABASE db_raaei CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================
USE db_raaei;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

-- Tabela de Escolas Parceiras
CREATE TABLE escola (
    id_escola INT AUTO_INCREMENT PRIMARY KEY,
    nome_escola VARCHAR(100) NOT NULL,
    tipo_rede ENUM('Publica', 'Privada') NOT NULL,
    municipio VARCHAR(60) NOT NULL DEFAULT 'Rondonópolis',
    turno VARCHAR(20) NOT NULL
);

-- Tabela de Categorias de Atletismo
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    faixa_etaria VARCHAR(30) NOT NULL,
    genero_categoria ENUM('Masculino', 'Feminino', 'Misto') NOT NULL
);

-- Tabela de Colaboradores e Equipe Técnica
CREATE TABLE colaborador (
    id_colaborador INT AUTO_INCREMENT PRIMARY KEY,
    nome_colaborador VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    funcao VARCHAR(50) NOT NULL,
    contato VARCHAR(20) NOT NULL,
    data_admissao DATE NOT NULL
);

-- Tabela de Atletas
CREATE TABLE atleta (
    id_atleta INT AUTO_INCREMENT PRIMARY KEY,
    nome_atleta VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    genero VARCHAR(20) NOT NULL,
    observacoes_medicas VARCHAR(255) DEFAULT 'Nenhuma',
    data_cadastro DATE DEFAULT (CURRENT_DATE),
    id_escola INT NOT NULL,
    id_categoria INT NOT NULL
);


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================
ALTER TABLE atleta
    ADD CONSTRAINT fk_atleta_escola FOREIGN KEY (id_escola) REFERENCES escola(id_escola),
    ADD CONSTRAINT fk_atleta_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);


-- ============================================================
-- 5. INSERTS
-- ============================================================

-- Inserção de Escolas
INSERT INTO escola (nome_escola, tipo_rede, municipio, turno) VALUES
('Escola Estadual Dom Aquino', 'Publica', 'Rondonópolis', 'Matutino'),
('Escola Municipal Prof. Melchior', 'Publica', 'Rondonópolis', 'Vespertino'),
('Colégio Adventista de Rondonópolis', 'Privada', 'Rondonópolis', 'Integral'),
('Escola Estadual Lourdes Ribeiro', 'Publica', 'Rondonópolis', 'Matutino'),
('Escola Estadual LaSalle', 'Publica', 'Rondonópolis', 'Vespertino');

-- Inserção de Categorias
INSERT INTO categoria (nome_categoria, faixa_etaria, genero_categoria) VALUES
('Sub-14', '12 a 13 anos', 'Misto'),
('Sub-16', '14 a 15 anos', 'Misto'),
('Sub-18', '16 a 17 anos', 'Misto'),
('Sub-20', '18 a 19 anos', 'Misto'),
('Adulto', '20 anos ou mais', 'Misto'),
('Paratletismo Inclusivo', 'Livre', 'Misto');

-- Inserção de Colaboradores
INSERT INTO colaborador (nome_colaborador, cpf, funcao, contato, data_admissao) VALUES
('Walter Salido', '111.222.333-44', 'Presidente e Treinador Chefe', '(66) 99999-1111', '2024-01-10'),
('Vanessa Salido', '222.333.444-55', 'Tesoureira', '(66) 99999-2222', '2024-01-10'),
('Gabriel Pereira', '333.444.555-66', 'Vice-Presidente', '(66) 99999-3333', '2024-02-15'),
('Ana Lúcia Alves', '444.555.666-77', 'Secretária', '(66) 99999-4444', '2024-02-15'),
('José Elias', '555.666.777-88', 'Treinador Olímpico', '(66) 99999-5588', '2024-03-01'),
('Jerson Vicente', '666.777.888-99', 'Treinador Paralímpico', '(66) 99999-6699', '2024-03-01'),
('Diuvana Mendes', '777.888.999-00', 'Psicóloga', '(66) 99999-7700', '2024-04-10'),
('André Lima', '888.999.000-11', 'Coordenador de Literatura', '(66) 99999-8811', '2024-05-05');

-- Inserção de Atletas
INSERT INTO atleta (nome_atleta, data_nascimento, genero, observacoes_medicas, id_escola, id_categoria) VALUES
('Miguel Augusto', '2011-05-12', 'Masculino', 'Nenhuma', 1, 1),
('Giovana Santana', '2010-08-22', 'Feminino', 'Alergia leve a poeira', 2, 2),
('Matheus Mario', '2008-03-15', 'Masculino', 'Nenhuma', 3, 3),
('Gabriel Pereira', '2007-11-30', 'Masculino', 'Uso preventivo de bombinha para asma', 1, 4),
('Marcio Damásio', '2005-01-10', 'Masculino', 'Nenhuma', 4, 5),
('Andressa Silva', '2009-07-19', 'Feminino', 'Nenhuma', 5, 2),
('Renan Seabra', '2012-09-04', 'Masculino', 'Nenhuma', 2, 1),
('Gabrielle Bispo', '2006-12-18', 'Feminino', 'Restrição a impacto no joelho direito', 3, 4),
('Luiz Fernando', '2011-02-25', 'Masculino', 'Nenhuma', 1, 1),
('Maria Nunes', '2008-06-14', 'Feminino', 'Nenhuma', 4, 3),
('Sergio Santos', '2004-10-05', 'Masculino', 'Nenhuma', 5, 5),
('Artur de Souza', '2010-04-20', 'Masculino', 'Nenhuma', 2, 2),
('Maria Eduarda', '2007-08-09', 'Feminino', 'Nenhuma', 3, 4),
('Enzo Gabriel', '2012-01-30', 'Masculino', 'Nenhuma', 1, 1),
('Leandra Costa', '2005-09-11', 'Feminino', 'Nenhuma', 4, 5);


-- ============================================================
-- 6. UPDATES
-- ============================================================
UPDATE atleta 
SET observacoes_medicas = 'Atestado liberado para competições de alta intensidade.' 
WHERE id_atleta = 3;

UPDATE escola 
SET turno = 'Integral' 
WHERE nome_escola = 'Escola Estadual Dom Aquino';


-- ============================================================
-- 7. DELETES
-- ============================================================
DELETE FROM colaborador 
WHERE id_colaborador = 8;

DELETE FROM atleta 
WHERE id_atleta = 15;


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================
SELECT nome_atleta, data_nascimento, genero 
FROM atleta;


-- ============================================================
-- 9. WHERE
-- ============================================================
SELECT a.nome_atleta, e.nome_escola, a.observacoes_medicas
FROM atleta a
JOIN escola e ON a.id_escola = e.id_escola
WHERE a.observacoes_medicas IS NOT NULL AND a.observacoes_medicas <> 'Nenhuma';


-- ============================================================
-- 10. ORDER BY
-- ============================================================
SELECT nome_colaborador, funcao, contato 
FROM colaborador 
ORDER BY nome_colaborador ASC;


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================
SELECT 
    COUNT(*) AS total_atletas,
    MIN(data_nascimento) AS atleta_mais_velho_nasc,
    MAX(data_nascimento) AS atleta_mais_novo_nasc
FROM atleta;


-- ============================================================
-- 12. GROUP BY
-- ============================================================
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria;


-- ============================================================
-- 13. HAVING
-- ============================================================
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 2;


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================
SELECT 
    nome_escola, 
    UPPER(municipio) AS municipio_maiusculo, 
    CONCAT(nome_escola, ' - ', tipo_rede) AS info_escola
FROM escola;


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================
SHOW TABLES;
SELECT 'Banco de dados db_raaei validado e executado com sucesso!' AS status_execucao;


SHOW TABLES;

DESCRIBE nome_tabela;

SHOW CREATE TABLE nome_tabela;

SELECT 
    a.nome_atleta, 
    c.nome_categoria, 
    c.faixa_etaria, 
    a.genero, 
    e.nome_escola, 
    a.observacoes_medicas
FROM atleta a
JOIN escola e ON a.id_escola = e.id_escola
JOIN categoria c ON a.id_categoria = c.id_categoria
ORDER BY c.nome_categoria ASC, a.nome_atleta ASC;

SELECT 
    c.nome_categoria, 
    c.faixa_etaria, 
    COUNT(a.id_atleta) AS total_atletas
FROM categoria c
JOIN atleta a ON c.id_categoria = a.id_categoria
WHERE a.genero IN ('Masculino', 'Feminino')
GROUP BY c.id_categoria, c.nome_categoria, c.faixa_etaria
HAVING COUNT(a.id_atleta) > 0
ORDER BY total_atletas DESC, c.nome_categoria ASC;


