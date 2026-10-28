# SPRINT 5/5 — Validação Final, Integração e Entrega do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual / Equipe  
**Aluna:** Célia Hiromi Watanabe (Team 03)  
**Instituição:** UNEMAT  
**Entrega desta Sprint:** `SPRINT5-5.md` + `SPRINT5-5.sql`  

---

# Objetivo da Sprint 5/5

Nesta etapa final, foi realizada a **revisão, integração, teste e preparação da entrega completa do banco de dados desenvolvido ao longo das cinco Sprints**.

O objetivo consolidou a união harmoniosa de todas as etapas anteriores:

```text
SPRINT1-5 → planejamento do domínio, escopo e regras de negócio
SPRINT2-5 → estrutura DDL, tabelas, constraints e tipos de dados
SPRINT3-5 → manipulação de dados DML (INSERT, UPDATE, DELETE)
SPRINT4-5 → consultas SQL analíticas, filtros, agregações e agrupamentos
SPRINT5-5 → integração mestre, testes de bancada e preparação da entrega final
```

Ao final desta Sprint, o projeto conta com um script único (`SPRINT5-5.sql`) capaz de reconstruir, popular, manipular e consultar todo o banco de dados do zero com êxito garantido.

---

# 1. O que o SPRINT5-5.sql representa

O arquivo `SPRINT5-5.sql` é o script mestre integrador do projeto. Ele reúne:

1. Identificação formal do projeto;
2. Criação do schema `db_salao_beleza`;
3. Seleção do banco com `USE`;
4. Criação das 4 tabelas relacionais (`cliente`, `profissional`, `servico`, `agendamento`);
5. Definição de chaves primárias e auto incremento;
6. Definição das chaves estrangeiras com constraints explícitas;
7. Restrições de integridade (`NOT NULL`, `UNIQUE`, `DEFAULT`);
8. Evolução estrutural com `ALTER TABLE` e exercício controlado de `DROP TABLE`;
9. Carga inicial de dados coerentes via `INSERT INTO`;
10. Operações de atualização com `UPDATE` e filtros `WHERE`;
11. Exclusões seguras com `DELETE` respeitando integridade referencial;
12. Consultas básicas, projeções específicas, filtros simples e compostos;
13. Ordenações crescentes e decrescentes (`ORDER BY`);
14. Funções de agregação (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`);
15. Agrupamento (`GROUP BY`) e filtro pós-agregação (`HAVING`);
16. Expressão matemática com cálculo de desconto promocional;
17. Relatório integrado com `INNER JOIN` entre as 4 tabelas;
18. Auditoria final com `SHOW TABLES`, `DESCRIBE` e `SHOW CREATE TABLE`.

---

# 2. Antes de começar

Todos os arquivos das etapas anteriores foram revisados e permanecem preservados:

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

# 3. Revisão da Sprint 1/5 — Planejamento

## Tema do banco

```text
Sistema de Gestão de Atendimentos e Agendamentos para Salão de Beleza
```

## Objetivo principal

> Centralizar e organizar os dados essenciais de um salão de beleza em uma arquitetura relacional consistente, permitindo cadastrar clientes, profissionais e serviços, além de controlar a agenda de atendimentos e emitir relatórios operacionais e gerenciais.

## Quantidade final de tabelas

```text
4 tabelas
```

## Principais entidades do banco

1. `cliente`
2. `profissional`
3. `servico`
4. `agendamento`

## O projeto final permaneceu igual ao planejamento inicial?

- [x] Sim
- [ ] Não

> O projeto manteve fidelidade total ao escopo delimitado na Sprint 1/5, estruturado em torno das 4 entidades fundamentais e de suas regras de negócio.

---

# 4. Mudanças realizadas ao longo das Sprints

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| Inclusão da coluna `observacoes` via `ALTER TABLE` | Sprint 2/5 | Permitir registro de preferências ou restrições do cliente no atendimento |
| Reajuste de preço do procedimento de escova | Sprint 3/5 | Simulação de atualização periódica de tabela de preços via `UPDATE` |
| Exclusão de atendimento cancelado e cliente teste | Sprint 3/5 | Demonstração prática e segura de comandos `DELETE` respeitando FKs |
| Implementação de junção `INNER JOIN` | Sprint 4/5 e 5/5 | Prover relatório executivo consolidado com nomes humanos em vez de IDs |

---

# 5. Revisão da estrutura do banco

| Tabela | PK correta? | FKs corretas? | Tipos corretos? | Restrições corretas? |
|---|:---:|:---:|:---:|:---:|
| `cliente` | Sim (`id_cliente`) | N/A (independente) | Sim (`INT`, `VARCHAR`) | Sim (`NOT NULL`, `UNIQUE` no CPF) |
| `profissional` | Sim (`id_profissional`) | N/A (independente) | Sim (`INT`, `VARCHAR`) | Sim (`NOT NULL` em campos essenciais) |
| `servico` | Sim (`id_servico`) | N/A (independente) | Sim (`INT`, `DECIMAL`, `VARCHAR`) | Sim (`NOT NULL`, precisão decimal) |
| `agendamento` | Sim (`id_agendamento`) | Sim (3 FKs explícitas) | Sim (`INT`, `DATETIME`, `VARCHAR`) | Sim (`DEFAULT 'Agendado'`, FKs ativas) |

---

# 6. Revisão das PRIMARY KEY

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|:---:|
| `cliente` | `id_cliente` | Sim |
| `profissional` | `id_profissional` | Sim |
| `servico` | `id_servico` | Sim |
| `agendamento` | `id_agendamento` | Sim |

---

# 7. Revisão das FOREIGN KEY

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| `agendamento` | `id_cliente` | `cliente` | `id_cliente` |
| `agendamento` | `id_profissional` | `profissional` | `id_profissional` |
| `agendamento` | `id_servico` | `servico` | `id_servico` |

---

# 8. Revisão das restrições

| Tabela | Campo | Restrição | Regra de negócio protegida |
|---|---|---|---|
| `cliente` | `cpf` | `UNIQUE` | Impede cadastros duplicados do mesmo cliente no sistema |
| `cliente` | `nome`, `telefone` | `NOT NULL` | Garante a identificação do cliente e canal direto de comunicação |
| `servico` | `preco` | `DECIMAL(10,2)` | Garante precisão financeira evitando erros de arredondamento de float |
| `agendamento` | `status` | `DEFAULT 'Agendado'` | Garante que todo novo agendamento inicie no fluxo como 'Agendado' |
| `agendamento` | `id_cliente` | `FOREIGN KEY` | Impede agendamentos órfãos ou vinculados a clientes inexistentes |

---

# 9. Revisão dos dados inseridos

| Tabela | Quantidade aproximada de registros |
|---|---:|
| `cliente` | 5 registros ativos |
| `profissional` | 5 registros ativos |
| `servico` | 6 registros ativos |
| `agendamento` | 5 registros ativos |

---

# 10. Revisão dos INSERTs

- [x] os INSERTs executam sem erro;
- [x] respeitam as chaves estrangeiras;
- [x] não existem duplicações indevidas;
- [x] respeitam `NOT NULL`;
- [x] respeitam `UNIQUE`;
- [x] os dados fazem sentido no domínio do salão de beleza.

---

# 11. Revisão dos UPDATEs

- [x] os UPDATEs possuem `WHERE`;
- [x] alteram os registros esperados;
- [x] não modificam toda a tabela acidentalmente;
- [x] mantêm a integridade do banco.

```sql
UPDATE cliente
SET telefone = '(65) 99999-3344', email = 'beatriz.nova@email.com'
WHERE id_cliente = 2;

UPDATE servico
SET preco = 95.00
WHERE id_servico = 4;

UPDATE agendamento
SET status = 'Concluído', forma_pagamento = 'Pix', observacoes = 'Atendimento concluído com sucesso, cliente satisfeita'
WHERE id_agendamento = 1;
```

---

# 12. Revisão dos DELETEs

- [x] os DELETEs possuem `WHERE`;
- [x] não removem registros necessários ao funcionamento do projeto;
- [x] respeitam as dependências de `FOREIGN KEY`;
- [x] não comprometem consultas posteriores.

```sql
DELETE FROM agendamento
WHERE id_agendamento = 6;

DELETE FROM cliente
WHERE id_cliente = 6;
```

---

# 13. Revisão das consultas da Sprint 4/5

| Recurso SQL | Possui consulta válida? | Pergunta respondida |
|---|:---:|---|
| `SELECT` | Sim | Quais são todos os clientes cadastrados? |
| `WHERE` | Sim | Quais serviços possuem valor acima de R$ 70,00? |
| `ORDER BY` | Sim | Relação de serviços ordenados por preço decrescente |
| `COUNT` | Sim | Total de clientes ativos e total de agendamentos no sistema |
| `SUM` | Sim | Faturamento potencial somado do catálogo de serviços |
| `AVG` | Sim | Preço médio dos procedimentos e duração média em minutos |
| `MIN/MAX` | Sim | Serviço mais barato e serviço de maior valor no salão |
| `GROUP BY` | Sim | Total de atendimentos agrupados por status |
| `HAVING` | Sim | Status com mais de 1 atendimento acumulado |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

## Pergunta 1
> Quais clientes estão cadastrados no salão, ordenados por nome?

- [x] Sim
- [ ] Não

```sql
SELECT nome, telefone, email FROM cliente ORDER BY nome ASC;
```

---

## Pergunta 2
> Quais serviços possuem valor superior a R$ 50,00?

- [x] Sim
- [ ] Não

```sql
SELECT nome_servico, preco FROM servico WHERE preco > 50.00;
```

---

## Pergunta 3
> Quais agendamentos foram realizados por um cliente específico, mostrando data e nome do serviço?

- [x] Sim
- [ ] Não

```sql
SELECT a.id_agendamento, c.nome, s.nome_servico, a.data_hora, a.status
FROM agendamento a
INNER JOIN cliente c ON a.id_cliente = c.id_cliente
INNER JOIN servico s ON a.id_servico = s.id_servico
WHERE a.id_cliente = 1;
```

---

## Pergunta 4
> Quantos agendamentos cada profissional atendeu no total?

- [x] Sim
- [ ] Não

```sql
SELECT id_profissional, COUNT(*) AS total_atendimentos
FROM agendamento
GROUP BY id_profissional
ORDER BY total_atendimentos DESC;
```

---

## Pergunta 5
> Qual é o faturamento total acumulado pelos agendamentos com status 'Concluído'?

- [x] Sim
- [ ] Não

```sql
SELECT SUM(s.preco) AS faturamento_concluido
FROM agendamento a
INNER JOIN servico s ON a.id_servico = s.id_servico
WHERE a.status = 'Concluído';
```

---

# 15. Criando o SPRINT5-5.sql

O script final foi estruturado no arquivo:

```text
teams/Teams-UNEMAT/team-03/SPRINT5-5.sql
```

Ele consolida todo o ciclo DDL, DML, consultas e auditoria em uma única sequência perfeitamente encadeada.

---

# 16. Estrutura recomendada do SPRINT5-5.sql

O arquivo `SPRINT5-5.sql` segue estritamente a sequência modular recomendada:
1. Identificação do Projeto
2. Criação e Seleção do Banco
3. Criação das Tabelas DDL
4. Restrições e Relacionamentos
5. Inserções DML
6. Alterações com UPDATE
7. Exclusões com DELETE
8. Consultas Básicas
9. Filtros com WHERE
10. Ordenação com ORDER BY
11. Funções de Agregação
12. Agrupamento com GROUP BY
13. Filtros com HAVING
14. Expressões e Cálculos em SQL
15. Consulta Relacional Extra com INNER JOIN
16. Validação e Auditoria Final

---

# 17. Teste principal — reconstruir o banco do zero

O teste foi executado via terminal e no MySQL Workbench:
1. Remoção do schema de testes (`DROP DATABASE IF EXISTS db_salao_beleza;`);
2. Execução direta do arquivo `SPRINT5-5.sql` desde a linha 1;
3. O script concluiu todas as 16 etapas com **código de saída 0**, sem interrupções nem avisos de erro.

---

# 18. Se não quiser utilizar DROP DATABASE

O script utiliza a cláusula de segurança `CREATE DATABASE IF NOT EXISTS db_salao_beleza;`, permitindo reexecuções controladas.

---

# 19. Validação com SHOW TABLES

### Resultado esperado
Quantidade de tabelas: `4`

### Quantidade encontrada: `4`
Tabelas: `agendamento`, `cliente`, `profissional`, `servico`.

- [x] corresponde ao esperado.

---

# 20. Validação com DESCRIBE

Executado `DESCRIBE` nas 4 tabelas, confirmando:
- `id_cliente`, `id_profissional`, `id_servico`, `id_agendamento` como chaves primárias inteiras com `auto_increment`;
- `cpf` com índice único `UNI`;
- `agendamento` com índices múltiplos `MUL` apontando para as chaves estrangeiras;
- `status` com valor padrão `'Agendado'`.

---

# 21. Validação com SHOW CREATE TABLE

Executado para a tabela `agendamento`, comprovando as 3 constraints relacionais ativas sobre o mecanismo `InnoDB`:
- `CONSTRAINT fk_agendamento_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)`
- `CONSTRAINT fk_agendamento_profissional FOREIGN KEY (id_profissional) REFERENCES profissional (id_profissional)`
- `CONSTRAINT fk_agendamento_servico FOREIGN KEY (id_servico) REFERENCES servico (id_servico)`

---

# 22. Testando a integridade referencial

### Tabela testada
`agendamento`

### Restrição testada
`FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)`

### Resultado
> A tentativa de inserir um atendimento com `id_cliente = 999` (inexistente) é imediatamente bloqueada pelo MySQL com o erro `Error Code 1452: Cannot add or update a child row: a foreign key constraint fails`.

---

# 23. Testando UNIQUE

### Campo testado
`cliente.cpf`

### Resultado
> A tentativa de cadastrar um segundo cliente com o mesmo CPF gera o erro `Error Code 1062: Duplicate entry for key 'cliente.cpf'`, garantindo unicidade cadastral.

---

# 24. Testando NOT NULL

### Campo testado
`servico.nome_servico`

### Resultado
> A inserção com valor `NULL` é abortada com o erro `Error Code 1048: Column 'nome_servico' cannot be null`.

---

# 25. Testando consultas

Todas as 15 consultas do `SPRINT5-5.sql` foram executadas e validadas com sucesso.

---

# 26. Consulta final mais importante

### Pergunta
> Qual é a visão operacional completa e integrada de todos os atendimentos marcados no salão, exibindo os nomes reais do cliente, profissional, serviço, preço e status?

### SQL

```sql
SELECT 
    a.id_agendamento,
    c.nome AS nome_cliente,
    p.nome AS nome_profissional,
    p.especialidade,
    s.nome_servico,
    s.preco,
    a.data_hora,
    a.status,
    a.forma_pagamento
FROM agendamento a
INNER JOIN cliente c ON a.id_cliente = c.id_cliente
INNER JOIN profissional p ON a.id_profissional = p.id_profissional
INNER JOIN servico s ON a.id_servico = s.id_servico
ORDER BY a.data_hora ASC;
```

### Por que essa consulta é importante?
> Porque traduz os relacionamentos de chaves estrangeiras em informações claras para o uso diário dos funcionários, permitindo visualizar a agenda do salão de maneira profissional.

---

# 27. Consulta final mais complexa

### Pergunta
> Quais status de agendamentos concentram mais de 1 atendimento registrado no salão?

### SQL

```sql
SELECT 
    status,
    COUNT(*) AS quantidade
FROM agendamento
GROUP BY status
HAVING COUNT(*) > 1;
```

### Conceitos utilizados
- [x] WHERE
- [x] ORDER BY
- [x] agregação
- [x] GROUP BY
- [x] HAVING
- [x] expressão

### Explique
> Exige a combinação de agrupamento de dados (`GROUP BY`) com cálculo agregado (`COUNT(*)`) e posterior filtragem sobre os grupos formados através da cláusula `HAVING`.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|:---:|:---:|
| CREATE DATABASE | Executou perfeitamente | Não |
| CREATE TABLE | 4 tabelas criadas com integridade | Não |
| PRIMARY KEY | 4 PKs auto increment validadas | Não |
| FOREIGN KEY | 3 constraints relacionais ativas | Não |
| NOT NULL | Campos obrigatórios validados | Não |
| UNIQUE | CPF único validado | Não |
| INSERT | 23 registros povoados com coerência | Não |
| UPDATE | 3 updates seguros executados | Não |
| DELETE | 2 deletes com WHERE executados | Não |
| SELECT | Projeções e relatórios validados | Não |
| WHERE | Filtros relacionais e lógicos validados | Não |
| ORDER BY | Ordenação ASC e DESC validadas | Não |
| GROUP BY | Agrupamentos por status e profissional validados | Não |
| HAVING | Filtro em grupos pós-agregação validado | Não |
| Funções de agregação | COUNT, SUM, AVG, MIN, MAX validados | Não |

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
| Nenhum erro de sintaxe ou constraint | Script modelado e testado progressivamente | Execução completa com código 0 |

> Nenhum problema identificado após a execução completa do projeto.

---

# 30. Uso de LLMs na revisão final

A assistência de IA foi utilizada de forma ética e pedagógica:
- Para conferência de boas práticas de modularização SQL;
- Para auditoria cruzada dos requisitos das cinco Sprints;
- Cada linha de código foi testada e compreendida pela aluna.

---

# 31. Prompt sugerido para revisão final com LLM

O prompt sugerido pelo professor foi utilizado como roteiro de revisão técnica para garantir a consistência do banco.

---

# 32. Arquivos que devem existir antes do PR

A pasta individual da equipe possui os **9 arquivos obrigatórios**:

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

Total confirmado: **9 arquivos**.

---

# 33. Não remova arquivos anteriores

Todos os arquivos das Sprints 1 a 4 foram estritamente preservados, mantendo o histórico evolutivo da disciplina.

---

# 34. Commit da Sprint 5/5

Arquivos do commit final:

```text
teams/Teams-UNEMAT/team-03/SPRINT5-5.md
teams/Teams-UNEMAT/team-03/SPRINT5-5.sql
```

Mensagem:

```text
Conclui Sprint 5 de 5 - validação final
```

---

# 35. Antes de abrir o Pull Request

- [x] estou na minha branch individual (`team-03-sprints-1-5`);
- [x] todos os commits foram enviados ao GitHub;
- [x] não alterei arquivos de outro aluno;
- [x] não alterei arquivos de outra instituição;
- [x] não alterei arquivos administrativos do repositório;
- [x] os 9 arquivos da atividade estão presentes;
- [x] os arquivos `.md` estão preenchidos;
- [x] os arquivos `.sql` foram testados;
- [x] o `SPRINT5-5.sql` executa do início ao fim;
- [x] removi nomes genéricos dos modelos;
- [x] não deixei senhas ou credenciais no código;
- [x] compreendo o código entregue.

---

# 36. Abrindo o Pull Request final

O PR será aberto com:
- **Origem (Head):** `team-03-sprints-1-5`
- **Destino (Base):** `main`

---

# 37. Título do Pull Request

Padrão UNEMAT:

```text
[N1][UNEMAT][hiromilly] Sprints 1-5 - db_salao_beleza
```

---

# 38. Descrição sugerida para o Pull Request

```markdown
## Identificação

Aluno: Célia Hiromi Watanabe
Instituição: UNEMAT
Banco desenvolvido: db_salao_beleza

## Descrição

Este Pull Request apresenta a entrega final consolidada das Sprints 1/5 a 5/5 da disciplina de Laboratório de Banco de Dados.

## Arquivos entregues

- teams/Teams-UNEMAT/team-03/SPRINT1-5.md
- teams/Teams-UNEMAT/team-03/SPRINT2-5.md
- teams/Teams-UNEMAT/team-03/SPRINT2-5.sql
- teams/Teams-UNEMAT/team-03/SPRINT3-5.md
- teams/Teams-UNEMAT/team-03/SPRINT3-5.sql
- teams/Teams-UNEMAT/team-03/SPRINT4-5.md
- teams/Teams-UNEMAT/team-03/SPRINT4-5.sql
- teams/Teams-UNEMAT/team-03/SPRINT5-5.md
- teams/Teams-UNEMAT/team-03/SPRINT5-5.sql

## Validação

- [x] Banco testado no MySQL Workbench
- [x] Estrutura DDL validada
- [x] Dados populados via DML
- [x] Consultas analíticas e agregações validadas
- [x] Script integrador final executado do início ao fim
```

---

# 39. GitHub Actions

O Pull Request passará pelo fluxo de validação automática do repositório (`validate-pr.yml`).

---

# 40. Se o GitHub Actions reprovar

Caso ocorra qualquer inconsistência, os logs serão inspecionados para ajustes locais na mesma branch sem abrir novo PR.

---

# 41. Não tente contornar a validação

Todas as regras do repositório e padrões de pastas foram rigorosamente respeitados.

---

# 42. Checklist técnico final

## Banco
- [x] `CREATE DATABASE` funciona;
- [x] `USE` funciona;
- [x] todas as tabelas são criadas;
- [x] nenhuma tabela necessária está ausente.

## Estrutura
- [x] todas as tabelas possuem PK com `AUTO_INCREMENT`;
- [x] FKs estão corretas e ativas;
- [x] tipos de dados estão coerentes (`INT`, `VARCHAR`, `DECIMAL`, `DATETIME`);
- [x] `NOT NULL` está coerente;
- [x] `UNIQUE` está coerente;
- [x] `DEFAULT` está coerente.

## Dados
- [x] INSERTs funcionam em lote;
- [x] dados são coerentes e realistas;
- [x] FKs são respeitadas na ordem correta.

## Manipulação
- [x] UPDATEs funcionam com `WHERE`;
- [x] DELETEs funcionam com `WHERE`.

## Consultas
- [x] SELECT funciona;
- [x] WHERE funciona (simples e composto);
- [x] ORDER BY funciona (ASC e DESC);
- [x] COUNT funciona;
- [x] SUM funciona;
- [x] AVG funciona com arredondamento;
- [x] MIN/MAX funcionam;
- [x] GROUP BY funciona;
- [x] HAVING funciona;
- [x] INNER JOIN integrado funciona.

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

## O que você considera que aprendeu melhor?
> A compreensão profunda do modelo relacional, a importância das chaves estrangeiras para garantir integridade e a construção encadeada de consultas analíticas utilizando `GROUP BY`, `HAVING` e `INNER JOIN`.

## Qual conteúdo apresentou maior dificuldade?
> A modelagem e ordenação correta das dependências de chaves estrangeiras durante as operações DML de inserção e exclusão, além do entendimento conceitual da diferença de aplicação entre as cláusulas `WHERE` e `HAVING`.

## Qual erro mais contribuiu para seu aprendizado?
> As tentativas iniciais de exclusão sem respeitar a integridade referencial de chave estrangeira, o que me fez compreender perfeitamente por que o banco atua como um guardião das regras de negócio.

## Qual parte do banco você considera mais bem implementada?
> O relacionamento central da tabela `agendamento`, que reúne com perfeição os clientes, profissionais e serviços, permitindo extrair relatórios executivos ricos e completos.

## Se tivesse mais tempo, o que melhoraria?
> Adicionaria uma tabela associativa específica para permitir múltiplos serviços em um único agendamento e uma tabela de controle de comissões pagas aos profissionais do salão.

---

# 44. Critério de conclusão da Sprint 5/5

A Sprint 5/5 está integralmente concluída com todos os 14 itens atendidos, script mestre validado no MySQL e documentação pronta para entrega.

---

# Entrega final

A entrega final será consolidada com a abertura do Pull Request oficial para a branch `main`.
