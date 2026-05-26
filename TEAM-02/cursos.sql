-- =====================================
-- TABELA DE CURSOS
-- =====================================
CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    carga_horaria INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================
-- INSERINDO DADOS (REGISTROS)
-- =====================================
INSERT INTO cursos (nome, descricao, carga_horaria) VALUES
('Banco de Dados', 'Curso de SQL e modelagem de dados', 60),
('Programação', 'Lógica de programação e algoritmos', 80),
('Engenharia de Software', 'Processos de desenvolvimento de software', 70),
('Redes de Computadores', 'Fundamentos de redes', 50);

-- =====================================
-- CONSULTAS BÁSICAS
-- =====================================

-- Listar todos os cursos
SELECT * FROM cursos;

-- Listar apenas nome e carga horária
SELECT nome, carga_horaria FROM cursos;

-- Buscar cursos com carga horária maior que 60
SELECT * FROM cursos WHERE carga_horaria > 60;

-- Buscar curso pelo nome
SELECT * FROM cursos WHERE nome = 'Banco de Dados';

-- Ordenar cursos por carga horária
SELECT * FROM cursos ORDER BY carga_horaria DESC;
