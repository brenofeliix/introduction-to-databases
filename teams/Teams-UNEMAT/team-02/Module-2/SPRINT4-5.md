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

> Geovanna Gaspar Ribeiro

**Banco utilizado:**

```text
gerenciamento_incidentes
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| listar_incidentes_por_status | Procedure | p_status VARCHAR(20) | Lista de incidentes | Listar incidentes filtrados por status (ABERTO, EM_ANALISE, etc.) |
| encerrar_incidente | Procedure | p_id_incidente INT | Mensagem de confirmação | Encerrar um incidente, evitando encerrar um que já esteja encerrado |
| contar_incidentes_por_severidade | Procedure | p_severidade VARCHAR(20) | p_total INT (OUT) | Contar quantos incidentes existem de determinada severidade |
| dias_em_aberto | Function | p_id_incidente INT | INT (dias) | Calcular há quantos dias um incidente está em aberto (ou levou para ser resolvido) |

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

> Por padrão, o MySQL usa ; para marcar o fim de cada comando. Mas o corpo de uma Procedure ou Function costuma ter vários comandos internos, cada um terminado com ; — se o delimitador continuasse sendo ;, o MySQL entenderia que a criação da rotina terminou no primeiro ; interno, antes do END. Por isso, trocamos temporariamente o delimitador para algo como //, para que o MySQL só considere o bloco CREATE PROCEDURE ... END como um único comando, terminado apenas quando encontrar //. No final, o delimitador é devolvido para ; com DELIMITER ;.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Listar todos os incidentes que estejam em um determinado status (por exemplo, todos os ABERTO), já mostrando o analista responsável por cada um.

**Parâmetro de entrada:**

```text
p_status VARCHAR(20) — o status a ser filtrado (ex.: 'ABERTO', 'EM_ANALISE', 'ENCERRADO')
```

**SQL:**

```sql
DELIMITER //

CREATE PROCEDURE listar_incidentes_por_status(
    IN p_status VARCHAR(20)
)
BEGIN
    SELECT i.id_incidente,
           i.titulo,
           i.severidade,
           a.nome AS analista
    FROM incidentes i
    JOIN analistas a ON i.id_analista = a.id_analista
    WHERE i.status = p_status;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL listar_incidentes_por_status('ABERTO');
```

**Resultado esperado:**

> Uma lista com todos os incidentes cujo status seja exatamente 'ABERTO', mostrando título, severidade e o nome do analista responsável. Se nenhum incidente tiver esse status, a lista vem vazia (sem erro).

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

> Encerrar um incidente (mudar o status para 'ENCERRADO' e registrar a data de encerramento), mas evitando encerrar de novo um incidente que já esteja encerrado.

```sql
DELIMITER //

CREATE PROCEDURE encerrar_incidente(
    IN p_id_incidente INT
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status INTO v_status
    FROM incidentes
    WHERE id_incidente = p_id_incidente;

    IF v_status = 'ENCERRADO' THEN
        SELECT CONCAT('O incidente ', p_id_incidente, ' já está encerrado.') AS mensagem;
    ELSE
        UPDATE incidentes
        SET status = 'ENCERRADO',
            data_encerramento = NOW()
        WHERE id_incidente = p_id_incidente;

        SELECT CONCAT('Incidente ', p_id_incidente, ' encerrado com sucesso.') AS mensagem;
    END IF;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL encerrar_incidente(2);
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

CREATE PROCEDURE contar_incidentes_por_severidade(
    IN p_severidade VARCHAR(20),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM incidentes
    WHERE severidade = p_severidade;
END //

DELIMITER ;
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

> Calcular há quantos dias um incidente está em aberto ou, se ele já foi encerrado, quantos dias ele levou entre a identificação e o encerramento.

**Parâmetro recebido:**

```text
p_id_incidente INT — o id do incidente
```

**Valor retornado:**

```text
INT — quantidade de dias
```

**SQL:**

```sql
DELIMITER //

CREATE FUNCTION dias_em_aberto(p_id_incidente INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_dias INT;

    SELECT TIMESTAMPDIFF(
               DAY,
               data_identificacao,
               IFNULL(data_encerramento, NOW())
           ) INTO v_dias
    FROM incidentes
    WHERE id_incidente = p_id_incidente;

    RETURN v_dias;
END //

DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT dias_em_aberto(2);
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

> Na Procedure encerrar_incidente (seção 5): antes de encerrar um incidente, a rotina verifica se ele já está com status = 'ENCERRADO'. Se estiver, ela apenas avisa que o incidente já foi encerrado, sem fazer nenhuma alteração (evitando sobrescrever, por exemplo, uma data_encerramento que já existia). Só quando o status é diferente de 'ENCERRADO' é que o UPDATE realmente acontece.

```sql
IF v_status = 'ENCERRADO' THEN
    SELECT CONCAT('O incidente ', p_id_incidente, ' já está encerrado.') AS mensagem;
ELSE
    UPDATE incidentes
    SET status = 'ENCERRADO',
        data_encerramento = NOW()
    WHERE id_incidente = p_id_incidente;

    SELECT CONCAT('Incidente ', p_id_incidente, ' encerrado com sucesso.') AS mensagem;
END IF;
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Uma Procedure é uma rotina que executa um conjunto de comandos (pode incluir SELECT, INSERT, UPDATE, DELETE, estruturas de controle etc.) e é chamada com CALL. Ela não é obrigada a devolver um valor único, pode retornar um conjunto de linhas (como um SELECT normal), não retornar nada, ou devolver valores através de parâmetros OUT.

## Function

> Uma Function é uma rotina que sempre devolve um único valor, através de RETURN, e pode ser usada diretamente dentro de uma expressão SQL por exemplo, dentro de um SELECT, WHERE ou ORDER BY como se fosse uma coluna calculada.

## Quando você utilizaria cada uma no seu projeto?

> Utilizo o Procedure quando a operação envolve uma ação mais completa sobre o banco (como encerrar um incidente, alterando dados) ou quando quero retornar uma lista de linhas, algo que uma Function não pode fazer. Já o Function quando preciso de um cálculo pontual e reaproveitável, que eu queira embutir dentro de outras consultas, como calcular dias_em_aberto de cada incidente numa lista inteira, sem precisar chamar uma rotina separada para cada um.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL listar_incidentes_por_status('ABERTO');
CALL listar_incidentes_por_status('ENCERRADO');
```

**Resultados:**

> A chamada com 'ABERTO' retornou 2 incidentes nesse status, enquanto a chamada com 'ENCERRADO' retornou 3 incidentes, já refletindo os encerramentos realizados nas Sprints anteriores e durante os testes desta Sprint. Isso confirma que o parâmetro p_status controla corretamente o filtro aplicado pela Procedure.

## Procedure 2

```sql
CALL encerrar_incidente(2);
CALL encerrar_incidente(2);
```

**Resultados:**

> Nas duas execuções, a Procedure retornou a mensagem "O incidente 2 já está encerrado.", pois o incidente 2 já havia sido encerrado em um teste anterior a esta chamada. O comportamento confirma o funcionamento do IF/ELSE: como v_status já era 'ENCERRADO', o UPDATE não foi executado em nenhuma das duas chamadas, evitando sobrescrever indevidamente a data_encerramento já registrada.

## Function

```sql
SELECT dias_em_aberto(2);
SELECT dias_em_aberto(5);
```

**Resultados:**

> As duas chamadas retornaram 0. Isso ocorre porque tanto a identificação quanto o encerramento dos incidentes 2 e 5 foram registrados no mesmo dia em que os testes foram executados, como TIMESTAMPDIFF(DAY, ...) conta apenas dias de calendário completos, a diferença de poucas horas entre os dois eventos resulta em zero dias completos. O resultado é matematicamente correto e evidencia uma limitação natural da granularidade em dias para incidentes resolvidos no mesmo dia em que foram abertos.

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
encerrar_incidente
```

```sql
DELIMITER //

CREATE PROCEDURE encerrar_incidente(
    IN p_id_incidente INT
)
BEGIN
    DECLARE v_status VARCHAR(20);

    SELECT status INTO v_status
    FROM incidentes
    WHERE id_incidente = p_id_incidente;

    IF v_status = 'ENCERRADO' THEN
        SELECT CONCAT('O incidente ', p_id_incidente, ' já está encerrado.') AS mensagem;
    ELSE
        UPDATE incidentes
        SET status = 'ENCERRADO',
            data_encerramento = NOW()
        WHERE id_incidente = p_id_incidente;

        SELECT CONCAT('Incidente ', p_id_incidente, ' encerrado com sucesso.') AS mensagem;
    END IF;
END //

DELIMITER ;
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
