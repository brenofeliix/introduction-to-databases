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

> Anna Beatriz Oliveira Moura

**Banco utilizado:**

```text
locacao_de_filmes
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| sp_listar_filmes_por_genero | Procedure | ID do gênero (IN) | Lista de filmes | Consultar os filmes pertencentes a um gênero específico. |
| sp_calcular_total_locacao | Procedure | ID da locação (IN) | Valor total (OUT) | Calcular o valor total de uma locação, considerando os filmes e suas diárias. |
| fn_calcular_valor_item | Function | Valor da diária e datas | Valor calculado (RETURN) | Calcular o valor de um item alugado considerando a quantidade de dias. |

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

> O comando DELIMITER é utilizado para alterar temporariamente o delimitador de comandos SQL durante a criação de Procedures e Functions. Como essas rotinas possuem vários comandos internos que terminam com ponto e vírgula, é necessário utilizar outro delimitador, como ($$), para indicar ao MySQL onde termina a definição completa da rotina. Depois da criação das rotinas, o delimitador original é restaurado com DELIMITER ;.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Permitir a consulta dos filmes pertencentes a um gênero específico, recebendo o identificador do gênero como parâmetro.

**Parâmetro de entrada:**

```text
p_id_genero INT
```

**SQL:**

```sql
CREATE PROCEDURE sp_listar_filmes_por_genero(
    IN p_id_genero INT
)
BEGIN
    DECLARE v_genero_existe INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_genero_existe
    FROM genero
    WHERE id_genero = p_id_genero;

    IF v_genero_existe > 0 THEN

        SELECT
            f.id_filme,
            f.titulo,
            f.ano_lancamento,
            f.avaliacao,
            f.diretor,
            g.nome AS genero
        FROM filme AS f
        INNER JOIN genero AS g
            ON f.id_genero = g.id_genero
        WHERE g.id_genero = p_id_genero
        ORDER BY f.titulo;

    ELSE

        SELECT
            'Genero nao encontrado' AS mensagem;

    END IF;
END$$
```

**Execução:**

```sql
CALL sp_listar_filmes_por_genero(4);
```

**Resultado esperado:**

> A execução lista os filmes do gênero Terror, pelo ID 4 corresponder a esse gênero.

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

> Calcular o valor total de uma locação, considerando os valores das diárias dos filmes incluídos e a diferença entre a data da locação e a data de devolução. A rotina recebe o identificador da locação e utiliza a Function fn_calcular_valor_item para calcular o valor de cada item.

```sql
CREATE PROCEDURE sp_calcular_total_locacao(
    IN p_id_locacao INT,
    OUT p_valor_total DECIMAL(10,2)
)
BEGIN
    DECLARE v_locacao_existe INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_locacao_existe
    FROM locacao
    WHERE id_locacao = p_id_locacao;

    IF v_locacao_existe > 0 THEN

        SELECT
            COALESCE(
                SUM(
                    fn_calcular_valor_item(
                        i.valor_diaria,
                        l.data_locacao,
                        l.data_devolucao
                    )
                ),
                0.00
            )
        INTO p_valor_total
        FROM locacao AS l
        LEFT JOIN item_locacao AS i
            ON l.id_locacao = i.id_locacao
        WHERE l.id_locacao = p_id_locacao;

    ELSE

        SET p_valor_total = NULL;

    END IF;
END$$
```

**Execução:**

```sql
SET @total_locacao = 0;
CALL sp_calcular_total_locacao(1, @total_locacao);
SELECT @total_locacao;
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
SET @total_locacao = 0;

CALL sp_calcular_total_locacao(1, @total_locacao);

SELECT @total_locacao AS valor_total;
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

> Calcular o valor de um item alugado com base no valor da diária e na diferença entre a data de locação e a data de devolução.

**Parâmetro recebido:**

```text
p_valor_diaria DECIMAL(10,2)
p_data_locacao DATE
p_data_devolucao DATE
```

**Valor retornado:**

```text
DECIMAL(10,2)
```

**SQL:**

```sql
CREATE FUNCTION fn_calcular_valor_item(
    p_valor_diaria DECIMAL(10,2),
    p_data_locacao DATE,
    p_data_devolucao DATE
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_quantidade_dias INT DEFAULT 0;
    DECLARE v_valor_total DECIMAL(10,2) DEFAULT 0.00;

    IF p_valor_diaria IS NULL
       OR p_valor_diaria < 0
       OR p_data_locacao IS NULL
       OR p_data_devolucao IS NULL
       OR p_data_devolucao < p_data_locacao
    THEN
        SET v_valor_total = 0.00;

    ELSE
        SET v_quantidade_dias =
            DATEDIFF(p_data_devolucao, p_data_locacao);

        SET v_valor_total =
            p_valor_diaria * v_quantidade_dias;
    END IF;

    RETURN v_valor_total;
END$$
```

**Exemplo de uso:**

```sql
SELECT fn_calcular_valor_item(
    8.00,
    '2026-09-01',
    '2026-09-04'
) AS valor_item;
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

> As rotinas utilizam condições para verificar se os dados informados são válidos antes de executar suas operações. Na Procedure sp_listar_filmes_por_genero, o IF/ELSE verifica se o gênero informado existe. Se existir, são listados seus filmes; caso contrário, é apresentada uma mensagem. Na Function fn_calcular_valor_item, o IF/ELSE verifica se o valor da diária e as datas são válidos. Se houver informações inválidas, o resultado será zero. Caso contrário, o valor será calculado pela multiplicação da diária pela quantidade de dias.

```sql
IF v_genero_existe > 0 THEN

        SELECT
            f.id_filme,
            f.titulo,
            f.ano_lancamento,
            f.avaliacao,
            f.diretor,
            g.nome AS genero
        FROM filme AS f
        INNER JOIN genero AS g
            ON f.id_genero = g.id_genero
        WHERE g.id_genero = p_id_genero
        ORDER BY f.titulo;

    ELSE

        SELECT
            'Genero nao encontrado' AS mensagem;

    END IF;
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Uma Procedure é uma rotina armazenada no MySQL que executa uma sequência de comandos SQL. Pode receber parâmetros de entrada e saída e ser chamada por meio do comando CALL. É adequada para executar operações e consultas que podem envolver várias etapas.

## Function

> Uma Function é uma rotina armazenada que realiza um cálculo ou processamento e obrigatoriamente retorna um valor por meio de RETURN. Pode ser utilizada diretamente dentro de comandos SELECT e em expressões SQL.

## Quando você utilizaria cada uma no seu projeto?

> Uma Procedure foi utilizada para consultar os filmes de determinado gênero ou calcular o valor total de uma locação, pois essas operações podem envolver consultas a várias tabelas. Enquanto que uma Function foi utilizada para calcular o valor de um item alugado, pois essa operação recebe valores e datas, realiza um cálculo e retorna um único resultado que pode ser reutilizado em outras consultas e rotinas.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL sp_listar_filmes_por_genero(4);
CALL sp_listar_filmes_por_genero(2);
```

**Resultados:**

> A primeira chamada apresenta os filmes do gênero correspondente ao ID 4, filmes de terror. A segunda apresenta os filmes do gênero correspondente ao ID 2, filmes de comédia.

## Procedure 2

```sql
SET @total_locacao = 0;
CALL sp_calcular_total_locacao(1, @total_locacao);
SELECT @total_locacao;

SET @total_locacao = 0;
CALL sp_calcular_total_locacao(2, @total_locacao);
SELECT @total_locacao;
```

**Resultados:**

> As chamadas apresentam os resultados para as locações: locação 1 com valor de R$ 24,00 e a locação 2 com valor de R$ 30,00.

## Function

```sql
SELECT fn_calcular_valor_item(
    8.00,
    '2026-09-01',
    '2026-09-04'
);

SELECT fn_calcular_valor_item(
    10.00,
    '2026-09-02',
    '2026-09-05'
);
```

**Resultados:**

> Para o primeiro teste: R$ 24,00. Para o segundo teste: R$ 30,00. Os dois testes utilizam valores de diária e datas diferentes para demonstrar que a Function pode ser reutilizada com diferentes parâmetros.

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
sp_calcular_total_locacao
```

```sql
SET @total_locacao = 0;

CALL sp_calcular_total_locacao(1, @total_locacao);

SELECT @total_locacao AS valor_total;
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
| Erro encontrado no MySQL no momento de rodar o código para criar a Function. | Tinha clicado de maneira errada. | Clicar no título da CREATE FUNCTION, com a função do MySQL (execute the statement under the keyboard cursor). |
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
