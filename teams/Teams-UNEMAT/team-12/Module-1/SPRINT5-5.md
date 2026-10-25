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

```text
Site de anúncios imobiliários (real_estate_database)
```

## Objetivo principal

> Armazenar os dados dos imóveis, corretores e clientes de forma segura, permitindo cadastrar anúncios, associar cada imóvel a um corretor responsável e controlar os agendamentos de visita solicitados pelos clientes.

## Quantidade final de tabelas

```text
4
```

## Principais entidades do banco

1. corretor
2. cliente
3. imovel
4. agendamento
5.

## O projeto final permaneceu igual ao planejamento inicial?

- [ ] Sim
- [x] Não

Caso tenha mudado, explique:

> A entidade planejada inicialmente como "interesse" (Sprint 1/5) foi implementada como "agendamento" a partir da Sprint 2/5, pois representa melhor a operação real do sistema (marcar uma visita, com data e status), e não apenas uma manifestação de interesse. Além disso, duas perguntas da Sprint 1/5 foram adaptadas na Sprint 4/5: a pergunta sobre "agendamentos na próxima semana" virou uma consulta sobre agendamentos com status "Pendente" (mais útil operacionalmente do que um filtro de data relativa), e a pergunta sobre visitas do imóvel de ID 50 foi ajustada para o imóvel de ID 3, já que o catálogo final possui apenas 5 imóveis ativos.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| Entidade "interesse" renomeada para "agendamento" | Sprint 2/5 | Nome mais fiel à funcionalidade implementada (visita com data e status, não apenas um interesse) |
| Pergunta sobre "agendamentos na próxima semana" adaptada para "agendamentos com status Pendente" | Sprint 4/5 | Um filtro de status é mais estável e operacionalmente útil do que uma janela de datas relativa |
| Referência ao imóvel de ID 50 (Sprint 1/5) ajustada para ID 3 | Sprint 4/5 | O catálogo final possui poucos registros (5 imóveis após o DELETE), então o ID 50 não existe na base |
| Imóvel "Cobertura Duplex" (id 6) removido do catálogo | Sprint 3/5 | Exercício obrigatório de DELETE proposto na atividade, sem imóvel dependente em agendamentos |

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
| corretor | Sim | Não se aplica (sem FK) | Sim | Sim |
| cliente | Sim | Não se aplica (sem FK) | Sim | Sim |
| imovel | Sim | Sim (id_corretor → corretor) | Sim | Sim |
| agendamento | Sim | Sim (id_cliente → cliente, id_imovel → imovel) | Sim | Sim |

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| corretor | id_corretor | Sim |
| cliente | id_cliente | Sim |
| imovel | id_imovel | Sim |
| agendamento | id_agendamento | Sim |

Verifique se cada registro pode ser identificado de forma única.

> Sim, todas as tabelas possuem um identificador numérico único e crescente, o que garante a identificação individual de cada registro.

---

# 7. Revisão das FOREIGN KEY

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| imovel | id_corretor | corretor | id_corretor |
| agendamento | id_cliente | cliente | id_cliente |
| agendamento | id_imovel | imovel | id_imovel |

Confira se:

- a tabela referenciada existe;
- o campo referenciado existe;
- os tipos são compatíveis;
- o relacionamento faz sentido;
- a ordem de criação das tabelas está correta.

> Todas as condições acima foram confirmadas. A ordem de criação respeita a dependência: corretor e cliente (independentes) são criadas primeiro, depois imovel (depende de corretor) e por último agendamento (depende de cliente e imovel).

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
| corretor | creci | UNIQUE | Um corretor não pode se cadastrar com um número de CRECI já existente |
| corretor | email | UNIQUE | Um corretor não pode possuir dois cadastros com o mesmo e-mail |
| cliente | email | UNIQUE | Um cliente não pode possuir dois cadastros com o mesmo e-mail |
| agendamento | status | DEFAULT ('Pendente') | Todo agendamento nasce com uma situação definida, mesmo sem informação explícita |
| imovel | id_corretor | FOREIGN KEY + NOT NULL | Um imóvel não pode ser cadastrado sem um corretor responsável associado |

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|
| corretor | 5 |
| cliente | 5 |
| imovel | 5 (6 inseridos, 1 excluído) |
| agendamento | 5 (6 inseridos, 1 excluído) |

Pergunte:

- existem dados suficientes para testar relacionamentos?
- existem valores diferentes para permitir filtros?
- existem grupos diferentes para testar `GROUP BY`?
- existem valores suficientes para `SUM`, `AVG`, `MIN` e `MAX`?
- existem registros que permitam testar `HAVING`?

> Sim para todos os pontos. Os imóveis têm cidades distintas (Rondonópolis, Chapada dos Guimarães, Alagoas, Rondônia), suficientes para GROUP BY por cidade; os valores variam de R$ 150.000 a R$ 800.000, permitindo testar SUM, AVG, MIN e MAX com resultados não triviais; e o cliente de id 1 possui 2 agendamentos, o que permite validar o HAVING COUNT(*) > 1.

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
| Nenhum problema encontrado nos INSERTs | Não se aplica |

---

# 11. Revisão dos UPDATEs

Confirme:

- [x] os UPDATEs possuem `WHERE`;
- [x] alteram os registros esperados;
- [x] não modificam toda a tabela acidentalmente;
- [x] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```sql
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 1;
UPDATE imovel SET valor = 240000.00 WHERE id_imovel = 2;
UPDATE cliente SET telefone = '66000000000' WHERE id_cliente = 3;
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
DELETE FROM agendamento WHERE id_agendamento = 5;
DELETE FROM imovel WHERE id_imovel = 6;
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
| SELECT | Sim | Quais são todos os imóveis cadastrados no sistema? |
| WHERE | Sim | Quais imóveis estão localizados em Rondonópolis? |
| ORDER BY | Sim | Quais imóveis custam menos de R$ 300.000,00, do mais barato ao mais caro? |
| COUNT | Sim | Quantos agendamentos estão com status "Pendente"? |
| SUM | Sim | Qual a soma total em dinheiro de todos os imóveis do catálogo? |
| AVG | Sim | Qual a média de preço dos imóveis anunciados? |
| MIN/MAX | Sim | Qual o valor do imóvel mais barato e do mais caro? |
| GROUP BY | Sim | Quantos imóveis existem por cidade? |
| HAVING | Sim | Quais clientes possuem mais de 1 agendamento? |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Quais imóveis estão cadastrados na cidade de Rondonópolis?

**Foi respondida?**

- [x] Sim
- [ ] Não

**Consulta utilizada:**

```sql
SELECT titulo, valor, cidade
FROM imovel
WHERE cidade = 'Rondonópolis';
```

---

## Pergunta 2

> Quais imóveis custam menos de R$ 300.000,00?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT titulo, valor, cidade
FROM imovel
WHERE valor < 300000.00
ORDER BY valor ASC;
```

---

## Pergunta 3

> Quantos agendamentos estão com o status Pendente?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT COUNT(*) AS agendamentos_pendentes
FROM agendamento
WHERE status = 'Pendente';
```

---

## Pergunta 4

> Quantos imóveis temos anunciados no total?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT COUNT(*) AS total_imoveis
FROM imovel;
```

---

## Pergunta 5

> Quais as datas de visita agendadas para o imóvel de ID 3 (Chácara)?

**Foi respondida?**

- [x] Sim
- [ ] Não

```sql
SELECT id_cliente, data_visita, status
FROM agendamento
WHERE id_imovel = 3
ORDER BY data_visita ASC;
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

-- Aluno: João Guilherme Barros de Lima
-- Tema: Site de anúncios imobiliários
-- Banco: real_estate_database


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================

CREATE DATABASE IF NOT EXISTS real_estate_database;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE real_estate_database;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

CREATE TABLE corretor (
    id_corretor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    creci VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    data_nascimento DATE
);

CREATE TABLE imovel (
    id_imovel INT PRIMARY KEY AUTO_INCREMENT,
    id_corretor INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quantidade_comodos INT NOT NULL,
    cidade VARCHAR(100) NOT NULL,

    CONSTRAINT fk_imovel_corretor
        FOREIGN KEY (id_corretor)
        REFERENCES corretor(id_corretor)
);

CREATE TABLE agendamento (
    id_agendamento INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_imovel INT NOT NULL,
    data_visita DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente',

    CONSTRAINT fk_agendamento_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_agendamento_imovel
        FOREIGN KEY (id_imovel)
        REFERENCES imovel(id_imovel)
);


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================

-- As restrições PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL e
-- DEFAULT já foram declaradas junto com a criação das tabelas
-- na seção anterior. Comandos de verificação:

DESCRIBE corretor;
DESCRIBE cliente;
DESCRIBE imovel;
DESCRIBE agendamento;

SHOW CREATE TABLE corretor;
SHOW CREATE TABLE cliente;
SHOW CREATE TABLE imovel;
SHOW CREATE TABLE agendamento;


-- ============================================================
-- 5. INSERTS
-- ============================================================

INSERT INTO corretor (nome, creci, email, telefone)
VALUES
    ('Paulo Roberto de Lima Junior', 'CRECI111', 'paulo@imob.com', '66999991111'),
    ('Isa', 'CRECI222', 'isa@imob.com', '66999992222'),
    ('Jao', 'CRECI333', 'jao@imob.com', '66999993333'),
    ('Amanda', 'CRECI444', 'amanda@imob.com', '66999994444'),
    ('Theus', 'CRECI555', 'theus@imob.com', '66999995555');

INSERT INTO cliente (nome, email, senha, telefone, data_nascimento)
VALUES
    ('João Guilherme Barros de Lima', 'joao@email.com', 'senha123', '66988881111', '2006-11-29'),
    ('Gi', 'gi@email.com', 'senha456', '66988882222', '2005-05-15'),
    ('Carlos Santos', 'carlos@email.com', 'senha789', '66988883333', '1990-08-20'),
    ('Mariana Silva', 'mariana@email.com', 'senha321', '66988884444', '1995-12-10'),
    ('Lucas Almeida', 'lucas@email.com', 'senha654', '66988885555', '1988-03-30');

INSERT INTO imovel (id_corretor, titulo, valor, quantidade_comodos, cidade)
VALUES
    (1, 'Casa com piscina', 450000.00, 4, 'Rondonópolis'),
    (2, 'Apartamento Centro', 250000.00, 3, 'Rondonópolis'),
    (3, 'Chácara para descanso', 600000.00, 5, 'Chapada dos Guimarães'),
    (4, 'Casa na praia', 800000.00, 4, 'Alagoas'),
    (1, 'Terreno amplo', 150000.00, 0, 'Rondônia'),
    (5, 'Cobertura Duplex', 950000.00, 6, 'Rondonópolis');

INSERT INTO agendamento (id_cliente, id_imovel, data_visita, status)
VALUES
    (1, 4, '2026-10-15 10:00:00', 'Pendente'),
    (2, 3, '2026-10-16 14:30:00', 'Pendente'),
    (1, 3, '2026-10-17 09:00:00', 'Pendente'),
    (3, 2, '2026-10-18 11:00:00', 'Pendente'),
    (4, 5, '2026-10-19 15:00:00', 'Cancelado'),
    (5, 1, '2026-10-20 16:00:00', 'Pendente');


-- ============================================================
-- 6. UPDATES
-- ============================================================

UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 1;
UPDATE imovel SET valor = 240000.00 WHERE id_imovel = 2;
UPDATE cliente SET telefone = '66000000000' WHERE id_cliente = 3;


-- ============================================================
-- 7. DELETES
-- ============================================================

DELETE FROM agendamento WHERE id_agendamento = 5;
DELETE FROM imovel WHERE id_imovel = 6;


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================

SELECT * FROM imovel;
SELECT titulo, valor FROM imovel;


-- ============================================================
-- 9. WHERE
-- ============================================================

SELECT titulo, valor, cidade
FROM imovel
WHERE cidade = 'Rondonópolis';

SELECT *
FROM agendamento
WHERE status = 'Pendente'
  AND data_visita > '2026-10-16';


-- ============================================================
-- 10. ORDER BY
-- ============================================================

SELECT titulo, valor, cidade
FROM imovel
WHERE valor < 300000.00
ORDER BY valor ASC;


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

SELECT COUNT(*) AS agendamentos_pendentes
FROM agendamento
WHERE status = 'Pendente';

SELECT SUM(valor) AS soma_total_imoveis
FROM imovel;

SELECT AVG(valor) AS media_precos
FROM imovel;

SELECT MIN(valor) AS imovel_mais_barato,
       MAX(valor) AS imovel_mais_caro
FROM imovel;


-- ============================================================
-- 12. GROUP BY
-- ============================================================

SELECT cidade, COUNT(*) AS total_por_cidade
FROM imovel
GROUP BY cidade;


-- ============================================================
-- 13. HAVING
-- ============================================================

SELECT id_cliente, COUNT(*) AS quantidade_visitas
FROM agendamento
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================

SELECT titulo,
       valor,
       valor * 0.05 AS comissao_corretor
FROM imovel;


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================

SHOW TABLES;

SELECT * FROM corretor;
SELECT * FROM cliente;
SELECT * FROM imovel;
SELECT * FROM agendamento;
```

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

```text
4
```

Quantidade encontrada:

```text
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

```text
imovel
```

### Restrição testada

```text
FOREIGN KEY id_corretor → corretor(id_corretor)
```

### Resultado

> Ao tentar inserir um imóvel com um id_corretor inexistente (ex: 99), o MySQL rejeitou a operação com o erro "Cannot add or update a child row: a foreign key constraint fails", confirmando que a integridade referencial entre imovel e corretor está sendo respeitada.

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```text
email (tabela corretor)
```

### Resultado

> Ao tentar inserir um novo corretor utilizando um e-mail já cadastrado (ex: paulo@imob.com), o MySQL rejeitou a operação com o erro "Duplicate entry ... for key 'email'", confirmando que a restrição UNIQUE está ativa.

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```text
valor (tabela imovel)
```

### Resultado

> Ao tentar inserir um imóvel sem informar o campo valor, o MySQL rejeitou a operação com o erro "Field 'valor' doesn't have a default value", confirmando que a restrição NOT NULL está funcionando.

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

> Quantos agendamentos estão atualmente com o status "Pendente" no sistema?

### SQL

```sql
SELECT COUNT(*) AS agendamentos_pendentes
FROM agendamento
WHERE status = 'Pendente';
```

### Resultado esperado

> Com os dados finais (5 agendamentos restantes após o DELETE, sendo 1 atualizado para "Confirmado"), o resultado esperado é 4 agendamentos pendentes.

### Por que essa consulta é importante?

> Porque é a consulta que a equipe usaria no dia a dia para saber quantas visitas ainda precisam de confirmação. É um indicador operacional direto do sistema: se o número estiver alto, sinaliza agendamentos sem retorno do corretor ou do cliente, exigindo ação imediata.

---

# 27. Consulta final mais complexa

### Pergunta

> Quais clientes possuem mais de 1 agendamento de visita registrado no sistema?

### SQL

```sql
SELECT id_cliente, COUNT(*) AS quantidade_visitas
FROM agendamento
GROUP BY id_cliente
HAVING COUNT(*) > 1;
```

### Conceitos utilizados

- [ ] WHERE
- [ ] ORDER BY
- [ ] agregação
- [x] GROUP BY
- [x] HAVING
- [ ] expressão
- [ ] outro

### Explique

> WHERE filtra linhas individuais antes de qualquer agrupamento, mas "mais de 1 agendamento" só existe depois que as linhas já foram agrupadas por id_cliente e contadas. Por isso é necessário primeiro o GROUP BY, para formar os grupos por cliente, e depois o HAVING, para filtrar o resultado da agregação (COUNT) sobre esses grupos. Com os dados finais, apenas o cliente de id 1 possui 2 agendamentos, sendo o único retornado pela consulta.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | Executado com sucesso | Não |
| CREATE TABLE | Executado com sucesso, 4 tabelas criadas | Não |
| PRIMARY KEY | Funcionando em todas as tabelas | Não |
| FOREIGN KEY | Funcionando, bloqueia registros órfãos | Não |
| NOT NULL | Funcionando | Não |
| UNIQUE | Funcionando | Não |
| INSERT | Executado com sucesso | Não |
| UPDATE | Executado com sucesso | Não |
| DELETE | Executado com sucesso, sem violar FK | Não |
| SELECT | Funcionando | Não |
| WHERE | Funcionando | Não |
| ORDER BY | Funcionando | Não |
| GROUP BY | Funcionando | Não |
| HAVING | Funcionando | Não |
| funções de agregação | COUNT, SUM, AVG, MIN e MAX funcionando | Não |

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
| Comando SELECT do COUNT de agendamentos pendentes estava digitado como "ELECT" (Sprint 4/5) | Erro de digitação ao copiar o comando no script | Corrigido para "SELECT" antes da integração no SPRINT5-5.sql |
| Tentativa inicial de filtrar clientes com mais de 1 agendamento usando WHERE COUNT(*) > 1 (Sprint 4/5) | Uso de função de agregação dentro de WHERE, não permitido no MySQL | Substituído por GROUP BY id_cliente + HAVING COUNT(*) > 1 |

Nenhum problema novo foi identificado durante a reconstrução completa do banco nesta Sprint; os dois itens acima já haviam sido corrigidos ainda na Sprint 4/5 e foram apenas confirmados como resolvidos aqui.

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
- [x] `UNIQUE` está coerente;
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

> A lógica de relacionamento entre tabelas usando FOREIGN KEY, e a diferença prática entre filtrar linhas (WHERE) e filtrar grupos já agregados (HAVING).

## Qual conteúdo apresentou maior dificuldade?

> Entender por que HAVING é necessário em vez de WHERE quando a condição depende de uma função de agregação (COUNT, SUM etc.), já que a princípio pareciam intercambiáveis.

## Qual erro mais contribuiu para seu aprendizado?

> A tentativa de usar WHERE COUNT(*) > 1 para filtrar clientes com mais de um agendamento, que gerou erro de sintaxe e me obrigou a entender a ordem lógica de execução do SQL (FROM → WHERE → GROUP BY → HAVING → SELECT).

## Qual parte do banco você considera mais bem implementada?

> A tabela agendamento, por concentrar as duas chaves estrangeiras (cliente e imóvel) e o campo status com DEFAULT, o que permitiu testar de forma clara integridade referencial, agregação e agrupamento.

## Se tivesse mais tempo, o que melhoraria?

> Adicionaria uma tabela de imagens do imóvel (relacionamento 1:N com imovel), já que isso estava previsto na descrição inicial do sistema (Sprint 1/5) mas não chegou a ser implementado como tabela própria.

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
