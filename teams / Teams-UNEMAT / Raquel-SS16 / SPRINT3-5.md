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
| PLATAFORMA | 6 | Não (independente) |
| USUARIO | 6 | Não (independente) |
| SERIE | 8 | Sim (PLATAFORMA) |
| ITEM_WATCHLIST | 11 | Sim (USUARIO e SERIE) |
|  |  |  |

---

# 8. INSERTs realizados

## Tabela 1

**Nome:**

```text

PLATAFORMA

```

```sql
-- Cole aqui os INSERTs realizados.
INSERT INTO plataforma (nome_plataforma)
VALUES 
    ('Netflix'),
    ('HBO Max'),
    ('Prime Video'),
    ('Disney+'),
    ('Apple TV+'),
    ('Paramount+');
```

## Tabela 2

**Nome:**

```text

USUARIO

```

```sql
-- Cole aqui os INSERTs realizados.

INSERT INTO usuario (nome, email, data_cadastro)
VALUES 
    ('Lucas Silveira', 'lucas.silveira@email.com', '2024-01-15'),
    ('Beatriz Lima', 'beatriz.lima@email.com', '2024-02-10'),
    ('Carlos Eduardo', 'carlos.edu@email.com', '2024-02-28'),
    ('Mariana Santos', 'mariana.santos@email.com', '2024-03-05'),
    ('Rafael Souza', 'rafael.souza@email.com', '2024-03-12'),
    ('Fernanda Costa', 'fernanda.costa@email.com', '2024-03-20');

```

## Tabela 3

**Nome:**

```text
SERIE
```

```sql
-- Cole aqui os INSERTs realizados.

INSERT INTO serie (titulo, genero, ano_lancamento, id_plataforma, pais_origem)
VALUES 
    ('Stranger Things', 'Ficção Científica', 2016, 1, 'EUA'),
    ('The Last of Us', 'Drama / Pós-Apocalíptico', 2023, 2, 'EUA'),
    ('The Boys', 'Ação / Super-heróis', 2019, 3, 'EUA'),
    ('The Mandalorian', 'Ficção Científica / Aventura', 2019, 4, 'EUA'),
    ('Severance', 'Suspense / Ficção Científica', 2022, 5, 'EUA'),
    ('Dark', 'Ficção Científica / Mistério', 2017, 1, 'Alemanha'),
    ('Succession', 'Drama', 2018, 2, 'EUA'),
    ('Serie Cancelada Teste', 'Comédia', 2020, 6, 'EUA');

```

## Tabela 4

**Nome:**

```text

ITEM_WATCHLIST

```

```sql
-- Cole aqui os INSERTs realizados.

INSERT INTO item_watchlist (id_usuario, id_serie, status_assistindo, nota, comentario)
VALUES 
    (1, 1, 'Finalizado', 9.5, 'Excelente primeira e quarta temporadas.'),
    (1, 2, 'Assistindo', 9.0, 'Adaptação muito fiel ao jogo.'),
    (1, 5, 'Quero Ver', NULL, NULL),
    (2, 2, 'Finalizado', 10.0, 'Uma obra-prima dramática.'),
    (2, 6, 'Finalizado', 9.8, 'Roteiro complexo e trilha fantástica.'),
    (3, 3, 'Assistindo', 8.5, 'Sátira ácida muito boa.'),
    (3, 4, 'Quero Ver', NULL, NULL),
    (4, 1, 'Assistindo', 8.0, 'Ritmo bom.'),
    (4, 7, 'Finalizado', 9.7, 'Atuações impecáveis.'),
    (5, 5, 'Quero Ver', NULL, NULL),
    (6, 8, 'Quero Ver', NULL, 'Adicionada para teste de remoção.');

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
| UNIQUE (email em USUARIO) | Tentativa de inserir um novo usuário utilizando o e-mail 'lucas.silveira@email.com', já existente. | O MySQL bloqueou a inserção retornando erro Error Code: 1062. Duplicate entry 'lucas.silveira@email.com' for key 'usuario.email' |
| NOT NULL (titulo em SERIE) | Tentativa de inserir uma série omitindo o título ou passando valor explicitamente NULL. | O MySQL bloqueou a operação com o erro Error Code: 1048. Column 'titulo' cannot be null |
| FOREIGN KEY (id_plataforma em SERIE) | Tentativa de inserir uma série apontando para id_plataforma = 999 (inexistente). | O MySQL bloqueou a inserção com o erro Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails |

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
UPDATE item_watchlist
SET status_assistindo = 'Finalizado'
WHERE id_usuario = 1 AND id_serie = 2;
```

**O que foi alterado?**

> Alterou o status da série de ID 2 (The Last of Us) na lista do usuário de ID 1 de 'Assistindo' para 'Concluído'.

## UPDATE 2

```sql
-- Cole aqui.
UPDATE usuario
SET email = 'carlos.eduardo.dev@email.com'
WHERE id_usuario = 3;

```

**O que foi alterado?**

> Atualizou o endereço de e-mail corporativo/pessoal do usuário Carlos Eduardo (ID 3).

## UPDATE 3

```sql
-- Cole aqui.

UPDATE serie
SET genero = 'Drama / Ficção Científica'
WHERE id_serie = 2;

```

**O que foi alterado?**

> Refinou a classificação de gênero da série de ID 2 de 'Drama / Pós-Apocalíptico' para 'Drama / Ficção Científica'.

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

DELETE FROM item_watchlist
WHERE id_usuario = 6 AND id_serie = 8;

```

**Registro removido:**

> Removeu o vínculo entre o usuário 6 e a série 8 da tabela associativa item_watchlist, simulando o usuário retirando a produção de sua lista pessoal.

## DELETE 2

```sql
-- Cole aqui.

DELETE FROM serie
WHERE id_serie = 8;

```

**Registro removido:**

> Excluiu o registro da produção 'Serie Cancelada Teste' (ID 8) da tabela serie. Esta exclusão só foi viável e segura porque seu vínculo na tabela filha (item_watchlist) foi previamente removido no DELETE 1, preservando a integridade referencial.

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
| PLATAFORMA | 6 |
| USUARIO | 6 |
| SERIE | 7 |
| ITEM_WATCHLIST | 10 |
|  |  |

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos:

```text

31 registros inseridos no total entre as quatro tabelas.

```

## UPDATE

Quantidade de operações:

```text

3 operações executadas com sucesso.

```

## DELETE

Quantidade de operações:

```text

2 operações executadas com sucesso.

```

---

# 25. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Inserção de formato de data | Confusão inicial com o padrão de data DD/MM/AAAA | Ajustado para o padrão ISO obrigatório do MySQL: 'AAAA-MM-DD'. |
| Falha ao tentar excluir a série teste diretamente (Error Code: 1451) | Violação de integridade referencial: existia registro dependente na tabela filha item_watchlist. | Executou-se primeiro o DELETE na tabela filha item_watchlist para depois executar o DELETE na tabela pai serie. |
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
