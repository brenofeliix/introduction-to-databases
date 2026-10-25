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
Clinica_Ser
```

## Objetivo principal

> Escreva aqui.
Ele é a representação de uma clinica que realiza exames radiologicos, apenas colaboradores e diretoria, Nome completo, data de nascimento, telefone, sexo, cpf e imgens.
Pesquisa, arquivamento de imagens em jpg, laudos em pdf e agendamento.

## Quantidade final de tabelas

```text
6 tabelas
```

## Principais entidades do banco

1. Paciente
2. Médico
3. Exame
4. Agendamento
5. Resultado
6. Convênio

## O projeto final permaneceu igual ao planejamento inicial?

- [V] Sim
- [ ] Não

Caso tenha mudado, explique:

> Escreva aqui.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
|  |  |  |
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
| --- | --- | --- | --- | --- |
|Paciente| Sim (id_paciente) | Sim (id_convenio) | Sim (texto, data, inteiro) | Sim (cpf UNIQUE, NOT NULL) |
|Médico | Sim (id_medico) | Não possui | Sim | Sim (cro UNIQUE, NOT NULL) |
|Exame | Sim (id_exame) | Não possui | Sim | Sim (preco NOT NULL, >0) |
|Agendamento| Sim (id_agendamento) | Sim (id_paciente, id_exame, id_medico) | Sim | Sim (FKs, data_hora NOT NULL) |
|Resultado | Sim (id_resultado) | Sim (id_exame) | Sim | Sim (FK, laudo NOT NULL) |
|Convênio| Sim (id_convenio) | Não possui | Sim | Sim (nome_convenio NOT NULL) |
---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
| --- | --- | --- |
| Paciente | id_paciente | Sim |
| Médico | id_medico | Sim |
| Exame | id_exame | Sim |
| Agendamento | id_agendamento | Sim |
| Resultado | id_resultado | Sim |
| Convênio | id_convenio | Sim |
Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
| --- | --- | --- | --- |
| Paciente | id_convenio | Convênio | id_convenio |
| Agendamento | id_paciente | Paciente | id_paciente |
| Agendamento | id_exame | Exame | id_exame |
| Agendamento | id_medico | Médico | id_medico |
| Resultado | id_exame | Exame | id_exame |

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
| --- | --- | --- | --- |
| **Paciente| cpf | UNIQUE, NOT NULL | Evita duplicidade de pacientes com o mesmo CPF |
| **Paciente** | id_paciente | PRIMARY KEY, AUTO_INCREMENT | Garante identificação única de cada paciente |
| **Médico| cro| UNIQUE, NOT NULL | Impede cadastro de médicos repetidos com o mesmo CRM |
| **Exame** | preco | NOT NULL, CHECK (preco > 0) | Impede exames sem preço ou com valor negativo |
| **Agendamento** | id_paciente, id_exame, id_medico | FOREIGN KEY | Garante que o agendamento esteja vinculado a registros existentes |
| **Resultado** | id_exame | FOREIGN KEY | Assegura que só exista resultado para exame realizado |

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
| --- | --- |
| Paciente | 20–30 |
| Médico | 5–10 |
| Exame | 10–15 |
| Agendamento | 50–80 |
| Resultado | 40–60 |
| Convênio | 5–8 |

Pergunte:

- existem dados suficientes para testar relacionamentos?
- existem valores diferentes para permitir filtros?
- existem grupos diferentes para testar `GROUP BY`?
- existem valores suficientes para `SUM`, `AVG`, `MIN` e `MAX`?
- existem registros que permitam testar `HAVING`?

---

# 10. Revisão dos INSERTs

Confirme:

- [ ] os INSERTs executam sem erro;
- [ ] respeitam as chaves estrangeiras;
- [ ] não existem duplicações indevidas;
- [ ] respeitam `NOT NULL`;
- [ ] respeitam `UNIQUE`;
- [ ] os dados fazem sentido no domínio.

Caso encontre problemas, registre:

| Problema | Correção realizada |

| --- | --- |
| Inserção de paciente sem CPF | Adicionado CPF obrigatório |
| Exame com preço nulo | Definido valor padrão positivo |
| Agendamento sem paciente vinculado | FK corrigida para paciente existente |

---

# 11. Revisão dos UPDATEs

Confirme:

- [V] os UPDATEs possuem `WHERE`;
- [V] alteram os registros esperados;
- [V] não modificam toda a tabela acidentalmente;
- [V] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
-- Cole aqui os UPDATEs mais importantes.
-- Atualizar telefone de um paciente
UPDATE Paciente
SET telefone = '66 99999-1234'
WHERE id_paciente = 5;

-- Alterar preço de um exame
UPDATE Exame
SET preco = 250.00
WHERE id_exame = 3;

-- Atualizar convênio de um paciente
UPDATE Paciente
SET id_convenio = 2
WHERE id_paciente = 10;

```

---

# 12. Revisão dos DELETEs

Confirme:

- [V] os DELETEs possuem `WHERE`;
- [V] não removem registros necessários ao funcionamento do projeto;
- [V] respeitam as dependências de `FOREIGN KEY`;
- [V] não comprometem consultas posteriores.

Liste os DELETEs finais:

```sql
-- Cole aqui.
-- Remover paciente específico
DELETE FROM Paciente
WHERE id_paciente = 15;

-- Remover agendamento cancelado
DELETE FROM Agendamento
WHERE id_agendamento = 22;

-- Remover convênio desativado
DELETE FROM Convenio
WHERE id_convenio = 4;

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
| SELECT |Sim|Quais pacientes estão cadastrados?|
| WHERE |Sim|Quais exames custam mais de R$ 200?|
| ORDER BY |Sim|Listar agendamentos ordenados por data|
| COUNT |Sim|Quantos exames cada médico solicitou?|
| SUM |Sim|Qual o total arrecadado em exames no mês?|
| AVG |Sim|Qual o preço médio dos exames?|
| MIN/MAX |Sim|Qual o exame mais barato e mais caro?|
| GROUP BY |Sim|Quantos pacientes existem por convênio?|
| HAVING |Sim|Quais convênios possuem mais de 10 pacientes?|

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Escreva aqui.

**Foi respondida?**

- [V] Sim
- [ ] Não

**Consulta utilizada:**

```sql
-- Cole aqui.
SELECT id_paciente, nome, cpf, data_nascimento
FROM Paciente;

```

---

## Pergunta 2

> Escreva aqui.

**Foi respondida?**

- [V] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT e.tipo_exame, a.data_hora, p.nome AS paciente
FROM Agendamento a
JOIN Exame e ON a.id_exame = e.id_exame
JOIN Paciente p ON a.id_paciente = p.id_paciente
WHERE a.data_hora BETWEEN '2026-09-01' AND '2026-09-30';

```

---

## Pergunta 3

> Escreva aqui.

**Foi respondida?**

- [V] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT m.nome AS medico, COUNT(a.id_agendamento) AS total_agendamentos
FROM Agendamento a
JOIN Medico m ON a.id_medico = m.id_medico
GROUP BY m.nome;

```

---

## Pergunta 4

> Escreva aqui.

**Foi respondida?**

- [V] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT c.nome_convenio, COUNT(p.id_paciente) AS total_pacientes
FROM Paciente p
JOIN Convenio c ON p.id_convenio = c.id_convenio
GROUP BY c.nome_convenio
ORDER BY total_pacientes DESC
LIMIT 1;

```

---

## Pergunta 5

> Escreva aqui.

**Foi respondida?**

- [V] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT r.id_resultado, r.laudo_texto, r.data_emissao, e.tipo_exame
FROM Resultado r
JOIN Exame e ON r.id_exame = e.id_exame
JOIN Agendamento a ON e.id_exame = a.id_exame
JOIN Paciente p ON a.id_paciente = p.id_paciente
WHERE p.nome = 'Maria Silva';

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

1. o banco é criado;V
2. as tabelas são criadas;V
3. as chaves funcionam;V
4. os INSERTs funcionam;V
5. os UPDATEs funcionam;V
6. os DELETEs funcionam;V
7. as consultas funcionam.V

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

- [V] corresponde ao esperado.

---

# 20. Validação com DESCRIBE

Para cada tabela:

```sql
DESCRIBE nome_tabela;
```
id_paciente → INT, PK, AUTO_INCREMENT

cpf → VARCHAR(11), UNIQUE, NOT NULL

id_convenio → INT, FK

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
PRIMARY KEY (id_agendamento)

FOREIGN KEY (id_paciente) → Paciente(id_paciente)

FOREIGN KEY (id_exame) → Exame(id_exame)

FOREIGN KEY (id_medico) → Medico(id_medico)
---

# 22. Testando a integridade referencial

Faça pelo menos um teste para confirmar que uma `FOREIGN KEY` está funcionando.

Exemplo conceitual:

tentar inserir um registro dependente utilizando um identificador inexistente.

Registre:

### Tabela testada

```text
Agendamento
```

### Restrição testada

```text
FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente)

```

### Resultado

> Escreva aqui.
INSERT INTO Agendamento (id_paciente, id_exame, id_medico, data_hora)
VALUES (999, 1, 1, '2026-09-25 09:00:00');
Erro retornado: Cannot add or update a child row: a foreign key constraint fails  
✔ Isso confirma que a integridade referencial está funcionando corretamente.

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text
Paciente.cpf
```

### Resultado

> Escreva aqui.
 Erro de duplicidade → a restrição UNIQUE funcionou corretamente, impedindo dois cadastros com o mesmo CPF.
---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text
Exame.preco
```

### Resultado

> Escreva aqui.
Erro de nulidade → a restrição NOT NULL funcionou corretamente, impedindo exame sem preço.
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

> Escreva aqui.
Qual é o convênio mais utilizado pelos pacientes?
### SQL

```sql
-- Cole aqui.
SELECT c.nome_convenio, COUNT(p.id_paciente) AS total_pacientes
FROM Paciente p
JOIN Convenio c ON p.id_convenio = c.id_convenio
GROUP BY c.nome_convenio
ORDER BY total_pacientes DESC
LIMIT 1;

```

### Resultado esperado

> Escreva aqui.
Nome do convênio mais popular e quantidade de pacientes vinculados.
### Por que essa consulta é importante?

> Escreva aqui.
Demonstra o uso real do banco para gestão estratégica da clínica, ajudando a identificar convênios mais relevantes para parcerias e negociações.
---

# 27. Consulta final mais complexa

### Pergunta

> Escreva aqui.
Quantos exames cada médico solicitou no último mês e quais médicos tiveram mais de 5 solicitações?
### SQL

```sql
-- Cole aqui.
SELECT m.nome AS medico, COUNT(a.id_agendamento) AS total_exames
FROM Agendamento a
JOIN Medico m ON a.id_medico = m.id_medico
WHERE MONTH(a.data_hora) = 9 AND YEAR(a.data_hora) = 2026
GROUP BY m.nome
HAVING COUNT(a.id_agendamento) > 5
ORDER BY total_exames DESC;

```

### Conceitos utilizados

- [V] WHERE
- [V] ORDER BY
- [V] agregação
- [V] GROUP BY
- [V] HAVING
- [V] expressão
- [V] outro

### Explique

> Escreva aqui.
Essa consulta combina filtros (WHERE), agrupamento (GROUP BY), agregação (COUNT), restrição de grupo (HAVING) e ordenação (ORDER BY). É útil para avaliar produtividade médica e identificar profissionais com maior demanda.
---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE |OK|NÃO|
| CREATE TABLE |OK|NÃO|
| PRIMARY KEY |OK|NÃO|
| FOREIGN KEY |OK|NÃO|
| NOT NULL |OK|NÃO|
| UNIQUE |OK|NÃO|
| INSERT |OK|NÃO|
| UPDATE |OK|NÃO|
| DELETE |OK|NÃO|
| SELECT |OK|NÃO|
| WHERE |OK|NÃO|
| ORDER BY |OK|NÃO|
| GROUP BY |OK|NÃO|
| HAVING |OK|NÃO|
| funções de agregação |OK|NÃO|

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
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

- [V] estou na minha branch individual;
- [V] todos os commits foram enviados ao GitHub;
- [V] não alterei arquivos de outro aluno;
- [V] não alterei arquivos de outra instituição;
- [V] não alterei arquivos administrativos do repositório;
- [V] os 9 arquivos da atividade estão presentes;
- [V] os arquivos `.md` estão preenchidos;
- [V] os arquivos `.sql` foram testados;
- [V] o `SPRINT5-5.sql` executa do início ao fim;
- [V] removi nomes genéricos dos modelos;
- [V] não deixei senhas ou credenciais;
- [V] compreendo o código entregue.

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

- [V] `CREATE DATABASE` funciona;
- [V] `USE` funciona;
- [V] todas as tabelas são criadas;
- [V] nenhuma tabela necessária está ausente.

## Estrutura

- [V] todas as tabelas possuem PK;
- [V] FKs estão corretas;
- [V] tipos de dados estão coerentes;
- [V] `NOT NULL` está coerente;
- [V] `UNIQUE` está coerente;
- [V] `DEFAULT` está coerente.

## Dados

- [V] INSERTs funcionam;
- [V] dados são coerentes;
- [V] FKs são respeitadas.

## Manipulação

- [V] UPDATEs funcionam;
- [V] UPDATEs possuem `WHERE`;
- [V] DELETEs funcionam;
- [V] DELETEs possuem `WHERE`.

## Consultas

- [V] SELECT funciona;
- [V] WHERE funciona;
- [V] ORDER BY funciona;
- [V] COUNT funciona;
- [V] SUM funciona quando aplicável;
- [V] AVG funciona quando aplicável;
- [V] MIN/MAX funcionam;
- [V] GROUP BY funciona;
- [V] HAVING funciona.

## Arquivos

- [V] `SPRINT1-5.md`;
- [V] `SPRINT2-5.md`;
- [V] `SPRINT2-5.sql`;
- [V] `SPRINT3-5.md`;
- [V] `SPRINT3-5.sql`;
- [V] `SPRINT4-5.md`;
- [V] `SPRINT4-5.sql`;
- [V] `SPRINT5-5.md`;
- [V] `SPRINT5-5.sql`.

---

# 43. Autoavaliação

Responda brevemente.

## O que você considera que aprendeu melhor?

> Escreva aqui.
pREENCHER SPRINT
## Qual conteúdo apresentou maior dificuldade?

> Escreva aqui.
GIT HUB
## Qual erro mais contribuiu para seu aprendizado?

> Escreva aqui.
GIT HUB
## Qual parte do banco você considera mais bem implementada?

> Escreva aqui.
SPRINT 2
## Se tivesse mais tempo, o que melhoraria?

> Escreva aqui.
BASICAMENTE TUDO
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
