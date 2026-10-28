# SPRINT 3/5 — Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
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
2. Abra sua conexão.
3. Confirme que o banco criado na Sprint 2/5 existe.
4. Abra ou execute o `SPRINT2-5.sql`, se necessário.
5. Selecione o banco:

```sql
USE nome_do_banco;
```

6. Confira as tabelas:

```sql
DESCRIBE nome_da_tabela;
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
SPRINT3-5.sql
```

Esse arquivo deverá conter os comandos DML desta Sprint.

---

# 3. INSERT — inserindo dados

Estrutura básica:

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

Exemplo:

```sql
INSERT INTO cliente (
    nome,
    email,
    data_nascimento
)
VALUES (
    'Ana Souza',
    'ana@email.com',
    '2000-05-10'
);
```

---

# 4. Inserindo vários registros

```sql
INSERT INTO cliente (
    nome,
    email
)
VALUES
    ('Ana Souza', 'ana@email.com'),
    ('Carlos Lima', 'carlos@email.com'),
    ('Mariana Silva', 'mariana@email.com');
```

---

# 5. Quantidade mínima de dados

Procure inserir:

```text
pelo menos 5 registros em cada tabela principal
```

Exemplo:

```text
CLIENTE        → pelo menos 5 registros
PRODUTO        → pelo menos 5 registros
PEDIDO         → pelo menos 5 registros
ITEM_PEDIDO    → registros suficientes para representar os relacionamentos
```

Os dados precisam ser coerentes e úteis para as consultas da Sprint 4/5.

---

# 6. Ordem correta dos INSERTs

Quando existem `FOREIGN KEY`, insira primeiro os registros das tabelas independentes.

Exemplo:

```text
CLIENTE
   ↓
PEDIDO
   ↓
ITEM_PEDIDO
```

Ordem recomendada:

```text
1. tabelas independentes;
2. tabelas com FOREIGN KEY;
3. tabelas associativas.
```

---

# 7. Planejamento dos dados

| Tabela | Quantidade prevista | Depende de outra tabela? |
|---|---:|---|

| escola | 5 registros | Não (Tabela independente / Pai)

| categoria | 5 registros | Não (Tabela independente / Pai)

| colaborador | 5 registros | Não (Tabela independente / Pai)

| atleta | 5 registros | Sim (escola e categoria)
---

# 8. INSERTs realizados

## Tabela 1

**Nome:**

```
escola

```

```
-- Inserção de Escolas parceiras
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) VALUES
('E. E. Dom Aquino Corrêa', 'Pública', 'Centro', 'Rondonópolis'),
('E. M. Profª Icelina G. Carvalho', 'Pública', 'Vila Operária', 'Rondonópolis'),
('E. E. Adventista de Rondonópolis', 'Privada', 'Jardim Atlântico', 'Rondonópolis'),
('E. E. Antonio Guimarães Balbino', 'Pública', 'Sagrada Família', 'Rondonópolis'),
('E. M. Albano Soares Ferreira', 'Pública', 'Jardim das Flores', 'Rondonópolis');

```

## Tabela 2

**Nome:**

```
categoria
```

```
-- Inserção de Categorias de Atletismo
INSERT INTO categoria (nome_categoria, idade_minima, idade_maxima, genero_categoria) VALUES
('Sub-14 Misto', 12, 13, 'Misto'),
('Sub-16 Masculino', 14, 15, 'Masculino'),
('Sub-16 Feminino', 14, 15, 'Feminino'),
('Sub-18 Masculino', 16, 17, 'Masculino'),
('Sub-18 Feminino', 16, 17, 'Feminino');
```

## Tabela 3

**Nome:**

```
colaborador
```

```
-- Inserção de Colaboradores e Diretoria
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) VALUES
('Walter Anacleto Salido de Souza', '11122233344', 'Presidente / Treinador', '(66) 99911-2233', '2026-01-15'),
('Vanessa Salido', '22233344455', 'Primeira Tesoureira', '(66) 99922-3344', '2026-01-15'),
('Carlos Eduardo Mendes', '33344455666', 'Treinador de Saltos', '(66) 99933-4455', '2026-02-10'),
('Ana Paula Silveira', '44455667788', 'Professora de Apoio / Base', '(66) 99944-5566', '2026-02-15'),
('Marcos Vinícius Rocha', '55566778899', 'Preparador Físico', '(66) 99955-6677', '2026-03-01');
```

## Tabela 4

**Nome:**

```
atleta

```

```
-- Inserção de Atletas vinculados às Escolas e Categorias
INSERT INTO atleta (nome_completo, cpf, data_nascimento, nome_mae, nome_pai, endereco, id_escola, id_categoria, observacoes_medicas) VALUES
('Gabriel Santos Silva', '66677788899', '2012-04-12', 'Maria Santos Silva', 'João Silva', 'Rua das Flores, 123, Centro', 1, 1, 'Nenhuma restrição médica.'),
('Beatriz Lima Souza', '77788899900', '2010-08-22', 'Ana Lima Souza', 'Carlos Souza', 'Av. dos Estados, 456, Vila Operária', 2, 3, 'Alergia leve a poeira.'),
('Lucas Gabriel Pereira', '88899900011', '2011-01-15', 'Juliana Pereira', 'Marcos Pereira', 'Rua 7, 789, Jardim Atlântico', 3, 2, 'Usa óculos para esporte.'),
('Larissa Vitória Martins', '99900011122', '2009-09-30', 'Fernanda Martins', 'Roberto Martins', 'Rua dos Girassóis, 321, Sagrada Família', 4, 5, 'Sem restrições.'),
('Matheus Henrique Costa', '00011122233', '2009-05-18', 'Sandra Costa', 'Paulo Costa', 'Av. Brasil, 654, Jardim das Flores', 5, 4, 'Acompanhamento ortopédico de rotina.');

```

---

# 9. AUTO_INCREMENT

Se a chave primária utiliza `AUTO_INCREMENT`, normalmente você não informa o identificador no `INSERT`.

Exemplo:

```sql
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);
```

Inserção:

```sql
INSERT INTO cliente (nome)
VALUES ('Maria');
```

---

# 10. Tipos de valores

Texto:

```sql
'João da Silva'
```

Inteiro:

```sql
10
```

Decimal:

```sql
199.90
```

Data:

```sql
'2026-09-02'
```

Booleano:

```sql
TRUE
```

ou:

```sql
FALSE
```

Ausência de valor:

```sql
NULL
```

---

# 11. Testando restrições de integridade

Agora que existem dados, teste restrições criadas na Sprint 2/5.

Exemplo:

```sql
email VARCHAR(150) UNIQUE
```

Pergunte:

- o banco impede valores duplicados?
- `NOT NULL` está funcionando?
- a `FOREIGN KEY` impede referências inexistentes?

Registre os resultados:

| Restrição testada | O que foi testado? | Resultado |
|---|---|---|

| UNIQUE | Tentativa de cadastrar um segundo atleta utilizando um número de CPF (cpf) já existente na tabela atleta. | O SGBD bloqueou a operação e retornou um erro de violação da restrição de chave única (Duplicate entry), garantindo a unicidade do documento.

| NOT NULL | Tentativa de inserir uma nova escola omitindo o preenchimento do campo obrigatório nome_escola. | O SGBD impediu a execução do comando, gerando um erro informando que o campo não pode receber valores nulos (Column 'nome_escola' cannot be null).

| FOREIGN KEY | Tentativa de cadastrar um atleta informando um código de escola (id_escola = 99) inexistente na tabela pai escola. | O SGBD bloqueou a inserção devido à violação da integridade referencial (Foreign key constraint fails), impedindo registros órfãos.

> Não mantenha comandos propositalmente inválidos no `SPRINT3-5.sql` final.

---

# 12. UPDATE — alterando registros

Estrutura:

```sql
UPDATE nome_tabela
SET campo = novo_valor
WHERE condicao;
```

Exemplo:

```sql
UPDATE cliente
SET email = 'novo@email.com'
WHERE id_cliente = 1;
```

---

# 13. Atenção ao WHERE no UPDATE

Este comando:

```sql
UPDATE cliente
SET ativo = FALSE;
```

pode alterar **todos os registros**.

Já:

```sql
UPDATE cliente
SET ativo = FALSE
WHERE id_cliente = 3;
```

altera somente o registro escolhido.

> Confira sempre o `WHERE` antes da execução.

---

# 14. UPDATEs obrigatórios

Execute pelo menos:

```text
3 operações UPDATE
```

## UPDATE 1

```
Atualizando o telefone de contato de um colaborador na tabela colaborador
UPDATE colaborador
SET telefone = '(66) 99988-7766'
WHERE id_colaborador = 2;

```

**O que foi alterado?**

> Foi atualizado o número de telefone da primeira tesoureira (Vanessa Salido, ID 2) para o novo contato telefônico institucional da associação.

## UPDATE 2

```
-- Atualizando as observações médicas de um atleta na tabela atleta
UPDATE atleta
SET observacoes_medicas = 'Alergia leve a poeira. Uso contínuo de antialérgico sob prescrição.'
WHERE id_atleta = 2;

```

**O que foi alterado?**

> Foram detalhadas as restrições e orientações médicas da atleta Beatriz Lima Souza (ID 2), aprimorando o cadastro de acompanhamento de saúde da associação.

## UPDATE 3

```
-- Atualizando a faixa etária de uma categoria de atletismo na tabela categoria
UPDATE categoria
SET idade_maxima = 16
WHERE id_categoria = 3;

```

**O que foi alterado?**

> Foi corrigida a idade máxima limite da categoria 'Sub-16 Feminino' (ID 3), ajustando a regra de enquadramento das atletas conforme as novas diretrizes da federação.

---

# 15. DELETE — removendo registros

Estrutura:

```sql
DELETE FROM nome_tabela
WHERE condicao;
```

Exemplo:

```sql
DELETE FROM cliente
WHERE id_cliente = 5;
```

---

# 16. Atenção ao WHERE no DELETE

Este comando:

```sql
DELETE FROM cliente;
```

remove todos os registros.

Este:

```sql
DELETE FROM cliente
WHERE id_cliente = 5;
```

remove apenas o registro selecionado.

> Nunca execute `DELETE` sem conferir a condição.

---

# 17. DELETE e FOREIGN KEY

Uma exclusão pode ser impedida pela integridade referencial.

Exemplo:

```text
CLIENTE
   ↓
PEDIDO
```

Se um pedido depende de um cliente, o MySQL pode impedir:

```sql
DELETE FROM cliente
WHERE id_cliente = 1;
```

Isso pode indicar que a `FOREIGN KEY` está funcionando corretamente.

---

# 18. DELETEs obrigatórios

Execute pelo menos:

```text
2 operações DELETE
```

## DELETE 1

```
-- Criando e removendo um registro temporário para demonstração de exclusão segura
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) 
VALUES ('Escola Teste Temporária', 'Pública', 'Teste', 'Rondonópolis');

-- Removendo o registro temporário criado
DELETE FROM escola
WHERE nome_escola = 'Escola Teste Temporária';

```

**Registro removido:**

> Foi removido um registro temporário inserido para fins de validação da operação de exclusão (DELETE), garantindo que nenhuma dependência relacional ativa fosse afetada.

## DELETE 2

```
-- Removendo um registro de colaborador inativo ou de teste na tabela colaborador
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) 
VALUES ('Colaborador Temporário', '99988877766', 'Apoio Eventual', '(66) 99900-1122', '2026-03-05');

DELETE FROM colaborador
WHERE cpf = '99988877766';

```

**Registro removido:**

> Foi removido o registro de um colaborador temporário previamente cadastrado para teste de controle de exclusão, mantendo a tabela limpa e restrita aos membros efetivos da diretoria e comissão técnica.
---

# 19. Conferindo os registros

Nesta Sprint, você pode utilizar `SELECT` apenas para verificar o estado das tabelas.

```sql
SELECT * FROM nome_tabela;
```

Antes de um `UPDATE` ou `DELETE`, é recomendável verificar o registro.

```sql
SELECT *
FROM cliente
WHERE id_cliente = 3;
```

Depois execute a alteração e consulte novamente.

---

# 20. Modelo genérico para adaptar

**Não entregue o código abaixo sem adaptação.**

```-- ============================================================
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS (DML)
-- PROJETO: Gestão de Atletas e Colaboradores da RAAEI
-- AUTOR: Walter Anacleto Salido de Souza
-- ============================================================

USE db_raaei;

-- ------------------------------------------------------------
-- 1. INSERÇÃO DE DADOS (DML - INSERT)
-- ------------------------------------------------------------

-- Inserindo Escolas parceiras (Tabela independente)
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) VALUES
('E. E. Dom Aquino Corrêa', 'Pública', 'Centro', 'Rondonópolis'),
('E. M. Profª Icelina G. Carvalho', 'Pública', 'Vila Operária', 'Rondonópolis'),
('E. E. Adventista de Rondonópolis', 'Privada', 'Jardim Atlântico', 'Rondonópolis'),
('E. E. Antonio Guimarães Balbino', 'Pública', 'Sagrada Família', 'Rondonópolis'),
('E. M. Albano Soares Ferreira', 'Pública', 'Jardim das Flores', 'Rondonópolis');

-- Inserindo Categorias de Atletismo (Tabela independente)
INSERT INTO categoria (nome_categoria, idade_minima, idade_maxima, genero_categoria) VALUES
('Sub-14 Misto', 12, 13, 'Misto'),
('Sub-16 Masculino', 14, 15, 'Masculino'),
('Sub-16 Feminino', 14, 15, 'Feminino'),
('Sub-18 Masculino', 16, 17, 'Masculino'),
('Sub-18 Feminino', 16, 17, 'Feminino');

-- Inserindo Colaboradores e Diretoria (Tabela independente)
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) VALUES
('Walter Anacleto Salido de Souza', '11122233344', 'Presidente / Treinador', '(66) 99911-2233', '2026-01-15'),
('Vanessa Salido', '22233344455', 'Primeira Tesoureira', '(66) 99922-3344', '2026-01-15'),
('Carlos Eduardo Mendes', '33344455666', 'Treinador de Saltos', '(66) 99933-4455', '2026-02-10'),
('Ana Paula Silveira', '44455667788', 'Professora de Apoio / Base', '(66) 99944-5566', '2026-02-15'),
('Marcos Vinícius Rocha', '55566778899', 'Preparador Físico', '(66) 99955-6677', '2026-03-01');

-- Inserindo Atletas vinculados às Escolas e Categorias (Tabela dependente)
INSERT INTO atleta (nome_completo, cpf, data_nascimento, nome_mae, nome_pai, endereco, id_escola, id_categoria, observacoes_medicas) VALUES
('Gabriel Santos Silva', '66677788899', '2012-04-12', 'Maria Santos Silva', 'João Silva', 'Rua das Flores, 123, Centro', 1, 1, 'Nenhuma restrição médica.'),
('Beatriz Lima Souza', '77788899900', '2010-08-22', 'Ana Lima Souza', 'Carlos Souza', 'Av. dos Estados, 456, Vila Operária', 2, 3, 'Alergia leve a poeira.'),
('Lucas Gabriel Pereira', '88899900011', '2011-01-15', 'Juliana Pereira', 'Marcos Pereira', 'Rua 7, 789, Jardim Atlântico', 3, 2, 'Usa óculos para esporte.'),
('Larissa Vitória Martins', '99900011122', '2009-09-30', 'Fernanda Martins', 'Roberto Martins', 'Rua dos Girassóis, 321, Sagrada Família', 4, 5, 'Sem restrições.'),
('Matheus Henrique Costa', '00011122233', '2009-05-18', 'Sandra Costa', 'Paulo Costa', 'Av. Brasil, 654, Jardim das Flores', 5, 4, 'Acompanhamento ortopédico de rotina.');

-- ------------------------------------------------------------
-- 2. VERIFICAÇÃO INICIAL DOS DADOS (SELECT)
-- ------------------------------------------------------------
SELECT * FROM escola;
SELECT * FROM categoria;
SELECT * FROM colaborador;
SELECT * FROM atleta;

-- ------------------------------------------------------------
-- 3. ATUALIZAÇÃO DE DADOS (DML - UPDATE)
-- ------------------------------------------------------------

-- UPDATE 1: Atualizando o telefone de contato de um colaborador
UPDATE colaborador
SET telefone = '(66) 99988-7766'
WHERE id_colaborador = 2;

-- UPDATE 2: Atualizando as observações médicas de um atleta
UPDATE atleta
SET observacoes_medicas = 'Alergia leve a poeira. Uso contínuo de antialérgico sob prescrição.'
WHERE id_atleta = 2;

-- UPDATE 3: Atualizando a idade máxima de uma categoria de atletismo
UPDATE categoria
SET idade_maxima = 16
WHERE id_categoria = 3;

-- ------------------------------------------------------------
-- 4. REMOÇÃO DE DADOS (DML - DELETE)
-- ------------------------------------------------------------

-- Inserindo e removendo um registro temporário para demonstração segura de exclusão
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) 
VALUES ('Escola Teste Temporária', 'Pública', 'Teste', 'Rondonópolis');

DELETE FROM escola
WHERE nome_escola = 'Escola Teste Temporária';

-- Inserindo e removendo um colaborador temporário para teste de exclusão
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) 
VALUES ('Colaborador Temporário', '99988877766', 'Apoio Eventual', '(66) 99900-1122', '2026-03-05');

DELETE FROM colaborador
WHERE cpf = '99988877766';

-- ------------------------------------------------------------
-- 5. VERIFICAÇÃO FINAL DOS DADOS (SELECT)
-- ------------------------------------------------------------
SELECT * FROM colaborador;
SELECT * FROM atleta;
SELECT * FROM categoria;
SELECT * FROM escola;
```

---

# 21. Estrutura recomendada do SPRINT3-5.sql

```
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE db_raaei;


-- ============================================================
-- INSERTS — TABELA 1 (escola)
-- ============================================================

INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) VALUES
('E. E. Dom Aquino Corrêa', 'Pública', 'Centro', 'Rondonópolis'),
('E. M. Profª Icelina G. Carvalho', 'Pública', 'Vila Operária', 'Rondonópolis'),
('E. E. Adventista de Rondonópolis', 'Privada', 'Jardim Atlântico', 'Rondonópolis'),
('E. E. Antonio Guimarães Balbino', 'Pública', 'Sagrada Família', 'Rondonópolis'),
('E. M. Albano Soares Ferreira', 'Pública', 'Jardim das Flores', 'Rondonópolis');


-- ============================================================
-- INSERTS — TABELA 2 (categoria)
-- ============================================================

INSERT INTO categoria (nome_categoria, idade_minima, idade_maxima, genero_categoria) VALUES
('Sub-14 Misto', 12, 13, 'Misto'),
('Sub-16 Masculino', 14, 15, 'Masculino'),
('Sub-16 Feminino', 14, 15, 'Feminino'),
('Sub-18 Masculino', 16, 17, 'Masculino'),
('Sub-18 Feminino', 16, 17, 'Feminino');


-- ============================================================
-- INSERTS — TABELA 3 (colaborador)
-- ============================================================

INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) VALUES
('Walter Anacleto Salido de Souza', '11122233344', 'Presidente / Treinador', '(66) 99911-2233', '2026-01-15'),
('Vanessa Salido', '22233344455', 'Primeira Tesoureira', '(66) 99922-3344', '2026-01-15'),
('Carlos Eduardo Mendes', '33344455666', 'Treinador de Saltos', '(66) 99933-4455', '2026-02-10'),
('Ana Paula Silveira', '44455667788', 'Professora de Apoio / Base', '(66) 99944-5566', '2026-02-15'),
('Marcos Vinícius Rocha', '55566778899', 'Preparador Físico', '(66) 99955-6677', '2026-03-01');


-- ============================================================
-- INSERTS — TABELA 4 (atleta)
-- ============================================================

INSERT INTO atleta (nome_completo, cpf, data_nascimento, nome_mae, nome_pai, endereco, id_escola, id_categoria, observacoes_medicas) VALUES
('Gabriel Santos Silva', '66677788899', '2012-04-12', 'Maria Santos Silva', 'João Silva', 'Rua das Flores, 123, Centro', 1, 1, 'Nenhuma restrição médica.'),
('Beatriz Lima Souza', '77788899900', '2010-08-22', 'Ana Lima Souza', 'Carlos Souza', 'Av. dos Estados, 456, Vila Operária', 2, 3, 'Alergia leve a poeira.'),
('Lucas Gabriel Pereira', '88899900011', '2011-01-15', 'Juliana Pereira', 'Marcos Pereira', 'Rua 7, 789, Jardim Atlântico', 3, 2, 'Usa óculos para esporte.'),
('Larissa Vitória Martins', '99900011122', '2009-09-30', 'Fernanda Martins', 'Roberto Martins', 'Rua dos Girassóis, 321, Sagrada Família', 4, 5, 'Sem restrições.'),
('Matheus Henrique Costa', '00011122233', '2009-05-18', 'Sandra Costa', 'Paulo Costa', 'Av. Brasil, 654, Jardim das Flores', 5, 4, 'Acompanhamento ortopédico de rotina.');


-- ============================================================
-- VERIFICAÇÕES
-- ============================================================

SELECT * FROM escola;
SELECT * FROM categoria;
SELECT * FROM colaborador;
SELECT * FROM atleta;


-- ============================================================
-- UPDATES
-- ============================================================

-- UPDATE 1: Atualizando o telefone de contato de um colaborador
UPDATE colaborador
SET telefone = '(66) 99988-7766'
WHERE id_colaborador = 2;

-- UPDATE 2: Atualizando as observações médicas de um atleta
UPDATE atleta
SET observacoes_medicas = 'Alergia leve a poeira. Uso contínuo de antialérgico sob prescrição.'
WHERE id_atleta = 2;

-- UPDATE 3: Atualizando a idade máxima de uma categoria de atletismo
UPDATE categoria
SET idade_maxima = 16
WHERE id_categoria = 3;


-- ============================================================
-- DELETES
-- ============================================================

-- Inserindo e removendo um registro temporário para demonstração segura de exclusão em escola
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) 
VALUES ('Escola Teste Temporária', 'Pública', 'Teste', 'Rondonópolis');

DELETE FROM escola
WHERE nome_escola = 'Escola Teste Temporária';

-- Inserindo e removendo um colaborador temporário para teste de exclusão em colaborador
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) 
VALUES ('Colaborador Temporário', '99988877766', 'Apoio Eventual', '(66) 99900-1122', '2026-03-05');

DELETE FROM colaborador
WHERE cpf = '99988877766';


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

SELECT * FROM escola;
SELECT * FROM categoria;
SELECT * FROM colaborador;
SELECT * FROM atleta;
```

---

# 22. Passo a passo no MySQL Workbench

## Etapa 1 — Abra o banco

No painel `Schemas`, confirme se o banco e as tabelas da Sprint 2/5 estão disponíveis.

## Etapa 2 — Selecione o banco

```sql
USE nome_do_banco;
```

## Etapa 3 — Insira dados nas tabelas independentes

Comece pelas tabelas que não possuem dependências.

## Etapa 4 — Confira os dados

```sql
SELECT * FROM nome_tabela;
```

## Etapa 5 — Insira dados nas tabelas dependentes

Respeite as `FOREIGN KEY`.

## Etapa 6 — Execute os UPDATEs

Realize pelo menos três alterações coerentes.

## Etapa 7 — Execute os DELETEs

Realize pelo menos duas exclusões seguras.

## Etapa 8 — Faça a verificação final

Confira o conteúdo das tabelas.

## Etapa 9 — Salve o arquivo

```text
File → Save Script As...
```

Nome obrigatório:

```text
SPRINT3-5.sql
```

---

# 23. Resumo dos dados

| Tabela | Quantidade aproximada de registros ao final |
|---|---:|

| escola | 5 registros

| categoria | 5 registros

| colaborador | 5 registros

| atleta | 5 registros

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos:

```
22 registros no total (sendo 5 em cada tabela principal, além de 2 registros temporários utilizados para validação das operações de exclusão).
```

## UPDATE

Quantidade de operações:

```
3 operações estruturadas (atualização de contato de colaborador, refinamento de observação médica de atleta e ajuste de faixa etária em categoria).
```

## DELETE

Quantidade de operações:

```
2 operações controladas (exclusão de registros temporários criados para teste de integridade em escola e colaborador).
```

---

# 25. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|

| Duplicate entry | Tentativa de inserir um registro com um valor duplicado em um campo configurado com a restrição UNIQUE (como CPF ou e-mail). | Validação prévia dos dados de cadastro e restrição da inserção a valores únicos e válidos.

| Cannot add or update a child row | Violação de integridade referencial ao tentar inserir um registro dependente referenciando uma chave estrangeira inexistente na tabela pai (FOREIGN KEY). | Garantia da ordem correta de inserção, populando primeiramente as tabelas independentes (escola, categoria) antes da tabela dependente (atleta).

| Column cannot be null | Omissão de valor em um campo estruturado obrigatoriamente com a restrição NOT NULL durante a operação de inserção. | Inclusão explícita de todos os campos obrigatórios nos comandos INSERT correspondentes.

Mensagens que podem aparecer:

```text
Duplicate entry
Cannot add or update a child row
Cannot delete or update a parent row
Column cannot be null
Data too long for column
Unknown column
```

---

# 26. O que deve existir ao final desta Sprint

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql
```

Não exclua arquivos das etapas anteriores.

---

# 27. Checklist da Sprint 3/5

- [ ] utilizei o banco criado na Sprint 2/5;
- [ ] utilizei `USE`;
- [ ] inseri dados coerentes com o projeto;
- [ ] respeitei a ordem das tabelas;
- [ ] procurei inserir pelo menos 5 registros nas tabelas principais;
- [ ] testei restrições de integridade;
- [ ] executei pelo menos 3 `UPDATE`;
- [ ] os `UPDATE` possuem condição adequada;
- [ ] executei pelo menos 2 `DELETE`;
- [ ] os `DELETE` possuem condição adequada;
- [ ] verifiquei dependências de `FOREIGN KEY`;
- [ ] utilizei `SELECT` para conferência;
- [ ] registrei os problemas encontrados;
- [ ] salvei o código como `SPRINT3-5.sql`;
- [ ] preenchi completamente o `SPRINT3-5.md`;
- [ ] revisei os arquivos antes do commit.

---

# 28. Regras de Git/GitHub

A atividade continua **individual**.

Utilize a mesma branch individual das Sprints anteriores.

Não crie uma branch nova.

## Arquivos obrigatórios no commit desta Sprint

```text
SPRINT3-5.md
SPRINT3-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 3 de 5 - operações DML
```

---

# 29. Pull Request

**Ainda não abra o Pull Request final.**

O PR será aberto somente após a Sprint 5/5.

```text
SPRINT1-5.md
      ↓ commit

SPRINT2-5.md + SPRINT2-5.sql
      ↓ commit

SPRINT3-5.md + SPRINT3-5.sql
      ↓ commit

SPRINT4-5.md + SPRINT4-5.sql
      ↓ commit

SPRINT5-5.md + SPRINT5-5.sql
      ↓ commit

PULL REQUEST FINAL
      ↓
main
```

---

# 30. Critério de conclusão

A Sprint 3/5 será considerada concluída quando o aluno:

1. utilizar o banco criado anteriormente;
2. popular suas tabelas;
3. respeitar os relacionamentos existentes;
4. utilizar corretamente `INSERT`;
5. realizar pelo menos 3 `UPDATE`;
6. realizar pelo menos 2 `DELETE`;
7. preservar a integridade dos dados;
8. documentar a atividade no `SPRINT3-5.md`;
9. salvar o código executável em `SPRINT3-5.sql`;
10. incluir os dois arquivos no commit.

---

# Próxima etapa

Na **Sprint 4/5**, os dados criados nesta etapa serão utilizados para consultas SQL.

Serão trabalhados:

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

> **Não desenvolva a Sprint 4/5 neste arquivo.**
