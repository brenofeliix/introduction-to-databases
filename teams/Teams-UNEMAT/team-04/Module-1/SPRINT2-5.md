# SPRINT 2/5 — Implementação da Estrutura do Banco de Dados com DDL

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT2-5.md` + `SPRINT2-5.sql`

---

# Objetivo da Sprint 2/5

Nesta etapa, cada aluno deverá transformar o planejamento produzido na `SPRINT1-5.md` em uma **estrutura funcional de banco de dados no MySQL**.

O objetivo é criar o banco e suas tabelas utilizando comandos DDL (*Data Definition Language*), implementando corretamente:

- `CREATE DATABASE`;
- `USE`;
- `CREATE TABLE`;
- tipos de dados;
- `PRIMARY KEY`;
- `AUTO_INCREMENT`, quando adequado;
- `NOT NULL`;
- `UNIQUE`;
- `DEFAULT`, quando adequado;
- `FOREIGN KEY`;
- `ALTER TABLE`;
- `DROP TABLE` em exercício controlado;
- validação da estrutura criada.

Ao final da Sprint 2/5, o aluno deverá possuir **dois arquivos**:

```text
SPRINT2-5.md
SPRINT2-5.sql
```

O arquivo `.md` documentará as decisões, explicações e evidências da Sprint.

O arquivo `.sql` conterá o **script SQL executável produzido no MySQL Workbench**.

> Os dois arquivos deverão permanecer na branch individual do aluno e serão incluídos posteriormente no Pull Request final, após a Sprint 5/5.

---

# 1. Antes de começar

Abra a sua `SPRINT1-5.md` e revise:

- tema escolhido;
- entidades;
- atributos;
- chaves primárias;
- relacionamentos;
- cardinalidades;
- possíveis chaves estrangeiras;
- restrições de integridade;
- regras de negócio.

A Sprint 2/5 deve ser uma implementação do que foi planejado anteriormente.

Caso seja necessário alterar alguma decisão da Sprint 1/5, isso é permitido, mas a mudança deverá ser registrada neste arquivo.

---

## Alterações realizadas em relação à Sprint 1/5

> Durante a implementação foram adicionadas as tabelas `PRODUTO`, `EXPEDIENTE` e `ESTOQUE`. A carga horária, que inicialmente havia sido pensada como uma entidade separada, passou a fazer parte da tabela `CARGO`. Também foram definidos os relacionamentos do funcionário com cargo, setor e filial, além do controle de expediente e do estoque de produtos por filial.

# 2. Passo a passo no MySQL Workbench

## Passo 1 — Abrir o MySQL Workbench

1. Abra o **MySQL Workbench**.
2. Na tela inicial, localize sua conexão MySQL.
3. Clique na conexão.
4. Informe a senha, caso seja solicitado.
5. Aguarde a abertura do ambiente SQL.

Ao entrar, você deverá visualizar:

- área de edição SQL;
- painel **Navigator**;
- seção **Schemas**;
- barra de execução dos comandos.

---

## Passo 2 — Criar uma nova aba SQL

Clique em:

```text
File → New Query Tab
```

ou utilize o botão de criação de uma nova aba SQL.

Essa será a área onde o script da Sprint será desenvolvido.

---

## Passo 3 — Abrir o arquivo modelo `SPRINT2-5.sql`

Utilize o arquivo `SPRINT2-5.sql` fornecido pelo professor como estrutura inicial.

Você poderá:

1. abrir o arquivo diretamente no Workbench; ou
2. copiar o conteúdo para uma nova aba SQL.

O código disponibilizado é **genérico**.

Você deverá substituir os nomes, atributos, tipos de dados e relacionamentos de acordo com o banco planejado na Sprint 1/5.

---

# 3. Criando o banco de dados

Todo projeto deverá possuir um banco de dados próprio.

Estrutura genérica:

```sql
CREATE DATABASE nome_do_banco;

USE nome_do_banco;
```

Exemplo:

```sql
CREATE DATABASE loja_virtual;

USE loja_virtual;
```

## Código utilizado no seu projeto

```sql
DROP DATABASE IF EXISTS Rh_sorveteria;

CREATE DATABASE Rh_sorveteria;

USE Rh_sorveteria;
```

## Nome definitivo do banco

```text
Rh_sorveteria
```

---

# 4. Tipos de dados

Escolha tipos coerentes com as informações armazenadas.

Alguns tipos comuns no MySQL:

```sql
INT
BIGINT
VARCHAR(100)
CHAR(2)
DATE
DATETIME
DECIMAL(10,2)
BOOLEAN
TEXT
```

Exemplos:

```sql
id_cliente INT
nome VARCHAR(120)
cpf CHAR(11)
data_nascimento DATE
preco DECIMAL(10,2)
ativo BOOLEAN
descricao TEXT
```

## Atenção

Não escolha tipos apenas porque o comando funciona.

Pergunte:

- esse campo armazenará números inteiros?
- terá casas decimais?
- possui tamanho previsível?
- representa data?
- representa texto curto ou texto longo?
- será usado como identificador?

---

# 5. Criando as tabelas

Com base na Sprint 1/5, implemente as tabelas do banco.

Para esta atividade, o projeto deverá possuir **pelo menos 4 tabelas relacionadas**, salvo orientação diferente do professor.

Estrutura genérica:

```sql
CREATE TABLE nome_tabela (
    id INT PRIMARY KEY AUTO_INCREMENT,
    campo_1 VARCHAR(100) NOT NULL,
    campo_2 DATE,
    campo_3 DECIMAL(10,2)
);
```

## Tabelas planejadas

| Nº | Nome da tabela | Finalidade |
|---:|---|---|
| 1 | FILIAL | Armazena as informações das filiais da sorveteria e açaiteria. |
| 2 | CARGO | Armazena os cargos, salário base e carga horária dos funcionários. |
| 3 | PRODUTO | Armazena os produtos utilizados no controle de estoque. |
| 4 | SETOR | Armazena os setores onde os funcionários trabalham. |
| 5 | FUNCIONARIO | Armazena os dados individuais dos funcionários e relaciona cada funcionário ao cargo, setor e filial. |
| 6 | EXPEDIENTE | Armazena os batimentos de ponto, horários, horas extras e justificativas dos funcionários. |
| 7 | ESTOQUE | Controla a quantidade de cada produto existente em cada filial. |

---

# 6. Ordem de criação das tabelas

A ordem de criação é importante quando existem `FOREIGN KEY`.

Regra prática:

```text
1. criar primeiro as tabelas independentes;
2. depois criar as tabelas que possuem chaves estrangeiras;
3. criar por último as tabelas associativas, quando existirem.
```

Exemplo:

```text
CLIENTE
PRODUTO
    ↓
PEDIDO
    ↓
ITEM_PEDIDO
```

Se `PEDIDO` possui uma FK para `CLIENTE`, então `CLIENTE` deve existir antes de `PEDIDO`.

## Ordem definida para o seu projeto

1. FILIAL
2. CARGO
3. PRODUTO
4. SETOR
5. FUNCIONARIO
6. EXPEDIENTE
7. ESTOQUE

As tabelas `FILIAL`, `CARGO`, `PRODUTO` e `SETOR` são criadas primeiro porque não dependem de outras tabelas. Depois é criada `FUNCIONARIO`, que possui chaves estrangeiras para `CARGO`, `SETOR` e `FILIAL`. Em seguida é criada `EXPEDIENTE`, que depende de `FUNCIONARIO`, e por último `ESTOQUE`, que relaciona `FILIAL` e `PRODUTO`.

---

# 7. PRIMARY KEY

Cada tabela deverá possuir uma chave primária adequada.

Estrutura comum:

```sql
id INT PRIMARY KEY AUTO_INCREMENT
```

Exemplo:

```sql
id_cliente INT PRIMARY KEY AUTO_INCREMENT
```

## Chaves primárias implementadas

| Tabela | Chave primária | Utiliza `AUTO_INCREMENT`? |
|---|---|---|
| FILIAL | id_filial | Sim |
| CARGO | id_cargo | Sim |
| PRODUTO | id_produto | Sim |
| SETOR | id_setor | Sim |
| FUNCIONARIO | id_func | Sim |
| EXPEDIENTE | id_expediente | Sim |
| ESTOQUE | id_filial + id_produto | Não. Utiliza chave primária composta. |

---

# 8. NOT NULL

Utilize `NOT NULL` quando a informação for obrigatória.

Exemplo:

```sql
nome VARCHAR(120) NOT NULL
```

Não utilize `NOT NULL` indiscriminadamente. A restrição deve refletir uma regra de negócio.

## Campos obrigatórios implementados

| Tabela | Campo | Por que é obrigatório? |
|---|---|---|
| FILIAL | Modulo, Localizacao, data_abertura | São informações necessárias para identificar e organizar cada filial. |
| CARGO | nome_cargo, salario_base, carga_horaria | O cargo precisa possuir nome, salário base e carga horária definidos. |
| PRODUTO | nome_produto | Todo produto precisa possuir um nome cadastrado. |
| SETOR | nome_setor | Todo setor precisa possuir um nome cadastrado. |
| FUNCIONARIO | nome_func, cpf_func, data_nascimento, data_admissao, id_cargo, id_setor, id_filial | São dados necessários para identificar o funcionário e definir onde e em qual função ele trabalha. |
| EXPEDIENTE | data_batimento, hora_entrada, hora_saida, id_func | O registro de expediente precisa informar a data, os horários e o funcionário relacionado. |
| ESTOQUE | quantidade, id_filial, id_produto | O estoque precisa informar a quantidade e qual produto pertence a qual filial. |

---

# 9. UNIQUE

Utilize `UNIQUE` quando um valor não puder se repetir.

Exemplo:

```sql
email VARCHAR(150) UNIQUE
```

ou:

```sql
cpf CHAR(11) NOT NULL UNIQUE
```

## Restrições `UNIQUE` implementadas

| Tabela | Campo | Por que não pode se repetir? |
|---|---|---|
| FUNCIONARIO | cpf_func | O CPF identifica cada funcionário de forma individual e não deve existir mais de um cadastro com o mesmo CPF. |

A restrição `UNIQUE` foi utilizada somente no CPF do funcionário, pois é o campo do projeto que precisa ser único entre os registros.

---

# 10. DEFAULT

Utilize `DEFAULT` quando existir um valor padrão coerente.

Exemplo:

```sql
ativo BOOLEAN NOT NULL DEFAULT TRUE
```

ou:

```sql
status VARCHAR(20) NOT NULL DEFAULT 'ATIVO'
```

## Valores padrão utilizados

| Tabela | Campo | DEFAULT | Justificativa |
|---|---|---|---|
| EXPEDIENTE | hora_extra | 0 | Quando não houver hora extra registrada, o campo inicia com valor padrão igual a zero. |

O `DEFAULT` foi utilizado no campo `hora_extra` para evitar que um novo registro de expediente fique sem um valor inicial para hora extra.

---

# 11. FOREIGN KEY

As chaves estrangeiras representam relacionamentos entre tabelas.

Estrutura genérica:

```sql
CREATE TABLE tabela_filha (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_tabela_pai INT NOT NULL,

    CONSTRAINT fk_tabela_filha_tabela_pai
        FOREIGN KEY (id_tabela_pai)
        REFERENCES tabela_pai(id_tabela_pai)
);
```

Exemplo:

```sql
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);
```

## Regras importantes para FK

Verifique se:

- a tabela referenciada já existe;
- o campo referenciado é `PRIMARY KEY` ou possui restrição adequada;
- os tipos das duas colunas são compatíveis;
- o nome do campo está correto;
- o relacionamento corresponde ao planejamento.

## Chaves estrangeiras implementadas

| Tabela | Campo FK | Referencia | Relacionamento |
|---|---|---|---|
| FUNCIONARIO | id_cargo | CARGO(id_cargo) | Um cargo pode estar relacionado a vários funcionários. |
| FUNCIONARIO | id_setor | SETOR(id_setor) | Um setor pode possuir vários funcionários. |
| FUNCIONARIO | id_filial | FILIAL(id_filial) | Uma filial pode possuir vários funcionários. |
| EXPEDIENTE | id_func | FUNCIONARIO(id_func) | Um funcionário pode possuir vários registros de expediente. |
| ESTOQUE | id_filial | FILIAL(id_filial) | Uma filial pode possuir vários produtos em estoque. |
| ESTOQUE | id_produto | PRODUTO(id_produto) | Um produto pode existir no estoque de várias filiais. |

---

# 12. Relacionamento N:N

Caso exista um relacionamento muitos-para-muitos (`N:N`), normalmente será necessária uma tabela associativa.

Exemplo:

```text
ALUNO N:N DISCIPLINA
```

pode se tornar:

```text
ALUNO
   1
   |
   N
MATRICULA
   N
   |
   1
DISCIPLINA
```

Estrutura genérica:

```sql
CREATE TABLE tabela_associativa (
    id_a INT NOT NULL,
    id_b INT NOT NULL,

    PRIMARY KEY (id_a, id_b),

    CONSTRAINT fk_associativa_a
        FOREIGN KEY (id_a)
        REFERENCES tabela_a(id_a),

    CONSTRAINT fk_associativa_b
        FOREIGN KEY (id_b)
        REFERENCES tabela_b(id_b)
);
```

## Seu banco possui relacionamento N:N?

- [x] Sim
- [ ] Não

Se sim, explique como foi implementado:

> Existe um relacionamento N:N entre `FILIAL` e `PRODUTO`. Uma filial pode possuir vários produtos e o mesmo produto pode existir em várias filiais. Esse relacionamento foi implementado através da tabela `ESTOQUE`, que possui as chaves estrangeiras `id_filial` e `id_produto`. As duas colunas juntas formam uma chave primária composta, impedindo o mesmo produto de ser cadastrado mais de uma vez para a mesma filial.

---

# 13. ALTER TABLE

Nesta Sprint, execute pelo menos **uma alteração estrutural utilizando `ALTER TABLE`**.

Exemplos:

### Adicionar coluna

```sql
ALTER TABLE nome_tabela
ADD COLUMN novo_campo VARCHAR(100);
```

### Modificar tipo

```sql
ALTER TABLE nome_tabela
MODIFY COLUMN novo_campo VARCHAR(150);
```

### Adicionar restrição

```sql
ALTER TABLE nome_tabela
ADD CONSTRAINT uq_nome UNIQUE (novo_campo);
```

## ALTER TABLE utilizado no projeto

```sql
ALTER TABLE FUNCIONARIO
RENAME COLUMN cpf TO cpf_func;
```

### Explique a alteração

> O comando foi utilizado para alterar o nome da coluna `cpf` da tabela `FUNCIONARIO` para `cpf_func`. A mudança deixa o nome do campo mais específico e facilita identificar que o CPF pertence ao funcionário.

---

# 14. DROP TABLE — exercício controlado

`DROP TABLE` remove a tabela e sua estrutura.

Para praticar sem destruir o banco principal, crie uma tabela temporária:

```sql
CREATE TABLE tabela_teste (
    id INT PRIMARY KEY
);
```

Depois:

```sql
DROP TABLE tabela_teste;
```

## Código executado

```sql
CREATE TABLE tabela_teste (
    id INT PRIMARY KEY
);

DROP TABLE tabela_teste;
```

## Explique a diferença

Qual é a diferença entre:

```sql
DELETE FROM tabela;
```

e:

```sql
DROP TABLE tabela;
```

> O comando `DELETE FROM tabela` apaga os registros existentes dentro da tabela, mas mantém a estrutura da tabela no banco de dados. Já o comando `DROP TABLE tabela` remove a tabela inteira, incluindo sua estrutura e seus dados.

---

# 15. Estrutura genérica completa para adaptar

O modelo abaixo serve apenas como referência estrutural.

**Não entregue o código exatamente como está.**

Adapte tudo ao tema escolhido na Sprint 1/5.

```sql
-- ============================================================
-- SPRINT 2/5
-- MODELO GENÉRICO DE BANCO RELACIONAL
-- ============================================================

CREATE DATABASE nome_do_banco;

USE nome_do_banco;

-- ------------------------------------------------------------
-- TABELA 1 — independente
-- ------------------------------------------------------------

CREATE TABLE tabela_a (
    id_a INT PRIMARY KEY AUTO_INCREMENT,
    campo_a1 VARCHAR(100) NOT NULL,
    campo_a2 VARCHAR(150) UNIQUE,
    campo_a3 DATE
);

-- ------------------------------------------------------------
-- TABELA 2 — independente
-- ------------------------------------------------------------

CREATE TABLE tabela_b (
    id_b INT PRIMARY KEY AUTO_INCREMENT,
    campo_b1 VARCHAR(100) NOT NULL,
    campo_b2 DECIMAL(10,2) NOT NULL,
    campo_b3 BOOLEAN NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- TABELA 3 — relacionada à tabela_a
-- ------------------------------------------------------------

CREATE TABLE tabela_c (
    id_c INT PRIMARY KEY AUTO_INCREMENT,
    id_a INT NOT NULL,
    campo_c1 DATE NOT NULL,

    CONSTRAINT fk_tabela_c_tabela_a
        FOREIGN KEY (id_a)
        REFERENCES tabela_a(id_a)
);

-- ------------------------------------------------------------
-- TABELA 4 — exemplo de tabela associativa
-- ------------------------------------------------------------

CREATE TABLE tabela_d (
    id_c INT NOT NULL,
    id_b INT NOT NULL,
    quantidade INT NOT NULL,

    PRIMARY KEY (id_c, id_b),

    CONSTRAINT fk_tabela_d_tabela_c
        FOREIGN KEY (id_c)
        REFERENCES tabela_c(id_c),

    CONSTRAINT fk_tabela_d_tabela_b
        FOREIGN KEY (id_b)
        REFERENCES tabela_b(id_b)
);

-- ------------------------------------------------------------
-- ALTER TABLE
-- ------------------------------------------------------------

ALTER TABLE tabela_a
ADD COLUMN campo_novo VARCHAR(100);

-- ------------------------------------------------------------
-- TABELA TEMPORÁRIA PARA PRATICAR DROP TABLE
-- ------------------------------------------------------------

CREATE TABLE tabela_teste (
    id_teste INT PRIMARY KEY
);

DROP TABLE tabela_teste;
```

---

# 16. Como executar o código no MySQL Workbench

## Executar apenas um comando

1. Posicione o cursor dentro do comando.
2. Clique no ícone do raio de execução.
3. Observe o painel **Output**.

Exemplo:

```sql
CREATE DATABASE meu_banco;
```

Execute e verifique se aparece uma mensagem de sucesso.

---

## Executar vários comandos

Selecione o trecho desejado e utilize o botão de execução.

Também é possível executar o script inteiro.

Durante o desenvolvimento, é recomendado executar **por etapas**:

```text
1. CREATE DATABASE
2. USE
3. primeira tabela
4. segunda tabela
5. tabelas dependentes
6. ALTER TABLE
7. testes
```

Assim fica mais fácil identificar a origem de um erro.

---

# 17. Atualizar a lista de Schemas

Depois de criar o banco:

1. vá até o painel **Schemas**;
2. clique no botão de atualizar;
3. localize o banco criado;
4. expanda o banco;
5. expanda **Tables**;
6. confirme se as tabelas aparecem.

---

# 18. Validar cada tabela

Utilize:

```sql
DESCRIBE nome_tabela;
```

Exemplo:

```sql
DESCRIBE cliente;
```

Faça isso para cada tabela criada.

## Validações realizadas

| Tabela | `DESCRIBE` executado? | Estrutura correta? |
|---|---|---|
| FILIAL | Não consta no script final | Não validado por `DESCRIBE` no arquivo |
| CARGO | Não consta no script final | Não validado por `DESCRIBE` no arquivo |
| PRODUTO | Não consta no script final | Não validado por `DESCRIBE` no arquivo |
| SETOR | Não consta no script final | Não validado por `DESCRIBE` no arquivo |
| FUNCIONARIO | Não consta no script final | Não validado por `DESCRIBE` no arquivo |
| EXPEDIENTE | Não consta `DESCRIBE`, mas foi utilizado `SHOW CREATE TABLE` | Estrutura consultada pelo `SHOW CREATE TABLE` |
| ESTOQUE | Sim | Estrutura consultada pelo `DESCRIBE ESTOQUE` |

---

# 19. Visualizar o CREATE TABLE gerado pelo MySQL

Utilize:

```sql
SHOW CREATE TABLE nome_tabela;
```

Exemplo:

```sql
SHOW CREATE TABLE pedido;
```

Esse comando ajuda a verificar:

- `PRIMARY KEY`;
- `FOREIGN KEY`;
- `UNIQUE`;
- nomes de constraints;
- estrutura final da tabela.

## Validação utilizada no projeto

```sql
SHOW CREATE TABLE EXPEDIENTE;
```

> O comando foi utilizado para visualizar a estrutura final da tabela `EXPEDIENTE`.

---

# 20. Erros comuns e como verificar

## Erro: banco já existe

Pode ocorrer com:

```sql
CREATE DATABASE nome_do_banco;
```

Durante testes, você pode utilizar:

```sql
CREATE DATABASE IF NOT EXISTS nome_do_banco;
```

---

## Erro: tabela já existe

Pode ocorrer ao executar novamente:

```sql
CREATE TABLE cliente (...);
```

Durante os testes, você poderá excluir o banco de testes e criá-lo novamente, ou utilizar estratégias indicadas pelo professor.

Não adicione comandos destrutivos sem compreender o que eles fazem.

---

## Erro de FOREIGN KEY

Verifique:

1. a tabela pai já foi criada?
2. a coluna referenciada existe?
3. a coluna referenciada é chave?
4. os tipos das colunas são compatíveis?
5. os nomes estão escritos corretamente?

---

## Erro de sintaxe

Verifique:

- vírgulas;
- parênteses;
- ponto e vírgula;
- nomes de colunas;
- nomes de tabelas;
- palavras reservadas.

---

# 21. Registro de problemas encontrados

| Problema | Causa identificada | Como foi resolvido |
|---|---|---|
| Necessidade de executar novamente o script durante os testes | O banco já poderia existir de uma execução anterior | Foi utilizado `DROP DATABASE IF EXISTS Rh_sorveteria` antes da criação do banco. |
| Nome do campo CPF pouco específico | A coluna havia sido criada inicialmente apenas como `cpf` | Foi utilizado `ALTER TABLE` para renomear a coluna para `cpf_func`. |

> Após os ajustes presentes no script final, não ficou registrado outro problema de execução.

---

# 21.1. Estrutura implementada no projeto

O banco final desta Sprint possui as seguintes relações principais:

```text
CARGO 1 ───── N FUNCIONARIO
SETOR 1 ───── N FUNCIONARIO
FILIAL 1 ───── N FUNCIONARIO
FUNCIONARIO 1 ───── N EXPEDIENTE

FILIAL 1 ───── N ESTOQUE N ───── 1 PRODUTO
```

A tabela `ESTOQUE` funciona como tabela associativa entre `FILIAL` e `PRODUTO`.

---

# 22. Script final

Depois de testar cada parte, organize o código definitivo no arquivo:

```text
SPRINT2-5.sql
```

Esse arquivo deverá conter **somente o SQL necessário para criar a estrutura final do projeto e os exercícios exigidos nesta Sprint**.

O arquivo deverá estar organizado, indentado e comentado.

Sugestão de organização:

```sql
-- Identificação
-- Banco
-- Tabelas independentes
-- Tabelas relacionadas
-- Tabelas associativas
-- ALTER TABLE
-- Exercício de DROP TABLE
-- Comandos de validação
```

---

# 23. Como salvar no MySQL Workbench

Depois de finalizar o código:

1. clique em `File`;
2. escolha `Save Script As...`;
3. selecione a pasta do projeto;
4. utilize exatamente o nome:

```text
SPRINT2-5.sql
```

5. confirme o salvamento.

> Não salve apenas uma captura de tela. O arquivo `.sql` deverá ser entregue junto com o `.md`.

---

# 24. O que deve existir ao final desta Sprint

Ao concluir a Sprint 2/5, sua pasta deverá possuir:

```text
SPRINT1-5.md
SPRINT2-5.md
SPRINT2-5.sql
```

Nas próximas Sprints, novos arquivos serão adicionados.

A estrutura final esperada será semelhante a:

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

> A organização das Sprints futuras poderá ser ajustada pelo professor conforme o andamento da disciplina.

---

# 25. Checklist técnico da Sprint 2/5

Antes de finalizar:

- [x] utilizei como base a `SPRINT1-5.md`;
- [x] criei um banco de dados;
- [x] utilizei `USE`;
- [x] criei pelo menos 4 tabelas relacionadas;
- [x] todas as tabelas possuem chave primária;
- [x] utilizei tipos de dados coerentes;
- [x] apliquei `NOT NULL` quando necessário;
- [x] apliquei `UNIQUE` quando necessário;
- [x] apliquei `DEFAULT` quando necessário;
- [x] implementei as chaves estrangeiras necessárias;
- [x] respeitei a ordem de criação das tabelas;
- [x] tratei corretamente relacionamentos N:N;
- [x] executei pelo menos um `ALTER TABLE`;
- [x] pratiquei `DROP TABLE` em tabela temporária;
- [X] executei `DESCRIBE` em todas as tabelas
- [ ] verifiquei as tabelas no painel Schemas
- [x] corrigi ajustes estruturais registrados no script;
- [x] organizei o script final;
- [x] possuo o arquivo SQL da Sprint 2;
- [x] preenchi completamente este `SPRINT2-5.md`.

---

# 26. Regras de Git/GitHub

A atividade é **individual**.

Continue utilizando a mesma branch individual iniciada na Sprint 1/5.

Não crie uma nova branch somente para esta Sprint.

---

## Arquivos que devem entrar no commit de hoje

O commit da Sprint 2/5 deverá incluir obrigatoriamente:

```text
SPRINT2-5.md
SPRINT2-5.sql
```

Antes do commit, confirme que ambos estão salvos.

---

## Commit

Mensagem sugerida:

```text
Conclui Sprint 2 de 5 - estrutura DDL
```

O objetivo é manter o histórico da construção do banco ao longo dos dias.

---

## Pull Request

**Não abrir o Pull Request final hoje.**

Os arquivos devem ser acumulados na mesma branch até a conclusão da Sprint 5/5.

Fluxo:

```text
SPRINT1-5.md
      ↓ commit

SPRINT2-5.md + SPRINT2-5.sql
      ↓ commit

SPRINT3-5...
      ↓

SPRINT4-5...
      ↓

SPRINT5-5...
      ↓

PULL REQUEST FINAL
      ↓
main
```

Quando chegar o momento do PR, o repositório deverá conter todos os arquivos exigidos nas cinco etapas.

---

# 27. Entrega da Sprint 2/5

A Sprint 2/5 somente será considerada concluída quando:

1. o banco tiver sido criado no MySQL;
2. as tabelas estiverem implementadas;
3. os relacionamentos necessários estiverem implementados;
4. o script tiver sido executado e testado;
5. o arquivo `SPRINT2-5.md` estiver preenchido;
6. o arquivo `SPRINT2-5.sql` contiver o código desenvolvido;
7. os dois arquivos estiverem incluídos no commit da Sprint 2/5.

---

# Próxima etapa

Na **Sprint 3/5**, o banco criado nesta etapa será populado e manipulado utilizando:

```sql
INSERT
UPDATE
DELETE
```

A Sprint 3/5 deverá reutilizar a estrutura criada no arquivo `SPRINT2-5.sql`.

> Não desenvolva a Sprint 3/5 neste arquivo.
