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

> Vinícius Eduardo Lima de Assis.

**Banco utilizado:**

```text
pacote_viagens
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| sp_buscar_hospedagens_destino | Procedure | p_id_destino INT | Tabela de resultados | Listar todas as hospedagens cadastradas para um determinado destino |
| sp_resumo_cliente | Procedure | p_id_cliente INT | Tabela de resultados | Exibir os dados do cliente e todas as suas reservas efetuadas com detalhes de hotel e transporte |
| fn_calcular_valor_total_reserva | Function | p_id_reserva INT | DECIMAL(10,2) | Calcular o valor estimado do pacote (valor da diária da hospedagem x número de pessoas) |
| fn_classificar_hospedagem | Function | p_id_hospedagem INT | VARCHAR(30) | Classificar uma hospedagem em categorias de custo ('Econômica', 'Intermediária', 'Luxo') com uso de IF/ELSE |
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

> O DELIMITER altera temporariamente o caractere padrão que finaliza comandos no MySQL (que é o ponto e vírgula ;). Isso é essencial ao criar Procedures ou Functions, pois essas rotinas contêm múltiplos comandos SQL internos terminados em ;. Mudar o delimitador (por exemplo, para //) evita que o MySQL interprete o primeiro ; interno como o fim de toda a criação da Stored Procedure/Function.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Buscar e retornar todas as hospedagens vinculadas a um destino específico informado via ID.

**Parâmetro de entrada:**

```text
p_id_destino INT
```

**SQL:**

```sql
-- USE pacote_viagens;

-- 1. Altera o delimitador para //
DELIMITER //

CREATE PROCEDURE sp_buscar_hospedagens_destino(
    IN p_id_destino INT
)
BEGIN
    SELECT 
        h.id_hospedagem,
        h.nome AS hospedagem,
        h.tipo,
        h.valor_diaria,
        d.nome AS destino
    FROM hospedagem AS h
    INNER JOIN destino AS d ON h.id_destino = d.id_destino
    WHERE h.id_destino = p_id_destino;
END //

-- 2. Restaura o delimitador padrão para ;
DELIMITER ;
```

**Execução:**

```sql
CALL sp_buscar_hospedagens_destino(2);
```

**Resultado esperado:**

> Uma lista contendo todas as opções de acomodação (hotéis, pousadas) cadastradas para o destino de ID 1 (Fernando de Noronha).

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

> Listar o histórico completo e detalhado das reservas ativas efetuadas por um determinado cliente.

```sql
-- USE pacote_viagens;

-- 1. Altera o delimitador para //
DELIMITER //

CREATE PROCEDURE sp_resumo_cliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        c.nome AS cliente,
        r.id_reserva,
        r.data_reserva,
        r.quantidade_pessoas,
        h.nome AS hospedagem,
        t.empresa AS transporte
    FROM reserva_pacote AS r
    INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
    INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
    INNER JOIN transporte AS t ON r.id_transporte = t.id_transporte
    WHERE c.id_cliente = p_id_cliente;
END //

-- 2. Restaura o delimitador padrão para ;
DELIMITER ;
```

**Execução:**

```sql
CALL sp_resumo_cliente(1);
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
-- USE pacote_viagens;

DELIMITER //

DROP PROCEDURE IF EXISTS sp_contar_reservas_cliente //

CREATE PROCEDURE sp_contar_reservas_cliente(
    IN p_id_cliente INT,
    OUT p_total_reservas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_reservas
    FROM reserva_pacote
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;

CALL sp_contar_reservas_cliente(1, @total);
SELECT @total AS total_reservas_cliente;
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

> Calcular o valor estimado por diária da reserva multiplicando a quantidade de pessoas pelo valor unitário da diária da hospedagem associada.

**Parâmetro recebido:**

```text
p_id_reserva INT
```

**Valor retornado:**

```text
DECIMAL(10,2)
```

**SQL:**

```sql
-- USE pacote_viagens;

DELIMITER //

DROP FUNCTION IF EXISTS fn_calcular_valor_total_reserva //

CREATE FUNCTION fn_calcular_valor_total_reserva(
    p_id_reserva INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_valor_diaria DECIMAL(10,2);
    DECLARE v_qtd_pessoas INT;
    DECLARE v_total DECIMAL(10,2);

    SELECT h.valor_diaria, r.quantidade_pessoas
    INTO v_valor_diaria, v_qtd_pessoas
    FROM reserva_pacote AS r
    INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
    WHERE r.id_reserva = p_id_reserva;

    SET v_total = v_valor_diaria * v_qtd_pessoas;

    RETURN v_total;
END //

DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT 
    id_reserva, 
    id_cliente, 
    fn_calcular_valor_total_reserva(id_reserva) AS subtotal_calculado
FROM reserva_pacote
WHERE id_reserva = 1;
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

> Classificar a hospedagem em faixas de preço de diária: 'Econômica' (diária até R$ 700,00), 'Intermediária' (diária de R$ 700,01 a R$ 1.500,00) ou 'Alto Padrão / Luxo' (diária acima de R$ 1.500,00).

```sql
-- USE pacote_viagens;

DELIMITER //

DROP FUNCTION IF EXISTS fn_classificar_hospedagem //

CREATE FUNCTION fn_classificar_hospedagem(
    p_id_hospedagem INT
)
RETURNS VARCHAR(30)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_valor DECIMAL(10,2);
    DECLARE v_categoria VARCHAR(30);

    SELECT valor_diaria INTO v_valor
    FROM hospedagem
    WHERE id_hospedagem = p_id_hospedagem;

    IF v_valor IS NULL THEN
        SET v_categoria = 'Não Encontrada';
    ELSEIF v_valor <= 700.00 THEN
        SET v_categoria = 'Econômica';
    ELSEIF v_valor <= 1500.00 THEN
        SET v_categoria = 'Intermediária';
    ELSE
        SET v_categoria = 'Alto Padrão / Luxo';
    END IF;

    RETURN v_categoria;
END //

DELIMITER ;

SELECT 
    id_hospedagem,
    nome,              
    valor_diaria,
    fn_classificar_hospedagem(id_hospedagem) AS categoria
FROM hospedagem;
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> É um conjunto encapsulado de instruções SQL executado através do comando CALL. Pode receber parâmetros de entrada (IN), parâmetros de saída (OUT) e manipular registros no banco de dados. Não necessita retornar um valor único e pode retornar múltiplos conjuntos de dados (tabelas) na tela.

## Function

> É uma estrutura que tem como finalidade calcular e retornar obrigatoriamente um único valor escalar (número, texto, data) via instrução RETURN. Pode ser invocada diretamente em expressões dentro de seleções (SELECT), cláusulas de filtro (WHERE) ou ordenação (ORDER BY).

## Quando você utilizaria cada uma no seu projeto?

> Utilizaria Procedures para ações operacionais do sistema, como buscar o resumo do cliente, emitir relatórios de reserva ou processar cancelamentos. Utilizaria Functions para cálculos numéricos e transformações reutilizáveis diretamente dentro das consultas SELECT, tais como calcular o total estimado de uma reserva ou categorizar estadias pelo preço.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL sp_buscar_hospedagens_destino(1);
CALL sp_buscar_hospedagens_destino(2);
```

**Resultados:**

> O primeiro CALL retornou a Pousada Zé Maria cadastrada para o destino de Fernando de Noronha (ID 1). O segundo CALL retornou o Hotel Colline de France cadastrado para o destino de Gramado (ID 2).

## Procedure 2

```sql
CALL sp_resumo_cliente(1);
CALL sp_resumo_cliente(3);
```

**Resultados:**

> O primeiro CALL exibiu a reserva ativa do cliente Carlos Silva. O segundo exibiu a reserva ativa do cliente Roberto Santos.

## Function

```sql
SELECT fn_calcular_valor_total_reserva(1) AS total_reserva_1;
SELECT fn_calcular_valor_total_reserva(3) AS total_reserva_3;
```

**Resultados:**

> O primeiro SELECT retornou 2400.00 (R$ 1.200,00 x 2 pessoas). O segundo SELECT retornou 2600.00 (R$ 650,00 x 4 pessoas).

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
sp_buscar_hospedagens_destino
```

```sql
-- CREATE PROCEDURE sp_buscar_hospedagens_destino(
    IN p_id_destino INT
)
BEGIN
    SELECT 
        h.id_hospedagem,
        h.nome AS hospedagem,
        h.tipo,
        h.valor_diaria,
        d.nome AS destino
    FROM hospedagem AS h
    INNER JOIN destino AS d ON h.id_destino = d.id_destino
    WHERE h.id_destino = p_id_destino;
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
| Erro 1064: Syntax Error perto da palavra END | Executar o comando sem alterar o delimitador com DELIMITER // | Incluir DELIMITER // antes do CREATE e DELIMITER ; ao final |

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
- [x] consigo explicar todas as rotinas;
- [x] salvei `SPRINT4-5.md`;
- [x] salvei `SPRINT4-5.sql`.

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
