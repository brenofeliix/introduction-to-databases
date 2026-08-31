# Team 02 — Modulo Imobiliario

## Integrantes

- Rafael Tokashiki Souza

---

# Descricao

Este modulo e responsavel pelo cadastro de imoveis e de seus proprietarios.
Permite registrar informacoes como tipo, finalidade, bairro, numero de quartos,
area e preco, alem de identificar o proprietario de cada imovel.

---

# CREATE TABLE

```sql
CREATE TABLE proprietarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    cidade VARCHAR(80)
);

CREATE TABLE imoveis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    finalidade VARCHAR(20) NOT NULL,
    bairro VARCHAR(80),
    cidade VARCHAR(80) NOT NULL,
    quartos INT DEFAULT 0,
    banheiros INT DEFAULT 0,
    vagas INT DEFAULT 0,
    area_m2 DECIMAL(8,2),
    preco DECIMAL(12,2) NOT NULL,
    disponivel BOOLEAN DEFAULT TRUE,
    data_cadastro DATE NOT NULL,
    proprietario_id INT,
    FOREIGN KEY (proprietario_id) REFERENCES proprietarios(id)
);
```

---

# INSERT INTO

```sql
INSERT INTO proprietarios (nome, telefone, cidade) VALUES
('Joao Pereira', '66999990001', 'Rondonopolis'),
('Maria Santos', '66999990002', 'Rondonopolis'),
('Carlos Oliveira', '66999990003', 'Cuiaba');

INSERT INTO imoveis
(titulo, tipo, finalidade, bairro, cidade, quartos, banheiros, vagas, area_m2, preco, data_cadastro, proprietario_id)
VALUES
('Casa terrea com quintal', 'Casa', 'Venda', 'Vila Aurora', 'Rondonopolis', 3, 2, 2, 180.00, 450000.00, '2026-03-10', 1),
('Apartamento no centro', 'Apartamento', 'Aluguel', 'Centro', 'Rondonopolis', 2, 1, 1, 68.50, 1800.00, '2026-04-02', 1),
('Sobrado alto padrao', 'Sobrado', 'Venda', 'Jardim Atlantico', 'Rondonopolis', 4, 4, 3, 320.00, 1250000.00, '2026-01-15', 2),
('Kitnet mobiliada', 'Kitnet', 'Aluguel', 'Vila Birigui', 'Rondonopolis', 1, 1, 0, 32.00, 950.00, '2026-05-20', 2),
('Terreno em condominio', 'Terreno', 'Venda', 'Parque Universitario', 'Rondonopolis', 0, 0, 0, 400.00, 280000.00, '2026-02-08', 3),
('Sala comercial', 'Comercial', 'Aluguel', 'Centro', 'Rondonopolis', 0, 1, 1, 45.00, 2200.00, '2026-06-01', 3);
```

---

# CONSULTAS SQL

## SELECT *

```sql
SELECT * FROM imoveis;
```

---

## SELECT COM WHERE

```sql
SELECT titulo, bairro, preco
FROM imoveis
WHERE finalidade = 'Venda';
```

---

## SELECT COM ORDER BY

```sql
SELECT titulo, quartos, preco
FROM imoveis
ORDER BY preco DESC;
```

---

## SELECT COM GROUP BY

```sql
SELECT tipo, COUNT(*) AS total
FROM imoveis
GROUP BY tipo;
```

---

# JOIN

Relaciona cada imovel ao seu proprietario por meio da chave estrangeira
`proprietario_id`.

```sql
SELECT imoveis.titulo, imoveis.preco, proprietarios.nome
FROM imoveis
INNER JOIN proprietarios ON imoveis.proprietario_id = proprietarios.id;
```

---

# Screenshots

Inserir screenshots abaixo.

---

# Observacoes

Os scripts foram executados e testados no MySQL via terminal no Ubuntu.
