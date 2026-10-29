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
Locadora.
```

## Objetivo principal

> O principal objetivo do banco de dados é organizar e armazenar as informações de uma locadora de filmes, permitindo controlar o cadastro de clientes, funcionários, filmes e gêneros, além de registrar as locações realizadas. O banco deverá possibilitar a consulta e o gerenciamento dessas informações de forma estruturada, mantendo os relacionamentos entre os diferentes dados da locadora e garantindo a integridade das informações cadastradas.

## Quantidade final de tabelas

```text
6
```

## Principais entidades do banco

1. cliente
2. funcionario
3. genero
4. filme
5. locacao
6. item_locacao

## O projeto final permaneceu igual ao planejamento inicial?

- [ ] Sim
- [x] Não

Caso tenha mudado, explique:

> Meu planejamento inicial era o desevolvimento de um banco de dados de filmes de terror, para coonseguir desenvolver uma maior quantidade de tabelas para preencher o projeto de banco de dados foi pego a ideia original e modificado para o desenvolvimento de uma locadora.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| Ideia inical banco de dados de filmes de terror, para um banco de dados de uma locadora. | Sprint 1/5 | A alteração foi feita para o melhor desenvolvimento das entidades do banco de dados. |
|  |  |  |
|  |  |  |
|  |  |  |

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
| cliente | id_cliente | -- | Sim | Sim |
| funcionario | id_funcionario | -- | Sim | Sim |
| genero | id_genero | -- | Sim | Sim |
| filme | id_filme | id_genero | Sim | Sim |
| locacao | id_locacao | id_cliente, id_funcionario | Sim | Sim |
| item_locacao | id_item | id_locacao, id_filme | Sim | Sim |

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| cliente | id_cliente | Sim |
| funcionario | id_funcionario | Sim |
| genero | id_genero | Sim |
| filme | id_filme | Sim |
| locacao | id_locacao | Sim |
| item_locacao | id_item | Sim |

Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| filme | id_genero | genero | genero(id_genero) |
| locacao | id_cliente, id_funcionario | cliente, funcionario | cliente(id_cliente), funcionario(id_funcionario) |
| item_locacao | id_locacao, id_filme | locacao, filme | locacao(id_locacao), filme(id_filme) |
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
| cliente | cpf | UNIQUE, NOT NULL | Impede clientes com CPF duplicado ou sem CPF. |
| funcionario | cpf | UNIQUE, NOT NULL | Impede funcionários com CPF duplicado ou sem CPF. |
| genero | nome | UNIQUE, NOT NULL | Impede gêneros duplicados ou sem identificação. |
| item_locacao | id_locacao, id_filme | UNIQUE | Impede que o mesmo filme seja incluído duas vezes na mesma locação. |

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| cliente | 5 |
| funcionario | 5 |
| genero | 6 |
| filme | 6 |
| locacao | 5 |
| item_locacao | 5 |

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
| -- | -- |
| -- | -- |

---

# 11. Revisão dos UPDATEs

Confirme:

- [x] os UPDATEs possuem `WHERE`;
- [x] alteram os registros esperados;
- [x] não modificam toda a tabela acidentalmente;
- [x] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
UPDATE funcionario
SET cargo = 'Atendente'
WHERE id_funcionario = 2;

UPDATE filme
SET avaliacao = 7.5
WHERE id_filme = 5;

UPDATE cliente
SET telefone = '(66) 99999-7777'
WHERE id_cliente = 2;

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
DELETE FROM cliente
WHERE id_cliente = 6;

DELETE FROM item_locacao
WHERE id_locacao = 1
  AND id_filme = 2;

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
| SELECT | Sim | Quais clientes estão cadastrados? |
| WHERE | Sim | Quais filmes possuem avaliação ≥ 7,0? |
| ORDER BY | Sim | Quais filmes possuem as maiores avaliações? |
| COUNT | Sim | Quantas locações foram realizadas? |
| SUM | Sim | Qual foi o valor total da locação 1? |
| AVG | Sim | Qual é a avaliação média dos filmes? |
| MIN/MAX | Sim | Qual é a menor e a maior avaliação? |
| GROUP BY | Sim | Quantas locações cada cliente realizou? |
| HAVING | Sim | Quais funcionários registraram mais de uma locação? |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quais clientes estão cadastrados na locadora?

**Foi respondida?**

- [x] Sim
- [ ] Não

**Consulta utilizada:**

```sql
SELECT *
FROM cliente;

```

---

## Pergunta 2

> Quais filmes estão cadastrados e quais são seus respectivos gêneros?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT
    f.titulo,
    g.nome AS genero
FROM filme AS f
JOIN genero AS g
    ON f.id_genero = g.id_genero
ORDER BY f.titulo ASC;

```

---

## Pergunta 3

> Quantas locações cada cliente realizou?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT
    c.nome AS cliente,
    COUNT(l.id_locacao) AS quantidade_locacoes
FROM cliente AS c
LEFT JOIN locacao AS l
    ON c.id_cliente = l.id_cliente
GROUP BY
    c.id_cliente,
    c.nome;

```

---

## Pergunta 4

> Quais filmes foram mais alugados?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT
    f.titulo,
    g.nome AS genero,
    COUNT(i.id_filme) AS quantidade_locacoes
FROM filme AS f
JOIN genero AS g
    ON f.id_genero = g.id_genero
JOIN item_locacao AS i
    ON f.id_filme = i.id_filme
GROUP BY
    f.id_filme,
    f.titulo,
    g.nome
ORDER BY quantidade_locacoes DESC;

```

---

## Pergunta 5

> Quantos filmes existem cadastrados em cada gênero?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT
    g.nome AS genero,
    COUNT(f.id_filme) AS quantidade_filmes
FROM genero AS g
LEFT JOIN filme AS f
    ON g.id_genero = f.id_genero
GROUP BY
    g.id_genero,
    g.nome;

```

---

## Pergunta 6

> Quais funcionários registraram locações?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT DISTINCT
    f.nome AS funcionario,
    f.cargo
FROM funcionario AS f
JOIN locacao AS l
    ON f.id_funcionario = l.id_funcionario
ORDER BY f.nome ASC;

```

---

## Pergunta 7

> Qual foi o valor total de uma determinada locação? / (foi escolhida a locação 1)

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT
    l.id_locacao,
    SUM(
        DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria
    ) AS valor_total
FROM locacao AS l
JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
WHERE l.id_locacao = 1
GROUP BY l.id_locacao;

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

```text
6
```

Quantidade encontrada:

```text
6
```

- [x] corresponde ao esperado.

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
locacao
```

### Restrição testada

```text
FOREIGN KEY id_cliente
```

### Resultado

> Foi realizada uma tentativa de inserir uma locação utilizando um id_cliente inexistente. O MySQL rejeitou a operação, confirmando que a chave estrangeira está funcionando corretamente e impedindo referências a clientes não cadastrados.

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text
cliente.cpf
```

### Resultado

> Foi realizada uma tentativa de inserir um cliente com um CPF já existente. O MySQL rejeitou o registro, confirmando o funcionamento da restrição UNIQUE.

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text
genero.nome
```

### Resultado

> Foi realizada uma tentativa de inserir um gênero com valor NULL no campo nome. O MySQL impediu a inserção, confirmando o funcionamento da restrição NOT NULL.

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

### Pergunta

> Qual foi o valor total de cada locação?

### SQL

```sql
SELECT
    l.id_locacao,
    c.nome AS cliente,
    SUM(
        DATEDIFF(l.data_devolucao, l.data_locacao)
        * i.valor_diaria
    ) AS valor_total
FROM locacao AS l
JOIN cliente AS c
    ON l.id_cliente = c.id_cliente
JOIN item_locacao AS i
    ON l.id_locacao = i.id_locacao
GROUP BY
    l.id_locacao,
    c.nome
ORDER BY l.id_locacao;

```

### Resultado esperado

> A consulta deve apresentar o identificador de cada locação, o nome do cliente e o valor total correspondente, calculado com base na quantidade de dias e no valor da diária dos filmes vinculados à locação.

### Por que essa consulta é importante?

> Essa consulta é importante porque reúne informações de diferentes tabelas e transforma os dados registrados em uma informação útil para a operação da locadora, permitindo identificar quanto deve ser cobrado por cada locação.

---

# 27. Consulta final mais complexa

### Pergunta

> Quais filmes foram mais alugados?

### SQL

```sql
SELECT
    f.titulo,
    g.nome AS genero,
    COUNT(i.id_filme) AS quantidade_locacoes
FROM filme AS f
JOIN genero AS g
    ON f.id_genero = g.id_genero
JOIN item_locacao AS i
    ON f.id_filme = i.id_filme
GROUP BY
    f.id_filme,
    f.titulo,
    g.nome
ORDER BY quantidade_locacoes DESC;

```

### Conceitos utilizados

- [ ] WHERE
- [x] ORDER BY
- [x] agregação
- [x] GROUP BY
- [ ] HAVING
- [ ] expressão
- [x] outro: JOIN

### Explique

> Essa consulta foi considerada a mais complexa porque relaciona três tabelas diferentes por meio de JOIN, utiliza COUNT() para contabilizar a quantidade de locações de cada filme, GROUP BY para agrupar os registros e ORDER BY para apresentar os filmes em ordem decrescente de quantidade de locações.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | Executado com sucesso | Não |
| CREATE TABLE | As 6 tabelas foram criadas | Não |
| PRIMARY KEY | Funcionando corretamente | Não |
| FOREIGN KEY | Funcionando corretamente | Não* |
| NOT NULL | Funcionando corretamente | Não* |
| UNIQUE | Funcionando corretamente | Não* |
| INSERT | Executado com sucesso | Não |
| UPDATE | Executado com sucesso | Não |
| DELETE | Executado com sucesso | Não |
| SELECT | Executado com sucesso | Não |
| WHERE | Executado com sucesso | Não |
| ORDER BY | Executado com sucesso | Não |
| GROUP BY | Executado com sucesso | Não |
| HAVING | Executado com sucesso | Não |
| funções de agregação | Executadas com sucesso | Não |

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |

Caso não tenha ocorrido nenhum problema:

> Nenhum Nenhum problema identificado após a execução completa do projeto no banco temporário utilizado para validação.

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

- [x] estou na minha branch individual;
- [x] todos os commits foram enviados ao GitHub;
- [x] não alterei arquivos de outro aluno;
- [x] não alterei arquivos de outra instituição;
- [x] não alterei arquivos administrativos do repositório;
- [x] os 9 arquivos da atividade estão presentes;
- [x] os arquivos `.md` estão preenchidos;
- [x] os arquivos `.sql` foram testados;
- [x] o `SPRINT5-5.sql` executa do início ao fim;
- [x] removi nomes genéricos dos modelos;
- [x] não deixei senhas ou credenciais;
- [x] compreendo o código entregue.

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

- [x] `CREATE DATABASE` funciona;
- [x] `USE` funciona;
- [x] todas as tabelas são criadas;
- [x] nenhuma tabela necessária está ausente.

## Estrutura

- [x] todas as tabelas possuem PK;
- [x] FKs estão corretas;
- [x] tipos de dados estão coerentes;
- [x] `NOT NULL` está coerente;
- [x] `UNIQUE` está coerente;
- [x] `DEFAULT` está coerente.

## Dados

- [x] INSERTs funcionam;
- [x] dados são coerentes;
- [x] FKs são respeitadas.

## Manipulação

- [x] UPDATEs funcionam;
- [x] UPDATEs possuem `WHERE`;
- [x] DELETEs funcionam;
- [x] DELETEs possuem `WHERE`.

## Consultas

- [x] SELECT funciona;
- [x] WHERE funciona;
- [x] ORDER BY funciona;
- [x] COUNT funciona;
- [x] SUM funciona quando aplicável;
- [x] AVG funciona quando aplicável;
- [x] MIN/MAX funcionam;
- [x] GROUP BY funciona;
- [x] HAVING funciona.

## Arquivos

- [x] `SPRINT1-5.md`;
- [x] `SPRINT2-5.md`;
- [x] `SPRINT2-5.sql`;
- [x] `SPRINT3-5.md`;
- [x] `SPRINT3-5.sql`;
- [x] `SPRINT4-5.md`;
- [x] `SPRINT4-5.sql`;
- [x] `SPRINT5-5.md`;
- [x] `SPRINT5-5.sql`.

---

# 43. Autoavaliação

Responda brevemente.

## O que você considera que aprendeu melhor?

> Considero que aprendi melhor a organização e o relacionamento entre tabelas e a importância da ordem de criação e preenchimento das tabelas.

## Qual conteúdo apresentou maior dificuldade?

> O conteúdo que apresentou maior dificuldade foi a utilização de consultas envolvendo várias tabelas, especialmente com JOIN, GROUP BY, funções de agregação e HAVING, pois foi necessário compreender como os dados de tabelas diferentes estavam relacionados.

## Qual erro mais contribuiu para seu aprendizado?

> Um dos pontos que mais contribuiu para meu aprendizado foi compreender que registros relacionados por chaves estrangeiras não podem ser excluídos livremente. Durante a Sprint 3, foi necessário analisar quais registros poderiam ser removidos sem comprometer a integridade referencial do banco.

## Qual parte do banco você considera mais bem implementada?

> Considero os relacionamentos entre cliente, funcionario, locacao, item_locacao, filme e genero uma das partes mais bem implementadas, pois permitem representar de forma organizada o funcionamento de uma locadora e realizar consultas envolvendo diferentes informações.

## Se tivesse mais tempo, o que melhoraria?

> Se tivesse mais tempo, acrescentaria uma quantidade maior de registros, novas informações relacionadas às locações e mais consultas para analisar o histórico dos clientes, os filmes mais procurados e os valores obtidos com as locações.

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
- possuir os arquivos apenas no Fork;
- possuir os arquivos em uma branch sem PR;
- enviar capturas de tela;
- enviar somente o arquivo `.sql`.

A entrega deverá estar registrada no repositório por meio do Pull Request final.

---

# Fluxo completo da atividade

```text
SPRINT1-5.md
Planejamento
      ↓
COMMIT

SPRINT2-5.md
SPRINT2-5.sql
DDL
      ↓
COMMIT

SPRINT3-5.md
SPRINT3-5.sql
DML
      ↓
COMMIT

SPRINT4-5.md
SPRINT4-5.sql
CONSULTAS
      ↓
COMMIT

SPRINT5-5.md
SPRINT5-5.sql
INTEGRAÇÃO E VALIDAÇÃO
      ↓
COMMIT
      ↓
PULL REQUEST
      ↓
GITHUB ACTIONS
      ↓
ENTREGA FINAL
```
