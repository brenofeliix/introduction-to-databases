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

> Raquel Silva dos Santos

**Banco utilizado:**

```text
series_watchlist_db
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
| sp_listar_series_por_plataforma | Procedure | p_nome_plataforma VARCHAR(50) | Tabela com séries | Listar produções do catálogo que pertencem a um determinado streaming informado. |
| sp_atualizar_status_watchlist | Procedure | p_id_usuario INT, p_id_serie INT, p_novo_status VARCHAR(20), p_nota TINYINT | Mensagem de estado / Atualização | Atualizar o estado e a nota de um item na watchlist com validação condicional de regras de negócio. |
| sp_resumo_usuario | Procedure | p_id_usuario INT (IN), p_total_series INT (OUT), p_media_pessoal DECIMAL(3,1) (OUT) | Variáveis com totais agregados | Contar o volume de séries na lista e calcular a média pessoal de notas de um usuário. |
| fn_classificar_desempenho_serie | Function | p_id_serie INT | VARCHAR(30) | Retornar uma classificação textual ('Excelente', 'Bom', 'Regular / Baixo', 'Sem Avaliações') com base na média aritmética da série. |


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

>O MySQL utiliza o ponto e vírgula (;) como caractere delimitador padrão para indicar o fim de uma instrução SQL. No entanto, corpos de rotinas armazenadas (BEGIN ... END) contêm múltiplas instruções internas terminadas por ponto e vírgula. O comando DELIMITER (por exemplo, DELIMITER //) altera temporariamente o delimitador da consola, permitindo que todo o bloco da rotina seja transmitido e compilado no servidor sem ser interrompido antecipadamente no primeiro ponto e vírgula interno. No fim, restaura-se o padrão com DELIMITER ;.

---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Consultar e projetar todas as séries cadastradas que pertencem a uma plataforma de streaming informada como parâmetro de entrada.

**Parâmetro de entrada:**

```text
p_nome_plataforma VARCHAR(50)
```

**SQL:**

```sql
DELIMITER //

CREATE PROCEDURE sp_listar_series_por_plataforma(
    IN p_nome_plataforma VARCHAR(50)
)
BEGIN
    SELECT 
        s.id_serie,
        s.titulo AS nome_serie,
        s.genero,
        s.ano_lancamento,
        s.pais_origem,
        p.nome_plataforma AS plataforma
    FROM serie AS s
    INNER JOIN plataforma AS p
        ON s.id_plataforma = p.id_plataforma
    WHERE p.nome_plataforma = p_nome_plataforma;
END //

DELIMITER ;
```

**Execução:**

```sql
CALL sp_listar_series_por_plataforma('Netflix');
```

**Resultado esperado:**

> Retorno de um conjunto com as séries pertencentes à plataforma informada (como Stranger Things e Dark no caso da Netflix).   
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

> Atualizar o progresso de acompanhamento (status_assistindo) e a nota de uma obra na watchlist de um utilizador. A rotina impede a atribuição de notas caso o estado ainda seja definido como 'Quero Ver', gravando NULL e exibindo mensagem informativa.   

```sql
-- DELIMITER //

CREATE PROCEDURE sp_atualizar_status_watchlist(
    IN p_id_usuario INT,
    IN p_id_serie INT,
    IN p_novo_status VARCHAR(20),
    IN p_nota TINYINT

)
BEGIN
    IF p_novo_status = 'Quero Ver' THEN
        UPDATE item_watchlist
        SET status_assistindo = p_novo_status,
            nota = NULL
        WHERE id_usuario = p_id_usuario 
          AND id_serie = p_id_serie;
        SELECT 'Item atualizado para Quero Ver. A nota foi ajustada para NULL.' AS mensagem;
    ELSE
        UPDATE item_watchlist
        SET status_assistindo = p_novo_status,
            nota = p_nota
        WHERE id_usuario = p_id_usuario 
          AND id_serie = p_id_serie;
        SELECT 'Item atualizado com sucesso.' AS mensagem;
    END IF;
END //

DELIMITER ;
```

**Execução:**

```sql
-- Testes da Procedure 2
CALL sp_atualizar_status_watchlist(1, 5, 'Assistindo', 8);
CALL sp_atualizar_status_watchlist(1, 5, 'Quero Ver', 9);
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

CREATE PROCEDURE sp_resumo_usuario(
    IN  p_id_usuario INT,
    OUT p_total_series INT,
    OUT p_media_pessoal DECIMAL(3,1)
)
BEGIN
    SELECT 
        COUNT(*),
        ROUND(COALESCE(AVG(nota), 0.0), 1)
    INTO 
        p_total_series,
        p_media_pessoal
    FROM item_watchlist
    WHERE id_usuario = p_id_usuario;
END //

DELIMITER ;
```

Caso não seja aplicável, justifique:

> Não se aplica, pois o requisito foi atendido integralmente com a implementação da procedure `sp_resumo_usuario` utilizando parâmetros `OUT` para exportar o total de séries e a média aritmética das notas.

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

> Calcular a nota média de uma série no catálogo e retornar uma classificação qualitativa padronizada para interfaces e relatórios analíticos.   

**Parâmetro recebido:**

```text
p_id_serie INT
```

**Valor retornado:**

```text
VARCHAR(30)
```

**SQL:**

```sql
DELIMITER //

CREATE FUNCTION fn_classificar_desempenho_serie(
    p_id_serie INT
)
RETURNS VARCHAR(30)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(3,1);
    DECLARE v_resultado VARCHAR(30);

    SELECT AVG(nota)
    INTO v_media
    FROM item_watchlist
    WHERE id_serie = p_id_serie 
      AND nota IS NOT NULL;

    IF v_media IS NULL THEN
        SET v_resultado = 'Sem Avaliações';
    ELSEIF v_media >= 9.0 THEN
        SET v_resultado = 'Excelente';
    ELSEIF v_media >= 7.0 THEN
        SET v_resultado = 'Bom';
    ELSE
        SET v_resultado = 'Regular / Baixo';
    END IF;

    RETURN v_resultado;
END //

DELIMITER ;
```

**Exemplo de uso:**

```sql
SELECT 
    titulo, 
    fn_classificar_desempenho_serie(id_serie) AS classificacao
FROM serie;
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

> Se uma série não possui notas registadas na watchlist, a função classifica-a como 'Sem Avaliações'. Para séries avaliadas, se a nota média for maior ou igual a 9.0, ela é categorizada como 'Excelente'; caso esteja entre 7.0 e 8.9, como 'Bom'; abaixo disso, é classificada como 'Regular / Baixo'.
```sql
IF v_media IS NULL THEN
    SET v_resultado = 'Sem Avaliações';
ELSEIF v_media >= 9.0 THEN
    SET v_resultado = 'Excelente';
ELSEIF v_media >= 7.0 THEN
    SET v_resultado = 'Bom';
ELSE
    SET v_resultado = 'Regular / Baixo';
END IF;
---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Uma Stored Procedure executa ações, tarefas e manipulações de dados (como INSERT, UPDATE, DELETE ou consultas com múltiplos conjuntos de retorno) no servidor. Ela não é obrigada a devolver dados e é invocada explicitamente através do comando CALL.

## Function

> Uma Stored Function tem como finalidade primordial calcular e devolver obrigatoriamente um único valor escalar por meio da cláusula RETURN. Ela pode ser acoplada diretamente em expressões SQL (SELECT, WHERE, ORDER BY).

## Quando você utilizaria cada uma no seu projeto?

> No projeto series_watchlist_db:Procedure: Para rotinas transacionais ou que executam operações no banco, como matricular séries na watchlist, alternar estados de visualização e gerar relatórios completos com tabelas relacionais.   Function: Para rotinas determinísticas de cálculo ou formatação unitária, como converter notas numéricas em conceitos textuais ou calcular a idade de lançamento de um título a partir do ano corrente.   

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL sp_listar_series_por_plataforma('Netflix');
CALL sp_listar_series_por_plataforma('HBO Max');
```

**Resultados:**

> O primeiro teste filtrou e listou as séries Stranger Things e Dark associadas à Netflix.   O segundo teste retornou as séries The Last of Us e Succession vinculadas à HBO Max. 

## Procedure 2

```sql
CALL sp_atualizar_status_watchlist(1, 5, 'Assistindo', 8.5);
CALL sp_atualizar_status_watchlist(1, 5, 'Quero Ver', 9.0);
```

**Resultados:**

> O primeiro teste alterou o estado de Severance para 'Assistindo' com nota 8.5.   O segundo teste acionou a condicional do IF, convertendo o estado de volta para 'Quero Ver' e forçando o campo nota para NULL, garantindo a integridade da regra de negócio. 

## Function

```sql
SELECT id_serie, titulo, fn_classificar_desempenho_serie(id_serie) AS resultado 
FROM serie 
WHERE id_serie = 2;

SELECT id_serie, titulo, fn_classificar_desempenho_serie(id_serie) AS resultado 
FROM serie 
WHERE id_serie = 4;
```

**Resultados:**

> Para a série 2 (The Last of Us), com notas elevadas (9.0 e 10.0), a função retornou 'Excelente'.   Para a série 4 (The Mandalorian), que só possuía registos com nota NULL, a função identificou a ausência de avaliações e retornou 'Sem Avaliações'.  
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
sp_resumo_usuario
```

```sql
DELIMITER //

CREATE PROCEDURE sp_resumo_usuario(
    IN  p_id_usuario INT,
    OUT p_total_series INT,
    OUT p_media_pessoal DECIMAL(3,1)
)
BEGIN
    SELECT 
        COUNT(*),
        ROUND(COALESCE(AVG(nota), 0.0), 1)
    INTO 
        p_total_series,
        p_media_pessoal
    FROM item_watchlist
    WHERE id_usuario = p_id_usuario;
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
| Média retornando `NULL` para usuários sem notas na procedure com OUT | `AVG(nota)` avalia para nulo quando não há registros ou quando todas as notas são nulas | Aplicação de `COALESCE(AVG(nota), 0.0)` em conjunto com `ROUND()` para garantir retorno numérico consistente. |
| Inconsistência de nota presente em obras com status 'Quero Ver' | Usuário enviar valor de nota ao marcar um título que ainda não começou a assistir | Inclusão de desvio condicional (`IF/ELSE`) na procedure forçando `nota = NULL` ao receber o status `'Quero Ver'`. |
| Erro de compilação da Function por controle de binlog do MySQL | Funções que realizam leitura de dados exigem propriedades de determinismo declaradas | Adicionadas as cláusulas `DETERMINISTIC` e `READS SQL DATA` no cabeçalho da Function. |
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
