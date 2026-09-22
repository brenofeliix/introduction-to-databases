# SPRINT 4/5 — Consultas SQL e Expressões

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual / Equipe  
**Aluna:** Célia Hiromi Watanabe (Team 03)  
**Entrega desta Sprint:** `SPRINT4-5.md` + `SPRINT4-5.sql`  

---

# Objetivo da Sprint 4/5

Nesta etapa, cada aluno deverá utilizar o banco de dados desenvolvido nas Sprints anteriores para consultar, filtrar, ordenar, agrupar e resumir os dados armazenados.

Nesta Sprint serão trabalhados principalmente:

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

Ao final da atividade, o aluno deverá entregar:

```text
SPRINT4-5.md
SPRINT4-5.sql
```

O arquivo `.md` documentará as consultas e o raciocínio utilizado.  
O arquivo `.sql` conterá todas as consultas efetivamente executadas e testadas no MySQL Workbench.

> Utilize obrigatoriamente o mesmo banco criado nas Sprints anteriores.

---

# 1. Antes de começar

1. Abra o MySQL Workbench.
2. Abra sua conexão (`Local instance 3306`).
3. Confirme que o banco da Sprint 2/5 (`db_salao_beleza`) existe.
4. Confirme que os dados da Sprint 3/5 estão disponíveis.
5. Selecione o banco:

```sql
USE db_salao_beleza;
```

6. Confira os dados:

```sql
SELECT * FROM cliente;
SELECT * FROM profissional;
SELECT * FROM servico;
SELECT * FROM agendamento;
```

---

# 2. Crie o arquivo SPRINT4-5.sql

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
teams/Teams-UNEMAT/team-03/SPRINT4-5.sql
```

Esse arquivo contém todas as consultas SQL desenvolvidas, testadas e validadas nesta Sprint.

---

# 3. Retome as perguntas da Sprint 1/5

As perguntas estratégicas planejadas na Sprint 1/5 foram resgatadas e refinadas:

1. **Quais clientes estão cadastrados no salão, ordenados por nome?**  
   *Exige:* Projeção (`SELECT`) e ordenação (`ORDER BY`).
2. **Quais serviços possuem valor superior a R$ 70,00?**  
   *Exige:* Projeção e filtro relacional (`WHERE >`).
3. **Quais agendamentos estão confirmados para uma data específica?**  
   *Exige:* Filtro composto com múltiplos critérios (`WHERE ... AND`).
4. **Quantos agendamentos existem agrupados por status e por profissional?**  
   *Exige:* Agrupamento (`GROUP BY`) e função de agregação (`COUNT`).
5. **Qual é o faturamento total acumulado e a média de preços dos procedimentos?**  
   *Exige:* Funções agregadas de resumo (`SUM`, `AVG`, `MIN`, `MAX`).

---

# 4. SELECT

## Consulta 1

### Pergunta respondida

> Quais são todos os dados cadastrais dos clientes registrados no sistema?

### SQL

```sql
SELECT *
FROM cliente;
```

### Explique o resultado

> A consulta retorna todos os atributos e registros da tabela `cliente`, permitindo à recepção visualizar a lista completa de clientes cadastrados, com seus IDs, nomes, CPFs, números de telefone e e-mails de contato.

---

## Consulta 2 (Colunas Específicas)

### Pergunta respondida

> Qual é o catálogo simplificado de procedimentos disponíveis, exibindo o nome do serviço, o tempo estimado de atendimento e o valor cobrado?

### SQL

```sql
SELECT nome_servico, duracao_minutos, preco
FROM servico;
```

### Explique o resultado

> Projeta apenas as três colunas de interesse do catálogo de serviços, omitindo chaves primárias internas e oferecendo uma listagem limpa para exibição em tabelas de preços ou cardápios de atendimento.

---

# 5. WHERE

## Consulta obrigatória com WHERE

### Pergunta respondida

> Quais são os serviços do salão com valor superior a R$ 70,00 (serviços de ticket mais elevado)?

### SQL

```sql
SELECT nome_servico, preco
FROM servico
WHERE preco > 70.00;
```

### Explique o filtro

> A cláusula `WHERE preco > 70.00` filtra os registros na tabela `servico`, retornando apenas os procedimentos com maior valor agregado (como Maquiagem Social R$ 150.00, Limpeza de Pele R$ 120.00, Escova e Hidratação R$ 95.00 e Corte Feminino R$ 80.00).

---

## Consulta com mais de uma condição (WHERE composto)

### Pergunta respondida

> Quais agendamentos estão com status pendente ('Agendado') para atendimento no dia 15/09/2026?

### SQL

```sql
SELECT id_agendamento, id_cliente, id_profissional, id_servico, data_hora, status
FROM agendamento
WHERE status = 'Agendado'
  AND data_hora >= '2026-09-15 00:00:00'
  AND data_hora <= '2026-09-15 23:59:59';
```

### Explique o filtro

> O operador lógico `AND` combina o filtro de status (`status = 'Agendado'`) com o intervalo de data e hora do dia especificado, identificando exatamente os clientes que devem comparecer ao salão nessa data.

---

# 6. ORDER BY

## Consulta obrigatória com ORDER BY

### Pergunta respondida

> Como emitir uma listagem alfabética de todos os clientes cadastrados com seus respectivos contatos?

### SQL

```sql
SELECT nome, telefone, email
FROM cliente
ORDER BY nome ASC;
```

### Explique a ordenação

> A cláusula `ORDER BY nome ASC` classifica os registros por ordem alfabética de A a Z, facilitando a busca rápida de fichas cadastrais pela equipe da recepção.

---

## Consulta com ORDER BY decrescente

### Pergunta respondida

> Quais são os procedimentos ofertados ordenados do maior valor para o mais barato?

### SQL

```sql
SELECT nome_servico, duracao_minutos, preco
FROM servico
ORDER BY preco DESC;
```

---

# 7. Funções de agregação

As funções de agregação foram aplicadas sobre a tabela de serviços e agendamentos para gerar métricas de negócio e indicadores de desempenho.

---

# 8. Consultas obrigatórias com agregação

## COUNT

```sql
SELECT 
    (SELECT COUNT(*) FROM cliente) AS total_clientes,
    (SELECT COUNT(*) FROM agendamento) AS total_agendamentos;
```

**Pergunta respondida:**

> Quantos clientes e quantos agendamentos no total estão cadastrados no banco de dados?

---

## SUM

```sql
SELECT SUM(preco) AS faturamento_total_catalogo
FROM servico;
```

**Pergunta respondida:**

> Qual seria o faturamento somado se todos os serviços ofertados no catálogo fossem contratados exatamente uma vez (R$ 560,00)?

---

## AVG

```sql
SELECT 
    ROUND(AVG(preco), 2) AS preco_medio_servicos,
    ROUND(AVG(duracao_minutos), 1) AS duracao_media_minutos
FROM servico;
```

**Pergunta respondida:**

> Qual é o preço médio cobrado pelos procedimentos do salão (R$ 93,33) e qual é o tempo médio de duração de cada atendimento (53,3 minutos)?

---

## MIN ou MAX

```sql
SELECT 
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM servico;
```

**Pergunta respondida:**

> Qual é o serviço mais barato do catálogo (Corte Masculino a R$ 50,00) e qual é o de maior valor (Maquiagem Social a R$ 150,00)?

---

# 9. GROUP BY

## Consulta obrigatória com GROUP BY

### Pergunta respondida

> Quantos agendamentos existem agrupados por status de atendimento (quantos estão 'Agendados' e quantos estão 'Concluídos')?

### SQL

```sql
SELECT 
    status,
    COUNT(*) AS quantidade_agendamentos
FROM agendamento
GROUP BY status;
```

### Explique o agrupamento

> A instrução `GROUP BY status` agrupa as linhas da tabela `agendamento` pelo valor da coluna `status` e calcula a quantidade total de registros em cada categoria através do `COUNT(*)`, permitindo ao gestor monitorar a taxa de conclusão dos atendimentos.

---

## Consulta adicional de agrupamento (Produtividade por Profissional)

```sql
SELECT 
    id_profissional,
    COUNT(*) AS total_atendimentos
FROM agendamento
GROUP BY id_profissional
ORDER BY total_atendimentos DESC;
```

---

# 10. HAVING

## Consulta obrigatória com HAVING

### Pergunta respondida

> Quais status de agendamentos concentram mais de 1 atendimento registrado no sistema?

### SQL

```sql
SELECT 
    status,
    COUNT(*) AS quantidade
FROM agendamento
GROUP BY status
HAVING COUNT(*) > 1;
```

### Por que HAVING foi necessário?

> A cláusula `WHERE` só é capaz de filtrar linhas individuais antes do agrupamento. Como o critério de seleção depende do resultado de uma função agregada (`COUNT(*) > 1`), o uso do `HAVING` é indispensável para filtrar os grupos gerados após o `GROUP BY`.

---

# 11. Expressões SQL

## Consulta com expressão

```sql
SELECT 
    nome_servico,
    preco AS preco_original,
    ROUND(preco * 0.15, 2) AS valor_desconto_15,
    ROUND(preco * 0.85, 2) AS preco_promocional_com_desconto
FROM servico
ORDER BY preco_original DESC;
```

### Explique o cálculo

> A consulta calcula uma política promocional de fidelidade: multiplica o valor do serviço por `0.15` para extrair o valor líquido do desconto concedido e por `0.85` para gerar o preço final com 15% de abatimento, utilizando a função `ROUND(..., 2)` para formatar os centavos com precisão decimal.

---

# 12. Consultas mínimas exigidas

Todas as 12 exigências formais foram cumpridas no script:

- [x] 1 SELECT básico (`cliente`)
- [x] 1 SELECT com colunas específicas (`servico`)
- [x] 1 consulta com WHERE (`preco > 70.00`)
- [x] 1 consulta com mais de uma condição (`WHERE status = 'Agendado' AND data_hora ...`)
- [x] 1 consulta com ORDER BY (`ORDER BY nome ASC` e `ORDER BY preco DESC`)
- [x] 1 consulta com COUNT (`COUNT(*)`)
- [x] 1 consulta com SUM (`SUM(preco)`)
- [x] 1 consulta com AVG (`AVG(preco)` e `AVG(duracao_minutos)`)
- [x] 1 consulta com MIN ou MAX (`MIN(preco)` e `MAX(preco)`)
- [x] 1 consulta com GROUP BY (`GROUP BY status` e `GROUP BY id_profissional`)
- [x] 1 consulta com HAVING (`HAVING COUNT(*) > 1`)
- [x] 1 consulta com expressão (`preco * 0.85`)

---

# 13. Evite consultas sem significado

Todas as consultas desenvolvidas respondem a necessidades operacionais, gerenciais ou financeiras verídicas do salão de beleza, evitando consultas vazias ou meramente sintáticas.

---

# 14. Modelo genérico para adaptar

O modelo teórico disponibilizado pelo professor foi inteiramente adaptado com os nomes reais das entidades, colunas e relacionamentos do schema `db_salao_beleza`.

---

# 15. Estrutura recomendada do SPRINT4-5.sql

O arquivo `SPRINT4-5.sql` foi estruturado em módulos claros e comentados:
- Seleção do schema (`USE db_salao_beleza;`)
- 1. Consultas Básicas
- 2. Filtros com WHERE (simples e composto)
- 3. Ordenação com ORDER BY (crescente e decrescente)
- 4. Funções de Agregação (COUNT, SUM, AVG, MIN, MAX)
- 5. Agrupamento com GROUP BY
- 6. Filtro de Grupos com HAVING
- 7. Expressões e Cálculos em SQL
- 8. Consulta Relacional Extra com INNER JOIN

---

# 16. Passo a passo no MySQL Workbench

1. **Etapa 1:** Conectar no MySQL Workbench e selecionar o schema `db_salao_beleza`;
2. **Etapa 2:** Abrir o arquivo `teams/Teams-UNEMAT/team-03/SPRINT4-5.sql`;
3. **Etapa 3:** Posicionar o cursor sobre cada consulta e pressionar `Ctrl + Enter` (ou rodar em lote com o raio ⚡);
4. **Etapa 4:** Analisar os resultados retornados no painel **Result Grid**;
5. **Etapa 5:** Salvar o arquivo no repositório.

---

# 17. Registro das consultas

| Nº | Pergunta | Recursos SQL utilizados | Funcionou? |
|---:|---|---|:---:|
| 1 | Quais os dados completos dos clientes? | `SELECT *` | Sim |
| 2 | Qual a relação resumida de serviços disponíveis? | `SELECT colunas` | Sim |
| 3 | Quais serviços custam mais de R$ 70,00? | `WHERE preco > 70.00` | Sim |
| 4 | Quais agendamentos estão marcados para 15/09? | `WHERE ... AND ...` | Sim |
| 5 | Quais clientes em ordem alfabética? | `ORDER BY nome ASC` | Sim |
| 6 | Quais procedimentos mais caros em ordem decrescente? | `ORDER BY preco DESC` | Sim |
| 7 | Quantos clientes e agendamentos existem? | `COUNT(*)` | Sim |
| 8 | Qual o faturamento total somado do catálogo? | `SUM(preco)` | Sim |
| 9 | Qual o preço médio e a duração média dos serviços? | `AVG(preco)`, `AVG(duracao_minutos)` | Sim |
| 10 | Qual o menor e o maior preço do salão? | `MIN(preco)`, `MAX(preco)` | Sim |
| 11 | Quantos agendamentos por status? | `GROUP BY status`, `COUNT(*)` | Sim |
| 12 | Qual a produtividade por profissional? | `GROUP BY id_profissional`, `COUNT(*)` | Sim |
| 13 | Quais status possuem mais de 1 atendimento? | `GROUP BY`, `HAVING COUNT(*) > 1` | Sim |
| 14 | Qual a tabela de preços com 15% de desconto fidelidade? | Expressão `ROUND(preco * 0.85, 2)` | Sim |
| 15 | Qual o relatório geral de agendamentos com nomes e serviços? | `INNER JOIN` entre 4 tabelas | Sim |

---

# 18. Consulta mais útil

### Pergunta

> Qual é o relatório executivo integrado de todos os agendamentos cadastrados, apresentando o nome completo do cliente, o profissional alocado, sua especialidade, o nome do serviço contratado, o valor, a data/horário e o status?

### SQL

```sql
SELECT 
    a.id_agendamento,
    c.nome AS nome_cliente,
    p.nome AS nome_profissional,
    p.especialidade,
    s.nome_servico,
    s.preco,
    a.data_hora,
    a.status,
    a.forma_pagamento
FROM agendamento a
INNER JOIN cliente c ON a.id_cliente = c.id_cliente
INNER JOIN profissional p ON a.id_profissional = p.id_profissional
INNER JOIN servico s ON a.id_servico = s.id_servico
ORDER BY a.data_hora ASC;
```

### Por que ela é útil?

> Esta consulta é a mais útil de todo o sistema porque integra as 4 tabelas fundamentais do salão em uma única visão humana e operacional. Em vez de exibir apenas números de IDs estrangeiros incompreensíveis, ela entrega exatamente a planilha de trabalho que a recepcionista e os gerentes precisam para o dia a dia.

---

# 19. Consulta mais complexa

### Pergunta

> Quais status de agendamentos reúnem volume superior a um atendimento registrado no salão, filtrando após o agrupamento?

### SQL

```sql
SELECT 
    status,
    COUNT(*) AS quantidade
FROM agendamento
GROUP BY status
HAVING COUNT(*) > 1;
```

### Qual foi a dificuldade?

> A complexidade reside na diferenciação conceitual entre o filtro de linhas individuais (`WHERE`) e o filtro de grupos consolidados (`HAVING`). Foi necessário compreender a ordem de processamento do MySQL (primeiro agrupa os registros por status e calcula a contagem acumulada, e só depois aplica a condição de corte `HAVING`).

---

# 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Retorno de casas decimais extensas no cálculo de médias | Divisão de valores gerando dízimas periódicas no `AVG` | Utilizada a função `ROUND(AVG(...), 2)` para padronizar em 2 casas decimais monetárias |
| Filtragem incorreta de data em coluna `DATETIME` | Comparar apenas a data sem considerar a hora | Utilizado intervalo com operador `>= '2026-09-15 00:00:00' AND <= '2026-09-15 23:59:59'` |
| Ambiguidade potencial de colunas em junções | Colunas com nomes semelhantes em tabelas distintas | Utilizados aliases explícitos (`a`, `c`, `p`, `s`) para garantir clareza e precisão |

---

# 21. Uso de LLMs nesta Sprint

O apoio de LLM foi utilizado de acordo com as boas práticas recomendadas:
- Estruturação de consultas SQL com precisão analítica;
- Formulação de filtros compostos com operadores de data;
- Compreensão e distinção entre cláusulas `WHERE` e `HAVING`;
- Validação e execução de 100% dos códigos no MySQL Workbench.

---

# 22. O que deve existir ao final da Sprint 4/5

```text
SPRINT1-5.md
SPRINT2-5.md
SPRINT2-5.sql
SPRINT3-5.md
SPRINT3-5.sql
SPRINT4-5.md
SPRINT4-5.sql
```

Todos os arquivos anteriores foram rigorosamente preservados na pasta `teams/Teams-UNEMAT/team-03/`.

---

# 23. Checklist da Sprint 4/5

- [x] utilizei o banco das Sprints anteriores (`db_salao_beleza`);
- [x] confirmei que existem dados suficientes;
- [x] utilizei `SELECT`;
- [x] selecionei colunas específicas;
- [x] utilizei `WHERE`;
- [x] utilizei mais de uma condição (`AND`);
- [x] utilizei `ORDER BY` (crescente e decrescente);
- [x] utilizei `COUNT`;
- [x] utilizei `SUM`, quando aplicável;
- [x] utilizei `AVG`, quando aplicável;
- [x] utilizei `MIN` ou `MAX`;
- [x] utilizei `GROUP BY`;
- [x] utilizei `HAVING`;
- [x] utilizei aliases com `AS`;
- [x] utilizei expressão SQL quando aplicável (`desconto`);
- [x] minhas consultas respondem perguntas reais do salão de beleza;
- [x] testei as consultas no MySQL Workbench com êxito;
- [x] salvei o código em `SPRINT4-5.sql`;
- [x] preenchi completamente o `SPRINT4-5.md`;
- [x] revisei os arquivos antes do commit.

---

# 24. Regras de Git/GitHub

A atividade continua **individual / por equipe**.

Utilize a mesma branch das Sprints anteriores:

```text
team-03-sprints-1-5
```

## Arquivos obrigatórios no commit desta Sprint:

```text
teams/Teams-UNEMAT/team-03/SPRINT4-5.md
teams/Teams-UNEMAT/team-03/SPRINT4-5.sql
```

## Mensagem sugerida pelo professor:

```text
Conclui Sprint 4 de 5 - consultas SQL
```

---

# 25. Pull Request

> **Ainda não abra o Pull Request final.**  
> O PR será aberto exclusivamente após a conclusão da Sprint 5/5.

---

# 26. Critério de conclusão da Sprint 4/5

A Sprint 4/5 está plenamente concluída atendendo a todos os requisitos:

1. Utilizou os dados e tabelas populados nas Sprints anteriores;
2. Elaborou consultas coerentes e ricas com o domínio do salão;
3. Utilizou corretamente comandos de projeção, filtragem, ordenação, agregação e agrupamento;
4. Respondeu às perguntas estratégicas do sistema;
5. Executou e validou todas as consultas no MySQL Workbench;
6. Documentou detalhadamente o trabalho no `SPRINT4-5.md`;
7. Salvou o código executável em `SPRINT4-5.sql`;
8. Arquivos prontos para o commit na branch.

---

# Próxima etapa

Na **Sprint 5/5**, o projeto será revisado, integrado e preparado para a entrega final:

- revisão geral da estrutura DDL e restrições;
- revisão das operações DML e consultas SQL;
- consolidação do script final integrador;
- preparação e abertura do **Pull Request final** para a branch `main`.
