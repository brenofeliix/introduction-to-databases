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
Secretaria de Saúde - gestão de pacientes, atendimentos e unidades de saúde.
```

## Objetivo principal

> Organizar e centralizar as informações de pacientes e atendimentos da rede municipal de saúde, garantindo rastreabilidade do histórico clínico-administrativo e apoiando a gestão da secretaria..

## Quantidade final de tabelas

```text
7 tabelas
```

## Principais entidades do banco

1. Paciente
2. Profissional
3. Unidade_saude
4. Atendimento
5. Prontuario
6. Estoque_item
7. Obito

## O projeto final permaneceu igual ao planejamento inicial?

- [ ] Sim
- [x] Não

Caso tenha mudado, explique:

> Houve ajustes pontuais de obrigatoriedade e a coluna telefone, registrados no item 4.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| telefone em profissional | Sprint 2 | Atributo já previsto na Sprint 1, mas a coluna foi adicionada por ALTER TABLE para praticar o comando. |
| paciente.data_nascimento | Sprint 2 | Planejado como obrigatório, implementado como opcional. |
| paciente.endereco | Sprint 2 | Planejado como opcional, implementado como NOT NULL, para garantir a localização do paciente |
| unidade_saude.tipo | Sprint 2 | Planejado como obrigatório, implementado como opcional.|

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
| paciente | Sim | Sim (N/A) | Sim | Sim |
| profissional | Sim | Sim (N/A) | Sim | Sim |
| unidade_saude | Sim | Sim (N/A) | Sim | Sim |
| atendimento | Sim | Sim | Sim | Sim |
| prontuario | Sim | Sim | Sim | Sim |
| estoque_item | Sim | Sim | Sim | Sim|
| obito | Sim | Sim | Sim | Sim | 
---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| paciente | id_paciente | Sim |
| profissional | id_profissional | Sim |
| unidade_saude | id_unidade | Sim |
| atendimento | id_atendimento | Sim |
| prontuario | id_prontuario | Sim | 
| estoque_item | id_item | Sim |
| obito | id_obito | Sim | 

Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| atendimento | id_paciente | paciente | id_paciente |
| atendimento | id_profissional | profissional | id_profissional |
| atendimento | id_unidade | unidade_saude | id_unidade |
| prontuario | id_paciente | paciente | id_paciente |
| prontuario | id_atendimento | atendimento | id_atendimento |
| estoque_item | id_unidade | unidade_saude | id_unidade | 
| obito | id_paciente | paciente | id_paciente |
| obito | unidade_responsavel | unidade_saude | id_unidade |

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
| paciente | cpf | UNIQUE, NOT NULL | Evitar duplo cadastro da mesma pessoa física |
| profissional | registro_conselho | UNIQUE | Garantir que o mesmo número de conselho (ex: CRM) não pertence a duas pessoas |
| atendimento | status | DEFAULT 'AGENDADO' | Todo o novo atendimento nasce obrigatoriamente como agendado |
| prontuario | id_atendimento | UNIQUE | Um atendimento específico apenas pode gerar um único prontuário. |
| estoque_item | quantidade | DEFAULT 0 | O estoque não pode ficar nulo, assumindo 0 caso não se informe a quantidade inicial | 

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| paciente | 10 |
| profissional | 8 |
| unidade_saude | 6 |
| atendimento | 15 |
| prontuário | 11 |
| estoque_item | 10 |
| obito | 2 |

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
|  |  |
|  |  |

---

# 11. Revisão dos UPDATEs

Confirme:

- [x] os UPDATEs possuem `WHERE`;
- [x] alteram os registros esperados;
- [x] não modificam toda a tabela acidentalmente;
- [x] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
UPDATE atendimento SET data_hora = '2026-11-05 08:30:00' WHERE id_atendimento = 14;
UPDATE paciente SET telefone = '(66) 99905-0555', endereco = 'Rua das Acácias, 88 - Jardim Primavera' WHERE id_paciente = 5;
UPDATE profissional SET telefone = '(66) 98801-0007' WHERE id_profissional = 7;
UPDATE estoque_item SET quantidade = quantidade - 2 WHERE id_item = 3;

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
DELETE FROM estoque_item WHERE id_item = 9;
DELETE FROM atendimento WHERE id_atendimento = 12;

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
| SELECT | sim | Identificação de pacientes vinculados a uma unidade. |
| WHERE | sim | Identificação de vacinas com stock baixo (crítico). |
| ORDER BY | sim | Ordenação cronológica de agendamentos futuros. |
| COUNT | sim | Total de óbitos na rede municipal. |
| SUM | sim | Somatório de todas as vacinas disponíveis. |
| AVG | sim | Média de unidades em stock por medicamento. |
| MIN/MAX | sim  | Data do agendamento mais próximo e do mais distante. |
| GROUP BY | sim | Total de óbitos e tipo de atendimento mais frequente por unidade. |
| HAVING | sim | Filtro de profissionais que realizaram 2 ou mais atendimentos. |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quais pacientes foram atendidos em determinada unidade?

**Foi respondida?**

- [x] Sim
- [ ] Não

**Consulta utilizada:**

```sql
SELECT DISTINCT id_paciente 
FROM atendimento 
WHERE id_unidade = 2;

```

---

## Pergunta 2

> Quantos atendimentos cada profissional realizou no mês?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT id_profissional, COUNT(*) AS total_atendimentos 
FROM atendimento 
WHERE status = 'REALIZADO' 
GROUP BY id_profissional 
HAVING COUNT(*) >= 2;

```

---

## Pergunta 3

> Quais unidades têm estoque baixo de determinada vacina?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT id_unidade, nome, quantidade 
FROM estoque_item 
WHERE tipo = 'VACINA' AND quantidade < 50;

```

---

## Pergunta 4

> Qual o número de óbitos registrados por unidade/período?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT unidade_responsavel, COUNT(*) AS total_obitos 
FROM obito 
GROUP BY unidade_responsavel;

```

---

## Pergunta 5

> Quais pacientes têm atendimentos agendados para os próximos dias?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT id_paciente, data_hora, tipo_atendimento 
FROM atendimento 
WHERE status = 'AGENDADO' AND data_hora >= '2026-10-26'
ORDER BY data_hora ASC;

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
esperado 7
```

Quantidade encontrada:

```text
encontrado 7
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
atendimento
```

### Restrição testada

```text
FOREIGN KEY (id_paciente)
```

### Resultado

> Erro 1452 – Cannot add or update a child row: a foreign key constraint fails

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text
paciente.cpf
```

### Resultado

> Erro 1062 – Duplicate entry ‘10000000001’ for key ‘cpf’

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text
paciente.endereco
```

### Resultado

> Erro 1364 – Field ‘endereco’ doesn’t have a default value

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

> Quais unidades têm estoque baixo de determinada vacina? 

### SQL

```sql
SELECT id_unidade, nome, quantidade 
FROM estoque_item 
WHERE tipo = 'VACINA' AND quantidade < 50;

```

### Resultado esperado

> Lista contendo o ID das unidades, nome da vacina e a respetiva quantidade restante (menor que 50).

### Por que essa consulta é importante?

> Tem impacto administrativo e na saúde pública de forma imediata, garantindo a reposição de insumos críticos para que não falte imunização à população.

---

# 27. Consulta final mais complexa

### Pergunta

> Qual o tipo de atendimento mais frequente por unidade?

### SQL

```sql
SELECT id_unidade, tipo_atendimento, COUNT(*) AS frequencia 
FROM atendimento 
GROUP BY id_unidade, tipo_atendimento 
ORDER BY id_unidade, frequencia DESC;

```

### Conceitos utilizados

- [ ] WHERE
- [x] ORDER BY
- [x] agregação
- [x] GROUP BY
- [ ] HAVING
- [ ] expressão
- [ ] outro

### Explique

> Esta consulta utiliza o agrupamento simultâneo por duas colunas para criar subgrupos na rede hospitalar, ordenando o resultado pela frequência calculada (agregação COUNT) de forma descendente, exigindo boa visualização lógica dos relacionamentos.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | Sucesso | Nenhuma |
| CREATE TABLE | Sucesso | Nenhuma |
| PRIMARY KEY | Sucesso | Nenhuma |
| FOREIGN KEY | Sucesso | Nenhuma |
| NOT NULL | Sucesso | Nenhuma |
| UNIQUE | Sucesso | Nenhuma |
| INSERT | Sucesso | Nenhuma |
| UPDATE | Sucesso | Nenhuma |
| DELETE | Sucesso  | Nenhuma  |
| SELECT | Sucesso | Nenhuma |
| WHERE | Sucesso | Nenhuma |
| ORDER BY | Sucesso | Nenhuma |
| GROUP BY | Sucesso | Nenhuma  |
| HAVING | Sucesso | Nenhuma |
| funções de agregação | Sucesso | Nenhuma |

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
| Nenhum | Planeamento DDL sólido e executado na ordem correta. | Manutenção da estrutura |
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

> O planeamento estrutural do esquema em papel e a sua conversão exata para DDL, compreendendo como os relacionamentos suportam o banco de dados.

## Qual conteúdo apresentou maior dificuldade?

> O entendimento prático entre o filtro inicial WHERE e o filtro pós-agrupamento HAVING na estruturação de relatórios complexos.

## Qual erro mais contribuiu para seu aprendizado?

> As tentativas de exclusão de dados vinculados a uma chave estrangeira em tabelas filhas (que geraram erro), demonstrando perfeitamente a eficácia da integridade referencial.

## Qual parte do banco você considera mais bem implementada?

> O eixo central clínico: paciente -> atendimento -> prontuario, porque reflete de forma concisa e muito real a rotina de uma unidade de saúde primária.

## Se tivesse mais tempo, o que melhoraria?

> Adicionaria regras de validação por Triggers para automatizar baixas de stock após a prescrição de certos itens no prontuário.

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
