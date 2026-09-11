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
| corretor | 5 | Não |
| cliente | 5 | Não |
| imovel | 6 | Sim (corretor) |
| agendamento | 6 | Sim (cliente e imovel) |

---

# 8. INSERTs realizados

## Tabela 1

**Nome:**

```corretor```

```sql
INSERT INTO corretor (nome, creci, email, telefone)
VALUES
    ('Paulo Roberto de Lima Junior', 'CRECI111', 'paulo@imob.com', '66999991111'),
    ('Isa', 'CRECI222', 'isa@imob.com', '66999992222'),
    ('Jao', 'CRECI333', 'jao@imob.com', '66999993333'),
    ('Amanda', 'CRECI444', 'amanda@imob.com', '66999994444'),
    ('Theus', 'CRECI555', 'theus@imob.com', '66999995555');
```

## Tabela 2

**Nome:**

```cliente```

```sql
INSERT INTO cliente (nome, email, senha, telefone, data_nascimento)
VALUES
    ('João Guilherme Barros de Lima', 'joao@email.com', 'senha123', '66988881111', '2006-11-29'),
    ('Gi', 'gi@email.com', 'senha456', '66988882222', '2005-05-15'),
    ('Carlos Santos', 'carlos@email.com', 'senha789', '66988883333', '1990-08-20'),
    ('Mariana Silva', 'mariana@email.com', 'senha321', '66988884444', '1995-12-10'),
    ('Lucas Almeida', 'lucas@email.com', 'senha654', '66988885555', '1988-03-30');

```

## Tabela 3

**Nome:**

```imovel```

```sql
INSERT INTO imovel (id_corretor, titulo, valor, quantidade_comodos, cidade)
VALUES
    (1, 'Casa com piscina', 450000.00, 4, 'Rondonópolis'),
    (2, 'Apartamento Centro', 250000.00, 3, 'Rondonópolis'),
    (3, 'Chácara para descanso', 600000.00, 5, 'Chapada dos Guimarães'),
    (4, 'Casa na praia', 800000.00, 4, 'Alagoas'),
    (1, 'Terreno amplo', 150000.00, 0, 'Rondônia'),
    (5, 'Cobertura Duplex', 950000.00, 6, 'Rondonópolis');

```

## Tabela 4

**Nome:**

```agendamento```

```sql
INSERT INTO agendamento (id_cliente, id_imovel, data_visita, status)
VALUES
    (1, 4, '2026-10-15 10:00:00', 'Pendente'),
    (2, 3, '2026-10-16 14:30:00', 'Pendente'),
    (1, 3, '2026-10-17 09:00:00', 'Pendente'),
    (3, 2, '2026-10-18 11:00:00', 'Pendente'),
    (4, 5, '2026-10-19 15:00:00', 'Cancelado'),
    (5, 1, '2026-10-20 16:00:00', 'Pendente');
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
|  |  |  |
|  |  |  |
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
-- Cole aqui.

```

**O que foi alterado?**

> Escreva aqui.

## UPDATE 2

```sql
-- Cole aqui.

```

**O que foi alterado?**

> Escreva aqui.

## UPDATE 3

```sql
-- Cole aqui.

```

**O que foi alterado?**

> Escreva aqui.

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
-- Cole aqui.

```

**Registro removido:**

> Escreva aqui.

## DELETE 2

```sql
-- Cole aqui.

```

**Registro removido:**

> Escreva aqui.

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
USE nome_do_banco;

-- INSERTS

INSERT INTO tabela_a (
    campo_a1,
    campo_a2
)
VALUES (
    'Valor 1',
    'Valor 2'
);

INSERT INTO tabela_a (
    campo_a1,
    campo_a2
)
VALUES
    ('Valor 3', 'Valor 4'),
    ('Valor 5', 'Valor 6'),
    ('Valor 7', 'Valor 8');

INSERT INTO tabela_b (
    id_a,
    campo_b1
)
VALUES (
    1,
    'Outro valor'
);

-- VERIFICAÇÕES

SELECT * FROM tabela_a;
SELECT * FROM tabela_b;

-- UPDATES

UPDATE tabela_a
SET campo_a1 = 'Valor atualizado'
WHERE id_a = 1;

UPDATE tabela_a
SET campo_a2 = 'Outro valor'
WHERE id_a = 2;

UPDATE tabela_b
SET campo_b1 = 'Atualizado'
WHERE id_b = 1;

-- DELETES

DELETE FROM tabela_b
WHERE id_b = 3;

DELETE FROM tabela_a
WHERE id_a = 5;
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
|  |  |
|  |  |
|  |  |
|  |  |
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

- [ ] utilizei o banco criado na Sprint 2/5;
- [ ] utilizei `USE`;
- [ ] inseri dados coerentes com o projeto;
- [ ] respeitei a ordem das tabelas;
- [ ] procurei inserir pelo menos 5 registros nas tabelas principais;
- [ ] testei restrições de integridade;
- [ ] executei pelo menos 3 `UPDATE`;
- [ ] os `UPDATE` possuem condição adequada;
- [ ] executei pelo menos 2 `DELETE`;
- [ ] os `DELETE` possuem condição adequada;
- [ ] verifiquei dependências de `FOREIGN KEY`;
- [ ] utilizei `SELECT` para conferência;
- [ ] registrei os problemas encontrados;
- [ ] salvei o código como `SPRINT3-5.sql`;
- [ ] preenchi completamente o `SPRINT3-5.md`;
- [ ] revisei os arquivos antes do commit.

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
