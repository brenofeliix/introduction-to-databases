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
USE pacote_viagens;
```

6. Confira as tabelas:

```sql
DESCRIBE cliente;
DESCRIBE destino;
DESCRIBE transporte;
DESCRIBE hospedagem;
DESCRIBE reserva_pacote;
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
| destino | 5 | Não |
| cliente | 5 | Não |
| transporte | 5 | Não |
| hospedagem | 5 | Sim (destino) |
| reserva_pacote | 5 | Sim (cliente, hospedagem, transporte) |

---

# 8. INSERTs realizados

## Tabela 1

**Nome:**

```text
destino
```

```sql
INSERT INTO destino (
    nome,
    pais,
    estado,
    descricao
)
VALUES
    ('Fernando de Noronha', 'Brasil', 'Pernambuco', 'Arquipélago vulcânico com praias paradisíacas e vida marinha abundante.'),
    ('Gramado', 'Brasil', 'Rio Grande do Sul', 'Cidade turística na Serra Gaúcha famosa pela arquitetura e gastronomia.'),
    ('Salvador', 'Brasil', 'Bahia', 'Capital baiana reconhecida pelo centro histórico do Pelourinho e cultura rica.'),
    ('Foz do Iguaçu', 'Brasil', 'Paraná', 'Famosa pelas Cataratas do Iguaçu e Parque das Aves.'),
    ('Rio de Janeiro', 'Brasil', 'Rio de Janeiro', 'Conhecida pelas praias de Copacabana e Ipanema e a estátua do Cristo Redentor.');

```

## Tabela 2

**Nome:**

```text
cliente
```

```sql
INSERT INTO cliente (
    nome,
    cpf,
    email,
    telefone
)
VALUES
    ('Carlos Silva', '123.456.789-01', 'carlos.silva@email.com', '(11) 98765-4321'),
    ('Mariana Oliveira', '234.567.890-12', 'mariana.oliveira@email.com', '(21) 97654-3210'),
    ('Roberto Santos', '345.678.901-23', 'roberto.santos@email.com', '(31) 96543-2109'),
    ('Ana Souza', '456.789.012-34', 'ana.souza@email.com', '(41) 95432-1098'),
    ('Beatriz Lima', '567.890.123-45', 'beatriz.lima@email.com', '(51) 94321-0987');

```

## Tabela 3

**Nome:**

```text

```
transporte
```sql
INSERT INTO transporte (
    tipo,
    empresa,
    origem,
    destino
)
VALUES
    ('Aéreo', 'LATAM', 'São Paulo (GRU)', 'Fernando de Noronha (FEN)'),
    ('Aéreo', 'Gol', 'Rio de Janeiro (GIG)', 'Porto Alegre (POA)'),
    ('Rodoviário', 'Viação Cometa', 'São Paulo (Tietê)', 'Curitiba (TRM)'),
    ('Aéreo', 'Azul', 'Belo Horizonte (CNF)', 'Salvador (SSA)'),
    ('Rodoviário', 'Catarinense', 'Florianópolis', 'Foz do Iguaçu');

```

## Tabela 4

**Nome:**

```text
hospedagem
```

```sql
INSERT INTO hospedagem (
    nome,
    endereco,
    tipo,
    valor_diaria,
    id_destino
)
VALUES
    ('Pousada Zé Maria', 'Rua Maj. José Vicente, 100', 'Pousada', 1200.00, 1),
    ('Hotel Colline de France', 'Rua Nilo Peçanha, 79', 'Hotel Resort', 950.00, 2),
    ('Fera Palace Hotel', 'Rua da Chile, 20', 'Hotel', 650.00, 3),
    ('Belmond Hotel das Cataratas', 'Rodovia BR-469, Km 28', 'Hotel Luxo', 1800.00, 4),
    ('Copacabana Palace', 'Av. Atlântica, 1702', 'Hotel Luxo', 2200.00, 5);

```

## Tabela 5

**Nome:**

```text
reserva_pacote
```

```sql
INSERT INTO reserva_pacote (
    id_cliente,
    id_hospedagem,
    id_transporte,
    data_reserva,
    quantidade_pessoas
)
VALUES
    (1, 1, 1, '2026-09-02', 2),
    (2, 2, 2, '2026-09-03', 1),
    (3, 3, 4, '2026-09-04', 4),
    (4, 4, 5, '2026-09-05', 2),
    (5, 5, 1, '2026-09-06', 3);
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
| UNIQUE | Tentativa de inserir um novo cliente com o CPF '123.456.789-01' já existente | O banco bloqueou a inserção retornando erro Error Code: 1062. Duplicate entry. |
| NOT NULL | Tentativa de inserir uma hospedagem com valor_diaria definido como NULL | O banco impediu a execução retornando erro Error Code: 1048. Column cannot be null. |
| FOREIGN KEY | Inserção de registro na tabela hospedagem com id_destino = 99. | O banco rejeitou o comando com erro Error Code: 1452. Cannot add or update a child row. |

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
UPDATE cliente
SET telefone = '(11) 99999-8888'
WHERE id_cliente = 1;

```

**O que foi alterado?**

> Foi atualizado o número de telefone do cliente de ID 1 (Carlos Silva).

## UPDATE 2

```sql
UPDATE hospedagem
SET valor_diaria = 1050.00
WHERE id_hospedagem = 2;

```

**O que foi alterado?**

> Foi reajustado o valor da diária da hospedagem de ID 2 (Hotel Colline de France) de R$ 950.00 para R$ 1050.00.

## UPDATE 3

```sql
UPDATE reserva_pacote
SET quantidade_pessoas = 5
WHERE id_reserva = 3;

```

**O que foi alterado?**

> Foi alterada a quantidade de pessoas da reserva de pacote de ID 3, mudando 4 para 5 pessoas.

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
SQL
DELETE FROM reserva_pacote
WHERE id_reserva = 5;

```

**Registro removido:**

> Removida a reserva de pacote de ID 5, eliminando a dependência do cliente 5.

## DELETE 2

```sql
DELETE FROM cliente
WHERE id_cliente = 5;

```

**Registro removido:**

> Excluído o registro do cliente de ID 5 (Beatriz Lima), operação realizada de forma segura após a exclusão de sua reserva associada.

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
USE pacote_viagens;

-- INSERTS EXEMPLO
INSERT INTO destino (nome, pais, estado, descricao)
VALUES ('Fernando de Noronha', 'Brasil', 'Pernambuco', 'Praias paradisíacas.');

-- VERIFICAÇÕES
SELECT * FROM destino;

-- UPDATES
UPDATE cliente
SET telefone = '(11) 99999-8888'
WHERE id_cliente = 1;

-- DELETES
DELETE FROM reserva_pacote
WHERE id_reserva = 5;
```

---

# 21. Estrutura recomendada do SPRINT3-5.sql

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno:
-- Banco:


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE nome_do_banco;


-- ============================================================
-- INSERTS — TABELA 1
-- ============================================================


-- ============================================================
-- INSERTS — TABELA 2
-- ============================================================


-- ============================================================
-- INSERTS — TABELA 3
-- ============================================================


-- ============================================================
-- INSERTS — TABELA 4
-- ============================================================


-- ============================================================
-- VERIFICAÇÕES
-- ============================================================


-- ============================================================
-- UPDATES
-- ============================================================


-- ============================================================
-- DELETES
-- ============================================================


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
| destino | 5 |
| cliente | 4 |
| transporte | 5 |
| hospedagem | 5 |
| reserva_pacote | 4 |

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos:

```text
25 registros (5 em cada uma das 5 tabelas)
```

## UPDATE

Quantidade de operações:

```text
3 operações
```

## DELETE

Quantidade de operações:

```text
2 operações
```

---

# 25. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Error Code: 1452. Cannot add or update a child row | Tentativa de inserir registros na tabela reserva_pacote referente a um id_transporte antes da execução dos INSERTs na tabela transporte | Reorganizada a ordem de execução do script para criar todas as tabelas independentes (transporte) antes das tabelas dependentes |
| Error Code: 1175. You are using safe update mode | Trava padrão do MySQL Workbench que bloqueia UPDATE e DELETE sem restrição restrita por PK ou índice | Adicionado o comando SET SQL_SAFE_UPDATES = 0; no início do script para desativar a restrição temporariamente durante o teste |

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
