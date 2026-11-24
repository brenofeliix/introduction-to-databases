# SPRINT 4/5 — Stored Procedures e Functions

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT4-5.md` + `SPRINT4-5.sql`

---

# Objetivo da Sprint 4/5

Criar rotinas reutilizáveis dentro do MySQL: Procedures (`CALL`, parâmetros `IN`/`OUT`, `IF/ELSE`, `DECLARE`) e Functions (`RETURNS`/`RETURN`).

---

# 1. Identificação

**Nome completo:**

> Gabriel Sakaizawa Campos

**Banco utilizado:**

```text
db_restaurante_sabor
```

---

# 2. Planejamento das rotinas

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| `sp_pedidos_do_cliente` | Procedure | `p_id_cliente` (IN) | tabela com pedidos e total | Listar os pedidos de um cliente |
| `sp_alterar_status_pedido` | Procedure | `p_id_pedido`, `p_novo_status` (IN) | mensagem de resultado | Mudar o status de um pedido com validação |
| `sp_total_do_pedido` | Procedure | `p_id_pedido` (IN) | `p_total` (OUT) | Devolver o total de um pedido em variável |
| `fn_total_pedido` | Function | `p_id_pedido` | `DECIMAL(10,2)` | Calcular o total de um pedido |
| `fn_faixa_pedido` | Function | `p_id_pedido` | `VARCHAR` | Classificar o pedido em Alto/Médio/Baixo |

---

# 3. DELIMITER

**Explique por que o `DELIMITER` é utilizado:**

> O MySQL termina cada comando no `;`. Dentro de uma Procedure há vários comandos terminados em `;`, e o MySQL cortaria a criação no primeiro deles. Com `DELIMITER //` eu digo que o fim do comando agora é `//`, então o bloco `BEGIN ... END` inteiro é enviado de uma vez. No final volto com `DELIMITER ;`.


---

# 4. Procedure 1 — parâmetro IN

**Objetivo:**

> Listar os pedidos de um cliente com o valor total de cada um.

**Parâmetro de entrada:**

```text
p_id_cliente INT
```

**SQL:**

```sql
DELIMITER //

-- PROCEDURE 1 (parametro IN): lista os pedidos de um cliente com o total de cada um
CREATE PROCEDURE sp_pedidos_do_cliente(IN p_id_cliente INT)
BEGIN
    SELECT p.id_pedido, p.data_pedido, p.status,
           SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
    FROM pedido AS p
    INNER JOIN item_pedido AS ip ON p.id_pedido = ip.id_pedido
    WHERE p.id_cliente = p_id_cliente
    GROUP BY p.id_pedido, p.data_pedido, p.status
    ORDER BY p.id_pedido;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_pedidos_do_cliente(1);
```

**Resultado esperado:**

> Para o cliente 1 (Ana Souza): pedido 1 (finalizado, R$ 103,80) e pedido 3 (aberto, R$ 57,90).

---

# 5. Procedure 2 — operação do domínio

**Objetivo:**

> Alterar o status de um pedido (aberto, finalizado ou cancelado), avisando se o pedido não existe ou se o status é inválido.

```sql
DELIMITER //

-- PROCEDURE 2 (operacao do dominio + IF/ELSE): altera o status de um pedido
CREATE PROCEDURE sp_alterar_status_pedido(
    IN p_id_pedido INT,
    IN p_novo_status VARCHAR(20)
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM pedido
    WHERE id_pedido = p_id_pedido;

    IF v_existe = 0 THEN
        SELECT CONCAT('Pedido ', p_id_pedido, ' nao encontrado') AS resultado;
    ELSEIF p_novo_status NOT IN ('aberto', 'finalizado', 'cancelado') THEN
        SELECT CONCAT('Status invalido: ', p_novo_status) AS resultado;
    ELSE
        UPDATE pedido
        SET status = p_novo_status
        WHERE id_pedido = p_id_pedido;
        SELECT CONCAT('Pedido ', p_id_pedido, ' agora esta ', p_novo_status) AS resultado;
    END IF;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_alterar_status_pedido(5, 'finalizado');
```

---

# 6. Procedure com OUT

```sql
DELIMITER //

-- PROCEDURE COM OUT: devolve o total de um pedido em uma variavel
CREATE PROCEDURE sp_total_do_pedido(
    IN  p_id_pedido INT,
    OUT p_total DECIMAL(10,2)
)
BEGIN
    SELECT COALESCE(SUM(quantidade * preco_unitario), 0)
    INTO p_total
    FROM item_pedido
    WHERE id_pedido = p_id_pedido;
END //

DELIMITER ;
```

```sql
CALL sp_total_do_pedido(4, @total);
SELECT @total;
```

> O parâmetro `OUT` devolve o valor para uma variável de sessão (`@total`). Para o pedido 4 o resultado foi 149,00.

---

# 7. Function

## Function obrigatória

**Objetivo:**

> Calcular o total de um pedido somando `quantidade * preco_unitario` dos itens.

**Parâmetro recebido:**

```text
p_id_pedido INT
```

**Valor retornado:**

```text
DECIMAL(10,2) — total do pedido (0 se não houver itens)
```

**SQL:**

```sql
DELIMITER //

-- FUNCTION 1: retorna o total de um pedido
CREATE FUNCTION fn_total_pedido(p_id_pedido INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(quantidade * preco_unitario), 0)
    INTO v_total
    FROM item_pedido
    WHERE id_pedido = p_id_pedido;

    RETURN v_total;
END //

DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT fn_total_pedido(1);
```

> Retorna 103,80. A cláusula `READS SQL DATA` é necessária porque a function lê tabelas; sem ela (ou `DETERMINISTIC`/`NO SQL`) o MySQL com log binário ligado dá o erro 1418 ao criar.

---

# 8. IF / ELSE

**Regra de negócio implementada:**

> `sp_alterar_status_pedido` só altera o pedido se ele existir e se o status for um dos permitidos. `fn_faixa_pedido` classifica o pedido: total >= 100 é "Alto", >= 50 é "Medio", senão "Baixo".

```sql
DELIMITER //

-- FUNCTION 2 (IF/ELSE): classifica o pedido pela faixa de valor
CREATE FUNCTION fn_faixa_pedido(p_id_pedido INT)
RETURNS VARCHAR(10)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SET v_total = fn_total_pedido(p_id_pedido);

    IF v_total >= 100 THEN
        RETURN 'Alto';
    ELSEIF v_total >= 50 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Baixo';
    END IF;
END //

DELIMITER ;
```

---

# 9. Procedure x Function

## Procedure

> É um bloco de comandos que eu chamo com `CALL`. Pode fazer várias operações (inclusive `UPDATE`/`INSERT`), devolver tabelas e ter parâmetros `IN` e `OUT`.

## Function

> Calcula e devolve **um valor**, e por isso pode ser usada dentro de um `SELECT`, como `SELECT fn_total_pedido(id_pedido) FROM pedido`.

## Quando você utilizaria cada uma no seu projeto?

> Procedure para ações do dia a dia (alterar status, listar pedidos do cliente). Function para cálculos que entram em consultas (total do pedido, faixa do pedido).


---

# 10. Testes obrigatórios

## Procedure 1

```sql
CALL sp_pedidos_do_cliente(1);
CALL sp_pedidos_do_cliente(4);
```

**Resultados:**

> Cliente 1: pedidos 1 (103,80) e 3 (57,90). Cliente 4 (Pedro): pedido 5 (29,00).

## Procedure 2

```sql
CALL sp_alterar_status_pedido(5, 'finalizado');
CALL sp_alterar_status_pedido(5, 'aberto');
CALL sp_alterar_status_pedido(5, 'xpto');
CALL sp_alterar_status_pedido(99, 'aberto');
```

**Resultados:**

> "Pedido 5 agora esta finalizado"; "Pedido 5 agora esta aberto" (voltei ao estado original); "Status invalido: xpto"; "Pedido 99 nao encontrado". Os dois últimos não alteraram nada.

## Function

```sql
SELECT fn_total_pedido(1), fn_total_pedido(4);
SELECT id_pedido, fn_total_pedido(id_pedido) AS total, fn_faixa_pedido(id_pedido) AS faixa FROM pedido;
```

**Resultados:**

> 103,80 e 149,00. Faixas: pedido 1 = Alto (103,80); 2 = Medio (77,00); 3 = Medio (57,90); 4 = Alto (149,00); 5 = Baixo (29,00).

## Procedure com OUT

```sql
CALL sp_total_do_pedido(4, @total); SELECT @total;
CALL sp_total_do_pedido(5, @total); SELECT @total;
```

> 149,00 e 29,00.

---

# 11. Validação prática presencial

**Rotina escolhida:**

```text
sp_alterar_status_pedido
```

```sql
DELIMITER //

-- PROCEDURE 2 (operacao do dominio + IF/ELSE): altera o status de um pedido
CREATE PROCEDURE sp_alterar_status_pedido(
    IN p_id_pedido INT,
    IN p_novo_status VARCHAR(20)
)
BEGIN
    DECLARE v_existe INT;

    SELECT COUNT(*) INTO v_existe
    FROM pedido
    WHERE id_pedido = p_id_pedido;

    IF v_existe = 0 THEN
        SELECT CONCAT('Pedido ', p_id_pedido, ' nao encontrado') AS resultado;
    ELSEIF p_novo_status NOT IN ('aberto', 'finalizado', 'cancelado') THEN
        SELECT CONCAT('Status invalido: ', p_novo_status) AS resultado;
    ELSE
        UPDATE pedido
        SET status = p_novo_status
        WHERE id_pedido = p_id_pedido;
        SELECT CONCAT('Pedido ', p_id_pedido, ' agora esta ', p_novo_status) AS resultado;
    END IF;
END //

DELIMITER ;
```

> Se eu trocar o parâmetro, o resultado muda: `CALL sp_alterar_status_pedido(5, 'xpto')` cai no `ELSEIF` e mostra "Status invalido"; com o id 99 cai no primeiro `IF`. Só com pedido existente e status válido chega no `UPDATE`.


---

# 12. Quantidade mínima exigida

| Exigência | Atendida |
|---|---|
| 2 Procedures | `sp_pedidos_do_cliente`, `sp_alterar_status_pedido` (+ `sp_total_do_pedido`) |
| 1 Function | `fn_total_pedido` (+ `fn_faixa_pedido`) |
| parâmetro `IN` | todas |
| `IF/ELSE` | `sp_alterar_status_pedido`, `fn_faixa_pedido` |
| `OUT` | `sp_total_do_pedido` |
| 2 testes por rotina | seção 10 |

---

# 13. Estrutura do SPRINT4-5.sql

`USE`, `DROP ... IF EXISTS`, `DELIMITER //`, as 3 Procedures e 2 Functions, `DELIMITER ;`, testes com `CALL` e testes com `SELECT`. Pode ser executado várias vezes.

---

# 14. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro 1418 ao criar a Function | Log binário ligado e a function não declarava `DETERMINISTIC`/`READS SQL DATA`/`NO SQL` | Adicionar `READS SQL DATA` |
| Erro de sintaxe ao criar a Procedure | Esqueci o `DELIMITER` e o MySQL cortou no primeiro `;` | `DELIMITER //` antes e `DELIMITER ;` depois |
| O teste da Procedure deixaria o pedido alterado | O `UPDATE` é permanente | Chamar de novo voltando o status para `aberto` |


---

# 15. Uso de LLMs

Usei uma LLM como apoio para o rascunho das rotinas. Depois li linha por linha, adaptei aos nomes do meu banco, executei com parâmetros diferentes e consigo explicar o que cada parâmetro e cada `IF` faz.


---

# 16. Checklist

- [x] utilizei o banco do projeto;
- [ ] compreendi o uso do `DELIMITER`; <!-- marque depois de estudar -->
- [x] criei pelo menos 2 Procedures;
- [x] criei uma Function;
- [x] utilizei parâmetro `IN`;
- [x] utilizei `OUT` quando aplicável;
- [x] utilizei `IF/ELSE`;
- [x] testei cada rotina;
- [x] executei parâmetros diferentes;
- [ ] consigo explicar todas as rotinas; <!-- marque depois de estudar -->
- [x] salvei `SPRINT4-5.md`;
- [x] salvei `SPRINT4-5.sql`.

---

# 17. Git/GitHub

Branch `team-03`.

```text
Conclui Module 2 Sprint 4 de 5 - procedures e functions
```
