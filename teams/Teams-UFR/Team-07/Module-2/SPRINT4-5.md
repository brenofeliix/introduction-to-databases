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

> Walter Anacleto Salido de Souza

**Banco utilizado:**

```
db_raaei
```

---

# 2. Planejamento das rotinas

Defina rotinas úteis ao seu sistema.

| Rotina | Tipo | Entrada | Saída | Objetivo |
|---|---|---|---|---|

| sp_cadastrar_atleta | Procedure | p_nome, p_genero, p_nascimento, p_escola, p_categoria | Mensagem de confirmação / Registro inserido | Automatizar a inserção de novos atletas com validação prévia de integridade referencial nas tabelas de escolas e categorias.

| sp_contar_atletas_por_rede | Procedure | p_tipo_rede (IN), p_total (OUT) | Quantidade de atletas vinculados à rede informada | Retornar o quantitativo total de praticantes de acordo com o tipo de rede de ensino (ex: Pública ou Privada) utilizando parâmetros de saída.

| fn_calcular_idade | Functionp_data_nascimento | Inteiro (INT - Idade em anos) | Calcular de forma dinâmica e precisa a idade atual de um atleta ou colaborador com base na data de nascimento informada.

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

> O comando DELIMITER é utilizado para alterar temporariamente o caractere de terminação de instruções do SGBD (que por padrão é o ponto e vírgula ;). Em rotinas procedurais como Procedures e Functions, precisamos agrupar múltiplos comandos SQL internos dentro de blocos BEGIN ... END, e cada comando interno termina naturalmente com ;. Se o SGBD interpretasse o ponto e vírgula padrão no meio da rotina, ele encerraria a criação prematuramente, gerando erros de sintaxe. Ao definir um delimitador customizado (como // ou $$), garantimos que todo o bloco da rotina seja lido e enviado ao servidor como uma única unidade lógica antes de restaurar o delimitador padrão.


---

# 4. Procedure 1 — parâmetro IN

Crie uma Procedure que receba pelo menos um parâmetro.

**Objetivo:**

> Listar de forma automatizada todos os atletas cadastrados que pertencem a uma categoria esportiva específica passada como parâmetro de entrada, facilitando a visualização das turmas de treinamento pela equipe técnica.

**Parâmetro de entrada:**

```
p_id_categoria (INT): Identificador único da categoria esportiva a ser consultada.

```

**SQL:**

```
DELIMITER //

CREATE PROCEDURE sp_listar_atletas_por_categoria(IN p_id_categoria INT)
BEGIN
    SELECT 
        a.id_atleta,
        a.nome_atleta,
        a.genero,
        a.data_nascimento,
        c.nome_categoria,
        c.faixa_etaria
    FROM atleta AS a
    INNER JOIN categoria AS c 
        ON a.id_categoria = c.id_categoria
    WHERE a.id_categoria = p_id_categoria
    ORDER BY a.nome_atleta;
END //

DELIMITER ;
```

**Execução:**

```
-- Executando a procedure para listar os atletas da categoria com ID 3 (ex: Arremesso de Peso Sub-18)
CALL sp_listar_atletas_por_categoria(3);
```

**Resultado esperado:**

> O SGBD executa o bloco procedural, filtrando os registros da tabela atleta com base no ID da categoria fornecido via parâmetro IN (p_id_categoria), retornando uma tabela formatada contendo o nome, gênero, data de nascimento e os dados da modalidade de todos os praticantes inscritos naquela turma específica da associação.

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

> Atualizar a escola de origem de um atleta cadastrado na associação, permitindo que a diretoria técnica mantenha os registros institucionais e educacionais dos jovens praticantes sempre precisos e atualizados.

```
DELIMITER //

CREATE PROCEDURE sp_atualizar_escola_atleta(
    IN p_id_atleta INT,
    IN p_novo_id_escola INT
)
BEGIN
    UPDATE atleta
    SET id_escola = p_novo_id_escola
    WHERE id_atleta = p_id_atleta;
END //

DELIMITER ;
```

**Execução:**

```
-- Atualiza a escola do atleta com ID 1 para a nova instituição de ensino (ID 2)
CALL sp_atualizar_escola_atleta(1, 2);
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

```
DELIMITER //

CREATE PROCEDURE sp_contar_total_atletas(
    OUT p_total_atletas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_atletas
    FROM atleta;
END //

DELIMITER ;

-- Executando a Procedure e recuperando a variável de saída
CALL sp_contar_total_atletas(@total_cadastrados);
SELECT @total_cadastrados AS total_geral_atletas;
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

> Calcular de forma automatizada e dinâmica a idade exata (em anos) de um atleta ou colaborador com base em sua data de nascimento, permitindo que a comissão técnica valide rapidamente a elegibilidade para categorias etárias em competições oficiais.

**Parâmetro recebido:**

```
p_data_nascimento (DATE): Data de nascimento do praticante ou colaborador cadastrado.
```

**Valor retornado:**

```
INT: O valor numérico correspondente à idade atual em anos.
```

**SQL:**

```
DELIMITER //

CREATE FUNCTION fn_calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_idade INT;
    SET v_idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
    RETURN v_idade;
END //

DELIMITER ;
```

**Exemplo de uso:**

```
-- Consultando o nome, data de nascimento e a idade calculada pela função para cada atleta
SELECT 
    nome_atleta,
    data_nascimento,
    fn_calcular_idade(data_nascimento) AS idade_atual
FROM atleta;
```

---

# 8. IF / ELSE - 

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

> Classificar automaticamente o status competitivo de um atleta da associação com base em sua idade atual. Caso o praticante tenha menos de 18 anos, o sistema o categoriza como "Atleta de Base (Formação)"; caso contrário, o classifica como "Atleta Principal / Adulto", auxiliando a diretoria técnica e os treinadores na gestão das equipes de rendimento e de base.

```
DELIMITER //

CREATE PROCEDURE sp_verificar_classificacao_etaria(
    IN p_id_atleta INT,
    OUT p_classificacao VARCHAR(50)
)
BEGIN
    DECLARE v_idade INT;
    
    -- Obtém a idade do atleta utilizando a função auxiliar fn_calcular_idade
    SELECT fn_calcular_idade(data_nascimento) INTO v_idade
    FROM atleta
    WHERE id_atleta = p_id_atleta;
    
    -- Aplicação da estrutura condicional IF / ELSE para definição da faixa competitiva
    IF v_idade < 18 THEN
        SET p_classificacao = 'Atleta de Base (Formação)';
    ELSE
        SET p_classificacao = 'Atleta Principal / Adulto';
    END IF;
END //

DELIMITER ;

-- Exemplo de execução:
-- CALL sp_verificar_classificacao_etaria(1, @status_atleta);
-- SELECT @status_atleta AS classificacao_competitiva;
```

---

# 9. Procedure x Function

Explique com suas palavras.

## Procedure

> Uma Procedure (Procedimento Armazenado) é uma rotina procedural executada diretamente no servidor de banco de dados que agrupa um bloco de comandos SQL. Ela é ideal para realizar operações complexas, manipulação de dados (INSERT, UPDATE, DELETE), controle transacional e lógica condicional. Procedures podem receber múltiplos parâmetros de entrada (IN) e retornar dados através de parâmetros de saída (OUT), sendo invocadas no SGBD por meio do comando CALL.

## Function

> Uma Function (Função) é uma rotina desenvolvida para realizar cálculos, transformações ou validações e retornar obrigatoriamente um único valor (escalar). Diferente das procedures, as funções são projetadas para serem integradas diretamente dentro de instruções SQL (como em cláusulas SELECT, WHERE ou ORDER BY), encapsulando regras de negócio puras sem causar efeitos colaterais diretos na persistência dos dados.

## Quando você utilizaria cada uma no seu projeto?

> Utilizaria Procedures para automatizar processos operacionais e administrativos que modificam o estado do banco de dados ou exigem múltiplos passos, a exemplo de rotinas de cadastro institucional, alteração de vínculos escolares de atletas ou procedimentos que retornam sumários gerenciais complexos via parâmetros OUT.
> Utilizaria Functions sempre que precisar de uma regra de cálculo ou formatação que deva ser aplicada de forma fluida e inline nas consultas e relatórios. O exemplo clássico no sistema é a função fn_calcular_idade, utilizada diretamente nos comandos SELECT para calcular e exibir a idade atual dos atletas e colaboradores de forma dinâmica.

---

# 10. Testes obrigatórios

Para cada rotina, execute pelo menos dois testes com parâmetros diferentes.

## Procedure 1

```
-- Teste 1: Listando atletas da categoria com ID 1 (Ex: Sub-16)
CALL sp_listar_atletas_por_categoria(1);

-- Teste 2: Listando atletas da categoria com ID 3 (Ex: Sub-18)
CALL sp_listar_atletas_por_categoria(3);
```

**Resultados:**

> Teste 1: A procedure executou com sucesso, varrendo a tabela atleta unida à tabela categoria e retornando todos os jovens praticantes vinculados especificamente à turma de ID 1, ordenados alfabeticamente por nome.
> Teste 2: Ao alterar o parâmetro de entrada para 3, o SGBD dinamicamente filtrou e exibiu o conjunto correspondente de atletas daquela nova modalidade, comprovando o correto funcionamento do parâmetro IN e da cláusula WHERE encapsulada.

## Procedure 2

```
-- Teste 1: Atualizando a escola do atleta ID 1 para a instituição ID 2
CALL sp_atualizar_escola_atleta(1, 2);

-- Teste 2: Atualizando a escola do atleta ID 4 para a instituição ID 1
CALL sp_atualizar_escola_atleta(4, 1);
```

**Resultados:**

> Teste 1: O comando de atualização (UPDATE) interno processou o registro do atleta de ID 1, modificando com sucesso sua chave estrangeira id_escola para o novo valor 2. Uma consulta posterior à tabela base confirmou a persistência imediata da alteração.
> Teste 2: A execução com os parâmetros (4, 1) alterou corretamente a escola de origem do quarto atleta cadastrado para a rede de ensino ID 1, demonstrando a reutilização e eficácia do procedimento de gestão cadastral.

## Function

```
-- Teste 1: Calculando a idade para uma data de nascimento do ano de 2010
SELECT fn_calcular_idade('2010-05-14') AS idade_atleta_1;

-- Teste 2: Calculando a idade para uma data de nascimento do ano de 2008
SELECT fn_calcular_idade('2008-09-22') AS idade_atleta_2;
```

**Resultados:**

> Teste 1: A função processou a data informada com base na função temporal do sistema (CURDATE()), retornando de forma escalar a idade exata correspondente (ex: 16 anos considerando o ano corrente de 2026).
> Teste 2: A função retornou com precisão o valor escalar correspondente para a segunda data informada (17 anos), comprovando que a rotina pode ser aplicada diretamente em consultas ou relatórios para qualquer parâmetro de data de nascimento fornecido.

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
sp_verificar_classificacao_etaria
```

```
DELIMITER //

CREATE PROCEDURE sp_verificar_classificacao_etaria(
    IN p_id_atleta INT,
    OUT p_classificacao VARCHAR(50)
)
BEGIN
    DECLARE v_idade INT;
    
    -- Obtém a idade do atleta utilizando a função auxiliar fn_calcular_idade
    SELECT fn_calcular_idade(data_nascimento) INTO v_idade
    FROM atleta
    WHERE id_atleta = p_id_atleta;
    
    -- Aplicação da estrutura condicional IF / ELSE para definição da faixa competitiva
    IF v_idade < 18 THEN
        SET p_classificacao = 'Atleta de Base (Formação)';
    ELSE
        SET p_classificacao = 'Atleta Principal / Adulto';
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

```
-- MODULE 2 — SPRINT 4/5
-- PROCEDURES E FUNCTIONS

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

DELIMITER //

-- =====================================================================
-- 1. PROCEDURE 1 — Parâmetro IN (Listar atletas por categoria)
-- =====================================================================
CREATE PROCEDURE sp_listar_atletas_por_categoria(IN p_id_categoria INT)
BEGIN
    SELECT 
        a.id_atleta,
        a.nome_atleta,
        a.genero,
        a.data_nascimento,
        c.nome_categoria,
        c.faixa_etaria
    FROM atleta AS a
    INNER JOIN categoria AS c 
        ON a.id_categoria = c.id_categoria
    WHERE a.id_categoria = p_id_categoria
    ORDER BY a.nome_atleta;
END //

-- =====================================================================
-- 2. PROCEDURE 2 — Operação de Domínio / Atualização Cadastral
-- =====================================================================
CREATE PROCEDURE sp_atualizar_escola_atleta(
    IN p_id_atleta INT,
    IN p_novo_id_escola INT
)
BEGIN
    UPDATE atleta
    SET id_escola = p_novo_id_escola
    WHERE id_atleta = p_id_atleta;
END //

-- =====================================================================
-- 3. PROCEDURE COM OUT — Contagem total de atletas
-- =====================================================================
CREATE PROCEDURE sp_contar_total_atletas(
    OUT p_total_atletas INT
)
BEGIN
    SELECT COUNT(*) INTO p_total_atletas
    FROM atleta;
END //

-- =====================================================================
-- 4. PROCEDURE COM IF / ELSE — Classificação etária e competitiva
-- =====================================================================
CREATE PROCEDURE sp_verificar_classificacao_etaria(
    IN p_id_atleta INT,
    OUT p_classificacao VARCHAR(50)
)
BEGIN
    DECLARE v_idade INT;
    
    -- Obtém a idade do atleta utilizando a função escalar fn_calcular_idade
    SELECT fn_calcular_idade(data_nascimento) INTO v_idade
    FROM atleta
    WHERE id_atleta = p_id_atleta;
    
    -- Estrutura condicional para definir o perfil competitivo
    IF v_idade < 18 THEN
        SET p_classificacao = 'Atleta de Base (Formação)';
    ELSE
        SET p_classificacao = 'Atleta Principal / Adulto';
    END IF;
END //

-- =====================================================================
-- 5. FUNCTION — Cálculo dinâmico de idade (DETERMINISTIC)
-- =====================================================================
CREATE FUNCTION fn_calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_idade INT;
    SET v_idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
    RETURN v_idade;
END //

DELIMITER ;

-- =====================================================================
-- 6. TESTES COM CALL (Procedures)
-- =====================================================================
-- Testes da Procedure 1 (Listar por Categoria)
CALL sp_listar_atletas_por_categoria(1);
CALL sp_listar_atletas_por_categoria(3);

-- Testes da Procedure 2 (Atualizar Escola do Atleta)
CALL sp_atualizar_escola_atleta(1, 2);
CALL sp_atualizar_escola_atleta(4, 1);

-- Testes da Procedure com OUT (Contagem de Atletas)
CALL sp_contar_total_atletas(@total_cadastrados);
SELECT @total_cadastrados AS total_geral_atletas;

-- Testes da Procedure com IF / ELSE (Classificação Etária)
CALL sp_verificar_classificacao_etaria(1, @status_atleta_1);
SELECT @status_atleta_1 AS classificacao_atleta_1;

CALL sp_verificar_classificacao_etaria(5, @status_atleta_2);
SELECT @status_atleta_2 AS classificacao_atleta_2;

-- =====================================================================
-- 7. TESTES COM SELECT (Functions)
-- =====================================================================
-- Teste 1 da Function (Cálculo de idade para data específica)
SELECT fn_calcular_idade('2010-05-14') AS idade_teste_1;

-- Teste 2 da Function (Cálculo de idade para outra data específica)
SELECT fn_calcular_idade('2008-09-22') AS idade_teste_2;

-- Teste integrando a Function diretamente em uma consulta aos atletas cadastrados
SELECT 
    nome_atleta,
    data_nascimento,
    fn_calcular_idade(data_nascimento) AS idade_atual_atleta
FROM atleta;
```

---

# 14. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|

| Erro de sintaxe ao compilar rotinas contendo múltiplos comandos terminados em ponto e vírgula (;). | O SGBD interpreta o primeiro ponto e vírgula interno como o fim da instrução SQL, encerrando a criação prematuramente antes de processar o bloco completo. | Envolver a rotina com os comandos DELIMITER // (ou outro caractere personalizado) no início e restaurar para DELIMITER ; ao final do script.

| Erro FUNCTION db_raaei.fn_calcular_idade does not exist ou falha ao referenciá-la dentro de uma Procedure. | A função foi criada em um banco diferente ou o script falhou em ser executado integralmente antes da criação da Procedure que a consome. | Garantir que o comando USE db_raaei; esteja ativo e que a Function seja compilada com sucesso antes de criar Procedures que façam chamadas a ela.

| Erro RETURN is only allowed in a FUNCTION ao tentar utilizar o comando RETURN dentro de uma Stored Procedure. | Confusão conceitual entre Procedures e Functions: Procedures gerenciam fluxo e parâmetros de saída (OUT), enquanto apenas Functions utilizam o comando RETURN para devolver um valor escalar diretamente. | Substituir o comando RETURN por parâmetros de saída (OUT) e atribuições via SET ou SELECT ... INTO quando estiver desenvolvendo Stored Procedures.

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
