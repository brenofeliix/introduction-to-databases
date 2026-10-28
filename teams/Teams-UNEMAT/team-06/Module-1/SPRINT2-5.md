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
CREATE DATABASE IF NOT EXISTS db_conveniencia;
USE db_conveniencia;
  
CREATE TABLE Categoria(
id_categoria INT PRIMARY KEY auto_increment,
nome_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE Produto(
id_produto INT PRIMARY KEY auto_increment,
id_categoria INT,
codigo_barras VARCHAR(50) UNIQUE,
nome_produto VARCHAR(100) NOT NULL,
preco_venda DECIMAL(10,2) CHECK (preco_venda >= 0),
quantidade_estoque INT CHECK (quantidade_estoque >=0),
FOREIGN KEY (id_categoria) references Categoria(id_categoria)
);

CREATE TABLE Venda(
id_venda INT auto_increment PRIMARY KEY,
data_venda DATETIME DEFAULT current_timestamp,
valor_total DECIMAL(10,2)
);

CREATE TABLE Item_venda(
quantidade int,
id_venda INT,
id_produto int,
PRIMARY KEY (id_venda, id_produto),
FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

```

## Nome definitivo do banco

```text

```
db_conveniencia
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
| 1 | Categoria | Armezenar o Nome da categoria e também o ID da categoria |
| 2 | Produto | Armazenar o Id do produto, Id da categoria o codigo de barras, o nome do produto, a quantidade do estoque e o preco da venda |
| 3 | Venda | Vai guardar o ID da venda, a data da venda e o Valor total da venda |
| 4 | Item_venda | vai Armazenar a quantidade de itens, o id da venda e o id do produto |
| 5 |  |  |
| 6 |  |  |

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

1. Categoria
2. Produto
3. Venda
4. Item_venda
5. 
6. 

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
| Categoria | id_categoria | Sim |
| Produto | id_produto | Sim |
| Venda | id_venda | Sim |
|  |  |  |

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
| Categoria | nome_categoria | Pelo fato de carregar o nome da categoria, isso e importante pra idetificação |
| Produto | nome_produto | Mesma razão do nome da categoria, por carregar o nome do produto e é importante pra identifição |
|  |  |  |

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
| Produto | codigo_barras | por ser um codigo unico destinado ao produto pelo fornecedor |
|  |  |  |

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
| Venda | data_venda | DATETIME DEFAULT | Ele vai pegar o horario atual do computador, então usar default eu já deixo claro que ele sempre vai tentar pegar o horario padrão da maquina |
|  |  |  |  |

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
| Produto |FOREIGN KEY (id_categoria)| references Categoria(id_categoria) | 1:N Uma categoria possui varios produtos |
| item_venda | FOREIGN KEY (id_venda) | REFERENCES Venda(id_venda) | 1:N uma venda pode conter varios itens |
| item_venda | FOREIGN KEY (id_produto) | REFERENCES Produto(id_produto) | 1:N um produto aparece em varias vendas |

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

> Teoricamente o relacionamento N:N seria da bomba da venda pro produto, mas deu pra resolver isso criando a tabela item_venda pra não precisar ficar se preocupando com isso

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
ALTER TABLE categoria 
ADD COLUMN meu_pedido VARCHAR(100);

```

### Explique a alteração

> Fiz essa mudança rapida para demonstrar que meu comando foi executado com clareza no ALTER TABLE, mas que por enquanto no comando final ele não vai existir por não ter necessidade

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
DROP TABLE item_venda;
19:51:18	DROP TABLE item_venda	0 row(s) affected	0.016 sec

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

> O DELETE FROM você tá tentando arrancar algum parametro que existe na tabela que você está entrando, agora no DROP TABLE você está arrancando totalmente a tabela e todos os seus parametros, então tem essa diferença: Num você vai tirar apenas um parametro e no outro você vai tirar a tabela toda.

---

# 15. Estrutura genérica completa para adaptar

O modelo abaixo serve apenas como referência estrutural.

**Não entregue o código exatamente como está.**

Adapte tudo ao tema escolhido na Sprint 1/5.

```sql
-- ============================================================
-- SPRINT 2/5
-- MODELO Vendas e Produtos (Loja de Conveniência).
-- ============================================================

CREATE DATABASE db_conveniencia;

USE db_conveniencia;

-- ------------------------------------------------------------
-- TABELA 1 — Categoria
-- ------------------------------------------------------------

CREATE TABLE Categoria (
     id_categoria INT PRIMARY KEY auto_increment,
    nome_categoria VARCHAR(50) NOT NULL
);

-- ------------------------------------------------------------
-- TABELA 2 — Produto
-- ------------------------------------------------------------

CREATE TABLE Produto (
      id_produto INT PRIMARY KEY auto_increment,
      id_categoria INT,
      codigo_barras VARCHAR(50) UNIQUE,
      nome_produto VARCHAR(100) NOT NULL,
      preco_venda DECIMAL(10,2) CHECK (preco_venda >= 0),
      quantidade_estoque INT CHECK (quantidade_estoque >=0),
      FOREIGN KEY (id_categoria) references Categoria(id_categoria)
);

-- ------------------------------------------------------------
-- TABELA 3 — Venda
-- ------------------------------------------------------------
   CREATE TABLE Venda(
    id_venda INT auto_increment PRIMARY KEY,
    data_venda DATETIME DEFAULT current_timestamp,
    valor_total DECIMAL(10,2)
);

-- ------------------------------------------------------------
-- TABELA 4 — Item_venda
-- ------------------------------------------------------------
      CREATE TABLE Item_venda(
      quantidade int,
      id_venda INT,
      id_produto int,
      PRIMARY KEY (id_venda, id_produto),
      FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
      FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- ------------------------------------------------------------
-- ALTER TABLE
-- ------------------------------------------------------------

ALTER TABLE categoria 
ADD COLUMN meu_pedido VARCHAR(100);

-- ------------------------------------------------------------
-- TABELA TEMPORÁRIA PARA PRATICAR DROP TABLE
-- ------------------------------------------------------------

CREATE TABLE meus_pedidos (
    id_meus INT PRIMARY KEY
);

DROP TABLE meus_pedidos;

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
| Categoria | Sim | Sim |
| Produto | Sim | Sim |
| Venda | Sim | Sim |
| Item_venda | Sim | Sim |

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
|  |  |  |
|  |  |  |
|  |  |  |

Caso não encontre problemas:

> Nenhum problema identificado após a execução final.

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

- [X] utilizei como base a `SPRINT1-5.md`;
- [X] criei um banco de dados;
- [X] utilizei `USE`;
- [X] criei pelo menos 4 tabelas relacionadas;
- [X] todas as tabelas possuem chave primária;
- [x] utilizei tipos de dados coerentes;
- [x] apliquei `NOT NULL` quando necessário;
- [x] apliquei `UNIQUE` quando necessário;
- [x] apliquei `DEFAULT` quando necessário;
- [x] implementei as chaves estrangeiras necessárias;
- [x] respeitei a ordem de criação das tabelas;
- [x] tratei corretamente relacionamentos N:N, caso existam;
- [x] executei pelo menos um `ALTER TABLE`;
- [x] pratiquei `DROP TABLE` em tabela temporária;
- [x] executei `DESCRIBE` nas tabelas;
- [x] verifiquei as tabelas no painel Schemas;
- [x] corrigi erros de execução;
- [x] organizei o script final;
- [x] salvei o script como `SPRINT2-5.sql`;
- [X] preenchi completamente este `SPRINT2-5.md`.

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
