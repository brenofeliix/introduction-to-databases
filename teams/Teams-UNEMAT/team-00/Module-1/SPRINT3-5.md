# SPRINT 3/5 — Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual / Equipe  
**Aluna:** Célia Hiromi Watanabe (Team 03)  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`  

---

# Objetivo da Sprint 3/5

Nesta etapa, cada aluno deverá utilizar o banco de dados criado na `SPRINT2-5.sql` para **inserir, alterar e excluir dados** utilizando comandos DML (*Data Manipulation Language*).

Nesta Sprint serão trabalhados principalmente:

```sql
INSERT
UPDATE
DELETE
```

Ao final da atividade, o banco deverá possuir dados coerentes com o domínio escolhido na Sprint 1/5.

O aluno deverá entregar:

```text
SPRINT3-5.md
SPRINT3-5.sql
```

O arquivo `SPRINT3-5.md` documentará o trabalho realizado. O arquivo `SPRINT3-5.sql` deverá conter os comandos SQL produzidos e testados no MySQL Workbench.

> Utilize obrigatoriamente o banco e as tabelas criados na Sprint 2/5.

---

# 1. Antes de começar

1. Abra o MySQL Workbench.
2. Abra sua conexão local (`Local instance 3306`).
3. Confirme que o banco criado na Sprint 2/5 (`db_salao_beleza`) existe.
4. Abra ou execute o `SPRINT2-5.sql`, se necessário.
5. Selecione o banco:

```sql
USE db_salao_beleza;
```

6. Confira as tabelas:

```sql
DESCRIBE cliente;
DESCRIBE profissional;
DESCRIBE servico;
DESCRIBE agendamento;
```

---

# 2. Crie o arquivo SPRINT3-5.sql

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
teams/Teams-UNEMAT/team-03/SPRINT3-5.sql
```

Esse arquivo contém todos os comandos DML desenvolvidos e validados nesta Sprint.

---

# 3. INSERT — inserindo dados

Estrutura básica utilizada:

```sql
INSERT INTO nome_tabela (
    campo_1,
    campo_2,
    campo_3
)
VALUES (
    valor_1,
    valor_2,
    valor_3
);
```

Exemplo aplicado ao projeto:

```sql
INSERT INTO cliente (
    nome,
    cpf,
    telefone,
    email
)
VALUES (
    'Mariana Souza',
    '111.222.333-44',
    '(65) 99111-2233',
    'mariana.souza@email.com'
);
```

---

# 4. Inserindo vários registros

No projeto, foram utilizadas inserções em lote (*multiple rows*) para ganho de performance e organização:

```sql
INSERT INTO cliente (nome, cpf, telefone, email)
VALUES
    ('Mariana Souza', '111.222.333-44', '(65) 99111-2233', 'mariana.souza@email.com'),
    ('Beatriz Santos', '222.333.444-55', '(65) 99222-3344', 'beatriz.santos@email.com'),
    ('Camila Oliveira', '333.444.555-66', '(65) 99333-4455', 'camila.oliveira@email.com');
```

---

# 5. Quantidade mínima de dados

O projeto contemplou pelo menos 5 a 6 registros em cada tabela principal:

```text
cliente        → 6 registros inseridos (1 específico para teste de exclusão segura)
profissional   → 5 registros inseridos
servico        → 6 registros inseridos
agendamento    → 6 registros inseridos (1 específico para teste de exclusão segura)
```

Os dados são totalmente realistas e cobrem cenários reais do cotidiano de um salão de beleza.

---

# 6. Ordem correta dos INSERTs

A ordem de inserção respeitou rigorosamente as restrições de integridade referencial (`FOREIGN KEY`):

```text
  [cliente]       [profissional]       [servico]
(independente)    (independente)     (independente)
        │                │                  │
        └────────────────┼──────────────────┘
                         ▼
                   [agendamento]
                    (dependente)
```

1. **Primeiro:** Inserir dados nas tabelas pai independentes (`cliente`, `profissional`, `servico`);
2. **Depois:** Inserir registros na tabela filha `agendamento`, referenciando IDs válidos já existentes.

---

# 7. Planejamento dos dados

| Tabela | Quantidade prevista | Depende de outra tabela? |
|---|---:|---|
| `cliente` | 6 registros | Não (tabela pai independente) |
| `profissional` | 5 registros | Não (tabela pai independente) |
| `servico` | 6 registros | Não (tabela pai independente) |
| `agendamento` | 6 registros | Sim (depende de `cliente`, `profissional` e `servico`) |

---

# 8. INSERTs realizados

## Tabela 1: `cliente`

```sql
INSERT INTO cliente (nome, cpf, telefone, email)
VALUES
    ('Mariana Souza', '111.222.333-44', '(65) 99111-2233', 'mariana.souza@email.com'),
    ('Beatriz Santos', '222.333.444-55', '(65) 99222-3344', 'beatriz.santos@email.com'),
    ('Camila Oliveira', '333.444.555-66', '(65) 99333-4455', 'camila.oliveira@email.com'),
    ('Juliana Costa', '444.555.666-77', '(65) 99444-5566', 'juliana.costa@email.com'),
    ('Fernanda Lima', '555.666.777-88', '(65) 99555-6677', 'fernanda.lima@email.com'),
    ('Lucas Ribeiro (Teste)', '666.777.888-99', '(65) 99666-7788', 'lucas.teste@email.com');
```

## Tabela 2: `profissional`

```sql
INSERT INTO profissional (nome, especialidade, telefone)
VALUES
    ('Ana Paula Nogueira', 'Cabeleireira', '(65) 98111-1001'),
    ('Carla Mendes', 'Manicure e Pedicure', '(65) 98222-1002'),
    ('Daniela Rocha', 'Maquiadora', '(65) 98333-1003'),
    ('Eduardo Martins', 'Barbeiro', '(65) 98444-1004'),
    ('Fabiana Silveira', 'Esteticista', '(65) 98555-1005');
```

## Tabela 3: `servico`

```sql
INSERT INTO servico (nome_servico, duracao_minutos, preco)
VALUES
    ('Corte Feminino', 45, 80.00),
    ('Corte Masculino', 30, 50.00),
    ('Manicure e Pedicure', 60, 65.00),
    ('Escova e Hidratação', 50, 90.00),
    ('Maquiagem Social', 60, 150.00),
    ('Limpeza de Pele', 75, 120.00);
```

## Tabela 4: `agendamento`

```sql
INSERT INTO agendamento (id_cliente, id_profissional, id_servico, data_hora, status, forma_pagamento, observacoes)
VALUES
    (1, 1, 1, '2026-09-15 09:00:00', 'Agendado', NULL, 'Cliente prefere corte na tesoura'),
    (2, 2, 3, '2026-09-15 10:30:00', 'Agendado', NULL, 'Trazer esmalte próprio'),
    (3, 3, 5, '2026-09-15 14:00:00', 'Agendado', NULL, 'Evento à noite, maquiagem marcante'),
    (4, 4, 2, '2026-09-16 11:00:00', 'Agendado', NULL, 'Acabamento com navalha'),
    (5, 5, 6, '2026-09-16 15:30:00', 'Agendado', NULL, 'Pele sensível'),
    (1, 2, 3, '2026-09-17 16:00:00', 'Cancelado', NULL, 'Cliente cancelou com antecedência por imprevisto');
```

---

# 9. AUTO_INCREMENT

Todas as quatro tabelas do projeto utilizam `AUTO_INCREMENT` nas chaves primárias (`id_cliente`, `id_profissional`, `id_servico`, `id_agendamento`). Por esse motivo, as colunas identificadoras são omitidas nos comandos `INSERT`, permitindo que o MySQL gere a sequência numérica de forma automática, consistente e sem risco de duplicidade manual.

---

# 10. Tipos de valores

Os seguintes tipos de valores foram praticados nos comandos DML:

- **Texto:** `'Mariana Souza'`, `'Agendado'`, `'Pix'`
- **Inteiro:** `45` (duração em minutos), `1` (IDs relacionais)
- **Decimal:** `80.00`, `95.00` (valores de serviços)
- **Data e Hora:** `'2026-09-15 09:00:00'` (formato ISO `YYYY-MM-DD HH:MM:SS`)
- **Ausência de valor:** `NULL` (usado nos agendamentos ainda não pagos ou sem anotações)

---

# 11. Testando restrições de integridade

Durante os testes em bancada no MySQL Workbench, foram avaliadas as restrições criadas na Sprint 2/5:

| Restrição testada | O que foi testado? | Resultado |
|---|---|---|
| `UNIQUE` (`cpf`) | Tentativa de inserir outro cliente com o CPF `'111.222.333-44'` já cadastrado | **Bloqueado pelo MySQL:** `Error Code 1062: Duplicate entry '111.222.333-44' for key 'cliente.cpf'` |
| `NOT NULL` (`nome`) | Tentativa de inserir um serviço com `nome_servico = NULL` | **Bloqueado pelo MySQL:** `Error Code 1048: Column 'nome_servico' cannot be null` |
| `FOREIGN KEY` | Tentativa de agendamento informando `id_cliente = 999` (inexistente) | **Bloqueado pelo MySQL:** `Error Code 1452: Cannot add or update a child row: a foreign key constraint fails` |

---

# 12. UPDATE — alterando registros

Estrutura padrão utilizada:

```sql
UPDATE nome_tabela
SET campo = novo_valor
WHERE condicao;
```

---

# 13. Atenção ao WHERE no UPDATE

Nunca executar `UPDATE` sem cláusula `WHERE` em ambiente de produção, pois isso alteraria indiscriminadamente todas as linhas da tabela. Antes de cada execução, o filtro `WHERE` foi inspecionado com auxílio de uma consulta prévia (`SELECT`).

---

# 14. UPDATEs obrigatórios

Foram executadas **3 operações UPDATE** com objetivos claros de negócio:

## UPDATE 1

```sql
UPDATE cliente
SET telefone = '(65) 99999-3344',
    email = 'beatriz.nova@email.com'
WHERE id_cliente = 2;
```

**O que foi alterado?**

> Atualização dos dados de contato (telefone e e-mail) da cliente Beatriz Santos (`id_cliente = 2`) após solicitação de alteração cadastral.

---

## UPDATE 2

```sql
UPDATE servico
SET preco = 95.00
WHERE id_servico = 4;
```

**O que foi alterado?**

> Reajuste de valor na tabela de preços do serviço "Escova e Hidratação" (`id_servico = 4`), alterando o preço de R$ 90.00 para R$ 95.00.

---

## UPDATE 3

```sql
UPDATE agendamento
SET status = 'Concluído',
    forma_pagamento = 'Pix',
    observacoes = 'Atendimento concluído com sucesso, cliente satisfeita'
WHERE id_agendamento = 1;
```

**O que foi alterado?**

> Conclusão do atendimento do agendamento 1 (`id_agendamento = 1`), alterando o status de `'Agendado'` para `'Concluído'`, registrando a forma de pagamento `'Pix'` e adicionando nota sobre a satisfação da cliente.

---

# 15. DELETE — removendo registros

Estrutura utilizada:

```sql
DELETE FROM nome_tabela
WHERE condicao;
```

---

# 16. Atenção ao WHERE no DELETE

A cláusula `WHERE` é indispensável no `DELETE` para delimitar com precisão cirúrgica o registro a ser removido e evitar o esvaziamento acidental da tabela.

---

# 17. DELETE e FOREIGN KEY

O MySQL atua ativamente para impedir exclusões que violem a integridade referencial:
- Se tentássemos rodar `DELETE FROM cliente WHERE id_cliente = 1;`, o MySQL rejeitaria com o erro `1451: Cannot delete or update a parent row: a foreign key constraint fails`, pois o cliente 1 possui agendamentos ativos.
- Para demonstrar o `DELETE` correto e seguro, as exclusões foram planejadas na ordem adequada (primeiro excluir agendamento cancelado, e exclusão de cliente que não possui dependentes).

---

# 18. DELETEs obrigatórios

Foram executadas **2 operações DELETE** controladas:

## DELETE 1

```sql
DELETE FROM agendamento
WHERE id_agendamento = 6;
```

**Registro removido:**

> Exclusão do agendamento cancelado previamente pela cliente por imprevisto (`id_agendamento = 6`), liberando o histórico de atendimentos descartados.

---

## DELETE 2

```sql
DELETE FROM cliente
WHERE id_cliente = 6;
```

**Registro removido:**

> Exclusão do cliente de testes Lucas Ribeiro (`id_cliente = 6`), que não possuía nenhum agendamento vinculado, comprovando a execução de um `DELETE` sem restrições de chave estrangeira.

---

# 19. Conferindo os registros

A cada etapa de manipulação, comandos `SELECT` foram executados para auditar as alterações:

```sql
-- Conferência antes da exclusão:
SELECT * FROM agendamento WHERE id_agendamento = 6;

-- Conferência após exclusão:
SELECT * FROM agendamento;
```

---

# 20. Modelo genérico para adaptar

O modelo genérico sugerido pelo professor foi completamente customizado para o domínio do salão de beleza e estruturado no script executável da equipe.

---

# 21. Estrutura recomendada do SPRINT3-5.sql

O arquivo `SPRINT3-5.sql` segue rigorosamente a estrutura modular de boas práticas:
1. Identificação e `USE db_salao_beleza;`
2. `INSERT` nas tabelas independentes (`cliente`, `profissional`, `servico`);
3. `INSERT` na tabela dependente (`agendamento`);
4. Verificações intermediárias (`SELECT`);
5. Três operações de `UPDATE`;
6. Duas operações de `DELETE`;
7. Verificação final (`SELECT`) de todas as tabelas.

---

# 22. Passo a passo no MySQL Workbench

1. **Etapa 1:** Conectar no MySQL Workbench e verificar o schema `db_salao_beleza`.
2. **Etapa 2:** Abrir o script `SPRINT3-5.sql` no Workbench.
3. **Etapa 3:** Clicar no botão do **Raio (⚡)** para executar o script.
4. **Etapa 4:** Observar a grade de resultados (*Result Grid*) com os dados povoados e o histórico de comandos bem-sucedidos no painel **Action Output**.
5. **Etapa 5:** Salvar o arquivo atualizado na pasta do projeto.

---

# 23. Resumo dos dados

| Tabela | Quantidade aproximada de registros ao final |
|---|---:|
| `cliente` | 5 registros ativos |
| `profissional` | 5 registros ativos |
| `servico` | 6 registros ativos |
| `agendamento` | 5 registros ativos |

---

# 24. Resumo das operações

## INSERT

Quantidade total de registros inseridos:

```text
23 registros (6 clientes + 5 profissionais + 6 serviços + 6 agendamentos)
```

## UPDATE

Quantidade de operações:

```text
3 operações UPDATE executadas com sucesso
```

## DELETE

Quantidade de operações:

```text
2 operações DELETE executadas com sucesso
```

---

# 25. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
| Risco de erro `1451` em `DELETE` | Tentar excluir cliente que possuía agendamento relacionado | Planejada a exclusão exclusiva de cliente sem agendamentos ativos (`id_cliente = 6`) |
| Risco de alteração em massa no `UPDATE` | Ausência acidental de `WHERE` | Todas as instruções foram validadas previamente e executadas com filtro por chave primária |
| Risco de duplicidade de CPF | Violação da restrição `UNIQUE` | Criada lista de CPFs distintos para todos os clientes inseridos |

---

# 26. O que deve existir ao final desta Sprint

A pasta da equipe `teams/Teams-UNEMAT/team-03/` agora possui a árvore completa:

```text
SPRINT1-5.md
SPRINT2-5.md
SPRINT2-5.sql
SPRINT3-5.md
SPRINT3-5.sql
```

---

# 27. Checklist da Sprint 3/5

- [x] utilizei o banco criado na Sprint 2/5 (`db_salao_beleza`);
- [x] utilizei `USE db_salao_beleza;`;
- [x] inseri dados coerentes com o projeto do salão de beleza;
- [x] respeitei a ordem das tabelas (tabelas pai antes da dependente);
- [x] procurei inserir pelo menos 5 registros nas tabelas principais;
- [x] testei restrições de integridade (`UNIQUE`, `NOT NULL`, `FOREIGN KEY`);
- [x] executei pelo menos 3 `UPDATE`;
- [x] os `UPDATE` possuem condição adequada com `WHERE`;
- [x] executei pelo menos 2 `DELETE`;
- [x] os `DELETE` possuem condição adequada com `WHERE`;
- [x] verifiquei dependências de `FOREIGN KEY`;
- [x] utilizei `SELECT` para conferência antes e depois;
- [x] registrei os problemas encontrados;
- [x] salvei o código como `SPRINT3-5.sql`;
- [x] preenchi completamente o `SPRINT3-5.md`;
- [x] revisei os arquivos antes do commit.

---

# 28. Regras de Git/GitHub

A atividade continua **individual / por equipe**.

Utilize a mesma branch individual das Sprints anteriores:

```text
team-03-sprints-1-5
```

## Arquivos obrigatórios no commit desta Sprint:

```text
teams/Teams-UNEMAT/team-03/SPRINT3-5.md
teams/Teams-UNEMAT/team-03/SPRINT3-5.sql
```

## Mensagem sugerida pelo professor:

```text
Conclui Sprint 3 de 5 - operações DML
```

---

# 29. Pull Request

> **Ainda não abra o Pull Request final.**  
> O PR será aberto exclusivamente após a conclusão da Sprint 5/5, reunindo todas as cinco entregas de forma consolidada para a branch `main`.

---

# 30. Critério de conclusão

A Sprint 3/5 está concluída com todos os critérios cumpridos:

1. Utilizou o banco `db_salao_beleza` criado na Sprint 2/5;
2. Populou todas as 4 tabelas com dados de alta qualidade;
3. Respeitou a integridade referencial e chaves estrangeiras;
4. Utilizou `INSERT` em lote para produtividade;
5. Realizou 3 `UPDATE` explicados e contextualizados;
6. Realizou 2 `DELETE` seguros;
7. Preservou a integridade dos dados;
8. Documentou a atividade integralmente no `SPRINT3-5.md`;
9. Salvou o código executável em `SPRINT3-5.sql`;
10. Arquivos prontos e validados para o commit.

---

# Próxima etapa

Na **Sprint 4/5**, os dados inseridos nesta etapa serão utilizados para consultas SQL avançadas:

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
