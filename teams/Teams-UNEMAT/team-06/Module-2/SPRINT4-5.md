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

> Mariano Lino da Silva Neto
**Banco utilizado:**

```
DB_Conveniencia
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| sp_baixar_estoque | Procedure | p_id_produto, p_qtd_comprada | Sucesso ou mensagem de erro | Verificar se no estoque tem produtos suficientes |
| sp_produtos_por_categoria | Procedure | p_nome_categoria | Lista de produtos | facilita a busca pelo produto filtrando com base no nome da categoria |
| fn_aplicar_desconto | Function | p_valor, p_porcentagem | Valor numérico  | Calcular o preço final de um produto aplicando um percentual de desconto |
|sp_total_vendas_periodo|Procedure|Nenhuma|p_total_arrecadado(OUT)|Somar e devolver o valor financeiro total de todas as vendas que foram realizadas|
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

> Ele serve para alterar temporariamente o caractere que finaliza os comandos no MYSQL, como procedures e Functions possuem comandos internos finalizados pelo: ;, a gente precisa mudar o delimitador global para fazer o banco ler a rotina inteira de uma vez só, indo do Begin até o END sem interromper a criação na primeira linha.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Dar baixa no estoque de algum produto no momento da venda, se houver quantidade suficiente disponivel.

**Parâmetro de entrada:**

```
p_id_produto (INT), p_qtd_comprada

```

**SQL:**

```sql
DELIMITER //
CREATE PROCEDURE sp_baixar_estoque(IN p_id_produto INT, IN p_qtd_comprada INT)
BEGIN
DECLARE v_estoque_atual INT;

SELECT quantidade_estoque INTO v_estoque_atual
FROM Produto
WHERE id_produto = p_id_produto;

IF v_estoque_atual >= p_qtd_comprada THEN
UPDATE Produto
SET quantidade_estoque = quantidade_estoque - p_qtd_comprada
WHERE id_produto = p_id_produto;
SELECT 'Sucesso: Estoque atualizado!' AS Status_Operacao;
ELSE
SELECT 'Erro: Estoque insuficiente para realizar essa venda.' AS Status_Operacao;
END IF;
END //
DELIMITER ;
```

**Execução:**

```sql
CALL sp_baixar_estoque(1, 5); 
```

**Resultado esperado:**

> Ele vai checar e subtrair produtos do estoque 1 e se tiver mais de 5 ele vai conseguir remover com sucesso, se tiver menos que 5 ele não vai tirar nada e vai dar erro.

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

> Lista de forma eficiente todos os produtos que pertecem a uma determinada categoria apenas com o nome dela, sem usar o JOIN.

```sql
DELIMITER //
CREATE PROCEDURE sp_produtos_por_categoria(IN p_nome_categoria VARCHAR(50))
BEGIN
SELECT 
p.id_produto,
p.nome_produto,
p.preco_venda,
p.quantidade_estoque
FROM Produto p
INNER JOIN Categoria c ON p.id_categoria = c.id_categoria
WHERE c.nome_categoria = p_nome_categoria;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_produtos_por_categoria('Salgados');
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
CREATE PROCEDURE sp_total_vendas_periodo(OUT p_total_arrecadado DECIMAL(10,2))
BEGIN
SELECT SUM(valor_total) INTO p_total_arrecadado
FROM Venda;
END //
DELIMITER ;

CALL sp_total_vendas_periodo(@meu_faturamento);
SELECT @meu_faturamento AS Faturamento_Total_Loja;
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

> Calcular de forma dinamica o valor de um produto caso a loja queira aplicar uma porcentagem de desconto

**Parâmetro recebido:**

```
p_valor DECIMAL(10,2), p_porcentagem DECIMAL(5,2)
```

**Valor retornado:**

```
DECIMAL(10,2) (o valor final após aplicar o desconto)
```

**SQL:**

```sql
DELIMITER //
CREATE FUNCTION fn_aplicar_desconto(p_valor DECIMAL(10,2), p_porcentagem DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
DECLARE v_valor_final DECIMAL(10,2);

IF p_porcentagem > 0 THEN
SET v_valor_final = p_valor - (p_valor *(p_porcentagem / 100));
ELSE 
SET v_valor_final = p_valor;
END IF;
RETURN v_valor_final;
END //
DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT 
nome_produto,
preco_venda AS preco_original,
fn_aplicar_desconto(preco_venda, 10.00) AS preco_com_10_porcento_desconto
FROM Produto; 
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

> Vamos usar a procedure sp_baixar_estoque aqui pra isso então, essa regra de negocio vai proteger a integridade dos dados da loja, ou seja: O caixa não vai poder vender um produto que não tem na pratileira, já que não tem como deixar a coluna quantidade_estoque negativa.

```sql
IF v_estoque_atual >= p_qtd_comprada THEN
UPDATE Produto
SET quantidade_estoque = quantidade_estoque - p_qtd_comprada
WHERE id_produto = p_id_produto;
SELECT 'Sucesso: Estoque atualizado!' AS Status_Operacao;
ELSE
SELECT 'Erro: Estoque insuficiente para realizar essa venda.' AS Status_Operacao;
END IF;
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Ele basicamente é um bloco de comandos onde o SQL armazena uma serie de ações, onde os procedures podem inserir, atualizar e consultar os dados, e ele não vão necessariamente retornar alguma coisa, e eles são utilizados usando o comando CALL.

## Function

> Ela é uma rotina que se foca exclusivamente em cálculos de dados de diferentes procedures, onde uma function tem que retornar um único valor obrigatório, ela não tem como ser chamada pela CALL mas sim pela WHERE e SELECT

## Quando você utilizaria cada uma no seu projeto?

> As procedures serão usadas para automatizar regras de negocio e também processos, já a FUNCTIOn vai ser usada para a facilidade na leitura dos dados, visto que é melhor automatizar esses processos do que deixar pra uma pessoa que talvez possa cometer erros.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL sp_baixar_estoque(1, 5);
CALL sp_baixar_estoque(1, 99999);
```

**Resultados:**

> O primeiro obviamente vai dar certo pq tem itens suficientes, mas o segundo CALL não vai dar certo por não ter estoque o suficiente para ser tirado.

## Procedure 2

```sql
CALL sp_produtos_por_categoria('Salgados');
CALL sp_produtos_por_categoria('Bebidas');
```

**Resultados:**

> A primeira chamada me entrega todos os itens que são da categoria salgados de forma perfeita, onde vamos ter os itens Pão frito e Salgado assado, enquanto no segundo CALL vamos ter as bebidas que serão o Refrigerante de 2l e o Suco Natural.

## Function

```sql
SELECT fn_aplicar_desconto(100.00,15.00) AS Teste_15_Porcento;
SELECT fn_aplicar_desconto(50.00, 0.00) AS Teste_Zero_Porcento;
```

**Resultados:**

> De modo pratico os dois descontos estão funcionando de forma perfeita, no primeiro ele de forma correta retira o desconto de 15 reais ficando apenas 85, enquanto no segundo teste ele deixa o valor original sem ser mexido, visto que nenhum desconto foi aplicado.

---

# 11. Validação prática presencial

Escolha uma rotina e prepare-se para:

1. explicar cada parâmetro;
2. alterar um parâmetro durante a aula;
3. executar novamente;
4. explicar por que o resultado mudou;
5. explicar a lógica interna.

**Rotina escolhida:**

```
sp_baixar_estoque
```

```sql
DELIMITER //
CREATE PROCEDURE sp_baixar_estoque(IN p_id_produto INT, IN p_qtd_comprada INT)
BEGIN
DECLARE v_estoque_atual INT;

SELECT quantidade_estoque INTO v_estoque_atual
FROM Produto
WHERE id_produto = p_id_produto;

IF v_estoque_atual >= p_qtd_comprada THEN
UPDATE Produto
SET quantidade_estoque = quantidade_estoque - p_qtd_comprada
WHERE id_produto = p_id_produto;
SELECT 'Sucesso: Estoque atualizado!' AS Status_Operacao;
ELSE
SELECT 'Erro: Estoque insuficiente para realizar essa venda.' AS Status_Operacao;
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
