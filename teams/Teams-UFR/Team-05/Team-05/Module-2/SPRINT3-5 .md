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

> NICOLAS LINO OLIVEIRA

**Banco utilizado:**

```text
banco_imobiliaria
```

---

# 2. Consultas do projeto que merecem reutilização

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Visitas com nome do cliente e endereço do imóvel (Sprint 1 do Module 2) | Os corretores consultam a agenda de visitas todos os dias, e o JOIN de 3 tabelas é longo para repetir | Sim: `vw_visitas_detalhadas` |
| Comissão por corretor (Sprint 1 do Module 2) | É o relatório financeiro principal da gestão | Sim: `vw_resumo_corretores` |
| Imóveis disponíveis (Sprint 4 do Module 1) com o corretor responsável | É a consulta mais usada no atendimento a clientes interessados | Sim: `vw_imoveis_disponiveis` |
| Propostas em análise (Sprint 1 do Module 2) | Mostra negociações em aberto, mas o filtro é simples | Não, por enquanto |

---

# 3. Criando uma VIEW

Estrutura geral:

```sql
CREATE VIEW nome_view AS
SELECT ...
FROM ...
WHERE ...;
```

Uma VIEW **não guarda dados**. Ela guarda apenas a consulta, que é executada cada vez que a VIEW é consultada.

---

# 4. VIEW 1 — relacionamento entre tabelas

**Nome da VIEW:**

```text
vw_visitas_detalhadas
```

**Pergunta que ela representa:**

> Quem visitou qual imóvel, quando e com qual situação?

**SQL:**

```sql
CREATE VIEW vw_visitas_detalhadas AS
SELECT
    v.id_visita,
    c.nome AS cliente,
    c.contato,
    i.endereco,
    i.tipo,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel;
```

**Tabelas utilizadas:**

> `visitas`, `clientes` e `imoveis`. A tabela `visitas` é a central, pois guarda as FKs `id_cliente` e `id_imovel`.

**Como consultar essa VIEW?**

```sql
SELECT * FROM vw_visitas_detalhadas;
```

---

# 5. VIEW 2 — agregação ou resumo

**Nome da VIEW:**

```text
vw_resumo_corretores
```

**Pergunta:**

> Quantos contratos cada corretor fechou, quanto vendeu e qual comissão tem a receber?

```sql
CREATE VIEW vw_resumo_corretores AS
SELECT
    cor.id_corretor,
    cor.nome AS corretor,
    cor.creci,
    cor.comissao_percentual,
    COUNT(ct.id_contrato) AS contratos_fechados,
    COALESCE(SUM(ct.valor_final), 0) AS total_vendido,
    COALESCE(SUM(ct.valor_final * cor.comissao_percentual / 100), 0) AS comissao_total
FROM corretores AS cor
LEFT JOIN contratos AS ct
    ON cor.id_corretor = ct.id_corretor
GROUP BY cor.id_corretor, cor.nome, cor.creci, cor.comissao_percentual;
```

**Explique:**

> A VIEW junta `corretores` e `contratos` com `LEFT JOIN`, para que corretores sem nenhuma venda continuem aparecendo. O `GROUP BY` forma um grupo por corretor, o `COUNT` conta os contratos, o `SUM` soma os valores vendidos e a expressão `valor_final * comissao_percentual / 100` calcula a comissão. O `COALESCE` troca `NULL` por 0 para os corretores sem contrato. Hoje o Carlos Eduardo Ramos aparece com 1 contrato, R$ 400.000,00 vendidos e R$ 24.000,00 de comissão.

---

# 6. VIEW 3 — consulta operacional do sistema

**Nome da VIEW:**

```text
vw_imoveis_disponiveis
```

```sql
CREATE VIEW vw_imoveis_disponiveis AS
SELECT
    i.id_imovel,
    i.endereco,
    i.tipo,
    i.preco,
    i.observacoes,
    cor.nome AS corretor_responsavel,
    cor.creci
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
WHERE i.status = 'disponível'
  AND g.data_fim IS NULL;
```

**Por que essa VIEW é útil?**

> Mostra ao atendente apenas os imóveis que realmente podem ser oferecidos (status 'disponível'), já com o corretor responsável atual (gestão ativa, `data_fim IS NULL`). Quando um cliente liga procurando um imóvel, o atendente não precisa montar o JOIN: basta consultar a VIEW e filtrar por tipo ou preço.

---

# 7. Consultando uma VIEW

**SQL executado:**

```sql
SELECT *
FROM vw_visitas_detalhadas;

SELECT *
FROM vw_visitas_detalhadas
WHERE status_visita = 'realizada';

SELECT *
FROM vw_imoveis_disponiveis
WHERE tipo = 'casa'
ORDER BY preco ASC;
```

**Resultado observado:**

> Esperado: a primeira consulta retorna as 5 visitas existentes, com nome do cliente e endereço. O filtro `'realizada'` reduz o resultado para 3 visitas (Lucas, Beatriz e Guilherme). A consulta de casas retorna as 2 casas disponíveis, a da Rua das Palmeiras, 88 (R$ 590.000) e a da Rua das Camélias, 45 (R$ 780.000), nessa ordem. A VIEW se comporta como uma tabela: aceita `WHERE` e `ORDER BY`. *(confirmar o resultado obtido no Workbench)*

---

# 8. CREATE OR REPLACE VIEW

**VIEW original:**

```sql
CREATE VIEW vw_imoveis_disponiveis AS
SELECT
    i.id_imovel,
    i.endereco,
    i.tipo,
    i.preco,
    i.observacoes,
    cor.nome AS corretor_responsavel,
    cor.creci
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
WHERE i.status = 'disponível'
  AND g.data_fim IS NULL;
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_imoveis_disponiveis AS
SELECT
    i.id_imovel,
    i.endereco,
    i.tipo,
    i.preco,
    i.observacoes,
    cor.nome AS corretor_responsavel,
    cor.creci,
    g.data_inicio AS gestao_desde
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
WHERE i.status = 'disponível'
  AND g.data_fim IS NULL;
```

**O que mudou?**

> Foi adicionada a coluna `gestao_desde`, com a data em que o corretor assumiu o imóvel (`gestoes.data_inicio`). O `CREATE OR REPLACE VIEW` substitui a definição existente sem precisar apagar a VIEW antes.

---

# 9. DROP VIEW — exercício controlado

**Código utilizado:**

```sql
CREATE VIEW vw_teste AS
SELECT
    id_cliente,
    nome
FROM clientes
WHERE tipo_interesse = 'compra';

SELECT * FROM vw_teste;

DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

> O `DROP VIEW` remove apenas a consulta salva, e os dados continuam intactos nas tabelas base (a tabela `clientes` não foi afetada). O `DROP TABLE` remove a tabela inteira, com a estrutura e todos os dados dela.

---

# 10. Validando as Views

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

1. vw_imoveis_disponiveis
2. vw_resumo_corretores
3. vw_visitas_detalhadas

> A `vw_teste` não aparece, pois foi removida com `DROP VIEW`.

---

# 11. Teste de atualização dos dados-base

**VIEW testada:**

```text
vw_imoveis_disponiveis
```

**Alteração realizada:**

```sql
-- Antes
SELECT id_imovel, endereco, tipo
FROM vw_imoveis_disponiveis;

-- Alteração na tabela base
UPDATE imoveis
SET status = 'alugado'
WHERE id_imovel = 3;

-- Depois
SELECT id_imovel, endereco, tipo
FROM vw_imoveis_disponiveis;

-- Reverter
UPDATE imoveis
SET status = 'disponível'
WHERE id_imovel = 3;
```

**Resultado observado:**

> Esperado: antes da alteração, a VIEW mostra 5 imóveis disponíveis (2, 3, 4, 5 e 6). Depois do `UPDATE`, o imóvel 3 (sala comercial) some da VIEW e restam 4. Isso mostra que a VIEW não guarda dados: ela executa a consulta na hora, sempre sobre os dados atuais. Depois reverti o status para manter os dados originais. *(confirmar o resultado obtido no Workbench)*

---

# 12. Validação prática obrigatória

**View escolhida:**

```sql
CREATE VIEW vw_visitas_detalhadas AS
SELECT
    v.id_visita,
    c.nome AS cliente,
    c.contato,
    i.endereco,
    i.tipo,
    v.data_visita,
    v.status AS status_visita
FROM visitas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN imoveis AS i
    ON v.id_imovel = i.id_imovel;
```

> 1. **Tabelas das quais depende:** `visitas`, `clientes` e `imoveis`.
> 2. **Relacionamentos utilizados:** `visitas.id_cliente = clientes.id_cliente` e `visitas.id_imovel = imoveis.id_imovel` (duas FKs da tabela `visitas`, ligadas às PKs das outras duas).
> 3. **Campos apresentados:** id da visita, nome e contato do cliente, endereço e tipo do imóvel, data e situação da visita.
> 4. **Problema que resolve:** evita reescrever o JOIN de três tabelas toda vez que alguém precisa da agenda de visitas com nomes e endereços legíveis, em vez de apenas números de ID.
> 5. **O que muda se os dados originais forem alterados:** a VIEW acompanha automaticamente. Se uma visita for inserida, cancelada ou removida, ou se o nome de um cliente mudar, a próxima consulta à VIEW já mostra o dado atualizado, pois ela não armazena dados, apenas a consulta.

---

# 13. Quantidade mínima exigida

| Exigência | Atendida em |
|---|---|
| 3 VIEWs úteis | itens 4, 5 e 6 |
| 1 VIEW com relacionamento | item 4 (`vw_visitas_detalhadas`) |
| 1 VIEW com agregação ou resumo | item 5 (`vw_resumo_corretores`) |
| 1 CREATE OR REPLACE VIEW | item 8 |
| 1 teste com DROP VIEW | item 9 |

---

# 14. Estrutura do SPRINT3-5.sql

O arquivo segue a estrutura recomendada: VIEW 1, VIEW 2, VIEW 3, consultas sobre as views, `CREATE OR REPLACE VIEW`, view temporária, `DROP VIEW`, validação com `SHOW FULL TABLES` e teste de atualização dos dados-base.

---

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 16. Uso de LLMs

Foi utilizada uma LLM como apoio para estruturar as Views. O código foi compreendido, adaptado, executado, testado e validado no MySQL Workbench, e consigo explicar presencialmente qualquer View entregue.

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

Mesma branch:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT3-5.md
Module-2/SPRINT3-5.sql
```

Commit:

```text
Conclui Module 2 Sprint 3 de 5 - views
```

Pull Request final não aberto.
