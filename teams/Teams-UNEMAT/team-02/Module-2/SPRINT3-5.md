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

> Geovanna Gaspar Ribeiro

**Banco utilizado:**

```text
gerenciamento_incidentes
```

---

# 2. Consultas do projeto que merecem reutilização

Identifique pelo menos três consultas das Sprints anteriores que são importantes para o sistema.

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Incidentes com analista, dispositivo e tipo de ameaça juntos  | Evita repetir 3 JOINs toda vez que alguém precisa ver o panorama completo de um incidente | Sim — vw_incidentes_detalhados |
| Quantidade de incidentes por analista | Métrica usada com frequência para acompanhar carga de trabalho da equipe | Sim — vw_incidentes_por_analista |
| Incidentes ainda em aberto/análise | Consulta operacional, usada no dia a dia para saber o que ainda precisa de atenção | Sim — vw_incidentes_em_aberto |
| Incidentes críticos por tipo de ameaça | Útil para relatórios, mas usada com menos frequência | Não — mantida como consulta avulsa |

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
vw_incidentes_detalhados
```

**Pergunta que ela representa:**

> Para cada incidente, quem é o analista responsável, em qual dispositivo ocorreu e qual o tipo de ameaça envolvido?

**SQL:**

```sql
CREATE VIEW vw_incidentes_detalhados AS
SELECT
    i.id_incidente,
    i.titulo AS incidente,
    i.severidade,
    i.status,
    a.nome AS analista,
    d.nome_dispositivo AS dispositivo,
    t.nome_ameaca AS tipo_ameaca
FROM incidentes i
JOIN analistas a ON i.id_analista = a.id_analista
JOIN dispositivos d ON i.id_dispositivo = d.id_dispositivo
JOIN tipos_ameacas t ON i.id_ameaca = t.id_ameaca;
```

**Tabelas utilizadas:**

> incidentes, analistas, dispositivos, tipos_ameacas.

**Como consultar essa VIEW?**

```sql
SELECT * FROM vw_incidentes_detalhados;
```

---

# 5. VIEW 2 — agregação ou resumo

Esta VIEW deverá possuir, quando aplicável:

- relacionamento entre tabelas;
- `COUNT`, `SUM`, `AVG`, `MIN` ou `MAX`;
- `GROUP BY`.

**Pergunta:**

> Quantos incidentes cada analista está acompanhando atualmente?
```sql
CREATE VIEW vw_incidentes_por_analista AS
SELECT
    a.id_analista,
    a.nome AS analista,
    COUNT(i.id_incidente) AS total_incidentes
FROM analistas a
LEFT JOIN incidentes i ON i.id_analista = a.id_analista
GROUP BY a.id_analista, a.nome;
```

**Explique:**

> A VIEW junta analistas com incidentes usando LEFT JOIN assim, analistas sem nenhum incidente atribuído também aparecem, com total_incidentes = 0, em vez de simplesmente sumirem do resultado (o que aconteceria com um JOIN comum). O GROUP BY faz o COUNT ser calculado por analista.

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
vw_incidentes_em_aberto
```

```sql
CREATE VIEW vw_incidentes_em_aberto AS
SELECT
    i.id_incidente,
    i.titulo AS incidente,
    i.severidade,
    i.status,
    a.nome AS analista
FROM incidentes i
JOIN analistas a ON i.id_analista = a.id_analista
WHERE i.status IN ('ABERTO', 'EM_ANALISE');
```

**Por que essa VIEW é útil?**

> Representa exatamente o que um analista ou coordenador do SOC olharia no dia a dia: a lista de incidentes que ainda precisam de atenção (excluindo os já ENCERRADOs ou RESOLVIDOs). Sem a VIEW, essa mesma consulta com JOIN e WHERE teria que ser reescrita toda vez que alguém quisesse esse painel.

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
SELECT * FROM vw_incidentes_em_aberto;

SELECT * FROM vw_incidentes_em_aberto
WHERE severidade = 'ALTA';
```

**Resultado observado:**

> A primeira consulta traz todos os incidentes com status ABERTO ou EM_ANALISE, já com o nome do analista responsável. A segunda filtra esse mesmo conjunto, mantendo apenas os de severidade ALTA mostrando que a VIEW pode ser consultada e filtrada como se fosse uma tabela comum, mesmo sendo, na verdade, uma consulta armazenada.

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
CREATE VIEW vw_incidentes_em_aberto AS
SELECT
    i.id_incidente,
    i.titulo AS incidente,
    i.severidade,
    i.status,
    a.nome AS analista
FROM incidentes i
JOIN analistas a ON i.id_analista = a.id_analista
WHERE i.status IN ('ABERTO', 'EM_ANALISE');
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_incidentes_em_aberto AS
SELECT
    i.id_incidente,
    i.titulo AS incidente,
    i.severidade,
    i.status,
    a.nome AS analista,
    d.nome_dispositivo AS dispositivo,
    i.data_identificacao
FROM incidentes i
JOIN analistas a ON i.id_analista = a.id_analista
JOIN dispositivos d ON i.id_dispositivo = d.id_dispositivo
WHERE i.status IN ('ABERTO', 'EM_ANALISE');
```

**O que mudou?**

> Foram adicionadas duas colunas: dispositivo (via novo JOIN com dispositivos) e data_identificacao, para deixar o painel operacional mais completo, mostrando também onde o incidente ocorreu e há quanto tempo foi identificado. O filtro (WHERE) continuou o mesmo.

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
SELECT nome, cargo
FROM analistas;

DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> DROP VIEW remove apenas a consulta armazenada (a definição do SELECT)sem afetar nenhum dado real, já que a VIEW não guarda dados próprios. DROP TABLE remove uma tabela de verdade, apagando permanentemente todos os dados e a estrutura (colunas, chaves, etc.) nela contidos. Remover uma VIEW é uma operação de baixo risco; remover uma tabela é uma operação destrutiva e, em geral, irreversível.

---

# 10. Validando as Views

Use:

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_incidentes_detalhados
2. vw_incidentes_por_analista
3. vw_incidentes_em_aberto

---

# 11. Teste de atualização dos dados-base

Faça um teste:

1. consulte a VIEW;
2. altere ou insira um dado em uma tabela base;
3. consulte a VIEW novamente.

**VIEW testada:**

```text
vw_incidentes_por_analista
```

**Alteração realizada:**

```sql
-- 1) Consultar a VIEW antes da alteração
SELECT * FROM vw_incidentes_por_analista;

-- 2) Alterar um dado-base: mudar o status de um incidente para ENCERRADO
--    (a View conta incidentes independente do status, então o teste real
--    aqui é inserir um novo incidente para o mesmo analista)
UPDATE incidentes
SET status = 'ENCERRADO'
WHERE id_incidente = 4;

-- 3) Consultar a VIEW novamente
SELECT * FROM vw_incidentes_por_analista;
```

**Resultado observado:**

> Como a VIEW vw_incidentes_por_analista conta o total de incidentes por analista (sem filtrar por status), o UPDATE de status não muda a contagem, o total continua o mesmo antes e depois. Isso demonstra que a VIEW não guarda um retrato "congelado" dos dados: ela é recalculada a cada consulta, refletindo o estado atual da tabela incidentes no momento em que é lida. (Para observar mudança nesse caso específico, seria necessário inserir um novo incidente para o mesmo analista, o que aumentaria o total_incidentes na consulta seguinte.)

---

# 12. Validação prática obrigatória

Escolha uma VIEW.

```sql
CREATE VIEW vw_incidentes_por_analista AS
SELECT
    a.id_analista,
    a.nome AS analista,
    COUNT(i.id_incidente) AS total_incidentes
FROM analistas a
LEFT JOIN incidentes i ON i.id_analista = a.id_analista
GROUP BY a.id_analista, a.nome;
```

Explique:

1. de quais tabelas ela depende;
2. qual relacionamento utiliza;
3. quais campos apresenta;
4. qual problema resolve;
5. o que muda se os dados das tabelas originais forem alterados.

> 1. analistas e incidentes.
> 2. o relacionamento 1:N entre analistas (PK id_analista) e incidentes (FK id_analista), via LEFT JOIN.
> 3. id_analista, analista (nome) e total_incidentes (contagem calculada).
> 4. evita que qualquer pessoa precise reescrever o JOIN + GROUP BY toda vez que quiser saber a carga de incidentes de cada analista, basta consultar SELECT * FROM vw_incidentes_por_analista.
> 5. como a VIEW não armazena dados, qualquer INSERT, UPDATE ou DELETE feito em analistas ou incidentes é refletido automaticamente na próxima vez que a VIEW for consultada, ela sempre mostra o estado atual das tabelas-base, nunca um valor desatualizado.

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
|  |  |  |
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
