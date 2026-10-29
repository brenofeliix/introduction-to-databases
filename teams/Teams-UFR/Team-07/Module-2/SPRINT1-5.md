# SPRINT 1/5 — JOINs e Consultas Relacionais

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT1-5.md` + `SPRINT1-5.sql`

---

# Objetivo da Sprint 1/5

Nesta primeira Sprint do **Module-2**, cada aluno deverá continuar utilizando o mesmo banco de dados desenvolvido no `Module-1`.

O foco agora será a consulta de dados relacionados entre duas ou mais tabelas por meio de:

```sql
INNER JOIN
LEFT JOIN
RIGHT JOIN
ON
AS
WHERE
ORDER BY
GROUP BY
COUNT
SUM
AVG
MIN
MAX
```

Ao final da Sprint, o aluno deverá ser capaz de identificar as tabelas necessárias, reconhecer PK e FK envolvidas, construir consultas com `JOIN`, interpretar os resultados e explicar presencialmente como cada consulta funciona.

> **Importante:** não crie um novo banco. Utilize o mesmo projeto desenvolvido no `Module-1`.

---

# 1. Estrutura do repositório

Os arquivos desta Sprint deverão ficar em:

```text
teams/Teams-UNEMAT/team-XX/Module-2/
```

Ao final:

```text
Module-2/
├── SPRINT1-5.md
└── SPRINT1-5.sql
```

Não altere nem apague os arquivos do `Module-1`.

---

# 2. Identificação

**Nome completo:**

> Walter Anacleto Salido de Souza

**Branch:**

```
team-07-UFR
```

**Nome do banco:**

```
db_raaei
```

**Tema do projeto:**

> Gestão e acompanhamento de atletas, categorias esportivas, escolas parceiras e equipe técnica da RAAEI (Rondonópolis Associação de Atletismo e Esporte Inclusivo).

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|

| 1	| escola | id_escola | Nenhuma

| 2	| categoria	| id_categoria | Nenhuma

| 3 | colaborador	| id_colaborador | Nenhuma

| 4	| atleta | id_atleta | id_escola, id_categoria

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|

| escola | 1 : N | atleta | id_escola (na tabela atleta)

| categoria | 1 : N | atleta | id_categoria (na tabela atleta)

---

# 5. INNER JOIN - 

O `INNER JOIN` retorna registros que possuem correspondência nas tabelas relacionadas.

Exemplo genérico:

```sql
SELECT
    a.campo,
    b.campo
FROM tabela_a AS a
INNER JOIN tabela_b AS b
    ON a.id = b.id_a;
```

## Consulta INNER JOIN 1

**Pergunta em linguagem natural:**

> Qual é a relação completa contendo o nome do atleta, sua data de nascimento, gênero e o respectivo nome da escola parceira de origem?

**Tabelas utilizadas:**

```
atleta, escola
```

**PK/FK utilizadas:**

```
PK: escola.id_escola
FK: atleta.id_escola
```

**SQL:**

```
SELECT
    a.nome_atleta,
    a.data_nascimento,
    a.genero,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
```

**Explique o resultado:**

> Esta consulta cruza os dados da tabela de atletas com a tabela de escolas por meio da chave estrangeira id_escola. O resultado exibe estritamente os atletas que possuem vínculo cadastrado com uma escola, unindo as informações cadastrais e institucionais em uma única listagem gerencial.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais atletas estão vinculados a cada categoria esportiva, exibindo o nome do atleta, sua categoria, faixa etária e o tipo de rede de ensino de sua escola de origem?

```
SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
```

**Explique:**

> Esta consulta demonstra um cruzamento triplo de tabelas (atleta, categoria e escola). Ela utiliza duas junções INNER JOIN consecutivas para conectar o atleta à sua categoria esportiva (id_categoria) e à sua escola de origem (id_escola), permitindo à comissão técnica visualizar simultaneamente a modalidade, a faixa etária competitiva e o perfil da rede de ensino de cada praticante.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Quais são todas as categorias esportivas cadastradas no sistema, exibindo também os atletas a elas vinculados, de forma a garantir que mesmo as categorias que ainda não possuem atletas cadastrados sejam listadas?

```
SELECT 
    c.nome_categoria,
    c.faixa_etaria,
    a.nome_atleta
FROM categoria AS c
LEFT JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Permite à comissão técnica e à diretoria visualizar a totalidade das categorias esportivas da associação. Diferente de um INNER JOIN (que ocultaria categorias vazias), o LEFT JOIN garante que categorias recém-criadas ou que ainda não possuem atletas inscritos apareçam na listagem com o campo de atleta indicando NULL, auxiliando no planejamento estratégico de captação e formação de equipes.

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Quais são todos os atletas cadastrados no sistema, exibindo também as respectivas escolas associadas, garantindo que mesmo atletas que porventura estejam sem escola vinculada na tabela à direita sejam listados?

```
SELECT 
    e.nome_escola,
    a.nome_atleta,
    a.genero
FROM escola AS e
RIGHT JOIN atleta AS a
    ON e.id_escola = a.id_escola;
```

**Explique o resultado:**

> O RIGHT JOIN prioriza todos os registros da tabela posicionada à direita da instrução (atleta). Neste cenário, a consulta garante que a listagem traga todos os atletas cadastrados na base de dados da RAAEI, exibindo a escola correspondente quando houver vínculo ou indicando ausência de registro institucional caso o campo esteja nulo, assegurando que nenhum atleta seja omitido do relatório geral.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Qual é o relatório gerencial detalhado contendo o nome do atleta, sua categoria esportiva, faixa etária, nome da escola parceira e o tipo de rede de ensino de origem?

```
SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.nome_escola,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
```

## Consulta 2

**Pergunta:**

> Qual é o quantitativo total de atletas distribuídos por escola parceira e categoria esportiva, exibindo o nome da escola, o nome da categoria e a contagem de praticantes?

```
SELECT
    e.nome_escola,
    c.nome_categoria,
    COUNT(a.id_atleta) AS total_atletas
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
GROUP BY e.nome_escola, c.nome_categoria
ORDER BY total_atletas DESC;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais são os atletas matriculados em escolas da rede pública estadual que pertencem à categoria de base, exibindo o nome do atleta, a escola e a categoria correspondente?

```
SELECT
    a.nome_atleta,
    e.nome_escola,
    c.nome_categoria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
WHERE e.tipo_rede = 'Estadual'
  AND c.nome_categoria LIKE '%Sub%';
```

**Explique o filtro:**

> A cláusula WHERE aplica dois filtros restritivos ao resultado do cruzamento das tabelas: o primeiro (e.tipo_rede = 'Estadual') seleciona apenas os atletas cujas escolas pertencem à rede pública estadual, enquanto o segundo (c.nome_categoria LIKE '%Sub%') restringe a listagem às categorias de base. Isso permite à diretoria da associação gerar relatórios focados em públicos específicos para fins de parcerias governamentais e captação de talentos escolares.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Qual é a listagem geral de atletas cadastrados, ordenada alfabeticamente pelo nome do atleta, exibindo também sua data de nascimento, a escola parceira e a categoria esportiva correspondente?

```
SELECT
    a.nome_atleta,
    a.data_nascimento,
    e.nome_escola,
    c.nome_categoria
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
ORDER BY a.nome_atleta ASC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Qual é o quantitativo total de atletas vinculados a cada escola parceira, exibindo o nome da escola e o número total de praticantes matriculados?

```
SELECT
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
LEFT JOIN atleta AS a
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
ORDER BY total_atletas DESC;
```

**Explique o agrupamento:**

> O GROUP BY agrupa os registros resultantes do LEFT JOIN com base na identificação e no nome de cada escola (e.id_escola, e.nome_escola). Em conjunto com a função de agregação COUNT(a.id_atleta), o banco calcula o número de atletas associados a cada instituição específica, permitindo avaliar quais escolas possuem maior representatividade e engajamento nos projetos de atletismo da associação.

---

# 12. Quantidade mínima exigida

O `SPRINT1-5.sql` deverá conter, no mínimo:

```text
2 INNER JOIN
1 LEFT JOIN
1 RIGHT JOIN
2 consultas envolvendo 3 ou mais tabelas
1 JOIN + WHERE
1 JOIN + ORDER BY
1 JOIN + GROUP BY + agregação
```

As consultas devem responder perguntas reais sobre o banco.

---

# 13. Consulta mais útil

**Pergunta:**

> Qual é o panorama gerencial completo contendo o quantitativo de atletas por escola parceira e categoria esportiva, permitindo à diretoria mapear o fluxo de captação de talentos e o engajamento institucional?

```
SELECT
    e.nome_escola,
    c.nome_categoria,
    COUNT(a.id_atleta) AS total_atletas
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
GROUP BY e.nome_escola, c.nome_categoria
ORDER BY total_atletas DESC;
```

**Por que ela é útil?**

> Esta consulta é a mais útil para a operação diária e o planejamento estratégico da associação, pois cruza três entidades fundamentais (atleta, escola e categoria) e utiliza agregação para fornecer um raio-X preciso da distribuição de praticantes. Com esses dados, a diretoria técnica e administrativa da RAAEI consegue identificar rapidamente quais escolas parceiras possuem maior representatividade, quais categorias esportivas estão mais populosas ou carentes de atletas, e fundamentar propostas de captação de recursos e parcerias públicas ou privadas.

---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```
SELECT
    a.nome_atleta,
    a.data_nascimento,
    a.genero,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> Tabelas participantes: Participam da consulta a tabela atleta (apelidada como a) e a tabela escola (apelidada como e).
> Chave Primária (PK) utilizada: A chave primária é id_escola, localizada na tabela escola, que identifica de forma única cada instituição parceira cadastrada.
>Chave Estrangeira (FK) utilizada: A chave estrangeira é id_escola, localizada na tabela atleta, que aponta para a escola de origem de cada praticante.
>Função da cláusula ON: A cláusula ON a.id_escola = e.id_escola estabelece o critério lógico de correspondência entre as duas tabelas. Ela instrui o SGBD a vincular cada registro de atleta à respectiva escola cujo identificador seja idêntico, unindo os dados relacionais de forma correta.
>Impacto de uma condição incorreta: Se a condição de relacionamento estivesse errada (por exemplo, comparando colunas incompatíveis ou apontando para uma chave equivocada), o SGBD poderia gerar um produto cartesiano (multiplicando indevidamente todas as linhas das tabelas), retornar um conjunto de resultados vazio por falta de correspondência lógica, ou associar incorretamente atletas às escolas erradas, comprometendo a integridade do relatório gerencial.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```
SELECT
    a.nome_atleta,
    c.nome_categoria,
    e.nome_escola
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;
```

**Resultado esperado:**

> Retornar uma listagem com todos os atletas cadastrados que possuem vínculo válido com uma categoria esportiva e com uma escola parceira, exibindo de forma clara e integrada o nome do atleta, a modalidade/categoria e a instituição de ensino correspondente.

**Resultado obtido:**

> Execução bem-sucedida no MySQL Workbench (db_raaei). A consulta processou o duplo INNER JOIN sem erros de sintaxe ou gargalos de desempenho, retornando o conjunto de registros estruturado exatamente conforme planejado, comprovando a integridade das chaves estrangeiras e a consistência relacional da base de dados.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|

| Retorno de linhas duplicadas ou multiplicação indevida de registros (Produto Cartesiano). | Ausência ou incorreção na especificação da condição de junção nas cláusulas ON. | Revisar a correspondência exata entre as Chaves Primárias (PK) e Estrangeiras (FK) de cada tabela envolvida na consulta.

| Omissão de atletas recém-cadastrados que ainda não possuem escola ou categoria vinculada. | Utilização restritiva de INNER JOIN, que descarta registros com valores nulos (NULL) nas referências. | Substituir por LEFT JOIN ou RIGHT JOIN dependendo da tabela base que precisa ser mantida integralmente na listagem.

| Erro de sintaxe Unknown column ou falha ao referenciar colunas em consultas com múltiplos JOIN. | Ambiguidade de nomes de colunas idênticas em tabelas diferentes sem a devida qualificação por alias. | Utilizar prefixos ou aliases claros para todas as tabelas e colunas referenciadas no comando SQL (ex: atleta AS a, escola AS e).

---

# 17. Uso de LLMs

LLMs podem ser utilizadas como apoio, mas todo código deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

O aluno deverá ser capaz de explicar presencialmente qualquer consulta entregue.

---

# 18. Estrutura recomendada do SPRINT1-5.sql

```
-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

-- =====================================================================
-- 1. INNER JOIN 1: Relacionamento entre Atleta e Escola
-- =====================================================================
SELECT
    a.nome_atleta,
    a.data_nascimento,
    a.genero,
    e.nome_escola
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;

-- =====================================================================
-- 2. INNER JOIN 2: Cruzamento Triplo (Atleta, Categoria e Escola)
-- =====================================================================
SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;

-- =====================================================================
-- 3. LEFT JOIN: Categorias e Atletas (Garantindo categorias sem atletas)
-- =====================================================================
SELECT 
    c.nome_categoria,
    c.faixa_etaria,
    a.nome_atleta
FROM categoria AS c
LEFT JOIN atleta AS a
    ON c.id_categoria = a.id_categoria;

-- =====================================================================
-- 4. RIGHT JOIN: Atletas e Escolas (Garantindo atletas sem escola)
-- =====================================================================
SELECT 
    e.nome_escola,
    a.nome_atleta,
    a.genero
FROM escola AS e
RIGHT JOIN atleta AS a
    ON e.id_escola = a.id_escola;

-- =====================================================================
-- 5. JOIN COM 3+ TABELAS 1: Relatório Completo Institucional
-- =====================================================================
SELECT
    a.nome_atleta,
    c.nome_categoria,
    c.faixa_etaria,
    e.nome_escola,
    e.tipo_rede
FROM atleta AS a
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola;

-- =====================================================================
-- 6. JOIN COM 3+ TABELAS 2: Agregação por Escola e Categoria
-- =====================================================================
SELECT
    e.nome_escola,
    c.nome_categoria,
    COUNT(a.id_atleta) AS total_atletas
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
GROUP BY e.nome_escola, c.nome_categoria
ORDER BY total_atletas DESC;

-- =====================================================================
-- 7. JOIN + WHERE: Filtrando por Rede Estadual e Categorias de Base
-- =====================================================================
SELECT
    a.nome_atleta,
    e.nome_escola,
    c.nome_categoria,
    e.tipo_rede
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
WHERE e.tipo_rede = 'Estadual'
  AND c.nome_categoria LIKE '%Sub%';

-- =====================================================================
-- 8. JOIN + ORDER BY: Listagem Geral Ordenada Alfabeticamente
-- =====================================================================
SELECT
    a.nome_atleta,
    a.data_nascimento,
    e.nome_escola,
    c.nome_categoria
FROM atleta AS a
INNER JOIN escola AS e
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c
    ON a.id_categoria = c.id_categoria
ORDER BY a.nome_atleta ASC;

-- =====================================================================
-- 9. JOIN + GROUP BY + AGREGAÇÃO: Quantitativo Total por Escola
-- =====================================================================
SELECT
    e.nome_escola,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
LEFT JOIN atleta AS a
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola
ORDER BY total_atletas DESC;
```

---

# 19. Checklist

- [ ] utilizei o mesmo banco do Module-1;
- [ ] identifiquei PKs e FKs;
- [ ] produzi 2 `INNER JOIN`;
- [ ] produzi 1 `LEFT JOIN`;
- [ ] produzi 1 `RIGHT JOIN`;
- [ ] produzi consultas com 3 ou mais tabelas;
- [ ] utilizei `WHERE`;
- [ ] utilizei `ORDER BY`;
- [ ] utilizei agregação e `GROUP BY`;
- [ ] as consultas respondem perguntas reais;
- [ ] testei tudo no MySQL Workbench;
- [ ] consigo explicar as consultas;
- [ ] salvei `SPRINT1-5.md`;
- [ ] salvei `SPRINT1-5.sql`.

---

# 20. Git/GitHub

Continue utilizando:

```text
team-XX
```

Arquivos do commit:

```text
Module-2/SPRINT1-5.md
Module-2/SPRINT1-5.sql
```

Mensagem sugerida:

```text
Conclui Module 2 Sprint 1 de 5 - JOINs
```

**Não abra o Pull Request final nesta Sprint.**

---

# Próxima etapa

Na Sprint 2/5 serão trabalhadas subconsultas:

```sql
IN
NOT IN
EXISTS
NOT EXISTS
subconsultas correlacionadas
```
