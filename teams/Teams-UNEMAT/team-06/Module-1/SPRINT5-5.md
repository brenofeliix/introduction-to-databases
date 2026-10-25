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

```
Vendas e Produto Loja de Conveniencia
```

## Objetivo principal

> Recriar em um banco de dados o funcionamento de estoque e caixa de uma pequena loja de conveniencia, dando pra cadastrar produtos e colocar eles em categorias.

## Quantidade final de tabelas

```
4
```

## Principais entidades do banco

1. Categoria 
2. Produto
3. Venda
4. Item_venda
5. 

## O projeto final permaneceu igual ao planejamento inicial?

- [x] Sim
- [ ] Não

Caso tenha mudado, explique:

> Escreva aqui.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |
|  |  |  |

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
| Categoria | Sim | N/A | Sim | Sim |
| Produto | sim | Sim | Sim | Sim |
| Venda | Sim | N/A | Sim | Sim |
| Item_venda | Sim | Sim | Sim | Sim |
|  |  |  |  |  |

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| Categoria | id_categoria | sim |
| Produto | id_produto | Sim |
| Venda | id_venda | Sim |
| Item_venda | id_venda, Id_produto | Não |

Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| Produto | id_categoria | Categoria | id_categoria |
| Item_venda | id_venda | Venda | id_venda |
| Item_venda | id_produto | Produto | id_produto |
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
| Produto | codigo_barras | UNIQUE | impede que dois produtos tenham o mesmo codigo |
| Produto | preco_venda | CHECK(>=0) | Impede que o sistema grave valores negativos |
| Venda | data_venda | DEFAULT CURRENT_TIMESTAMP | Garante que o horario que o sistema pegue seja gravado automaticamente no cupom |
|  |  |  |  |

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| Categoria | 4 |
| Produto | 4 |
| Venda | 7 |
| item_venda | 3 |
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

- [x] os INSERTs executam sem erro;
- [x] respeitam as chaves estrangeiras;
- [x] não existem duplicações indevidas;
- [x] respeitam `NOT NULL`;
- [x] respeitam `UNIQUE`;
- [x] os dados fazem sentido no domínio.

Caso encontre problemas, registre:

| Problema | Correção realizada |
|---|---|
|  |  |
|  |  |

---

# 11. Revisão dos UPDATEs

Confirme:

- [x] os UPDATEs possuem `WHERE`;
- [x] alteram os registros esperados;
- [x] não modificam toda a tabela acidentalmente;
- [x] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
UPDATE Produto
SET preco_venda = 12.50
WHERE id_produto = 1;

UPDATE Produto
SET preco_venda = 23.00
WHERE id_produto = 2;

UPDATE Produto
SET preco_venda = 1000000.00
WHERE id_produto = 4;
```

---

# 12. Revisão dos DELETEs

Confirme:

- [x] os DELETEs possuem `WHERE`;
- [x] não removem registros necessários ao funcionamento do projeto;
- [x] respeitam as dependências de `FOREIGN KEY`;
- [x] não comprometem consultas posteriores.

Liste os DELETEs finais:

```sql
DELETE FROM item_venda 
WHERE id_venda IN('1'); 

DELETE FROM item_venda 
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
| SELECT | Sim | Quais categorias estão cadastradas? |
| WHERE | Sim | Quais produtos custam mais de 15 reais |
| ORDER BY | Sim | Produtos ordenados por preço |
| COUNT | Sim | Total de produtos cadastrados |
| SUM | sim | faturamento total da loja |
| AVG | Sim | Ticket Medio das vendas |
| MIN/MAX | Sim | Venda mais barata e mais cara |
| GROUP BY | Sim | Quantos itens existem por Categoria |
| HAVING | Sim | Quais Categorias Possuem apenas 1 produto |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quantis Categorias estão cadastradas no Sistema.

**Foi respondida?**

- [x] Sim
- [ ] Não

**Consulta utilizada:**

```sql
SELECT nome_categoria
from Categoria;
```

---

## Pergunta 2

> Quais produtos custam mais de 15 reais?.

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT nome_produto, preco_venda
from Produto
WHERE preco_venda > 15.00;
```

---

## Pergunta 3

> Quais produtos custam mais de 10 e tem estoque acima de 50?.

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT nome_produto, preco_venda, quantidade_estoque
FROM Produto
WHERE preco_venda > 10.00
AND quantidade_estoque >= 50;
```

---

## Pergunta 4

> Quantos produtos existem em cada categoria?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT id_categoria, COUNT(*) AS quantidade_itens
from Produto
GROUP BY id_categoria;
```

---

## Pergunta 5

> Qual o valor total arrecadado das vendas?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT SUM(valot_total) AS total_produtos
from Produto;
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

-- Aluno: Mariano Lino da Silva Neto
-- Tema: Vendas e Produtos Loja de Conveniencia
-- Banco: db_conveniencia


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================
CREATE DATABASE IF NOT EXISTS db_conveniencia;

-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================
USE db_conveniencia;

-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================
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

-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================
ALTER TABLE Produto
ADD COLUMN marca varchar(50);

-- ============================================================
-- 5. INSERTS
-- ============================================================
INSERT INTO Categoria(nome_categoria) VALUES
('Salgados'),
('Doces e Bolachas'),
('Pão fresco'),
('Cobras');

INSERT INTO Produto(id_categoria, codigo_barras, nome_produto, quantidade_estoque) VALUES 
(1, '102324232323', 'Pão Frito', 50),
(2, '102324232324', 'Almoço velho', 50),
(3, '142324232325', 'Doces e Legumes', 50),
(4, '102324232326', 'Simplesmente a mulher mais linda do Mundo', 1);

INSERT INTO Venda(valor_total) VALUES
(15.00),
(13.00),
(12.00),
(03.00),
(07.00),
(23.00),
(08.00);

INSERT INTO Item_venda(quantidade, id_venda,id_produto) VALUES
(1,1,1),
(1,1,2),
(1,2,3),
(2,3,4),
(1,5,2);

-- ============================================================
-- 6. UPDATES
-- ============================================================
UPDATE Produto
SET preco_venda = 12.50
WHERE id_produto = 1;

UPDATE Produto
SET preco_venda = 23.00
WHERE id_produto = 2;

UPDATE Produto
SET preco_venda = 1000000.00
WHERE id_produto = 4;

-- ============================================================
-- 7. DELETES
-- ============================================================
DELETE FROM item_venda 
WHERE id_venda IN('1'); 

DELETE FROM item_venda 

-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================
SELECT nome_categoria
from Categoria;

-- ============================================================
-- 9. WHERE
-- ============================================================
SELECT nome_categoria
from Categoria;
WHERE id_venda IN('2');

SELECT nome_produto, preco_venda
from Produto
WHERE preco_venda > 15.00;

-- ============================================================
-- 10. ORDER BY
-- ============================================================
select nome_produto, preco_venda
from Produto
ORDER BY preco_venda ASC;

-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================
select nome_produto, preco_venda
from Produto
ORDER BY preco_venda ASC;

SELECT SUM(valot_total) AS total_produtos
from Produto;

SELECT COUNT(*) AS total_produtos
FROM Produto;

SELECT AVG(valor_total) AS ticke_medio
FROM Venda;

SELECT min(valor_total) as menor_venda,
	Max(valor_total) as maior_venda
	from Venda;

-- ============================================================
-- 12. GROUP BY
-- ============================================================
SELECT id_categoria, COUNT(*) AS quantidade_itens
from Produto
GROUP BY id_categoria;

-- ============================================================
-- 13. HAVING
-- ============================================================
SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;

-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================
SELECT nome_produto,
preco_venda,
Preco_venda * 0.90 AS preco_desconto
FROM Produto
WHERE preco_venda is not null;

-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================
SHOW TABLES;
```
DESCRIBE Categoria;
DESCRIBE Produto;
DESCRIBE Venda;
DESCRIBE Item_venda;
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

```
4
```

Quantidade encontrada:

```
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

```
Item_venda
```

### Restrição testada

```
FOREIGN KEY(id_produto)
```

### Resultado

> Tentamos inserir um item de venda referenciado que é inexsistente e o MYSQL bloqueou com o erro "cannot add or update a child row, a FOREIGN KEY constraint fails".

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```
Produto.codigo_barras
```

### Resultado

> Tentamos inserir um novo produto repetindo o codigo de barras, mas ele recusou dizendo que não dava pra duplicar uma entry.

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```
Produto.nome_produto
```

### Resultado

> Tentativa de inserção de produto deixando o nome vazio(NULL) com isso o MYSQL recusou na hora falando que não tinha como nome_produto ser nulo.

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

> Qual o faturamento financio total registrado pela loja.

### SQL

```sql
SELECT SUM(valot_total) AS total_produtos
from Produto;
```

### Resultado esperado

> A soma de todos os valores na columa valor_total.

### Por que essa consulta é importante?

> Pra evitar que as pessoas da loja calculem manualmente o faturamento da loja, melhor deixar essa parte automatizada pelo SUM.

---

# 27. Consulta final mais complexa

### Pergunta

> Quais Categorias possuem apenas 1 produto cadastrado no catálogo?.

### SQL

```sql
SELECT id_categoria, COUNT(*) AS quantidade_itens
FROM Produto 
GROUP BY  id_categoria 
HAVING COUNT(*) = 1;
```

### Conceitos utilizados

- [ ] WHERE
- [ ] ORDER BY
- [x] agregação
- [x] GROUP BY
- [x] HAVING
- [ ] expressão
- [ ] outro

### Explique

> Basicamente o banco vai agrupar os itens pela categoria de cada um, e depois vai contar o volume interno de cada um, pra só depois filtrar os grupos ultilizando o HAVING.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | Sucesso | Não |
| CREATE TABLE | Sucesso | Não |
| PRIMARY KEY | Sucesso | Não |
| FOREIGN KEY | Sucesso | Não |
| NOT NULL | Sucesso | Não |
| UNIQUE | Sucesso | Não |
| INSERT | Sucesso | Não |
| UPDATE | Sucesso | Não |
| DELETE | Sucesso | Não |
| SELECT | Sucesso | Não |
| WHERE | Sucesso | Não |
| ORDER BY | Sucesso | Não |
| GROUP BY | Sucesso | Não |
| HAVING | Sucesso | Não |
| funções de agregação | Sucesso | Não |

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

- [x] estou na minha branch individual;
- [x] todos os commits foram enviados ao GitHub;
- [x] não alterei arquivos de outro aluno;
- [x] não alterei arquivos de outra instituição;
- [x] não alterei arquivos administrativos do repositório;
- [x] os 9 arquivos da atividade estão presentes;
- [x] os arquivos `.md` estão preenchidos;
- [x] os arquivos `.sql` foram testados;
- [x] o `SPRINT5-5.sql` executa do início ao fim;
- [x] removi nomes genéricos dos modelos;
- [x] não deixei senhas ou credenciais;
- [x] compreendo o código entregue.

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

- [x] `CREATE DATABASE` funciona;
- [x] `USE` funciona;
- [x] todas as tabelas são criadas;
- [x] nenhuma tabela necessária está ausente.

## Estrutura

- [x] todas as tabelas possuem PK;
- [x] FKs estão corretas;
- [x] tipos de dados estão coerentes;
- [x] `NOT NULL` está coerente;
- [X] `UNIQUE` está coerente;
- [x] `DEFAULT` está coerente.

## Dados

- [x] INSERTs funcionam;
- [x] dados são coerentes;
- [x] FKs são respeitadas.

## Manipulação

- [x] UPDATEs funcionam;
- [x] UPDATEs possuem `WHERE`;
- [x] DELETEs funcionam;
- [x] DELETEs possuem `WHERE`.

## Consultas

- [x] SELECT funciona;
- [x] WHERE funciona;
- [x] ORDER BY funciona;
- [x] COUNT funciona;
- [x] SUM funciona quando aplicável;
- [x] AVG funciona quando aplicável;
- [x] MIN/MAX funcionam;
- [x] GROUP BY funciona;
- [x] HAVING funciona.

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

Responda brevemente.

## O que você considera que aprendeu melhor?

> Se brincar foi a parte de mexer nos comandos do DBEAVER visto que não to usando MYSQL pro PC.

## Qual conteúdo apresentou maior dificuldade?

> Pensar sobre as Sprints UM e também não tive muito tempo pras coisas.

## Qual erro mais contribuiu para seu aprendizado?

> Falta de Tempo.

## Qual parte do banco você considera mais bem implementada?

> Criação de Tabelas.

## Se tivesse mais tempo, o que melhoraria?

> Provavelmente ficaria bem mais organizado como foi distribuido os comandos no SQL.

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
