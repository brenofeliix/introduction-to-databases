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

> Walter Anacleto Salido de Souza

**Banco utilizado:**

```
db_raaei
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|

| Escolas com Atletas Ativos (Junção entre escolas e atletas com eliminação de duplicidades via DISTINCT / IN). | Permite à diretoria da associação identificar instantaneamente quais instituições parceiras possuem alunos matriculados e ativos nos projetos esportivos. | Sim (vw_escolas_com_atletas)

| Categorias Esportivas com Atletas (Verificação de existência de praticantes por modalidade via EXISTS). | Essencial para o planejamento técnico, permitindo mapear quais categorias estão ativas e quais estão ociosas sem praticantes vinculados. | Sim (vw_categorias_com_atletas)

| Atletas Mais Jovens (Filtro relacional cruzando dados de atletas e escolas com base na função agregada MAX). | Destaca o perfil etário dos novos talentos da associação, facilitando relatórios institucionais para federações e programas de base. | Sim (vw_atletas_mais_jovens)

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

```
CREATE VIEW vw_escolas_com_atletas AS
SELECT 
    e.id_escola,
    e.nome_escola,
    e.tipo_rede,
    COUNT(a.id_atleta) AS total_atletas
FROM escola AS e
INNER JOIN atleta AS a 
    ON e.id_escola = a.id_escola
GROUP BY e.id_escola, e.nome_escola, e.tipo_rede;
```

---

# 4. VIEW 1 — relacionamento entre tabelas

**Nome da VIEW:**

```
vw_atletas_escolas_categorias
```

**Pergunta que ela representa:**

> Quais são os dados detalhados de cada atleta cadastrado, exibindo simultaneamente o nome da escola parceira onde estuda e a categoria esportiva em que treina na associação?

**SQL:**

```
CREATE VIEW vw_atletas_escolas_categorias AS
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola,
    e.tipo_rede,
    c.nome_categoria,
    c.faixa_etaria
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c 
    ON a.id_categoria = c.id_categoria;
```

**Tabelas utilizadas:**

> atleta, escola e categoria.

**Como consultar essa VIEW?**

```
SELECT 
    nome_atleta,
    nome_escola,
    nome_categoria
FROM vw_atletas_escolas_categorias
WHERE tipo_rede = 'Pública';
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Qual é o panorama quantitativo de atletas matriculados em cada categoria esportiva da associação, permitindo identificar o volume de praticantes por modalidade (incluindo categorias que estejam temporariamente ociosas)?

```
CREATE VIEW vw_resumo_atletas_por_categoria AS
SELECT 
    c.id_categoria,
    c.nome_categoria,
    c.faixa_etaria,
    COUNT(a.id_atleta) AS total_atletas
FROM categoria AS c
LEFT JOIN atleta AS a 
    ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria, c.faixa_etaria;
```

**Explique:**

> Esta visão encapsula uma consulta de agregação avançada que cruza as tabelas categoria e atleta. O uso da função COUNT(a.id_atleta) calcula o total de praticantes vinculados a cada modalidade esportiva. A adoção do LEFT JOIN é um diferencial estratégico, pois garante que todas as categorias cadastradas apareçam no relatório institucional — mesmo aquelas que ainda não possuem atletas ativos (exibindo contagem igual a zero), auxiliando a diretoria técnica no planejamento de novas turmas e campanhas de captação.

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

```
vw_colaboradores_ativos
```

```
CREATE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email
FROM colaborador
WHERE cargo IS NOT NULL;
```

**Por que essa VIEW é útil?**

> Esta visão operacional é essencial para a diretoria administrativa e executiva da RAAEI, pois centraliza rapidamente os contatos e funções da equipe técnica, treinadores e colaboradores ativos. Ela agiliza a comunicação interna, a escala de treinamentos e a alocação de profissionais em competições oficiais, abstraindo a tabela base e fornecendo um acesso limpo, seguro e imediato aos dados cadastrais da equipe de apoio e multidisciplinar.

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

```
-- Consulta geral à view de resumo por categoria
SELECT *
FROM vw_resumo_atletas_por_categoria;

-- Consulta com filtro aplicado para listar apenas categorias com atletas ativos
SELECT 
    nome_categoria,
    faixa_etaria,
    total_atletas
FROM vw_resumo_atletas_por_categoria
WHERE total_atletas > 0
ORDER BY total_atletas DESC;
```

**Resultado observado:**

> O SGBD executou a consulta virtual encapsulada na view e aplicou o filtro na coluna calculada (total_atletas), retornando instantaneamente apenas as modalidades esportivas que possuem praticantes ativos na associação, ordenadas de forma decrescente pelo volume de inscrições. Isso demonstra como as views facilitam consultas complexas, permitindo o uso de cláusulas tradicionais de filtragem (WHERE e ORDER BY) diretamente sobre os dados agregados sem a necessidade de reescrever junções ou subconsultas longas.

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

```
CREATE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email
FROM colaborador
WHERE cargo IS NOT NULL;
```

**Nova versão:**

```
CREATE OR REPLACE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email,
    UPPER(cargo) AS cargo_formatado
FROM colaborador
WHERE cargo IS NOT NULL
  AND status_ativo = 1;
```

**O que mudou?**

> A estrutura da visão foi atualizada utilizando o comando CREATE OR REPLACE VIEW, que reconstrói a view existente sem a necessidade de excluí-la previamente com DROP. Foram feitas duas alterações estratégicas: Inclusão de nova coluna calculada: Adição da coluna cargo_formatado utilizando a função de string UPPER(), padronizando a exibição dos cargos em letras maiúsculas para relatórios institucionais. Refinamento do filtro: Atualização da cláusula WHERE para incluir a condição status_ativo = 1, garantindo que a visão traga estritamente apenas os profissionais que estão atualmente em exercício ativo nas atividades da associação, aumentando a precisão operacional do sistema.

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

```
-- Criação de uma VIEW temporária para teste operacional
CREATE VIEW vw_teste AS
SELECT 
    id_atleta,
    nome_atleta,
    genero
FROM atleta;

-- Consulta rápida para validar o funcionamento da VIEW criada
SELECT * 
FROM vw_teste;

-- Remoção controlada da VIEW temporária do banco de dados
DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> DROP VIEW: Remove apenas a definição lógica da visão (ou seja, o texto da consulta armazenada no dicionário de dados do SGBD). Ela não apaga nenhum dado físico, pois as tabelas subjacentes que alimentam a view permanecem intactas e seguras.
> DROP TABLE: É uma operação estrutural e destrutiva que remove permanentemente tanto a definição da tabela quanto todos os registros de dados armazenados nela no disco, o que pode causar perda irreversível de informações caso não haja backups recentes.

---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_atletas_escolas_categorias
2. vw_resumo_atletas_por_categoria
3. vw_colaboradores_ativos

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```
vw_resumo_atletas_por_categoria
```

**Alteração realizada:**

```
-- 1. Consulta inicial à VIEW antes da alteração
SELECT * 
FROM vw_resumo_atletas_por_categoria
WHERE nome_categoria = 'Arremesso de Peso Sub-18';

-- 2. Inserção de um novo atleta na tabela base (afetando a categoria correspondente)
INSERT INTO atleta (nome_atleta, genero, data_nascimento, id_escola, id_categoria) 
VALUES ('Lucas Gabriel Silva', 'M', '2010-05-14', 1, 3);

-- 3. Consulta posterior à VIEW para verificar a atualização dinâmica
SELECT * 
FROM vw_resumo_atletas_por_categoria
WHERE nome_categoria = 'Arremesso de Peso Sub-18';
```

**Resultado observado:**

> O teste comprovou que as views no MySQL são dinâmicas e funcionam como janelas em tempo real para as tabelas subjacentes. Na primeira consulta, a view exibia a contagem anterior de atletas para a categoria de arremesso de peso. Após o comando INSERT na tabela base atleta, uma nova consulta à mesma view (vw_resumo_atletas_por_categoria) refletiu instantaneamente o incremento de +1 no campo total_atletas daquela modalidade, sem a necessidade de recriar ou atualizar a estrutura da view. Isso demonstra a eficiência e a confiabilidade das visões para relatórios gerenciais sempre atualizados.

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```
CREATE VIEW vw_atletas_escolas_categorias AS
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola,
    e.tipo_rede,
    c.nome_categoria,
    c.faixa_etaria
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c 
    ON a.id_categoria = c.id_categoria;
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> 
1. Tabelas de dependência: A visão depende diretamente de três tabelas estruturais do banco de dados db_raaei: atleta, escola e categoria.
2. Relacionamentos utilizados: Utiliza dois cruzamentos relacionais do tipo INNER JOIN. O primeiro conecta a tabela atleta com a tabela escola por meio da chave estrangeira id_escola, e o segundo conecta a tabela atleta com a tabela categoria através da chave estrangeira id_categoria.
3. Campos apresentados: Exibe o identificador, nome, gênero e data de nascimento do atleta (atleta), o nome e o tipo de rede da instituição de ensino (escola), além do nome da modalidade e faixa etaria correspondente (categoria).
4. Problema que resolve: Elimina a necessidade de repetir consultas complexas com múltiplos JOINs sempre que a diretoria ou a equipe técnica precisar emitir relatórios unificados contendo simultaneamente o perfil do praticante, sua escola de origem e sua categoria de treinamento.
5. Comportamento diante de alterações: Por ser uma tabela virtual dinâmica, qualquer alteração, inserção ou exclusão realizada nas tabelas originais (atleta, escola ou categoria) refletirá de forma imediata e automática na próxima consulta à visão, garantindo a integridade e a atualização em tempo real dos relatórios institucionais da associação.

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

```-- MODULE 2 — SPRINT 3/5
-- VIEWS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

-- =====================================================================
-- 1. VIEW 1 — Relacionamento entre tabelas (Atletas, Escolas e Categorias)
-- =====================================================================
CREATE VIEW vw_atletas_escolas_categorias AS
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    a.data_nascimento,
    e.nome_escola,
    e.tipo_rede,
    c.nome_categoria,
    c.faixa_etaria
FROM atleta AS a
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
INNER JOIN categoria AS c 
    ON a.id_categoria = c.id_categoria;

-- =====================================================================
-- 2. VIEW 2 — Agregação ou resumo (Panorama de atletas por categoria)
-- =====================================================================
CREATE VIEW vw_resumo_atletas_por_categoria AS
SELECT 
    c.id_categoria,
    c.nome_categoria,
    c.faixa_etaria,
    COUNT(a.id_atleta) AS total_atletas
FROM categoria AS c
LEFT JOIN atleta AS a 
    ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria, c.faixa_etaria;

-- =====================================================================
-- 3. VIEW 3 — Consulta operacional do sistema (Colaboradores ativos)
-- =====================================================================
CREATE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email
FROM colaborador
WHERE cargo IS NOT NULL;

-- =====================================================================
-- 4. CONSULTAS SOBRE AS VIEWS
-- =====================================================================
-- Consulta geral à visão relacional filtrando por rede pública
SELECT 
    nome_atleta,
    nome_escola,
    nome_categoria
FROM vw_atletas_escolas_categorias
WHERE tipo_rede = 'Pública';

-- Consulta gerencial ordenada por volume de atletas
SELECT 
    nome_categoria,
    faixa_etaria,
    total_atletas
FROM vw_resumo_atletas_por_categoria
WHERE total_atletas > 0
ORDER BY total_atletas DESC;

-- =====================================================================
-- 5. CREATE OR REPLACE VIEW (Atualização da view de colaboradores)
-- =====================================================================
CREATE OR REPLACE VIEW vw_colaboradores_ativos AS
SELECT 
    id_colaborador,
    nome_colaborador,
    cargo,
    telefone,
    email,
    UPPER(cargo) AS cargo_formatado
FROM colaborador
WHERE cargo IS NOT NULL
  AND status_ativo = 1;

-- =====================================================================
-- 6. VIEW TEMPORÁRIA E TESTE COM DROP VIEW
-- =====================================================================
-- Criação de uma VIEW temporária para teste operacional
CREATE VIEW vw_teste AS
SELECT 
    id_atleta,
    nome_atleta,
    genero
FROM atleta;

-- Consulta rápida para validar a view temporária
SELECT * 
FROM vw_teste;

-- Remoção controlada da VIEW temporária
DROP VIEW vw_teste;

-- =====================================================================
-- 7. VALIDAÇÃO (Exibição de todas as Views ativas no banco)
-- =====================================================================
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|

| Erro Table 'db_raaei.nome_view' doesn't exist ao tentar consultar uma visão recém-criada. | Ocorre quando a consulta falhou silenciosamente no momento da criação (por erro de sintaxe ou coluna inexistente) e a view não foi efetivamente gerada no SGBD. | Validar a instrução SQL de criação isoladamente no editor ou executar SHOW FULL TABLES WHERE Table_type = 'VIEW'; para confirmar a existência da visão.

| Impossibilidade de realizar operações de inserção (INSERT), atualização (UPDATE) ou exclusão (DELETE) diretamente em uma View. | A view contém funções de agregação (COUNT, SUM, AVG), cláusulas de agrupamento (GROUP BY), uniões complexas (JOIN) ou agregações que impedem o SGBD de mapear as alterações univocamente para as tabelas base. | Realizar as operações de modificação de dados diretamente nas tabelas físicas subjacentes, utilizando as views exclusivamente para consultas, relatórios e abstração de leitura.

| Erro View's SELECT contains a subquery in the FROM clause ou restrições de performance ao consultar uma View aninhada em grandes volumes. | Utilização ineficiente de subconsultas não otimizadas dentro da definição da visão, o que pode gerar alto custo de varredura (Full Table Scan) a cada acesso. | Reescrever a instrução utilizando junções diretas (JOIN), criar índices nas chaves estrangeiras das tabelas base ou simplificar a lógica interna da visão.
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
