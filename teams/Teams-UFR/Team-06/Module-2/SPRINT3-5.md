# SPRINT 3/5 — Views e Abstração de Consultas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# Objetivo da Sprint 3/5

Nesta etapa, cada aluno deverá criar **Views** para representar consultas relevantes e reutilizáveis do seu banco.

Serão trabalhados:

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT
DROP VIEW
SHOW FULL TABLES
```

O aluno deverá compreender que uma `VIEW` representa uma consulta armazenada que pode ser utilizada como uma tabela virtual.

---

# 1. Identificação

**Nome completo:**

> Anna Beatriz Oliveira Moura

**Banco utilizado:**

```text
Locação de Filmes (locacao_de_filmes)
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Filmes e seus gêneros | Facilita a consulta ao catálogo sem precisar escrever o JOIN toda vez. | Sim — vw_filmes_generos |
| Quantidade de locações por funcionário | Permite acompanhar quantas locações foram registradas por cada funcionário. | Sim — vw_resumo_locacoes_funcionario |
| Detalhes das locações | Reúne cliente, filme, funcionário e datas em uma consulta operacional. | Sim — vw_detalhes_locacoes |
| Filmes acima da avaliação média | Reutiliza a subconsulta da Sprint 2 para identificar filmes com avaliação superior à média geral. | Sim — vw_filmes_acima_media |

---

# 3. Criando uma VIEW

Estrutura geral:

```sql
CREATE VIEW nome_view AS
SELECT ...
FROM ...
WHERE ...;
```

Exemplo:

```sql
CREATE VIEW vw_clientes_pedidos AS
SELECT
    c.id_cliente,
    c.nome,
    p.id_pedido,
    p.data_pedido
FROM cliente AS c
INNER JOIN pedido AS p
    ON c.id_cliente = p.id_cliente;
```

---

# 4. VIEW 1 — relacionamento entre tabelas

**Nome da VIEW:**

```text
vw_filmes_generos
```

**Pergunta que ela representa:**

> Quais filmes estão cadastrados e a qual gênero cada um pertence?

**SQL:**

```sql
CREATE VIEW vw_filmes_generos AS
SELECT
    f.id_filme,
    f.titulo,
    g.nome AS genero
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;
```

**Tabelas utilizadas:**

> filme e genero.

**Como consultar essa VIEW?**

```sql
SELECT *
FROM vw_filmes_generos;
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Quantas locações cada funcionário registrou, incluindo aqueles que não registraram nenhuma?

```sql
CREATE VIEW vw_resumo_locacoes_funcionario AS
SELECT
    f.id_funcionario,
    f.nome AS funcionario,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM funcionario AS f
LEFT JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
GROUP BY
    f.id_funcionario,
    f.nome;
```

**Explique:**

> A View utiliza LEFT JOIN para manter todos os funcionários cadastrados, COUNT() para contar as locações e GROUP BY para agrupar os resultados por funcionário. Dessa forma, também permite identificar funcionários sem locações registradas, que devem apresentar quantidade igual a zero.

---

# 6. VIEW 3 — consulta operacional do sistema

Crie uma VIEW que represente uma informação útil para um usuário real.

Exemplos:

```text
estoque baixo
empréstimos em aberto
pedidos pendentes
alunos matriculados
consultas futuras
reservas ativas
pagamentos pendentes
```

**Nome da VIEW:**

```text
vw_detalhes_locacoes
```

```sql
CREATE VIEW vw_detalhes_locacoes AS
SELECT
    l.id_locacao,
    c.id_cliente,
    c.nome AS cliente,
    fun.id_funcionario,
    fun.nome AS funcionario,
    i.id_item,
    fi.id_filme,
    fi.titulo AS filme,
    l.data_locacao,
    l.data_devolucao,
    i.valor_diaria
FROM locacao AS l
INNER JOIN cliente AS c
    ON l.id_cliente = c.id_cliente
INNER JOIN funcionario AS fun
    ON l.id_funcionario = fun.id_funcionario
INNER JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
INNER JOIN filme AS fi
    ON i.id_filme = fi.id_filme;
```

**Por que essa VIEW é útil?**

> Essa View reúne informações sobre as locações, apresentando o cliente, o funcionário responsável, o filme, a data da locação, a data de devolução e o valor da diária. Ela facilita a consulta ao histórico de locações e permite visualizar informações que estão distribuídas entre diferentes tabelas do banco.

---

# 7. Consultando uma VIEW

Execute:

```sql
SELECT *
FROM nome_view;
```

Depois faça um filtro:

```sql
SELECT *
FROM nome_view
WHERE ...;
```

**SQL executado:**

```sql
SELECT *
FROM vw_filmes_generos
WHERE id_filme = 1;
```

**Resultado observado:**

> O resultado mostra o filme registrado em ID 1, e as informações presentes são: id_filme (1), titulo (A Chance), e diretor (Michael Chapman). Pois, ao aplicar WHERE foi possível filtrar e mostrar somente o filme registrado em ID 1.

---

# 8. CREATE OR REPLACE VIEW

Escolha uma VIEW e faça uma alteração coerente.

Pode ser:

- adicionar coluna;
- alterar filtro;
- incluir um `JOIN`;
- adicionar cálculo;
- alterar uma agregação.

**VIEW original:**

```sql
CREATE VIEW vw_filmes_generos AS
SELECT
    f.id_filme,
    f.titulo,
    g.nome AS genero
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_filmes_generos AS
SELECT
    f.id_filme,
    f.titulo,
    f.ano_lancamento,
    f.avaliacao,
    f.diretor,
    g.nome AS genero,
    g.classificado AS classificacao
FROM filme AS f
INNER JOIN genero AS g
    ON f.id_genero = g.id_genero;
```

**O que mudou?**

> A View foi redefinida para apresentar mais informações do catálogo, incluindo ano de lançamento, avaliação, diretor e classificação do gênero. O nome da View foi mantido, mas sua consulta passou a retornar mais colunas. O comando CREATE OR REPLACE VIEW permite substituir uma definição existente sem precisar executar um DROP VIEW separado.

---

# 9. DROP VIEW — exercício controlado

Crie uma VIEW temporária:

```sql
CREATE VIEW vw_teste AS
SELECT ...;
```

Depois remova:

```sql
DROP VIEW vw_teste;
```

**Código utilizado:**

```sql
CREATE VIEW vw_teste AS
SELECT id_filme, titulo
FROM filme;

SELECT *
FROM vw_teste;

DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> DROP VIEW remove uma consulta armazenada como View, sem apagar os registros das tabelas-base. Já DROP TABLE remove a estrutura de uma tabela e seus dados, podendo afetar outros objetos que dependem dela.

---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_filmes_generos
2. vw_resumo_locacoes_funcionario
3. vw_detalhes_locacoes
4. vw_filmes_acima_media

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_filmes_generos
```

**Alteração realizada:**

```sql
UPDATE filme
SET diretor = 'DIRETOR TEMPORARIO PARA TESTE'
WHERE id_filme = 1;
```

**Resultado observado:**

> A consulta à View durante a transação apresentou o valor temporariamente alterado, demonstrando que a View utiliza os dados da tabela-base. Após a execução de ROLLBACK, o valor original foi restaurado.

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
vw_filmes_generos
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> A View depende das tabelas filme e genero. O relacionamento utiliza a chave estrangeira filme.id_genero e a chave primária genero.id_genero. A consulta apresenta informações dos filmes e seus gêneros. Ela resolve o problema de precisar escrever repetidamente o mesmo JOIN para consultar o catálogo. Se os dados das tabelas originais forem alterados, a consulta à View refletirá essas mudanças, respeitando os relacionamentos e filtros definidos na sua consulta.

---

# 13. Quantidade mínima exigida

O projeto deverá possuir no mínimo:

```text
3 VIEWs úteis
1 VIEW com relacionamento
1 VIEW com agregação ou resumo
1 CREATE OR REPLACE VIEW
1 teste com DROP VIEW
```

---

# 14. Estrutura recomendada do SPRINT3-5.sql

```sql
-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- VIEW 1

-- VIEW 2

-- VIEW 3

-- CONSULTAS SOBRE AS VIEWS

-- CREATE OR REPLACE VIEW

-- VIEW TEMPORÁRIA

-- DROP VIEW

-- VALIDAÇÃO
```

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Nenhum problema de execução identificado | -- | -- |
|  |  |  |
|  |  |  |

---

# 16. Uso de LLMs

O uso de LLMs pode ocorrer como apoio, mas o aluno deverá compreender e validar todo o código.

Fluxo obrigatório:

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

---

# 17. Checklist

- [ ] utilizei o banco do projeto;
- [ ] criei pelo menos 3 Views;
- [ ] pelo menos uma View usa JOIN;
- [ ] pelo menos uma View usa agregação ou resumo;
- [ ] consultei as Views;
- [ ] utilizei `CREATE OR REPLACE VIEW`;
- [ ] pratiquei `DROP VIEW`;
- [ ] validei as Views;
- [ ] testei mudança em tabela base;
- [ ] compreendo de onde vêm os dados de cada View;
- [ ] salvei `SPRINT3-5.md`;
- [ ] salvei `SPRINT3-5.sql`.

---

# 18. Git/GitHub

Continue utilizando:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT3-5.md
Module-2/SPRINT3-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 3 de 5 - views
```

**Ainda não abra o Pull Request final.**

---

# Próxima etapa

Na Sprint 4/5 serão trabalhados:

```sql
CREATE PROCEDURE
CALL
IN
OUT
CREATE FUNCTION
RETURN
IF
ELSE
```
