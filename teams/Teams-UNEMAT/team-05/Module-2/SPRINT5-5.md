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

> Escreva aqui.
Ylma Cristina Souza Lopes

**Banco utilizado:**

```text
Clinica_Ser
```

---

# 2. Revisão do Module-2

| Sprint | Conteúdo | Concluído? |
|---|---|---|
| 1/5 | JOINs |V|
| 2/5 | Subconsultas |V|
| 3/5 | Views |V|
| 4/5 | Procedures e Functions |V|
| 5/5 | Triggers e Transações |V|

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

> Escreva aqui.
Registrar um histórico automático (log) sempre que um novo resultado de exame for inserido.
**Evento:**

- [ ] BEFORE INSERT
- [V] AFTER INSERT
- [ ] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
Resultado
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
-- Cole aqui.
DELIMITER //

CREATE TRIGGER trg_log_resultado
AFTER INSERT ON Resultado
FOR EACH ROW
BEGIN
    INSERT INTO Log_Laudo (id_resultado, data_emissao, usuario)
    VALUES (NEW.id_resultado, NOW(), CURRENT_USER());
END //

DELIMITER ;

```

**Explique linha por linha:**

> Escreva aqui.
DELIMITER // altera o delimitador para permitir múltiplas linhas.
CREATE TRIGGER trg_log_resultado cria um trigger chamado trg_log_resultado.
AFTER INSERT ON Resultado especifica que o trigger será executado após inserção na tabela Resultado.
FOR EACH ROW aplica a lógica para cada linha inserida.
No bloco BEGIN...END, insere um novo registro na tabela Log_Laudo com o id do resultado inserido, a data/hora atual e o usuário que fez a operação.
DELIMITER ; volta o delimitador ao padrão.
---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
-- SELECT utilizado.
SELECT * FROM Log_Laudo;

```

**Operação executada:**

```sql
-- INSERT ou UPDATE utilizado.
INSERT INTO Resultado (id_agendamento, resultado_texto) VALUES (1, 'Exame com resultado Normal.');

```

**Estado depois do teste:**

```sql
-- SELECT utilizado.
SELECT * FROM Log_Laudo;

```

**Resultado observado:**

> Escreva aqui.
Após inserir um resultado, um novo registro foi criado automaticamente na tabela Log_Laudo, com o id do resultado recém inserido, data e usuário, confirmando o funcionamento do trigger.
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

> Escreva aqui.
Inserir paciente e agendamento vinculados, garantindo que as duas operações sejam concluídas juntas.

```sql
START TRANSACTION;

-- operações
START TRANSACTION;

INSERT INTO Paciente (nome, cpf, data_nascimento, telefone, endereco, id_convenio) 
VALUES ('Lucas Fernandes', '09876543210', '1992-08-20', '66 99999-5555', 'Av B', 1);

SET @novo_paciente = LAST_INSERT_ID();

INSERT INTO Agendamento (id_paciente, id_exame, id_medico, data_hora) 
VALUES (@novo_paciente, 1, 1, '2026-11-10 10:00:00');

COMMIT;

COMMIT;
```

**O que aconteceu após o COMMIT?**

> Escreva aqui.
As duas inserções foram confirmadas e persistiram no banco de dados.
---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
START TRANSACTION;
START TRANSACTION;

UPDATE Exame SET preco = 5000.00 WHERE id_exame = 1; -- Aumento abusivo acidental

ROLLBACK; -- Desfaz a alteração

-- operações

ROLLBACK;
```

**Verificação antes:**

```sql
-- SELECT
SELECT preco FROM Exame WHERE id_exame = 1;

```

**Verificação depois:**

```sql
-- SELECT
SELECT preco FROM Exame WHERE id_exame = 1;

```

**O que o ROLLBACK fez?**

> Escreva aqui.
Reverteu a alteração feita no preço, mantendo o dado original intacto.
---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Explique com suas palavras.
Confirma todas as operações feitas dentro da transação, tornando as mudanças permanentes no banco.
## ROLLBACK

> Explique com suas palavras.
Desfaz todas as operações feitas na transação até o momento do seu início, anulando as alterações.
## Por que transações são importantes?

> Escreva aqui.
Elas garantem a integridade do banco, permitindo agrupar operações relacionadas para que todas sejam concluídas com sucesso, ou nenhuma, evitando dados inconsistentes.
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

1. USE banco;
2. Consultas com JOIN (ex: vw_agendamentos_detalhados);
3. Subconsultas (ex: contagem de exames por paciente);
4. Views (vw_faturamento_por_exame, vw_laudos_pendentes);
5. Procedures (sp_agendar_exame, sp_verificar_elegibilidade);
6. Function (fn_calcular_desconto);
7. Trigger (trg_log_resultado);
8. Teste de COMMIT (inserção paciente + agendamento);
9. Teste de ROLLBACK (atualização de preço revertida);
10. Consultas de validação (SELECT em views e tabela de log);

---

# 11. Consulta relacional final

**Pergunta:**

> Escreva aqui.
Quais agendamentos estão marcados com detalhes completos do paciente, médico e exame?
```sql
-- Cole aqui.
SELECT a.id_agendamento, a.data_hora, p.nome AS paciente, m.nome AS medico, e.tipo_exame
FROM Agendamento a
INNER JOIN Paciente p ON a.id_paciente = p.id_paciente
INNER JOIN Medico m ON a.id_medico = m.id_medico
INNER JOIN Exame e ON a.id_exame = e.id_exame;

```

**Explique:**

> Escreva aqui.
Esta consulta utiliza JOINs para relacionar as principais tabelas e retorna informações completas e integradas dos agendamentos, facilitando o entendimento do quadro clínico e o planejamento médico.
---

# 12. Subconsulta final

**Pergunta:**

> Escreva aqui.
Qual o paciente com maior número de agendamentos registrados?
```sql
-- Cole aqui.
SELECT nome
FROM Paciente
WHERE id_paciente = (
    SELECT id_paciente
    FROM Agendamento
    GROUP BY id_paciente
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

```

**Explique:**

> Escreva aqui.
A subconsulta agrupa os agendamentos por paciente, ordena pela quantidade em ordem decrescente e retorna o paciente com maior número de agendamentos. A consulta externa busca o nome desse paciente.
---

# 13. VIEW final mais útil

**Nome:**

```text
vw_agendamentos_detalhados

```

**Por que é importante?**

> Escreva aqui.
Centraliza informações de várias tabelas para facilitar consultas frequentes sobre agendamentos, poupando tempo e evitando repetição de joins complexos em várias consultas.
---

# 14. Procedure final mais útil

**Nome:**

```text
sp_agendar_exame

```

**Entrada:**

```text
p_id_paciente INT, p_id_exame INT, p_id_medico INT, p_data DATETIME

```

**Resultado:**

> Escreva aqui.
Insere um novo agendamento no sistema com os dados fornecidos, garantindo o registro correto do exame agendado para o paciente e médico.
---

# 15. Function final

**Nome:**

```text
fn_calcular_desconto

```

**O que retorna?**

> Escreva aqui.
Retorna o preço final do exame aplicando desconto para pacientes conveniados, permitindo cálculos simplificados diretamente em consultas.
---

# 16. Trigger final

**Nome:**

```text
trg_log_resultado

```

**Regra automatizada:**

> Escreva aqui.
Após a inserção de um resultado de exame, registra automaticamente o evento em uma tabela de log com data e usuário, garantindo rastreabilidade das alterações no sistema.
---

# 17. Teste operacional final

O aluno deverá executar o projeto no MySQL Workbench e verificar:

- [V] JOINs funcionam;
- [V] subconsultas funcionam;
- [V] Views funcionam;
- [V] Procedures funcionam;
- [V] Function funciona;
- [V] Trigger funciona;
- [V] COMMIT funciona;
- [V] ROLLBACK funciona.

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
|Trigger não dispara após inserção|Definição incorreta do evento do trigger ou falta de permissão|Verificar evento (AFTER/BEFORE INSERT) e permissões do usuário|
|Procedures retornam erro de sintaxe|Uso incorreto do DELIMITER ou comandos mal formatados|Ajustar uso do DELIMITER e revisar sintaxe das procedures|
|Dados inconsistentes após transação|Falta de COMMIT ou erro na lógica que gera inconsistência|Confirmar transações com COMMIT ou implementar uso correto de ROLLBACK|

---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> Escreva aqui.
ROLLBACK

**Conteúdo mais difícil:**

> Escreva aqui.
PROCEDURES E FUNCTIONS

**Código do Module-2 que considero mais importante:**

> Escreva aqui.
JOINS

**O que eu conseguiria explicar presencialmente sem consultar material?**

> Escreva aqui.
SUBCONSULTAS
---

# 21. Estrutura recomendada do SPRINT5-5.sql

```sql
-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluno:
-- Banco:

USE nome_do_banco;

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

- [V] mantive os arquivos do Module-1;
- [V] utilizei a mesma branch `team-XX`;
- [V] concluí as cinco Sprints do Module-2;
- [V] todos os `.md` estão preenchidos;
- [V] todos os `.sql` foram testados;
- [V] JOINs funcionam;
- [V] subconsultas funcionam;
- [V] Views funcionam;
- [V] Procedures funcionam;
- [V] Function funciona;
- [V] Trigger funciona;
- [V] COMMIT e ROLLBACK foram demonstrados;
- [V] compreendo o código entregue;
- [V] revisei os nomes dos arquivos;
- [V] nenhum arquivo foi colocado fora de `Module-2`.

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
