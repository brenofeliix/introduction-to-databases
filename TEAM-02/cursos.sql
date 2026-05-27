# Team 02 — Módulo de Cursos

## Integrantes

- Geovanna Gaspar Ribeiro
---

# Descrição

Este módulo é responsável pelo gerenciamento de cursos no sistema, incluindo cadastro, consulta e organização das informações como nome, descrição e carga horária.

---

-- 1. Criação e seleção do banco de dados
CREATE DATABASE escola_db;
USE escola_db;

-- 2. Criação da tabela de cursos
CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    carga_horaria INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Inserção de dados para teste
INSERT INTO cursos (nome, descricao, carga_horaria) VALUES 
('Banco de Dados', 'Curso de SQL e modelagem de dados', 60),
('Programação', 'Lógica de programação e algoritmos', 80),
('Engenharia de Software', 'Processos de desenvolvimento de software', 120),
('Redes de Computadores', 'Fundamentos de redes', 50);

CONSULTAS SQL

SELECT * FROM cursos;
### Resultado:
![Resultado do Select Geral]("C:\Users\Geovanna\Pictures\Screenshots\Captura de tela 2026-05-27 183023.png")

SELECT COM WHERE

SELECT * FROM cursos
WHERE carga_horaria > 50;
### Resultado:
  ![Resultado do WHERE]()

SELECT COM ORDER BY

SELECT * FROM cursos
ORDER BY nome ASC;
### Resultado:
![Resultado do ORDER BY]("C:\Users\Geovanna\Pictures\Screenshots\Captura de tela 2026-05-27 182947.png"
