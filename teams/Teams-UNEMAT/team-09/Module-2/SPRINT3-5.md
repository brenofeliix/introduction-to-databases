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

> Vinícius Eduardo Lima de Assis.

**Banco utilizado:**

```text
pacote_viagens
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Junção de reservas com clientes, hospedagens e transportes | Permite visualizar todas as informações operacionais das reservas em um único local | Sim |
| Total gasto e quantidade de pessoas por destino | Facilita a análise de faturamento e fluxo de turistas por localização | Sim |
| Média de diárias por tipo de hospedagem | Permite comparar a média de preços entre hotéis, pousadas e hotéis de luxo | Sim |

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
vw_detalhes_reservas
```

**Pergunta que ela representa:**

> Quais são os detalhes completos de cada reserva efetuada, incluindo nome do cliente, e-mail, hospedagem reservada e empresa de transporte utilizada?

**SQL:**

```sql
-- CREATE VIEW vw_detalhes_reservas AS
SELECT 
    r.id_reserva,
    c.nome AS nome_cliente,
    c.email AS email_cliente,
    h.nome AS nome_hospedagem,
    t.empresa AS empresa_transporte,
    t.tipo AS tipo_transporte,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte;
```

**Tabelas utilizadas:**

> reserva_pacote, cliente, hospedagem e transporte.

**Como consultar essa VIEW?**

```sql
-- SELECT * FROM vw_detalhes_reservas;
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Qual é a quantidade total de pessoas com reserva e a quantidade total de reservas efetuadas agrupadas por destino?

```sql
-- CREATE VIEW vw_resumo_por_destino AS
SELECT 
    d.nome AS destino,
    d.pais,
    COUNT(r.id_reserva) AS total_reservas,
    SUM(r.quantidade_pessoas) AS total_passageiros
FROM destino AS d
INNER JOIN hospedagem AS h ON d.id_destino = h.id_destino
INNER JOIN reserva_pacote AS r ON h.id_hospedagem = r.id_hospedagem
GROUP BY d.id_destino, d.nome, d.pais;
```

**Explique:**

> A VIEW combina quatro tabelas, agrupa os dados pelo destino do pacote de viagens e calcula agregados: o número total de reservas (COUNT) e o número total acumulado de viajantes (SUM).

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
vw_reservas_ativas
```

```sql
-- CREATE VIEW vw_reservas_ativas AS
SELECT 
    r.id_reserva,
    c.nome AS cliente,
    c.telefone,
    h.nome AS hospedagem,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
WHERE c.ativo = TRUE;
```

**Por que essa VIEW é útil?**

> É extremamente útil para o setor operacional da agência de viagens no dia a dia, pois traz uma lista limpa das reservas ligadas a clientes ativos no cadastro, facilitando o contato direto e o envio de confirmações de viagem.

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
-- Consulta simples na VIEW
SELECT * FROM vw_detalhes_reservas;

-- Consulta com filtro na VIEW
SELECT * 
FROM vw_detalhes_reservas 
WHERE quantidade_pessoas > 2;
```

**Resultado observado:**

> A primeira consulta retornou todas as reservas cadastradas com suas informações resumidas e nomes completos. A segunda consulta filtrou com sucesso apenas as reservas que continham mais de 2 passageiros, demonstrando que a VIEW aceita filtros da mesma forma que uma tabela comum.

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
-- CREATE VIEW vw_reservas_ativas AS
SELECT 
    r.id_reserva,
    c.nome AS cliente,
    c.telefone,
    h.nome AS hospedagem,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
WHERE c.ativo = TRUE;
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_reservas_ativas AS
SELECT 
    r.id_reserva,
    c.nome AS cliente,
    c.telefone,
    c.email,
    h.nome AS hospedagem,
    d.nome AS destino,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino
WHERE c.ativo = TRUE;
```

**O que mudou?**

> Foi adicionado um INNER JOIN com a tabela destino e incluídas as colunas c.email e d.nome AS destino, enriquecendo a VIEW com as informações do e-mail do cliente e a cidade do destino reservado.

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
-- Criação de VIEW temporária
CREATE VIEW vw_teste AS
SELECT id_cliente, nome FROM cliente;

-- Remoção da VIEW temporária
DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> O comando DROP VIEW exclui apenas o objeto virtual de consulta e suas definições do banco de dados, sem remover nenhum dado real. Já o comando DROP TABLE elimina a estrutura física e todos os dados armazenados de forma irreversível da tabela do banco.

---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_detalhes_reservas
2. vw_reservas_ativas
3. vw_resumo_por_destino

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_detalhes_reservas
```

**Alteração realizada:**

```sql
-- UPDATE cliente 
SET nome = 'Carlos Silva Marques' 
WHERE id_cliente = 1;
```

**Resultado observado:**

> Ao consultar a vw_detalhes_reservas novamente após o UPDATE, o nome do cliente 1 apareceu automaticamente alterado para "Carlos Silva Marques". Isso confirma que as VIEWs não armazenam dados estáticos, mas consultam a tabela base em tempo real.

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
-- CREATE VIEW vw_detalhes_reservas AS
SELECT 
    r.id_reserva,
    c.nome AS nome_cliente,
    c.email AS email_cliente,
    h.nome AS nome_hospedagem,
    t.empresa AS empresa_transporte,
    t.tipo AS tipo_transporte,
    r.data_reserva,
    r.quantidade_pessoas
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte;
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> 1.Depende das tabelas reserva_pacote, cliente, hospedagem e transporte;
> 2.Utiliza relacionamentos N:1 entre a tabela associativa de reservas (reserva_pacote) e as tabelas cadastrais via chaves estrangeiras id_cliente, id_hospedagem e id_transporte;
> 3.Apresenta id_reserva, nome_cliente, email_cliente, nome_hospedagem, empresa_transporte, tipo_transporte, data_reserva e quantidade_pessoas;
> 4.Resolve a necessidade de escrever queries extensas com múltiplos JOINs toda vez que a equipe precisar consultar os detalhes principais das reservas do sistema;
> 5.Como a VIEW é uma tabela virtual dinâmica, qualquer inclusão, atualização ou exclusão feita nas tabelas originais será refletida de forma imediata ao consultar a VIEW.

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
| Nome de coluna duplicado na VIEW | Seleção de colunas com o mesmo nome (ex: nome) de tabelas distintas | Utilização de apelidos/alias para as colunas no SELECT (ex: c.nome AS nome_cliente |
| Erro ao recriar VIEW existente | Execução do comando CREATE VIEW para um nome já registrado no banco | Utilização da cláusula CREATE OR REPLACE VIEW |

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
