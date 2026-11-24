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

> NICOLAS LINO OLIVEIRA

**Banco utilizado:**

```text
banco_imobiliaria
```

---

# 2. Planejamento das rotinas

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| sp_listar_imoveis_por_tipo | Procedure | p_tipo (IN) | Tabela de imóveis do tipo | Buscar imóveis por tipo (casa, apartamento etc.) |
| sp_registrar_proposta | Procedure | p_id_cliente, p_id_imovel, p_valor (IN) | Mensagem de sucesso ou de erro | Registrar proposta respeitando a regra "valor maior que zero" |
| sp_contar_visitas_cliente | Procedure | p_id_cliente (IN) | p_total (OUT) | Informar quantas visitas um cliente já fez |
| fn_calcular_comissao | Function | p_id_corretor, p_valor | Valor da comissão (DECIMAL) | Calcular a comissão de um corretor sobre um valor |

---

# 3. DELIMITER

```sql
DELIMITER //

CREATE PROCEDURE exemplo()
BEGIN
    SELECT * FROM tabela;
END //

DELIMITER ;
```

**Explique por que o `DELIMITER` é utilizado:**

> Normalmente o `;` encerra um comando SQL. Dentro de uma Procedure ou Function existem vários comandos terminados por `;` entre o `BEGIN` e o `END`. Sem trocar o delimitador, o MySQL Workbench entenderia que o primeiro `;` já termina o `CREATE PROCEDURE` e daria erro. Com `DELIMITER //`, o `;` passa a ser um texto comum dentro da rotina e só o `//` encerra a criação. No final, `DELIMITER ;` devolve o padrão.

---

# 4. Procedure 1 — parâmetro IN

**Objetivo:**

> Listar os imóveis de um tipo escolhido pelo usuário, do mais barato ao mais caro.

**Parâmetro de entrada:**

```text
p_tipo VARCHAR(50): tipo do imóvel (casa, apartamento, comercial, terreno)
```

**SQL:**

```sql
DELIMITER //

CREATE PROCEDURE sp_listar_imoveis_por_tipo(
    IN p_tipo VARCHAR(50)
)
BEGIN
    SELECT
        id_imovel,
        endereco,
        tipo,
        preco,
        status
    FROM imoveis
    WHERE tipo = p_tipo
    ORDER BY preco ASC;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_listar_imoveis_por_tipo('casa');
```

**Resultado esperado:**

> Retorna as 2 casas cadastradas: a da Rua das Palmeiras, 88 (R$ 590.000,00) e a da Rua das Camélias, 45 (R$ 780.000,00), nessa ordem.

---

# 5. Procedure 2 — operação do domínio

**Objetivo:**

> Registrar uma nova proposta de um cliente para um imóvel, aplicando a regra de negócio da Sprint 1 do Module 1: "uma proposta não pode ter valor menor ou igual a zero". Se o valor for válido, a proposta é inserida com a data atual e o status 'em análise'.

```sql
DELIMITER //

CREATE PROCEDURE sp_registrar_proposta(
    IN p_id_cliente INT,
    IN p_id_imovel INT,
    IN p_valor DECIMAL(12, 2)
)
BEGIN
    IF p_valor <= 0 THEN
        SELECT 'ERRO: o valor da proposta deve ser maior que zero.' AS mensagem;
    ELSE
        INSERT INTO propostas (id_cliente, id_imovel, valor_proposto, data_proposta, status)
        VALUES (p_id_cliente, p_id_imovel, p_valor, CURDATE(), 'em análise');

        SELECT
            'Proposta registrada com sucesso.' AS mensagem,
            LAST_INSERT_ID() AS id_proposta;
    END IF;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_registrar_proposta(6, 4, 300000.00);
```

---

# 6. Procedure com OUT

```sql
DELIMITER //

CREATE PROCEDURE sp_contar_visitas_cliente(
    IN p_id_cliente INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM visitas
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_contar_visitas_cliente(1, @total);
SELECT @total;
```

> O parâmetro `IN` leva o id do cliente para dentro da Procedure. O parâmetro `OUT` devolve o resultado para fora, na variável `@total`, que depois pode ser consultada com `SELECT`.

---

# 7. Function

## Function obrigatória

**Objetivo:**

> Calcular, em reais, a comissão que um corretor recebe sobre um valor, usando o percentual cadastrado em `corretores`.

**Parâmetro recebido:**

```text
p_id_corretor INT: identificador do corretor
p_valor DECIMAL(12,2): valor da venda ou do contrato
```

**Valor retornado:**

```text
DECIMAL(12,2): comissão em reais (0 se o corretor não existir)
```

**SQL:**

```sql
DELIMITER //

CREATE FUNCTION fn_calcular_comissao(
    p_id_corretor INT,
    p_valor DECIMAL(12, 2)
)
RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE v_percentual DECIMAL(5, 2);

    SET v_percentual = (
        SELECT comissao_percentual
        FROM corretores
        WHERE id_corretor = p_id_corretor
    );

    IF v_percentual IS NULL THEN
        RETURN 0;
    ELSE
        RETURN p_valor * v_percentual / 100;
    END IF;
END //

DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT fn_calcular_comissao(1, 500000.00);
```

> Foi usado `READS SQL DATA` porque a função lê a tabela `corretores`. Sem essa declaração (ou `DETERMINISTIC`), o MySQL pode recusar a criação da função.

---

# 8. IF / ELSE

**Regra de negócio implementada:**

> Na Procedure `sp_registrar_proposta`: uma proposta não pode ter valor menor ou igual a zero. Na Function `fn_calcular_comissao`: se o corretor não existir, a comissão é 0.

```sql
-- Na procedure sp_registrar_proposta
IF p_valor <= 0 THEN
    SELECT 'ERRO: o valor da proposta deve ser maior que zero.' AS mensagem;
ELSE
    INSERT INTO propostas (id_cliente, id_imovel, valor_proposto, data_proposta, status)
    VALUES (p_id_cliente, p_id_imovel, p_valor, CURDATE(), 'em análise');
    SELECT 'Proposta registrada com sucesso.' AS mensagem, LAST_INSERT_ID() AS id_proposta;
END IF;

-- Na function fn_calcular_comissao
IF v_percentual IS NULL THEN
    RETURN 0;
ELSE
    RETURN p_valor * v_percentual / 100;
END IF;
```

---

# 9. Procedure x Function

## Procedure

> É uma rotina que executa um conjunto de comandos (consultar, inserir, alterar) e é chamada com `CALL`. Pode devolver tabelas de resultado e aceitar parâmetros `IN`, `OUT` e `INOUT`. Não precisa retornar um valor único.

## Function

> É uma rotina que sempre devolve um único valor, com `RETURN`, e pode ser usada dentro de um `SELECT`, como qualquer função do MySQL (`SUM`, `AVG`...). Recebe parâmetros apenas de entrada.

## Quando você utilizaria cada uma no seu projeto?

> **Procedure:** para operações do dia a dia da imobiliária, como registrar uma proposta (que valida e insere) ou listar imóveis por tipo. **Function:** para cálculos reutilizáveis dentro de consultas, como a comissão do corretor, que pode ser usada em relatórios com `SELECT id_contrato, fn_calcular_comissao(id_corretor, valor_final) FROM contratos`.

---

# 10. Testes obrigatórios

## Procedure 1

```sql
CALL sp_listar_imoveis_por_tipo('casa');
CALL sp_listar_imoveis_por_tipo('terreno');
```

**Resultados:**

> Com `'casa'` retornou 2 imóveis (R$ 590.000 e R$ 780.000). Com `'terreno'` retornou 1 imóvel (Rodovia Helder Cândia, R$ 350.000). Mudando o parâmetro, o resultado mudou.

## Procedure 2

```sql
CALL sp_registrar_proposta(6, 4, 0);
CALL sp_registrar_proposta(6, 4, 300000.00);
```

**Resultados:**

> Com valor 0, apareceu a mensagem de erro e nenhuma proposta foi inserida. Com R$ 300.000,00, a proposta foi inserida com status 'em análise' e a procedure mostrou a mensagem de sucesso com o id da nova proposta. Depois do teste, o registro foi removido com `DELETE` para manter os dados originais.

## Procedure com OUT

```sql
CALL sp_contar_visitas_cliente(1, @total);
SELECT @total;

CALL sp_contar_visitas_cliente(6, @total);
SELECT @total;
```

**Resultados:**

> O cliente 1 (Lucas) retornou 1 visita, e o cliente 6 (Larissa) retornou 0.

## Function

```sql
SELECT fn_calcular_comissao(1, 500000.00);
SELECT fn_calcular_comissao(2, 400000.00);
SELECT fn_calcular_comissao(99, 100000.00);
```

**Resultados:**

> Corretor 1 (6%) sobre R$ 500.000 retornou R$ 30.000,00. Corretor 2 (5,5%) sobre R$ 400.000 retornou R$ 22.000,00. Corretor 99, que não existe, retornou 0.

---

# 11. Validação prática presencial

**Rotina escolhida:**

```text
fn_calcular_comissao
```

```sql
CREATE FUNCTION fn_calcular_comissao(
    p_id_corretor INT,
    p_valor DECIMAL(12, 2)
)
RETURNS DECIMAL(12, 2)
READS SQL DATA
BEGIN
    DECLARE v_percentual DECIMAL(5, 2);

    SET v_percentual = (
        SELECT comissao_percentual
        FROM corretores
        WHERE id_corretor = p_id_corretor
    );

    IF v_percentual IS NULL THEN
        RETURN 0;
    ELSE
        RETURN p_valor * v_percentual / 100;
    END IF;
END;
```

> 1. **Parâmetros:** `p_id_corretor` é o id do corretor (para buscar o percentual) e `p_valor` é o valor sobre o qual a comissão será calculada.
> 2. **Alterar um parâmetro:** trocar `fn_calcular_comissao(1, 500000)` por `fn_calcular_comissao(4, 500000)`.
> 3. **Resultado novo:** o corretor 4 (Fernanda, 6,5%) retorna R$ 32.500,00, em vez de R$ 30.000,00 do corretor 1 (6%).
> 4. **Por que mudou:** o valor é o mesmo, mas o percentual guardado na tabela `corretores` é diferente para cada corretor.
> 5. **Lógica interna:** a função declara a variável `v_percentual`, busca o percentual do corretor na tabela, e o `IF` decide: se o corretor não existe (`NULL`), retorna 0; senão, retorna `valor * percentual / 100`.

---

# 12. Quantidade mínima exigida

| Exigência | Atendida em |
|---|---|
| 2 Stored Procedures | itens 4 e 5 (mais a do item 6) |
| 1 Function | item 7 |
| 1 rotina com parâmetro IN | itens 4, 5 e 6 |
| 1 uso de IF/ELSE | item 8 |
| 1 rotina com OUT | item 6 |
| 2 testes por rotina | item 10 |

---

# 13. Estrutura do SPRINT4-5.sql

O arquivo segue a estrutura recomendada: `USE`, `DELIMITER //`, Procedure 1, Procedure 2, Procedure com OUT, Function, `DELIMITER ;`, testes com `CALL`, testes com `SELECT` e validação com `SHOW PROCEDURE STATUS` e `SHOW FUNCTION STATUS`. No início há `DROP ... IF EXISTS`, que permite executar o script mais de uma vez.

---

# 14. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro 1064 (sintaxe) ao criar a Procedure | O `;` dentro do `BEGIN ... END` encerrava o comando antes da hora | Usar `DELIMITER //` antes e `DELIMITER ;` depois |
| Erro 1418 ao criar a Function | O MySQL exige declarar o tipo da função quando o log binário está ativo | Declarar `READS SQL DATA` na função |
| Erro 1304: "PROCEDURE already exists" ao rodar o script de novo | A rotina já tinha sido criada | Usar `DROP PROCEDURE IF EXISTS` e `DROP FUNCTION IF EXISTS` antes de criar |

---

# 15. Uso de LLMs

Foi utilizada uma LLM como apoio para estruturar as rotinas. O código foi compreendido, adaptado, executado, testado e validado no MySQL Workbench, e consigo explicar presencialmente cada rotina entregue.

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

Mesma branch:

```text
team-05
```

Arquivos:

```text
Module-2/SPRINT4-5.md
Module-2/SPRINT4-5.sql
```

Commit:

```text
Conclui Module 2 Sprint 4 de 5 - procedures e functions
```

Pull Request final não aberto.
