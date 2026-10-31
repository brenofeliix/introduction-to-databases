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

> Célia Hiromi Watanabe

**Banco utilizado:**

```text
db_salao_beleza
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| `sp_agendamentos_por_cliente` | Procedure | `p_id_cliente` (IN) | Tabela com os agendamentos | Mostrar o histórico de agendamentos de um cliente |
| `sp_concluir_agendamento` | Procedure | `p_id_agendamento`, `p_forma_pagamento` (IN) | Mensagem e atualização do agendamento | Concluir um atendimento e registrar o pagamento, com regra de negócio (IF/ELSE) |
| `sp_contar_por_status` | Procedure | `p_status` (IN) | `p_total` (OUT) | Contar quantos agendamentos existem em um status |
| `fn_total_gasto_cliente` | Function | `p_id_cliente` | `DECIMAL(10,2)` | Calcular quanto um cliente já pagou em atendimentos concluídos |

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

> Normalmente o MySQL entende que um comando termina no `;`. Dentro de uma Procedure ou Function existem vários comandos, cada um terminado em `;`, entre o `BEGIN` e o `END`. Sem mudar o delimitador, o MySQL encerraria o `CREATE PROCEDURE` no primeiro `;` e daria erro. O `DELIMITER //` faz o MySQL considerar `//` como fim de comando, para que a rotina inteira seja enviada de uma vez; no final, `DELIMITER ;` volta ao padrão.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Listar o histórico de agendamentos de um cliente, com serviço, profissional, preço e status, em ordem de data. A recepção pode usar quando o cliente liga para saber os horários dele.

**Parâmetro de entrada:**

```text
p_id_cliente INT — código do cliente (cliente.id_cliente)
```

**SQL:**

```sql
DELIMITER //

CREATE PROCEDURE sp_agendamentos_por_cliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT
        a.id_agendamento,
        a.data_hora,
        s.nome_servico AS servico,
        p.nome         AS profissional,
        s.preco,
        a.status
    FROM agendamento AS a
    INNER JOIN servico      AS s ON a.id_servico      = s.id_servico
    INNER JOIN profissional AS p ON a.id_profissional = p.id_profissional
    WHERE a.id_cliente = p_id_cliente
    ORDER BY a.data_hora;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_agendamentos_por_cliente(1);
```

**Resultado esperado:**

> 3 linhas com os agendamentos da Mariana Souza: 1 (Corte Feminino, Concluído), 7 (Manicure e Pedicure, Concluído) e 10 (Maquiagem Social, Cancelado).

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

> Concluir um atendimento e registrar a forma de pagamento (alterar status). A rotina verifica antes o status atual: só conclui agendamentos com status 'Agendado'; se o agendamento estiver cancelado, já concluído ou não existir, mostra uma mensagem e não altera nada.

```sql
DELIMITER //

CREATE PROCEDURE sp_concluir_agendamento(
    IN p_id_agendamento  INT,
    IN p_forma_pagamento VARCHAR(20)
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status INTO v_status
    FROM agendamento
    WHERE id_agendamento = p_id_agendamento;

    IF v_status IS NULL THEN
        SELECT CONCAT('Agendamento ', p_id_agendamento,
                      ' não encontrado.') AS mensagem;
    ELSEIF v_status = 'Agendado' THEN
        UPDATE agendamento
        SET status = 'Concluído',
            forma_pagamento = p_forma_pagamento
        WHERE id_agendamento = p_id_agendamento;

        SELECT CONCAT('Agendamento ', p_id_agendamento,
                      ' concluído. Pagamento: ', p_forma_pagamento) AS mensagem;
    ELSE
        SELECT CONCAT('Não é possível concluir: o agendamento ',
                      p_id_agendamento, ' está com status ', v_status, '.') AS mensagem;
    END IF;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_concluir_agendamento(2, 'Cartão');
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
DELIMITER //

CREATE PROCEDURE sp_contar_por_status(
    IN  p_status VARCHAR(20),
    OUT p_total  INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM agendamento
    WHERE status = p_status;
END //

DELIMITER ;

CALL sp_contar_por_status('Agendado', @total);
SELECT @total AS total_agendados;
```

Caso não seja aplicável, justifique:

> É aplicável. O parâmetro `OUT` devolve o total para a variável de sessão `@total`, que pode ser exibida com `SELECT @total` ou usada em outro comando.

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

> Calcular quanto um cliente já pagou no salão, somando os preços dos serviços dos seus atendimentos concluídos. Agendados e cancelados não entram na soma.

**Parâmetro recebido:**

```text
p_id_cliente INT — código do cliente
```

**Valor retornado:**

```text
DECIMAL(10,2) — total pago pelo cliente (0.00 se não tiver atendimento concluído)
```

**SQL:**

```sql
DELIMITER //

CREATE FUNCTION fn_total_gasto_cliente(
    p_id_cliente INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);

    SELECT COALESCE(SUM(s.preco), 0) INTO v_total
    FROM agendamento AS a
    INNER JOIN servico AS s ON a.id_servico = s.id_servico
    WHERE a.id_cliente = p_id_cliente
      AND a.status = 'Concluído';

    RETURN v_total;
END //

DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT fn_total_gasto_cliente(1) AS total_mariana;

SELECT nome, fn_total_gasto_cliente(id_cliente) AS total_gasto
FROM cliente
ORDER BY total_gasto DESC, nome;
```

> Foi usado `READS SQL DATA` em vez de `DETERMINISTIC`, porque a function lê dados de tabelas e o resultado muda quando os dados mudam. No MySQL 8, sem essa declaração, a criação da function pode falhar com o erro 1418.

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

> Na `sp_concluir_agendamento`, só pode ser concluído um agendamento com status 'Agendado'. Um agendamento cancelado não pode virar concluído, e um já concluído não pode ser concluído de novo (o que registraria um segundo pagamento). Se o código informado não existir, a rotina avisa em vez de não fazer nada em silêncio.

```sql
IF v_status IS NULL THEN
    SELECT CONCAT('Agendamento ', p_id_agendamento,
                  ' não encontrado.') AS mensagem;
ELSEIF v_status = 'Agendado' THEN
    UPDATE agendamento
    SET status = 'Concluído',
        forma_pagamento = p_forma_pagamento
    WHERE id_agendamento = p_id_agendamento;

    SELECT CONCAT('Agendamento ', p_id_agendamento,
                  ' concluído. Pagamento: ', p_forma_pagamento) AS mensagem;
ELSE
    SELECT CONCAT('Não é possível concluir: o agendamento ',
                  p_id_agendamento, ' está com status ', v_status, '.') AS mensagem;
END IF;
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> É um bloco de comandos salvo no banco e executado com `CALL`. Pode receber parâmetros `IN` e devolver valores por `OUT`, pode consultar, inserir, alterar e excluir dados e pode mostrar uma ou mais tabelas de resultado. Serve para executar uma **operação** completa.

## Function

> É uma rotina que sempre **retorna um único valor** com `RETURN`. É usada dentro de comandos SQL, como um `SELECT`, do mesmo jeito que `SUM()` ou `ROUND()`. Serve para fazer um **cálculo** que se repete.

## Quando você utilizaria cada uma no seu projeto?

> Procedure para operações da rotina do salão: concluir um atendimento com pagamento (`sp_concluir_agendamento`), consultar o histórico de um cliente (`sp_agendamentos_por_cliente`) ou contar agendamentos por status (`sp_contar_por_status`). Function para cálculos que aparecem dentro de consultas, como o total gasto por cliente (`fn_total_gasto_cliente`), usado no ranking de clientes com um único `SELECT`.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL sp_agendamentos_por_cliente(1);   -- Mariana Souza
CALL sp_agendamentos_por_cliente(3);   -- Camila Oliveira
```

**Resultados:**

> Executado no MySQL Workbench em 27/10/2026, sem erros. `CALL sp_agendamentos_por_cliente(1)` retornou **3 linhas** (Mariana Souza) e `CALL sp_agendamentos_por_cliente(3)` retornou **2 linhas** (Camila Oliveira). Trocar o parâmetro mudou o resultado, porque o `WHERE a.id_cliente = p_id_cliente` passou a filtrar outro cliente.

## Procedure 2

```sql
CALL sp_concluir_agendamento(2, 'Cartão');   -- agendamento 'Agendado'
CALL sp_concluir_agendamento(10, 'Pix');     -- agendamento 'Cancelado'
CALL sp_concluir_agendamento(99, 'Pix');     -- agendamento inexistente
```

**Resultados:**

> Os três `CALL` foram executados sem erros e cada um retornou 1 linha (a coluna `mensagem`). No caso do agendamento 2 ('Agendado'), a rotina executou o `UPDATE`: no comando de restauração que vem depois, o MySQL informou `Rows matched: 1  Changed: 1`, o que comprova que o status do agendamento 2 tinha sido alterado para 'Concluído'. Os agendamentos 10 ('Cancelado') e 99 (inexistente) caíram nos outros ramos do `IF` e não alteraram nenhum dado. Ao final do script, o agendamento 2 foi restaurado para 'Agendado'.
>
> Mensagens exibidas: agendamento 2 → "Agendamento 2 concluído. Pagamento: Cartão"; agendamento 10 → "Não é possível concluir: o agendamento 10 está com status Cancelado."; agendamento 99 → "Agendamento 99 não encontrado."

## Procedure com OUT

```sql
CALL sp_contar_por_status('Agendado', @total);
SELECT @total AS total_agendados;

CALL sp_contar_por_status('Concluído', @total);
SELECT @total AS total_concluidos;
```

**Resultados:**

> Os dois `CALL sp_contar_por_status` foram executados sem erros e cada `SELECT @total` retornou 1 linha, com o total guardado pelo parâmetro `OUT`. A grade exibiu **5** agendados (`total_agendados`) e **3** concluídos (`total_concluidos`). Depois da restauração do agendamento 2, o `total_agendados_final` voltou a **5**.

## Function

```sql
SELECT fn_total_gasto_cliente(1) AS total_mariana;
SELECT fn_total_gasto_cliente(7) AS total_patricia;
```

**Resultados:**

> A function foi criada sem o erro 1418 e as consultas foram executadas sem erros: `fn_total_gasto_cliente(1)` e `fn_total_gasto_cliente(7)` retornaram 1 linha cada, e o ranking de clientes retornou **6 linhas** (uma por cliente). A grade exibiu Mariana **145.00** (80.00 + 65.00) e Patrícia **0.00**. No ranking apareceram Mariana 145.00, Beatriz 80.00 e Camila, Fernanda, Juliana e Patrícia com 0.00. A Beatriz passou de **80.00** (`beatriz_antes`) para **145.00** (`beatriz_depois`) depois de o agendamento 2 ser concluído.

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
sp_concluir_agendamento
```

```sql
CREATE PROCEDURE sp_concluir_agendamento(
    IN p_id_agendamento  INT,
    IN p_forma_pagamento VARCHAR(20)
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status INTO v_status
    FROM agendamento
    WHERE id_agendamento = p_id_agendamento;

    IF v_status IS NULL THEN
        SELECT CONCAT('Agendamento ', p_id_agendamento,
                      ' não encontrado.') AS mensagem;
    ELSEIF v_status = 'Agendado' THEN
        UPDATE agendamento
        SET status = 'Concluído',
            forma_pagamento = p_forma_pagamento
        WHERE id_agendamento = p_id_agendamento;

        SELECT CONCAT('Agendamento ', p_id_agendamento,
                      ' concluído. Pagamento: ', p_forma_pagamento) AS mensagem;
    ELSE
        SELECT CONCAT('Não é possível concluir: o agendamento ',
                      p_id_agendamento, ' está com status ', v_status, '.') AS mensagem;
    END IF;
END
```

> 1. `p_id_agendamento` é o código do agendamento a concluir; `p_forma_pagamento` é como a cliente pagou (Pix, Cartão, Dinheiro).
> 2. e 3. Trocando o primeiro parâmetro de 2 para 10 e executando de novo, o resultado muda de "concluído" para "não é possível concluir".
> 4. O resultado muda porque a rotina lê o status do agendamento informado: o 2 está 'Agendado' e o 10 está 'Cancelado', e cada caso cai em um ramo diferente do `IF`.
> 5. A rotina guarda o status atual na variável `v_status` (`DECLARE` + `SELECT ... INTO`). Se não encontrou o agendamento, a variável fica `NULL` e a rotina avisa. Se o status é 'Agendado', faz o `UPDATE` e confirma. Em qualquer outro caso, bloqueia e explica o motivo.

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
| Erro 1418 ao criar a function (risco no MySQL 8) | Com o binary log ativo, o MySQL exige que a function declare `DETERMINISTIC`, `NO SQL` ou `READS SQL DATA` | Foi usado `READS SQL DATA`, pois a function só lê dados; a criação ocorreu sem erro |
| Aviso 1305 nos `DROP ... IF EXISTS` do início do script | As rotinas ainda não existiam na primeira execução | É só um aviso esperado; o `IF EXISTS` permite executar o script mais de uma vez sem erro |
| Agendamento 2 ficaria 'Concluído' depois dos testes | O teste da `sp_concluir_agendamento` altera dados de verdade | `UPDATE` de restauração no final do script, para manter os dados iguais na próxima Sprint |

Nenhuma rotina apresentou erro de execução no MySQL Workbench; os pontos acima são cuidados tomados durante a construção.

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

- [x] utilizei o banco do projeto;
- [x] compreendi o uso do `DELIMITER`;
- [x] criei pelo menos 2 Procedures;
- [x] criei uma Function;
- [x] utilizei parâmetro `IN`;
- [x] utilizei `OUT` quando aplicável;
- [x] utilizei `IF/ELSE`;
- [x] testei cada rotina;
- [x] executei parâmetros diferentes;
- [ ] consigo explicar todas as rotinas;
- [x] salvei `SPRINT4-5.md`;
- [x] salvei `SPRINT4-5.sql`.

---

# 17. Git/GitHub

Continue na mesma branch:

```text
team-03
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
