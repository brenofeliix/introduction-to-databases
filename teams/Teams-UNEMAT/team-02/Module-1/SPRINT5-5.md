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
Sistema de Gerenciamento de Incidentes de Segurança.
```

## Objetivo principal

> Organizar e armazenar informações relacionadas aos incidentes de segurança, permitindo consultar e acompanhar os registros de forma estruturada — identificando incidentes, analistas responsáveis, dispositivos envolvidos, tipos de ameaças e ações de resposta.

## Quantidade final de tabelas

```text
analistas, dispositivos, tipos_ameacas, alertas, incidentes, acoes_resposta.
```

## Principais entidades do banco

1. Incidentes
2. Analistas
3. Dispositivos
4. Alertas
5. Tipos de Ameaças
6. Ações de Resposta.

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
| id_analista implementado como INT (planejado como INT(100)) | Sprint 2/5 | INT(100) não é uma sintaxe válida para chave primária no MySQL atual |
| Campos id_analista, id_dispositivo, id_ameaca e id_alerta de incidentes implementados como NULL (opcionais) | Sprint 2/5 | A regra de negócio 3 da Sprint 1/5 diz que um incidente "poderá" ser associado a um analista, ou seja, a associação não é obrigatória |
| Adição de DEFAULT CURRENT_TIMESTAMP nos campos de data | Sprint 2/5 | Garantir que todo registro tenha uma data de criação automática, mesmo sem ser informada no INSERT |


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
|analistas |Sim  | Não se aplica (não possui FK) |Sim  | Sim (UNIQUE em email) |
|dispositivos |Sim  | Não se aplica (não possui FK) | Sim | Sim (UNIQUE em ip_address) |
|tipos_ameacas  |Sim  | Não se aplica (não possui FK) | Sim | Sim |
|alertas  | Sim | Sim (id_dispositivo → dispositivos) | Sim| Sim (corrigido o DEFAULT de data_alerta) |
|incidentes  |Sim  | 	Sim (4 FKs: analistas, dispositivos, tipos_ameacas, alertas) | Sim | Sim |
|acoes_resposta  |Sim  |	Sim (id_incidente → incidentes)  | Sim | Sim |

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
|analistas  | id_analista | Sim |
|dispositivos  | id_dispositivo | Sim |
| tipos_ameacas | id_ameaca | Sim |
| alertas | id_alerta | Sim |
| incidentes | id_incidente | Sim |
| acoes_resposta | id_acao | Sim |


Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| alertas | id_dispositivo |dispositivos  | id_dispositivo |
| incidentes |id_analista  | analistas | id_analista |
|incidentes  | id_dispositivo | dispositivos | id_dispositivo |
| incidentes | id_ameaca | tipos_ameacas | id_ameaca |
| incidentes |id_alerta| alertas |id_alerta  |
| acoes_resposta | id_incidente | incidentes  | id_incidente |

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
|analistas  | email | UNIQUE | Evita analistas duplicados com o mesmo e-mail |
| dispositivos | ip_address | UNIQUE | Evita dispositivos duplicados com o mesmo IP |
| incidentes |titulo, descricao, severidade, status  | NOT NULL | Todo incidente deve possuir título, descrição, severidade e status (regra de negócio 1 da Sprint 1/5) |
| incidentes | status | DEFAULT 'ABERTO' | Todo incidente novo começa como aberto (regra de negócio 2) |
|dispositivos  | ativo | DEFAULT TRUE | Um dispositivo cadastrado é considerado ativo até que se informe o contrário |
|Todas as PKs  | id_* | PRIMARY KEY + AUTO_INCREMENT | Identifica cada registro de forma única, sem repetição |


---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| analistas | 5 |
| dispositivos | 5 |
| tipos_ameacas | 5 |
| alertas | 4 (5 inseridos, 1 excluído na Sprint 3/5) |
| incidentes | 5 |
| acoes_resposta | 5 (6 inseridos, 1 excluído na Sprint 3/5) |

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
-- 
UPDATE incidentes
SET data_encerramento = CURRENT_TIMESTAMP
WHERE id_incidente = 5;

UPDATE dispositivos
SET ativo = TRUE
WHERE id_dispositivo = 5;

UPDATE incidentes
SET status = 'RESOLVIDO',
    data_encerramento = CURRENT_TIMESTAMP
WHERE id_incidente = 1;

UPDATE analistas
SET cargo = 'Analista de Segurança Sênior'
WHERE id_analista = 2;
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
--
DELETE FROM alertas
WHERE id_alerta = 4;

DELETE FROM acoes_resposta
WHERE id_acao = 6;

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
| SELECT | Sim | Visão geral dos incidentes cadastrados |
| WHERE | Sim | Quais incidentes estão atualmente abertos? |
| ORDER BY | Sim | Quais foram os incidentes mais recentes? |
| COUNT | Sim | Quantos incidentes já foram registrados no total? |
| SUM |Sim  | Quantos incidentes críticos/altos cada analista acompanha? |
| AVG |Sim  | Em média, quantos incidentes cada analista está acompanhando? |
| MIN/MAX | Sim | Qual foi o incidente mais antigo e o mais recente? |
| GROUP BY | Sim | Quantos incidentes foram registrados por tipo de ameaça? |
| HAVING | Sim | Quais dispositivos estão relacionados a mais de um incidente? |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quais incidentes de segurança estão atualmente abertos?

**Foi respondida?**

- [x] Sim
- [ ] Não

**Consulta utilizada:**

```sql
-- 
SELECT titulo, severidade, status, data_identificacao
FROM incidentes
WHERE status = 'ABERTO';

```

---

## Pergunta 2

> Quais incidentes possuem severidade alta ou crítica?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
-- 
SELECT titulo, severidade, status
FROM incidentes
WHERE severidade IN ('ALTA', 'CRITICA')
  AND status <> 'ENCERRADO';

```

---

## Pergunta 3

> Quais incidentes estão sob responsabilidade de cada analista?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
-- 
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.status
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
ORDER BY a.nome;

```

---

## Pergunta 4

> Quais dispositivos estão relacionados ao maior número de incidentes?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
--
SELECT d.nome_dispositivo,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM dispositivos d
JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(i.id_incidente) > 1
ORDER BY quantidade_incidentes DESC;

```

---

## Pergunta 5

> Quantos incidentes foram registrados por tipo de ameaça?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
-- 
SELECT t.nome_ameaca,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM tipos_ameacas t
LEFT JOIN incidentes i ON i.id_ameaca = t.id_ameaca
GROUP BY t.id_ameaca, t.nome_ameaca
ORDER BY quantidade_incidentes DESC;
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
Quantidade de tabelas esperada: 6
```

Quantidade encontrada:

```text
Quantidade encontrada: 6
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
incidentes
```

### Restrição testada

```text
FOREIGN KEY (id_analista)
```

### Resultado

> Foi tentado inserir um incidente com id_analista = 999 (inexistente). O MySQL recusou o comando com o erro "Cannot add or update a child row: a foreign key constraint fails", confirmando que a integridade referencial está funcionando. O comando de teste foi mantido apenas como comentário no SPRINT5-5.sql.

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text
analistas.email
```

### Resultado

> Foi tentado cadastrar um novo analista com um e-mail já existente (mariana.alves@empresa.com). O MySQL recusou o comando com o erro "Duplicate entry ... for key 'email'", confirmando que a restrição UNIQUE está funcionando.

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text
incidentes.titulo
```

### Resultado

> Foi tentado inserir um incidente sem informar o campo titulo. O MySQL recusou o comando com o erro "Field 'titulo' doesn't have a default value", confirmando que a restrição NOT NULL está funcionando.

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

> Quais dispositivos estão relacionados ao maior número de incidentes?

### SQL

```sql
-- 
SELECT d.nome_dispositivo,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM dispositivos d
JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(i.id_incidente) > 1
ORDER BY quantidade_incidentes DESC;

```

### Resultado esperado

> Uma lista de dispositivos que aparecem em mais de um incidente, ordenados do que mais concentra incidentes para o que menos concentra.

### Por que essa consulta é importante?

> Porque ajuda a priorizar ações de segurança: dispositivos que aparecem repetidamente em incidentes podem indicar falhas de configuração, vulnerabilidades recorrentes ou exposição excessiva, merecendo atenção prioritária da equipe de segurança.

---

# 27. Consulta final mais complexa

### Pergunta

> Em média, quantos incidentes cada analista está acompanhando?

### SQL

```sql
-- 
SELECT AVG(quantidade) AS media_incidentes_por_analista
FROM (
    SELECT id_analista, COUNT(*) AS quantidade
    FROM incidentes
    WHERE id_analista IS NOT NULL
    GROUP BY id_analista
) AS incidentes_por_analista;

```

### Conceitos utilizados

- [ ] WHERE
- [ ] ORDER BY
- [x] agregação
- [x] GROUP BY
- [ ] HAVING
- [ ] expressão
- [x] outro

### Explique

> Essa consulta precisou de uma subconsulta porque o MySQL não permite aninhar duas funções de agregação (AVG(COUNT(*))) diretamente. A subconsulta interna agrupa os incidentes por analista e conta quantos cada um tem; a consulta externa então calcula a média sobre esses totais. Foi a consulta mais difícil de montar, pois exigiu entender a ordem de execução das agregações no SQL.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | OK | Não |
| CREATE TABLE | OK | Não |
| PRIMARY KEY | OK | Não |
| FOREIGN KEY | OK | Não |
| NOT NULL | OK | Não |
| UNIQUE | OK | Não |
| INSERT | OK (após correção do DEFAULT em alertas.data_alerta) | Sim, já corrigida |
| UPDATE | OK | Não |
| DELETE | OK | Não |
| SELECT | OK | Não |
| WHERE | OK | Não |
| ORDER BY |OK  | Não |
| GROUP BY | OK | Não |
| HAVING | OK | Não |
| funções de agregação | OK | Não |

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
| INSERT INTO alertas retornava "Field 'data_alerta' doesn't have a default value" | A coluna data_alerta havia sido criada sem o DEFAULT CURRENT_TIMESTAMP previsto na Sprint 2/5 | Executado ALTER TABLE alertas MODIFY COLUMN data_alerta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP; durante a Sprint 3/5; o SPRINT5-5.sql já cria a coluna corretamente desde o início |

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

> A criação da estrutura do banco com CREATE TABLE, PRIMARY KEY e FOREIGN KEY, e como essas restrições realmente impedem dados inconsistentes na prática.

## Qual conteúdo apresentou maior dificuldade?

> As consultas mais avançadas, como o uso de subconsulta para calcular uma média sobre uma contagem (AVG de um COUNT agrupado), e entender a diferença entre WHERE e HAVING.

## Qual erro mais contribuiu para seu aprendizado?

> EO erro "Field 'data_alerta' doesn't have a default value" na Sprint 3/5, que me obrigou a entender de fato o que o DEFAULT faz e a diferença entre a estrutura planejada e a estrutura realmente criada no banco.

## Qual parte do banco você considera mais bem implementada?

> A tabela incidentes, por concentrar as principais chaves estrangeiras do projeto e representar bem o núcleo do sistema de gerenciamento de incidentes de segurança.

## Se tivesse mais tempo, o que melhoraria?

> Inseriria mais registros em cada tabela, para testar de forma ainda mais completa os agrupamentos e as funções de agregação.

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
