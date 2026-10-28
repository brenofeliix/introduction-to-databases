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

> Raquel Silva dos Santos

**Banco utilizado:**

```text
series_watchlist_db
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Catálogo completo com detalhes da plataforma de exibição | Elimina a necessidade de repetir o JOIN entre série e plataforma em telas de listagem | Sim (vw_catalogo_series_plataforma) |
| Estatísticas agregadas de desempenho e notas médias por série | Consolida o volume de avaliações e média de notas para relatórios analíticos | Sim (vw_estatisticas_series) |
| Itens em andamento ("Assistindo") com dados do usuário e da série | Fornece uma visão direta para painéis operacionais de séries ativas | Sim (vw_series_em_andamento) |
| Usuários sem atividade na watchlist | Identifica contas sem engajamento para réguas de reativação | Não (resolvida pontualmente via subconsulta) |

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
vw_catalogo_series_plataforma
```

**Pergunta que ela representa:**

> Como listar de forma unificada o catálogo de séries, trazendo o título, gênero, ano, país de origem e o nome legível do serviço de streaming onde a obra está disponível?

**SQL:**

```sql
CREATE VIEW vw_catalogo_series_plataforma AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    s.pais_origem,
    p.id_plataforma,
    p.nome_plataforma AS plataforma
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
```

**Tabelas utilizadas:**

> serie e plataforma.

**Como consultar essa VIEW?**

```sql
SELECT 
    nome_serie, 
    genero, 
    plataforma
FROM vw_catalogo_series_plataforma
ORDER BY nome_serie ASC;
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Qual é o resumo estatístico de cada série, informando a quantidade total de usuários que a adicionaram, a quantidade de notas atribuídas, a nota mínima, a nota máxima e a média de avaliação arredondada?

```sql
CREATE VIEW vw_estatisticas_series AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    p.nome_plataforma AS plataforma,
    COUNT(w.id_usuario) AS total_watchlist,
    COUNT(w.nota) AS total_avaliacoes,
    MIN(w.nota) AS menor_nota,
    MAX(w.nota) AS maior_nota,
    ROUND(AVG(w.nota), 2) AS media_nota
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY s.id_serie, s.titulo, p.nome_plataforma;
```

**Explique:**

> A VIEW combina três tabelas (serie, plataforma e item_watchlist) usando LEFT JOIN para garantir que séries sem nenhuma avaliação continuem presentes no resumo. Ela calcula indicadores fundamentais por meio das funções de agregação COUNT(), MIN(), MAX() e AVG(), agrupando o resultado pelo identificador e título da produção.

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
vw_series_em_andamento
```

```sql
CREATE VIEW vw_series_em_andamento AS
SELECT 
    u.id_usuario,
    u.nome AS usuario,
    u.email,
    s.id_serie,
    s.titulo AS serie,
    p.nome_plataforma AS plataforma,
    w.status_assistindo,
    w.nota
FROM item_watchlist AS w
INNER JOIN usuario AS u
    ON w.id_usuario = u.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
WHERE w.status_assistindo = 'Assistindo';
```

**Por que essa VIEW é útil?**

> É uma visualização operacional de uso contínuo pela aplicação. Permite que o frontend liste imediatamente na página inicial do usuário ou no painel de suporte quais séries estão atualmente em reprodução ativa, sem a necessidade de reescrever filtros condicionais e três junções relacionais a cada chamada de tela.

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
-- -- Consulta completa
SELECT *
FROM vw_estatisticas_series;

-- Consulta com filtro
SELECT 
    nome_serie, 
    plataforma, 
    media_nota, 
    total_avaliacoes
FROM vw_estatisticas_series
WHERE media_nota >= 9.0
ORDER BY media_nota DESC;
```

**Resultado observado:**

> A consulta com filtro retornou apenas os títulos com avaliação média de excelência (>= 9.0), listando produções como The Last of Us (média 9.50) e Dark (média 9.80). O filtro WHERE foi aplicado perfeitamente sobre a coluna computada media_nota da VIEW.

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
CREATE VIEW vw_catalogo_series_plataforma AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    s.pais_origem,
    p.id_plataforma,
    p.nome_plataforma AS plataforma
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_catalogo_series_plataforma AS
SELECT 
    s.id_serie,
    s.titulo AS nome_serie,
    s.genero,
    s.ano_lancamento,
    (2026 - s.ano_lancamento) AS anos_de_lancamento,
    s.pais_origem,
    p.id_plataforma,
    p.nome_plataforma AS plataforma
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma;
```

**O que mudou?**

> Foi adicionada uma coluna calculada: (2026 - s.ano_lancamento) AS anos_de_lancamento, permitindo que os consumidores da VIEW obtenham diretamente a idade da produção sem alterar a estrutura física da tabela base nem exigir recriação manual com DROP VIEW.

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
-- -- Criação de VIEW temporária para teste
CREATE VIEW vw_teste_temporaria AS
SELECT 
    id_usuario, 
    nome, 
    email
FROM usuario
WHERE data_cadastro >= '2024-03-01';

-- Remoção controlada
DROP VIEW vw_teste_temporaria;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

>O DROP TABLE remove permanentemente do banco a definição da tabela física e todos os dados nela armazenados. Já o DROP VIEW apaga apenas a consulta armazenada (a definição do objeto virtual); as tabelas originais e seus respectivos dados continuam completamente intactos.

---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_catalogo_series_plataforma
2. vw_estatisticas_series
3. vw_series_em_andamento

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_estatisticas_series
```

**Alteração realizada:**

```sql
-- -- Consulta prévia da média de Stranger Things (id_serie = 1)
SELECT nome_serie, media_nota, total_avaliacoes 
FROM vw_estatisticas_series 
WHERE id_serie = 1;

-- Inserção de uma nova avaliação para Stranger Things
INSERT INTO item_watchlist (id_usuario, id_serie, status_assistindo, nota, comentario)
VALUES (3, 1, 'Concluído', 10, 'Excelente série, revi agora!');

-- Nova consulta à VIEW
SELECT nome_serie, media_nota, total_avaliacoes 
FROM vw_estatisticas_series 
WHERE id_serie = 1;
```

**Resultado observado:**

> Antes do comando, Stranger Things possuía 2 avaliações válidas (notas 9.5 e 8.0, média 8.75). Logo após o INSERT na tabela física item_watchlist, a consulta à VIEW recalculou os números em tempo real, refletindo 3 avaliações e uma nova média aritmética arredondada de 9.17, sem que nenhuma manutenção precisasse ser feita na VIEW.

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
CREATE VIEW vw_series_em_andamento AS
SELECT 
    u.id_usuario,
    u.nome AS usuario,
    u.email,
    s.id_serie,
    s.titulo AS serie,
    p.nome_plataforma AS plataforma,
    w.status_assistindo,
    w.nota
FROM item_watchlist AS w
INNER JOIN usuario AS u
    ON w.id_usuario = u.id_usuario
INNER JOIN serie AS s
    ON w.id_serie = s.id_serie
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
WHERE w.status_assistindo = 'Assistindo';
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> Esta VIEW depende diretamente das tabelas `item_watchlist`, `usuario`, `serie` e `plataforma`, estruturando-se por meio dos relacionamentos entre as chaves estrangeiras da watchlist e as chaves primárias de usuário (`w.id_usuario = u.id_usuario`) e de série (`w.id_serie = s.id_serie`), além da chave estrangeira de série vinculada à primária de plataforma (`s.id_plataforma = p.id_plataforma`). Como resultado, ela disponibiliza de forma unificada o identificador, nome e e-mail de contato do usuário, o ID e título da série, o nome da plataforma, o status de exibição atual e eventual nota já atribuída. Com isso, resolve o problema de complexidade do encadeamento de três junções internas e do filtro textual obrigatório, entregando uma interface pronta e padronizada para os componentes da aplicação responsáveis pelo acompanhamento de consumo de conteúdo. Por se tratar de uma estrutura dinâmica, qualquer alteração nas tabelas de origem — como a atualização do nome de uma plataforma, do título de uma série ou a mudança de status realizada pelo usuário (como de "Assistindo" para "Concluído") — é refletida de forma imediata na consulta da VIEW no exato momento de sua execução.

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
| Séries sem avaliações ficavam de fora da VIEW de estatísticas | O uso inicial de INNER JOIN com a tabela item_watchlist descartava produções sem resenhas | Substituição pelo uso de LEFT JOIN, mantendo todas as séries e retornando zero/nulo nas métricas |
| Ambiguidade no nome de colunas idênticas entre tabelas | serie e plataforma possuem a coluna id_plataforma | Emprego de aliases explícitos (s.id_plataforma, p.nome_plataforma) |
| Erro de tentativa de substituição em banco em produção | Utilizar apenas CREATE VIEW falha caso o objeto já exista | Adoção da sintaxe CREATE OR REPLACE VIEW para permitir evolução do esquema |

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

- [X] utilizei o banco do projeto;
- [X] criei pelo menos 3 Views;
- [X] pelo menos uma View usa JOIN;
- [X] pelo menos uma View usa agregação ou resumo;
- [X] consultei as Views;
- [X] utilizei `CREATE OR REPLACE VIEW`;
- [X] pratiquei `DROP VIEW`;
- [X] validei as Views;
- [X] testei mudança em tabela base;
- [X] compreendo de onde vêm os dados de cada View;
- [X] salvei `SPRINT3-5.md`;
- [X] salvei `SPRINT3-5.sql`.

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
