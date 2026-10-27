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

> João Guilherme Barros de Lima

**Banco utilizado:**

```text
real_estate_database
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Agendamentos com cliente, imóvel e corretor responsável (JOIN de 4 tabelas, Sprint 1) | Reúne em uma única visão todo o contexto de cada visita, evitando repetir um JOIN longo | Sim (VIEW 1) |
| Resumo de imóveis por corretor: quantidade, valor total e valor médio (JOIN + GROUP BY, Sprint 1) | Permite acompanhar a carteira de cada corretor, inclusive de quem está sem imóvel | Sim (VIEW 2) |
| Agendamentos com status "Pendente" (Sprint 4 do Module-1, agora com JOIN) | Gera a fila de visitas que a equipe precisa confirmar, já com nome e telefone do cliente | Sim (VIEW 3) |
| Imóveis com valor acima da média (subconsulta, Sprint 2) | Destaca os imóveis de maior valor | Não, foi mantida como consulta avulsa, já que a mesma lógica de agregação está coberta pela VIEW 2 |

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
vw_agendamentos_detalhados
```

**Pergunta que ela representa:**

> Quais são todos os agendamentos de visita, com o nome do cliente, o imóvel visitado, a cidade, o corretor responsável, a data e o status?

**SQL:**

```sql
CREATE VIEW vw_agendamentos_detalhados AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    i.titulo AS imovel,
    i.cidade,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

**Tabelas utilizadas:**

> agendamento, cliente, imovel e corretor.

**Como consultar essa VIEW?**

```sql
SELECT *
FROM vw_agendamentos_detalhados;
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Quantos imóveis cada corretor possui, qual o valor total e qual o valor médio desses imóveis?

```sql
CREATE VIEW vw_resumo_imoveis_corretor AS
SELECT
    c.id_corretor,
    c.nome AS corretor,
    COUNT(i.id_imovel) AS total_imoveis,
    SUM(i.valor) AS valor_total,
    AVG(i.valor) AS valor_medio
FROM corretor AS c
LEFT JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.id_corretor, c.nome;
```

**Explique:**

> O LEFT JOIN liga cada corretor aos seus imóveis, mantendo também os corretores que não têm nenhum (caso do Theus, que ficou sem imóvel após o DELETE do Module-1). O GROUP BY forma um grupo por corretor, e as funções COUNT, SUM e AVG calculam, dentro de cada grupo, a quantidade, a soma e a média dos valores. Usei COUNT(i.id_imovel) em vez de COUNT(*) porque o COUNT(i.id_imovel) ignora valores NULL: assim o corretor sem imóvel aparece com total 0, e não com 1. Para ele, valor_total e valor_medio retornam NULL, pois não há valores para somar ou tirar a média.

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
vw_agendamentos_pendentes
```

```sql
CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    i.titulo AS imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';
```

**Por que essa VIEW é útil?**

> Porque entrega a lista de trabalho de quem cuida da agenda: todas as visitas que ainda precisam de confirmação, já com o nome e o telefone do cliente e o imóvel em questão. Quem usa a VIEW não precisa conhecer o JOIN nem lembrar do filtro de status, basta fazer um SELECT. E, como o filtro fica dentro da VIEW, quando uma visita é confirmada ou cancelada ela deixa de aparecer sozinha.

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
FROM vw_agendamentos_detalhados;

SELECT cliente, imovel, data_visita, status
FROM vw_agendamentos_detalhados
WHERE cidade = 'Rondonópolis';
```

**Resultado observado:**

> O primeiro SELECT retornou 5 linhas, uma para cada agendamento existente. O segundo, com o filtro por cidade, retornou 2 linhas: Carlos Santos (Apartamento Centro, 18/10/2026) e Lucas Almeida (Casa com piscina, 20/10/2026), ambos com status Pendente. O WHERE funciona sobre a VIEW como se ela fosse uma tabela comum, filtrando as colunas que ela expõe, como cidade.

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
CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    i.titulo AS imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    cl.email AS email_cliente,
    i.titulo AS imovel,
    i.valor AS valor_imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';
```

**O que mudou?**

> Foram adicionadas duas colunas à VIEW: o e-mail do cliente (email_cliente), como segunda forma de contato, e o valor do imóvel (valor_imovel), para a equipe saber qual visita tem mais peso comercial. O filtro e os JOINs continuam iguais. O CREATE OR REPLACE VIEW substituiu a definição antiga sem precisar de um DROP VIEW antes, o que o CREATE VIEW comum não permite, pois daria erro se a VIEW já existisse.

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
SELECT titulo, valor
FROM imovel
WHERE valor < 300000;

SELECT * FROM vw_teste;

DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> O DROP VIEW remove apenas a definição da consulta armazenada. Os dados continuam intactos nas tabelas base, porque a VIEW não guarda dado nenhum. Já o DROP TABLE apaga a estrutura da tabela e todos os dados dentro dela, de forma permanente. Depois de um DROP VIEW da vw_teste, a tabela imovel continua com todos os seus registros.

---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_agendamentos_detalhados
2. vw_resumo_imoveis_corretor
3. vw_agendamentos_pendentes

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_agendamentos_pendentes
```

**Alteração realizada:**

```sql
SELECT * FROM vw_agendamentos_pendentes;

UPDATE agendamento
SET status = 'Confirmado'
WHERE id_agendamento = 2;

SELECT * FROM vw_agendamentos_pendentes;

-- Reversão, para manter os dados originais do banco
UPDATE agendamento
SET status = 'Pendente'
WHERE id_agendamento = 2;
```

**Resultado observado:**

> Antes da alteração, a VIEW retornava 4 agendamentos pendentes (ids 2, 3, 4 e 6). Depois de mudar o status do agendamento 2 para "Confirmado" na tabela base, a segunda consulta retornou apenas 3 linhas: o agendamento 2 sumiu da VIEW. Isso mostra que a VIEW não guarda cópia dos dados: ela reexecuta a consulta a cada uso, então reflete na hora o estado atual das tabelas. Depois do teste, devolvi o status para "Pendente".

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
CREATE VIEW vw_resumo_imoveis_corretor AS
SELECT
    c.id_corretor,
    c.nome AS corretor,
    COUNT(i.id_imovel) AS total_imoveis,
    SUM(i.valor) AS valor_total,
    AVG(i.valor) AS valor_medio
FROM corretor AS c
LEFT JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.id_corretor, c.nome;
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> 1. Depende das tabelas corretor e imovel.
> 2. Usa o relacionamento 1:N entre corretor e imovel, por meio da FK imovel.id_corretor, que referencia corretor.id_corretor, em um LEFT JOIN.
> 3. Apresenta id_corretor, o nome do corretor, a quantidade de imóveis (total_imoveis), a soma dos valores (valor_total) e a média dos valores (valor_medio).
> 4. Resolve a necessidade de ver, em uma única consulta, o tamanho e o valor da carteira de cada corretor, sem repetir o JOIN com GROUP BY toda vez. Como usa LEFT JOIN, também mostra corretores sem nenhum imóvel.
> 5. Nada precisa ser atualizado na VIEW: ela não armazena dados, só a consulta. Se um imóvel for inserido, removido ou tiver o valor alterado, ou se um corretor for cadastrado, o resultado da VIEW muda automaticamente na próxima vez que for consultada.

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

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

-- VIEW 1
CREATE VIEW vw_agendamentos_detalhados AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    i.titulo AS imovel,
    i.cidade,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;

-- VIEW 2
CREATE VIEW vw_resumo_imoveis_corretor AS
SELECT
    c.id_corretor,
    c.nome AS corretor,
    COUNT(i.id_imovel) AS total_imoveis,
    SUM(i.valor) AS valor_total,
    AVG(i.valor) AS valor_medio
FROM corretor AS c
LEFT JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.id_corretor, c.nome;

-- VIEW 3
CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    i.titulo AS imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';

-- CONSULTAS SOBRE AS VIEWS
SELECT * FROM vw_agendamentos_detalhados;

SELECT cliente, imovel, data_visita, status
FROM vw_agendamentos_detalhados
WHERE cidade = 'Rondonópolis';

SELECT * FROM vw_resumo_imoveis_corretor;

SELECT * FROM vw_agendamentos_pendentes;

-- CREATE OR REPLACE VIEW
CREATE OR REPLACE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    cl.email AS email_cliente,
    i.titulo AS imovel,
    i.valor AS valor_imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';

SELECT * FROM vw_agendamentos_pendentes;

-- VIEW TEMPORÁRIA
CREATE VIEW vw_teste AS
SELECT titulo, valor
FROM imovel
WHERE valor < 300000;

SELECT * FROM vw_teste;

-- DROP VIEW
DROP VIEW vw_teste;

-- VALIDAÇÃO
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- TESTE DE ATUALIZAÇÃO DOS DADOS-BASE
SELECT * FROM vw_agendamentos_pendentes;

UPDATE agendamento
SET status = 'Confirmado'
WHERE id_agendamento = 2;

SELECT * FROM vw_agendamentos_pendentes;

UPDATE agendamento
SET status = 'Pendente'
WHERE id_agendamento = 2;
```

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro "Table 'vw_agendamentos_detalhados' already exists" ao executar o script uma segunda vez | O CREATE VIEW não sobrescreve uma VIEW que já existe, e ela já tinha sido criada na primeira execução | Usar `CREATE OR REPLACE VIEW`, ou `DROP VIEW IF EXISTS` antes do `CREATE VIEW` |
| Erro "Duplicate column name 'nome'" ao criar a VIEW 1 | As tabelas cliente e corretor têm uma coluna chamada nome, e uma VIEW não aceita duas colunas com o mesmo nome | Criar aliases diferentes: `cl.nome AS cliente` e `c.nome AS corretor` |
| Corretor sem imóvel aparecendo com total_imoveis = 1 na VIEW 2 | O `COUNT(*)` conta a linha gerada pelo LEFT JOIN mesmo quando os campos do imóvel são NULL | Trocar por `COUNT(i.id_imovel)`, que ignora NULL e retorna 0 |

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

- [x] utilizei o banco do projeto;
- [x] criei pelo menos 3 Views;
- [x] pelo menos uma View usa JOIN;
- [x] pelo menos uma View usa agregação ou resumo;
- [x] consultei as Views;
- [x] utilizei `CREATE OR REPLACE VIEW`;
- [x] pratiquei `DROP VIEW`;
- [x] validei as Views;
- [x] testei mudança em tabela base;
- [x] compreendo de onde vêm os dados de cada View;
- [x] salvei `SPRINT3-5.md`;
- [x] salvei `SPRINT3-5.sql`.

---

# 18. Git/GitHub

Continue utilizando:

```text
team-12
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
