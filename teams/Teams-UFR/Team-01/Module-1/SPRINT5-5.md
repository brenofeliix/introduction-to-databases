# SPRINT 5/5 — Validação Final, Integração e Entrega do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT5-5.md` + `SPRINT5-5.sql`

---

# Objetivo da Sprint 5/5

Nesta etapa final, cada aluno deverá **revisar, integrar, testar e preparar a entrega completa do banco de dados desenvolvido ao longo das cinco Sprints**.

A Sprint 5/5 não é uma etapa para começar um novo banco.

O objetivo é reunir e validar tudo o que foi desenvolvido anteriormente:

```text
SPRINT1-5 → planejamento
SPRINT2-5 → estrutura DDL
SPRINT3-5 → manipulação de dados DML
SPRINT4-5 → consultas SQL
SPRINT5-5 → integração, testes e entrega final
```

Ao final desta Sprint, o aluno deverá possuir um banco de dados que possa ser reconstruído, populado e consultado por meio de um único script SQL final.

Os arquivos obrigatórios desta Sprint são:

```text
SPRINT5-5.md
SPRINT5-5.sql
```

O arquivo `SPRINT5-5.md` documentará a validação final.

O arquivo `SPRINT5-5.sql` deverá conter o **script completo e integrado do projeto**.

---

# 1. O que o SPRINT5-5.sql deverá representar

O `SPRINT5-5.sql` será o arquivo SQL final do projeto.

Ele deverá reunir, de maneira organizada, o que foi produzido nas Sprints anteriores.

A estrutura esperada é:

```text
1. identificação do projeto
2. criação do banco de dados
3. seleção do banco com USE
4. criação das tabelas
5. chaves primárias
6. chaves estrangeiras
7. demais restrições
8. inserção dos dados
9. atualizações necessárias
10. exclusões previstas na atividade
11. consultas básicas
12. consultas com filtros
13. consultas com ordenação
14. funções de agregação
15. GROUP BY
16. HAVING
17. expressões SQL
18. comandos de validação
```

> O objetivo é que o professor consiga abrir somente o `SPRINT5-5.sql`, executar o projeto e compreender a solução final.

---

# 2. Antes de começar

Abra e revise os arquivos anteriores:

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql

SPRINT4-5.md
SPRINT4-5.sql
```

Não comece a integração sem verificar o que foi desenvolvido em cada etapa.

---

# 3. Revisão da Sprint 1/5 — Planejamento

Releia seu planejamento inicial.

Verifique se o banco final ainda corresponde ao projeto proposto.

## Tema do banco

```text
Gerenciamento de salão de beleza
```

## Objetivo principal

> gerenciar agendamentos de um salão

## Quantidade final de tabelas

```text
5
```

## Principais entidades do banco

1. CLIENTES 
2. SERVICOS
3. COLABORADORES
4. PRODUTOS
5. AGENDAMENTO

## O projeto final permaneceu igual ao planejamento inicial?

- [x] Sim
- [ ] Não

Caso tenha mudado, explique:

> Escreva aqui.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| Inclusão de `DROP TABLE IF EXISTS` | Sprint 3 | Evitar erros de duplicação de chave primária/única (Erro 1062) ao re-executar o script |
| Adição de restrição `UNIQUE` na coluna `CPF` | Sprint 2 | Garantir a integridade dos dados e prevenir cadastros duplicados de clientes |
| Ajuste no tamanho do campo `TELEFONE` para `VARCHAR(15)` | Sprint 3 | Permitir o armazenamento correto de números com DDD e formatação sem estourar o limite (Erro 1406) |

Caso não tenha ocorrido alteração:

> O projeto permaneceu coerente com o planejamento inicial.

---

# 5. Revisão da estrutura do banco

Confira se todas as tabelas possuem:

- nome coerente;
- chave primária;
- atributos adequados;
- tipos de dados corretos;
- restrições necessárias;
- relacionamentos coerentes.

Preencha:

| Tabela | PK correta? | FKs corretas? | Tipos corretos? | Restrições corretas? |
|---|---|---|---|---|
| `CLIENTES` | Sim (`ID_CLIENTES`) | N/A | Sim (`VARCHAR`, `TEXT`) | Sim (`UNIQUE`, `NOT NULL`) |
| `SERVICOS` | Sim (`NOME_SERVICO`) | N/A | Sim (`VARCHAR`, `FLOAT`) | Sim (`PRIMARY KEY`, `NOT NULL`) |
| `COLABORADORES` | Sim (`ID_COLABORADOR`) | N/A | Sim (`VARCHAR`, `TEXT`) | Sim (`AUTO_INCREMENT`, `NOT NULL`) |
| `PRODUTOS` | Sim (`ID_PRODUTO`) | N/A | Sim (`FLOAT`, `DATETIME`) | Sim (`AUTO_INCREMENT`, `NOT NULL`) |
| `AGENDAMENTO` | Sim (`DATA_AGENDAMENTO`) | Sim (`fk_CPF`, `fk_NOME_SERVICO`) | Sim (`DATETIME`, `VARCHAR`) | Sim (`FOREIGN KEY`, `NOT NULL`) |

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| CLIENTES |ID_CLIENTES  |  SIM|
| SERVICOS | NOME_SERVICO | NÃO  |
|COLABORADORES  | ID_COLABORADOR | NÃO |
|PRODUTOS  | ID_PRODUTO |SIM|
|AGENDAMENTO|DATA_AGENDAMENTO | NÃO| |

Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
|AGENDAMENTO|CPF|CLIENTES|CPF|
|AGENDAMENTO|NOME_SERVICO|SERVICOS|NOME_SERVICO|
|  |  |  |  |
|  |  |  |  |

Confira se:

- a tabela referenciada existe;
- o campo referenciado existe;
- os tipos são compatíveis;
- o relacionamento faz sentido;
- a ordem de criação das tabelas está correta.

---

# 8. Revisão das restrições

Verifique as restrições utilizadas.

```sql
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
DEFAULT
AUTO_INCREMENT
```

Registre exemplos:

| Tabela | Campo | Restrição | Regra de negócio protegida |
|---|---|---|---|
| `CLIENTES` | `ID_CLIENTES` | `PRIMARY KEY` / `AUTO_INCREMENT` | Identifica exclusivamente cada cliente e gera IDs sequenciais automaticamente |
| `CLIENTES` | `CPF` | `UNIQUE` / `NOT NULL` | Impede o cadastro de clientes duplicados ou com CPF em branco |
| `SERVICOS` | `NOME_SERVICO` | `PRIMARY KEY` / `NOT NULL` | Garante que cada serviço oferecido possua um nome único e obrigatório |
| `AGENDAMENTO` | `CPF` | `FOREIGN KEY` | Garante a integridade referencial, permitindo agendamentos apenas para clientes cadastrados |
| `AGENDAMENTO` | `NOME_SERVICO` | `FOREIGN KEY` | Garante que um agendamento seja associado apenas a serviços válidos do salão |
| `PRODUTOS` | `PRECO_VENDA` | `NOT NULL` | Impede que produtos sejam cadastrados sem valor de venda |

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| `CLIENTES` | 5 |
| `SERVICOS` | 5 |
| `COLABORADORES` | 6 |
| `PRODUTOS` | 5 |
| `AGENDAMENTO` | 5 |

Pergunte:

- existem dados suficientes para testar relacionamentos?
- existem valores diferentes para permitir filtros?
- existem grupos diferentes para testar `GROUP BY`?
- existem valores suficientes para `SUM`, `AVG`, `MIN` e `MAX`?
- existem registros que permitam testar `HAVING`?

---

# 10. Revisão dos INSERTs

Confirme:

- [x] os INSERTs executam sem erro;
- [x] respeitam as chaves estrangeiras;
- [x] não existem duplicações indevidas;
- [x] respeitam `NOT NULL`;
- [x] respeitam `UNIQUE`;
- [x] os dados fazem sentido no domínio.

Caso encontre problemas, registre:

| Problema | Correção realizada |
|---|---|
| Erro 1062 ao re-executar os INSERTs em `CLIENTES` por conta da chave `UNIQUE` no CPF[cite: 2] | Adicionada a instrução `DROP TABLE IF EXISTS` para garantir um reset limpo do banco antes da reinserção dos dados |

---

# 11. Revisão dos UPDATEs

Confirme:

- [x] os UPDATEs possuem `WHERE`;
- [x] alteram os registros esperados;
- [x] não modificam toda a tabela acidentalmente;
- [x] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
-- Atualização do preço de um serviço específico
UPDATE SERVICOS 
SET PRECO_SERVICOS = 45.00 
WHERE NOME_SERVICO = 'Corte Feminino';

-- Atualização do telefone de um cliente via ID
UPDATE CLIENTES 
SET TELEFONE = '66999887766' 
WHERE ID_CLIENTES = 1;
```

---

# 12. Revisão dos DELETEs

Confirme:

- [x] os DELETEs possuem `WHERE`;
- [x] não removem registros necessários ao funcionamento do projeto;
- [x] respeitam as dependências de `FOREIGN KEY`;
- [x] não comprometem consultas posteriores.

Liste os DELETEs finais:

```sql
-- Remoção de um produto descontinuado especificando o seu ID
DELETE FROM PRODUTOS 
WHERE ID_PRODUTO = 5;

-- Remoção de um agendamento cancelado com base na data e hora
DELETE FROM AGENDAMENTO 
WHERE DATA_AGENDAMENTO = '2024-10-15 14:00:00';
```

---

# 13. Revisão das consultas da Sprint 4/5

O projeto final deverá possuir consultas que demonstrem, quando aplicável:

```sql
SELECT
WHERE
ORDER BY
COUNT
SUM
AVG
MIN
MAX
GROUP BY
HAVING
```

Preencha:

| Recurso SQL | Possui consulta válida? | Pergunta respondida |
|---|---|---|
| `SELECT` | SIM | Quais clientes estão cadastrados no sistema? |
| `WHERE` | SIM | Quais produtos possuem margem de lucro superior a 20 reais? |
| `ORDER BY` | SIM | Quais produtos geram maior lucro, ordenados do maior para o menor? |
| `COUNT` | SIM | Quantos clientes estão registrados no sistema? |
| `SUM` | SIM | Qual o valor total de lucro estimado obtido com a venda de todos os produtos? |
| `AVG` | SIM | Qual é o preço médio dos serviços oferecidos pelo salão? |
| `MIN / MAX` | SIM | Quais são os valores do serviço mais barato e do serviço mais caro? |
| `GROUP BY` | SIM | Quantos agendamentos foram realizados para cada tipo de serviço? |
| `HAVING` | SIM | Quais serviços possuem mais de 1 agendamento realizado? |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quais clientes estão cadastrados?

**Foi respondida?**

- [x] Sim
- [ ] Não

**Consulta utilizada:**

```sql
SELECT 
    NOME, 
    CPF, 
    TELEFONE 
FROM CLIENTES
ORDER BY NOME ASC;
```

---

## Pergunta 2

> Escreva aqui.

**Foi respondida?**

- [ ] Sim
- [X] Não

```sql
-- SELECT 
    NOME_PRODUTO,
    PRECO_COMPRA,
    PRECO_VENDA,
    (PRECO_VENDA - PRECO_COMPRA) AS LUCRO
FROM PRODUTOS
ORDER BY LUCRO DESC;

```

---

## Pergunta 3

> Quais agendamentos diários?

**Foi respondida?**

- [X] Sim
- [ ] Não

```sql
-- SELECT 
    DATA_AGENDAMENTO, 
    CPF, 
    NOME_SERVICO 
FROM AGENDAMENTO
ORDER BY DATA_AGENDAMENTO ASC;

```

---

## Pergunta 4

> Quais produtos mais está sendo vendidos?

**Foi respondida?**

- [X] Sim
- [ ] Não

```sql
-- SELECT 
    NOME_PRODUTO, 
    COUNT(*) AS QUANTIDADE_VENDAS
FROM PRODUTOS
GROUP BY NOME_PRODUTO
ORDER BY QUANTIDADE_VENDAS DESC;

```

---

## Pergunta 5

> Quantos clientes ativos tem registrados?

**Foi respondida?**

- [X] Sim
- [ ] Não

```sql
-- SELECT 
    COUNT(*) AS TOTAL_CLIENTES_REGISTRADOS
FROM CLIENTES;

```

---

# 15. Criando o SPRINT5-5.sql

No MySQL Workbench:

```text
File → New Query Tab
```

ou abra um novo arquivo.

Depois salve como:

```text
SPRINT5-5.sql
```

Esse arquivo deverá reunir o projeto completo.

---

# 16. Estrutura recomendada do SPRINT5-5.sql

Use esta organização:

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno:
-- Tema:
-- Banco:


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================


-- ============================================================
-- 5. INSERTS
-- ============================================================


-- ============================================================
-- 6. UPDATES
-- ============================================================


-- ============================================================
-- 7. DELETES
-- ============================================================


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================


-- ============================================================
-- 9. WHERE
-- ============================================================


-- ============================================================
-- 10. ORDER BY
-- ============================================================


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================


-- ============================================================
-- 12. GROUP BY
-- ============================================================


-- ============================================================
-- 13. HAVING
-- ============================================================


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================

```

---

# 17. Teste principal — reconstruir o banco do zero

Este é o teste mais importante da Sprint 5/5.

O objetivo é verificar se o `SPRINT5-5.sql` funciona como um projeto completo.

## Procedimento

### Etapa 1

Faça uma cópia de segurança dos seus arquivos.

### Etapa 2

Utilize um banco de teste ou remova apenas o banco criado para esta atividade, caso saiba exatamente o que está fazendo.

Exemplo:

```sql
DROP DATABASE nome_do_banco;
```

> **Atenção:** `DROP DATABASE` apaga completamente o banco. Execute somente sobre o banco criado para esta disciplina e somente se estiver seguro.

### Etapa 3

Execute o `SPRINT5-5.sql` desde a primeira linha.

### Etapa 4

Verifique se:

1. o banco é criado;
2. as tabelas são criadas;
3. as chaves funcionam;
4. os INSERTs funcionam;
5. os UPDATEs funcionam;
6. os DELETEs funcionam;
7. as consultas funcionam.

---

# 18. Se não quiser utilizar DROP DATABASE

Você pode criar um banco temporário para testar a reconstrução.

Exemplo:

```text
meu_banco_teste_final
```

Adapte temporariamente:

```sql
CREATE DATABASE meu_banco_teste_final;

USE meu_banco_teste_final;
```

Execute todo o projeto nesse banco.

Depois da validação, utilize no arquivo final o nome correto do projeto.

---

# 19. Validação com SHOW TABLES

Execute:

```sql
SHOW TABLES;
```

Confira se todas as tabelas aparecem.

### Resultado esperado

Quantidade de tabelas:

```
5
```

Quantidade encontrada:

```text
5
```

- [X] corresponde ao esperado.

---

# 20. Validação com DESCRIBE

Para cada tabela:

```sql
DESCRIBE nome_tabela;
```

Confirme:

- tipos;
- nulabilidade;
- chaves;
- valores padrão.

---

# 21. Validação com SHOW CREATE TABLE

Utilize:

```sql
SHOW CREATE TABLE nome_tabela;
```

Esse comando permite verificar a estrutura completa criada pelo MySQL.

Confirme:

- `PRIMARY KEY`;
- `FOREIGN KEY`;
- `UNIQUE`;
- `DEFAULT`;
- constraints.

---

# 22. Testando a integridade referencial

Faça pelo menos um teste para confirmar que uma `FOREIGN KEY` está funcionando.

Exemplo conceitual:

tentar inserir um registro dependente utilizando um identificador inexistente.

Registre:

### Tabela testada

```text
AGENDAMENTO
```

### Restrição testada

```text
fk_CPF (FOREIGN KEY apontando para CLIENTES.CPF)
```

### Resultado

> Sucesso no bloqueio: Ao tentar executar o comando de teste INSERT INTO AGENDAMENTO (DATA_AGENDAMENTO, CPF, NOME_SERVICO) VALUES ('2026-10-20 14:00:00', '00000000000', 'Corte Feminino');, o MySQL retornou o Erro 1452 (Cannot add or update a child row: a foreign key constraint fails). O banco de dados recusou a operação corretamente, comprovando que a chave estrangeira impede a criação de agendamentos associados a clientes não cadastrados.

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text
CPF (tabela CLIENTES)
```

### Resultado

> Sucesso no bloqueio: Ao tentar executar a inserção de um cliente com CPF duplicado

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text
NOME_SERVICO (tabela SERVICOS)  
NOME (tabela CLIENTES)
```

### Resultado

> Sucesso no bloqueio: Ao tentar inserir um registro sem preencher um campo obrigatório

---

# 25. Testando consultas

Execute todas as consultas do `SPRINT5-5.sql`.

Para cada uma:

1. execute;
2. observe o resultado;
3. verifique se responde à pergunta proposta;
4. corrija caso necessário.

---

# 26. Consulta final mais importante

Escolha a consulta que melhor demonstra a utilidade do seu banco.

### Qual é a margem de lucro unitária e o detalhamento de preços de cada produto comercializado no salão?

> Escreva aqui.

### SQL

```sql
-- SELECT 
    NOME_PRODUTO,
    PRECO_COMPRA,
    PRECO_VENDA,
    (PRECO_VENDA - PRECO_COMPRA) AS LUCRO_UNITARIO
FROM PRODUTOS
ORDER BY LUCRO_UNITARIO DESC;

```

### Resultado esperado

> Uma tabela contendo todos os produtos cadastrados, informando o custo de aquisição, valor de venda e a margem de lucro calculada em ordem decrescente (do item mais rentável ao menos rentável).

### Por que essa consulta é importante?

> É a consulta mais estratégica do ponto de vista de gestão financeira, pois fornece clareza imediata sobre quais itens trazem mais retorno financeiro ao salão, permitindo direcionar campanhas de vendas e renegociar custos com fornecedores.

---

# 27. Consulta final mais complexa

### Pergunta

> Quais serviços do salão possuem agendamentos registrados no sistema?

### SQL

```sql
SELECT 
    NOME_SERVICO, 
    COUNT(*) AS TOTAL_AGENDAMENTOS
FROM AGENDAMENTO
GROUP BY NOME_SERVICO
HAVING COUNT(*) > 0;

```

### Conceitos utilizados

- [ ] WHERE
- [X] ORDER BY
- [X] agregação
- [X] GROUP BY
- [X] HAVING
- [ ] expressão
- [ ] outro

### Explique

> Esta consulta é a mais complexa do projeto pois exige o agrupamento de múltiplos registros (GROUP BY) combinado à função de agregação COUNT(*) para contabilizar o número de agendamentos por serviço. Além disso, utiliza a cláusula HAVING para aplicar um filtro condicional diretamente sobre o valor retornado pela agregação (o que não seria possível utilizando apenas o WHERE).

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE |Sucesso  |Não|
| CREATE TABLE |Sucesso  |Não|
| PRIMARY KEY | Sucesso|Não|
| FOREIGN KEY | Sucesso |Não|
| NOT NULL | Sucesso |Não|
| UNIQUE | Sucesso |Não|
| INSERT |Sucesso  | Ajustada sintaxe do script |
| UPDATE | Sucesso |Não|
| DELETE |  Sucesso| Ajustada FK para não violar integridade |
| SELECT |Sucesso  |Não|
| WHERE | Sucesso |Não|
| ORDER BY |Sucesso  |Não|
| GROUP BY | Sucesso |Não|
| HAVING |Sucesso  |Não|
| funções de agregação |Sucesso  |Não|

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
|Erro ao re-executar o script de teste do zero (Erro 1050 / Erro 1062)|Tabelas ou registros já existentes de execuções anteriores|Inclusão das cláusulas DROP DATABASE IF EXISTS e DROP TABLE IF EXISTS no topo do arquivo .sql|
|Erro ao tentar deletar cliente (Erro 1452 / 1451)|O registro possuía vínculo direto em AGENDAMENTO via FOREIGN KEY|Ajustado o comando DELETE no script final para atuar sobre tabela/registro sem dependência ativa|
|  |  |  |
|  |  |  |

Caso não tenha ocorrido nenhum problema:

> Nenhum problema identificado após a execução completa do projeto.

---

# 30. Uso de LLMs na revisão final

O uso de LLMs continua permitido como apoio.

Nesta etapa, uma LLM poderá ser utilizada para:

- revisar sintaxe;
- identificar erros;
- explicar mensagens do MySQL;
- sugerir testes;
- revisar relacionamentos;
- revisar consultas;
- melhorar organização e legibilidade.

Entretanto, antes de aceitar qualquer sugestão:

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

O aluno deverá ser capaz de explicar todo o código entregue.

---

# 31. Prompt sugerido para revisão final com LLM

Você poderá utilizar um prompt semelhante:

```text
Atue como revisor técnico de Banco de Dados MySQL.

Estou finalizando um projeto individual de banco de dados.

Vou fornecer meu script SQL completo.

Analise:

1. se o CREATE DATABASE está correto;
2. se as tabelas estão em ordem adequada;
3. se todas as PRIMARY KEY estão corretas;
4. se as FOREIGN KEY estão corretas;
5. se existem problemas com tipos de dados;
6. se as restrições estão coerentes;
7. se os INSERTs respeitam as FKs;
8. se UPDATE e DELETE possuem WHERE adequado;
9. se as consultas respondem perguntas coerentes;
10. se GROUP BY e HAVING estão corretos;
11. se o script pode ser executado do início ao fim no MySQL Workbench.

Não reescreva todo o projeto automaticamente.

Liste primeiro os problemas encontrados.

Para cada problema, explique:
- onde está;
- por que ocorre;
- como corrigir;
- qual conceito está envolvido.

Ao final, apresente um checklist de validação.
```

---

# 32. Arquivos que devem existir antes do PR

Ao final da Sprint 5/5, a pasta individual deverá conter:

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql

SPRINT4-5.md
SPRINT4-5.sql

SPRINT5-5.md
SPRINT5-5.sql
```

Total esperado:

```text
9 arquivos
```

---

# 33. Não remova arquivos anteriores

Todos os arquivos deverão permanecer no histórico da atividade.

Não substitua:

```text
SPRINT2-5.sql
```

por:

```text
SPRINT5-5.sql
```

Os dois devem permanecer.

O `SPRINT5-5.sql` representa a versão integrada final.

Os arquivos anteriores representam a evolução do projeto.

---

# 34. Commit da Sprint 5/5

O commit final da Sprint deverá incluir:

```text
SPRINT5-5.md
SPRINT5-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 5 de 5 - validação final
```

---

# 35. Antes de abrir o Pull Request

Confirme:

- [X] estou na minha branch individual;
- [X] todos os commits foram enviados ao GitHub;
- [X] não alterei arquivos de outro aluno;
- [X] não alterei arquivos de outra instituição;
- [X] não alterei arquivos administrativos do repositório;
- [X] os 9 arquivos da atividade estão presentes;
- [X] os arquivos `.md` estão preenchidos;
- [X] os arquivos `.sql` foram testados;
- [X] o `SPRINT5-5.sql` executa do início ao fim;
- [X] removi nomes genéricos dos modelos;
- [X] não deixei senhas ou credenciais;
- [X] compreendo o código entregue.

---

# 36. Abrindo o Pull Request final

Agora, e somente agora, o aluno deverá abrir o Pull Request.

O PR deverá ter como destino:

```text
main
```

A branch de origem deverá ser a branch individual utilizada durante as cinco Sprints.

---

# 37. Título do Pull Request

Utilize o padrão definido para sua instituição.

Exemplo UNEMAT:

```text
[N1][UNEMAT][seu-login-github] Sprints 1-5 - Nome do Banco
```

Exemplo UFR:

```text
[N1][UFR][seu-login-github] Sprints 1-5 - Nome do Banco
```

Substitua:

```text
seu-login-github
```

pelo seu usuário real do GitHub.

Substitua:

```text
Nome do Banco
```

pelo nome do seu projeto.

---

# 38. Descrição sugerida para o Pull Request

Utilize uma descrição semelhante:

```text
## Identificação

Aluno: [nome completo]

Instituição: [UNEMAT ou UFR]

Banco desenvolvido: [nome]

## Descrição

Este Pull Request apresenta a entrega final das Sprints 1/5 a 5/5 da disciplina de Laboratório de Banco de Dados.

## Arquivos entregues

- SPRINT1-5.md
- SPRINT2-5.md
- SPRINT2-5.sql
- SPRINT3-5.md
- SPRINT3-5.sql
- SPRINT4-5.md
- SPRINT4-5.sql
- SPRINT5-5.md
- SPRINT5-5.sql

## Validação

- [x] Banco testado no MySQL Workbench
- [x] Estrutura validada
- [x] Dados inseridos
- [x] DML validado
- [x] Consultas testadas
- [x] Script final executado
```

---

# 39. GitHub Actions

Depois de abrir o PR, o GitHub executará automaticamente as validações configuradas pelo professor.

Observe a área:

```text
Checks
```

ou:

```text
Actions
```

Caso a validação falhe:

1. leia a mensagem apresentada;
2. identifique o arquivo com problema;
3. corrija localmente;
4. faça novo commit;
5. faça push para a mesma branch;
6. aguarde a nova validação.

> Não abra outro Pull Request para corrigir o mesmo trabalho.

---

# 40. Se o GitHub Actions reprovar

Exemplos possíveis:

```text
arquivo obrigatório ausente
arquivo vazio
CREATE DATABASE ausente
CREATE TABLE ausente
INSERT INTO ausente
SELECT ausente
quantidade insuficiente de commits
nome de branch incorreto
arquivo alterado fora da pasta permitida
```

Leia a mensagem antes de modificar o projeto.

---

# 41. Não tente contornar a validação

É proibido:

- alterar o workflow;
- apagar arquivos para evitar validação;
- modificar arquivos de configuração;
- alterar arquivos de outro aluno;
- modificar a `main`;
- criar arquivos falsos apenas para passar no GitHub Actions.

A validação automática é parte do processo de entrega.

---

# 42. Checklist técnico final

## Banco

- [ ] `CREATE DATABASE` funciona;
- [ ] `USE` funciona;
- [ ] todas as tabelas são criadas;
- [ ] nenhuma tabela necessária está ausente.

## Estrutura

- [ ] todas as tabelas possuem PK;
- [ ] FKs estão corretas;
- [ ] tipos de dados estão coerentes;
- [ ] `NOT NULL` está coerente;
- [ ] `UNIQUE` está coerente;
- [ ] `DEFAULT` está coerente.

## Dados

- [ ] INSERTs funcionam;
- [ ] dados são coerentes;
- [ ] FKs são respeitadas.

## Manipulação

- [ ] UPDATEs funcionam;
- [ ] UPDATEs possuem `WHERE`;
- [ ] DELETEs funcionam;
- [ ] DELETEs possuem `WHERE`.

## Consultas

- [ ] SELECT funciona;
- [ ] WHERE funciona;
- [ ] ORDER BY funciona;
- [ ] COUNT funciona;
- [ ] SUM funciona quando aplicável;
- [ ] AVG funciona quando aplicável;
- [ ] MIN/MAX funcionam;
- [ ] GROUP BY funciona;
- [ ] HAVING funciona.

## Arquivos

- [ ] `SPRINT1-5.md`;
- [ ] `SPRINT2-5.md`;
- [ ] `SPRINT2-5.sql`;
- [ ] `SPRINT3-5.md`;
- [ ] `SPRINT3-5.sql`;
- [ ] `SPRINT4-5.md`;
- [ ] `SPRINT4-5.sql`;
- [ ] `SPRINT5-5.md`;
- [ ] `SPRINT5-5.sql`.

---

# 43. Autoavaliação

Responda brevemente.

## O que você considera que aprendeu melhor?

> Escreva aqui.

## Qual conteúdo apresentou maior dificuldade?

> Escreva aqui.

## Qual erro mais contribuiu para seu aprendizado?

> Escreva aqui.

## Qual parte do banco você considera mais bem implementada?

> Escreva aqui.

## Se tivesse mais tempo, o que melhoraria?

> Escreva aqui.

---

# 44. Critério de conclusão da Sprint 5/5

A Sprint 5/5 será considerada concluída quando o aluno:

1. revisar o planejamento inicial;
2. revisar a estrutura do banco;
3. revisar as chaves e restrições;
4. revisar os dados;
5. revisar DML;
6. revisar as consultas;
7. integrar todo o projeto em `SPRINT5-5.sql`;
8. executar o script final;
9. testar o funcionamento do banco;
10. preencher o `SPRINT5-5.md`;
11. realizar o commit da Sprint 5/5;
12. confirmar a presença dos arquivos anteriores;
13. abrir o Pull Request final;
14. acompanhar a validação automática do GitHub Actions.

---

# Entrega final

A entrega final da atividade será realizada pelo Pull Request.

Não será considerada entrega apenas:

- possuir os arquivos localmente;
