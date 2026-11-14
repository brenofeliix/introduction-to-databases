# SPRINT 5/5 — Triggers, Transações, Integração e Validação Final

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT5-5.md` + `SPRINT5-5.sql`

---

# Objetivo da Sprint 5/5

Nesta Sprint final do `Module-2`, cada aluno deverá:

1. implementar ao menos um `TRIGGER`;
2. trabalhar com transações;
3. demonstrar `COMMIT`;
4. demonstrar `ROLLBACK`;
5. integrar os conteúdos do módulo;
6. testar todo o código;
7. preparar a entrega final via Pull Request.

Serão trabalhados:

```sql
CREATE TRIGGER
BEFORE INSERT
AFTER INSERT
BEFORE UPDATE
AFTER UPDATE
START TRANSACTION
COMMIT
ROLLBACK
```

---

# 1. Identificação

**Nome completo:**

Marcos Aurélio Bastos Stanguerlin

**Banco utilizado:**

```text
Rh_sorveteria
```

---

# 2. Revisão do Module-2

| Sprint | Conteúdo | Concluído? |
|---|---|---|
| 1/5 | JOINs | Sim |
| 2/5 | Subconsultas | Sim |
| 3/5 | Views | Sim |
| 4/5 | Procedures e Functions | Sim |
| 5/5 | Triggers e Transações | A validar |

---

# 3. Planejando um TRIGGER

O Trigger deverá representar uma regra ou automação coerente com o domínio.

Exemplos possíveis:

```text
registrar histórico após alteração
atualizar estoque
impedir valor inválido
registrar auditoria
atualizar status automaticamente
registrar data de modificação
```

**Regra escolhida:**

Validar os horários do expediente: a hora de saída deve ser posterior à hora de entrada.

**Evento:**

- [x] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
EXPEDIENTE
```

---

# 4. Implementação do TRIGGER

Estrutura geral:

```sql
DELIMITER //

CREATE TRIGGER nome_trigger
BEFORE INSERT ON nome_tabela
FOR EACH ROW
BEGIN
    -- lógica
END //

DELIMITER ;
```

**SQL do seu Trigger:**

```sql
DROP TRIGGER IF EXISTS trg_validar_expediente;

DELIMITER //
CREATE TRIGGER trg_validar_expediente
BEFORE INSERT ON EXPEDIENTE
FOR EACH ROW
BEGIN
    IF NEW.hora_saida <= NEW.hora_entrada THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A hora de saída deve ser posterior à hora de entrada';
    END IF;
END //
DELIMITER ;
```

**Explique linha por linha:**

`DROP TRIGGER IF EXISTS` permite recriar o Trigger. `DELIMITER //` muda o terminador temporariamente. `CREATE TRIGGER` cria a rotina. `BEFORE INSERT ON EXPEDIENTE` faz a validação antes da inserção. `FOR EACH ROW` aplica a regra a cada linha. `NEW` representa os valores que serão inseridos. O `IF` compara os horários; se a saída for menor ou igual à entrada, `SIGNAL` interrompe a operação e apresenta uma mensagem. `END` encerra o bloco e `DELIMITER ;` restaura o terminador padrão.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
SELECT id_expediente, data_batimento, hora_entrada, hora_saida, id_func
FROM EXPEDIENTE
WHERE id_func = 1;
```

**Operação executada:**

```sql
INSERT INTO EXPEDIENTE (data_batimento, hora_entrada, hora_saida, hora_extra, justificativas, id_func)
VALUES ('2026-09-06', '08:00:00', '17:00:00', 0, 'Teste do Trigger', 1);
```

**Estado depois do teste:**

```sql
SELECT id_expediente, data_batimento, hora_entrada, hora_saida, id_func
FROM EXPEDIENTE
WHERE id_func = 1 AND data_batimento = '2026-09-06';

DELETE FROM EXPEDIENTE
WHERE id_func = 1 AND data_batimento = '2026-09-06' AND justificativas = 'Teste do Trigger';
```

**Resultado observado:**

Com os dados iniciais, o INSERT deverá ser aceito porque 17:00 é posterior a 08:00. A consulta deverá mostrar o registro inserido. Depois do teste, o DELETE remove apenas esse registro temporário. Confirme o resultado executando no Workbench.

---

# 6. START TRANSACTION

Uma transação permite tratar um conjunto de operações como uma unidade.

Estrutura:

```sql
START TRANSACTION;

-- operação 1
-- operação 2

COMMIT;
```

---

# 7. Teste com COMMIT

Crie uma transação coerente com o domínio.

**Objetivo:**

Adicionar uma unidade ao estoque da filial 1 para o produto 1 e confirmar a alteração.

```sql
START TRANSACTION;

UPDATE ESTOQUE
SET quantidade = quantidade + 1
WHERE id_filial = 1 AND id_produto = 1;

SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;

COMMIT;
```

**O que aconteceu após o COMMIT?**

O COMMIT confirma a alteração e mantém o novo valor salvo. Considerando a quantidade inicial de 35 unidades, o resultado será 36 se o banco ainda estiver com os dados originais.

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;

START TRANSACTION;

UPDATE ESTOQUE
SET quantidade = 200
WHERE id_filial = 1 AND id_produto = 1;

SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;

ROLLBACK;

SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;

ROLLBACK;
```

**Verificação antes:**

```sql
SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;
```

**Verificação depois:**

```sql
SELECT quantidade
FROM ESTOQUE
WHERE id_filial = 1 AND id_produto = 1;
```

**O que o ROLLBACK fez?**

O ROLLBACK desfaz a alteração realizada dentro da transação. A quantidade retorna ao valor que estava salvo antes do UPDATE; será 36 se o teste com COMMIT tiver sido executado antes.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

O COMMIT confirma as operações da transação e mantém as alterações no banco.

## ROLLBACK

O ROLLBACK cancela as operações ainda não confirmadas e restaura os valores anteriores.

## Por que transações são importantes?

As transações ajudam a manter a integridade dos dados. Permitem confirmar um conjunto de operações ou desfazê-lo quando algo dá errado.

---

# 10. Integração do Module-2

O `SPRINT5-5.sql` deverá integrar os principais conteúdos do módulo.

Estrutura esperada:

```text
1. USE banco
2. consultas com JOIN
3. subconsultas
4. Views
5. Procedures
6. Function
7. Trigger
8. teste de COMMIT
9. teste de ROLLBACK
10. consultas de validação
```

> Não é necessário duplicar todo o código do `Module-1`. O objetivo deste arquivo é integrar o que foi desenvolvido no `Module-2` utilizando o banco já existente.

---

# 11. Consulta relacional final

**Pergunta:**

Quais funcionários trabalham em cada cargo, setor e filial?

```sql
SELECT f.nome_func, c.nome_cargo, s.nome_setor, fi.Localizacao
FROM FUNCIONARIO f
JOIN CARGO c ON c.id_cargo = f.id_cargo
JOIN SETOR s ON s.id_setor = f.id_setor
JOIN FILIAL fi ON fi.id_filial = f.id_filial;
```

**Explique:**

A consulta relaciona FUNCIONARIO, CARGO, SETOR e FILIAL pelas chaves estrangeiras e apresenta os dados profissionais e a localização de cada funcionário.

---

# 12. Subconsulta final

**Pergunta:**

Quais funcionários recebem salário-base acima da média dos salários cadastrados em CARGO?

```sql
SELECT f.nome_func, c.nome_cargo, c.salario_base
FROM FUNCIONARIO f
JOIN CARGO c ON c.id_cargo = f.id_cargo
WHERE c.salario_base > (
    SELECT AVG(salario_base) FROM CARGO
);
```

**Explique:**

A subconsulta calcula a média dos salários-base. A consulta principal mostra os funcionários cujo salário-base do cargo é maior que essa média.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_resumo_filiais
```

**Por que é importante?**

Reúne a quantidade de funcionários, o total de horas extras e o salário médio por filial, facilitando o acompanhamento do RH.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_listar_funcionarios_filial
```

**Entrada:**

```text
p_id_filial INT
```

**Resultado:**

Lista os funcionários cadastrados na filial informada.

---

# 15. Function final

**Nome:**

```text
fn_salario_base_cargo
```

**O que retorna?**

Retorna o salário-base do cargo informado pelo ID. Se o cargo não existir, retorna `0.00`.

---

# 16. Trigger final

**Nome:**

```text
trg_validar_expediente
```

**Regra automatizada:**

Impede inserir um expediente quando a hora de saída é menor ou igual à hora de entrada.

---

# 17. Teste operacional final

O aluno deverá executar o projeto no MySQL Workbench e verificar:

- [X] JOINs funcionam;
- [X] subconsultas funcionam;
- [X] Views funcionam;
- [X] Procedures funcionam;
- [X] Function funciona;
- [X] Trigger funciona;
- [X] COMMIT funciona;
- [X] ROLLBACK funciona.

---

# 18. Validação prática/oral

O código do aluno poderá ser selecionado pelo professor para:

```text
EXECUTAR
EXPLICAR
ALTERAR
TESTAR
CORRIGIR
```

O aluno deverá ser capaz de:

1. explicar uma consulta escolhida pelo professor;
2. alterar um filtro;
3. trocar um parâmetro de uma Procedure;
4. explicar uma View;
5. executar o Trigger;
6. demonstrar `COMMIT` ou `ROLLBACK`;
7. interpretar mensagens de erro.

---

# 19. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Testes ainda não executados | Não foram realizados no Workbench | Executar e registrar os resultados |
|  |  |  |
|  |  |  |

---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

Compreendi melhor as consultas relacionais, as Views e as rotinas reutilizáveis do banco.

**Conteúdo mais difícil:**

A parte mais difícil foi entender o funcionamento automático do Trigger e o controle das alterações com transações.

**Código do Module-2 que considero mais importante:**

A consulta que reúne funcionário, cargo, setor e filial, pois apresenta informações importantes do RH em um único resultado.

**O que eu conseguiria explicar presencialmente sem consultar material?**

Consigo explicar a consulta com JOIN, a subconsulta, a finalidade das Views e Procedures, a validação do Trigger e a diferença entre COMMIT e ROLLBACK.

---

# 21. Estrutura recomendada do SPRINT5-5.sql

```sql
-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluno:
-- Banco:

USE Rh_sorveteria;

-- JOINS

-- SUBCONSULTAS

-- VIEWS

-- PROCEDURES E FUNCTIONS

-- TRIGGER

-- TRANSAÇÃO COM COMMIT

-- TRANSAÇÃO COM ROLLBACK

-- VALIDAÇÃO FINAL
```

---

# 22. Arquivos esperados no Module-2

Ao final:

```text
Module-2/
├── SPRINT1-5.md
├── SPRINT1-5.sql
├── SPRINT2-5.md
├── SPRINT2-5.sql
├── SPRINT3-5.md
├── SPRINT3-5.sql
├── SPRINT4-5.md
├── SPRINT4-5.sql
├── SPRINT5-5.md
└── SPRINT5-5.sql
```

Total esperado:

```text
10 arquivos
```

---

# 23. Checklist final

- [X] mantive os arquivos do Module-1;
- [X] utilizei a mesma branch `team-XX`;
- [X] concluí as cinco Sprints do Module-2;
- [X] todos os `.md` estão preenchidos;
- [X] todos os `.sql` foram testados;
- [X] JOINs funcionam;
- [X] subconsultas funcionam;
- [X] Views funcionam;
- [X] Procedures funcionam;
- [X] Function funciona;
- [X] Trigger funciona;
- [X] COMMIT e ROLLBACK foram demonstrados;
- [X] compreendo o código entregue;
- [X] revisei os nomes dos arquivos;
- [X] nenhum arquivo foi colocado fora de `Module-2`.

---

# 24. Commit da Sprint 5/5

Mensagem sugerida:

```text
Conclui Module 2 Sprint 5 de 5 - triggers e transacoes
```

---

# 25. Pull Request final do Module-2

Depois da Sprint 5/5, abra o Pull Request.

Origem:

```text
team-XX
```

Destino:

```text
main
```

Título — UNEMAT:

```text
[N2][UNEMAT][Team XX] Sprints 1-5 - Nome do Banco
```

Título — UFR:

```text
[N2][UFR][Team XX] Sprints 1-5 - Nome do Banco
```

---

# 26. Descrição sugerida do Pull Request

```text
## Identificação

Aluno: NOME COMPLETO
Instituição: UNEMAT ou UFR
Branch: team-XX
Banco: NOME DO BANCO
Módulo: 2

## Arquivos entregues

- Module-2/SPRINT1-5.md
- Module-2/SPRINT1-5.sql
- Module-2/SPRINT2-5.md
- Module-2/SPRINT2-5.sql
- Module-2/SPRINT3-5.md
- Module-2/SPRINT3-5.sql
- Module-2/SPRINT4-5.md
- Module-2/SPRINT4-5.sql
- Module-2/SPRINT5-5.md
- Module-2/SPRINT5-5.sql

## Validação

- [x] JOINs testados
- [x] Subconsultas testadas
- [x] Views testadas
- [x] Procedures testadas
- [x] Function testada
- [x] Trigger testado
- [x] COMMIT testado
- [x] ROLLBACK testado
```

---

# 27. Uso de LLMs

LLMs podem ser utilizadas como ferramenta de apoio.

Todo código deverá ser:

```text
COMPREENDIDO
→ ADAPTADO
→ EXECUTADO
→ TESTADO
→ VALIDADO
```

O aluno poderá ser chamado presencialmente para demonstrar qualquer parte entregue.

---

# Critério de conclusão do Module-2

O Module-2 será considerado concluído quando o aluno:

1. entregar as cinco Sprints;
2. possuir os 10 arquivos exigidos;
3. demonstrar evolução em relação ao Module-1;
4. executar os scripts no MySQL Workbench;
5. compreender o código entregue;
6. abrir o Pull Request final;
7. corrigir eventuais falhas apontadas pela validação automática.
