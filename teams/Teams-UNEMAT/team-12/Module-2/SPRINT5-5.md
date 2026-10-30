# SPRINT 5/5 — Triggers, Transações, Integração e Validação Final

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT5-5.md` + `SPRINT5-5.sql`

---

# Objetivo da Sprint 5/5

Nesta Sprint final do `Module-2`, cada aluno deverá:

1. implementar ao menos um `TRIGGER`;
2. trabalhar com transações;
3. demonstrar `COMMIT`;
4. demonstrar `ROLLBACK`;
5. integrar os conteúdos do módulo;
6. testar todo o código;
7. preparar a entrega final via Pull Request.

Serão trabalhados:

```sql
CREATE TRIGGER
BEFORE INSERT
AFTER INSERT
BEFORE UPDATE
AFTER UPDATE
START TRANSACTION
COMMIT
ROLLBACK
```

---

# 1. Identificação

**Nome completo:**

> João Guilherme Barros de Lima

**Banco utilizado:**

```text
real_estate_database
```

---

# 2. Revisão do Module-2

| Sprint | Conteúdo | Concluído? |
|---|---|---|
| 1/5 | JOINs | Sim |
| 2/5 | Subconsultas | Sim |
| 3/5 | Views | Sim |
| 4/5 | Procedures e Functions | Sim |
| 5/5 | Triggers e Transações | Sim |

---

# 3. Planejando um TRIGGER

O Trigger deverá representar uma regra ou automação coerente com o domínio.

Exemplos possíveis:

```text
registrar histórico após alteração
atualizar estoque
impedir valor inválido
registrar auditoria
atualizar status automaticamente
registrar data de modificação
```

**Regra escolhida:**

> Registrar automaticamente, em uma tabela de histórico, toda mudança de status de um agendamento (status anterior, status novo e data/hora da mudança). Assim fica o rastro de quando uma visita foi confirmada, cancelada ou reaberta, sem depender de quem altera lembrar de anotar.

**Evento:**

- [ ] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [x] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
agendamento (o trigger grava na tabela de histórico historico_agendamento)
```

---

# 4. Implementação do TRIGGER

Estrutura geral:

```sql
DELIMITER //

CREATE TRIGGER nome_trigger
BEFORE INSERT ON nome_tabela
FOR EACH ROW
BEGIN
    -- lógica
END //

DELIMITER ;
```

**SQL do seu Trigger:**

```sql
CREATE TABLE historico_agendamento (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_agendamento INT NOT NULL,
    status_anterior VARCHAR(50) NOT NULL,
    status_novo VARCHAR(50) NOT NULL,
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_agendamento_historico_status
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_agendamento
            (id_agendamento, status_anterior, status_novo)
        VALUES
            (OLD.id_agendamento, OLD.status, NEW.status);
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> 1. `CREATE TABLE historico_agendamento`: tabela de auditoria que guarda o rastro das mudanças. `id_historico` é a chave primária (AUTO_INCREMENT), `status_anterior` e `status_novo` guardam os dois lados da mudança, e `data_alteracao` tem `DEFAULT CURRENT_TIMESTAMP`, então o próprio MySQL preenche a data e a hora. O campo `id_agendamento` não tem FOREIGN KEY de propósito: o histórico precisa continuar existindo mesmo que o agendamento seja excluído depois.
> 2. `DELIMITER //`: troca o terminador de comando para `//`, para que os `;` de dentro do trigger não encerrem o `CREATE TRIGGER` antes da hora (mesma razão da Sprint 4/5).
> 3. `CREATE TRIGGER trg_agendamento_historico_status`: cria o trigger e dá um nome a ele.
> 4. `AFTER UPDATE ON agendamento`: define quando ele dispara: depois que um UPDATE na tabela agendamento altera uma linha. Usei AFTER porque só quero registrar uma mudança que de fato foi gravada; se o UPDATE falhar, nada é registrado.
> 5. `FOR EACH ROW`: o corpo roda uma vez para cada linha afetada. Um UPDATE que altera 2 agendamentos dispara o trigger 2 vezes.
> 6. `BEGIN ... END //`: delimita o corpo do trigger, que pode ter vários comandos.
> 7. `IF OLD.status <> NEW.status THEN`: `OLD` representa a linha antes do UPDATE e `NEW` representa a linha depois. A condição só é verdadeira se o status mudou de verdade. Um UPDATE que não altera o status (ou que mexe em outra coluna) não gera histórico.
> 8. `INSERT INTO historico_agendamento (...) VALUES (OLD.id_agendamento, OLD.status, NEW.status)`: grava o id do agendamento, o status que ele tinha (`OLD.status`) e o status novo (`NEW.status`). A data é preenchida sozinha pelo DEFAULT.
> 9. `END IF;` e `END //`: fecham o IF e o trigger. `DELIMITER ;` devolve o terminador ao padrão.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
SELECT * FROM historico_agendamento;
SELECT id_agendamento, status FROM agendamento WHERE id_agendamento = 2;
```

**Operação executada:**

```sql
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 2;

-- mesmo valor de novo: o IF do trigger deve impedir o registro
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 2;

-- reversão, para manter os dados originais do banco
UPDATE agendamento SET status = 'Pendente' WHERE id_agendamento = 2;
```

**Estado depois do teste:**

```sql
SELECT * FROM historico_agendamento;
```

**Resultado observado:**

> Antes: o histórico estava vazio e o agendamento 2 estava "Pendente". Depois do 1º UPDATE, o trigger gravou uma linha no histórico (agendamento 2, de "Pendente" para "Confirmado", com a data e a hora preenchidas automaticamente). O 2º UPDATE repetiu o mesmo status, então o `IF OLD.status <> NEW.status` foi falso e o histórico continuou com 1 linha. O 3º UPDATE, que devolveu o agendamento 2 para "Pendente", gerou a segunda linha ("Confirmado" para "Pendente"). Ao final, o histórico tinha 2 linhas e o agendamento 2 voltou ao estado original. Nenhum desses UPDATEs chamou o histórico: foi o trigger que gravou sozinho.

---

# 6. START TRANSACTION

Uma transação permite tratar um conjunto de operações como uma unidade.

Estrutura:

```sql
START TRANSACTION;

-- operação 1
-- operação 2

COMMIT;
```

---

# 7. Teste com COMMIT

Crie uma transação coerente com o domínio.

**Objetivo:**

> Confirmar as duas visitas da Chácara (agendamentos 2 e 3) como uma única unidade de trabalho: ou as duas passam para "Confirmado", ou nenhuma passa. As alterações são feitas pela procedure `sp_atualizar_status_agendamento`.

```sql
SELECT COUNT(*) AS pendentes_antes FROM vw_agendamentos_pendentes;

START TRANSACTION;

CALL sp_atualizar_status_agendamento(2, 'Confirmado');
CALL sp_atualizar_status_agendamento(3, 'Confirmado');

COMMIT;

SELECT COUNT(*) AS pendentes_depois FROM vw_agendamentos_pendentes;
```

**O que aconteceu após o COMMIT?**

> Antes da transação havia 4 agendamentos pendentes; depois do COMMIT sobraram 2 (os agendamentos 4 e 6). O COMMIT tornou as duas alterações permanentes e visíveis para qualquer outra conexão. O trigger também registrou as duas mudanças no histórico, porque ele roda dentro da mesma transação. Depois do teste, devolvi os dois agendamentos para "Pendente" com um UPDATE comum, para manter os dados originais do banco.

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
START TRANSACTION;

DELETE FROM agendamento WHERE id_cliente = 1;
UPDATE agendamento SET status = 'Cancelado' WHERE id_agendamento = 4;

SELECT COUNT(*) AS agendamentos_durante FROM agendamento;
SELECT COUNT(*) AS historico_durante FROM historico_agendamento;

ROLLBACK;
```

**Verificação antes:**

```sql
SELECT COUNT(*) AS agendamentos_antes FROM agendamento;
SELECT COUNT(*) AS historico_antes FROM historico_agendamento;
```

**Verificação depois:**

```sql
SELECT COUNT(*) AS agendamentos_depois FROM agendamento;
SELECT COUNT(*) AS historico_depois FROM historico_agendamento;
```

**O que o ROLLBACK fez?**

> Antes da transação havia 5 agendamentos e 6 linhas no histórico. Dentro da transação, o DELETE removeu os 2 agendamentos do cliente 1 (restaram 3) e o UPDATE cancelou o agendamento 4, o que fez o trigger gravar mais uma linha no histórico (7). O ROLLBACK desfez tudo: os 2 agendamentos voltaram (5), o agendamento 4 voltou a "Pendente" e a linha que o trigger tinha gravado também foi desfeita (6), porque o trigger faz parte da transação. Nada do que aconteceu dentro da transação chegou a ser gravado.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> O COMMIT encerra a transação confirmando tudo o que foi feito desde o START TRANSACTION. A partir dele as alterações ficam gravadas de forma permanente e passam a ser vistas por outras conexões. Não dá para desfazer um COMMIT com ROLLBACK.

## ROLLBACK

> O ROLLBACK encerra a transação descartando tudo o que foi feito desde o START TRANSACTION. O banco volta ao estado que tinha antes da transação, como se nenhum dos comandos tivesse sido executado. Só funciona para o que ainda não recebeu COMMIT.

## Por que transações são importantes?

> Porque várias operações que dependem umas das outras precisam acontecer por inteiro ou não acontecer: se o terceiro comando falha no meio de cinco, o ROLLBACK evita que o banco fique com metade das alterações. Isso protege a consistência dos dados contra falhas e erros de quem executa. No meu projeto, confirmar as duas visitas da Chácara ou desfazer uma exclusão feita por engano são exemplos disso. Um detalhe importante: o ROLLBACK só tem efeito dentro de uma transação aberta com START TRANSACTION; com o autocommit ligado (padrão), cada comando é gravado na hora.

---

# 10. Integração do Module-2

O `SPRINT5-5.sql` deverá integrar os principais conteúdos do módulo.

Estrutura esperada:

```text
1. USE banco
2. consultas com JOIN
3. subconsultas
4. Views
5. Procedures
6. Function
7. Trigger
8. teste de COMMIT
9. teste de ROLLBACK
10. consultas de validação
```

> Não é necessário duplicar todo o código do `Module-1`. O objetivo deste arquivo é integrar o que foi desenvolvido no `Module-2` utilizando o banco já existente.

---

# 11. Consulta relacional final

**Pergunta:**

> Quais clientes agendaram visita, em qual imóvel, e quem é o corretor responsável por esse imóvel?

```sql
SELECT
    cl.nome AS cliente,
    i.titulo AS imovel,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;
```

**Explique:**

> A consulta parte de agendamento e liga, por INNER JOIN, o cliente (pela FK id_cliente), o imóvel (pela FK id_imovel) e, a partir do imóvel, o corretor (pela FK id_corretor). Cada JOIN usa a chave estrangeira certa no ON; sem essa condição o MySQL combinaria linhas que não têm relação. O resultado é uma linha por visita, com todo o contexto necessário em uma única tela.

---

# 12. Subconsulta final

**Pergunta:**

> Quais imóveis nunca receberam nenhum agendamento de visita?

```sql
SELECT titulo
FROM imovel AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);
```

**Explique:**

> É uma subconsulta correlacionada: para cada imóvel da consulta externa, a subconsulta procura se existe algum agendamento com aquele id_imovel. O NOT EXISTS deixa o imóvel no resultado somente quando essa busca não encontra nada. Com os dados atuais, apenas o "Terreno amplo" aparece. É útil para o negócio porque aponta os anúncios que ninguém procurou.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_agendamentos_detalhados
```

**Por que é importante?**

> Porque guarda o JOIN de 4 tabelas (agendamento, cliente, imovel e corretor) já pronto: quem usa a VIEW consulta cliente, imóvel, cidade, corretor, data e status com um simples SELECT, sem precisar conhecer as chaves nem repetir o JOIN. E, como a VIEW não guarda dados, ela sempre reflete o estado atual das tabelas.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_atualizar_status_agendamento
```

**Entrada:**

```text
p_id_agendamento INT
p_novo_status VARCHAR(50)
```

**Resultado:**

> Altera o status do agendamento informado, mas só depois de validar se ele existe e se o novo status é permitido (Pendente, Confirmado ou Cancelado). Devolve uma mensagem: "Status atualizado com sucesso", "Status inválido" ou "Agendamento não encontrado". Como o UPDATE mexe na tabela agendamento, ela também aciona o trigger de histórico.

---

# 15. Function final

**Nome:**

```text
fn_comissao_corretor
```

**O que retorna?**

> Retorna um DECIMAL(10,2) com a comissão de 5% sobre o valor recebido em p_valor (por exemplo, 22500.00 para um imóvel de R$ 450.000,00). Por ser uma function, pode ser usada dentro de um SELECT, como em `SELECT titulo, valor, fn_comissao_corretor(valor) FROM imovel`.

---

# 16. Trigger final

**Nome:**

```text
trg_agendamento_historico_status
```

**Regra automatizada:**

> Sempre que o status de um agendamento muda, o MySQL grava automaticamente uma linha em historico_agendamento com o id do agendamento, o status anterior, o status novo e a data/hora. UPDATEs que não alteram o status não geram registro.

---

# 17. Teste operacional final

O aluno deverá executar o projeto no MySQL Workbench e verificar:

- [x] JOINs funcionam;
- [x] subconsultas funcionam;
- [x] Views funcionam;
- [x] Procedures funcionam;
- [x] Function funciona;
- [x] Trigger funciona;
- [x] COMMIT funciona;
- [x] ROLLBACK funciona.

---

# 18. Validação prática/oral

O código do aluno poderá ser selecionado pelo professor para:

```text
EXECUTAR
EXPLICAR
ALTERAR
TESTAR
CORRIGIR
```

O aluno deverá ser capaz de:

1. explicar uma consulta escolhida pelo professor;
2. alterar um filtro;
3. trocar um parâmetro de uma Procedure;
4. explicar uma View;
5. executar o Trigger;
6. demonstrar `COMMIT` ou `ROLLBACK`;
7. interpretar mensagens de erro.

---

# 19. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro 1442: "Can't update table 'agendamento' in stored function/trigger because it is already used by statement which invoked this stored function/trigger" | O trigger tentava alterar a própria tabela que o disparou (agendamento), o que o MySQL não permite | Gravar o rastro em outra tabela (`historico_agendamento`), que o trigger pode alterar livremente |
| `ROLLBACK` sem efeito: a linha continuou apagada | Sem `START TRANSACTION`, o autocommit (ligado por padrão) grava cada comando na hora, e não há nada pendente para desfazer | Abrir a transação com `START TRANSACTION` antes do `DELETE`/`UPDATE` e só então usar `ROLLBACK` |
| Erro 1359 "Trigger already exists" ao executar o script uma segunda vez | O `CREATE TRIGGER` não substitui um trigger existente, e o MySQL não tem `CREATE OR REPLACE` para triggers | Colocar `DROP TRIGGER IF EXISTS` antes do `CREATE TRIGGER` |

---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> A ideia de transação como "tudo ou nada", e a diferença entre COMMIT (grava de forma definitiva) e ROLLBACK (descarta). Também compreendi que o trigger roda dentro da mesma transação, tanto que o ROLLBACK desfez a linha de histórico que ele gravou.

**Conteúdo mais difícil:**

> Entender o OLD e o NEW dentro do trigger e escolher entre BEFORE e AFTER. Também foi difícil aceitar a restrição de que o trigger não pode alterar a tabela que o disparou (erro 1442).

**Código do Module-2 que considero mais importante:**

> A procedure `sp_atualizar_status_agendamento` junto com o trigger `trg_agendamento_historico_status`: a procedure valida e altera o status, e o trigger registra a mudança sozinho. Os dois juntos mostram como regra de negócio e auditoria podem ficar dentro do banco.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> A diferença entre INNER, LEFT e RIGHT JOIN; IN x EXISTS e por que a subconsulta correlacionada roda uma vez por linha; View x tabela; Procedure x Function; e, principalmente, o fluxo do trigger de histórico e a diferença entre COMMIT e ROLLBACK.

---

# 21. Estrutura recomendada do SPRINT5-5.sql

```sql
-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

-- ============================================================
-- LIMPEZA PARA PERMITIR EXECUTAR O SCRIPT MAIS DE UMA VEZ
-- (a ordem importa: o trigger sai antes da tabela de histórico)
-- ============================================================

DROP TRIGGER IF EXISTS trg_agendamento_historico_status;
DROP TABLE IF EXISTS historico_agendamento;
DROP VIEW IF EXISTS vw_agendamentos_detalhados;
DROP VIEW IF EXISTS vw_resumo_imoveis_corretor;
DROP VIEW IF EXISTS vw_agendamentos_pendentes;
DROP PROCEDURE IF EXISTS sp_listar_imoveis_por_cidade;
DROP PROCEDURE IF EXISTS sp_atualizar_status_agendamento;
DROP PROCEDURE IF EXISTS sp_contar_agendamentos_por_status;
DROP FUNCTION IF EXISTS fn_comissao_corretor;


-- ============================================================
-- JOINS
-- ============================================================

-- Consulta relacional final: cliente, imóvel e corretor de cada visita
SELECT
    cl.nome AS cliente,
    i.titulo AS imovel,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;

-- Corretores com ou sem imóvel
SELECT
    c.nome AS corretor,
    i.titulo AS imovel
FROM imovel AS i
RIGHT JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;


-- ============================================================
-- SUBCONSULTAS
-- ============================================================

-- Subconsulta final: imóveis que nunca receberam visita
SELECT titulo
FROM imovel AS i
WHERE NOT EXISTS (
    SELECT 1
    FROM agendamento AS a
    WHERE a.id_imovel = i.id_imovel
);

-- Subconsulta correlacionada: imóveis acima da média do próprio corretor
SELECT i.titulo, i.valor, i.id_corretor
FROM imovel AS i
WHERE i.valor > (
    SELECT AVG(i2.valor)
    FROM imovel AS i2
    WHERE i2.id_corretor = i.id_corretor
);


-- ============================================================
-- VIEWS
-- ============================================================

CREATE VIEW vw_agendamentos_detalhados AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    i.titulo AS imovel,
    i.cidade,
    c.nome AS corretor,
    a.data_visita,
    a.status
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
INNER JOIN corretor AS c
    ON i.id_corretor = c.id_corretor;

CREATE VIEW vw_resumo_imoveis_corretor AS
SELECT
    c.id_corretor,
    c.nome AS corretor,
    COUNT(i.id_imovel) AS total_imoveis,
    SUM(i.valor) AS valor_total,
    AVG(i.valor) AS valor_medio
FROM corretor AS c
LEFT JOIN imovel AS i
    ON c.id_corretor = i.id_corretor
GROUP BY c.id_corretor, c.nome;

CREATE VIEW vw_agendamentos_pendentes AS
SELECT
    a.id_agendamento,
    cl.nome AS cliente,
    cl.telefone AS telefone_cliente,
    cl.email AS email_cliente,
    i.titulo AS imovel,
    i.valor AS valor_imovel,
    a.data_visita
FROM agendamento AS a
INNER JOIN cliente AS cl
    ON a.id_cliente = cl.id_cliente
INNER JOIN imovel AS i
    ON a.id_imovel = i.id_imovel
WHERE a.status = 'Pendente';

SELECT * FROM vw_agendamentos_detalhados;
SELECT * FROM vw_resumo_imoveis_corretor;
SELECT * FROM vw_agendamentos_pendentes;


-- ============================================================
-- PROCEDURES E FUNCTIONS
-- ============================================================

DELIMITER //

CREATE PROCEDURE sp_listar_imoveis_por_cidade(
    IN p_cidade VARCHAR(100)
)
BEGIN
    SELECT
        id_imovel,
        titulo,
        valor,
        quantidade_comodos
    FROM imovel
    WHERE cidade = p_cidade
    ORDER BY valor ASC;
END //

CREATE PROCEDURE sp_atualizar_status_agendamento(
    IN p_id_agendamento INT,
    IN p_novo_status VARCHAR(50)
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM agendamento
    WHERE id_agendamento = p_id_agendamento;

    IF v_existe = 0 THEN
        SELECT 'Agendamento não encontrado' AS mensagem;
    ELSEIF p_novo_status NOT IN ('Pendente', 'Confirmado', 'Cancelado') THEN
        SELECT 'Status inválido' AS mensagem;
    ELSE
        UPDATE agendamento
        SET status = p_novo_status
        WHERE id_agendamento = p_id_agendamento;

        SELECT 'Status atualizado com sucesso' AS mensagem;
    END IF;
END //

CREATE PROCEDURE sp_contar_agendamentos_por_status(
    IN p_status VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM agendamento
    WHERE status = p_status;
END //

CREATE FUNCTION fn_comissao_corretor(
    p_valor DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_valor * 0.05, 2);
END //

DELIMITER ;

CALL sp_listar_imoveis_por_cidade('Rondonópolis');

CALL sp_contar_agendamentos_por_status('Pendente', @total);
SELECT @total;

SELECT titulo, valor, fn_comissao_corretor(valor) AS comissao
FROM imovel;


-- ============================================================
-- TRIGGER
-- Regra: todo UPDATE que muda o status de um agendamento
-- gera uma linha na tabela de histórico.
-- ============================================================

CREATE TABLE historico_agendamento (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_agendamento INT NOT NULL,
    status_anterior VARCHAR(50) NOT NULL,
    status_novo VARCHAR(50) NOT NULL,
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER trg_agendamento_historico_status
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_agendamento
            (id_agendamento, status_anterior, status_novo)
        VALUES
            (OLD.id_agendamento, OLD.status, NEW.status);
    END IF;
END //

DELIMITER ;

-- Teste do trigger: estado antes
SELECT * FROM historico_agendamento;
SELECT id_agendamento, status FROM agendamento WHERE id_agendamento = 2;

-- Operação: o status muda e o trigger registra
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 2;

-- Estado depois
SELECT * FROM historico_agendamento;

-- UPDATE sem mudança de status: o IF impede o registro
UPDATE agendamento SET status = 'Confirmado' WHERE id_agendamento = 2;
SELECT COUNT(*) AS linhas_no_historico FROM historico_agendamento;

-- Reversão para manter os dados originais do banco
UPDATE agendamento SET status = 'Pendente' WHERE id_agendamento = 2;
SELECT * FROM historico_agendamento;


-- ============================================================
-- TRANSAÇÃO COM COMMIT
-- Confirmar as duas visitas da Chácara (agendamentos 2 e 3)
-- como uma única unidade de trabalho
-- ============================================================

SELECT COUNT(*) AS pendentes_antes FROM vw_agendamentos_pendentes;

START TRANSACTION;

CALL sp_atualizar_status_agendamento(2, 'Confirmado');
CALL sp_atualizar_status_agendamento(3, 'Confirmado');

COMMIT;

SELECT COUNT(*) AS pendentes_depois FROM vw_agendamentos_pendentes;

-- Reversão para manter os dados originais do banco
UPDATE agendamento SET status = 'Pendente' WHERE id_agendamento IN (2, 3);


-- ============================================================
-- TRANSAÇÃO COM ROLLBACK
-- Exclusão e alteração desfeitas antes de serem gravadas
-- ============================================================

SELECT COUNT(*) AS agendamentos_antes FROM agendamento;
SELECT COUNT(*) AS historico_antes FROM historico_agendamento;

START TRANSACTION;

DELETE FROM agendamento WHERE id_cliente = 1;
UPDATE agendamento SET status = 'Cancelado' WHERE id_agendamento = 4;

SELECT COUNT(*) AS agendamentos_durante FROM agendamento;
SELECT COUNT(*) AS historico_durante FROM historico_agendamento;

ROLLBACK;

SELECT COUNT(*) AS agendamentos_depois FROM agendamento;
SELECT COUNT(*) AS historico_depois FROM historico_agendamento;


-- ============================================================
-- VALIDAÇÃO FINAL
-- ============================================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT routine_type, routine_name
FROM information_schema.routines
WHERE routine_schema = 'real_estate_database'
ORDER BY routine_type, routine_name;

SELECT trigger_name, event_manipulation, event_object_table, action_timing
FROM information_schema.triggers
WHERE trigger_schema = 'real_estate_database';

SELECT id_agendamento, status FROM agendamento ORDER BY id_agendamento;
SELECT * FROM historico_agendamento;
```

---

# 22. Arquivos esperados no Module-2

Ao final:

```text
Module-2/
├── SPRINT1-5.md
├── SPRINT1-5.sql
├── SPRINT2-5.md
├── SPRINT2-5.sql
├── SPRINT3-5.md
├── SPRINT3-5.sql
├── SPRINT4-5.md
├── SPRINT4-5.sql
├── SPRINT5-5.md
└── SPRINT5-5.sql
```

Total esperado:

```text
10 arquivos
```

---

# 23. Checklist final

- [x] mantive os arquivos do Module-1;
- [x] utilizei a mesma branch `team-12`;
- [x] concluí as cinco Sprints do Module-2;
- [x] todos os `.md` estão preenchidos;
- [x] todos os `.sql` foram testados;
- [x] JOINs funcionam;
- [x] subconsultas funcionam;
- [x] Views funcionam;
- [x] Procedures funcionam;
- [x] Function funciona;
- [x] Trigger funciona;
- [x] COMMIT e ROLLBACK foram demonstrados;
- [x] compreendo o código entregue;
- [x] revisei os nomes dos arquivos;
- [x] nenhum arquivo foi colocado fora de `Module-2`.

---

# 24. Commit da Sprint 5/5

Mensagem sugerida:

```text
Conclui Module 2 Sprint 5 de 5 - triggers e transacoes
```

---

# 25. Pull Request final do Module-2

Depois da Sprint 5/5, abra o Pull Request.

Origem:

```text
team-12
```

Destino:

```text
main
```

Título — UNEMAT:

```text
[N2][UNEMAT][Team 12] Sprints 1-5 - real_estate_database
```

Título — UFR:

```text
[N2][UFR][Team XX] Sprints 1-5 - Nome do Banco
```

---

# 26. Descrição sugerida do Pull Request

```text
## Identificação

Aluno: João Guilherme Barros de Lima
Instituição: UNEMAT
Branch: team-12
Banco: real_estate_database
Módulo: 2

## Arquivos entregues

- Module-2/SPRINT1-5.md
- Module-2/SPRINT1-5.sql
- Module-2/SPRINT2-5.md
- Module-2/SPRINT2-5.sql
- Module-2/SPRINT3-5.md
- Module-2/SPRINT3-5.sql
- Module-2/SPRINT4-5.md
- Module-2/SPRINT4-5.sql
- Module-2/SPRINT5-5.md
- Module-2/SPRINT5-5.sql

## Validação

- [x] JOINs testados
- [x] Subconsultas testadas
- [x] Views testadas
- [x] Procedures testadas
- [x] Function testada
- [x] Trigger testado
- [x] COMMIT testado
- [x] ROLLBACK testado
```

---

# 27. Uso de LLMs

LLMs podem ser utilizadas como ferramenta de apoio.

Todo código deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

O aluno poderá ser chamado presencialmente para demonstrar qualquer parte entregue.

---

# Critério de conclusão do Module-2

O Module-2 será considerado concluído quando o aluno:

1. entregar as cinco Sprints;
2. possuir os 10 arquivos exigidos;
3. demonstrar evolução em relação ao Module-1;
4. executar os scripts no MySQL Workbench;
5. compreender o código entregue;
6. abrir o Pull Request final;
7. corrigir eventuais falhas apontadas pela validação automática.
