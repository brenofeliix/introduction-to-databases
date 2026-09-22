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

Catálogo e lista pessoal de séries com notas e status de exibição (estilo Watchlist / Letterboxd de séries).

```

## Objetivo principal

> Gerenciar um catálogo simples de séries associado a plataformas de streaming e permitir que usuários controlem seu histórico e avaliações em uma única lista personalizada.


## Quantidade final de tabelas

```text

4 tabelas

```

## Principais entidades do banco

1. PLATAFORMA
2. USUARIO
3. SERIE
4. ITEM_WATCHLIST

## O projeto final permaneceu igual ao planejamento inicial?

- [ ] Sim
- [x] Não

Caso tenha mudado, explique:

> Escreva aqui.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| Substituição do ID artificial (id_item) por Chave Primária Composta (id_usuario, id_serie) | Sprint 2/5 | Simplificação relacional da tabela associativa N:N, garantindo naturalmente que o mesmo usuário não repita a mesma série na watchlist. |
| Inclusão da coluna pais_origem via ALTER TABLE | Sprint 2/5 | Cumprimento do requisito DDL de evolução de schema para permitir rastreio de produções internacionais com valor padrão 'EUA'. |
|  Adição de restrição CHECK em notas (0 a 10) | Sprint 2/5 | Proteção no nível de banco para garantir consistência às regras de negócio definidas na Sprint 1. |


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
| PLATAFORMA | Sim (id_plataforma) | N/A (Independente) | Sim (INT, VARCHAR) | Sim (NOT NULL, UNIQUE) |
| USUARIO | Sim (id_usuario) | N/A (Independente) | Sim (INT, VARCHAR, DATE) | Sim (NOT NULL, UNIQUE) |
| SERIE | Sim (id_serie) | Sim (id_plataforma) | Sim (INT, VARCHAR) | Sim (NOT NULL) |
| ITEM_WATCHLIST | Sim (id_usuario, id_serie) | Sim (id_usuario, id_serie) | Sim (INT, VARCHAR, DECIMAL) | Sim (NOT NULL, DEFAULT, CHECK) |
|  |  |  |  |  |

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| PLATAFORMA | id_plataforma | Sim |
| USUARIO | id_usuario | Sim |
| SERIE | id_serie | Sim |
| ITEM_WATCHLIST | (id_usuario, id_serie) | Não (Chave Composta) |

Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| SERIE | id_plataforma | PLATAFORMA | id_plataforma |
| ITEM_WATCHLIST | id_usuario | USUARIO | id_usuario |
| ITEM_WATCHLIST | id_serie | SERIE | id_serie |
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
| USUARIO | email | UNIQUE | Impede cadastros duplicados com o mesmo endereço eletrônico. |
| PLATAFORMA | nome_plataforma | UNIQUE | Impede o cadastramento duplicado de uma mesma plataforma de streaming. |
| ITEM_WATCHLIST | status_assistindo | DEFAULT 'Quero Ver' | Define o estado inicial da produção na lista caso o usuário não informe. |
| ITEM_WATCHLIST | nota | CHECK (nota >= 0 AND nota <= 10) | Garante que as notas inseridas permaneçam na escala numérica permitida. |

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| PLATAFORMA | 6 |
| USUARIO | 6 |
| SERIE | 7 (8 inseridos, 1 excluído controladamente) |
| ITEM_WATCHLIST | 10 (11 inseridos, 1 excluído controladamente) |
|  |  |

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
|  |  |
|  |  |

---

# 11. Revisão dos UPDATEs

Confirme:

- [X] os UPDATEs possuem `WHERE`;
- [X] alteram os registros esperados;
- [X] não modificam toda a tabela acidentalmente;
- [X] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
-- Cole aqui os UPDATEs mais importantes.

UPDATE item_watchlist
SET status_assistindo = 'Concluído'
WHERE id_usuario = 1 AND id_serie = 2;

UPDATE usuario
SET email = 'carlos.eduardo.dev@email.com'
WHERE id_usuario = 3;

UPDATE serie
SET genero = 'Drama / Ficção Científica'
WHERE id_serie = 2;

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
-- Cole aqui.

DELETE FROM item_watchlist
WHERE id_usuario = 6 AND id_serie = 8;

DELETE FROM serie
WHERE id_serie = 8;

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
| SELECT | Sim | Projeção com apelidos de títulos e anos no catálogo. |
| WHERE | Sim | Séries da plataforma Netflix / Séries de Drama a partir de 2020. |
| ORDER BY | Sim | Catálogo ordenado por ano de lançamento e título alfabético. |
| COUNT | Sim | Total de séries concluídas por usuário na watchlist. |
| SUM | Sim | Somatório geral dos pontos atribuídos em resenhas válidas. |
| AVG | Sim | Média de notas avaliadas de cada título. |
| MIN/MAX | Sim | Menor e maior pontuação registradas na base. |
| GROUP BY | Sim | Agrupamento de notas por série e contagem por usuário. |
| HAVING | Sim | Séries com média final de excelência (nota >= 9.0). |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quais séries cadastradas pertencem à plataforma "Netflix"?

**Foi respondida?**

- [x] Sim
- [ ] Não

**Consulta utilizada:**

```sql
-- Cole aqui.
SELECT id_serie, titulo, genero, ano_lancamento
FROM serie
WHERE id_plataforma = 1;
```

---

## Pergunta 2

> Qual é a média das notas de cada série calculada a partir das avaliações dos usuários?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_notas,
    COUNT(nota) AS volume_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie;

```

---

## Pergunta 3

> Quantas séries cada usuário tem marcadas com o status "Finalizada" (registrado como 'Concluído')?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT 
    id_usuario, 
    COUNT(*) AS total_concluidas
FROM item_watchlist
WHERE status_assistindo = 'Concluído'
GROUP BY id_usuario;

```

---

## Pergunta 4

> Quais séries cadastradas são do gênero "Drama" e foram lançadas a partir de 2020?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT titulo, genero, ano_lancamento, pais_origem
FROM serie
WHERE genero LIKE '%Drama%' 
  AND ano_lancamento >= 2020;

```

---

## Pergunta 5

> Qual é o top 3 de séries com as maiores notas médias entre os usuários?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
-- Cole aqui.
SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_final,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie
ORDER BY media_final DESC
LIMIT 3;


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
4

```

Quantidade encontrada:

```text
4
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
SERIE

```

### Restrição testada

```text

fk_serie_plataforma (FOREIGN KEY)

```

### Resultado

> A tentativa de inserir uma série com id_plataforma = 999 disparou o erro Error Code: 1452: Cannot add or update a child row: a foreign key constraint fails, comprovando a integridade referencial ativa.

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text

usuario.email

```

### Resultado

> A tentativa de cadastrar um segundo usuário utilizando um e-mail já existente gerou o erro Error Code: 1062: Duplicate entry for key 'usuario.uq_usuario_email', bloqueando a duplicidade.

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text

serie.titulo

```

### Resultado

> A tentativa de gravar uma série com o campo titulo nulo resultou no erro Error Code: 1048: Column 'titulo' cannot be null.
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

> Qual é o top 3 de séries com as maiores notas médias entre os usuários?

### SQL

```sql
-- Cole aqui.

SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_final,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie
ORDER BY media_final DESC
LIMIT 3;

```

### Resultado esperado

> Exibição consolidada dos três títulos mais aclamados pelo público no sistema, com média calculada e volume de avaliações.

### Por que essa consulta é importante?

> > Representa o propósito central de uma plataforma de catálogo comunitário, permitindo calcular o ranking das séries mais bem avaliadas pelos usuários para gerar recomendações diretas.

---

# 27. Consulta final mais complexa

### Pergunta

> Entre as séries avaliadas, quais obtiveram média de aprovação excelente (nota média maior ou igual a 9.0)?

### SQL

```sql
-- Cole aqui.

SELECT 
    id_serie,
    ROUND(AVG(nota), 2) AS media_notas,
    COUNT(nota) AS total_avaliacoes
FROM item_watchlist
WHERE nota IS NOT NULL
GROUP BY id_serie
HAVING AVG(nota) >= 9.0;

```

### Conceitos utilizados

- [X] WHERE
- [X] ORDER BY
- [X] agregação
- [X] GROUP BY
- [X] HAVING
- [X] expressão
- [X] outro

### Explique

>A consulta exige filtrar as linhas que ainda não possuem nota via WHERE, agrupar os dados por identificador de série (GROUP BY), aplicar a função agregada AVG(nota) e filtrar os grupos pós-cálculo com a cláusula HAVING.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | Executado com sucesso | Não |
| CREATE TABLE | 4 tabelas criadas | Não |
| PRIMARY KEY | Chaves simples e composta ativas | Não |
| FOREIGN KEY | 3 relacionamentos validados | Não |
| NOT NULL | Campos obrigatórios consistentes | Não |
| UNIQUE | E-mail e Nome da Plataforma protegidos | Não |
| INSERT | 31 registros populados | Não |
| UPDATE | 3 operações executadas com WHERE | Não |
| DELETE | 2 exclusões executadas na ordem pai/filho |  Não|
| SELECT | Projeções funcionando | Não|
| WHERE | Filtros simples e compostos validados | Não |
| ORDER BY | Ordenação decrescente/crescente ativa | Não |
| GROUP BY | Grupos calculados com sucesso | Não |
| HAVING | Filtro pós-agregação funcional | Não |
| funções de agregação | COUNT, SUM, AVG, MIN, MAX validados | Não |

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

- [X] `CREATE DATABASE` funciona;
- [X] `USE` funciona;
- [X] todas as tabelas são criadas;
- [X] nenhuma tabela necessária está ausente.

## Estrutura

- [X] todas as tabelas possuem PK;
- [X] FKs estão corretas;
- [X] tipos de dados estão coerentes;
- [X] `NOT NULL` está coerente;
- [X] `UNIQUE` está coerente;
- [X] `DEFAULT` está coerente.

## Dados

- [X] INSERTs funcionam;
- [X] dados são coerentes;
- [X] FKs são respeitadas.

## Manipulação

- [X] UPDATEs funcionam;
- [X] UPDATEs possuem `WHERE`;
- [X] DELETEs funcionam;
- [X] DELETEs possuem `WHERE`.

## Consultas

- [X] SELECT funciona;
- [X] WHERE funciona;
- [X] ORDER BY funciona;
- [X] COUNT funciona;
- [X] SUM funciona quando aplicável;
- [X] AVG funciona quando aplicável;
- [X] MIN/MAX funcionam;
- [X] GROUP BY funciona;
- [X] HAVING funciona.

## Arquivos

- [X] `SPRINT1-5.md`;
- [X] `SPRINT2-5.md`;
- [X] `SPRINT2-5.sql`;
- [X] `SPRINT3-5.md`;
- [X] `SPRINT3-5.sql`;
- [X] `SPRINT4-5.md`;
- [X] `SPRINT4-5.sql`;
- [X] `SPRINT5-5.md`;
- [X] `SPRINT5-5.sql`.

---

# 43. Autoavaliação

Responda brevemente.

## O que você considera que aprendeu melhor?

> Aprendi como ligar as tabelas do jeito certo usando chaves estrangeiras sem deixar dados perdidos, e entendi bem a diferença entre o WHERE (que filtra antes de juntar as contas) e o HAVING (que filtra depois das contas e médias feitas).

## Qual conteúdo apresentou maior dificuldade?

> A ordem de apagar as coisas com o DELETE. Foi difícil lembrar que precisava apagar primeiro o registro na tabela do meio (item_watchlist) antes de conseguir apagar a série na tabela principal, senão o banco travava.

## Qual erro mais contribuiu para seu aprendizado?

> O erro de "chave duplicada" quando tentei rodar o código de novo e a Netflix já existia no banco. Ali aprendi na prática a usar o comando para apagar e recriar o banco do zero (DROP DATABASE IF EXISTS) toda vez que fosse testar o script.

## Qual parte do banco você considera mais bem implementada?

> A tabela da lista de séries (item_watchlist). Ela junta o usuário e a série sem precisar de uma coluna extra de ID, não deixa a mesma pessoa colocar a mesma série duas vezes e ainda trava notas fora de 0 a 10.
## Se tivesse mais tempo, o que melhoraria?

> Criaria tabelas para colocar os atores e diretores de cada série, e usaria o comando JOIN para fazer relatórios mais bonitos que mostrassem o nome da série e da plataforma juntos na mesma tela, sem mostrar códigos numéricos.
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
