# SPRINT 2/5 — Subconsultas e Consultas Avançadas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# Objetivo da Sprint 2/5

Nesta etapa, cada aluno deverá aprofundar as consultas SQL por meio de **subconsultas**.

O objetivo é resolver perguntas em que uma consulta depende do resultado produzido por outra consulta.

Serão trabalhados:

```sql
SUBQUERY
IN
NOT IN
EXISTS
NOT EXISTS
AVG
MAX
MIN
COUNT
subconsulta correlacionada
```

O aluno deverá continuar utilizando o mesmo banco do `Module-1`.

---

# 1. Identificação

**Nome completo:**

> Walter Anacleto Salido de Souza

**Banco utilizado:**

```
db_raaei
```

---

# 2. O que é uma subconsulta?

Uma subconsulta é um `SELECT` utilizado dentro de outro comando SQL.

Exemplo:

```sql
SELECT nome, preco
FROM produto
WHERE preco > (
    SELECT AVG(preco)
    FROM produto
);
```

Neste exemplo:

1. a consulta interna calcula a média;
2. a consulta externa utiliza esse resultado.

---

# 3. Perguntas que exigem subconsulta

Defina pelo menos cinco perguntas do seu domínio que possam ser resolvidas com subconsultas.

1. Quais são os atletas cuja idade (calculada ou cadastrada) está acima da média de idade de todos os atletas matriculados na associação?

2. Quais escolas parceiras possuem um número total de atletas superior à média de atletas cadastrados por escola em toda a base de dados?

3. Quais categorias esportivas possuem pelo menos um atleta cadastrado (utilizando o operador EXISTS para correlacionar com a tabela de atletas)?

4. Quais escolas parceiras ainda não possuem nenhum atleta matriculado e vinculado em suas dependências (utilizando NOT IN ou NOT EXISTS)?

5. Quais atletas pertencem à mesma categoria que o atleta mais jovem cadastrado na base de dados da associação?

---

# 4. Subconsulta com comparação

Crie uma consulta utilizando uma comparação com resultado agregado.

**Pergunta:**

> Quais escolas parceiras possuem um número total de atletas matriculados superior à média geral de atletas por escola em toda a associação?

```
SELECT 
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
INNER JOIN atleta AS a 
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
HAVING COUNT(a.id_atleta) > (
    SELECT AVG(atletas_por_escola.total)
    FROM (
        SELECT COUNT(at.id_atleta) AS total
        FROM escola AS esc
        LEFT JOIN atleta AS at 
            ON esc.id_escola = at.id_escola
        GROUP BY esc.id_escola
    ) AS atletas_por_escola
);
```

**Explique primeiro a consulta interna:**

> A subconsulta mais interna (atletas_por_escola) agrupa todos os atletas por escola e calcula a contagem (COUNT) de praticantes vinculados a cada instituição. Em seguida, a função AVG aplicada sobre esse conjunto computa o valor médio geral de atletas por escola na associação, retornando um único valor escalar de referência.

**Depois explique a consulta externa:**

> A consulta externa realiza a junção entre as tabelas escola e atleta, agrupa os resultados por instituição e aplica a cláusula HAVING. Ela compara o total de atletas de cada escola individualmente com o valor médio retornado pela subconsulta, exibindo apenas as instituições cuja representatividade de praticantes está acima da média geral da associação.

---

# 5. Subconsulta com IN

Exemplo:

```sql
SELECT nome
FROM cliente
WHERE id_cliente IN (
    SELECT id_cliente
    FROM pedido
);
```

## Consulta obrigatória

**Pergunta:**

> Quais são os nomes e os tipos de rede das escolas parceiras que possuem pelo menos um atleta cadastrado e ativo nas categorias da associação?

```
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);
```

**Explique:**

> A subconsulta (interna) seleciona todos os identificadores de escola (id_escola) que aparecem associados a registros na tabela atleta, utilizando DISTINCT para eliminar duplicidades. A consulta externa utiliza o operador IN para verificar quais escolas da tabela escola possuem seu identificador presente no conjunto retornado pela subconsulta, listando assim apenas as instituições ativas que colaboram com a formação de atletas na RAAEI.

---

# 6. Subconsulta com NOT IN

**Pergunta:**

> Quais são as escolas parceiras cadastradas no sistema que ainda não possuem nenhum atleta vinculado ou matriculado nas atividades da associação?

```
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola NOT IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);
```

**Que registros você está procurando?**

> Estamos procurando por escolas cadastradas na base de dados (escola) cujos identificadores (id_escola) não estejam presentes no conjunto de chaves estrangeiras referenciadas na tabela de atletas (atleta). Esse filtro por exclusão (NOT IN) permite à diretoria identificar instituições parceiras inativas ou que necessitam de ações urgentes de captação e divulgação para iniciar o envio de novos praticantes para os projetos da RAAEI.

---

# 7. EXISTS

`EXISTS` verifica se a subconsulta retorna pelo menos um registro.

## Consulta obrigatória

**Pergunta:**

> Quais são as categorias esportivas cadastradas que possuem, no momento, pelo menos um atleta vinculado participando dos treinamentos da associação?

```
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);
```

---

# 8. NOT EXISTS

**Pergunta:**

> Quais são as categorias esportivas cadastradas que não possuem nenhum atleta vinculado atualmente, permitindo à diretoria técnica identificar modalidades ociosas ou que exigem novas turmas de captação?

```
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);
```

**Explique a diferença em relação a `EXISTS`:**

> Enquanto o operador EXISTS avalia como verdadeiro e retorna os registros da consulta externa quando a subconsulta correlacionada encontra pelo menos uma correspondência, o NOT EXISTS faz exatamente o oposto: ele filtra e retorna apenas os registros da tabela externa para os quais a subconsulta não encontra nenhuma linha correspondente. Em termos lógicos, o EXISTS busca categorias com atletas, enquanto o NOT EXISTS isola as categorias vazias ou sem praticantes ativos.

---

# 9. Subconsulta com MAX ou MIN

**Pergunta:**

> Quais são os dados completos dos atletas (nome, gênero e data de nascimento) que correspondem ao atleta mais jovem cadastrado na base de dados da associação?

```
SELECT 
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
WHERE a.data_nascimento = (
    SELECT MAX(data_nascimento)
    FROM atleta
);
```

**Explique:**

> A subconsulta interna utiliza a função de agregação MAX(data_nascimento) para encontrar a data mais recente registrada na tabela de atletas, que corresponde matematicamente ao praticante com menor idade (o atleta mais jovem). A consulta externa então filtra todos os registros da tabela atleta (cruzando com a escola correspondente) para retornar apenas o atleta (ou atletas, em caso de empate na mesma data) cuja data de nascimento coincida exatamente com esse valor máximo obtido.

---

# 10. Subconsulta correlacionada

Uma subconsulta correlacionada depende de valores da consulta externa.

## Consulta obrigatória

**Pergunta:**

> Quais atletas possuem uma data de nascimento anterior à data de nascimento média de todos os demais atletas cadastrados na mesma escola em que estudam?

```
SELECT 
    a1.nome_atleta,
    a1.data_nascimento,
    e.nome_escola
FROM atleta AS a1
INNER JOIN escola AS e 
    ON a1.id_escola = e.id_escola
WHERE a1.data_nascimento < (
    SELECT AVG(a2.data_nascimento)
    FROM atleta AS a2
    WHERE a2.id_escola = a1.id_escola
);
```

**Qual coluna da consulta externa é utilizada pela subconsulta?**

> A coluna da consulta externa utilizada pela subconsulta é a1.id_escola. Essa referência cria a correlação linha a linha: para cada atleta avaliado na consulta principal (a1), a subconsulta executa o cálculo da média de nascimento (AVG) filtrando especificamente apenas os atletas pertencentes à mesma instituição (a2.id_escola = a1.id_escola).

---

# 11. Resolver a mesma pergunta de duas formas

Escolha duas perguntas e resolva cada uma utilizando:

```text
a) JOIN
b) SUBQUERY
```

## Pergunta 1

> Quais são as escolas parceiras que possuem atletas matriculados e ativos nos projetos da associação?

### JOIN

```
SELECT DISTINCT
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
INNER JOIN atleta AS a
    ON e.id_escola = a.id_escola;
```

### SUBQUERY

```
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);
```

### Qual abordagem ficou mais compreensível?

> A abordagem com JOIN mostrou-se mais intuitiva e compreensível para esta pergunta específica. Como o objetivo principal é relacionar duas entidades estruturais (escola e atleta), o JOIN conecta os dados de forma natural e direta. A utilização do DISTINCT evita duplicidades caso a escola possua múltiplos atletas, mantendo o código limpo e com excelente performance no SGBD.

---

## Pergunta 2

> Quais categorias esportivas cadastradas possuem pelo menos um atleta vinculado participando dos treinamentos?

### JOIN

```
SELECT DISTINCT
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
INNER JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;
```

### SUBQUERY

```
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);
```

### Comparação

> Ambas as abordagens resolvem perfeitamente a questão analítica, mas atendem a lógicas distintas. O JOIN com DISTINCT funciona muito bem pelo cruzamento relacional, porém a abordagem com SUBQUERY usando EXISTS revelou-se conceitualmente mais elegante para verificar a existência de registros dependentes. O EXISTS é altamente otimizado para checagem booleana, pois interrompe a busca na subconsulta assim que encontra a primeira correspondência para cada categoria, evitando processamentos desnecessários de linhas duplicadas.

---

# 12. Quantidade mínima exigida

O `SPRINT2-5.sql` deverá conter no mínimo:

```text
1 subconsulta com comparação
1 subconsulta com IN
1 subconsulta com NOT IN
1 consulta com EXISTS
1 consulta com NOT EXISTS
1 subconsulta com MAX ou MIN
1 subconsulta correlacionada
2 problemas resolvidos com JOIN e SUBQUERY
```

---

# 13. Validação prática

Escolha uma subconsulta.

```
SELECT 
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
WHERE a.data_nascimento = (
    SELECT MAX(data_nascimento)
    FROM atleta
);
```

Responda:

1. Qual consulta é executada primeiro?
2. Qual valor ou conjunto de valores ela retorna?
3. Como esse resultado é utilizado pela consulta externa?

> Execução inicial: A subconsulta interna (SELECT MAX(data_nascimento) FROM atleta) é executada primeiro pelo SGBD.
> Retorno obtido: Ela processa a tabela inteira de atletas e retorna um único valor escalar correspondente à data mais recente cadastrada no sistema (ou seja, a data de nascimento do atleta mais jovem).
>Utilização pelo comando externo: A consulta externa utiliza esse valor escalar como parâmetro de igualdade na cláusula WHERE (a.data_nascimento = <valor_retornado>). O SGBD filtra e exibe apenas os registros da tabela atleta (juntamente com as informações da tabela escola) cuja data de nascimento coincida exatamente com o limite máximo calculado, garantindo a identificação precisa do praticante mais novo da associação.

---

# 14. Teste operacional no Workbench

Execute uma consulta e altere temporariamente um valor de filtro.

**Consulta original:**

```
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);
```

**Alteração realizada:**

> Adição de um filtro restritivo de gênero (AND a.genero = 'F') na cláusula WHERE da subconsulta correlacionada, passando a verificar apenas a existência de atletas do gênero feminino vinculadas a cada categoria.

**Mudança observada:**

> O conjunto de resultados obtido foi reduzido dinamicamente. O SGBD passou a listar apenas as categorias esportivas que possuem, comprovadamente, pelo menos uma atleta do gênero feminino ativa, ocultando as modalidades que contam exclusivamente com praticantes do gênero masculino. Esse teste operacional demonstra a flexibilidade e o poder de refinamento analítico proporcionado pelas subconsultas correlacionadas no MySQL Workbench.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|

| Erro Subquery returns more than 1 row ao utilizar operadores de comparação direta (=, >, <). | Utilização de um operador relacional simples com uma subconsulta que retorna múltiplos registros, em vez de um único valor escalar. | Ajustar a consulta utilizando operadores de conjunto (IN, ANY, ALL) ou aplicar funções de agregação (MAX, MIN, AVG) na subconsulta.

| Retorno vazio ou incorreto ao utilizar o operador NOT IN. | Presença de valores NULL no conjunto retornado pela subconsulta, o que anula a lógica de exclusão no SQL. | Adicionar um filtro explícito WHERE coluna IS NOT NULL na subconsulta ou substituir a estrutura por NOT EXISTS.

| Lentidão ou alto custo de processamento em subconsultas correlacionadas com grandes volumes de dados. | Execução linha a linha da subconsulta interna para cada registro avaliado pela consulta externa (complexidade de varredura). | Criar índices nas chaves estrangeiras envolvidas ou reescrever a lógica utilizando junções (JOIN) e agregações padrão quando aplicável.

---

# 16. Estrutura recomendada do SPRINT2-5.sql

```
-- MODULE 2 — SPRINT 2/5
-- SUBCONSULTAS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

-- =====================================================================
-- 1. SUBQUERY COM COMPARAÇÃO: Escolas com atletas acima da média geral
-- =====================================================================
SELECT 
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
INNER JOIN atleta AS a 
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
HAVING COUNT(a.id_atleta) > (
    SELECT AVG(atletas_por_escola.total)
    FROM (
        SELECT COUNT(at.id_atleta) AS total
        FROM escola AS esc
        LEFT JOIN atleta AS at 
            ON esc.id_escola = at.id_escola
        GROUP BY esc.id_escola
    ) AS atletas_por_escola
);

-- =====================================================================
-- 2. IN: Escolas parceiras que possuem pelo menos um atleta ativo
-- =====================================================================
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

-- =====================================================================
-- 3. NOT IN: Escolas cadastradas que ainda não possuem atletas vinculados
-- =====================================================================
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola NOT IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

-- =====================================================================
-- 4. EXISTS: Categorias esportivas que possuem pelo menos um atleta ativo
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);

-- =====================================================================
-- 5. NOT EXISTS: Categorias esportivas ociosas ou sem praticantes
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);

-- =====================================================================
-- 6. MAX / MIN: Dados completos do atleta mais jovem da associação
-- =====================================================================
SELECT 
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
WHERE a.data_nascimento = (
    SELECT MAX(data_nascimento)
    FROM atleta
);

-- =====================================================================
-- 7. SUBQUERY CORRELACIONADA: Atletas mais novos que a média de sua escola
-- =====================================================================
SELECT 
    a1.nome_atleta,
    a1.data_nascimento,
    e.nome_escola
FROM atleta AS a1
INNER JOIN escola AS e 
    ON a1.id_escola = e.id_escola
WHERE a1.data_nascimento < (
    SELECT AVG(a2.data_nascimento)
    FROM atleta AS a2
    WHERE a2.id_escola = a1.id_escola
);

-- =====================================================================
-- 8. PROBLEMA 1 - JOIN: Escolas com atletas matriculados
-- =====================================================================
SELECT DISTINCT
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
INNER JOIN atleta AS a
    ON e.id_escola = a.id_escola;

-- =====================================================================
-- 9. PROBLEMA 1 - SUBQUERY: Escolas com atletas matriculados
-- =====================================================================
SELECT 
    e.nome_escola,
    e.tipo_rede
FROM escola AS e
WHERE e.id_escola IN (
    SELECT DISTINCT a.id_escola
    FROM atleta AS a
    WHERE a.id_escola IS NOT NULL
);

-- =====================================================================
-- 10. PROBLEMA 2 - JOIN: Categorias esportivas com atletas ativos
-- =====================================================================
SELECT DISTINCT
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
INNER JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;

-- =====================================================================
-- 11. PROBLEMA 2 - SUBQUERY: Categorias esportivas com atletas ativos
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria
FROM categoria AS c
WHERE EXISTS (
    SELECT 1
    FROM atleta AS a
    WHERE a.id_categoria = c.id_categoria
);
```

---

# 17. Checklist

- [ ] utilizei o banco do projeto;
- [ ] criei subconsulta com comparação;
- [ ] utilizei `IN`;
- [ ] utilizei `NOT IN`;
- [ ] utilizei `EXISTS`;
- [ ] utilizei `NOT EXISTS`;
- [ ] utilizei `MAX` ou `MIN`;
- [ ] criei subconsulta correlacionada;
- [ ] resolvi duas perguntas usando JOIN e SUBQUERY;
- [ ] expliquei o raciocínio;
- [ ] testei no MySQL Workbench;
- [ ] consigo explicar as consultas presencialmente;
- [ ] salvei `SPRINT2-5.md`;
- [ ] salvei `SPRINT2-5.sql`.

---

# 18. Git/GitHub

Continue na mesma branch:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT2-5.md
Module-2/SPRINT2-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 2 de 5 - subconsultas
```

**Não abra o Pull Request final.**

---

# Próxima etapa

Na Sprint 3/5 serão trabalhadas:

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT em VIEW
DROP VIEW
```
