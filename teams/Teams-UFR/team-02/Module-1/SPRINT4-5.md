# SPRINT 4/5 — Consultas SQL e Expressões

**Disciplina:** Laboratório de Banco de Dados
**Modalidade:** Atividade individual
**Aluno:** Rafael Tokashiki Souza
**Banco:** `imobiliaria`
**Entrega desta Sprint:** `SPRINT4-5.md` + `SPRINT4-5.sql`

---

# 1. Antes de começar

Utilizei o banco `imobiliaria`, com a estrutura criada na Sprint 2/5 e os dados
inseridos na Sprint 3/5. Antes de começar, confirmei os totais de cada tabela:

| Tabela | Registros |
|---|---:|
| proprietarios | 5 |
| clientes | 4 |
| corretores | 5 |
| imoveis | 8 |
| visitas | 5 |
| contratos | 3 |

Os dados são suficientes para as consultas desta Sprint: existem seis tipos
diferentes de imóvel (permitindo `GROUP BY`), duas finalidades (venda e
aluguel), faixas de preço bem distintas (de R$ 950,00 a R$ 1.150.000,00) e
proprietários com quantidades diferentes de imóveis (permitindo `HAVING`).

---

# 3. Retome as perguntas da Sprint 1/5

As perguntas definidas no planejamento foram:

1. Quais imóveis estão disponíveis para venda em um determinado bairro?
2. Quais imóveis de aluguel custam até um valor definido pelo cliente?
3. Quantos imóveis existem na carteira em cada tipo?
4. Qual é o preço médio dos imóveis por finalidade?
5. Quem é o proprietário de cada imóvel da carteira?
6. Quantas visitas cada corretor realizou em um determinado período?
7. Quais imóveis receberam mais visitas e ainda não foram vendidos ou alugados?
8. Qual foi o valor total dos contratos fechados por corretor?

Classificação por recurso SQL necessário:

| Pergunta | Recurso necessário |
|---|---|
| 1 e 2 | `WHERE` com múltiplas condições |
| 3 | `GROUP BY` + `COUNT` |
| 4 | `GROUP BY` + `AVG` |
| 5 | `INNER JOIN` |
| 6 e 8 | `JOIN` + `GROUP BY` + agregação |
| 7 | `GROUP BY` + `HAVING` |

---

# 4. SELECT

## Consulta 1

### Pergunta respondida

> Quais imóveis estão cadastrados na carteira?

### SQL

```sql
SELECT * FROM imoveis;
```

### Explique o resultado

Retorna os 8 imóveis com todas as 15 colunas, incluindo `valor_condominio`,
acrescentada pelo `ALTER TABLE` da Sprint 2/5. É a consulta de conferência
geral: serve para verificar o estado da tabela, mas não é adequada para uso
diário, porque traz colunas que o corretor não precisa ver na tela.

## Consulta 2 — colunas específicas

```sql
SELECT titulo,
       tipo,
       bairro,
       quartos,
       preco
FROM imoveis;
```

Esta versão traz só o que interessa em um anúncio. Selecionar colunas
específicas em vez de `*` reduz o volume de dados trafegado e deixa o resultado
legível.

---

# 5. WHERE

## Consulta obrigatória com WHERE

### Pergunta respondida

> Quais imóveis de aluguel custam até R$ 2.000,00 e ainda estão disponíveis?
> (pergunta 2 do planejamento)

### SQL

```sql
SELECT titulo, bairro, preco, valor_condominio
FROM imoveis
WHERE finalidade = 'Aluguel'
  AND preco <= 2000.00
  AND disponivel = TRUE;
```

### Explique o filtro

São três condições ligadas por `AND`, e todas precisam ser verdadeiras ao mesmo
tempo. A terceira é a mais importante do ponto de vista do negócio: sem
`disponivel = TRUE`, a consulta devolveria também o apartamento do Centro, que
foi alugado na Sprint 3/5 e não pode mais ser oferecido. Mostrar um imóvel já
alugado a um cliente é exatamente o problema que o banco deveria evitar.

## Outros filtros utilizados

Além do `AND`, usei quatro operadores diferentes no `SPRINT4-5.sql`:

| Operador | Consulta | Pergunta |
|---|---|---|
| `BETWEEN` | 05 | Quais imóveis custam entre R$ 280.000 e R$ 500.000? |
| `IN` | 06 | Quais imóveis são casas, sobrados ou apartamentos? |
| `IS NOT NULL` | 07 | Quais contratos possuem data de término? |
| `LIKE` | 08 | Quais imóveis ficam em bairros com "Jardim" no nome? |

A consulta 07 é interessante: como contratos de venda recebem `NULL` em
`data_fim`, o `IS NOT NULL` separa automaticamente as locações das vendas sem
precisar filtrar pelo campo `tipo_contrato`.

---

# 6. ORDER BY

## Consulta obrigatória com ORDER BY

### Pergunta respondida

> Quais são os imóveis mais caros da carteira?

### SQL

```sql
SELECT titulo, tipo, preco
FROM imoveis
ORDER BY preco DESC;
```

O sobrado aparece em primeiro (R$ 1.150.000,00, já com a redução aplicada no
`UPDATE 1` da Sprint 3/5) e a kitnet em último (R$ 950,00).

## Ordenação por duas colunas

```sql
SELECT tipo, titulo, preco
FROM imoveis
ORDER BY tipo ASC, preco DESC;
```

Agrupa visualmente por tipo em ordem alfabética e, dentro de cada tipo, do mais
caro para o mais barato. A segunda coluna do `ORDER BY` só é usada para
desempatar registros que têm o mesmo valor na primeira.

---

# 8. Consultas obrigatórias com agregação

## COUNT

```sql
SELECT COUNT(*) AS total_imoveis
FROM imoveis;
```

**Pergunta respondida:**

> Quantos imóveis existem na carteira?

Resultado: 8.

Também usei `COUNT` com filtro:

```sql
SELECT COUNT(*) AS imoveis_disponiveis
FROM imoveis
WHERE disponivel = TRUE;
```

> Quantos imóveis ainda estão disponíveis para negociação?

Resultado: 6, porque dois saíram da carteira nos `UPDATE` da Sprint 3/5.

## SUM

```sql
SELECT SUM(valor) AS valor_total_contratos
FROM contratos;
```

**Pergunta respondida:**

> Qual é o valor total movimentado pelos contratos fechados?

Soma os três contratos: a venda de R$ 380.000,00 mais as duas locações
(R$ 1.800,00 e R$ 950,00).

## AVG

```sql
SELECT ROUND(AVG(preco), 2) AS preco_medio_venda
FROM imoveis
WHERE finalidade = 'Venda';
```

**Pergunta respondida:**

> Qual é o preço médio dos imóveis à venda?

Usei `ROUND(..., 2)` porque o `AVG` do MySQL devolve o resultado com várias
casas decimais. Para um valor em reais, duas casas bastam.

O `WHERE finalidade = 'Venda'` é essencial aqui: sem ele, a média misturaria
preços de venda (centenas de milhares) com aluguéis (centenas de reais), e o
número resultante não significaria nada.

## MIN e MAX

```sql
SELECT MIN(preco) AS menor_preco,
       MAX(preco) AS maior_preco
FROM imoveis;
```

**Pergunta respondida:**

> Qual é o imóvel mais barato e o mais caro da carteira?

---

# 9. GROUP BY

## Consulta obrigatória com GROUP BY

### Pergunta respondida

> Quantos imóveis existem na carteira em cada tipo? (pergunta 3 do planejamento)

### SQL

```sql
SELECT tipo,
       COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
ORDER BY quantidade DESC;
```

### Explique o agrupamento

O `GROUP BY tipo` junta todas as linhas que têm o mesmo valor na coluna `tipo` e
aplica o `COUNT(*)` a cada grupo separadamente, em vez de contar a tabela
inteira. O resultado tem uma linha por tipo distinto.

A regra que vale lembrar: toda coluna que aparece no `SELECT` sem estar dentro
de uma função de agregação precisa estar no `GROUP BY`. Aqui, `tipo` está nos
dois lugares, e `COUNT(*)` é a agregação.

## GROUP BY com JOIN

```sql
SELECT corretores.nome AS corretor,
       COUNT(visitas.id_visita) AS total_visitas
FROM visitas
INNER JOIN corretores ON visitas.id_corretor = corretores.id_corretor
GROUP BY corretores.nome
ORDER BY total_visitas DESC;
```

> Quantas visitas cada corretor realizou? (pergunta 6 do planejamento)

Sem o `JOIN`, o agrupamento traria apenas `id_corretor` — um número, inútil em
um relatório. O `JOIN` busca o nome na tabela `corretores`, e o agrupamento
passa a ser feito por esse nome.

---

# 10. HAVING

## Consulta obrigatória com HAVING

### Pergunta respondida

> Quais proprietários possuem 2 ou mais imóveis na carteira, e qual o valor
> total que cada um tem conosco?

### SQL

```sql
SELECT proprietarios.nome AS proprietario,
       COUNT(imoveis.id_imovel) AS total_imoveis,
       SUM(imoveis.preco) AS valor_total_carteira
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
GROUP BY proprietarios.nome
HAVING COUNT(imoveis.id_imovel) >= 2
ORDER BY valor_total_carteira DESC;
```

### Por que HAVING foi necessário?

Porque o filtro é sobre o **resultado de uma contagem**, e essa contagem só
existe depois que o agrupamento aconteceu.

A ordem de execução é: `FROM` → `JOIN` → `WHERE` → `GROUP BY` → agregação →
`HAVING`. O `WHERE` roda antes do `GROUP BY`, quando `COUNT(*)` ainda não foi
calculado — por isso `WHERE COUNT(*) >= 2` é um erro de sintaxe no MySQL.

Resumindo a diferença que levei um tempo para entender: **`WHERE` filtra linhas,
`HAVING` filtra grupos.**

Esta consulta é útil comercialmente: identifica os proprietários que concentram
mais imóveis conosco, que são os que merecem atendimento prioritário.

---

# 11. Expressões SQL

## Consulta com expressão

```sql
SELECT titulo,
       preco,
       ROUND(preco * 0.06, 2) AS comissao_6_porcento
FROM imoveis
WHERE finalidade = 'Venda'
ORDER BY comissao_6_porcento DESC;
```

### Explique o cálculo

Multiplica o preço por 0,06 para estimar a comissão de 6% que a imobiliária
receberia em cada venda. O valor não é armazenado em lugar nenhum — é calculado
na hora da consulta.

Essa é a vantagem da expressão: se a taxa mudar, basta alterar a consulta.
Guardar a comissão como coluna na tabela criaria dado redundante, que poderia
ficar desatualizado em relação ao preço.

## Outras expressões utilizadas

```sql
SELECT titulo,
       preco AS aluguel,
       valor_condominio,
       preco + valor_condominio AS custo_mensal_total
FROM imoveis
WHERE finalidade = 'Aluguel'
ORDER BY custo_mensal_total ASC;
```

> Qual é o custo mensal real de cada imóvel de aluguel?

Responde a uma dúvida concreta do cliente: o aluguel anunciado não é o que ele
vai pagar. A kitnet, por exemplo, tem aluguel de R$ 950,00 mas R$ 180,00 de
condomínio.

```sql
SELECT titulo,
       area_m2,
       preco,
       ROUND(preco / area_m2, 2) AS preco_por_m2
FROM imoveis
WHERE finalidade = 'Venda'
  AND area_m2 > 0
ORDER BY preco_por_m2 DESC;
```

> Qual é o preço por metro quadrado de cada imóvel à venda?

Permite comparar imóveis de tamanhos diferentes em uma base justa. O
`AND area_m2 > 0` evita divisão por zero.

---

# 17. Registro das consultas

| Nº | Pergunta | Recursos SQL utilizados | Funcionou? |
|---:|---|---|---|
| 1 | Quais imóveis estão cadastrados? | `SELECT *` | Sim |
| 2 | Lista resumida para anúncio | `SELECT` com colunas | Sim |
| 3 | Imóveis à venda na Vila Aurora | `WHERE` + `AND` | Sim |
| 4 | Aluguéis até R$ 2.000 disponíveis | `WHERE` + 3 condições | Sim |
| 5 | Imóveis entre R$ 280 mil e R$ 500 mil | `BETWEEN` | Sim |
| 6 | Casas, sobrados ou apartamentos | `IN` | Sim |
| 7 | Contratos com data de término | `IS NOT NULL` | Sim |
| 8 | Bairros com "Jardim" no nome | `LIKE` | Sim |
| 9 | Imóveis mais caros | `ORDER BY DESC` | Sim |
| 10 | Carteira por tipo e preço | `ORDER BY` duas colunas | Sim |
| 11 | Total de imóveis | `COUNT` | Sim |
| 12 | Imóveis disponíveis | `COUNT` + `WHERE` | Sim |
| 13 | Valor total dos contratos | `SUM` | Sim |
| 14 | Preço médio à venda | `AVG` + `ROUND` + `WHERE` | Sim |
| 15 | Menor e maior preço | `MIN` / `MAX` | Sim |
| 16 | Imóveis por tipo | `GROUP BY` + `COUNT` | Sim |
| 17 | Preço médio por finalidade | `GROUP BY` + `AVG` | Sim |
| 18 | Visitas por corretor | `JOIN` + `GROUP BY` | Sim |
| 19 | Tipos com mais de uma unidade | `GROUP BY` + `HAVING` | Sim |
| 20 | Proprietários com 2+ imóveis | `JOIN` + `GROUP BY` + `HAVING` + `SUM` | Sim |
| 21 | Comissão de 6% | expressão aritmética | Sim |
| 22 | Custo mensal total do aluguel | expressão com soma | Sim |
| 23 | Preço por metro quadrado | expressão com divisão | Sim |
| 24 | Proprietário de cada imóvel | `INNER JOIN` | Sim |
| 25 | Histórico de visitas | `JOIN` entre 4 tabelas | Sim |
| 26 | Contratos e corretores | `JOIN` entre 4 tabelas | Sim |
| 27 | Contratos por tipo | `GROUP BY` + `COUNT` + `SUM` + `AVG` | Sim |

---

# 18. Consulta mais útil

### Pergunta

> Quais imóveis de aluguel custam até R$ 2.000,00 e ainda estão disponíveis?

### SQL

```sql
SELECT titulo, bairro, preco, valor_condominio
FROM imoveis
WHERE finalidade = 'Aluguel'
  AND preco <= 2000.00
  AND disponivel = TRUE;
```

### Por que ela é útil?

É a consulta que um corretor faria várias vezes por dia, enquanto atende um
cliente ao telefone. Ela responde diretamente à pergunta mais comum do negócio:
"o que vocês têm para alugar dentro do meu orçamento?".

O detalhe que a torna confiável é o `disponivel = TRUE`. Era exatamente o que o
controle em planilha não garantia — o problema que motivou este banco na Sprint
1/5.

---

# 19. Consulta mais complexa

### Pergunta

> Quais proprietários possuem 2 ou mais imóveis conosco, e qual o valor total da
> carteira de cada um?

### SQL

```sql
SELECT proprietarios.nome AS proprietario,
       COUNT(imoveis.id_imovel) AS total_imoveis,
       SUM(imoveis.preco) AS valor_total_carteira
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
GROUP BY proprietarios.nome
HAVING COUNT(imoveis.id_imovel) >= 2
ORDER BY valor_total_carteira DESC;
```

### Qual foi a dificuldade?

Combinar quatro recursos em uma consulta só: `JOIN`, `GROUP BY`, duas funções de
agregação diferentes e `HAVING`.

A dificuldade principal foi entender por que não podia escrever
`WHERE COUNT(*) >= 2`. Levei um tempo para assimilar que o `WHERE` é avaliado
antes do agrupamento, quando a contagem ainda não existe — e que é por isso que
o `HAVING` precisa ser uma cláusula separada.

A segunda dificuldade foi o `GROUP BY`: a coluna `proprietarios.nome` aparece no
`SELECT` fora de uma agregação, então precisa obrigatoriamente constar no
`GROUP BY`. Agrupar por `proprietarios.id_proprietario` também funcionaria e
seria mais seguro no caso de dois proprietários homônimos.

---

# 20. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| `AVG(preco)` retornava valores com seis casas decimais | O MySQL expande a precisão em funções de agregação sobre `DECIMAL` | Uso de `ROUND(AVG(preco), 2)`, adequado para valores monetários |
| A média de preço misturava venda e aluguel, gerando um número sem significado | Faltava filtrar por finalidade antes de calcular | Inclusão de `WHERE finalidade = 'Venda'`, e também uma versão agrupada com `GROUP BY finalidade` |
| Tentativa de usar `WHERE COUNT(*) >= 2` | O `WHERE` é avaliado antes do `GROUP BY`, quando a contagem ainda não foi calculada | Substituição por `HAVING COUNT(*) >= 2` |
| O `GROUP BY` por `id_corretor` retornava apenas números | A tabela `visitas` guarda só a chave estrangeira, não o nome | Inclusão de `INNER JOIN` com `corretores` para trazer o nome |
| Risco de divisão por zero no cálculo de preço por m² | Terrenos e imóveis sem área informada poderiam ter `area_m2` nulo ou zero | Inclusão de `AND area_m2 > 0` no filtro |

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

---

# 23. Checklist da Sprint 4/5

- [x] utilizei o banco das Sprints anteriores;
- [x] confirmei que existem dados suficientes;
- [x] utilizei `SELECT`;
- [x] selecionei colunas específicas;
- [x] utilizei `WHERE`;
- [x] utilizei mais de uma condição;
- [x] utilizei `ORDER BY`;
- [x] utilizei `COUNT`;
- [x] utilizei `SUM`;
- [x] utilizei `AVG`;
- [x] utilizei `MIN` ou `MAX`;
- [x] utilizei `GROUP BY`;
- [x] utilizei `HAVING`;
- [x] utilizei aliases com `AS`;
- [x] utilizei expressão SQL;
- [x] minhas consultas respondem perguntas reais;
- [x] testei as consultas no MySQL Workbench;
- [x] salvei o código em `SPRINT4-5.sql`;
- [x] preenchi completamente o `SPRINT4-5.md`;
- [x] revisei os arquivos antes do commit.
