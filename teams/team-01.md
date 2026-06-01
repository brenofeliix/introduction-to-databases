# Team 01 — Módulo de Alunos

## Integrantes

- Vinícius Eduardo Lima de Assis

---

# Descrição

Responsável por: tabela de alunos; registros de alunos e consultas básicas de alunos.

---

# CREATE TABLE

```sql
CREATE TABLE alunos (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_nascimento DATE
);
```

---

# INSERT INTO

```sql
INSERT INTO alunos(nome, cpf, email, telefone, data_nascimento)
VALUES
('Carlos Silva', '123.456.789-00', 'carlos@gmail.com', '66999999999', '2002-05-10'),
('Ana Souza', '987.654.321-00', 'ana@gmail.com', '66988888888', '2001-08-15'),
('João Pedro', '111.222.333-44', 'joao@gmail.com', '66977777777', '2003-09-20'),
('Mariana Lima', '555.666.777-88', 'mariana@gmail.com', '66966666666', '2000-11-03'),
('Lucas Ferreira', '999.888.777-66', 'lucas@gmail.com', '66955555555', '2002-02-25');
```

---

# CONSULTAS SQL

## SELECT *

```sql - Buscar todos os alunos
SELECT * FROM alunos;
```

---

## SELECT COM WHERE

```sql - Buscar Aluno pelo Nome
SELECT * FROM alunos
WHERE nome = 'Carlos Silva';
```

---

## SELECT COM ORDER BY

```sql - Buscar em Ordem Alfabética
SELECT * FROM alunos
ORDER BY nome ASC;
```

---

# JOIN

```sql
SELECT *
FROM example;
```

---

# Screenshots

- Criando tabela:

<img width="1919" height="1029" alt="image" src="https://github.com/user-attachments/assets/d6507854-b90c-446e-a976-3a8b034e621b" />

- Inserindo os dados:

<img width="1914" height="1007" alt="image" src="https://github.com/user-attachments/assets/a6bebd33-7c60-4c95-b020-fe8e089835af" />

- Consultando todos os alunos:

<img width="1914" height="983" alt="image" src="https://github.com/user-attachments/assets/0a6d246e-14e7-4def-9a85-abd1ca65b314" />

- Consultando por nome:

<img width="1911" height="983" alt="image" src="https://github.com/user-attachments/assets/46bb6bcf-ee7a-4180-b059-2e3d10cd7adc" />

- Consultando por ordem alfabética:

<img width="1910" height="978" alt="image" src="https://github.com/user-attachments/assets/c0e87548-e60a-4dc8-8f77-8b7c9ace198e" />




