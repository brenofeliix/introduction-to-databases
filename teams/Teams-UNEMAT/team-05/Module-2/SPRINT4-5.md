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

> Escreva aqui.
Ylma Cristina Souza Lopes
**Banco utilizado:**

```text
Clinica_Ser
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|
|confirmar_agendamento| Procedure |id_agendamento, data_confirmacao|Mensagem de confirmação|Atualizar status de agendamento para confirmado|
|cancelar_agendamento| Procedure |id_agendamento|Mensagem de cancelamento|Marcar agendamento como cancelado e liberar horário|
|calcular_faturamento_periodo| Function |data_inicio, data_fim|Valor numérico (faturamento total)|Calcular o faturamento total em um período específico|

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

> Escreva aqui.
O DELIMITER é usado para alterar o caractere que marca o fim de um comando SQL padrão (normalmente ;). Como Procedures e Functions podem conter múltiplos comandos SQL que usam ; internamente, é preciso mudar temporariamente o delimitador para que o sistema não interprete o ; interno como fim da criação da rotina. Ao final, o delimitador volta para ;.
---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Escreva aqui.
Agendar um exame para um paciente, informando o paciente, exame, médico e data/hora.
**Parâmetro de entrada:**

```text
p_id_paciente INT, p_id_exame INT, p_id_medico INT, p_data DATETIME

```

**SQL:**

```sql
-- Cole aqui.
DELIMITER //

CREATE PROCEDURE sp_agendar_exame (
    IN p_id_paciente INT,
    IN p_id_exame INT,
    IN p_id_medico INT,
    IN p_data DATETIME
)
BEGIN
    INSERT INTO Agendamento (id_paciente, id_exame, id_medico, data_hora)
    VALUES (p_id_paciente, p_id_exame, p_id_medico, p_data);
END //

DELIMITER ;

```

**Execução:**

```sql
CALL ...
CALL sp_agendar_exame(1, 1, 1, '2026-10-15 14:00:00');

```

**Resultado esperado:**

> Escreva aqui.
Um novo agendamento é inserido na tabela com os dados fornecidos.
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

> Escreva aqui.
Verificar se um paciente é elegível para atendimento via convênio (plano) ou se deve ser atendido como particular.
```sql
-- Cole aqui.
DELIMITER //

CREATE PROCEDURE sp_verificar_elegibilidade (
    IN p_id_paciente INT,
    OUT p_status VARCHAR(50)
)
BEGIN
    DECLARE v_convenio INT;
    SELECT id_convenio INTO v_convenio FROM Paciente WHERE id_paciente = p_id_paciente;
    
    IF v_convenio IS NOT NULL THEN
        SET p_status = 'Elegível para atendimento via plano';
    ELSE
        SET p_status = 'Atendimento particular';
    END IF;
END //

DELIMITER ;

```

**Execução:**

```sql
CALL ...
CALL sp_verificar_elegibilidade(1, @status);
SELECT @status;

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
-- Cole aqui.
```

Caso não seja aplicável, justifique:

> Escreva aqui.
Já apresentada na Procedure 2 acima, que utiliza OUT para retornar um status.
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

> Escreva aqui.
Calcular o preço final de um exame, aplicando desconto para pacientes conveniados.
**Parâmetro recebido:**

```text
p_preco DECIMAL(10,2), p_convenio INT
```

**Valor retornado:**

```text
DECIMAL(10,2) — preço com desconto aplicado ou preço original
```

**SQL:**

```sql
-- Cole aqui.
DELIMITER //

CREATE FUNCTION fn_calcular_desconto (
    p_preco DECIMAL(10,2),
    p_convenio INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE desconto DECIMAL(10,2);
    IF p_convenio IS NOT NULL THEN
        SET desconto = p_preco * 0.85; -- 15% de desconto para conveniados
    ELSE
        SET desconto = p_preco;
    END IF;
    RETURN desconto;
END //

DELIMITER ;

```

**Exemplo de uso:**

```sql
SELECT nome_funcao(...);
SELECT tipo_exame, preco, fn_calcular_desconto(preco, 1) AS preco_final FROM Exame;

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

> Escreva aqui.
Aplicação de desconto ao preço do exame conforme o convênio do paciente.
```sql
-- Cole aqui.
-- Utilizado dentro da função fn_calcular_desconto

IF p_convenio IS NOT NULL THEN
    SET desconto = p_preco * 0.85;
ELSE
    SET desconto = p_preco;
END IF;

```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Escreva aqui.
É uma rotina que executa uma série de comandos e pode alterar dados no banco (INSERT, UPDATE, DELETE). Pode ou não retornar valores via parâmetros OUT mas não em formato direto para uso em uma consulta.
## Function

> Escreva aqui.
Retorna um valor único e pode ser usada diretamente em consultas SQL (SELECT). Deve sempre retornar um resultado e não alterar dados no banco.
## Quando você utilizaria cada uma no seu projeto?

> Escreva aqui.
Use procedures para operações que envolvam alterações no banco ou processos complexos com vários passos. Use functions para cálculos ou operações que retornam um único valor e que se integrem facilmente em consultas.
---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```sql
CALL ...;
CALL ...;
CALL sp_agendar_exame(1, 1, 1, '2026-10-15 14:00:00');
CALL sp_agendar_exame(2, 2, 3, '2026-10-20 09:30:00');

```

**Resultados:**

> Escreva aqui.
Duas inserções diferentes na tabela Agendamento, com pacientes, exames, médicos e datas distintas.

## Procedure 2

```sql
CALL ...;
CALL ...;
CALL sp_verificar_elegibilidade(1, @status);
SELECT @status;

CALL sp_verificar_elegibilidade(100, @status);
SELECT @status;

```

**Resultados:**

> Escreva aqui.
Para o paciente 1, retorna "Elegível para atendimento via plano" (se tiver convênio). Para o paciente 100 (que não exista ou não tenha convênio), retorna "Atendimento particular".

## Function

```sql
SELECT ...;
SELECT ...;
SELECT fn_calcular_desconto(100, 1);
SELECT fn_calcular_desconto(100, NULL);

```

**Resultados:**

> Escreva aqui.
Para convênio 1, retorna 85.00 (15% de desconto). Para NULL, retorna 100.00 (sem desconto).
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
sp_verificar_elegibilidade

```

```sql
-- Cole aqui.
DELIMITER //

CREATE PROCEDURE sp_verificar_elegibilidade (
    IN p_id_paciente INT,
    OUT p_status VARCHAR(50)
)
BEGIN
    DECLARE v_convenio INT;
    SELECT id_convenio INTO v_convenio FROM Paciente WHERE id_paciente = p_id_paciente;
    
    IF v_convenio IS NOT NULL THEN
        SET p_status = 'Elegível para atendimento via plano';
    ELSE
        SET p_status = 'Atendimento particular';
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
|Procedure não executa devido a erro|Sintaxe incorreta ou falta do DELIMITER para procedimentos com múltiplos comandos|Usar DELIMITER para definir corretamente o término do bloco SQL|
|Parâmetro OUT não retorna valor|Não foi usado símbolo correto para capturar o valor (ex.: variável de sessão)|Após CALL, usar variável de sessão (@variavel) para capturar saída|
|Function retorna valor incorreto|Lógica da função incorreta ou tratamento errado de NULL|Revisar lógica da função, tratar valores NULL e testar com dados reais|

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

- [V] utilizei o banco do projeto;
- [V] compreendi o uso do `DELIMITER`;
- [V] criei pelo menos 2 Procedures;
- [V] criei uma Function;
- [V] utilizei parâmetro `IN`;
- [V] utilizei `OUT` quando aplicável;
- [V] utilizei `IF/ELSE`;
- [V] testei cada rotina;
- [V] executei parâmetros diferentes;
- [V] consigo explicar todas as rotinas;
- [V] salvei `SPRINT4-5.md`;
- [V] salvei `SPRINT4-5.sql`.

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
