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

> João Guilherme Barros de Lima

**Banco utilizado:**

```text
real_estate_database
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| sp_listar_imoveis_por_cidade | Procedure | p_cidade (VARCHAR) | Lista de imóveis da cidade, do mais barato ao mais caro | Consultar rapidamente os imóveis anunciados em uma cidade |
| sp_atualizar_status_agendamento | Procedure | p_id_agendamento (INT) e p_novo_status (VARCHAR) | Mensagem informando o resultado da operação | Alterar o status de uma visita validando se o agendamento existe e se o status é permitido |
| fn_comissao_corretor | Function | p_valor (DECIMAL) | Comissão de 5% sobre o valor (DECIMAL) | Calcular a comissão do corretor, reutilizável dentro de qualquer SELECT |
| sp_contar_agendamentos_por_status | Procedure (OUT) | p_status (VARCHAR) | p_total (INT, parâmetro OUT) | Contar quantos agendamentos existem em determinado status |

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

> O cliente MySQL (como o Workbench) considera o ponto e vírgula (;) o fim de um comando e envia cada comando ao servidor assim que o encontra. Só que o corpo de uma Procedure ou Function tem vários comandos, cada um terminando em ;. Sem o DELIMITER, o cliente cortaria o CREATE PROCEDURE no primeiro ; de dentro do BEGIN...END, enviaria um comando incompleto e daria erro de sintaxe. Com DELIMITER //, o terminador passa a ser //, então o ; fica livre para ser usado dentro da rotina e o CREATE inteiro é enviado como um único comando. No final, o DELIMITER ; devolve o terminador ao padrão. O DELIMITER é um comando do cliente, não da linguagem SQL do servidor.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Listar os imóveis anunciados em uma cidade informada, ordenados do mais barato para o mais caro.

**Parâmetro de entrada:**

```text
p_cidade VARCHAR(100)
```

**SQL:**

```sql
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

DELIMITER ;
```

**Execução:**

```sql
CALL sp_listar_imoveis_por_cidade('Rondonópolis');
```

**Resultado esperado:**

> Duas linhas, ordenadas por valor: "Apartamento Centro" (R$ 240.000,00) e "Casa com piscina" (R$ 450.000,00), que são os imóveis cadastrados em Rondonópolis.

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

> Alterar o status de um agendamento de visita (por exemplo, de "Pendente" para "Confirmado"), validando antes se o agendamento existe e se o novo status é um dos valores permitidos (Pendente, Confirmado ou Cancelado). Se algo estiver errado, nada é alterado e a procedure devolve uma mensagem explicando o motivo.

```sql
DELIMITER //

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

DELIMITER ;
```

**Execução:**

```sql
CALL sp_atualizar_status_agendamento(2, 'Confirmado');
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

CREATE PROCEDURE sp_contar_agendamentos_por_status(
    IN p_status VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM agendamento
    WHERE status = p_status;
END //

DELIMITER ;

CALL sp_contar_agendamentos_por_status('Pendente', @total);
SELECT @total;
```

Caso não seja aplicável, justifique:

> Aplicável: a procedure recebe o status por IN e devolve a quantidade pelo parâmetro OUT p_total, que é guardado na variável de sessão @total e lido depois com SELECT @total.

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

> Calcular a comissão do corretor sobre o valor de um imóvel, usando o mesmo percentual de 5% aplicado nas consultas do Module-1, de forma que o cálculo fique em um só lugar e possa ser usado em qualquer SELECT.

**Parâmetro recebido:**

```text
p_valor DECIMAL(10,2)
```

**Valor retornado:**

```text
DECIMAL(10,2) — a comissão de 5% sobre o valor informado
```

**SQL:**

```sql
DELIMITER //

CREATE FUNCTION fn_comissao_corretor(
    p_valor DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_valor * 0.05, 2);
END //

DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT fn_comissao_corretor(450000.00);

SELECT titulo, valor, fn_comissao_corretor(valor) AS comissao
FROM imovel;
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

> Um agendamento só pode ter o status alterado se existir no banco e se o novo status for Pendente, Confirmado ou Cancelado. A procedure testa as condições em ordem: se o agendamento não existe, informa isso; se o status não é permitido, informa que é inválido; só se as duas verificações passarem (ELSE) é que o UPDATE é executado. Assim, um valor digitado errado não chega a ser gravado na tabela.

```sql
DELIMITER //

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

DELIMITER ;
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Uma Procedure é um conjunto de comandos SQL guardado no banco e executado quando eu chamo com CALL. Ela pode consultar, inserir, alterar ou excluir dados, receber parâmetros de entrada (IN) e devolver valores por parâmetros de saída (OUT). Pode também devolver tabelas de resultado, como um SELECT. Ela não retorna um valor com RETURN e não pode ser usada dentro de um SELECT: é chamada sozinha, como uma ação.

## Function

> Uma Function também é guardada no banco, mas sempre calcula e devolve um único valor com RETURN. Por isso ela pode ser usada dentro de um SELECT, de um WHERE ou de uma expressão, do mesmo jeito que funções prontas como UPPER() ou ROUND(). Ela serve para cálculos e transformações reutilizáveis, e não para executar uma sequência de ações.

## Quando você utilizaria cada uma no seu projeto?

> Usaria Procedure para operações do sistema, como alterar o status de um agendamento com validação (sp_atualizar_status_agendamento) ou listar os imóveis de uma cidade (sp_listar_imoveis_por_cidade). Usaria Function para um cálculo que se repete em várias consultas, como a comissão do corretor (fn_comissao_corretor). Assim, se o percentual mudar, altero em um único lugar e todas as consultas que usam a função passam a refletir o novo valor.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL sp_listar_imoveis_por_cidade('Rondonópolis');
CALL sp_listar_imoveis_por_cidade('Alagoas');
```

**Resultados:**

> Com 'Rondonópolis': 2 linhas, "Apartamento Centro" (R$ 240.000,00) e "Casa com piscina" (R$ 450.000,00), nessa ordem. Com 'Alagoas': 1 linha, "Casa na praia" (R$ 800.000,00). Mudando só o parâmetro, a mesma procedure devolve conjuntos diferentes.

## Procedure 2

```sql
CALL sp_atualizar_status_agendamento(2, 'Confirmado');
CALL sp_atualizar_status_agendamento(2, 'Pendente');
CALL sp_atualizar_status_agendamento(2, 'Aprovado');
CALL sp_atualizar_status_agendamento(99, 'Confirmado');
```

**Resultados:**

> 1ª chamada: "Status atualizado com sucesso" (o agendamento 2 passou a Confirmado). 2ª chamada: "Status atualizado com sucesso" (devolvi o agendamento 2 para Pendente, mantendo os dados originais). 3ª chamada: "Status inválido", pois "Aprovado" não é um status permitido, e nada foi alterado. 4ª chamada: "Agendamento não encontrado", pois não existe agendamento de id 99.

## Procedure com OUT

```sql
CALL sp_contar_agendamentos_por_status('Pendente', @total);
SELECT @total;

CALL sp_contar_agendamentos_por_status('Confirmado', @total);
SELECT @total;
```

**Resultados:**

> Com 'Pendente', @total é 4 (agendamentos 2, 3, 4 e 6). Com 'Confirmado', @total é 1 (agendamento 1).

## Function

```sql
SELECT fn_comissao_corretor(450000.00);
SELECT fn_comissao_corretor(240000.00);
```

**Resultados:**

> Para R$ 450.000,00 retorna 22500.00, e para R$ 240.000,00 retorna 12000.00, que são 5% de cada valor. Aplicada à tabela inteira (`SELECT titulo, valor, fn_comissao_corretor(valor) FROM imovel`), retorna a comissão de cada um dos 5 imóveis cadastrados.

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
sp_atualizar_status_agendamento
```

```sql
DELIMITER //

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

-- Aluno: João Guilherme Barros de Lima
-- Banco: real_estate_database

USE real_estate_database;

DROP PROCEDURE IF EXISTS sp_listar_imoveis_por_cidade;
DROP PROCEDURE IF EXISTS sp_atualizar_status_agendamento;
DROP PROCEDURE IF EXISTS sp_contar_agendamentos_por_status;
DROP FUNCTION IF EXISTS fn_comissao_corretor;

DELIMITER //

-- PROCEDURE 1
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

-- PROCEDURE 2
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

-- PROCEDURE COM OUT
CREATE PROCEDURE sp_contar_agendamentos_por_status(
    IN p_status VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM agendamento
    WHERE status = p_status;
END //

-- FUNCTION
CREATE FUNCTION fn_comissao_corretor(
    p_valor DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_valor * 0.05, 2);
END //

DELIMITER ;

-- TESTES COM CALL
CALL sp_listar_imoveis_por_cidade('Rondonópolis');
CALL sp_listar_imoveis_por_cidade('Alagoas');

CALL sp_contar_agendamentos_por_status('Pendente', @total);
SELECT @total;

CALL sp_contar_agendamentos_por_status('Confirmado', @total);
SELECT @total;

CALL sp_atualizar_status_agendamento(2, 'Confirmado');
SELECT id_agendamento, status FROM agendamento WHERE id_agendamento = 2;

-- Reversão, para manter os dados originais do banco
CALL sp_atualizar_status_agendamento(2, 'Pendente');
SELECT id_agendamento, status FROM agendamento WHERE id_agendamento = 2;

CALL sp_atualizar_status_agendamento(2, 'Aprovado');
CALL sp_atualizar_status_agendamento(99, 'Confirmado');

-- TESTES COM SELECT
SELECT fn_comissao_corretor(450000.00);
SELECT fn_comissao_corretor(240000.00);

SELECT titulo, valor, fn_comissao_corretor(valor) AS comissao
FROM imovel;
```

---

# 14. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro 1064 (erro de sintaxe) ao executar o CREATE PROCEDURE | Sem o `DELIMITER //`, o cliente cortou o comando no primeiro `;` de dentro do BEGIN...END e enviou um comando incompleto | Usar `DELIMITER //` antes do CREATE, terminar a rotina com `END //` e voltar com `DELIMITER ;` |
| Erro 1418 ao criar a function: "This function has none of DETERMINISTIC, NO SQL, or READS SQL DATA in its declaration" | Com o log binário ativo, o MySQL exige que a function declare suas características | Incluir `DETERMINISTIC` na declaração, já que o resultado depende só do parâmetro |
| Risco de a procedure alterar todos os agendamentos ao usar parâmetro com o mesmo nome da coluna (ex: `status`) | Em `WHERE status = status`, o MySQL compara a coluna com ela mesma, e a condição fica sempre verdadeira | Usar o prefixo `p_` nos parâmetros (`p_status`, `p_novo_status`), distinguindo parâmetro de coluna |

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
team-12
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
