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
USE real_estate_database;
```
 
6. Confira os dados:
```sql
SELECT * FROM imovel;
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
 
1. Quais imóveis estão cadastrados na cidade de Rondonópolis?
2. Quais imóveis custam menos de R$ 300.000,00?
3. Quantos agendamentos estão com o status Pendente? (Adaptada da pergunta original sobre datas para focar na busca por status de confirmação)
4. Quantos imóveis temos anunciados no total?
5. Quais as datas de visita agendadas para o imóvel de ID 3 (Chácara)?
Agora identifique quais delas exigem:
 
- consulta simples;
- filtro;
- ordenação;
- agregação;
- agrupamento;
- filtro sobre grupos.
> A pergunta 1 exige apenas filtro (WHERE). A pergunta 2 exige filtro e ordenação (WHERE + ORDER BY). A pergunta 3 exige agregação (COUNT) combinada com filtro. A pergunta 4 exige agregação simples (COUNT). A pergunta 5 exige filtro e ordenação (WHERE + ORDER BY) sobre a tabela agendamento.
 
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
 
> Quais são todos os imóveis cadastrados no sistema?
 
### SQL
 
```sql
SELECT * FROM imovel;
 
```
 
### Explique o resultado
 
> Esta consulta retorna todas as colunas e todas as linhas da tabela imovel, exibindo o catálogo completo de anúncios do banco de dados.
 
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
 
> Quais imóveis estão localizados na cidade de Rondonópolis?
 
### SQL
 
```sql
SELECT titulo, valor, cidade 
FROM imovel 
WHERE cidade = 'Rondonópolis';
 
```
 
### Explique o filtro
 
> O comando WHERE cidade = 'Rondonópolis' verifica cada linha da tabela e retorna apenas aquelas onde o valor da coluna "cidade" é exatamente igual a 'Rondonópolis', filtrando os imóveis de outras cidades.
 
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
 
> Quais imóveis custam menos de R$ 300.000,00, listados do mais barato para o mais caro?
 
### SQL
 
```sql
SELECT titulo, valor, cidade 
FROM imovel 
WHERE valor < 300000.00 
ORDER BY valor ASC;
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
 
```sql
SELECT COUNT(*) AS agendamentos_pendentes 
FROM agendamento 
WHERE status = 'Pendente';
 
```
 
**Pergunta respondida:**
 
> Quantos agendamentos estão atualmente com o status "Pendente" no sistema?
 
## SUM
 
```sql
SELECT SUM(valor) AS soma_total_imoveis 
FROM imovel;
 
```
 
**Pergunta respondida:**
 
> Qual é a soma total em dinheiro de todos os imóveis atualmente em catálogo?
 
Caso não seja aplicável ao domínio, justifique.
 
## AVG
 
```sql
SELECT AVG(valor) AS media_precos 
FROM imovel;
```
 
**Pergunta respondida:**
 
> Qual é a média de preço dos imóveis anunciados no sistema?
 
Caso não seja aplicável ao domínio, justifique.
 
## MIN ou MAX
 
```sql
SELECT MIN(valor) AS imovel_mais_barato,
       MAX(valor) AS imovel_mais_caro 
FROM imovel;
 
```
 
**Pergunta respondida:**
 
> Qual é o valor do imóvel mais barato e do imóvel mais caro anunciados pela imobiliária?
 
---
 
# 9. GROUP BY
 
`GROUP BY` permite agrupar registros.
 
Exemplo:
 
```sql
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id;
```
 
Outro exemplo:
 
```sql
SELECT status,
       COUNT(*) AS quantidade
FROM pedido
GROUP BY status;
```
 
## Consulta obrigatória com GROUP BY
 
### Pergunta respondida
 
> Quantos imóveis temos anunciados divididos por cada cidade?
 
### SQL
 
```sql
SELECT cidade, COUNT(*) AS total_por_cidade 
FROM imovel 
GROUP BY cidade;
 
```
 
### Explique o agrupamento
 
> O banco de dados agrupa as linhas que possuem o mesmo nome na coluna cidade (ex: junta todos os registros de Rondonópolis). Em seguida, aplica a função COUNT(*) para contar quantas linhas existem dentro de cada um desses grupos.
 
---
 
# 10. HAVING
 
`WHERE` filtra registros antes do agrupamento.
 
`HAVING` filtra os grupos após o `GROUP BY`.
 
Exemplo:
 
```sql
SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id
HAVING COUNT(*) > 5;
```
 
## Consulta obrigatória com HAVING
 
### Pergunta respondida
 
> Quais clientes possuem mais de 1 agendamento de visita registrado no sistema?
 
### SQL
 
```sql
SELECT id_cliente, COUNT(*) AS quantidade_visitas 
FROM agendamento 
GROUP BY id_cliente 
HAVING COUNT(*) > 1;
 
```
 
### Por que HAVING foi necessário?
 
> Porque o comando WHERE não pode ser utilizado junto com funções de agregação (como o COUNT). Precisamos primeiro agrupar os agendamentos por cliente com GROUP BY e só depois filtrar os grupos resultantes usando o HAVING para exibir apenas os que têm a contagem maior que 1.
 
---
 
# 11. Expressões SQL
 
É possível realizar cálculos em consultas.
 
Exemplo:
 
```sql
SELECT nome,
       preco,
       preco * 0.90 AS preco_com_desconto
FROM produto;
```
 
Outro exemplo:
 
```sql
SELECT quantidade,
       valor_unitario,
       quantidade * valor_unitario AS subtotal
FROM item_pedido;
```
 
## Consulta com expressão
 
```sql
SELECT titulo, 
       valor, 
       valor * 0.05 AS comissao_corretor 
FROM imovel;
 
```
 
### Explique o cálculo
 
> O cálculo valor * 0.05 pega o preço de cada imóvel cadastrado e multiplica por 5%, criando uma coluna virtual chamada comissao_corretor. Isso permite visualizar rapidamente o valor financeiro da comissão que o corretor ganhará ao vender aquele imóvel.
 
Caso não seja aplicável ao domínio, justifique.
 
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
USE real_estate_database;
 
-- SELECT básico
SELECT *
FROM imovel;
 
-- Colunas específicas
SELECT titulo, valor
FROM imovel;
 
-- WHERE
SELECT *
FROM imovel
WHERE valor > 300000;
 
-- Duas condições
SELECT *
FROM agendamento
WHERE status = 'Pendente'
  AND data_visita > '2026-10-16';
 
-- ORDER BY
SELECT *
FROM imovel
ORDER BY valor ASC;
 
-- COUNT
SELECT COUNT(*) AS total_imoveis
FROM imovel;
 
-- SUM
SELECT SUM(valor) AS valor_total_catalogo
FROM imovel;
 
-- AVG
SELECT AVG(valor) AS media_valor
FROM imovel;
 
-- MIN / MAX
SELECT MIN(valor) AS menor_valor,
       MAX(valor) AS maior_valor
FROM imovel;
 
-- GROUP BY
SELECT cidade,
       COUNT(*) AS quantidade
FROM imovel
GROUP BY cidade;
 
-- HAVING
SELECT id_cliente,
       COUNT(*) AS quantidade_visitas
FROM agendamento
GROUP BY id_cliente
HAVING COUNT(*) > 1;
 
-- Expressão
SELECT titulo,
       valor,
       valor * 1.10 AS valor_com_inflacao
FROM imovel;
```
 
> Substitua `nome_do_banco`, `tabela_a`, `campo_a1`, `campo_numerico`, `campo_categoria` e demais nomes genéricos pelos nomes reais do seu projeto.
 
---
 
# 15. Estrutura recomendada do SPRINT4-5.sql
 
```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
 
-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database
 
-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================
 
USE real_estate_database;
 
-- ============================================================
-- 1. CONSULTAS BÁSICAS
-- ============================================================
SELECT * FROM imovel;
SELECT titulo, valor FROM imovel;
 
-- ============================================================
-- 2. WHERE
-- ============================================================
SELECT titulo, valor, cidade FROM imovel WHERE cidade = 'Rondonópolis';
SELECT * FROM agendamento WHERE status = 'Pendente' AND data_visita > '2026-10-16';
 
-- ============================================================
-- 3. ORDER BY
-- ============================================================
SELECT titulo, valor FROM imovel WHERE valor < 300000.00 ORDER BY valor ASC;
 
-- ============================================================
-- 4. FUNÇÕES DE AGREGAÇÃO
-- ============================================================
SELECT COUNT(*) AS agendamentos_pendentes FROM agendamento WHERE status = 'Pendente';
SELECT SUM(valor) AS soma_total_imoveis FROM imovel;
SELECT AVG(valor) AS media_precos FROM imovel;
SELECT MIN(valor) AS imovel_mais_barato, MAX(valor) AS imovel_mais_caro FROM imovel;
 
-- ============================================================
-- 5. GROUP BY
-- ============================================================
SELECT cidade, COUNT(*) AS total_por_cidade FROM imovel GROUP BY cidade;
 
-- ============================================================
-- 6. HAVING
-- ============================================================
SELECT id_cliente, COUNT(*) AS quantidade_visitas FROM agendamento GROUP BY id_cliente HAVING COUNT(*) > 1;
 
-- ============================================================
-- 7. EXPRESSÕES SQL
-- ============================================================
SELECT titulo, valor, valor * 0.05 AS comissao_corretor FROM imovel;
 
-- ============================================================
-- CONSULTAS EXTRAS
-- ============================================================
SELECT id_cliente, data_visita, status FROM agendamento WHERE id_imovel = 3 ORDER BY data_visita ASC;
 
```
 
---
 
# 16. Passo a passo no MySQL Workbench
 
## Etapa 1 — Selecione o banco
 
```sql
USE real_estate_database;
```
 
## Etapa 2 — Confira as tabelas
 
```sql
SELECT * FROM imovel;
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
| 1 | Quais são todos os imóveis cadastrados no sistema? | SELECT * | Sim |
| 2 | Quais imóveis estão localizados na cidade de Rondonópolis? | WHERE | Sim |
| 3 | Quais imóveis custam menos de R$ 300.000,00, do mais barato ao mais caro? | WHERE, ORDER BY | Sim |
| 4 | Quantos agendamentos estão atualmente com o status "Pendente"? | COUNT | Sim |
| 5 | Qual a soma, a média, o valor mínimo e o valor máximo dos imóveis do catálogo? | SUM, AVG, MIN, MAX | Sim |
| 6 | Quantos imóveis temos anunciados divididos por cada cidade? | GROUP BY | Sim |
| 7 | Quais clientes possuem mais de 1 agendamento de visita registrado? | GROUP BY, HAVING | Sim |
| 8 | Qual seria a comissão do corretor (5%) sobre o valor de cada imóvel? | Expressão (AS) | Sim |
 
---
 
# 18. Consulta mais útil
 
### Pergunta
 
> Quantos agendamentos estão atualmente com o status "Pendente" no sistema?
 
### SQL
 
```sql
SELECT COUNT(*) AS agendamentos_pendentes
FROM agendamento
WHERE status = 'Pendente';
```
 
### Por que ela é útil?
 
> Porque é a consulta que a equipe usaria no dia a dia para saber quantas visitas ainda precisam de confirmação. É um indicador operacional direto: se o número estiver alto, sinaliza que há agendamentos sem retorno do corretor ou do cliente, exigindo ação imediata.
 
---
 
# 19. Consulta mais complexa
 
### Pergunta
 
> Quais clientes possuem mais de 1 agendamento de visita registrado no sistema?
 
### SQL
 
```sql
SELECT id_cliente, COUNT(*) AS quantidade_visitas
FROM agendamento
GROUP BY id_cliente
HAVING COUNT(*) > 1;
```
 
### Qual foi a dificuldade?
 
> A dificuldade foi entender por que WHERE não funciona nesse caso. WHERE filtra linhas individuais antes de qualquer agrupamento, mas "mais de 1 agendamento" só existe depois que as linhas já foram agrupadas por id_cliente e contadas. Por isso é necessário GROUP BY para formar os grupos e HAVING para filtrar o resultado da agregação (COUNT) sobre esses grupos — são duas etapas lógicas distintas, e confundir a ordem gera erro de sintaxe no MySQL.
 
---
 
# 20. Problemas encontrados
 
| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Erro de sintaxe ao executar a consulta de COUNT (comando aparecia como "ELECT" em vez de "SELECT") | Erro de digitação ao copiar o comando no script | Comando corrigido para "SELECT COUNT(*) AS agendamentos_pendentes..." |
| Tentativa inicial de filtrar clientes com mais de 1 agendamento usando WHERE COUNT(*) > 1 | Uso de função de agregação dentro de WHERE, que não é permitido no MySQL | Substituição por GROUP BY id_cliente seguido de HAVING COUNT(*) > 1 |
| Dúvida sobre por que MIN e MAX precisavam estar na mesma consulta | Falta de familiaridade inicial com múltiplas funções de agregação na mesma cláusula SELECT | Uso de duas colunas de agregação separadas por vírgula na mesma consulta (MIN(valor), MAX(valor)) |
 
---
 
# 21. Uso de LLMs nesta Sprint
 
Caso utilize uma LLM, informe:
 
- tema do banco;
- nomes reais das tabelas;
- estrutura das tabelas;
- dados disponíveis;
- pergunta que deseja responder;
- SQL já tentado;
- mensagem de erro do MySQL, quando houver.
Exemplo de solicitação adequada:
 
```text
Tenho uma tabela produto com os campos id_produto, nome,
preco, estoque e id_categoria.
 
Quero responder: "Qual é o preço médio dos produtos de cada
categoria?"
 
Explique como construir essa consulta usando GROUP BY e AVG.
Depois apresente um exemplo compatível com MySQL.
```
 
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
 
- [x] utilizei o banco das Sprints anteriores;
- [x] confirmei que existem dados suficientes;
- [x] utilizei `SELECT`;
- [x] selecionei colunas específicas;
- [x] utilizei `WHERE`;
- [x] utilizei mais de uma condição;
- [x] utilizei `ORDER BY`;
- [x] utilizei `COUNT`;
- [x] utilizei `SUM`, quando aplicável;
- [x] utilizei `AVG`, quando aplicável;
- [x] utilizei `MIN` ou `MAX`;
- [x] utilizei `GROUP BY`;
- [x] utilizei `HAVING`;
- [x] utilizei aliases com `AS`;
- [x] utilizei expressão SQL quando aplicável;
- [x] minhas consultas respondem perguntas reais;
- [x] testei as consultas no MySQL Workbench;
- [x] salvei o código em `SPRINT4-5.sql`;
- [x] preenchi completamente o `SPRINT4-5.md`;
- [x] revisei os arquivos antes do commit.
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
