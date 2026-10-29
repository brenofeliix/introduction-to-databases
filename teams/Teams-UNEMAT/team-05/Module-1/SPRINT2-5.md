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
-- Copie aqui o código utilizado.
CREATE DATABASE Clinica_Ser;
USE Clinica_Ser;

-- Tabela Paciente
CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(15),
    sexo ENUM('M','F') NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    imagem VARCHAR(255)
);

-- Tabela Médico
CREATE TABLE Medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    especialidade VARCHAR(50)
);

-- Tabela Convênio
CREATE TABLE Convenio (
    id_convenio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Paciente vinculado a Convênio (1:1)
ALTER TABLE Paciente
ADD COLUMN id_convenio INT UNIQUE,
ADD CONSTRAINT fk_paciente_convenio FOREIGN KEY (id_convenio) REFERENCES Convenio(id_convenio);

-- Tabela Exame
CREATE TABLE Exame (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0)
);

-- Tabela Agendamento
CREATE TABLE Agendamento (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    data_agendamento DATETIME NOT NULL,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_exame INT NOT NULL,
    CONSTRAINT fk_agendamento_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    CONSTRAINT fk_agendamento_medico FOREIGN KEY (id_medico) REFERENCES Medico(id_medico),
    CONSTRAINT fk_agendamento_exame FOREIGN KEY (id_exame) REFERENCES Exame(id_exame)
);

-- Tabela Resultado
CREATE TABLE Resultado (
    id_resultado INT AUTO_INCREMENT PRIMARY KEY,
    laudo_pdf VARCHAR(255) NOT NULL,
    id_exame INT NOT NULL,
    CONSTRAINT fk_resultado_exame FOREIGN KEY (id_exame) REFERENCES Exame(id_exame)
);

```

## Nome definitivo do banco

```text

```Clinica Ser

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
| 1 |Paciente|Armazena dados pessoais dos pacientes (nome, CPF, telefone, data de nascimento, sexo, imagem)|
| 2 |Medico|Registra informações dos médicos (nome, CRO, especialidade)|
| 3 |Convenio|Lista os convênios disponíveis e vincula cada paciente a apenas um convênio|
| 4 |Exame|Define os tipos de exames realizados, com preço e descrição|
| 5 |Agendamento|Controla os agendamentos, vinculando paciente, médico e exame em uma data/hora específica|
| 6 |Resultado|Armazena os laudos em PDF e vincula cada resultado a um exame realizado|

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

1. Paciente
2. Medico
3. Convenio
4. Exame
5. Agendamento
6. Resultado

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
|Paciente|id_paciente|Sim|
|Medico|id_medico|Sim|
|Convenio|id_convenio|Sim|
|Exame|id_exame|Sim|
|Agendamento|id_agendamento|Sim|
|Resultado|id_resultado|Sim|

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

Paciente	nome_completo	Identificação essencial do paciente
Paciente	data_nascimento	Necessário para cadastro clínico
Paciente	sexo	Informação obrigatória para ficha médica
Paciente	cpf	Documento único de identificação
Medico	nome_completo	Identificação essencial do médico
Medico	crm	Registro profissional obrigatório
Exame	tipo	Identificação do exame
Exame	preco	Valor do exame não pode ser nulo
Agendamento	data_agendamento	Sem data não há agendamento
Resultado	laudo_pdf	Resultado precisa estar vinculado a um arquivo

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
|Paciente|cpf|Cada paciente deve ter apenas um CPF|
|Medico|cro|Cada médico possui um CRO único|
|Paciente|id_convenio|Um paciente só pode ter um convenio por vez|

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
|Exame|preco|DEFAULT 0.00|Evita valores nulos, mas permite atualização posterior|
|Paciente|imagem|DEFAULT NULL|Nem todo paciente terá imagem cadastrada|
|Resultado|laudo_pdf|DEFAULT NULL|Permite criar exame antes de anexar laudo|

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
|Paciente|id_convenio|Convenio(id_convenio)|Paciente possui convenio|
|Agendamento|id_paciente|Paciente(id_paciente)|Paciente realiza agendamento|
|Agendamento|id_medico|Medico(id_medico)|Medico solicita agendamento|
|Agendamento|id_exame|Exame(id_exame)|Agendamento refere-se a exame|
|Resultado|id_exame|Exame(id_exame)|Resultado vinculado a exame|
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

- [ ] Sim
- [x] Não

Se sim, explique como foi implementado:

> Escreva aqui.

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
-- Cole aqui o comando executado.
ALTER TABLE Paciente
MODIFY COLUMN telefone VARCHAR(20);

```

### Explique a alteração

> Escreva aqui.
ALTER TABLE Paciente → indica que vamos alterar a tabela Paciente.

MODIFY COLUMN telefone VARCHAR(20) → muda o tipo do campo telefone para aceitar até 20 caracteres (antes estava com 15).

Isso é uma alteração estrutural válida e prática, pois reflete uma necessidade real: armazenar números de telefone mais completos.
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
-- Cole aqui o teste realizado.
CREATE TABLE tabela_teste (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100)
);

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

> Responda aqui.
DELETE FROM apaga todos os pacientes cadastrados, mas a tabela Paciente continua disponivel.
DROP TABLE apaga completamente a tabela Paciente do banco.
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
| Tabela | ``DESCRIBE`` executado? | Estrutura correta? |
| --- | --- | --- |
| **[Paciente](ca://s?q=Validar_tabela_Paciente)** | Sim | Deve mostrar ``id_paciente`` como PK, ``cpf`` com UNIQUE, campos obrigatórios com ``NOT ``NULL``. |
| **[Medico](ca://s?q=Validar_tabela_Medico)** | Sim | Deve mostrar ``id_medico`` como PK, ``crm`` com UNIQUE, ``nome_completo`` obrigatório. |
| **[Convenio](ca://s?q=Validar_tabela_Convenio)** | Sim | Deve mostrar ``id_convenio`` como PK e ``nome`` obrigatório. |
| **[Exame](ca://s?q=Validar_tabela_Exame)** | Sim | Deve mostrar ``id_exame`` como PK, ``preco`` com ``CHECK ``(>=0)``, ``tipo`` obrigatório. |
| **[Agendamento](ca://s?q=Validar_tabela_Agendamento)** | Sim | Deve mostrar ``id_agendamento`` como PK, FKs para ``Paciente``, ``Medico`` e ``Exame``. |
| **[Resultado](ca://s?q=Validar_tabela_Resultado)** | Sim | Deve mostrar ``id_resultado`` como PK e FK para ``Exame``. |
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
| Problema | Causa identificada | Como foi resolvido |
| --- | --- | --- |
| Erro ao criar banco ``Clinica_Ser`` | O banco já existia, e o comando ``CREATE ``DATABASE`` não permite duplicidade | Utilizar ``CREATE ``DATABASE ``IF ``NOT ``EXISTS ``Clinica_Ser;`` ou remover o banco antigo com ``DROP ``DATABASE ``Clinica_Ser;`` antes de recriar |
| Erro ao criar tabela ``Paciente`` | A tabela já existia no banco, e ``CREATE ``TABLE`` não permite recriação sem exclusão | Usar ``CREATE ``TABLE ``IF ``NOT ``EXISTS ``Paciente ``(...);`` ou executar ``DROP ``TABLE ``Paciente;`` antes de recriar |
| Erro de FOREIGN KEY em tabelas dependentes | A tabela pai não havia sido criada antes da tabela filha, ou o campo referenciado não era chave primária | Ajustar a **ordem de criação** das tabelas e garantir que o campo referenciado seja ``PRIMARY ``KEY`` |
| Erro de sintaxe em comandos SQL | Faltavam vírgulas, ponto e vírgula, ou nomes estavam inconsistentes | Revisar cada comando, conferindo vírgulas entre colunas, fechamento de parênteses e nomes corretos de tabelas/colunas |

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

- [V] utilizei como base a `SPRINT1-5.md`;
- [V] criei um banco de dados;
- [V] utilizei `USE`;
- [V] criei pelo menos 4 tabelas relacionadas;
- [V] todas as tabelas possuem chave primária;
- [V] utilizei tipos de dados coerentes;
- [V] apliquei `NOT NULL` quando necessário;
- [V] apliquei `UNIQUE` quando necessário;
- [V] apliquei `DEFAULT` quando necessário;
- [V] implementei as chaves estrangeiras necessárias;
- [V] respeitei a ordem de criação das tabelas;
- [V] tratei corretamente relacionamentos N:N, caso existam;
- [V] executei pelo menos um `ALTER TABLE`;
- [V] pratiquei `DROP TABLE` em tabela temporária;
- [V] executei `DESCRIBE` nas tabelas;
- [V] verifiquei as tabelas no painel Schemas;
- [V] corrigi erros de execução;
- [V] organizei o script final;
- [V] salvei o script como `SPRINT2-5.sql`;
- [V] preenchi completamente este `SPRINT2-5.md`.

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
