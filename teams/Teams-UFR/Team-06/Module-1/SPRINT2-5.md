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
CREATE DATABASE IF NOT EXISTS locacao_de_filmes;

USE locacao_de_filmes;

```

## Nome definitivo do banco

```text
locacao_de_filmes
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
| 1 | cliente | Armazenar os dados dos clientes da locadora. |
| 2 | funcionario | Armazenar os dados dos funcionários da locadora. |
| 3 | genero | Armazenar os gêneros dos filmes. |
| 4 | filme | Armazenar os dados dos filmes disponíveis no catálogo. |
| 5 | locacao | Registrar as locações realizadas pelos clientes e os funcionários responsáveis. |
| 6 | item_locacao | Registrar os filmes pertencentes a cada locação. |

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

1. cliente
2. funcionario
3. genero
4. filme
5. locaco
6. item_locacao

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
| cliente | id_cliente | Sim |
| funcionario | id_funcionario | Sim |
| genero | id_genero | Sim |
| filme | id_filme | Sim |
| locacao | id_locacao | Sim |
| item_locacao | id_item | Sim |

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
| cliente | nome | Todo cliente precisa possuir um nome cadastrado. |
| cliente | cpf | O CPF identifica o cliente e é necessário para o cadastro. |
| funcionario | nome | Todo funcionário precisa possuir um nome cadastrado. |
| funcionario | cpf | O CPF é utilizado para identificar o funcionário. |
| funcionario | cargo | É necessário informar a função do funcionário na locadora. |
| genero | nome | Todo gênero precisa possuir um nome. |
| filme | titulo | Todo filme precisa possuir um título. |
| filme | ano_lancamento | É necessário informar o ano de lançamento do filme. |
| filme | diretor | O diretor faz parte das informações principais do filme. |
| filme | id_genero | Todo filme deve estar associado a um gênero existente. |
| locacao | id_cliente | Toda locação deve estar associada a um cliente. |
| locacao | id_funcionario | Toda locação deve estar associada a um funcionário. |
| item_locacao | id_locacao | Todo item deve pertencer a uma locação. |
| item_locacao | id_filme | Todo item deve estar associado a um filme. |
| item_locacao | valor_diaria | O valor diária é necessário para registrar o item da locação. |

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
| cliente | cpf | O CPF deve identificar um único cliente. |
| funcionario | cpf | O CPF deve identificar um único funcionário. |
| genero | nome | Evita o cadastro de gêneros com o mesmo nome. |
| item_locacao | id_locacao, id_filme | Evita que o mesmo filme seja registrado duas vezes na mesma locação. |

Caso nenhuma seja necessária, justifique:

> Escreva aqui.

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
| cliente | ativo | TRUE | Novos clientes são considerados ativos por padrão. |
| genero | ativo | TRUE | Novos gêneros são considerados ativos por padrão. |
| locacao | data_locacao | CURRENT_DATE | A data da locação é preenchida automaticamente com a data atual. |

Caso não utilize `DEFAULT`, justifique:

> Escreva aqui.

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
| filme | id_genero | genero(id_genero) | Um gênero possui vários filmes. |
| locacao | id_cliente | cliente(id_cliente) | Um cliente pode realizar várias locações. |
| locacao | id_funcionario | funcionario(id_funcionario) | Um funcionário pode registrar várias locações. |
| item_locacao | id_locacao | locacao(id_locacao) | Uma locação pode possuir vários items. |
| item_locacao | id_filme | filme(id_filme) | Um filme pode aparecer em várias locações. |

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

- [X] Sim
- [ ] Não

Se sim, explique como foi implementado:

> O banco possui um relacionamento muitos-para-muitos entre locacao e filme. Uma locação pode conter vários filmes e um mesmo filme pode aparecer em várias locações ao longo do tempo. Para representar esse relacionamente, foi criada a tabela associativa intem_locacao, que possui as chaves estrangeiras id_locacao e id_filme. A estrutura fica: LOCAÇÃO 1 ───── N ITEM_LOCAÇÃO N ───── 1 FILME. Dessa forma, item_locacao funciona como tabela associativa entre locacao e filme.

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
ALTER TABLE filme
MODIFY COLUMN titulo VARCHAR(150) NOT NULL;

```

### Explique a alteração

> O comando ALTER TABLE foi utilizado para modificar a estrutura da tabela filme, ajustando o tamanho máximo do atributo titulo para 150 caracteres. A alteração foi realizada para manter o campo de acordo com o planejamento definido na Sprint 1/5.

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
    id_teste INT PRIMARY KEY
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

> DELETE FROM tabela remove os registros armazenados em um tabela, mas mantém a estrutura da tabela no banco de dados. Enquanto que DROP TABLE tabela remove a tabela inteira, incluindo sua estrutura e seus registros. Por esse motivo, o DROP TABLE foi executado em uma tabela de teste criada para o exercício controlado.

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

CREATE DATABASE locacao_de_filmes;

USE locacao_de_filmes;

-- ------------------------------------------------------------
-- TABELA 1 — independente
-- ------------------------------------------------------------

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),

    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- TABELA 2 — independente
-- ------------------------------------------------------------

CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    telefone VARCHAR(20)
);

-- ------------------------------------------------------------
-- TABELA 3 — independente
-- ------------------------------------------------------------

CREATE TABLE genero (
    id_genero INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(200),
    classificado VARCHAR(50),

    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ------------------------------------------------------------
-- TABELA 4 — relacionada à genero
-- ------------------------------------------------------------

CREATE TABLE filme (
    id_filme INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    ano_lancamento YEAR NOT NULL,
    avaliacao DECIMAL(3,1),
    diretor VARCHAR(100) NOT NULL,
    id_genero INT NOT NULL,

    CONSTRAINT fk_filme_genero
        FOREIGN KEY (id_genero)
        REFERENCES genero(id_genero)
);

-- ------------------------------------------------------------
-- TABELA 5 — tabela associativa
-- ------------------------------------------------------------

CREATE TABLE locacao (
    id_locacao INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    data_locacao DATE NOT NULL DEFAULT (CURRENT_DATE),
    data_devolucao DATE,

    CONSTRAINT fk_locacao_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_locacao_funcionario
        FOREIGN KEY (id_funcionario)
        REFERENCES funcionario(id_funcionario)
);

-- ------------------------------------------------------------
-- TABELA 6 — tabela associativa
-- ------------------------------------------------------------

CREATE TABLE item_locacao (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_locacao INT NOT NULL,
    id_filme INT NOT NULL,
    valor_diaria DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_item_locacao
        FOREIGN KEY (id_locacao)
        REFERENCES locacao(id_locacao),

    CONSTRAINT fk_item_filme
        FOREIGN KEY (id_filme)
        REFERENCES filme(id_filme),

    CONSTRAINT uq_item_locacao_filme
        UNIQUE (id_locacao,id_filme)
);

-- ------------------------------------------------------------
-- ALTER TABLE
-- ------------------------------------------------------------

ALTER TABLE filme
MODIFY COLUMN titulo VARCHAR(150) NOT NULL;

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
| cliente | Sim | Sim |
| funcionario | Sim | Sim |
| genero | Sim | Sim |
| filme | Sim | Sim |
| locacao | Sim | Sim |
| item_locacao | Sim | Sim |

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
| filme possuía id_genero, mas não havia relacionamento implementado | A FK ainda não havia sido criada | fk_filme_genero |
| A tabela filme aparecia antes de genero | A ordem de criacao não respeitava a dependência da FK | genero passou a ser criada antes de filme. |
| Alguns problemas de atributos possuíam erros de digitação | Erros nos nomes ano_lacamento e classifcado | Os atributos foram corrigidos para ano_lancamento e classificado. |

Caso não encontre problemas:

> Nenhum problema identificado após a execução final.

---

# 22. Script final

Depois de testar cada parte, organize o código definitivo no arquivo:

```text
SPRINT2-5.sql
```

Esse arquivo deverá conter **somente o SQL necessário para criar a estrutura final do projeto e os exercícios exigidos nesta Sprint**.

O arquivo deverá estar organizado, indentificado e comentado.

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

- [ ] utilizei como base a `SPRINT1-5.md`;
- [ ] criei um banco de dados;
- [ ] utilizei `USE`;
- [ ] criei pelo menos 4 tabelas relacionadas;
- [ ] todas as tabelas possuem chave primária;
- [ ] utilizei tipos de dados coerentes;
- [ ] apliquei `NOT NULL` quando necessário;
- [ ] apliquei `UNIQUE` quando necessário;
- [ ] apliquei `DEFAULT` quando necessário;
- [ ] implementei as chaves estrangeiras necessárias;
- [ ] respeitei a ordem de criação das tabelas;
- [ ] tratei corretamente relacionamentos N:N, caso existam;
- [ ] executei pelo menos um `ALTER TABLE`;
- [ ] pratiquei `DROP TABLE` em tabela temporária;
- [ ] executei `DESCRIBE` nas tabelas;
- [ ] verifiquei as tabelas no painel Schemas;
- [ ] corrigi erros de execução;
- [ ] organizei o script final;
- [ ] salvei o script como `SPRINT2-5.sql`;
- [ ] preenchi completamente este `SPRINT2-5.md`.

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
