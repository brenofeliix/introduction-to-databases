# SPRINT 4/5 — Consultas SQL e Expressões

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
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
2. Abra sua conexão.
3. Confirme que o banco da Sprint 2/5 existe.
4. Confirme que os dados da Sprint 3/5 estão disponíveis.
5. Selecione o banco:

```sql
USE nome_do_banco;
```

6. Confira os dados:

```sql
SELECT * FROM nome_da_tabela;
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
SPRINT4-5.sql
```

---

# 3. Retome as perguntas da Sprint 1/5

Recupere as perguntas que você definiu anteriormente para o banco.

1. Quais são todos os atletas cadastrados no projeto e suas respectivas datas de nascimento?
2. Quantos atletas estão vinculados a cada escola parceira?
3. Qual é a média de idade (ou data de nascimento média) dos atletas por categoria de atletismo?
4. Quais escolas possuem mais de um atleta participante cadastrado no projeto?
5. Quais atletas possuem restrições médicas cadastradas em suas fichas?

Agora identifique quais delas exigem:

- consulta simples;
- filtro;
- ordenação;
- agregação;
- agrupamento;
- filtro sobre grupos.

---

# 4. SELECT

Consulta básica:

```sql
SELECT *
FROM nome_tabela;
```

Selecionando colunas específicas:

```sql
SELECT campo_1, campo_2
FROM nome_tabela;
```

## Consulta 1

### Pergunta respondida

> Quais são os nomes completos, CPFs e telefones de todos os colaboradores e membros da equipe técnica cadastrados na RAAEI?

### SQL

```
SELECT nome_completo, cpf, telefone
FROM colaborador;

```

### Explique o resultado

> Esta consulta extrai exclusivamente as colunas de identificação e contato (nome_completo, cpf e telefone) da tabela colaborador. O uso de colunas específicas em vez de SELECT * otimiza a leitura dos dados gerenciais, exibindo apenas as informações estritamente necessárias para contato e controle administrativo da diretoria e comissão técnica.

---

# 5. WHERE

Utilize `WHERE` para filtrar registros.

Exemplo:

```sql
SELECT *
FROM produto
WHERE preco > 100;
```

Operadores comuns:

```text
=   igual
<>  diferente
>   maior que
<   menor que
>=  maior ou igual
<=  menor ou igual
```

Também podem ser utilizados:

```sql
AND
OR
LIKE
BETWEEN
IN
IS NULL
IS NOT NULL
```

Exemplo:

```sql
SELECT *
FROM produto
WHERE preco > 100
  AND estoque > 0;
```

## Consulta obrigatória com WHERE

### Pergunta respondida

> Quais são os atletas cadastrados que possuem algum tipo de restrição ou acompanhamento médico registrado em sua ficha?

### SQL

```
SELECT nome_completo, data_nascimento, observacoes_medicas
FROM atleta
WHERE observacoes_medicas <> 'Nenhuma restrição médica.'
  AND observacoes_medicas IS NOT NULL;

```

### Explique o filtro

> Este filtro utiliza os operadores de diferença (<>) e de verificação de nulos (IS NOT NULL) para selecionar estritamente os atletas cujas observações médicas indiquem algum cuidado especial, alergias ou acompanhamentos ortopédicos. Isso permite à comissão técnica identificar rapidamente quais alunos exigem atenção diferenciada durante as sessões de treinamento e competições de atletismo.

---

# 6. ORDER BY

Ordenação crescente:

```sql
SELECT *
FROM produto
ORDER BY preco ASC;
```

Ordenação decrescente:

```sql
SELECT *
FROM produto
ORDER BY preco DESC;
```

Por mais de uma coluna:

```sql
SELECT *
FROM produto
ORDER BY categoria ASC, preco DESC;
```

## Consulta obrigatória com ORDER BY

### Pergunta respondida

> Quais são os atletas cadastrados ordenados pelo nome completo em ordem alfabética crescente, e em caso de coincidência, pela data de nascimento?

### SQL

```
SELECT nome_completo, data_nascimento, endereco
FROM atleta
ORDER BY nome_completo ASC, data_nascimento ASC;

```

---

# 7. Funções de agregação

Principais funções:

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

## COUNT

```sql
SELECT COUNT(*) AS total_registros
FROM nome_tabela;
```

## SUM

```sql
SELECT SUM(campo_numerico) AS total
FROM nome_tabela;
```

## AVG

```sql
SELECT AVG(campo_numerico) AS media
FROM nome_tabela;
```

## MIN e MAX

```sql
SELECT MIN(campo_numerico) AS menor_valor,
       MAX(campo_numerico) AS maior_valor
FROM nome_tabela;
```

---

# 8. Consultas obrigatórias com agregação

## COUNT

```
SELECT COUNT(*) AS total_atletas
FROM atleta;
```

**Pergunta respondida:**

> Quantos atletas no total estão atualmente cadastrados e ativos no projeto da associação?

## SUM

```
SELECT SUM(idade_minima + idade_maxima) AS soma_total_idades_referencia
FROM categoria;

```

**Pergunta respondida:**

> Qual é o somatório acumulado dos limites de idade estipulados para todas as categorias de atletismo cadastradas?

Nota de domínio: Como a tabela de atletas possui campos estritamente cadastrais, demográficos e médicos (sem colunas financeiras ou quantitativas monetárias diretas), o operador SUM foi aplicado sobre os parâmetros numéricos das faixas etárias das categorias para fins estatísticos e de estruturação de provas.

Caso não seja aplicável ao domínio, justifique.

## AVG

```
SELECT AVG(idade_minima) AS media_idade_minima_categorias
FROM categoria;

```

**Pergunta respondida:**

> Qual é a média geral das idades mínimas exigidas pelas categorias de atletismo oferecidas pela RAAEI?

Caso não seja aplicável ao domínio, justifique.

## MIN ou MAX

```
SELECT MIN(data_nascimento) AS atleta_mais_velho,
       MAX(data_nascimento) AS atleta_mais_novo
FROM atleta;

```

**Pergunta respondida:**

> Quais são as datas de nascimento do atleta mais velho (data menor) e do atleta mais novo (data maior) cadastrados na associação?

---

# 9. GROUP BY - 

`GROUP BY` permite agrupar registros.

Exemplo:

```
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id;
```

Outro exemplo:

```
SELECT status,
       COUNT(*) AS quantidade
FROM pedido
GROUP BY status;
```

## Consulta obrigatória com GROUP BY

### Pergunta respondida

> Quantos atletas estão cadastrados em cada uma das redes de ensino (escola pública ou privada) parceiras do projeto?

### SQL

```
SELECT e.tipo_rede, COUNT(a.id_atleta) AS total_atletas
FROM escola e
JOIN atleta a ON e.id_escola = a.id_escola
GROUP BY e.tipo_rede;

```

### Explique o agrupamento

> Este agrupamento cruza a tabela de escolas com a tabela de atletas por meio de uma junção (JOIN) e utiliza a cláusula GROUP BY associada à coluna e.tipo_rede. Com isso, a base de dados categoriza e consolida o quantitativo de alunos participantes conforme a dependência administrativa das instituições de ensino (pública versus privada), fornecendo um panorama gerencial importante para a associação.

---

# 10. HAVING

`WHERE` filtra registros antes do agrupamento.

`HAVING` filtra os grupos após o `GROUP BY`.

Exemplo:

```
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id
HAVING COUNT(*) > 5;
```

## Consulta obrigatória com HAVING

### Pergunta respondida

> Quais são as categorias de atletismo que possuem mais de um atleta cadastrado no projeto?

### SQL

```
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 1;

```

### Por que HAVING foi necessário?

> O HAVING foi estritamente necessário porque a condição de filtro (> 1) incide diretamente sobre o resultado de uma função de agregação (COUNT(a.id_atleta)). Enquanto a cláusula WHERE filtra linhas individuais antes que o agrupamento ocorra, o HAVING atua após a formação dos grupos gerados pelo GROUP BY, permitindo isolar apenas as categorias que atingem o patamar quantitativo estabelecido.
---

# 11. Expressões SQL

É possível realizar cálculos em consultas.

Exemplo:

```
SELECT nome,
       preco,
       preco * 0.90 AS preco_com_desconto
FROM produto;
```

Outro exemplo:

``` 
SELECT quantidade,
       valor_unitario,
       quantidade * valor_unitario AS subtotal
FROM item_pedido;
```

## Consulta com expressão

```
SELECT nome_categoria,
       idade_minima,
       idade_maxima,
       (idade_maxima - idade_minima) AS amplitude_faixa_etaria
FROM categoria;

```

### Explique o cálculo

> O cálculo utiliza uma expressão aritmética de subtração (idade_maxima - idade_minima) sobre os campos numéricos da tabela categoria. O resultado gera um novo atributo derivado chamado amplitude_faixa_etaria, que indica a amplitude em anos de cada categoria de atletismo da associação (por exemplo, o intervalo etário coberto pela categoria), auxiliando a comissão técnica na visualização do escopo de idade de cada faixa de treinamento.

---

# 12. Consultas mínimas exigidas

O arquivo `SPRINT4-5.sql` deverá possuir, no mínimo:

```text
1 SELECT básico
1 SELECT com colunas específicas
1 consulta com WHERE
1 consulta com mais de uma condição
1 consulta com ORDER BY
1 consulta com COUNT
1 consulta com SUM, quando aplicável
1 consulta com AVG, quando aplicável
1 consulta com MIN ou MAX
1 consulta com GROUP BY
1 consulta com HAVING
1 consulta com expressão, quando aplicável
```

As consultas devem responder perguntas reais sobre o banco.

---

# 13. Evite consultas sem significado

Evite:

```sql
SELECT *
FROM produto
WHERE id_produto > 0;
```

se isso não responde nenhuma necessidade real.

Prefira:

```sql
SELECT nome, estoque
FROM produto
WHERE estoque < 5
ORDER BY estoque ASC;
```

Pergunta:

```text
Quais produtos estão com estoque baixo?
```

---

# 14. Modelo genérico para adaptar

**Não entregue este código sem adaptação.**

```sql
USE nome_do_banco;

-- SELECT básico
SELECT *
FROM tabela_a;

-- Colunas específicas
SELECT campo_a1, campo_a2
FROM tabela_a;

-- WHERE
SELECT *
FROM tabela_a
WHERE campo_numerico > 10;

-- Duas condições
SELECT *
FROM tabela_a
WHERE campo_numerico > 10
  AND campo_status = 'ATIVO';

-- ORDER BY
SELECT *
FROM tabela_a
ORDER BY campo_a1 ASC;

-- COUNT
SELECT COUNT(*) AS total_registros
FROM tabela_a;

-- SUM
SELECT SUM(campo_numerico) AS total
FROM tabela_a;

-- AVG
SELECT AVG(campo_numerico) AS media
FROM tabela_a;

-- MIN / MAX
SELECT MIN(campo_numerico) AS menor_valor,
       MAX(campo_numerico) AS maior_valor
FROM tabela_a;

-- GROUP BY
SELECT campo_categoria,
       COUNT(*) AS quantidade
FROM tabela_a
GROUP BY campo_categoria;

-- HAVING
SELECT campo_categoria,
       COUNT(*) AS quantidade
FROM tabela_a
GROUP BY campo_categoria
HAVING COUNT(*) > 1;

-- Expressão
SELECT campo_a1,
       campo_numerico,
       campo_numerico * 1.10 AS valor_calculado
FROM tabela_a;
```

> Substitua `nome_do_banco`, `tabela_a`, `campo_a1`, `campo_numerico`, `campo_categoria` e demais nomes genéricos pelos nomes reais do seu projeto.

---

# 15. Estrutura recomendada do SPRINT4-5.sql

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno:
-- Banco:

-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE nome_do_banco;

-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================


-- ============================================================
-- 2. WHERE
-- ============================================================


-- ============================================================
-- 3. ORDER BY
-- ============================================================


-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================


-- ============================================================
-- 5. GROUP BY
-- ============================================================


-- ============================================================
-- 6. HAVING
-- ============================================================


-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================


-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================

```

---

# 16. Passo a passo no MySQL Workbench

## Etapa 1 — Selecione o banco

```sql
USE nome_do_banco;
```

## Etapa 2 — Confira as tabelas

```sql
SELECT * FROM nome_tabela;
```

## Etapa 3 — Escolha uma pergunta

Exemplo:

```text
Quais produtos possuem preço acima de R$ 100?
```

## Etapa 4 — Transforme em SQL

```sql
SELECT nome, preco
FROM produto
WHERE preco > 100;
```

## Etapa 5 — Execute

Execute uma consulta por vez e confira o resultado.

## Etapa 6 — Documente no próprio `.sql`

Exemplo:

```sql
-- Consulta 01
-- Pergunta:
-- Quais produtos possuem estoque abaixo de 5 unidades?

SELECT nome, estoque
FROM produto
WHERE estoque < 5
ORDER BY estoque ASC;
```

## Etapa 7 — Salve

Salve frequentemente como:

```text
SPRINT4-5.sql
```

---

# 17. Registro das consultas

| Nº | Pergunta | Recursos SQL utilizados | Funcionou? |
|---:|---|---|---|

|1 | Quais são os nomes completos, CPFs e telefones de todos os colaboradores e membros da equipe técnica? | SELECT, Colunas específicas | Sim

| 2 | Quais são os atletas cadastrados que possuem algum tipo de restrição ou acompanhamento médico registrado? | SELECT, WHERE, Operador de diferença (<>), IS NOT NULL | Sim

| 3 | Quais atletas possuem restrição médica e pertencem a uma escola específica (id_escola = 2)? | SELECT, WHERE, AND | Sim

| 4 | Quais são os atletas cadastrados ordenados pelo nome completo em ordem alfabética crescente? | SELECT, ORDER BY ASC | Sim

| 5 | Quantos atletas no total estão atualmente cadastrados e ativos no projeto da associação? | SELECT, Função de agregação COUNT | Sim

| 6 | Quantos atletas estão cadastrados em cada uma das redes de ensino (escola pública ou privada) parceiras? | SELECT, JOIN, COUNT, GROUP BY | Sim

| 7 | Quais são as categorias de atletismo que possuem mais de um atleta cadastrado no projeto? | SELECT, LEFT JOIN, COUNT, GROUP BY, HAVING | Sim

| 8 | Qual é a amplitude (diferença entre idade máxima e mínima) de cada categoria de atletismo? | SELECT, Expressão aritmética (-) | Sim

---

# 18. Consulta mais útil

### Pergunta

> Quantos atletas estão cadastrados em cada uma das redes de ensino (escola pública ou privada) parceiras do projeto?

### SQL

```
SELECT e.tipo_rede, COUNT(a.id_atleta) AS total_atletas
FROM escola e
JOIN atleta a ON e.id_escola = a.id_escola
GROUP BY e.tipo_rede;

```

### Por que ela é útil?

> Esta consulta é de extrema relevância gerencial e estratégica para a diretoria e a coordenação técnica da RAAEI. Ao cruzar as tabelas de escolas e atletas por meio de uma junção (JOIN) e consolidar os dados com GROUP BY e COUNT, ela revela instantaneamente a proporção de atendimento entre a rede pública e a privada. Esse indicador é fundamental para a elaboração de relatórios de impacto social, prestação de contas com parceiros institucionais e planejamento de novas parcerias educacionais na região.

---

# 19. Consulta mais complexa

### Pergunta

> Quais são as categorias de atletismo que possuem mais de um atleta vinculado ao projeto, considerando inclusive a listagem estrutural das categorias?

### SQL

```
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 1;

```

### Qual foi a dificuldade?

> A principal dificuldade técnica envolveu a combinação simultânea de vários conceitos avançados de SQL: a necessidade de utilizar um LEFT JOIN para preservar todas as categorias cadastradas (evitando a omissão de registros caso alguma categoria estivesse temporariamente sem atletas), o cuidado de agrupar por múltiplas colunas da tabela de categorias (id_categoria e nome_categoria) para garantir a integridade do agrupamento, e a aplicação correta da cláusula HAVING para filtrar estritamente os grupos cujo resultado da função de agregação COUNT fosse superior a 1, separando a lógica de filtragem de linhas individuais (WHERE) da filtragem de grupos agregados.

---

# 20. Problemas encontrados -

| Problema | Possível causa | Solução aplicada |
|---|---|---|

| Erro de modo estrito de agrupamento (ONLY_FULL_GROUP_BY) ao executar consultas com GROUP BY. | Seleção de colunas na projeção (SELECT) que não estavam incluídas na cláusula GROUP BY nem eram alvos de funções de agregação. | Inclusão de todas as colunas descritivas e chaves primárias correspondentes na cláusula GROUP BY (ex: GROUP BY c.id_categoria, c.nome_categoria).

| Omissão de categorias esportivas que não possuem atletas cadastrados ao gerar relatórios quantitativos. |Utilização de uma junção interna (JOIN), que retorna apenas os registros com correspondência estrita em ambas as tabelas. |Substituição por uma junção à esquerda (LEFT JOIN a partir da tabela categoria), garantindo a exibição de todas as categorias na análise.

| Inconsistência no filtro de observações médicas devido a valores nulos (NULL) ou variações de texto. | Emprego incorreto de operador de igualdade simples ou falha ao tratar registros sem preenchimento na tabela atleta. | Ajuste da cláusula WHERE combinando o operador de diferença (<> 'Nenhuma restrição médica.') com a verificação explícita (AND observacoes_medicas IS NOT NULL).

---

# 21. Uso de LLMs nesta Sprint

Caso utilize uma LLM, informe:

- Tema do banco: Gestão de associação atlética e inclusiva de atletismo (db_raaei).

- Nomes reais das tabelas: escola, categoria, atleta, colaborador.

- Estrutura das tabelas: Relacionamentos relacionais de chave primária e estrangeira ligando atletas a escolas e categorias de atletismo, além de tabelas cadastrais de equipe técnica.

- Dados disponíveis: Cadastros demográficos de atletas, faixas etárias de categorias, tipos de rede de ensino (pública/privada) e observações médicas.

- Perguntas que se desejou responder: Indicadores quantitativos por rede de ensino, filtragem de categorias por volume de atletas (HAVING) e cálculos de amplitude de faixas etárias.

- SQL tentado e mensagens de erro: Tratamento prévio de restrições de modo estrito do MySQL (ONLY_FULL_GROUP_BY) e ajuste de junções entre tabelas.



Todo código sugerido por LLM deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

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

Não exclua arquivos anteriores.

---

# 23. Checklist da Sprint 4/5

- [ x ] utilizei o banco das Sprints anteriores;
- [ x ] confirmei que existem dados suficientes;
- [ x ] utilizei `SELECT`;
- [ x ] selecionei colunas específicas;
- [ x ] utilizei `WHERE`;
- [ x ] utilizei mais de uma condição;
- [ x ] utilizei `ORDER BY`;
- [ x ] utilizei `COUNT`;
- [ x ] utilizei `SUM`, quando aplicável;
- [ x ] utilizei `AVG`, quando aplicável;
- [ x ] utilizei `MIN` ou `MAX`;
- [ x ] utilizei `GROUP BY`;
- [ x ] utilizei `HAVING`;
- [ x ] utilizei aliases com `AS`;
- [ x ] utilizei expressão SQL quando aplicável;
- [ x ] minhas consultas respondem perguntas reais;
- [ x ] testei as consultas no MySQL Workbench;
- [ x ] salvei o código em `SPRINT4-5.sql`;
- [ x ] preenchi completamente o `SPRINT4-5.md`;
- [ x ] revisei os arquivos antes do commit.

---

# 24. Regras de Git/GitHub

A atividade continua **individual**.

Utilize a mesma branch das Sprints anteriores.

Não crie uma nova branch.

## Arquivos obrigatórios no commit desta Sprint

```text
SPRINT4-5.md
SPRINT4-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 4 de 5 - consultas SQL
```

---

# 25. Pull Request

**Ainda não abra o Pull Request final.**

O PR será aberto somente após a Sprint 5/5.

```text
SPRINT1-5.md
      ↓ commit

SPRINT2-5.md + SPRINT2-5.sql
      ↓ commit

SPRINT3-5.md + SPRINT3-5.sql
      ↓ commit

SPRINT4-5.md + SPRINT4-5.sql
      ↓ commit

SPRINT5-5.md + SPRINT5-5.sql
      ↓ commit

PULL REQUEST FINAL
      ↓
main
```

---

# 26. Critério de conclusão da Sprint 4/5

A Sprint será considerada concluída quando o aluno:

1. utilizar os dados criados anteriormente;
2. elaborar consultas coerentes com o domínio;
3. utilizar corretamente `SELECT`;
4. utilizar `WHERE`;
5. utilizar `ORDER BY`;
6. utilizar funções de agregação;
7. utilizar `GROUP BY`;
8. utilizar `HAVING`;
9. conseguir explicar as perguntas respondidas;
10. executar e validar as consultas no MySQL Workbench;
11. documentar o trabalho no `SPRINT4-5.md`;
12. salvar o código em `SPRINT4-5.sql`;
13. incluir os dois arquivos no commit.

---

# Próxima etapa

Na **Sprint 5/5**, o projeto será revisado, integrado e preparado para a entrega final.

A Sprint final envolverá:

- revisão da estrutura;
- revisão das restrições;
- revisão dos dados;
- revisão das consultas;
- execução completa;
- correção de erros;
- organização dos arquivos;
- preparação do `SPRINT5-5.sql`;
- abertura do Pull Request final.

> **Não abra o Pull Request antes de concluir a Sprint 5/5.**
