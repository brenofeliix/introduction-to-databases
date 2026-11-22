# SPRINT 3/5 — Inserção e Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Aluno:** Marcos Aurélio Bastos Stanguerlin  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# Objetivo da Sprint 3/5

Nesta etapa, o banco criado e estruturado nas Sprints anteriores passa a receber dados e operações de manipulação.

O objetivo desta Sprint é utilizar comandos DML (*Data Manipulation Language*) para:

- inserir registros com `INSERT`;
- alterar registros com `UPDATE`;
- excluir registros com `DELETE`;
- validar as restrições criadas anteriormente;
- testar `NOT NULL`, `UNIQUE` e `FOREIGN KEY`;
- consultar os dados após as operações;
- registrar os problemas encontrados durante a execução.

O banco utilizado continua sendo o sistema da **Sorveteria e Açaiteria**, denominado:

```text
Rh_sorveteria
```

---

# 1. Continuidade das Sprints anteriores

A Sprint 3/5 utiliza a estrutura criada na Sprint 2/5.

As tabelas utilizadas são:

1. `FILIAL`
2. `CARGO`
3. `PRODUTO`
4. `SETOR`
5. `FUNCIONARIO`
6. `EXPEDIENTE`
7. `ESTOQUE`

Nesta etapa não foi necessário criar novas tabelas. O objetivo foi popular e manipular os registros das tabelas já existentes.

---

# 2. Dados inseridos no banco

Foram inseridos dados suficientes para representar o funcionamento básico da sorveteria e açaiteria.

Foram cadastrados:

- 5 filiais;
- 5 cargos;
- 5 produtos;
- 5 setores;
- 5 funcionários;
- 5 registros de expediente;
- 5 registros de estoque.

Os registros foram distribuídos entre as tabelas para permitir posteriormente a realização de consultas envolvendo funcionários, filiais, cargos, estoque e expediente.

---

# 3. INSERT — FILIAL

Foram cadastradas cinco filiais.

```sql
INSERT INTO FILIAL (
    Modulo,
    Localizacao,
    data_abertura
)
VALUES
    ('VAREJO', 'Centro - Rondonópolis', '2022-03-15'),
    ('VAREJO', 'Vila Operária - Rondonópolis', '2023-07-20'),
    ('ADMINISTRAÇÃO', 'Centro - Rondonópolis', '2021-01-10'),
    ('VAREJO', 'Jardim Atlântico - Rondonópolis', '2024-05-12'),
    ('ADMINISTRAÇÃO', 'Jardim Europa - Rondonópolis', '2025-02-18');
```

### Explicação

> Foram cadastradas filiais dos módulos de varejo e administração, todas localizadas em Rondonópolis. Também foi armazenada a data de abertura de cada unidade.

---

# 4. INSERT — CARGO

Foram cadastrados cinco cargos.

```sql
INSERT INTO CARGO (
    nome_cargo,
    salario_base,
    carga_horaria
)
VALUES
    ('Gerente', 4500.00, 44),
    ('Atendente', 2200.00, 44),
    ('Caixa', 2100.00, 44),
    ('Auxiliar de Estoque', 2000.00, 44),
    ('Supervisor', 3200.00, 44);
```

### Explicação

> Os cargos representam as principais funções utilizadas no exemplo do sistema. Cada cargo possui um salário base e uma carga horária semanal de 44 horas.

---

# 5. INSERT — PRODUTO

Foram cadastrados cinco produtos.

```sql
INSERT INTO PRODUTO (
    nome_produto
)
VALUES
    ('Açaí 500ml'),
    ('Sorvete de Chocolate'),
    ('Sorvete de Morango'),
    ('Açaí 700ml'),
    ('Sorvete de Baunilha');
```

### Explicação

> Os produtos foram cadastrados para permitir o controle de estoque das filiais.

---

# 6. INSERT — SETOR

Foram cadastrados cinco setores.

```sql
INSERT INTO SETOR (
    nome_setor
)
VALUES
    ('Atendimento'),
    ('Caixa'),
    ('Estoque'),
    ('Produção'),
    ('Administração');
```

### Explicação

> Os setores representam as áreas onde os funcionários podem atuar dentro da empresa.

---

# 7. INSERT — FUNCIONARIO

Foram cadastrados cinco funcionários.

```sql
INSERT INTO FUNCIONARIO (
    nome_func,
    cpf_func,
    data_nascimento,
    data_admissao,
    id_cargo,
    id_setor,
    id_filial
)
VALUES
    ('Carlos Henrique', '12345678901', '1988-04-12', '2022-03-20', 1, 5, 3),
    ('Ana Paula', '23456789012', '1995-08-25', '2023-07-25', 2, 1, 1),
    ('Lucas Mendes', '34567890123', '1999-02-10', '2024-01-15', 3, 2, 2),
    ('Mariana Souza', '45678901234', '1992-11-30', '2024-06-01', 4, 3, 4),
    ('Rafael Oliveira', '56789012345', '1985-06-18', '2025-02-25', 5, 4, 5);
```

### Explicação

> Cada funcionário possui CPF, data de nascimento, data de admissão e relacionamentos com cargo, setor e filial. Os campos `id_cargo`, `id_setor` e `id_filial` utilizam registros já existentes nas tabelas relacionadas.

---

# 8. INSERT — EXPEDIENTE

Foram cadastrados cinco registros de expediente.

```sql
INSERT INTO EXPEDIENTE (
    data_batimento,
    hora_entrada,
    hora_saida,
    hora_extra,
    justificativas,
    id_func
)
VALUES
    ('2026-09-01', '08:00:00', '17:00:00', 0, NULL, 1),
    ('2026-09-02', '08:00:00', '18:00:00', 1, 'Aumento de demanda na filial', 2),
    ('2026-09-03', '09:00:00', '18:00:00', 0, NULL, 3),
    ('2026-09-04', '08:00:00', '19:00:00', 2, 'Organização do estoque', 4),
    ('2026-09-05', '07:00:00', '17:00:00', 1, 'Atendimento de demanda extra', 5);
```

### Explicação

> Os registros representam batimentos de ponto dos funcionários. Foram incluídos horários de entrada e saída, quantidade de horas extras e justificativas quando existiram horas adicionais.

### Observação de execução

> A tabela `EXPEDIENTE` possui uma chave estrangeira para `FUNCIONARIO`. Por isso, os funcionários precisam ser inseridos antes dos registros de expediente

---

# 9. INSERT — ESTOQUE

Foram cadastrados cinco registros de estoque.

```sql
INSERT INTO ESTOQUE (
    quantidade,
    id_filial,
    id_produto
)
VALUES
    (35, 1, 1),
    (20, 2, 2),
    (50, 3, 3),
    (15, 4, 4),
    (40, 5, 5);
```

### Explicação

> Cada registro informa a quantidade de determinado produto existente em uma filial. A tabela `ESTOQUE` relaciona `FILIAL` e `PRODUTO`.

---

# 10. Resumo dos INSERTs realizados

| Tabela | Quantidade de registros inseridos | Finalidade |
|---|---:|---|
| FILIAL | 5 | Cadastrar as unidades da empresa |
| CARGO | 5 | Cadastrar os cargos |
| PRODUTO | 5 | Cadastrar os produtos |
| SETOR | 5 | Cadastrar os setores |
| FUNCIONARIO | 5 | Cadastrar os funcionários |
| EXPEDIENTE | 5 | Registrar os batimentos de ponto |
| ESTOQUE | 5 | Registrar produtos e quantidades por filial |

---

# 11. UPDATE — alteração do nome de funcionário

Foi realizada uma alteração no nome do funcionário de `id_func = 2`.

```sql
UPDATE FUNCIONARIO
SET nome_func = 'Anna Paula'
WHERE id_func = 2;
```

### Antes

```text
Ana Paula
```

### Depois

```text
Anna Paula
```

### Explicação

> O comando demonstra a alteração de um dado já cadastrado utilizando `UPDATE` com uma condição no `WHERE`.

---

# 12. UPDATE — alteração do salário

Foi alterado o salário base do cargo de gerente.

```sql
UPDATE CARGO
SET salario_base = 4700.00
WHERE id_cargo = 1;
```

### Antes

```text
R$ 4.500,00
```

### Depois

```text
R$ 4.700,00
```

### Explicação

> O salário base do cargo de gerente foi atualizado de R$ 4.500,00 para R$ 4.700,00.

---

# 13. UPDATE — alteração do estoque

O registro de estoque da filial 2 para o produto 2 foi alterado.

```sql
UPDATE ESTOQUE
SET quantidade = 30
WHERE id_filial = 2
  AND id_produto = 2;
```

### Antes

```text
20 unidades
```

### Depois

```text
30 unidades
```

### Explicação

> Na estrutura criada na Sprint 2, a tabela `ESTOQUE` utiliza chave primária composta por `id_filial` e `id_produto`. Portanto, o registro deve ser localizado por esses dois campos.

### Ajuste em relação ao código inicial

O código inicial utilizava:

```sql
WHERE id_estoque = 2;
```

Porém, o campo `id_estoque` não existe na estrutura da Sprint 2. A condição foi corrigida para:

```sql
WHERE id_filial = 2
  AND id_produto = 2;
```

---

# 14. DELETE

A exclusão de um funcionário que possui registros em `EXPEDIENTE` é impedida pela chave estrangeira enquanto esses registros relacionados existirem.

Para executar uma exclusão válida e preservar a integridade referencial, primeiro é excluído o expediente relacionado e depois o funcionário.

```sql
DELETE FROM EXPEDIENTE
WHERE id_func = 1;

DELETE FROM FUNCIONARIO
WHERE id_func = 1;
```

### Explicação

> O funcionário de `id_func = 1` possui um registro relacionado na tabela `EXPEDIENTE`. Como a estrutura não definiu exclusão automática em cascata, o registro dependente deve ser removido antes do funcionário.

### Importância do `WHERE`

> O uso do `WHERE` é necessário para limitar a exclusão ao registro desejado. Um `DELETE` sem condição poderia excluir todos os registros da tabela.

---

# 15. Teste da restrição UNIQUE

A tabela `FUNCIONARIO` possui a restrição `UNIQUE` no campo `cpf_func`.

Foi realizado o seguinte teste:

```sql
INSERT INTO FUNCIONARIO (
    nome_func,
    cpf_func,
    data_nascimento,
    data_admissao,
    id_cargo,
    id_setor,
    id_filial
)
VALUES (
    'Teste CPF',
    '12345678901',
    '1990-01-01',
    '2026-09-01',
    1,
    1,
    1
);
```

### Resultado esperado

> O comando deve gerar erro enquanto o funcionário Carlos Henrique, que possui o CPF `12345678901`, ainda estiver cadastrado.

### Motivo

> A restrição `UNIQUE` não permite que dois funcionários possuam o mesmo CPF.

### Regra validada

```text
Um funcionário não pode possuir o mesmo CPF de outro funcionário.
```

---

# 16. Teste da restrição NOT NULL

Foi realizado um teste tentando inserir um produto sem nome.

```sql
INSERT INTO PRODUTO (
    nome_produto
)
VALUES (
    NULL
);
```

### Resultado esperado

> O comando deve ser rejeitado pelo MySQL.

### Motivo

> O campo `nome_produto` foi definido com `NOT NULL`, portanto não pode receber valor nulo.

---

# 17. Teste de FOREIGN KEY

Foi realizado um teste tentando inserir um expediente para um funcionário inexistente.

```sql
INSERT INTO EXPEDIENTE (
    data_batimento,
    hora_entrada,
    hora_saida,
    hora_extra,
    justificativas,
    id_func
)
VALUES (
    '2026-09-10',
    '08:00:00',
    '17:00:00',
    0,
    NULL,
    999
);
```

### Resultado esperado

> O comando deve gerar erro de chave estrangeira.

### Motivo

> Não existe um funcionário com `id_func = 999`. Como `EXPEDIENTE.id_func` referencia `FUNCIONARIO.id_func`, o banco impede o cadastro de um expediente para um funcionário inexistente.

---

# 18. Resumo dos testes de integridade

| Teste | Restrição validada | Resultado esperado |
|---|---|---|
| Inserção de CPF repetido | `UNIQUE` | Erro |
| Inserção de produto com nome `NULL` | `NOT NULL` | Erro |
| Inserção de expediente com funcionário 999 | `FOREIGN KEY` | Erro |
| Exclusão de funcionário com expediente relacionado | `FOREIGN KEY` | Erro se o expediente não for removido antes |

---

# 19. SELECT para validação dos dados

Após as operações foram utilizadas consultas simples para verificar o conteúdo das tabelas.

```sql
SELECT * FROM FILIAL;
SELECT * FROM CARGO;
SELECT * FROM PRODUTO;
SELECT * FROM SETOR;
SELECT * FROM FUNCIONARIO;
SELECT * FROM EXPEDIENTE;
SELECT * FROM ESTOQUE;
```

### Objetivo

> Os comandos permitem visualizar os registros existentes depois dos `INSERT`, `UPDATE` e `DELETE`, facilitando a conferência das alterações realizadas.

---

# 20. Ordem correta de execução dos INSERTs

Como existem chaves estrangeiras, a ordem de inserção precisa respeitar os relacionamentos.

1. `FILIAL`
2. `CARGO`
3. `PRODUTO`
4. `SETOR`
5. `FUNCIONARIO`
6. `EXPEDIENTE`
7. `ESTOQUE`

### Justificativa

> `FUNCIONARIO` depende de registros existentes em `CARGO`, `SETOR` e `FILIAL`. Já `EXPEDIENTE` depende de `FUNCIONARIO`. A tabela `ESTOQUE` depende de `FILIAL` e `PRODUTO`.

---

# 21. Problemas identificados durante a revisão

| Problema | Causa | Correção |
|---|---|---|
| `EXPEDIENTE` era inserido antes de `FUNCIONARIO` | A FK `id_func` exige que o funcionário já exista | O `INSERT INTO FUNCIONARIO` foi colocado antes de `EXPEDIENTE` |
| `UPDATE ESTOQUE` utilizava `id_estoque` | A tabela utiliza PK composta (`id_filial`, `id_produto`) e não possui `id_estoque` | O `WHERE` foi alterado para `id_filial = 2 AND id_produto = 2` |
| `DELETE FROM FUNCIONARIO WHERE id_func = 1` poderia ser bloqueado | O funcionário possui registro relacionado em `EXPEDIENTE` | O expediente relacionado deve ser removido antes do funcionário |
| Teste de CPF repetido poderia deixar de testar `UNIQUE` se executado depois da exclusão | O CPF `12345678901` pertence ao funcionário 1 | O teste de `UNIQUE` deve ser executado antes da exclusão do funcionário 1 |

---

# 22. Cuidados tomados com UPDATE e DELETE

Durante a manipulação dos dados, foi utilizado `WHERE` nos comandos `UPDATE` e `DELETE`.

Isso é importante porque:

```sql
UPDATE tabela SET campo = valor;
```

sem `WHERE` alteraria todos os registros da tabela.

Da mesma forma:

```sql
DELETE FROM tabela;
```

sem `WHERE` excluiria todos os registros.

No projeto, as condições foram utilizadas para manipular somente os registros escolhidos.

---

# 23. Relação entre as operações e o sistema

As operações realizadas representam situações que podem acontecer no funcionamento da empresa:

- cadastro de uma nova filial;
- cadastro de cargos e setores;
- cadastro de funcionários;
- cadastro dos produtos;
- registro de estoque;
- registro de expediente;
- correção do nome de funcionário;
- reajuste salarial de um cargo;
- atualização de quantidade em estoque;
- exclusão controlada de registros;
- validação de CPF duplicado;
- validação de campos obrigatórios;
- validação dos relacionamentos entre tabelas.

---

# 24. Resultado da Sprint 3/5

Com os comandos desenvolvidos nesta Sprint, o banco passou a possuir registros suficientes para testar sua estrutura.

Também foi possível validar que as restrições definidas na Sprint 2 possuem função prática:

- `UNIQUE` evita CPF duplicado;
- `NOT NULL` impede produto sem nome;
- `FOREIGN KEY` impede referências para funcionários inexistentes;
- as chaves estrangeiras também protegem registros relacionados durante exclusões.

---

# 25. Checklist técnico da Sprint 3/5

- [x] utilizei a estrutura criada na Sprint 2/5;
- [x] inseri dados em `FILIAL`;
- [x] inseri dados em `CARGO`;
- [x] inseri dados em `PRODUTO`;
- [x] inseri dados em `SETOR`;
- [x] inseri dados em `FUNCIONARIO`;
- [x] inseri dados em `EXPEDIENTE`;
- [x] inseri dados em `ESTOQUE`;
- [x] utilizei `INSERT`;
- [x] utilizei `UPDATE`;
- [x] utilizei `DELETE`;
- [x] utilizei condições `WHERE` nas alterações e exclusões;
- [x] testei a restrição `UNIQUE`;
- [x] testei a restrição `NOT NULL`;
- [x] testei uma `FOREIGN KEY`;
- [x] consultei as tabelas utilizando `SELECT`;
- [x] revisei a ordem de inserção por causa das chaves estrangeiras;
- [x] registrei os problemas identificados;
- [x] organizei o script SQL da Sprint;
- [x] preenchi a documentação da Sprint 3/5.

---

# 26. Arquivos da Sprint

Ao final desta etapa, os arquivos relacionados ao projeto deverão incluir:

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql
```

---

# 27. Git/GitHub

A Sprint deve continuar sendo desenvolvida na mesma branch individual utilizada anteriormente.

Os arquivos desta etapa devem ser incluídos no commit:

```text
SPRINT3-5.md
SPRINT3-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 3 de 5 - operações DML
```

O Pull Request final ainda não deve ser aberto nesta etapa.

---

# 28. Próxima etapa

Na Sprint 4/5, os dados inseridos nesta Sprint poderão ser utilizados em consultas SQL mais completas.

A estrutura e os registros permitirão desenvolver consultas utilizando recursos como:

```sql
SELECT
WHERE
ORDER BY
JOIN
COUNT
SUM
AVG
MIN
MAX
GROUP BY
HAVING
```

> A Sprint 4/5 deverá reutilizar o banco estruturado nas Sprints anteriores.
