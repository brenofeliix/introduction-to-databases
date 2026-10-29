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

> Vinícius Eduardo Lima de Assis.

**Branch:**

```text
team-09
```

**Nome do banco:**

```text
pacote_viagens
```

**Tema do projeto:**

> Sistema de Gestão e Reserva de Pacotes de Viagens.

---

# 3. Retomada do banco

Liste as principais tabelas que serão utilizadas.

| Nº | Tabela | PK | Principais FKs |
|---:|---|---|---|
| 1 | destino | id_destino | Nenhuma |
| 2 | cliente | id_cliente | Nenhuma |
| 3 | transporte | id_transporte | Nenhuma |
| 4 | hospedagem | id_hospedagem | id_destino |
| 5 | reserva_pacote | id_reserva | id_cliente, id_hospedagem, id_transporte |

---

# 4. Relacionamentos existentes

| Tabela A | Cardinalidade | Tabela B | FK utilizada |
|---|---|---|---|
| destino | 1:N | hospedagem | hospedagem.id_destino |
| cliente | 1:N | reserva_pacote | reserva_pacote.id_cliente |
| hospedagem | 1:N | reserva_pacote | reserva_pacote.id_hospedagem |
| transporte | 1:N | reserva_pacote | reserva_pacote.id_transporte |

---

# 5. INNER JOIN

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

> Quais hospedagens estão cadastradas e a quais destinos (nome e estado) elas pertencem?

**Tabelas utilizadas:**

```text
hospedagem, destino
```

**PK/FK utilizadas:**

```text
destino.id_destino (PK), hospedagem.id_destino (FK)
```

**SQL:**

```sql
-- SELECT 
    h.nome AS hospedagem,
    h.tipo,
    h.valor_diaria,
    d.nome AS destino,
    d.estado
FROM hospedagem AS h
INNER JOIN destino AS d
    ON h.id_destino = d.id_destino;
```

**Explique o resultado:**

> Retorna apenas as hospedagens que possuem um destino devidamente associado, relacionando as informações do hotel/pousada com a cidade/localização de destino.

## Consulta INNER JOIN 2

**Pergunta:**

> Quais clientes realizaram reservas e qual a data e quantidade de pessoas de cada reserva?

```sql
-- SELECT 
    c.nome AS cliente,
    r.data_reserva,
    r.quantidade_pessoas
FROM cliente AS c
INNER JOIN reserva_pacote AS r
    ON c.id_cliente = r.id_cliente;
```

**Explique:**

> Associa os dados dos clientes com as suas respectivas reservas cadastradas, omitindo clientes que ainda não efetuaram nenhuma reserva.

---

# 6. LEFT JOIN

O `LEFT JOIN` mantém todos os registros da tabela à esquerda, mesmo quando não existe correspondência na tabela da direita.

## Consulta obrigatória

**Pergunta:**

> Liste todos os clientes e suas respectivas reservas (caso existam).

```sql
-- SELECT 
    c.nome AS cliente,
    c.email,
    r.id_reserva,
    r.data_reserva
FROM cliente AS c
LEFT JOIN reserva_pacote AS r
    ON c.id_cliente = r.id_cliente;
```

**O que o LEFT JOIN permite visualizar neste caso?**

> Permite visualizar todos os clientes cadastrados no sistema, inclusive aqueles que não possuem nenhuma reserva efetuada (exibindo valores NULL nas colunas da reserva).

---

# 7. RIGHT JOIN

O `RIGHT JOIN` mantém todos os registros da tabela da direita, mesmo quando não existe correspondência na tabela da esquerda.

## Consulta obrigatória

**Pergunta:**

> Liste todas as hospedagens e as reservas associadas a elas.

```sql
-- SELECT 
    r.id_reserva,
    r.data_reserva,
    h.nome AS hospedagem,
    h.valor_diaria
FROM reserva_pacote AS r
RIGHT JOIN hospedagem AS h
    ON r.id_hospedagem = h.id_hospedagem;
```

**Explique o resultado:**

> Retorna todas as hospedagens da tabela à direita (hospedagem), mesmo aquelas que ainda não receberam nenhuma reserva, garantindo a visualização de todos os hotéis/pousadas do catálogo.

---

# 8. JOIN com três ou mais tabelas

Crie duas consultas envolvendo pelo menos três tabelas.

## Consulta 1

**Pergunta:**

> Quais clientes reservaram hospedagens e qual o destino dessas hospedagens?

```sql
-- SELECT 
    c.nome AS cliente,
    h.nome AS hospedagem,
    d.nome AS destino,
    d.pais
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino;
```

## Consulta 2

**Pergunta:**

> Qual o detalhamento completo de cada reserva, incluindo cliente, hospedagem e transporte utilizado?

```sql
-- SELECT 
    r.id_reserva,
    c.nome AS cliente,
    h.nome AS hospedagem,
    t.empresa AS empresa_transporte,
    t.tipo AS tipo_transporte,
    r.data_reserva
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte;
```

---

# 9. JOIN + WHERE

**Pergunta:**

> Quais clientes reservaram hospedagens com diária superior a R$ 1.000,00?

```sql
-- SELECT 
    c.nome AS cliente,
    h.nome AS hospedagem,
    h.valor_diaria
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
WHERE h.valor_diaria > 1000.00;
```

**Explique o filtro:**

> O filtro WHERE h.valor_diaria > 1000.00 restringe o resultado da junção apenas para as reservas em que a diária da hospedagem selecionada ultrapassa R$ 1.000,00.

---

# 10. JOIN + ORDER BY

**Pergunta:**

> Quais são os destinos e suas respectivas hospedagens, ordenadas da diária mais cara para a mais barata?

```sql
-- SELECT 
    d.nome AS destino,
    h.nome AS hospedagem,
    h.valor_diaria
FROM hospedagem AS h
INNER JOIN destino AS d ON h.id_destino = d.id_destino
ORDER BY h.valor_diaria DESC;
```

---

# 11. JOIN + GROUP BY + agregação

Crie uma consulta que combine tabelas e utilize ao menos uma função de agregação.

**Pergunta:**

> Qual o total de pessoas reservadas por nome de destino?

```sql
-- SELECT 
    d.nome AS destino,
    SUM(r.quantidade_pessoas) AS total_pessoas
FROM reserva_pacote AS r
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino
GROUP BY d.nome;
```

**Explique o agrupamento:**

> A consulta agrupa os registros pelo nome do destino e calcula a soma total de viajantes (SUM(r.quantidade_pessoas)) que fizeram reservas para hospedagens situados em cada um desses destinos.

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

> Qual é o resumo executivo de todas as reservas ativas, apresentando o cliente, hospedagem, transporte, número de passageiros e data?

```sql
-- SELECT 
    r.id_reserva,
    c.nome AS cliente,
    h.nome AS hospedagem,
    t.tipo AS modal,
    t.empresa AS transporte,
    r.quantidade_pessoas,
    r.data_reserva
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte
ORDER BY r.data_reserva ASC;
```

**Por que ela é útil?**

> É a consulta operacional mais completa para a agência de viagens, pois consolida em uma única visão todas as pontas do pacote vendido (cliente, estadia e transporte), facilitando a emissão de relatórios e vouchers.
---

# 14. Validação prática obrigatória

Escolha uma consulta produzida nesta Sprint.

```sql
-- SELECT 
    h.nome AS hospedagem,
    h.tipo,
    h.valor_diaria,
    d.nome AS destino,
    d.estado
FROM hospedagem AS h
INNER JOIN destino AS d
    ON h.id_destino = d.id_destino;
```

Explique:

1. quais tabelas participam;
2. qual PK está sendo utilizada;
3. qual FK está sendo utilizada;
4. o que a cláusula `ON` faz;
5. o que ocorreria se a condição de relacionamento estivesse errada.

> 1. Participam as tabelas hospedagem (com o alias h) e destino (com o alias d); 2. A Chave Primária utilizada é id_destino da tabela destino (d.id_destino); 3. A Chave Estrangeira utilizada é id_destino da tabela hospedagem (h.id_destino), que faz referência à PK da tabela destino; 4. A cláusula ON (h.id_destino = d.id_destino) estabelece a condição de junção relacional. Ela garante que cada registro de hospedagem seja combinado estritamente com o registro correspondente da tabela de destinos; 5. Se a condição estivesse errada (ou ausente), ocorreria um produto cartesiano (onde todas as hospedagens seriam associadas a todos os destinos cadastrados), gerando combinações falsas/incoerentes de dados no resultado da consulta.

---

# 15. Teste no MySQL Workbench

**Consulta executada:**

```sql
-- SELECT 
    c.nome AS cliente,
    h.nome AS hospedagem,
    d.nome AS destino
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino;
```

**Resultado esperado:**

> A lista exibindo o nome dos clientes, as hospedagens reservados e o nome do destino correspondente para cada reserva existente.

**Resultado obtido:**

> Retornou com sucesso os registros de reservas ativas vinculando corretamente clientes como 'Carlos Silva' e 'Mariana Oliveira' às suas respectivas estadias e destinos sem erros de sintaxe ou inconsistência de chave.

---

# 16. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Ambiguidade no nome de colunas (ex: nome) | A coluna nome existe em várias tabelas (cliente, destino, hospedagem) | Utilização de alias explícitos (h.nome AS hospedagem, d.nome AS destino) |
|  |  |  |
|  |  |  |

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

```sql
-- MODULE 2 — SPRINT 1/5
-- JOINS E CONSULTAS RELACIONAIS

-- Aluno:
-- Banco:

USE nome_do_banco;

-- INNER JOIN 1

-- INNER JOIN 2

-- LEFT JOIN

-- RIGHT JOIN

-- JOIN COM 3+ TABELAS 1

-- JOIN COM 3+ TABELAS 2

-- JOIN + WHERE

-- JOIN + ORDER BY

-- JOIN + GROUP BY + AGREGAÇÃO
```

---

# 19. Checklist

- [x] utilizei o mesmo banco do Module-1;
- [x] identifiquei PKs e FKs;
- [x] produzi 2 `INNER JOIN`;
- [x] produzi 1 `LEFT JOIN`;
- [x] produzi 1 `RIGHT JOIN`;
- [x] produzi consultas com 3 ou mais tabelas;
- [x] utilizei `WHERE`;
- [x] utilizei `ORDER BY`;
- [x] utilizei agregação e `GROUP BY`;
- [x] as consultas respondem perguntas reais;
- [x] testei tudo no MySQL Workbench;
- [x] consigo explicar as consultas;
- [x] salvei `SPRINT1-5.md`;
- [x] salvei `SPRINT1-5.sql`.

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
