# SPRINT 3/5 — Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

**Aluna:** Anna Beatriz Oliveira Moura
**Tema:** Locadora
**Banco de dados:** locacao_de_filmes

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
USE locacao_de_filmes;
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
INSERT INTO cliente (
    nome,
    cpf,
    telefone,
    email
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
| cliente | 6 | Não |
| funcionario | 5 | Não |
| genero | 6 | Não |
| filme | 6 | Sim, de genero |
| locacao | 5 | Sim, de cliente e funcionario |
| item_locacao | 6 | Sim, de locacao e filme |

---

# 8. INSERTs realizados

## Tabela 1

**Nome: cliente**

```text
Registros inseridos: 6
```

```sql
INSERT INTO cliente (
    nome,
    cpf,
    telefone,
    email
)
VALUES 
    ('Tatum Riley', '022.015.504-12', '(66) 99999-1111', 'tatum@email.com'),
    ('Stiles Stilinski', '078.780.868-77', '(66) 99999-2222', 'stiles@email.com'),
    ('Kirby Reed', '759.033.418-96', '(66) 99999-3333', 'kirby@email.com'),
    ('John Snow', '441.696.558-34', '(66) 99999-4444', 'john@email.com'),
    ('Beatrice Prior', '578.768.538-54', '(66) 99999-5555', 'beatrice@email.com'),
    ('Hannah Klinkers', '321.654.987-00', '(66) 99999-6262', 'hannah@email.com');
```

## Tabela 2

**Nome: funcionario**

```text
Registros inseridos: 5
```

```sql
INSERT INTO funcionario (
    nome,
    cpf,
    cargo,
    telefone
)
VALUES
    ('Randy Meeks', '560.816.798-88', 'Gerente', '(66) 98888-1111'),
    ('Steve Harrington', '662.069.598-13', 'Atendete', '(66) 98888-2222'),
    ('Robin Buckley', '287.234.808-58', 'Atendente', '(66) 98888-3333'),
    ('Noah Foster', '402.531.878-42', 'Atendente', '(66) 98888-4444'),
    ('Karen Kolchak', '091.750.158-62', 'Gerente', '(66) 98888-5555');
```

## Tabela 3

**Nome: genero**

```text
Registros inseridos: 6
```

```sql
INSERT INTO genero (
    nome,
    descricao,
    classificado
)
VALUES
    ('Ação', 'Filmes com ritmo acelerado, lutas, perseguições e conflitos físicos', '12 anos'),
    ('Comédia', 'Filmes feitos para divertir e provocar o riso no público', 'Livre'),
    ('Drama', 'Filmes com narrativas sérias que exploram conflitos emocionais e dilemas humanos profundos', '12 anos'),
    ('Terror', 'Filmes criados para gerar medo, tensão e sustos nos espectadores', '16 anos'),
    ('Ficção Científica', 'Filmes com tramas baseadas em avanços tecnológicos, espaço ou futuros alternativos', '12 anos'),
    ('Romance', 'Filmes com histórias centradas em paixões, relacionamentos e laços afetivos', '14 anos');
```

## Tabela 4

**Nome: filme**

```text
Registros inseridos: 6
```

```sql
INSERT INTO filme (
    titulo,
    ano_lancamento,
    avaliacao,
    diretor,
    id_genero
)
VALUES
    ('A Chance', 1983, 6.0, 'Michael Chapman', 3),
	('Orgulho e Preconceito', 2005, 7.8, 'Joe Wright', 6),
	('Star Wars: Episódio V - O Império Contra-Ataca', 1980, 8.7, 'Irvin Kershner', 5),
    ('Psicose', 1960, 8.5, 'Alfred Hitchcock', 4),
    ('Transformers', 2007, 7.1, 'Michael Bay', 1),
    ('Perdido pra Cachorro', 2008, 4.0, 'Raja Gosnell', 2);
```

## Tabela 5

**Nome: locacao**

```text
Registros inseridos: 5
```

```sql
INSERT INTO locacao (
    id_cliente,
    id_funcionario,
    data_locacao,
    data_devolucao
)
VALUES
    (1, 3, '2026-09-01', '2026-09-04'),
    (2, 2, '2026-09-02', '2026-09-05'),
    (3, 1, '2026-09-03', '2026-09-06'),
    (4, 3, '2026-09-04', '2026-09-07'),
    (5, 4, '2026-09-05', '2026-09-08');
```

## Tabela 6

**Nome: item_locacao**

```text
Registros inseridos: 6
```

```sql
INSERT INTO item_locacao (
    id_locacao,
    id_filme,
    valor_diaria
)
VALUES
    (1, 1, 8.00),
    (1, 2, 8.00),
    (2, 3, 10.00),
    (3, 4, 9.00),
    (4, 5, 8.00),
    (5, 6, 7.00);
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
| UNIQUE | Inserção de CPF duplicado na tabela cliente. | Registro rejeitado pelo banco. |
| NOT NULL | Inserção de gênero com o campo nome nulo. | Registro rejeitado pelo banco. |
| FOREIGN KEY | Inserção de locação utilizando um cliente inexistente. | Operação impedida pela integridade referencial. |

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
SELECT *
FROM funcionario
WHERE id_funcionario = 2;

UPDATE funcionario
SET cargo = 'Atendente'
WHERE id_funcionario = 2;

SELECT *
FROM funcionario
WHERE id_funcionario = 2;
```

**O que foi alterado?**

> Foi realizada a correção do cargo do funcionário Steve Harrington, alterando o valor anteriormente cadastrado de Atendete para Atendente. A condição WHERE permitiu identificar o funcionário específico, evitando alterações nos demais registros.

## UPDATE 2

```sql
SELECT *
FROM filme
WHERE id_filme = 5;

UPDATE filme
SET avaliacao = 7.5
WHERE id_filme = 5;

SELECT *
FROM filme
WHERE id_filme = 5;
```

**O que foi alterado?**

> Foi atualizada a avaliação do filme Transformers, modificando seu valor de 7.1 para 7.5. A alteração foi realizada exclusivamente no registro identificado pelo id_filme = 5.

## UPDATE 3

```sql
SELECT *
FROM cliente
WHERE id_cliente = 2;

UPDATE cliente
SET telefone = '(66) 99999-7777'
WHERE id_cliente = 2;

SELECT *
FROM cliente
WHERE id_cliente = 2;
```

**O que foi alterado?**

> Foi atualizado o telefone do cliente Stiles Stilinski, identificado pelo id_cliente = 2. A operação demonstrou a possibilidade de modificar informações cadastrais sem excluir ou inserir novamente o registro.

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
SELECT *
FROM locacao
WHERE id_cliente = 6;

DELETE FROM cliente
WHERE id_cliente = 6;

SELECT *
FROM cliente
WHERE id_cliente = 6;
```

**Registro removido:**

> Foi excluído o cadastro do sexto cliente, que havia sido inserido sem possuir nenhuma locação vinculada. Antes da exclusão, foi realizada uma consulta para verificar a inexistência de registros relacionados na tabela locacao. Dessa forma, a operação foi executada sem comprometer a integridade referencial do banco.

## DELETE 2

```sql
SELECT *
FROM item_locacao
WHERE id_locacao = 1
AND id_filme = 2;

DELETE FROM item_locacao
WHERE id_locacao = 1
AND id_filme = 2;

SELECT *
FROM item_locacao
WHERE id_locacao = 1;
```

**Registro removido:**

> Foi excluído o registro da tabela item_locacao que associava o filme Orgulho e Preconceito à locação nº 1. A operação removeu somente o vínculo entre a locação e o filme, preservando o cadastro original do filme na tabela filme e mantendo o outro item da mesma locação.

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
USE locacao_de_filmes;

-- INSERTS

INSERT INTO cliente (
    nome,
    cpf,
    telefone,
    email
)
VALUES 
    ('Tatum Riley', '022.015.504-12', '(66) 99999-1111', 'tatum@email.com'),
    ('Stiles Stilinski', '078.780.868-77', '(66) 99999-2222', 'stiles@email.com'),
    ('Kirby Reed', '759.033.418-96', '(66) 99999-3333', 'kirby@email.com'),
    ('John Snow', '441.696.558-34', '(66) 99999-4444', 'john@email.com'),
    ('Beatrice Prior', '578.768.538-54', '(66) 99999-5555', 'beatrice@email.com'),
    ('Hannah Klinkers', '321.654.987-00', '(66) 99999-6262', 'hannah@email.com');


INSERT INTO funcionario (
    nome,
    cpf,
    cargo,
    telefone
)
VALUES
    ('Randy Meeks', '560.816.798-88', 'Gerente', '(66) 98888-1111'),
    ('Steve Harrington', '662.069.598-13', 'Atendete', '(66) 98888-2222'),
    ('Robin Buckley', '287.234.808-58', 'Atendente', '(66) 98888-3333'),
    ('Noah Foster', '402.531.878-42', 'Atendente', '(66) 98888-4444'),
    ('Karen Kolchak', '091.750.158-62', 'Gerente', '(66) 98888-5555');


INSERT INTO genero (
    nome,
    descricao,
    classificado
)
VALUES
    ('Ação', 'Filmes com ritmo acelerado, lutas, perseguições e conflitos físicos', '12 anos'),
    ('Comédia', 'Filmes feitos para divertir e provocar o riso no público', 'Livre'),
    ('Drama', 'Filmes com narrativas sérias que exploram conflitos emocionais e dilemas humanos profundos', '12 anos'),
    ('Terror', 'Filmes criados para gerar medo, tensão e sustos nos espectadores', '16 anos'),
    ('Ficção Científica', 'Filmes com tramas baseadas em avanços tecnológicos, espaço ou futuros alternativos', '12 anos'),
    ('Romance', 'Filmes com histórias centradas em paixões, relacionamentos e laços afetivos', '14 anos');

    
INSERT INTO filme (
    titulo,
    ano_lancamento,
    avaliacao,
    diretor,
    id_genero
)
VALUES
    ('A Chance', 1983, 6.0, 'Michael Chapman', 3),
	('Orgulho e Preconceito', 2005, 7.8, 'Joe Wright', 6),
	('Star Wars: Episódio V - O Império Contra-Ataca', 1980, 8.7, 'Irvin Kershner', 5),
    ('Psicose', 1960, 8.5, 'Alfred Hitchcock', 4),
    ('Transformers', 2007, 7.1, 'Michael Bay', 1),
    ('Perdido pra Cachorro', 2008, 4.0, 'Raja Gosnell', 2);


INSERT INTO locacao (
    id_cliente,
    id_funcionario,
    data_locacao,
    data_devolucao
)
VALUES
    (1, 3, '2026-09-01', '2026-09-04'),
    (2, 2, '2026-09-02', '2026-09-05'),
    (3, 1, '2026-09-03', '2026-09-06'),
    (4, 3, '2026-09-04', '2026-09-07'),
    (5, 4, '2026-09-05', '2026-09-08');


INSERT INTO item_locacao (
    id_locacao,
    id_filme,
    valor_diaria
)
VALUES
    (1, 1, 8.00),
    (1, 2, 8.00),
    (2, 3, 10.00),
    (3, 4, 9.00),
    (4, 5, 8.00),
    (5, 6, 7.00);

-- VERIFICAÇÕES

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM genero;
SELECT * FROM filme;
SELECT * FROM locacao;
SELECT * FROM item_locacao;

-- UPDATES

UPDATE funcionario
SET cargo = 'Atendente'
WHERE id_funcionario = 2;

UPDATE filme
SET avaliacao = 7.5
WHERE id_filme = 5;

UPDATE cliente
SET telefone = '(66) 99999-7777'
WHERE id_cliente = 2;

-- DELETES

DELETE FROM cliente
WHERE id_cliente = 6;

DELETE FROM item_locacao
WHERE id_locacao = 1
AND id_filme = 2;
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
| cliente | 5 |
| funcionario | 5 |
| genero | 6 |
| filme | 6 |
| locacao | 5 |
| item_locacao | 5 |
| TOTAL | 32 |

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos:

```text
Quantidade aproximada de registros inseridos: 34 registros, distribuídos entre as seis tabelas do banco de dados.
```

## UPDATE

Quantidade de operações:

```text
Quantidade de operações: 3 operações de atualização.
```

## DELETE

Quantidade de operações:

```text
Quantidade de operações: 2 operações de exclusão.
```
> Após as operações, o banco permaneceu com 32 registros, considerando os dados inseridos nesta Sprint.

---

# 25. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Dificuldade em selecionar um cliente para a operação DELETE. | Os cinco clientes inicialmente cadastrados possuíam locações vinculadas por chave estrangeira. | Foi acrescentado um sexto cliente sem locações para possibilitar uma exclusão segura. |
| Necessidade de excluir um registro sem comprometer o catálogo de filmes. | A exclusão direta de um filme poderia interferir em registros relacionados. | Foi removido apenas um registro da tabela associativa item_locacao. |
| Erros durante a execução final. | -- | Não foram identificados erros na execução dos comandos finais no MySQL Workbench. |

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
