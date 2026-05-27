# Team 02 — Módulo de Cursos

## Integrantes

- Geovanna Gaspar Ribeiro

---

# Descrição

Este módulo é responsável pelo gerenciamento de cursos no sistema. Ele permite cadastrar cursos, armazenar informações como nome, descrição e carga horária, além de realizar consultas e ordenações dos dados.

---

# CREATE TABLE

```sql 
CREATE TABLE cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    carga_horaria INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
# INSERT INTO
```sql 

INSERT INTO cursos (nome, descricao, carga_horaria) VALUES
('Banco de Dados', 'Curso de SQL e modelagem de dados', 60),
('Programação', 'Lógica de programação e algoritmos', 80),
('Engenharia de Software', 'Processos de desenvolvimento de software', 70),
('Redes de Computadores', 'Fundamentos de redes', 50);
```
# SELECT *
```sql 
SELECT * FROM cursos;
```
<img width="540" height="333" alt="Captura de tela 2026-05-27 183023" src="https://github.com/user-attachments/assets/d570fdb5-0b3f-4846-a087-5e225c4b2fbb" />

# SELECT COM WHERE
```sql 
SELECT * FROM cursos
ORDER BY carga_horaria DESC;
```
<img width="552" height="356" alt="Captura de tela 2026-05-27 182911" src="https://github.com/user-attachments/assets/477e2eff-e7e8-4f33-9956-03daec896a07" />

# ORDER BY
```sql 
SELECT * FROM cursos
WHERE carga_horaria > 60;
```
<img width="558" height="405" alt="Captura de tela 2026-05-27 182947" src="https://github.com/user-attachments/assets/07747d4d-20ff-4b6a-b98f-3dcba5e59bc9" />



