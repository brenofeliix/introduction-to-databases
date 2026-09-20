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

> Verificação realizada, todos estão de acordo

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

```
Rh de uma sorveteria
```

## Objetivo principal

> Realização de buscas relacionadas ao Rh e estoque de uma sorveteria.

## Quantidade final de tabelas

```
7 Tabelas
```

## Principais entidades do banco

1. Funcionarios
2. Expediente
3. Estoque

## O projeto final permaneceu igual ao planejamento inicial?

- [ ] Sim
- [X] Não

Caso tenha mudado, explique:

> Enquanto a idea continuou a mesma, alguns planilhas tiveram que ser reimaginadas (como expediente e cargo) para ficar mais coerente e facil de se trabalhar com

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| Adicionado hora de entrada e saida | 2 | Realizado anteriormente eram apenas hora de entrada e hora extra, foi alterado para possibilitar hora de almoço e simplesmente registrar hora de saida |
| Cargo ganhou expediente base | 2 | Anteriormente parte do expediente, porém ficava mais facil deixar no cargo. Também tinha testado no Funcionario porém ficava com muitas repetições |

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
| FILIAL  | SIM | SIM | SIM | SIM |
| CARGO  | SIM | SIM | SIM | SIM |
| PRODUTO  | SIM | SIM | SIM | SIM |
| SETOR  | SIM | SIM | SIM | SIM |
| FUNCIONARIO  | SIM | SIM | SIM | SIM |

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| FILIAL | id_filial | Sim |
| CARGO | id_cargo | Sim |
| PRODUTO | id_produto | Sim |
| SETOR | id_setor | Sim |
| FUNCIONARIO | id_func | Sim |
| EXPEDIENTE | id_expediente | Sim |
| ESTOQUE | id_filial, id_produto | Não |

Verifique se cada registro pode ser identificado de forma única.

--- sim

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| FUNCIONARIO | id_cargo | CARGO | id_cargo |
| FUNCIONARIO | id_setor | SETOR | id_setor |
| FUNCIONARIO | id_filial | FILIAL | id_filial |
| EXPEDIENTE | id_func | FUNCIONARIO | id_func |
| ESTOQUE | id_filial | FILIAL | id_filial |
| ESTOQUE | id_produto | PRODUTO | id_produto |

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
| FUNCIONARIO | id_func | PRIMARY KEY + AUTO_INCREMENT | Identifica cada funcionário de forma única |
| FUNCIONARIO | cpf_func | UNIQUE + NOT NULL | Impede CPF repetido e CPF vazio |
| FUNCIONARIO | id_cargo | FOREIGN KEY + NOT NULL | Garante que o cargo exista |
| FUNCIONARIO | id_setor | FOREIGN KEY + NOT NULL | Garante que o setor exista |
| FUNCIONARIO | id_filial | FOREIGN KEY + NOT NULL | Garante que a filial exista |
| EXPEDIENTE | id_func | FOREIGN KEY + NOT NULL | Garante que o expediente pertença a funcionário existente |
| EXPEDIENTE | hora_extra | DEFAULT | Define 0 como valor padrão |
| ESTOQUE | id_filial, id_produto | PRIMARY KEY | Evita duplicidade do mesmo produto na mesma filial |

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| FILIAL | 5 |
| CARGO | 5 |
| PRODUTO | 5 |
| SETOR | 5 |
| FUNCIONARIO | 4 após o DELETE realizado |
| EXPEDIENTE | 4 após o DELETE relacionado ao funcionário removido |
| ESTOQUE | 5 |

Pergunte:

- existem dados suficientes para testar relacionamentos?
- existem valores diferentes para permitir filtros?
- existem grupos diferentes para testar `GROUP BY`?
- existem valores suficientes para `SUM`, `AVG`, `MIN` e `MAX`?
- existem registros que permitam testar `HAVING`?

---

# 10. Revisão dos INSERTs

Confirme:

- [X] os INSERTs executam sem erro;
- [X] respeitam as chaves estrangeiras;
- [X] não existem duplicações indevidas;
- [X] respeitam `NOT NULL`;
- [X] respeitam `UNIQUE`;
- [X] os dados fazem sentido no domínio.

Caso encontre problemas, registre:

| Problema | Correção realizada |
|---|---|
| O CPF foi renomeado durante a evolução do banco | Foi realizado ALTER TABLE para renomear cpf para cpf_func |
| O DELETE do funcionário possuía um expediente relacionado | O expediente do funcionário foi excluído antes do funcionário para respeitar a FOREIGN KEY |

---

# 11. Revisão dos UPDATEs

Confirme:

- [X] os UPDATEs possuem `WHERE`;
- [X] alteram os registros esperados;
- [X] não modificam toda a tabela acidentalmente;
- [X] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
UPDATE FUNCIONARIO
SET nome_func = 'Anna Paula'
WHERE id_func = 2;

UPDATE CARGO
SET salario_base = 4700.00
WHERE id_cargo = 1;

UPDATE ESTOQUE
SET quantidade = 30
WHERE id_filial = 2
  AND id_produto = 2;
```

---

# 12. Revisão dos DELETEs

Confirme:

- [X] os DELETEs possuem `WHERE`;
- [X] não removem registros necessários ao funcionamento do projeto;
- [X] respeitam as dependências de `FOREIGN KEY`;
- [X] não comprometem consultas posteriores.

Liste os DELETEs finais:

```sql
DELETE FROM EXPEDIENTE
WHERE id_func = 1;

DELETE FROM FUNCIONARIO
WHERE id_func = 1;
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
| SELECT |  |  |
| WHERE |  |  |
| ORDER BY |  |  |
| COUNT |  |  |
| SUM |  |  |
| AVG |  |  |
| MIN/MAX |  |  |
| GROUP BY |  |  |
| HAVING |  |  |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quais funcionários foram contratados no dia 1º de setembro?

**Foi respondida?**

- [X] Sim
- [ ] Não

**Consulta utilizada:**

```sql
SELECT
    f.nome_func AS funcionario,
    f.data_admissao AS data_admissao
FROM FUNCIONARIO f
WHERE DAY(f.data_admissao) = 1
AND MONTH(f.data_admissao) = 9
ORDER BY f.data_admissao ASC;
```

---

## Pergunta 2

> Quantos funcionários foram contratados no último mês?

**Foi respondida?**

- [X] Sim
- [ ] Não

```sql
SELECT
    COUNT(*) AS quantidade_funcionarios
FROM FUNCIONARIO f
WHERE f.data_admissao >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
```

---

## Pergunta 3

> Quantas filiais foram abertas nos últimos 4 anos?

**Foi respondida?**

- [X] Sim
- [ ] Não

```sql
SELECT
    COUNT(*) AS quantidade_filiais
FROM FILIAL f
WHERE f.data_abertura >= DATE_SUB(CURDATE(), INTERVAL 4 YEAR);
```

---

## Pergunta 4

> Quais funcionários possuem mais de 50 horas extras no ano?

**Foi respondida?**

- [X] Sim
- [ ] Não

```sql
SELECT
    f.nome_func AS funcionario,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras
FROM FUNCIONARIO f
JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
WHERE YEAR(e.data_batimento) = YEAR(CURDATE())
GROUP BY f.id_func, f.nome_func
HAVING SUM(CAST(e.hora_extra AS DECIMAL(10,2))) > 50
ORDER BY total_horas_extras DESC;
```

---

## Pergunta 5

> Quais produtos estão com estoque baixo?

**Foi respondida?**

- [X] Sim
- [ ] Não

```sql
SELECT
    p.nome_produto AS produto,
    e.quantidade AS quantidade_estoque
FROM ESTOQUE e
JOIN PRODUTO p
    ON e.id_produto = p.id_produto
WHERE e.quantidade < 25
ORDER BY e.quantidade ASC;
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
7
```

Quantidade encontrada:

```text
7
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
EXPEDIENTE
```

### Restrição testada

```text
FOREIGN KEY (id_func) REFERENCES FUNCIONARIO(id_func)
```

### Resultado

> Foi realizado um teste com um id_func inexistente. O MySQL rejeitou o INSERT, confirmando que a FOREIGN KEY impede o cadastro de um expediente para um funcionário que não existe. O comando inválido não foi mantido no SQL final.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text
FUNCIONARIO.cpf_func
```

### Resultado

> Foi realizado um teste de CPF duplicado. O MySQL rejeitou o INSERT, confirmando o funcionamento da restrição UNIQUE. O comando inválido não foi mantido no SQL final.

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text
PRODUTO.nome_produto
```

### Resultado

> Foi realizado um teste inserindo NULL em nome_produto. O MySQL rejeitou o INSERT, confirmando o funcionamento do NOT NULL. O comando inválido não foi mantido no SQL final.

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

> Quantos funcionários existem em cada filial e qual é o total de horas extras registrado em cada uma?

### SQL

```sql
SELECT
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(DISTINCT f.id_func) >= 1
ORDER BY total_horas_extras DESC;
```

### Resultado esperado

> A consulta apresenta as filiais que possuem funcionários, a quantidade de funcionários, o total de horas extras e o salário médio dos funcionários de cada filial.

### Por que essa consulta é importante?

> Ela reúne informações de várias tabelas do banco e permite analisar a situação dos funcionários por filial, relacionando quantidade de funcionários, horas extras e salário médio.

---

# 27. Consulta final mais complexa

### Pergunta

> Qual é o total de funcionários, horas extras e salário médio por filial?

### SQL

```sql
SELECT
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    SUM(CAST(e.hora_extra AS DECIMAL(10,2))) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN EXPEDIENTE e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(DISTINCT f.id_func) >= 1
ORDER BY total_horas_extras DESC;
```

### Conceitos utilizados

- [ ] WHERE
- [X] ORDER BY
- [X] agregação
- [X] GROUP BY
- [X] HAVING
- [ ] expressão
- [X] outro

### Explique

> A consulta usa JOIN para relacionar filial, funcionário, cargo e expediente. Depois utiliza COUNT, SUM e AVG para calcular informações por filial. O GROUP BY separa os resultados por filial, o HAVING mantém apenas as filiais com pelo menos um funcionário e o ORDER BY organiza pelo total de horas extras.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | Estrutura presente no script final | Não |
| CREATE TABLE | 7 tabelas criadas | Não |
| PRIMARY KEY | PKs definidas em todas as tabelas | Não |
| FOREIGN KEY | 6 FKs definidas e relacionamentos mantidos | Não |
| NOT NULL | Restrições mantidas nos campos necessários | Não |
| UNIQUE | cpf_func mantém UNIQUE | Não |
| INSERT | Dados inseridos respeitando a ordem das FKs | Não |
| UPDATE | 3 UPDATEs com WHERE | Não |
| DELETE | DELETE do expediente antes do funcionário dependente | Não |
| SELECT | Consultas presentes | Não |
| WHERE | Filtros presentes | Não |
| ORDER BY | Ordenações presentes | Não |
| GROUP BY | Agrupamentos presentes | Não |
| HAVING | Consulta com HAVING presente | Não |
| funções de agregação | COUNT, SUM, AVG, MIN e MAX presentes | Não |

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
| DELETE do funcionário 1 poderia gerar erro de FOREIGN KEY | Existia um registro em EXPEDIENTE ligado ao funcionário | Excluir primeiro o expediente e depois o funcionário |
| Testes de integridade geravam erros propositalmente | Os testes usavam CPF duplicado, NULL e FK inexistente | Os testes foram realizados para validar as restrições e os comandos inválidos foram retirados do SQL final |
| hora_extra está armazenada como texto | O campo foi definido como VARCHAR(10) no modelo realizado | Nas consultas de soma foi usado CAST para realizar a agregação numérica |

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

- [ ] estou na minha branch individual;
- [ ] todos os commits foram enviados ao GitHub;
- [ ] não alterei arquivos de outro aluno;
- [ ] não alterei arquivos de outra instituição;
- [ ] não alterei arquivos administrativos do repositório;
- [ ] os 9 arquivos da atividade estão presentes;
- [ ] os arquivos `.md` estão preenchidos;
- [ ] os arquivos `.sql` foram testados;
- [ ] o `SPRINT5-5.sql` executa do início ao fim;
- [ ] removi nomes genéricos dos modelos;
- [ ] não deixei senhas ou credenciais;
- [ ] compreendo o código entregue.

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

Aluno: Não informado

Instituição: Não informado

Banco desenvolvido: Rh_sorveteria

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

- [X] `CREATE DATABASE` funciona;
- [X] `USE` funciona;
- [X] todas as tabelas são criadas;
- [ ] nenhuma tabela necessária está ausente.

## Estrutura

- [X] todas as tabelas possuem PK;
- [X] FKs estão corretas;
- [X] tipos de dados estão coerentes;
- [X] `NOT NULL` está coerente;
- [X] `UNIQUE` está coerente;
- [ ] `DEFAULT` está coerente.

## Dados

- [X] INSERTs funcionam;
- [X] dados são coerentes;
- [ ] FKs são respeitadas.

## Manipulação

- [X] UPDATEs funcionam;
- [X] UPDATEs possuem `WHERE`;
- [X] DELETEs funcionam;
- [ ] DELETEs possuem `WHERE`.

## Consultas

- [X] SELECT funciona;
- [X] WHERE funciona;
- [X] ORDER BY funciona;
- [X] COUNT funciona;
- [X] SUM funciona quando aplicável;
- [X] AVG funciona quando aplicável;
- [X] MIN/MAX funcionam;
- [X] GROUP BY funciona;
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

> Aprendi melhor a criar a estrutura de um banco em MySQL, relacionar as tabelas com PRIMARY KEY e FOREIGN KEY e realizar consultas usando filtros, ordenações e funções de agregação.

## Qual conteúdo apresentou maior dificuldade?

> A parte que apresentou maior dificuldade foi trabalhar com os relacionamentos entre as tabelas e entender as dependências das FOREIGN KEY, principalmente na hora de excluir registros.

## Qual erro mais contribuiu para seu aprendizado?

> O erro que mais contribuiu foi tentar excluir um funcionário que ainda possuía um registro relacionado em EXPEDIENTE. Isso ajudou a entender melhor como a FOREIGN KEY protege os dados relacionados.

## Qual parte do banco você considera mais bem implementada?

> Considero que a parte de relacionamentos e consultas ficou bem implementada, principalmente a relação entre FUNCIONARIO, CARGO, SETOR, FILIAL e EXPEDIENTE e as consultas que usam essas tabelas.

## Se tivesse mais tempo, o que melhoraria?

> Melhoraria alguns tipos de dados e acrescentaria mais registros para deixar as consultas de agrupamento e horas extras mais completas. Também poderia melhorar a estrutura do estoque com mais informações sobre os produtos.

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
