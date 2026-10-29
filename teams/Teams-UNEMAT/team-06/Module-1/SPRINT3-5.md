# SPRINT 3/5 — Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# Objetivo da Sprint 3/5

Nesta etapa, cada aluno deverá utilizar o banco de dados criado na `SPRINT2-5.sql` para **inserir, alterar e excluir dados** utilizando comandos DML (*Data Manipulation Language*).

Nesta Sprint serão trabalhados principalmente:

```sql
INSERT
UPDATE
DELETE
```

Ao final da atividade, o banco deverá possuir dados coerentes com o domínio escolhido na Sprint 1/5.

O aluno deverá entregar:

```text
SPRINT3-5.md
SPRINT3-5.sql
```

O arquivo `SPRINT3-5.md` documentará o trabalho realizado. O arquivo `SPRINT3-5.sql` deverá conter os comandos SQL produzidos e testados no MySQL Workbench.

> Utilize obrigatoriamente o banco e as tabelas criados na Sprint 2/5.

---

# 1. Antes de começar

1. Abra o MySQL Workbench.
2. Abra sua conexão.
3. Confirme que o banco criado na Sprint 2/5 existe.
4. Abra ou execute o `SPRINT2-5.sql`, se necessário.
5. Selecione o banco:

```sql
USE nome_do_banco;
```

6. Confira as tabelas:

```sql
DESCRIBE nome_da_tabela;
```

---

# 2. Crie o arquivo SPRINT3-5.sql

No MySQL Workbench:

```text
File → New Query Tab
```

Depois:

```text
File → Save Script As...
```

Salve exatamente como:

```text
SPRINT3-5.sql
```

Esse arquivo deverá conter os comandos DML desta Sprint.

---

# 3. INSERT — inserindo dados

Estrutura básica:

```sql
INSERT INTO nome_tabela (
    campo_1,
    campo_2,
    campo_3
)
VALUES (
    valor_1,
    valor_2,
    valor_3
);
```

Exemplo:

```sql
INSERT INTO cliente (
    nome,
    email,
    data_nascimento
)
VALUES (
    'Ana Souza',
    'ana@email.com',
    '2000-05-10'
);
```

---

# 4. Inserindo vários registros

```sql
INSERT INTO cliente (
    nome,
    email
)
VALUES
    ('Ana Souza', 'ana@email.com'),
    ('Carlos Lima', 'carlos@email.com'),
    ('Mariana Silva', 'mariana@email.com');
```

---

# 5. Quantidade mínima de dados

Procure inserir:

```text
pelo menos 5 registros em cada tabela principal
```

Exemplo:

```text
CLIENTE        → pelo menos 5 registros
PRODUTO        → pelo menos 5 registros
PEDIDO         → pelo menos 5 registros
ITEM_PEDIDO    → registros suficientes para representar os relacionamentos
```

Os dados precisam ser coerentes e úteis para as consultas da Sprint 4/5.

---

# 6. Ordem correta dos INSERTs

Quando existem `FOREIGN KEY`, insira primeiro os registros das tabelas independentes.

Exemplo:

```text
CLIENTE
   ↓
PEDIDO
   ↓
ITEM_PEDIDO
```

Ordem recomendada:

```text
1. tabelas independentes;
2. tabelas com FOREIGN KEY;
3. tabelas associativas.
```

---

# 7. Planejamento dos dados

| Tabela | Quantidade prevista | Depende de outra tabela? |
|---|---:|---|
| Categoria | 4 | Não |
| Produto | 4 | Sim |
| venda | 7 | Não |
| Item_venda | 5 | Sim |
|  |  |  |

---

# 8. INSERTs realizados

## Tabela 1

**Nome:**

```
CATEGORIA
```

```sql
INSERT INTO Categoria(nome_categoria) VALUES
('Salgados'),
('Doces e Bolachas'),
('Pão fresco'),
('Cobras');
```

## Tabela 2

**Nome:**

```
PRODUTO
```

```sql
INSERT INTO Produto(id_categoria, codigo_barras, nome_produto, quantidade_estoque) VALUES 
(1, '102324232323', 'Pão Frito', 50),
(1, '102324232324', 'Almoço velho', 50),
(1, '142324232325', 'Doces e Legumes', 50),
(1, '102324232326', 'Simplesmente a mulher mais linda do Mundo', 1);
```

## Tabela 3

**Nome:**

```
VENDA
```

```sql
INSERT INTO Venda(valor_total) VALUES
(15.00),
(13.00),
(12.00),
(03.00),
(07.00),
(23.00),
(08.00);
```

## Tabela 4

**Nome:**

```
ITEM_VENDA
```

```sql
INSERT INTO Item_venda(quantidade, id_venda,id_produto) VALUES
(1,1,1),
(1,1,2),
(1,2,3),
(2,3,4),
(1,5,2);
```

---

# 9. AUTO_INCREMENT

Se a chave primária utiliza `AUTO_INCREMENT`, normalmente você não informa o identificador no `INSERT`.

Exemplo:

```sql
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);
```

Inserção:

```sql
INSERT INTO cliente (nome)
VALUES ('Maria');
```

---

# 10. Tipos de valores

Texto:

```sql
'João da Silva'
```

Inteiro:

```sql
10
```

Decimal:

```sql
199.90
```

Data:

```sql
'2026-09-02'
```

Booleano:

```sql
TRUE
```

ou:

```sql
FALSE
```

Ausência de valor:

```sql
NULL
```

---

# 11. Testando restrições de integridade

Agora que existem dados, teste restrições criadas na Sprint 2/5.

Exemplo:

```sql
email VARCHAR(150) UNIQUE
```

Pergunte:

- o banco impede valores duplicados?
- `NOT NULL` está funcionando?
- a `FOREIGN KEY` impede referências inexistentes?

Registre os resultados:

| Restrição testada | O que foi testado? | Resultado |
|---|---|---|
| Valores Duplicados | se é possivel um valor INT com valor duplicado | não deixou:  Truncated incorrect DOUBLE value: '1,5'|
| Chave Estrangeria | Inserção de um id_produto no item_venda que não existe | O banco bloqueou a inserção devido a restrição de Foreign Key |
|  |  |  |

> Não mantenha comandos propositalmente inválidos no `SPRINT3-5.sql` final.

---

# 12. UPDATE — alterando registros

Estrutura:

```sql
UPDATE nome_tabela
SET campo = novo_valor
WHERE condicao;
```

Exemplo:

```sql
UPDATE cliente
SET email = 'novo@email.com'
WHERE id_cliente = 1;
```

---

# 13. Atenção ao WHERE no UPDATE

Este comando:

```sql
UPDATE cliente
SET ativo = FALSE;
```

pode alterar **todos os registros**.

Já:

```sql
UPDATE cliente
SET ativo = FALSE
WHERE id_cliente = 3;
```

altera somente o registro escolhido.

> Confira sempre o `WHERE` antes da execução.

---

# 14. UPDATEs obrigatórios

Execute pelo menos:

```text
3 operações UPDATE
```

## UPDATE 1

```sql
UPDATE Produto
SET preco_venda = 10.50
WHERE id_produto = 1;
```

**O que foi alterado?**

> Preço da venda um que no caso seria o Pão frito

## UPDATE 2

```sql
UPDATE Produto
SET preco_venda = 20.00
WHERE id_produto = 2;
```

**O que foi alterado?**

> Preço da segunda venda ou seja o almoço velho

## UPDATE 3

```sql
UPDATE Produto
SET preco_venda = 1000000.00
WHERE id_produto = 4;
```

**O que foi alterado?**

> Deixando o valor mais linda do mundo no maximo que acaba sendo possivel.

---

# 15. DELETE — removendo registros

Estrutura:

```sql
DELETE FROM nome_tabela
WHERE condicao;
```

Exemplo:

```sql
DELETE FROM cliente
WHERE id_cliente = 5;
```

---

# 16. Atenção ao WHERE no DELETE

Este comando:

```sql
DELETE FROM cliente;
```

remove todos os registros.

Este:

```sql
DELETE FROM cliente
WHERE id_cliente = 5;
```

remove apenas o registro selecionado.

> Nunca execute `DELETE` sem conferir a condição.

---

# 17. DELETE e FOREIGN KEY

Uma exclusão pode ser impedida pela integridade referencial.

Exemplo:

```text
CLIENTE
   ↓
PEDIDO
```

Se um pedido depende de um cliente, o MySQL pode impedir:

```sql
DELETE FROM cliente
WHERE id_cliente = 1;
```

Isso pode indicar que a `FOREIGN KEY` está funcionando corretamente.

---

# 18. DELETEs obrigatórios

Execute pelo menos:

```text
2 operações DELETE
```

## DELETE 1

```sql
DELETE FROM item_venda 
WHERE id_venda IN('1'); 
```

**Registro removido:**

> Removeu o ID que tinham antes de valor: (1,1,1),

## DELETE 2

```sql
DELETE FROM item_venda 
WHERE id_venda IN('2'); 
```

**Registro removido:**

> Removeu o ID (1,2,3) então né tá funcionando

---

# 19. Conferindo os registros

Nesta Sprint, você pode utilizar `SELECT` apenas para verificar o estado das tabelas.

```sql
SELECT * FROM nome_tabela;
```

Antes de um `UPDATE` ou `DELETE`, é recomendável verificar o registro.

```sql
SELECT *
FROM cliente
WHERE id_cliente = 3;
```

Depois execute a alteração e consulte novamente.

---

# 20. Modelo genérico para adaptar

**Não entregue o código abaixo sem adaptação.**

```sql
USE db_conveniencia;

-- INSERTS

INSERT INTO Categoria(nome_categoria) VALUES
('Salgados'),
('Doces e Bolachas'),
('Pão fresco'),
('Cobras');

INSERT INTO Produto(id_categoria, codigo_barras, nome_produto, quantidade_estoque) VALUES 
(1, '102324232323', 'Pão Frito', 50),
(2, '102324232324', 'Almoço velho', 50),
(3, '142324232325', 'Doces e Legumes', 50),
(4, '102324232326', 'Simplesmente a mulher mais linda do Mundo', 1);

INSERT INTO Venda(valor_total) VALUES
(15.00),
(13.00),
(12.00),
(03.00),
(07.00),
(23.00),
(08.00);

INSERT INTO Item_venda(quantidade, id_venda,id_produto) VALUES
(1,1,1),
(1,1,2),
(1,2,3),
(2,3,4),
(1,5,2);

-- VERIFICAÇÕES

SELECT * FROM Venda;
SELECT * FROM item_venda;

-- UPDATES

UPDATE Produto
SET preco_venda = 12.50
WHERE id_produto = 1;

UPDATE Produto
SET preco_venda = 23.00
WHERE id_produto = 2;

UPDATE Produto
SET preco_venda = 1000000.00
WHERE id_produto = 4;

-- DELETES

DELETE FROM item_venda 
WHERE id_venda IN('1'); 

DELETE FROM item_venda 
WHERE id_venda IN('2');
```

---

# 21. Estrutura recomendada do SPRINT3-5.sql

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Mariano Lino da Silva Neto
-- Banco: db_conveniencia


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE db_conveniencia;


-- ============================================================
-- INSERTS — TABELA 1
-- ============================================================
INSERT INTO Categoria(nome_categoria) VALUES
('Salgados'),
('Doces e Bolachas'),
('Pão fresco'),
('Cobras');

-- ============================================================
-- INSERTS — TABELA 2
-- ============================================================
INSERT INTO Produto(id_categoria, codigo_barras, nome_produto, quantidade_estoque) VALUES 
(1, '102324232323', 'Pão Frito', 50),
(2, '102324232324', 'Almoço velho', 50),
(3, '142324232325', 'Doces e Legumes', 50),
(4, '102324232326', 'Simplesmente a mulher mais linda do Mundo', 1);

-- ============================================================
-- INSERTS — TABELA 3
-- ============================================================
INSERT INTO Venda(valor_total) VALUES
(15.00),
(13.00),
(12.00),
(03.00),
(07.00),
(23.00),
(08.00);

-- ============================================================
-- INSERTS — TABELA 4
-- ============================================================
INSERT INTO Item_venda(quantidade, id_venda,id_produto) VALUES
(1,1,1),
(1,1,2),
(1,2,3),
(2,3,4),
(1,5,2);

-- ============================================================
-- VERIFICAÇÕES
-- ============================================================
SELECT * FROM item_venda;
SELECT * FROM Produto;
SELECT * FROM Venda;

-- ============================================================
-- UPDATES
-- ============================================================
UPDATE Produto
SET preco_venda = 12.50
WHERE id_produto = 1;

UPDATE Produto
SET preco_venda = 23.00
WHERE id_produto = 2;

UPDATE Produto
SET preco_venda = 1000000.00
WHERE id_produto = 4;

-- ============================================================
-- DELETES
-- ============================================================
DELETE FROM item_venda 
WHERE id_venda IN('1'); 

DELETE FROM item_venda 
WHERE id_venda IN('2'); 

-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

```

---

# 22. Passo a passo no MySQL Workbench

## Etapa 1 — Abra o banco

No painel `Schemas`, confirme se o banco e as tabelas da Sprint 2/5 estão disponíveis.

## Etapa 2 — Selecione o banco

```sql
USE nome_do_banco;
```

## Etapa 3 — Insira dados nas tabelas independentes

Comece pelas tabelas que não possuem dependências.

## Etapa 4 — Confira os dados

```sql
SELECT * FROM nome_tabela;
```

## Etapa 5 — Insira dados nas tabelas dependentes

Respeite as `FOREIGN KEY`.

## Etapa 6 — Execute os UPDATEs

Realize pelo menos três alterações coerentes.

## Etapa 7 — Execute os DELETEs

Realize pelo menos duas exclusões seguras.

## Etapa 8 — Faça a verificação final

Confira o conteúdo das tabelas.

## Etapa 9 — Salve o arquivo

```text
File → Save Script As...
```

Nome obrigatório:

```text
SPRINT3-5.sql
```

---

# 23. Resumo dos dados

| Tabela | Quantidade aproximada de registros ao final |
|---|---:|
| Categoria | 4 |
| Produto | 4 |
| Venda | 7 |
| Item_venda | 2 |
|  |  |

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos:

```text

```

## UPDATE

Quantidade de operações:

```text

```

## DELETE

Quantidade de operações:

```text

```

---

# 25. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

Mensagens que podem aparecer:

```text
Duplicate entry
Cannot add or update a child row
Cannot delete or update a parent row
Column cannot be null
Data too long for column
Unknown column
```

---

# 26. O que deve existir ao final desta Sprint

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql
```

Não exclua arquivos das etapas anteriores.

---

# 27. Checklist da Sprint 3/5

- [x] utilizei o banco criado na Sprint 2/5;
- [x] utilizei `USE`;
- [x] inseri dados coerentes com o projeto;
- [x] respeitei a ordem das tabelas;
- [x] procurei inserir pelo menos 5 registros nas tabelas principais;
- [x] testei restrições de integridade;
- [x] executei pelo menos 3 `UPDATE`;
- [x] os `UPDATE` possuem condição adequada;
- [x] executei pelo menos 2 `DELETE`;
- [x] os `DELETE` possuem condição adequada;
- [x] verifiquei dependências de `FOREIGN KEY`;
- [x] utilizei `SELECT` para conferência;
- [x] registrei os problemas encontrados;
- [x] salvei o código como `SPRINT3-5.sql`;
- [x] preenchi completamente o `SPRINT3-5.md`;
- [x] revisei os arquivos antes do commit.

---

# 28. Regras de Git/GitHub

A atividade continua **individual**.

Utilize a mesma branch individual das Sprints anteriores.

Não crie uma branch nova.

## Arquivos obrigatórios no commit desta Sprint

```text
SPRINT3-5.md
SPRINT3-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 3 de 5 - operações DML
```

---

# 29. Pull Request

**Ainda não abra o Pull Request final.**

O PR será aberto somente após a Sprint 5/5.

```text
SPRINT1-5.md
      ↓ commit

SPRINT2-5.md + SPRINT2-5.sql
      ↓ commit

SPRINT3-5.md + SPRINT3-5.sql
      ↓ commit

SPRINT4-5.md + SPRINT4-5.sql
      ↓ commit

SPRINT5-5.md + SPRINT5-5.sql
      ↓ commit

PULL REQUEST FINAL
      ↓
main
```

---

# 30. Critério de conclusão

A Sprint 3/5 será considerada concluída quando o aluno:

1. utilizar o banco criado anteriormente;
2. popular suas tabelas;
3. respeitar os relacionamentos existentes;
4. utilizar corretamente `INSERT`;
5. realizar pelo menos 3 `UPDATE`;
6. realizar pelo menos 2 `DELETE`;
7. preservar a integridade dos dados;
8. documentar a atividade no `SPRINT3-5.md`;
9. salvar o código executável em `SPRINT3-5.sql`;
10. incluir os dois arquivos no commit.

---

# Próxima etapa

Na **Sprint 4/5**, os dados criados nesta etapa serão utilizados para consultas SQL.

Serão trabalhados:

```sql
SELECT
WHERE
ORDER BY
GROUP BY
HAVING
COUNT
SUM
AVG
MIN
MAX
```

> **Não desenvolva a Sprint 4/5 neste arquivo.**
