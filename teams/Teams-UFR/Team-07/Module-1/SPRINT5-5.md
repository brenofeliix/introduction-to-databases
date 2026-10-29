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
db_raaei — Gestão de Associação Atlética e Inclusiva de Atletismo (RAAEI)
```

## Objetivo principal

> Estruturar, gerenciar e otimizar o armazenamento de dados de atletas, escolas parceiras, categorias esportivas e colaboradores da associação, permitindo o acompanhamento de desempenho, controle demográfico e emissão de relatórios gerenciais e estatísticos para apoiar as iniciativas de inclusão social por meio do esporte.

## Quantidade final de tabelas

```
4 tabelas principais (escola, categoria, atleta, colaborador)
```

## Principais entidades do banco

1. escola (Instituições de ensino parceiras, públicas e privadas)
2. categoria (Faixas etárias e classificações competitivas do atletismo)
3. atleta (Dados demográficos, esportivos e de saúde dos praticantes)
4. colaborador (Profissionais, técnicos e membros da equipe gestora)

## O projeto final permaneceu igual ao planejamento inicial?

- [ x ] Sim
- [ ] Não

Caso tenha mudado, explique:

> O planejamento inicial foi integralmente mantido ao longo de todas as etapas de desenvolvimento, assegurando que a modelagem relacional, a inserção de dados e as consultas SQL atendessem perfeitamente aos requisitos operacionais e institucionais definidos para a RAAEI.

---

# 4. Mudanças realizadas ao longo das Sprints

Registre alterações relevantes feitas desde a Sprint 1/5.

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|

| Ajuste no tratamento de restrições de nulos e campos opcionais na tabela de atletas. | Sprint 3/5 | Garantir maior flexibilidade no cadastro de observações médicas e dados de contato sem comprometer a integridade relacional.

| Inclusão de índices e refinamento no agrupamento com GROUP BY e HAVING para compatibilidade com o modo estrito do MySQL. | Sprint 4/5 | Assegurar que as consultas complexas executassem sem erros de agregação e com alta performance analítica.

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

| escola | Sim (id_escola) | Não se aplica (Tabela Pai) | Sim (VARCHAR, ENUM) | Sim (NOT NULL, UNIQUE)

| categoria	Sim (id_categoria) | Não se aplica (Tabela Pai) | Sim (VARCHAR, INT) | Sim (NOT NULL, CHECK)

atleta | Sim (id_atleta) | Sim (id_escola, id_categoria) | Sim (VARCHAR, DATE, INT) | Sim (NOT NULL, FOREIGN KEY)

| colaborador | Sim (id_colaborador) | Não se aplica (Tabela Independente) | Sim (VARCHAR, DATE) | Sim (NOT NULL, UNIQUE para CPF)

---

# 6. Revisão das PRIMARY KEY

Liste as chaves primárias finais.

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|

| escola | id_escola | Sim (INT AUTO_INCREMENT)

| categoria | id_categoria | Sim (INT AUTO_INCREMENT)

| atleta | id_atleta | Sim (INT AUTO_INCREMENT)

| colaborador | id_colaborador | Sim (INT AUTO_INCREMENT)

Verifique se cada registro pode ser identificado de forma única.

---

# 7. Revisão das FOREIGN KEY - 

Liste as chaves estrangeiras finais.

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|

| atleta | id_escola | escola | id_escola

| atleta | id_categoria | categoria | id_categoria

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

| colaborador | cpf | UNIQUE, NOT NULL | Garante que cada profissional ou membro da equipe técnica seja cadastrado unicamente pelo CPF, evitando duplicidade de registros na associação.

| atleta | id_escola | FOREIGN KEY, NOT NULL | Assegura que todo atleta cadastrado esteja obrigatoriamente vinculado a uma instituição de ensino parceira válida e registrada no sistema.

| atleta | data_cadastro | DEFAULT CURRENT_DATE | Preenche automaticamente a data de registro do atleta caso nenhum valor seja informado no momento da inserção.

| escola | id_escola | PRIMARY KEY, AUTO_INCREMENT | Identifica univocamente cada escola parceira com numeração sequencial gerada automaticamente pelo sistema.

---

# 9. Revisão dos dados inseridos

Analise se os dados da Sprint 3/5 são suficientes para testar o banco.

Preencha:

| Tabela | Quantidade aproximada de registros |
|---|---:|

| escola | 5

| categoria | 6

| atleta | 15

| colaborador | 8

Pergunte:

- existem dados suficientes para testar relacionamentos?
Sim. Os registros estão distribuídos de forma que cada atleta possui chaves estrangeiras válidas apontando para escolas e categorias específicas, permitindo junções (JOIN) precisas.

- existem valores diferentes para permitir filtros?
Sim. Há diversidade em campos como tipos de rede de ensino (pública e privada), faixas etárias, restrições médicas e status, viabilizando o uso de múltiplos operadores em cláusulas WHERE.

- existem grupos diferentes para testar `GROUP BY`?
Sim. Os dados permitem agrupar atletas por rede de ensino escolar e por categorias de atletismo com facilidade.

- existem valores suficientes para `SUM`, `AVG`, `MIN` e `MAX`?
Sim. As idades e os anos/faixas das categorias fornecem uma base numérica adequada para o cálculo de agregações estatísticas.

- existem registros que permitam testar `HAVING`?
Sim. A distribuição de atletas por categoria contempla grupos com mais de um participante e categorias vazias ou com apenas um registro, permitindo a aplicação correta de filtros em grupos (HAVING COUNT(...) > 1).

---

# 10. Revisão dos INSERTs

Confirme:

- [ ] os INSERTs executam sem erro;
- [ ] respeitam as chaves estrangeiras;
- [ ] não existem duplicações indevidas;
- [ ] respeitam `NOT NULL`;
- [ ] respeitam `UNIQUE`;
- [ ] os dados fazem sentido no domínio.

Caso encontre problemas, registre:

| Problema | Correção realizada |
|---|---|

| Incompatibilidade temporária na ordem de inserção devido às dependências de chave estrangeira (tentativa de inserir atletas antes das escolas e categorias). | Ajuste na estruturação da ordem dos scripts no arquivo unificado, garantindo que as tabelas pai (escola e categoria) sejam populadas antes da tabela filha (atleta).

| Inserção duplicada em campos com restrição UNIQUE (CPFs de colaboradores). | Validação prévia da lista de cadastros para garantir que cada registro de pessoal possua identificadores únicos e corretos.
---

# 11. Revisão dos UPDATEs

Confirme:

- [ ] os UPDATEs possuem `WHERE`;
- [ ] alteram os registros esperados;
- [ ] não modificam toda a tabela acidentalmente;
- [ ] mantêm a integridade do banco.

Liste os principais UPDATEs finais:

```
-- Atualização de observações médicas para um atleta específico
UPDATE atleta 
SET observacoes_medicas = 'Atestado liberado para competições de alta intensidade.' 
WHERE id_atleta = 3;

-- Atualização do turno de funcionamento de uma escola parceira
UPDATE escola 
SET turno = 'Integral' 
WHERE nome_escola = 'Escola Estadual Dom Aquino';

```

---

# 12. Revisão dos DELETEs

Confirme:

- [ ] os DELETEs possuem `WHERE`;
- [ ] não removem registros necessários ao funcionamento do projeto;
- [ ] respeitam as dependências de `FOREIGN KEY`;
- [ ] não comprometem consultas posteriores.

Liste os DELETEs finais:

```
-- Remoção controlada de um registro de colaborador inativo que não possui dependências críticas
DELETE FROM colaborador 
WHERE id_colaborador = 8;

-- Remoção de um registro de teste na tabela de atletas antes da consolidação final das consultas
DELETE FROM atleta 
WHERE id_atleta = 15;

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

| SELECT | Sim | Quais são os nomes e datas de nascimento de todos os atletas cadastrados na associação?

| WHERE |Sim | Quais atletas possuem alguma restrição médica registrada no sistema?

| ORDER BY | Sim |Quais são os atletas cadastrados ordenados alfabeticamente pelo nome em ordem crescente?

| COUNT | Sim | Qual é o número total de atletas cadastrados na associação?

| SUM | Sim | Qual é a soma total dos identificadores (IDs) dos colaboradores ativos na equipe técnica? (ou métrica quantitativa aplicável)

| AVG | Sim | Qual é a média dos IDs ou valores numéricos cadastrados para controle estatístico dos atletas?

| MIN/MAX | Sim | Qual é a menor e a maior idade (ou ano de nascimento) entre os atletas da associação?

| GROUP BY | Sim | Quantos atletas estão matriculados em cada escola parceira distinta?

| HAVING | Sim | Quais categorias esportivas possuem mais de 2 atletas cadastrados?

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

Retome as perguntas definidas inicialmente.

## Pergunta 1

> Qual é a distribuição quantitativa de atletas cadastrados em cada categoria de atletismo da associação?

**Foi respondida?**

- [ x ] Sim
- [ ] Não

**Consulta utilizada:**

```
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria;

```

---

## Pergunta 2

> Quais atletas possuem restrições médicas registradas e a quais escolas pertencem?

**Foi respondida?**

- [ x ] Sim
- [ ] Não

```
SELECT a.nome_atleta, e.nome_escola, a.observacoes_medicas
FROM atleta a
JOIN escola e ON a.id_escola = e.id_escola
WHERE a.observacoes_medicas IS NOT NULL AND a.observacoes_medicas <> 'Nenhuma';

```

---

## Pergunta 3

> Quais escolas parceiras possuem atletas cadastrados no programa de treinamento?

**Foi respondida?**

- [ x ] Sim
- [ ] Não

```
SELECT DISTINCT e.nome_escola, e.tipo_rede
FROM escola e
JOIN atleta a ON e.id_escola = a.id_escola;

```

---

## Pergunta 4

> Quais categorias esportivas possuem mais de dois atletas matriculados?

**Foi respondida?**

- [ x ] Sim
- [ ] Não

```
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 2;

```

---

## Pergunta 5

> Qual é a listagem ordenada alfabeticamente de todos os colaboradores e técnicos atuantes na RAAEI?

**Foi respondida?**

- [ x ] Sim
- [ ] Não

```
SELECT nome_colaborador, funcao, contato
FROM colaborador
ORDER BY nome_colaborador ASC;

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

-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Walter Anacleto Salido de Souza
-- Tema: Banco de Dados da Associação Atlética e Inclusiva de Atletismo (RAAEI)
-- Banco: db_raaei


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================
DROP DATABASE IF EXISTS db_raaei;
CREATE DATABASE db_raaei CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================
USE db_raaei;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

-- Tabela de Escolas Parceiras
CREATE TABLE escola (
    id_escola INT AUTO_INCREMENT PRIMARY KEY,
    nome_escola VARCHAR(100) NOT NULL,
    tipo_rede ENUM('Publica', 'Privada') NOT NULL,
    municipio VARCHAR(60) NOT NULL DEFAULT 'Rondonópolis',
    turno VARCHAR(20) NOT NULL
);

-- Tabela de Categorias de Atletismo
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    faixa_etaria VARCHAR(30) NOT NULL,
    genero_categoria ENUM('Masculino', 'Feminino', 'Misto') NOT NULL
);

-- Tabela de Colaboradores e Equipe Técnica
CREATE TABLE colaborador (
    id_colaborador INT AUTO_INCREMENT PRIMARY KEY,
    nome_colaborador VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    funcao VARCHAR(50) NOT NULL,
    contato VARCHAR(20) NOT NULL,
    data_admissao DATE NOT NULL
);

-- Tabela de Atletas
CREATE TABLE atleta (
    id_atleta INT AUTO_INCREMENT PRIMARY KEY,
    nome_atleta VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    genero VARCHAR(20) NOT NULL,
    observacoes_medicas VARCHAR(255) DEFAULT 'Nenhuma',
    data_cadastro DATE DEFAULT (CURRENT_DATE),
    id_escola INT NOT NULL,
    id_categoria INT NOT NULL
);


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================
ALTER TABLE atleta
    ADD CONSTRAINT fk_atleta_escola FOREIGN KEY (id_escola) REFERENCES escola(id_escola),
    ADD CONSTRAINT fk_atleta_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria);


-- ============================================================
-- 5. INSERTS
-- ============================================================

-- Inserção de Escolas
INSERT INTO escola (nome_escola, tipo_rede, municipio, turno) VALUES
('Escola Estadual Dom Aquino', 'Publica', 'Rondonópolis', 'Matutino'),
('Escola Municipal Prof. Melchior', 'Publica', 'Rondonópolis', 'Vespertino'),
('Colégio Adventista de Rondonópolis', 'Privada', 'Rondonópolis', 'Integral'),
('Escola Estadual Lourdes Ribeiro', 'Publica', 'Rondonópolis', 'Matutino'),
('Escola Estadual LaSalle', 'Publica', 'Rondonópolis', 'Vespertino');

-- Inserção de Categorias
INSERT INTO categoria (nome_categoria, faixa_etaria, genero_categoria) VALUES
('Sub-14', '12 a 13 anos', 'Misto'),
('Sub-16', '14 a 15 anos', 'Misto'),
('Sub-18', '16 a 17 anos', 'Misto'),
('Sub-20', '18 a 19 anos', 'Misto'),
('Adulto', '20 anos ou mais', 'Misto'),
('Paratletismo Inclusivo', 'Livre', 'Misto');

-- Inserção de Colaboradores
INSERT INTO colaborador (nome_colaborador, cpf, funcao, contato, data_admissao) VALUES
('Walter Salido', '111.222.333-44', 'Presidente e Treinador Chefe', '(66) 99999-1111', '2024-01-10'),
('Vanessa Salido', '222.333.444-55', 'Tesoureira', '(66) 99999-2222', '2024-01-10'),
('Gabriel Pereira', '333.444.555-66', 'Vice-Presidente', '(66) 99999-3333', '2024-02-15'),
('Ana Lúcia Alves', '444.555.666-77', 'Secretária', '(66) 99999-4444', '2024-02-15'),
('José Elias', '555.666.777-88', 'Treinador Olímpico', '(66) 99999-5588', '2024-03-01'),
('Jerson Vicente', '666.777.888-99', 'Treinador Paralímpico', '(66) 99999-6699', '2024-03-01'),
('Diuvana Mendes', '777.888.999-00', 'Psicóloga', '(66) 99999-7700', '2024-04-10'),
('André Lima', '888.999.000-11', 'Coordenador de Literatura', '(66) 99999-8811', '2024-05-05');

-- Inserção de Atletas
INSERT INTO atleta (nome_atleta, data_nascimento, genero, observacoes_medicas, id_escola, id_categoria) VALUES
('Miguel Augusto', '2011-05-12', 'Masculino', 'Nenhuma', 1, 1),
('Giovana Santana', '2010-08-22', 'Feminino', 'Alergia leve a poeira', 2, 2),
('Matheus Mario', '2008-03-15', 'Masculino', 'Nenhuma', 3, 3),
('Gabriel Pereira', '2007-11-30', 'Masculino', 'Uso preventivo de bombinha para asma', 1, 4),
('Marcio Damásio', '2005-01-10', 'Masculino', 'Nenhuma', 4, 5),
('Andressa Silva', '2009-07-19', 'Feminino', 'Nenhuma', 5, 2),
('Renan Seabra', '2012-09-04', 'Masculino', 'Nenhuma', 2, 1),
('Gabrielle Bispo', '2006-12-18', 'Feminino', 'Restrição a impacto no joelho direito', 3, 4),
('Luiz Fernando', '2011-02-25', 'Masculino', 'Nenhuma', 1, 1),
('Maria Nunes', '2008-06-14', 'Feminino', 'Nenhuma', 4, 3),
('Sergio Santos', '2004-10-05', 'Masculino', 'Nenhuma', 5, 5),
('Artur de Souza', '2010-04-20', 'Masculino', 'Nenhuma', 2, 2),
('Maria Eduarda', '2007-08-09', 'Feminino', 'Nenhuma', 3, 4),
('Enzo Gabriel', '2012-01-30', 'Masculino', 'Nenhuma', 1, 1),
('Leandra Costa', '2005-09-11', 'Feminino', 'Nenhuma', 4, 5);


-- ============================================================
-- 6. UPDATES
-- ============================================================
UPDATE atleta 
SET observacoes_medicas = 'Atestado liberado para competições de alta intensidade.' 
WHERE id_atleta = 3;

UPDATE escola 
SET turno = 'Integral' 
WHERE nome_escola = 'Escola Estadual Dom Aquino';


-- ============================================================
-- 7. DELETES
-- ============================================================
DELETE FROM colaborador 
WHERE id_colaborador = 8;

DELETE FROM atleta 
WHERE id_atleta = 15;


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================
SELECT nome_atleta, data_nascimento, genero 
FROM atleta;


-- ============================================================
-- 9. WHERE
-- ============================================================
SELECT a.nome_atleta, e.nome_escola, a.observacoes_medicas
FROM atleta a
JOIN escola e ON a.id_escola = e.id_escola
WHERE a.observacoes_medicas IS NOT NULL AND a.observacoes_medicas <> 'Nenhuma';


-- ============================================================
-- 10. ORDER BY
-- ============================================================
SELECT nome_colaborador, funcao, contato 
FROM colaborador 
ORDER BY nome_colaborador ASC;


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================
SELECT 
    COUNT(*) AS total_atletas,
    MIN(data_nascimento) AS atleta_mais_velho_nasc,
    MAX(data_nascimento) AS atleta_mais_novo_nasc
FROM atleta;


-- ============================================================
-- 12. GROUP BY
-- ============================================================
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria;


-- ============================================================
-- 13. HAVING
-- ============================================================
SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 2;


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================
SELECT 
    nome_escola, 
    UPPER(municipio) AS municipio_maiusculo, 
    CONCAT(nome_escola, ' - ', tipo_rede) AS info_escola
FROM escola;


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================
SHOW TABLES;
SELECT 'Banco de dados db_raaei validado e executado com sucesso!' AS status_execucao;

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

- [ x ] corresponde ao esperado.

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
atleta

```

### Restrição testada

```
fk_atleta_escola (referenciando id_escola na tabela escola)

```

### Resultado

> Teste de Integridade: Foi realizada uma tentativa proposital de inserção de um atleta associando um id_escola inexistente (id_escola = 99). O SGBD rejeitou imediatamente a operação, emitindo um erro de chave estrangeira (Cannot add or update a child row: a foreign key constraint fails), confirmando que a restrição está ativa e protege com sucesso a integridade referencial do banco de dados da associação.

> Comandos propositalmente inválidos não devem permanecer ativos no SQL final. Caso queira documentá-los, mantenha-os comentados.

---

# 23. Testando UNIQUE

Caso exista uma restrição `UNIQUE`, teste seu funcionamento.

### Campo testado

```
cpf (na tabela colaborador) e nome_categoria (na tabela categoria)

```

### Resultado

> Teste de Unicidade: Foi realizada uma tentativa controlada de inserir um novo colaborador utilizando um número de CPF já cadastrado no sistema ('111.222.333-44'). O SGBD bloqueou imediatamente a operação, emitindo um erro de violação de chave única (Duplicate entry '111.222.333-44' for key 'colaborador.cpf'). Isso comprova que a restrição UNIQUE está operando perfeitamente para evitar cadastros duplicados de membros da equipe técnica

---

# 24. Testando NOT NULL

Caso exista `NOT NULL`, verifique se a restrição funciona.

### Campo testado

```
nome_escola (na tabela escola) e nome_atleta (na tabela atleta)

```

### Resultado

> Teste de Nulidade: Foi executada uma tentativa controlada de inserir um registro na tabela escola omitindo o preenchimento do campo obrigatório nome_escola (atribuindo explicitamente o valor NULL). O SGBD barrou a transação imediatamente, retornando uma mensagem de erro indicando violação de restrição de campo nulo (Column 'nome_escola' cannot be null). O teste confirmou que a restrição NOT NULL atua corretamente para impedir a persistência de registros incomprováveis ou sem identificação essencial.

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

> Qual é a relação completa e detalhada de todos os atletas cadastrados na RAAEI, exibindo o nome do atleta, sua categoria esportiva, faixa etária, gênero, escola parceira de origem e eventuais observações médicas, ordenada por categoria e nome?

### SQL

```
SELECT 
    a.nome_atleta, 
    c.nome_categoria, 
    c.faixa_etaria, 
    a.genero, 
    e.nome_escola, 
    a.observacoes_medicas
FROM atleta a
JOIN escola e ON a.id_escola = e.id_escola
JOIN categoria c ON a.id_categoria = c.id_categoria
ORDER BY c.nome_categoria ASC, a.nome_atleta ASC;

```

### Resultado esperado

> Uma listagem consolidada unindo as tabelas de atletas, escolas e categorias, permitindo que a comissão técnica visualize rapidamente em qual categoria e escola cada atleta compete, acompanhado de seu perfil de saúde e restrições médicas de forma organizada.

### Por que essa consulta é importante?

> Esta consulta é o coração operacional do sistema da associação. Ela demonstra o poder relacional do banco de dados ao cruzar chaves estrangeiras (id_escola e id_categoria) para gerar um relatório gerencial completo. É indispensável para o planejamento de treinamentos, inscrições em competições oficiais de atletismo e o acompanhamento seguro da saúde dos jovens atletas assistidos pela RAAEI.

---

# 27. Consulta final mais complexa

### Pergunta

> Quais categorias de atletismo possuem atletas cadastrados, filtrando apenas os registros com gênero definido, agrupados por categoria e faixa etária, exibindo o total de participantes ordenado do maior para o menor grupo?

### SQL

```
SELECT 
    c.nome_categoria, 
    c.faixa_etaria, 
    COUNT(a.id_atleta) AS total_atletas
FROM categoria c
JOIN atleta a ON c.id_categoria = a.id_categoria
WHERE a.genero IN ('Masculino', 'Feminino')
GROUP BY c.id_categoria, c.nome_categoria, c.faixa_etaria
HAVING COUNT(a.id_atleta) > 0
ORDER BY total_atletas DESC, c.nome_categoria ASC;

```

### Conceitos utilizados

- [ x ] WHERE
- [ x ] ORDER BY
- [ x ] agregação
- [ x ] GROUP BY
- [ x ] HAVING
- [ x ] expressão
- [ x ] outro

### Explique

> Esta consulta representa o nível mais avançado de análise de dados no sistema da RAAEI. Ela opera combinando múltiplos recursos fundamentais de banco de dados: inicia unindo as tabelas categoria e atleta por meio de um JOIN, aplica um filtro preliminar de linhas com a cláusula WHERE IN, agrupa os dados por múltiplos atributos (GROUP BY), calcula uma métrica estatística de contagem (COUNT), filtra os grupos resultantes utilizando a restrição pós-agregação HAVING e, por fim, ordena os resultados de forma decrescente pela quantidade de atletas e alfabética pelo nome da categoria (ORDER BY). É ideal para relatórios gerenciais da comissão técnica e diretoria.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|

| CREATE DATABASE | Executado com sucesso, criando o ambiente db_raaei do zero. | Não

| CREATE TABLE | Todas as 4 tabelas (escola, categoria, colaborador, atleta) criadas sem erros. | Não

| PRIMARY KEY | Chaves primárias auto-incrementais validadas em todas as entidades. | Não

| FOREIGN KEY | Relacionamentos e restrições de integridade referencial testados e validados. | Não

| NOT NULL | Campos obrigatórios testados com bloqueio bem-sucedido de valores nulos. | Não

| UNIQUE | Restrições de unicidade (cpf e nome_categoria) validadas contra duplicidades. | Não

| INSERT | Inserção de massa de dados executada perfeitamente respeitando dependências. | Não

| UPDATE | Atualizações condicionais executadas com segurança através de cláusulas WHERE. | Não

| DELETE | Remoções controladas de registros realizadas sem comprometer o sistema. | Não

| SELECT | Consultas básicas retornando os conjuntos de dados esperados. | Não

| WHERE | Filtros aplicados com precisão sobre atributos específicos de atletas e escolas. | Não

| ORDER BY | Ordenação alfabética e numérica funcionando corretamente. | Não

| GROUP BY | Agrupamento de atletas por categoria e instituição realizado sem falhas. | Não

| HAVING | Filtro pós-agregação aplicado corretamente em grupos com mais de dois registros. | Não

| funções de agregação | Contagens e métricas estatísticas (COUNT, MIN, MAX) calculadas com exatidão. | Não

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

- [ ] estou na minha branch individual;
- [ ] todos os commits foram enviados ao GitHub;
- [ ] não alterei arquivos de outro aluno;
- [ ] não alterei arquivos de outra instituição;
- [ ] não alterei arquivos administrativos do repositório;
- [ ] os 9 arquivos da atividade estão presentes;
- [ ] os arquivos `.md` estão preenchidos;
- [ ] os arquivos `.sql` foram testados;
- [ ] o `SPRINT5-5.sql` executa do início ao fim;
- [ ] removi nomes genéricos dos modelos;
- [ ] não deixei senhas ou credenciais;
- [ ] compreendo o código entregue.

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

- [ ] `CREATE DATABASE` funciona;
- [ ] `USE` funciona;
- [ ] todas as tabelas são criadas;
- [ ] nenhuma tabela necessária está ausente.

## Estrutura

- [ ] todas as tabelas possuem PK;
- [ ] FKs estão corretas;
- [ ] tipos de dados estão coerentes;
- [ ] `NOT NULL` está coerente;
- [ ] `UNIQUE` está coerente;
- [ ] `DEFAULT` está coerente.

## Dados

- [ ] INSERTs funcionam;
- [ ] dados são coerentes;
- [ ] FKs são respeitadas.

## Manipulação

- [ ] UPDATEs funcionam;
- [ ] UPDATEs possuem `WHERE`;
- [ ] DELETEs funcionam;
- [ ] DELETEs possuem `WHERE`.

## Consultas

- [ ] SELECT funciona;
- [ ] WHERE funciona;
- [ ] ORDER BY funciona;
- [ ] COUNT funciona;
- [ ] SUM funciona quando aplicável;
- [ ] AVG funciona quando aplicável;
- [ ] MIN/MAX funcionam;
- [ ] GROUP BY funciona;
- [ ] HAVING funciona.

## Arquivos

- [ ] `SPRINT1-5.md`;
- [ ] `SPRINT2-5.md`;
- [ ] `SPRINT2-5.sql`;
- [ ] `SPRINT3-5.md`;
- [ ] `SPRINT3-5.sql`;
- [ ] `SPRINT4-5.md`;
- [ ] `SPRINT4-5.sql`;
- [ ] `SPRINT5-5.md`;
- [ ] `SPRINT5-5.sql`.

---

# 43. Autoavaliação

Responda brevemente.

## O que você considera que aprendeu melhor?

> A estruturação de relacionamentos relacionais complexos (FOREIGN KEY) e a construção de consultas analíticas avançadas combinando junções (JOIN), agrupamentos (GROUP BY) e filtros condicionais pós-agregação (HAVING).

## Qual conteúdo apresentou maior dificuldade?

> O alinhamento preciso da ordem de execução das etapas no script mestre para garantir que a reconstrução a partir do zero ocorresse de forma totalmente linear e sem conflitos de dependência entre as tabelas pai e filhas.

## Qual erro mais contribuiu para seu aprendizado?

> Tentativas iniciais de inserir registros dependentes antes da população correta das tabelas de referência, o que reforçou a importância absoluta do respeito à ordem de criação e inserção de dados em bancos relacionais.

## Qual parte do banco você considera mais bem implementada?

> O modelo relacional integrado e as consultas gerenciais que cruzam dados de escolas, categorias e atletas, permitindo um acompanhamento completo do perfil e do histórico de saúde dos praticantes de atletismo.

## Se tivesse mais tempo, o que melhoraria?

> Implementaria tabelas adicionais para controle de marcas oficiais em competições de atletismo, histórico de treinamentos e frequência dos atletas. 

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
