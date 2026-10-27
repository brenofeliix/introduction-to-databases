# SPRINT 4/5 — Stored Procedures e Functions

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual

# Objetivo da Sprint 4/5

Criar rotinas reutilizáveis no banco `Rh_sorveteria` para consultar funcionários, contar funcionários por filial e consultar o salário-base de um cargo.

# 1. Identificação

**Nome completo:**

```text
Marcos Aurélio Bastos Stanguerlin
```

**Banco utilizado:**

```text
Rh_sorveteria
```

# 2. Planejamento das rotinas

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| `sp_listar_funcionarios_filial` | Procedure | ID da filial (`IN`) | Lista de funcionários | Consultar funcionários de uma filial. |
| `sp_consultar_funcionario` | Procedure | ID do funcionário (`IN`) | Dados do funcionário ou mensagem | Consultar um funcionário e verificar se ele existe. |
| `sp_contar_funcionarios_filial` | Procedure | ID da filial (`IN`) | Quantidade (`OUT`) | Contar funcionários de uma filial. |
| `fn_salario_base_cargo` | Function | ID do cargo | Salário-base | Retornar o salário-base de um cargo. |

# 3. DELIMITER

```text
O DELIMITER muda temporariamente o símbolo usado para encerrar comandos. Assim, o MySQL reconhece o END da rotina sem encerrar sua criação antes da hora.
```

# 4. Procedure 1 — parâmetro IN

**Objetivo:**

```text
Listar os funcionários que pertencem à filial informada.
```

**Parâmetro de entrada:**

```text
p_id_filial INT — identificador da filial.
```

**SQL:**

```sql
DROP PROCEDURE IF EXISTS sp_listar_funcionarios_filial;

DELIMITER //
CREATE PROCEDURE sp_listar_funcionarios_filial(IN p_id_filial INT)
BEGIN
    SELECT
        f.id_func,
        f.nome_func,
        c.nome_cargo,
        f.id_filial
    FROM FUNCIONARIO f
    JOIN CARGO c ON c.id_cargo = f.id_cargo
    WHERE f.id_filial = p_id_filial
    ORDER BY f.nome_func;
END //
DELIMITER ;
```

**Execução:**

```sql
CALL sp_listar_funcionarios_filial(1);
CALL sp_listar_funcionarios_filial(3);
```

**Resultado esperado:**

```text
Com os dados de exemplo do projeto, a filial 1 lista Anna Paula e a filial 3 lista Carlos Henrique. O resultado real depende dos dados cadastrados.
```

# 5. Procedure 2 — operação do domínio

**Objetivo:**

```text
Consultar os dados de um funcionário. Se o ID não existir, retornar uma mensagem.
```

**SQL:**

```sql
DROP PROCEDURE IF EXISTS sp_consultar_funcionario;

DELIMITER //
CREATE PROCEDURE sp_consultar_funcionario(IN p_id_func INT)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM FUNCIONARIO
        WHERE id_func = p_id_func
    ) THEN
        SELECT
            f.id_func,
            f.nome_func,
            c.nome_cargo,
            s.nome_setor,
            fi.Localizacao AS filial
        FROM FUNCIONARIO f
        JOIN CARGO c ON c.id_cargo = f.id_cargo
        JOIN SETOR s ON s.id_setor = f.id_setor
        JOIN FILIAL fi ON fi.id_filial = f.id_filial
        WHERE f.id_func = p_id_func;
    ELSE
        SELECT 'Funcionário não encontrado' AS mensagem;
    END IF;
END //
DELIMITER ;
```

**Execução:**

```sql
CALL sp_consultar_funcionario(1);
CALL sp_consultar_funcionario(99);
```

# 6. Procedure com OUT

**SQL do projeto:**

```sql
DROP PROCEDURE IF EXISTS sp_contar_funcionarios_filial;

DELIMITER //
CREATE PROCEDURE sp_contar_funcionarios_filial(
    IN p_id_filial INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM FUNCIONARIO
    WHERE id_filial = p_id_filial;
END //
DELIMITER ;
```

**Execução:**

```sql
CALL sp_contar_funcionarios_filial(1, @total);
SELECT @total AS total_funcionarios;

CALL sp_contar_funcionarios_filial(3, @total);
SELECT @total AS total_funcionarios;
```

# 7. Function

**Objetivo:**

```text
Retornar o salário-base do cargo informado. Se o cargo não existir, retornar 0.
```

**Parâmetro recebido:**

```text
p_id_cargo INT — identificador do cargo.
```

**Valor retornado:**

```text
Salário-base do cargo, em DECIMAL(10,2). Retorna 0.00 se não encontrar o cargo.
```

**SQL:**

```sql
DROP FUNCTION IF EXISTS fn_salario_base_cargo;

DELIMITER //
CREATE FUNCTION fn_salario_base_cargo(p_id_cargo INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_salario DECIMAL(10,2);

    SELECT salario_base INTO v_salario
    FROM CARGO
    WHERE id_cargo = p_id_cargo;

    IF v_salario IS NULL THEN
        RETURN 0.00;
    ELSE
        RETURN v_salario;
    END IF;
END //
DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT fn_salario_base_cargo(1) AS salario;
SELECT fn_salario_base_cargo(2) AS salario;
```

# 8. IF / ELSE

**Regra de negócio implementada:**

```text
Ao consultar um funcionário, a rotina verifica se o ID existe. Se existir, mostra os dados; caso contrário, retorna uma mensagem. A Function também usa IF/ELSE para retornar 0.00 quando o cargo não é encontrado.
```

```sql
CALL sp_consultar_funcionario(1);
CALL sp_consultar_funcionario(99);
SELECT fn_salario_base_cargo(5) AS salario;
```

# 9. Procedure x Function

## Procedure

```text
Executa uma rotina e pode retornar resultados de consultas ou valores por parâmetros OUT. É chamada com CALL.
```

## Function

```text
Calcula ou consulta um valor e o retorna para ser usado em uma expressão, como em SELECT.
```

## Quando você utilizaria cada uma no seu projeto?

```text
Usaria Procedure para listar funcionários por filial ou consultar um funcionário. Usaria Function para obter o salário-base de um cargo em uma consulta.
```

# 10. Testes obrigatórios

## Procedure 1

```sql
CALL sp_listar_funcionarios_filial(1);
CALL sp_listar_funcionarios_filial(3);
```

**Resultados esperados:**

```text
Com os dados de exemplo, a filial 1 retorna Anna Paula e a filial 3 retorna Carlos Henrique. Confirmar os resultados no MySQL Workbench.
```

## Procedure 2

```sql
CALL sp_consultar_funcionario(1);
CALL sp_consultar_funcionario(99);
```

**Resultados esperados:**

```text
O ID 1 retorna os dados de Carlos Henrique. O ID 99 retorna a mensagem “Funcionário não encontrado”, se esse ID não estiver cadastrado.
```

## Function

```sql
SELECT fn_salario_base_cargo(1) AS salario;
SELECT fn_salario_base_cargo(2) AS salario;
```

**Resultados esperados:**

```text
Com os dados de exemplo, o cargo 1 retorna 4500.00 e o cargo 2 retorna 2200.00. Confirmar no MySQL Workbench.
```

## Teste da Procedure com OUT

```sql
CALL sp_contar_funcionarios_filial(1, @total);
SELECT @total AS total_funcionarios;

CALL sp_contar_funcionarios_filial(3, @total);
SELECT @total AS total_funcionarios;
```

**Resultado esperado:**

```text
Com os dados de exemplo, ambas as filiais retornam 1 funcionário.
```

# 11. Validação prática presencial

**Rotina escolhida:**

```text
sp_listar_funcionarios_filial
```

```sql
CALL sp_listar_funcionarios_filial(1);
CALL sp_listar_funcionarios_filial(2);
```

```text
O parâmetro p_id_filial informa qual filial consultar. Ao mudar o valor de 1 para 2, a rotina lista os funcionários da outra filial. A consulta filtra FUNCIONARIO pelo id_filial e relaciona CARGO para mostrar o nome do cargo.
```

# 12. Quantidade mínima exigida

```text
2 Stored Procedures: atendido.
1 Function: atendido.
Parâmetro IN: atendido.
IF/ELSE: atendido.
Parâmetro OUT: incluído.
2 testes por rotina: comandos incluídos; executar e conferir no MySQL Workbench.
```

# 13. Estrutura recomendada do SPRINT4-5.sql

```text

-- parametro in

DROP PROCEDURE IF EXISTS sp_listar_funcionarios_filial;

DELIMITER //
CREATE PROCEDURE sp_listar_funcionarios_filial(IN p_id_filial INT)
BEGIN
    SELECT
        f.id_func,
        f.nome_func,
        c.nome_cargo,
        f.id_filial
    FROM FUNCIONARIO f
    JOIN CARGO c ON c.id_cargo = f.id_cargo
    WHERE f.id_filial = p_id_filial
    ORDER BY f.nome_func;
END //
DELIMITER ;

CALL sp_listar_funcionarios_filial(1);
CALL sp_listar_funcionarios_filial(3);

-- Operação do dominio

DROP PROCEDURE IF EXISTS sp_consultar_funcionario;

DELIMITER //
CREATE PROCEDURE sp_consultar_funcionario(IN p_id_func INT)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM FUNCIONARIO
        WHERE id_func = p_id_func
    ) THEN
        SELECT
            f.id_func,
            f.nome_func,
            c.nome_cargo,
            s.nome_setor,
            fi.Localizacao AS filial
        FROM FUNCIONARIO f
        JOIN CARGO c ON c.id_cargo = f.id_cargo
        JOIN SETOR s ON s.id_setor = f.id_setor
        JOIN FILIAL fi ON fi.id_filial = f.id_filial
        WHERE f.id_func = p_id_func;
    ELSE
        SELECT 'Funcionário não encontrado' AS mensagem;
    END IF;
END //
DELIMITER ;

CALL sp_consultar_funcionario(1);
CALL sp_consultar_funcionario(99);

-- Procedure OUT

DROP PROCEDURE IF EXISTS sp_contar_funcionarios_filial;

DELIMITER //
CREATE PROCEDURE sp_contar_funcionarios_filial(
    IN p_id_filial INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM FUNCIONARIO
    WHERE id_filial = p_id_filial;
END //
DELIMITER ;

CALL sp_contar_funcionarios_filial(1, @total);
SELECT @total AS total_funcionarios;

CALL sp_contar_funcionarios_filial(3, @total);
SELECT @total AS total_funcionarios;

-- Function

DROP FUNCTION IF EXISTS fn_salario_base_cargo;

DELIMITER //
CREATE FUNCTION fn_salario_base_cargo(p_id_cargo INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_salario DECIMAL(10,2);

    SELECT salario_base INTO v_salario
    FROM CARGO
    WHERE id_cargo = p_id_cargo;

    IF v_salario IS NULL THEN
        RETURN 0.00;
    ELSE
        RETURN v_salario;
    END IF;
END //
DELIMITER ;

SELECT fn_salario_base_cargo(1) AS salario;
SELECT fn_salario_base_cargo(2) AS salario;

-- IF ELSE

CALL sp_consultar_funcionario(1);
CALL sp_consultar_funcionario(99);
SELECT fn_salario_base_cargo(5) AS salario;

```

# 14. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Rodando arquivo linha por linha não inicializa o delimiter | Sei não | Rodar o arquivo inteiro |
|  |  |  |
|  |  |  |

# 15. Uso de LLMs

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

# 16. Checklist

- [x] utilizei o banco do projeto;
- [x] expliquei o uso do `DELIMITER`;
- [x] criei pelo menos 2 Procedures;
- [x] criei uma Function;
- [x] utilizei parâmetro `IN`;
- [x] incluí uma rotina com `OUT`;
- [x] utilizei `IF/ELSE`;
- [x] executei e conferi cada rotina no MySQL Workbench;
- [x] confirmei os resultados com parâmetros diferentes;
- [x] confirmei que consigo explicar todas as rotinas;
- [x] organizei o conteúdo de `SPRINT4-5.md`.

# 17. Git/GitHub

**Branch:**

```text
team-04
```

**Arquivo:**

```text
Module-2/SPRINT4-5.md
```

**Commit sugerido:**

```text
Conclui Module 2 Sprint 4 de 5 - procedures e functions
```

Não abra o Pull Request final ainda.

# Próxima etapa

```sql
TRIGGER
START TRANSACTION
COMMIT
ROLLBACK
```
