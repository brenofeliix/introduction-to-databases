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

> Célia Hiromi Watanabe — UNEMAT — Team 03

**Banco utilizado:**

```text
db_salao_beleza
```

---

# 2. Revisão do Module-2

| Sprint | Conteúdo | Concluído? |
|---|---|---|
| 1/5 | JOINs | Sim |
| 2/5 | Subconsultas | Sim |
| 3/5 | Views | Sim |
| 4/5 | Procedures e Functions | Sim |
| 5/5 | Triggers e Transações | Sim |

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

> Registrar automaticamente o histórico de mudanças de status dos agendamentos. Toda vez que o status de um agendamento muda (por exemplo, de 'Agendado' para 'Concluído' ou 'Cancelado'), o banco grava na tabela `historico_status` qual era o status anterior, qual é o novo e a data/hora da alteração. Assim o salão tem uma auditoria de quem foi atendido, cancelado ou reagendado, sem depender de alguém anotar.

**Evento:**

- [ ] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [x] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
agendamento       (tabela que dispara o trigger)
historico_status  (tabela nova, onde o trigger grava o histórico)
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

**Tabela de histórico (criada antes do trigger):**

```sql
CREATE TABLE historico_status (
    id_historico    INT PRIMARY KEY AUTO_INCREMENT,
    id_agendamento  INT NOT NULL,
    status_anterior VARCHAR(20) NOT NULL,
    status_novo     VARCHAR(20) NOT NULL,
    data_alteracao  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_historico_agendamento
        FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento)
);
```

**SQL do seu Trigger:**

```sql
DELIMITER //

CREATE TRIGGER trg_historico_status
AFTER UPDATE ON agendamento
FOR EACH ROW
BEGIN
    -- OLD = valores antes do UPDATE | NEW = valores depois
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_status (id_agendamento, status_anterior, status_novo)
        VALUES (NEW.id_agendamento, OLD.status, NEW.status);
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> - `DELIMITER //`: muda o fim de comando para `//`, para o MySQL não encerrar o trigger no primeiro `;` de dentro do `BEGIN...END`.
> - `CREATE TRIGGER trg_historico_status`: cria o trigger com esse nome.
> - `AFTER UPDATE ON agendamento`: ele dispara sozinho depois de cada `UPDATE` na tabela `agendamento`, venha o UPDATE de um comando direto ou de dentro de uma procedure.
> - `FOR EACH ROW`: o corpo roda uma vez para cada linha alterada (um UPDATE que muda 2 linhas dispara 2 vezes).
> - `BEGIN ... END`: delimita a lógica do trigger.
> - `OLD.status` / `NEW.status`: `OLD` é a linha como era antes do UPDATE e `NEW` é a linha como ficou depois.
> - `IF OLD.status <> NEW.status THEN`: só registra quando o status realmente mudou; se o UPDATE alterar apenas a forma de pagamento, nada é gravado.
> - `INSERT INTO historico_status ... VALUES (NEW.id_agendamento, OLD.status, NEW.status)`: grava qual agendamento mudou, o status anterior e o novo. A coluna `data_alteracao` é preenchida pelo `DEFAULT CURRENT_TIMESTAMP`.
> - `END IF;` / `END //`: fecham o `IF` e o trigger.
> - `DELIMITER ;`: volta o fim de comando para `;`.
>
> Na tabela `historico_status`, a FK `fk_historico_agendamento` garante que o histórico só aponte para agendamentos que existem.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
SELECT * FROM historico_status;   -- tabela recém-criada
```

**Operação executada:**

```sql
-- A procedure da Sprint 4 faz o UPDATE de status; o trigger dispara
CALL sp_concluir_agendamento(9, 'Pix');

-- Muda só a forma de pagamento: o IF do trigger não deve registrar
UPDATE agendamento
SET forma_pagamento = 'Cartão'
WHERE id_agendamento = 9;

-- Restaura o agendamento 9: o trigger registra a volta
UPDATE agendamento
SET status = 'Agendado',
    forma_pagamento = NULL
WHERE id_agendamento = 9;
```

**Estado depois do teste:**

```sql
SELECT * FROM historico_status;   -- executado depois de cada operação
```

**Resultado observado:**

> Executado no MySQL Workbench em 27/10/2026, sem erros. Ao final dos testes, `SELECT * FROM historico_status` retornou **3 linhas**:
>
> | id_historico | id_agendamento | status_anterior | status_novo |
> |---|---|---|---|
> | 1 | 9 | Agendado | Concluído |
> | 2 | 9 | Concluído | Agendado |
> | 3 | 14 | Agendado | Concluído |
>
> As linhas 1 e 2 vêm dos testes desta seção: a 1 foi gravada pelo trigger quando a `sp_concluir_agendamento` concluiu o agendamento 9, e a 2 quando o status foi restaurado para 'Agendado'. A linha 3 é do encaixe da Patrícia (seção 7). O agendamento 9 tem **só 2 linhas**, apesar de ter sofrido 3 UPDATEs: o UPDATE que mudou apenas a `forma_pagamento` não gerou registro, o que comprova que o `IF OLD.status <> NEW.status` funciona. Todas as linhas receberam a data/hora preenchida pelo `DEFAULT CURRENT_TIMESTAMP`.

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

> No Workbench o autocommit vem ligado: cada comando é gravado na hora. O `START TRANSACTION` suspende o autocommit até o próximo `COMMIT` ou `ROLLBACK`. Comandos DDL (`CREATE TABLE`, `CREATE TRIGGER`, `DROP`) fazem COMMIT implícito, por isso ficaram fora das transações do script.

---

# 7. Teste com COMMIT

Crie uma transação coerente com o domínio.

**Objetivo:**

> Registrar um atendimento de encaixe da cliente Patrícia Almeida (id 7), que chegou sem horário marcado: inserir o agendamento e, ao final do atendimento, concluí-lo com o pagamento. As duas operações formam uma unidade: o atendimento só vale se as duas forem gravadas.

```sql
SELECT fn_total_gasto_cliente(7) AS patricia_antes;

START TRANSACTION;

-- Ana Paula Nogueira (1) — Escova e Hidratação (4)
INSERT INTO agendamento (id_cliente, id_profissional, id_servico, data_hora, status)
VALUES (7, 1, 4, '2026-09-22 10:00:00', 'Agendado');

-- LAST_INSERT_ID() devolve o id gerado pelo INSERT acima
UPDATE agendamento
SET status = 'Concluído',
    forma_pagamento = 'Pix'
WHERE id_agendamento = LAST_INSERT_ID();

COMMIT;

SELECT * FROM vw_agenda_completa WHERE cliente = 'Patrícia Almeida';
SELECT fn_total_gasto_cliente(7) AS patricia_depois;
SELECT * FROM historico_status;
```

**O que aconteceu após o COMMIT?**

> Antes da transação, `fn_total_gasto_cliente(7)` retornou **0.00**. Depois do `COMMIT`, a Patrícia passou a ter 1 atendimento concluído (a `vw_agenda_completa` retornou 1 linha para ela), `fn_total_gasto_cliente(7)` retornou **95.00** (preço atual da Escova e Hidratação, que foi alterado para 95.00 no Module 1) e o `historico_status` ganhou a 3ª linha (agendamento 14, Agendado → Concluído), gravada pelo trigger durante o UPDATE da transação. A contagem final por status ficou em Agendado 5, Cancelado 1 e Concluído 4 (antes eram 5, 1 e 3). O agendamento recebeu o id 14, e não 11, porque o AUTO_INCREMENT não reaproveita ids de linhas apagadas (ver seção 19).

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

> Situação: a recepção cancela por engano os agendamentos 3 e 9 e percebe o erro antes de confirmar.

```sql
START TRANSACTION;

UPDATE agendamento
SET status = 'Cancelado'
WHERE id_agendamento IN (3, 9);

SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;
SELECT * FROM historico_status;

ROLLBACK;
```

**Verificação antes:**

```sql
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;
```

**Verificação depois:**

```sql
SELECT * FROM vw_agendamentos_pendentes ORDER BY data_hora;
SELECT * FROM historico_status;
```

**O que o ROLLBACK fez?**

> Resultado observado no Workbench: antes da transação, a `vw_agendamentos_pendentes` tinha **5 linhas** (agendamentos 2, 3, 4, 5 e 9). Dentro da transação, depois do `UPDATE` que cancelou os agendamentos 3 e 9 (`Changed: 2`), a view passou a ter **3 linhas** (agendamentos 2, 4 e 5) e o `historico_status` foi para **5 linhas**, porque o trigger registrou os 2 cancelamentos. Depois do `ROLLBACK`, a view voltou a ter **5 linhas** e o histórico voltou a **3 linhas**. O ROLLBACK desfez os dois cancelamentos e também as linhas que o trigger gravou, porque o trigger faz parte da mesma transação.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Confirma a transação: tudo o que foi feito desde o `START TRANSACTION` passa a ser gravado de forma definitiva e fica visível para as outras conexões. Depois do COMMIT não dá mais para desfazer com ROLLBACK.

## ROLLBACK

> Cancela a transação: desfaz todas as alterações feitas desde o `START TRANSACTION`, e o banco volta exatamente ao estado de antes, inclusive o que os triggers gravaram durante a transação.

## Por que transações são importantes?

> Porque algumas operações só fazem sentido juntas. No salão, um atendimento concluído sem o agendamento registrado (ou o contrário) deixaria os dados inconsistentes. A transação garante "tudo ou nada": ou todas as operações são gravadas, ou nenhuma. E se alguém errar no meio (como o cancelamento por engano), o ROLLBACK permite voltar atrás antes de confirmar.

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

> No `SPRINT5-5.sql`, as views (Sprint 3) e as rotinas (Sprint 4) são reutilizadas, e não recriadas. A integração também aparece nos testes: o trigger é disparado pela `sp_concluir_agendamento`, e os resultados do COMMIT e do ROLLBACK são conferidos com `vw_agenda_completa`, `vw_agendamentos_pendentes` e `fn_total_gasto_cliente`.

---

# 11. Consulta relacional final

**Pergunta:**

> Quanto cada serviço já faturou com atendimentos concluídos, incluindo os serviços que nunca foram concluídos?

```sql
SELECT
    s.nome_servico,
    s.preco,
    COUNT(a.id_agendamento)           AS vezes_concluido,
    COUNT(a.id_agendamento) * s.preco AS faturamento
FROM servico AS s
LEFT JOIN agendamento AS a
    ON s.id_servico = a.id_servico
   AND a.status = 'Concluído'
GROUP BY s.id_servico, s.nome_servico, s.preco
ORDER BY faturamento DESC, s.nome_servico;
```

**Explique:**

> O `LEFT JOIN` parte de `servico` e mantém todos os serviços, mesmo os sem atendimento. O filtro `a.status = 'Concluído'` fica no `ON` (e não no `WHERE`) para não eliminar os serviços sem atendimento concluído. `COUNT(a.id_agendamento)` conta só as linhas que casaram (dá 0 para quem não tem), e o faturamento é essa contagem vezes o preço. Usar `SUM(s.preco)` estaria errado aqui, porque somaria o preço uma vez mesmo para serviços sem nenhum atendimento.
>
> Resultado: a consulta retornou **6 linhas**, uma para cada serviço, inclusive os sem atendimento concluído (com 0 e 0.00). Ela foi reexecutada depois do COMMIT da seção 7, por isso reflete o encaixe da Patrícia: Corte Feminino 2 × 80.00 = 160.00; Escova e Hidratação 1 × 95.00 = 95.00; Manicure e Pedicure 1 × 65.00 = 65.00; Corte Masculino, Limpeza de Pele e Maquiagem Social com 0 conclusões. Na execução do script, esta consulta roda antes do COMMIT, quando a Escova ainda tem 0 conclusões.

---

# 12. Subconsulta final

**Pergunta:**

> Quais clientes têm agendamento pendente e nunca tiveram um atendimento concluído (clientes novos que o salão precisa fidelizar)?

```sql
SELECT c.nome, c.telefone
FROM cliente AS c
WHERE c.id_cliente IN (
        SELECT id_cliente
        FROM agendamento
        WHERE status = 'Agendado'
      )
  AND NOT EXISTS (
        SELECT 1
        FROM agendamento AS a2
        WHERE a2.id_cliente = c.id_cliente
          AND a2.status = 'Concluído'
      )
ORDER BY c.nome;
```

**Explique:**

> A primeira subconsulta (`IN`) devolve os clientes que têm pelo menos um agendamento com status 'Agendado'. A segunda (`NOT EXISTS`) é correlacionada: para cada cliente da consulta externa, verifica se existe algum agendamento concluído dele; o cliente só aparece se não existir nenhum. As duas condições juntas trazem quem está para ser atendido pela primeira vez.
>
> Resultado: **Camila Oliveira**, **Fernanda Lima** e **Juliana Costa** (3 linhas). A Beatriz tem agendamento pendente, mas já teve um atendimento concluído, e a Mariana e a Patrícia não têm agendamento pendente.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_agenda_completa
```

**Por que é importante?**

> Ela junta as quatro tabelas (agendamento, cliente, profissional e serviço) e mostra a agenda com nomes em vez de códigos. Qualquer consulta do dia a dia (agenda de um cliente, de uma data, de um status) vira um `SELECT` simples com `WHERE` na view, sem repetir os JOINs. Nesta Sprint ela foi usada para conferir o resultado do COMMIT.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_concluir_agendamento
```

**Entrada:**

```text
p_id_agendamento  INT          (código do agendamento)
p_forma_pagamento VARCHAR(20)  (forma de pagamento)
```

**Resultado:**

> Conclui o atendimento e registra o pagamento, mas só se o agendamento estiver 'Agendado' (regra com IF/ELSEIF/ELSE). Agendamentos cancelados ou já concluídos são bloqueados, e um código inexistente gera aviso. Nesta Sprint, o UPDATE feito por ela também disparou o trigger `trg_historico_status`.

---

# 15. Function final

**Nome:**

```text
fn_total_gasto_cliente
```

**O que retorna?**

> Um `DECIMAL(10,2)` com quanto o cliente já pagou no salão: a soma dos preços dos serviços dos atendimentos concluídos (0.00 se não houver nenhum). Pode ser usada dentro de um `SELECT`, como no ranking de clientes. Nesta Sprint ela mostrou o efeito do COMMIT no total da Patrícia.

---

# 16. Trigger final

**Nome:**

```text
trg_historico_status
```

**Regra automatizada:**

> `AFTER UPDATE` em `agendamento`: sempre que o status muda, grava em `historico_status` o agendamento, o status anterior (`OLD`), o novo (`NEW`) e a data/hora. Alterações que não mudam o status (como só a forma de pagamento) não são registradas.

---

# 17. Teste operacional final

O aluno deverá executar o projeto no MySQL Workbench e verificar:

- [x] JOINs funcionam;
- [x] subconsultas funcionam;
- [x] Views funcionam;
- [x] Procedures funcionam;
- [x] Function funciona;
- [x] Trigger funciona;
- [x] COMMIT funciona;
- [x] ROLLBACK funciona.

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
| `CREATE TABLE` / `CREATE TRIGGER` dentro de uma transação a confirmariam sem querer | Comandos DDL fazem COMMIT implícito no MySQL | Criar a tabela e o trigger antes, fora das transações; dentro delas ficam só `INSERT`/`UPDATE` |
| UPDATE sem chave primária no `WHERE` é bloqueado no Workbench (erro 1175) | O "safe update mode" do Workbench vem ligado | Os UPDATEs do script filtram por `id_agendamento` (chave primária), inclusive o `IN (3, 9)` do ROLLBACK |
| Rodar o script duas vezes duplicaria o encaixe da Patrícia | O COMMIT grava o agendamento novo de forma definitiva | Executar o script uma vez só; os `DROP ... IF EXISTS` recriam o trigger e o histórico vazio |
| O script foi executado 3 vezes e a Patrícia ficou com 3 encaixes (agendamentos 11, 12 e 13): `fn_total_gasto_cliente(7)` deu 285.00 e Concluído deu 6 | O COMMIT da seção 7 não é desfeito ao rodar o script de novo | Apaguei o trigger, a tabela `historico_status` e os agendamentos 11, 12 e 13 (`DELETE ... WHERE id_agendamento IN (11, 12, 13)`, pela chave primária) e executei o script uma única vez. Depois disso a Patrícia ficou com 95.00 e Concluído com 4 |

> Nenhuma instrução SQL do script deu erro de execução. O único problema foi a execução repetida descrita acima, que deixou dados duplicados e foi corrigida antes dos resultados finais registrados nesta Sprint. O id do encaixe ficou 14 (e não 11) porque o AUTO_INCREMENT não reaproveita ids apagados.

---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> As Views. Uma view é uma consulta que fica salva com um nome. Em vez de escrever o JOIN de novo toda vez, eu só faço `SELECT` na view. Também entendi bem as Procedures: é como uma receita que eu chamo com `CALL` e passo os valores, por exemplo, o código do agendamento.

**Conteúdo mais difícil:**

> Triggers e transações. No trigger, o mais difícil foi entender o `OLD` e o `NEW`: `OLD` é o valor antes da mudança e `NEW` é o valor depois. Nas transações, aprendi do jeito difícil que o COMMIT não volta atrás: rodei o script mais de uma vez e a Patrícia ficou com agendamentos repetidos, e tive que apagar para refazer.

**Código do Module-2 que considero mais importante:**

> O trigger `trg_historico_status`. Toda vez que o status de um agendamento muda, ele anota sozinho na tabela de histórico o que era antes e o que ficou. Ninguém precisa lembrar de anotar.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> Como funciona o COMMIT e o ROLLBACK: o COMMIT confirma e grava de vez; o ROLLBACK desfaz tudo desde o `START TRANSACTION`. No meu teste, cancelei dois agendamentos por engano, dei ROLLBACK e os dois voltaram a ficar pendentes. Também consigo explicar o que o trigger faz com o `OLD` e o `NEW`.

---

# 21. Estrutura recomendada do SPRINT5-5.sql

```sql
-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluna: Célia Hiromi Watanabe (Team 03)
-- Banco: db_salao_beleza

USE db_salao_beleza;

-- 1. JOIN FINAL               (faturamento por serviço)
-- 2. SUBCONSULTA FINAL        (clientes pendentes sem atendimento concluído)
-- 3. VIEWS                    (vw_agenda_completa, vw_resumo_profissional)
-- 4. PROCEDURES E FUNCTION    (sp_agendamentos_por_cliente, sp_contar_por_status, fn_total_gasto_cliente)
-- 5. TRIGGER                  (historico_status + trg_historico_status e testes)
-- 6. TRANSAÇÃO COM COMMIT     (encaixe da Patrícia)
-- 7. TRANSAÇÃO COM ROLLBACK   (cancelamento por engano)
-- 8. VALIDAÇÃO FINAL          (SHOW TRIGGERS/VIEWS/PROCEDURES/FUNCTIONS e contagem por status)
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

- [ ] mantive os arquivos do Module-1;
- [ ] utilizei a mesma branch `team-XX`;
- [ ] concluí as cinco Sprints do Module-2;
- [ ] todos os `.md` estão preenchidos;
- [x] todos os `.sql` foram testados;
- [x] JOINs funcionam;
- [x] subconsultas funcionam;
- [x] Views funcionam;
- [x] Procedures funcionam;
- [x] Function funciona;
- [x] Trigger funciona;
- [x] COMMIT e ROLLBACK foram demonstrados;
- [ ] compreendo o código entregue;
- [ ] revisei os nomes dos arquivos;
- [ ] nenhum arquivo foi colocado fora de `Module-2`.

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
team-03
```

Destino:

```text
main
```

Título — UNEMAT:

```text
[N2][UNEMAT][Team 03] Sprints 1-5 - db_salao_beleza
```

---

# 26. Descrição sugerida do Pull Request

```text
## Identificação

Aluna: Célia Hiromi Watanabe
Instituição: UNEMAT
Branch: team-03
Banco: db_salao_beleza
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
