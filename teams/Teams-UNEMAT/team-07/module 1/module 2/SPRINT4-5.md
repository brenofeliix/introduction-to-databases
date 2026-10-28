# SPRINT 4/5 — Stored Procedures e Functions

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT4-5.md` + `SPRINT4-5.sql`

---

# Objetivo da Sprint 4/5

Nesta etapa, cada aluno deverá implementar rotinas reutilizáveis dentro do MySQL.

Serão trabalhados:

```sql
DELIMITER
CREATE PROCEDURE
CALL
IN
OUT
CREATE FUNCTION
RETURN
DECLARE
IF
ELSE
```

O objetivo não é apenas criar rotinas que executem, mas entender:

- qual problema cada rotina resolve;
- quais parâmetros recebe;
- quais operações executa;
- qual resultado produz;
- quando utilizar Procedure;
- quando utilizar Function.

---

# 1. Identificação

**Nome completo:**

> Talita de Oliveira Leite Sete 

**Banco utilizado:**

```text
secretaria_saude
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| sp_atendimentos_por_unidade | Procedure | IN p_id_unidade | Lista de atendimentos | Consultar os atendimentos de uma unidade |
| sp_baixa_estoque | Procedure | IN p_id_item, IN p_quantidade | Mensagem de resultado e item atualizado | Registrar a baixa de estoque com validações |
| fn_situacao_estoque | Function | p_quantidade | BAIXO, MÉDIO ou ALTO | Classificar a situação de um estoque |

---

# 3. DELIMITER

Procedures e Functions podem utilizar múltiplos comandos SQL.

Exemplo:

```sql
DELIMITER //

CREATE PROCEDURE exemplo()
BEGIN
    SELECT * FROM tabela;
END //

DELIMITER ;
```

**Explique por que o `DELIMITER` é utilizado:**

> O MySQL termina cada comando no ;. Dentro de uma procedure há vários comandos com ; (o SELECT, o UPDATE, o END IF). Sem trocar o delimitador, o cliente cortaria a procedure no primeiro ; e daria erro. Com DELIMITER //, o ; passa a fazer parte do corpo e só o // encerra a criação. No final, DELIMITER ; volta ao normal.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Listar os atendimentos de uma unidade, com paciente, profissional, tipo e status, em ordem cronológica.

**Parâmetro de entrada:**

```text
p_id_unidade INT
```

**SQL:**

```sql
-- ============================================================
-- PROCEDURE 1 — parâmetro IN
-- Lista os atendimentos de uma unidade de saúde
-- ============================================================
DROP PROCEDURE IF EXISTS sp_atendimentos_por_unidade //
CREATE PROCEDURE sp_atendimentos_por_unidade(IN p_id_unidade INT)
BEGIN
    SELECT a.id_atendimento, a.data_hora, p.nome AS paciente, pf.nome AS profissional,
           a.tipo_atendimento, a.status
    FROM atendimento AS a
    INNER JOIN paciente     AS p  ON p.id_paciente      = a.id_paciente
    INNER JOIN profissional AS pf ON pf.id_profissional = a.id_profissional
    WHERE a.id_unidade = p_id_unidade
    ORDER BY a.data_hora;
END //
```

**Execução:**

```sql
CALL sp_atendimentos_por_unidade(2);
```

**Resultado esperado:**

> 6 atendimentos da UBS Vila Nova (3 realizados e 3 agendados), do mais antigo ao mais recente.

---

# 5. Procedure 2 — operação do domínio

Crie uma segunda Procedure que represente uma operação útil.

Exemplos:

```text
registrar devolução
listar pagamentos
alterar status
consultar matrícula
buscar reservas
listar produtos de determinada categoria
```

**Objetivo:**

> Registrar a baixa de itens do estoque (ex.: doses aplicadas), recusando operações inválidas.

```sql
-- ============================================================
-- PROCEDURE 2 — operação do domínio, com IF/ELSEIF/ELSE
-- Registra a baixa de uma quantidade de um item do estoque
-- ============================================================
DROP PROCEDURE IF EXISTS sp_baixa_estoque //
CREATE PROCEDURE sp_baixa_estoque(IN p_id_item INT, IN p_quantidade INT)
BEGIN
    DECLARE v_atual INT;

    SELECT quantidade INTO v_atual
    FROM estoque_item
    WHERE id_item = p_id_item;

    IF v_atual IS NULL THEN
        SELECT 'ERRO: item não encontrado' AS resultado;
    ELSEIF p_quantidade <= 0 THEN
        SELECT 'ERRO: a quantidade deve ser maior que zero' AS resultado;
    ELSEIF p_quantidade > v_atual THEN
        SELECT CONCAT('ERRO: estoque insuficiente (disponível: ', v_atual, ')') AS resultado;
    ELSE
        UPDATE estoque_item
        SET quantidade = quantidade - p_quantidade
        WHERE id_item = p_id_item;

        SELECT 'OK: baixa registrada' AS resultado, id_item, nome, quantidade AS quantidade_atual
        FROM estoque_item
        WHERE id_item = p_id_item;
    END IF;
END //

```

**Execução:**

```sql
CALL sp_baixa_estoque(4, 5);
```

---

# 6. Procedure com OUT

Quando aplicável, crie uma Procedure com parâmetro `OUT`.

Exemplo:

```sql
CREATE PROCEDURE contar_registros(
    OUT total INT
)
BEGIN
    SELECT COUNT(*) INTO total
    FROM tabela;
END;
```

Depois:

```sql
CALL contar_registros(@total);
SELECT @total;
```

**SQL do seu projeto:**

```sql
-- ============================================================
-- PROCEDURE 3 — parâmetro OUT
-- Conta os atendimentos de um determinado status
-- ============================================================
DROP PROCEDURE IF EXISTS sp_contar_atendimentos //
CREATE PROCEDURE sp_contar_atendimentos(IN p_status VARCHAR(20), OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM atendimento
    WHERE status = p_status;
    CALL sp_contar_atendimentos('REALIZADO', @total);
SELECT @total;
END //
```

Caso não seja aplicável, justifique:

> Escreva aqui.

---

# 7. Function

Uma `FUNCTION` retorna um valor.

Estrutura genérica:

```sql
CREATE FUNCTION nome_funcao(parametro INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ...;
END;
```

## Function obrigatória

**Objetivo:**

> Classificar a situação do estoque de um item a partir da quantidade, para padronizar a regra “estoque baixo” em qualquer consulta.

**Parâmetro recebido:**

```text
p_quantidade INT
```

**Valor retornado:**

```text
VARCHAR(10): ‘BAIXO’ (< 50), ‘MÉDIO’ (50 a 199) ou ‘ALTO’ (200 ou mais).
```

**SQL:**

```sql
-- ============================================================
-- FUNCTION — classifica a situação do estoque
-- ============================================================
DROP FUNCTION IF EXISTS fn_situacao_estoque //
CREATE FUNCTION fn_situacao_estoque(p_quantidade INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE v_situacao VARCHAR(10);

    IF p_quantidade < 50 THEN
        SET v_situacao = 'BAIXO';
    ELSEIF p_quantidade < 200 THEN
        SET v_situacao = 'MÉDIO';
    ELSE
        SET v_situacao = 'ALTO';
    END IF;

    RETURN v_situacao;
END //

```

**Exemplo de uso:**

```sql
SELECT nome, quantidade, fn_situacao_estoque(quantidade) FROM estoque_item;
```

---

# 8. IF / ELSE

Utilize uma condição em pelo menos uma rotina.

Exemplo:

```sql
IF valor > 0 THEN
    ...
ELSE
    ...
END IF;
```

**Regra de negócio implementada:**

> Na sp_baixa_estoque, a baixa só ocorre se o item existir, a quantidade for maior que zero e não superar o estoque disponível. Nos outros casos, mostra uma mensagem de erro e não altera nada. Na function, o IF/ELSEIF/ELSE define a faixa da quantidade.

```sql
DROP PROCEDURE IF EXISTS sp_baixa_estoque //
CREATE PROCEDURE sp_baixa_estoque(IN p_id_item INT, IN p_quantidade INT)
BEGIN
    DECLARE v_atual INT;

    SELECT quantidade INTO v_atual
    FROM estoque_item
    WHERE id_item = p_id_item;

    IF v_atual IS NULL THEN
        SELECT 'ERRO: item não encontrado' AS resultado;
    ELSEIF p_quantidade <= 0 THEN
        SELECT 'ERRO: a quantidade deve ser maior que zero' AS resultado;
    ELSEIF p_quantidade > v_atual THEN
        SELECT CONCAT('ERRO: estoque insuficiente (disponível: ', v_atual, ')') AS resultado;
    ELSE
        UPDATE estoque_item
        SET quantidade = quantidade - p_quantidade
        WHERE id_item = p_id_item;

        SELECT 'OK: baixa registrada' AS resultado, id_item, nome, quantidade AS quantidade_atual
        FROM estoque_item
        WHERE id_item = p_id_item;
    END IF;
END //
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Rotina chamada com CALL. Pode executar vários comandos, alterar dados (INSERT/UPDATE/DELETE), devolver tabelas de resultado e usar parâmetros IN e OUT. É usada para executar uma operação.

## Function

> Rotina chamada dentro de um SELECT, que devolve um único valor com RETURN. É usada para calcular ou classificar um valor e reutilizá-lo em consultas.

## Quando você utilizaria cada uma no seu projeto?

> Procedure para operações como a baixa de estoque e a consulta de atendimentos por unidade. Function para a classificação do estoque (BAIXO/MÉDIO/ALTO), usada em qualquer relatório.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL sp_atendimentos_por_unidade(2);
CALL sp_atendimentos_por_unidade(5);
```

**Resultados:**

> Unidade 2 retorna 6 atendimentos; unidade 5 (CAPS) retorna 1 (Luciana Ferreira, consulta com a psicóloga). Com a unidade 6 a procedure retorna 0 linhas, porque o posto não tem atendimentos.

## Procedure 2

```sql
CALL sp_baixa_estoque(4, 5);
CALL sp_baixa_estoque(4, 9999);
```

**Resultados:**

> A primeira retorna “OK: baixa registrada” e a Hepatite B passa de 45 para 40. A segunda retorna “ERRO: estoque insuficiente (disponível: 40)” e nada muda. Também testei quantidade 0 (“deve ser maior que zero”) e item 999 (“item não encontrado”). Depois devolvi as 5 doses com um UPDATE.

## Function

```sql
SELECT fn_situacao_estoque(8);
SELECT fn_situacao_estoque(800);
```

**Resultados:**

> 8 retorna BAIXO e 800 retorna ALTO; 50 retorna MÉDIO (o limite é “menor que 50”) e 120 retorna MÉDIO. Aplicada à tabela, 3 itens saem BAIXO, 3 MÉDIO e 4 ALTO.

---

# 11. Validação prática presencial

Escolha uma rotina e prepare-se para:

1. explicar cada parâmetro;
2. alterar um parâmetro durante a aula;
3. executar novamente;
4. explicar por que o resultado mudou;
5. explicar a lógica interna.

**Rotina escolhida:**

```text
sp_baixa_estoque
```

```sql
-- ============================================================
-- PROCEDURE 2 — operação do domínio, com IF/ELSEIF/ELSE
-- Registra a baixa de uma quantidade de um item do estoque
-- ============================================================
DROP PROCEDURE IF EXISTS sp_baixa_estoque //
CREATE PROCEDURE sp_baixa_estoque(IN p_id_item INT, IN p_quantidade INT)
BEGIN
    DECLARE v_atual INT;

    SELECT quantidade INTO v_atual
    FROM estoque_item
    WHERE id_item = p_id_item;

    IF v_atual IS NULL THEN
        SELECT 'ERRO: item não encontrado' AS resultado;
    ELSEIF p_quantidade <= 0 THEN
        SELECT 'ERRO: a quantidade deve ser maior que zero' AS resultado;
    ELSEIF p_quantidade > v_atual THEN
        SELECT CONCAT('ERRO: estoque insuficiente (disponível: ', v_atual, ')') AS resultado;
    ELSE
        UPDATE estoque_item
        SET quantidade = quantidade - p_quantidade
        WHERE id_item = p_id_item;

        SELECT 'OK: baixa registrada' AS resultado, id_item, nome, quantidade AS quantidade_atual
        FROM estoque_item
        WHERE id_item = p_id_item;
    END IF;
END //

```

---

# 12. Quantidade mínima exigida

O `SPRINT4-5.sql` deverá conter no mínimo:

```text
2 Stored Procedures
1 Function
1 rotina com parâmetro IN
1 uso de IF/ELSE
1 rotina com OUT, quando aplicável
2 testes por rotina
```

---

# 13. Estrutura recomendada do SPRINT4-5.sql

```sql
-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluno:
-- Banco:

USE nome_do_banco;

DELIMITER //

-- PROCEDURE 1

-- PROCEDURE 2

-- PROCEDURE COM OUT

-- FUNCTION

DELIMITER ;

-- TESTES COM CALL

-- TESTES COM SELECT
```

---

# 14. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

---

# 15. Uso de LLMs

LLMs podem ser utilizadas como ferramenta de apoio, mas toda rotina deverá ser compreendida e testada.

Fluxo obrigatório:

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

---

# 16. Checklist

- [ ] utilizei o banco do projeto;
- [ ] compreendi o uso do `DELIMITER`;
- [ ] criei pelo menos 2 Procedures;
- [ ] criei uma Function;
- [ ] utilizei parâmetro `IN`;
- [ ] utilizei `OUT` quando aplicável;
- [ ] utilizei `IF/ELSE`;
- [ ] testei cada rotina;
- [ ] executei parâmetros diferentes;
- [ ] consigo explicar todas as rotinas;
- [ ] salvei `SPRINT4-5.md`;
- [ ] salvei `SPRINT4-5.sql`.

---

# 17. Git/GitHub

Continue na mesma branch:

```text
team-XX
```

Arquivos:

```text
Module-2/SPRINT4-5.md
Module-2/SPRINT4-5.sql
```

Commit sugerido:

```text
Conclui Module 2 Sprint 4 de 5 - procedures e functions
```

**Não abra o Pull Request final ainda.**

---

# Próxima etapa

Na Sprint 5/5 serão trabalhados:

```sql
TRIGGER
START TRANSACTION
COMMIT
ROLLBACK
```

e será realizada a integração final do `Module-2`.
