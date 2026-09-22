# SPRINT 2/5 — Implementação da Estrutura do Banco de Dados com DDL

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual / Equipe  
**Aluna:** Célia Hiromi Watanabe (Team 03)  
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

- tema escolhido: Sistema de Gestão de Salão de Beleza (`db_salao_beleza`);
- entidades: `cliente`, `profissional`, `servico`, `agendamento`;
- atributos e tipos de dados;
- chaves primárias e relacionamentos (1:N);
- restrições de integridade (`NOT NULL`, `UNIQUE`, `DEFAULT`, `FOREIGN KEY`).

A Sprint 2/5 é a implementação em SQL de todo o planejamento arquitetado na Sprint 1/5.

---

# 2. Passo a passo no MySQL Workbench

## Passo 1 — Abrir o MySQL Workbench

1. Abra o **MySQL Workbench**.
2. Na tela inicial, localize sua conexão MySQL.
3. Clique na conexão.
4. Informe a senha, caso seja solicitado (`S@lmos23`).
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

Abra o arquivo `SPRINT2-5.sql` da pasta da equipe:
`teams/Teams-UNEMAT/team-03/SPRINT2-5.sql`

O script já está configurado com todas as entidades, chaves primárias, chaves estrangeiras, restrições e validações do tema do salão de beleza.

---

# 3. Criando o banco de dados

Todo projeto deverá possuir um banco de dados próprio.

## Código utilizado no seu projeto

```sql
CREATE DATABASE IF NOT EXISTS db_salao_beleza;

USE db_salao_beleza;
```

## Nome definitivo do banco

```text
db_salao_beleza
```

---

# 4. Tipos de dados

Escolha tipos coerentes com as informações armazenadas.

### Tipos adotados no projeto:

- `INT`: Utilizado para todas as chaves primárias (`id_cliente`, `id_profissional`, `id_servico`, `id_agendamento`) e estrangeiras, além da duração do serviço em minutos (`duracao_minutos`).
- `VARCHAR(100)`: Adequado para campos de texto de tamanho variável como nomes de pessoas, nome do serviço e e-mail.
- `VARCHAR(14)`: Tamanho exato para armazenamento de CPF com formatação (`000.000.000-00`).
- `VARCHAR(20)`: Suficiente para números de telefone e palavras de status (`Agendado`, `Cancelado`, `Concluído`).
- `VARCHAR(255)`: Utilizado no campo `observacoes` adicionado via `ALTER TABLE` para notas sobre preferências do cliente.
- `DECIMAL(10,2)`: Essencial para valores monetários (`preco` dos serviços), garantindo precisão financeira sem erros de arredondamento de ponto flutuante.
- `DATETIME`: Utilizado para `data_hora` do agendamento, armazenando com exatidão o dia e horário marcado para o atendimento.

---

# 5. Criando as tabelas

Com base na Sprint 1/5, implemente as tabelas do banco.

O projeto possui **4 tabelas relacionadas**:

## Tabelas planejadas

| Nº | Nome da tabela | Finalidade |
|---:|---|---|
| 1 | `cliente` | Armazena dados cadastrais e de contato dos clientes atendidos |
| 2 | `profissional` | Registra os profissionais do salão e suas especialidades de atendimento |
| 3 | `servico` | Catálogo de serviços ofertados com tempo estimado de execução e preço |
| 4 | `agendamento` | Gerencia os atendimentos marcados conectando cliente, profissional e serviço |

---

# 6. Ordem de criação das tabelas

A ordem de criação é fundamental devido às restrições de chave estrangeira (`FOREIGN KEY`).

Regra prática adotada:

```text
1. Criar primeiro as tabelas independentes (tabelas pai);
2. Criar por último as tabelas dependentes que possuem chaves estrangeiras (tabela filha).
```

## Ordem definida para o seu projeto

1. `cliente` (independente — não depende de nenhuma outra tabela)
2. `profissional` (independente — não depende de nenhuma outra tabela)
3. `servico` (independente — não depende de nenhuma outra tabela)
4. `agendamento` (dependente — referencia `cliente`, `profissional` e `servico` como chaves estrangeiras)

---

# 7. PRIMARY KEY

Cada tabela possui uma chave primária simples, inteira e única para identificar univocamente cada registro.

## Chaves primárias implementadas

| Tabela | Chave primária | Utiliza `AUTO_INCREMENT`? |
|---|---|---|
| `cliente` | `id_cliente` | Sim |
| `profissional` | `id_profissional` | Sim |
| `servico` | `id_servico` | Sim |
| `agendamento` | `id_agendamento` | Sim |

---

# 8. NOT NULL

Utilize `NOT NULL` quando a informação for obrigatória pela regra de negócio.

## Campos obrigatórios implementados

| Tabela | Campo | Por que é obrigatório? |
|---|---|---|
| `cliente` | `nome`, `cpf`, `telefone` | O salão precisa obrigatoriamente identificar o cliente e manter canal de contato ativo |
| `profissional` | `nome`, `especialidade`, `telefone` | Necessário para alocar a pessoa certa no agendamento e ter contato interno |
| `servico` | `nome_servico`, `duracao_minutos`, `preco` | O catálogo não pode conter serviço sem identificação, tempo previsto ou preço |
| `agendamento` | `id_cliente`, `id_profissional`, `id_servico`, `data_hora`, `status` | Um agendamento não pode existir sem saber quem será atendido, por quem, o que fará, quando e qual o status |

---

# 9. UNIQUE

Utilize `UNIQUE` quando um valor não puder se repetir no banco de dados.

## Restrições `UNIQUE` implementadas

| Tabela | Campo | Por que não pode se repetir? |
|---|---|---|
| `cliente` | `cpf` | Cada pessoa possui um único CPF no território nacional, impedindo cadastros duplicados do mesmo cliente |

---

# 10. DEFAULT

Utilize `DEFAULT` quando existir um valor padrão coerente ao criar um novo registro.

## Valores padrão utilizados

| Tabela | Campo | DEFAULT | Justificativa |
|---|---|---|---|
| `agendamento` | `status` | `'Agendado'` | Todo novo atendimento registrado no salão entra inicialmente com o status padrão 'Agendado' |

---

# 11. FOREIGN KEY

As chaves estrangeiras garantem a integridade referencial dos dados entre as tabelas.

## Chaves estrangeiras implementadas

| Tabela | Campo FK | Referencia | Relacionamento |
|---|---|---|---|
| `agendamento` | `id_cliente` | `cliente(id_cliente)` | 1:N — Um cliente pode possuir múltiplos agendamentos |
| `agendamento` | `id_profissional` | `profissional(id_profissional)` | 1:N — Um profissional atende múltiplos agendamentos |
| `agendamento` | `id_servico` | `servico(id_servico)` | 1:N — Um tipo de serviço é realizado em múltiplos agendamentos |

---

# 12. Relacionamento N:N

Caso exista um relacionamento muitos-para-muitos (`N:N`), normalmente será necessária uma tabela associativa.

## Seu banco possui relacionamento N:N?

- [ ] Sim
- [x] Não

### Explicação do modelo adotado:

> O modelo do salão de beleza foi estruturado de forma que cada agendamento representa uma prestação de serviço individualizada (1 agendamento = 1 cliente + 1 profissional + 1 serviço contratado em determinado horário). Essa abordagem 1:N garante integridade referencial direta, simplifica o fluxo operacional e viabiliza consultas relacionais precisas nas próximas Sprints sem complexidade desnecessária.

---

# 13. ALTER TABLE

Nesta Sprint, execute pelo menos uma alteração estrutural utilizando `ALTER TABLE`.

## ALTER TABLE utilizado no projeto

```sql
ALTER TABLE agendamento
ADD COLUMN observacoes VARCHAR(255);
```

### Explique a alteração

> O comando `ALTER TABLE` adicionou a nova coluna `observacoes` na tabela `agendamento`. Isso permite que a recepcionista registre informações personalizadas sobre o atendimento (ex.: *"Cliente tem alergia a certos produtos químicos"*, *"Prefere corte na tesoura"*), demonstrando a capacidade de expandir a estrutura do banco sem precisar recriar a tabela.

---

# 14. DROP TABLE — exercício controlado

`DROP TABLE` remove a tabela e toda a sua estrutura de forma permanente.

## Código executado

```sql
CREATE TABLE tabela_teste_exclusao (
    id_teste INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(50)
);

DROP TABLE tabela_teste_exclusao;
```

## Explique a diferença entre DELETE e DROP TABLE

> - **`DELETE FROM tabela;` (DML — Manipulação de Dados):** Exclui apenas as linhas (registros) armazenadas dentro da tabela. A estrutura da tabela (colunas, tipos, chaves, índices) permanece intacta no banco, pronta para receber novos dados.
> - **`DROP TABLE tabela;` (DDL — Definição de Dados):** Exclui completamente a tabela e toda a sua estrutura do schema. A tabela deixa de existir no catálogo do MySQL.

---

# 15. Estrutura genérica completa para adaptar

O projeto foi adaptado integralmente a partir da estrutura de banco relacional recomendada, organizando tabelas independentes, dependentes, constraints e comandos de manipulação estrutural.

---

# 16. Como executar o código no MySQL Workbench

## Executar apenas um comando

1. Posicione o cursor na linha do comando desejado.
2. Clique no ícone do raio com cursor (⚡) ou pressione `Ctrl + Enter`.
3. Verifique a mensagem de sucesso com o ícone verde no painel inferior **Action Output**.

## Executar vários comandos

1. Selecione com o mouse o bloco de comandos que deseja rodar.
2. Clique no ícone do raio (⚡) ou pressione `Ctrl + Shift + Enter`.
3. Para rodar o script completo do início ao fim, certifique-se de que nada esteja selecionado e clique no primeiro raio da barra.

---

# 17. Atualizar a lista de Schemas

Depois de criar o banco:

1. No painel esquerdo **Navigator**, selecione a aba **Schemas**;
2. Clique no botão de atualizar (🔄);
3. Localize o banco **`db_salao_beleza`**;
4. Expanda a seta ao lado do banco e em seguida a pasta **Tables**;
5. Confirme a presença das 4 tabelas: `agendamento`, `cliente`, `profissional` e `servico`.

---

# 18. Validar cada tabela

Utilize o comando `DESCRIBE nome_tabela;` para conferir a especificação de colunas, tipos, chaves primárias e valores default.

## Validações realizadas

| Tabela | `DESCRIBE` executado? | Estrutura correta? |
|---|---|---|
| `cliente` | Sim | Sim, colunas `id_cliente` (PRI, auto_increment), `cpf` (UNI) e campos obrigatórios |
| `profissional` | Sim | Sim, `id_profissional` (PRI), nome, especialidade e contato validados |
| `servico` | Sim | Sim, `id_servico` (PRI), `duracao_minutos` e `preco DECIMAL(10,2)` validados |
| `agendamento` | Sim | Sim, `id_agendamento` (PRI), 3 FKs (MUL), `status DEFAULT 'Agendado'` e coluna `observacoes` |

---

# 19. Visualizar o CREATE TABLE gerado pelo MySQL

O comando `SHOW CREATE TABLE` permite auditar a definição exata gerada pelo MySQL, incluindo nomes automáticos de chaves, constraints e a codificação de caracteres (*character set*).

## Comando executado no projeto

```sql
SHOW CREATE TABLE agendamento;
```

### Análise da saída do MySQL

O comando confirma que o MySQL gerou as constraints relacionais corretamente:
- `CONSTRAINT fk_agendamento_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)`
- `CONSTRAINT fk_agendamento_profissional FOREIGN KEY (id_profissional) REFERENCES profissional (id_profissional)`
- `CONSTRAINT fk_agendamento_servico FOREIGN KEY (id_servico) REFERENCES servico (id_servico)`
- Mecanismo de armazenamento padrão: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4`

---

# 20. Erros comuns e como verificar

- **Banco já existe:** Evitado com o uso de `CREATE DATABASE IF NOT EXISTS db_salao_beleza;`.
- **Erro de FOREIGN KEY:** Prevenido pela ordem rigorosa de criação (tabelas pai `cliente`, `profissional` e `servico` criadas antes da tabela filha `agendamento`).
- **Compatibilidade de tipos:** Todas as chaves estrangeiras em `agendamento` possuem o mesmo tipo `INT` das chaves primárias referenciadas.

---

# 21. Registro de problemas encontrados

| Problema | Causa identificada | Como foi resolvido |
|---|---|---|
| Conexão recusada ao MySQL Workbench | Autenticação padrão via `auth_socket` exigia privilégios sudo | Configurado usuário root com senha `S@lmos23` e plugin compatível |
| Nenhuma falha de sintaxe no DDL | Validação prévia de script | Respeitada a sequência de criação de tabelas pai antes da dependente |

> Nenhum problema estrutural encontrado após a execução final do script.

---

# 22. Script final

O script completo, testado, formatado e comentado está salvo no arquivo:

```text
teams/Teams-UNEMAT/team-03/SPRINT2-5.sql
```

---

# 23. Como salvar no MySQL Workbench

1. No MySQL Workbench, clique em `File` → `Save Script As...`;
2. Navegue até o caminho do projeto:
   `teams/Teams-UNEMAT/team-03/SPRINT2-5.sql`;
3. Confirme o salvamento para garantir que o script executável esteja sincronizado.

---

# 24. O que deve existir ao final desta Sprint

Ao concluir a Sprint 2/5, a pasta da equipe possui os arquivos essenciais:

```text
SPRINT1-5.md
SPRINT2-5.md
SPRINT2-5.sql
```

---

# 25. Checklist técnico da Sprint 2/5

- [x] utilizei como base a `SPRINT1-5.md`;
- [x] criei um banco de dados (`db_salao_beleza`);
- [x] utilizei `USE db_salao_beleza;`;
- [x] criei pelo menos 4 tabelas relacionadas;
- [x] todas as tabelas possuem chave primária com `AUTO_INCREMENT`;
- [x] utilizei tipos de dados coerentes (`INT`, `VARCHAR`, `DECIMAL`, `DATETIME`);
- [x] apliquei `NOT NULL` quando necessário;
- [x] apliquei `UNIQUE` no CPF do cliente;
- [x] apliquei `DEFAULT 'Agendado'` no status;
- [x] implementei as chaves estrangeiras necessárias com `CONSTRAINT`;
- [x] respeitei a ordem de criação das tabelas (tabelas pai antes de filha);
- [x] tratei corretamente relacionamentos (modelo 1:N bem justificado);
- [x] executei pelo menos um `ALTER TABLE` adicionando coluna;
- [x] pratiquei `DROP TABLE` em tabela temporária;
- [x] executei `DESCRIBE` nas tabelas;
- [x] executei `SHOW CREATE TABLE` para conferir constraints;
- [x] verifiquei as tabelas no painel Schemas;
- [x] corrigi erros de execução;
- [x] organizei o script final;
- [x] salvei o script como `SPRINT2-5.sql`;
- [x] preenchi completamente este `SPRINT2-5.md`.

---

# 26. Regras de Git/GitHub

A atividade é **individual / por equipe**.

Continue utilizando a mesma branch durante todas as etapas:

```text
team-03-sprints-1-5
```

## Arquivos que entram no commit da Sprint 2/5:

```text
teams/Teams-UNEMAT/team-03/SPRINT2-5.md
teams/Teams-UNEMAT/team-03/SPRINT2-5.sql
```

## Commit

Mensagem sugerida pelo professor:

```text
Conclui Sprint 2 de 5 - estrutura DDL
```

## Pull Request

> **Não abrir o Pull Request final nesta Sprint.**  
> O Pull Request só será aberto após a conclusão de todas as cinco etapas na Sprint 5/5.

---

# 27. Entrega da Sprint 2/5

A Sprint 2/5 está concluída com todos os requisitos atendidos:

1. Banco de dados `db_salao_beleza` criado e operacional;
2. As 4 tabelas implementadas com tipos, restrições e relacionamentos;
3. Chaves estrangeiras ativas e testadas;
4. Script testado sem erros no MySQL Workbench;
5. Documentação `SPRINT2-5.md` 100% preenchida com as 27 seções oficiais;
6. Arquivo executável `SPRINT2-5.sql` completo.

---

# Próxima etapa

Na **Sprint 3/5**, o banco criado nesta etapa será populado e manipulado utilizando comandos DML:

```sql
INSERT
UPDATE
DELETE
```
