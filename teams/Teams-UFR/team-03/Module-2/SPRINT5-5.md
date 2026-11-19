# SPRINT 5/5 — Triggers, Transações, Integração e Validação Final

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT5-5.md` + `SPRINT5-5.sql`

---

# Objetivo da Sprint 5/5

Criar `TRIGGER`s, trabalhar com transações (`START TRANSACTION`, `COMMIT`, `ROLLBACK`) e integrar tudo o que foi feito no `Module-2`.

---

# 1. Identificação

**Nome completo:**

> Gabriel Sakaizawa Campos

**Banco utilizado:**

```text
db_restaurante_sabor
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

**Regra escolhida:**

> Trigger principal: não permitir item de pedido com quantidade zero ou negativa. Trigger extra: quando um pedido passa para "finalizado", a mesa dele volta a ficar "livre" automaticamente.

**Evento:**

- [x] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [x] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
item_pedido (BEFORE INSERT) e pedido (AFTER UPDATE)
```

---

# 4. Implementação do TRIGGER

**SQL do seu Trigger:**

```sql
DELIMITER //

-- TRIGGER 1 (BEFORE INSERT): impede item com quantidade invalida
CREATE TRIGGER trg_item_valida_quantidade
BEFORE INSERT ON item_pedido
FOR EACH ROW
BEGIN
    IF NEW.quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantidade deve ser maior que zero';
    END IF;
END //

DELIMITER ;
```

```sql
DELIMITER //

-- TRIGGER 2 (AFTER UPDATE): ao finalizar um pedido, libera a mesa
CREATE TRIGGER trg_pedido_libera_mesa
AFTER UPDATE ON pedido
FOR EACH ROW
BEGIN
    IF NEW.status = 'finalizado' AND OLD.status <> 'finalizado' THEN
        UPDATE mesa SET status = 'livre' WHERE id_mesa = NEW.id_mesa;
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> **Trigger 1 (`trg_item_valida_quantidade`)**
> - `BEFORE INSERT ON item_pedido`: roda antes de gravar cada novo item.
> - `FOR EACH ROW`: executa para cada linha inserida.
> - `NEW.quantidade`: o valor que está sendo inserido.
> - `IF NEW.quantidade <= 0`: testa se é inválido.
> - `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ...`: gera um erro com a mensagem, e o `INSERT` é cancelado.
>
> **Trigger 2 (`trg_pedido_libera_mesa`)**
> - `AFTER UPDATE ON pedido`: roda depois de um `UPDATE` em `pedido`.
> - `OLD.status` é o valor antes e `NEW.status` é o valor depois.
> - Se o status passou a ser `finalizado` (e antes não era), faz `UPDATE mesa SET status = 'livre'` na mesa do pedido (`NEW.id_mesa`).


---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
START TRANSACTION;
UPDATE mesa SET status = 'ocupada' WHERE id_mesa = 2;
SELECT p.id_pedido, p.status AS status_pedido, m.status AS status_mesa
FROM pedido AS p INNER JOIN mesa AS m ON p.id_mesa = m.id_mesa WHERE p.id_pedido = 2;
```

> Pedido 2 `aberto`, mesa 2 `ocupada`.

**Operação executada:**

```sql
UPDATE pedido SET status = 'finalizado' WHERE id_pedido = 2;
```

**Estado depois do teste:**

```sql
SELECT p.id_pedido, p.status AS status_pedido, m.status AS status_mesa
FROM pedido AS p INNER JOIN mesa AS m ON p.id_mesa = m.id_mesa WHERE p.id_pedido = 2;
ROLLBACK;
```

**Resultado observado:**

> Pedido 2 `finalizado` e mesa 2 `livre`, sem eu mexer na tabela `mesa`: quem fez isso foi o trigger. Depois desfiz tudo com `ROLLBACK`.
>
> Teste do Trigger 1 (último comando do `.sql`): `INSERT INTO item_pedido ... quantidade = 0` retorna `ERROR 1644 (45000): Quantidade deve ser maior que zero`, e nenhum item é gravado. Esse erro é o resultado esperado.

---

# 6. START TRANSACTION

Uma transação agrupa operações para que todas valham juntas (`COMMIT`) ou nenhuma valha (`ROLLBACK`). As tabelas são InnoDB, que suporta transações.

---

# 7. Teste com COMMIT

**Objetivo:**

> Registrar um pedido completo (pedido + 2 itens) como uma unidade.

```sql
START TRANSACTION;
INSERT INTO pedido (id_cliente, id_mesa, id_funcionario, data_pedido, status)
VALUES (2, 3, 2, CURDATE(), 'aberto');
SET @novo_pedido = LAST_INSERT_ID();
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (@novo_pedido, 1, 1, 45.90),
       (@novo_pedido, 4, 1, 8.50);
COMMIT;
```

**O que aconteceu após o COMMIT?**

> O pedido novo (id 6, Carlos Lima) ficou gravado de forma permanente, com total de R$ 54,40 (`fn_total_pedido`). No final do script ele é apagado só para o banco voltar ao estado do Module-1.

---

# 8. Teste com ROLLBACK

```sql
START TRANSACTION;
INSERT INTO pedido (id_cliente, id_mesa, id_funcionario, data_pedido, status)
VALUES (3, 4, 4, CURDATE(), 'aberto');
ROLLBACK;
```

**Verificação antes:**

```sql
SELECT COUNT(*) AS pedidos_antes FROM pedido;
```

> 6 (os 5 originais + o do teste de COMMIT).

**Verificação depois:**

```sql
SELECT COUNT(*) AS pedidos_depois FROM pedido;
```

> 6. Dentro da transação a contagem foi 7, mas depois do `ROLLBACK` voltou a 6.

**O que o ROLLBACK fez?**

> Desfez o `INSERT`: o pedido criado dentro da transação deixou de existir.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Confirma e grava de vez tudo o que foi feito na transação.

## ROLLBACK

> Cancela tudo o que foi feito desde o `START TRANSACTION`, voltando ao estado anterior.

## Por que transações são importantes?

> Para que operações que dependem umas das outras não fiquem pela metade. Por exemplo, se o pedido for gravado e os itens falharem, o `ROLLBACK` evita um pedido vazio no banco.


---

# 10. Integração do Module-2

O `SPRINT5-5.sql` segue a ordem: `USE`, JOINs, subconsultas, Views, Procedures, Function, Triggers, teste de `COMMIT`, teste de `ROLLBACK` e consultas de validação. Ele usa o banco já existente e pode ser executado várias vezes, porque usa `CREATE OR REPLACE VIEW` e `DROP ... IF EXISTS` antes de recriar.

---

# 11. Consulta relacional final

**Pergunta:**

> Qual o cliente, atendente, mesa, status e total de cada pedido?

```sql
SELECT p.id_pedido, c.nome AS cliente, f.nome AS atendente, m.numero AS mesa,
       p.status, SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM pedido AS p
INNER JOIN cliente     AS c  ON p.id_cliente     = c.id_cliente
INNER JOIN funcionario AS f  ON p.id_funcionario = f.id_funcionario
INNER JOIN mesa        AS m  ON p.id_mesa        = m.id_mesa
INNER JOIN item_pedido AS ip ON p.id_pedido      = ip.id_pedido
GROUP BY p.id_pedido, c.nome, f.nome, m.numero, p.status
ORDER BY p.id_pedido;
```

**Explique:**

> Junta `pedido` com `cliente`, `funcionario`, `mesa` e `item_pedido` e soma os itens por pedido. Retornou 5 pedidos: 1 (103,80), 2 (77,00), 3 (57,90), 4 (149,00) e 5 (29,00).

---

# 12. Subconsulta final

**Pergunta:**

> Quais pedidos têm total acima da média dos pedidos?

```sql
SELECT ip.id_pedido, SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM item_pedido AS ip
GROUP BY ip.id_pedido
HAVING SUM(ip.quantidade * ip.preco_unitario) > (
    SELECT AVG(t.total)
    FROM (
        SELECT SUM(quantidade * preco_unitario) AS total
        FROM item_pedido
        GROUP BY id_pedido
    ) AS t
)
ORDER BY total_pedido DESC;
```

**Explique:**

> A consulta mais interna calcula o total de cada pedido; a do meio tira a média (R$ 83,34); a externa mantém pedidos com total maior que ela: pedido 4 (149,00) e pedido 1 (103,80).

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_pedidos_abertos
```

**Por que é importante?**

> Mostra mesa, cliente, atendente e total dos pedidos ainda abertos: é a visão do dia a dia do salão.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_pedidos_do_cliente
```

**Entrada:**

```text
p_id_cliente INT
```

**Resultado:**

> Lista os pedidos do cliente com data, status e total. Para o cliente 1: pedidos 1 (103,80) e 3 (57,90).

---

# 15. Function final

**Nome:**

```text
fn_total_pedido
```

**O que retorna?**

> O total de um pedido (`DECIMAL(10,2)`): 103,80 para o pedido 1; 149,00 para o 4.

---

# 16. Trigger final

**Nome:**

```text
trg_item_valida_quantidade (e trg_pedido_libera_mesa)
```

**Regra automatizada:**

> Bloquear itens com quantidade <= 0 e liberar a mesa quando o pedido é finalizado.

---

# 17. Teste operacional final

- [x] JOINs funcionam;
- [x] subconsultas funcionam;
- [x] Views funcionam;
- [x] Procedures funcionam;
- [x] Function funciona;
- [x] Trigger funciona;
- [x] COMMIT funciona;
- [x] ROLLBACK funciona.

(Executei os 5 scripts em sequência, a partir do banco do Module-1, em um MySQL 8.0 com `ONLY_FULL_GROUP_BY` e log binário ligados. Nenhum erro, exceto o erro 1644 esperado do trigger no último comando do Sprint 5.)

---

# 18. Validação prática/oral

Pontos que estudei para a validação: explicar uma consulta e o `ON` do `JOIN`; trocar o filtro de um `WHERE`; trocar o parâmetro de uma Procedure (`CALL sp_pedidos_do_cliente(2)`); explicar uma View; disparar o Trigger com um `UPDATE`/`INSERT`; mostrar `COMMIT` e `ROLLBACK`; interpretar o erro 1644.


---

# 19. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
| Erro 1418 ao criar Function | Log binário ligado sem `DETERMINISTIC`/`READS SQL DATA` | Declarar `READS SQL DATA` |
| O script parava no teste do trigger | O `SIGNAL` gera erro, e o Workbench interrompe o script | Deixar esse teste como último comando |
| Rodar o script duas vezes dava "already exists" | Objetos já criados | `DROP ... IF EXISTS` e `CREATE OR REPLACE` |
| O teste de `COMMIT` deixaria um pedido extra | O `COMMIT` é permanente | Apagar o pedido de teste no final (seção de limpeza) |


---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> JOINs e Views.

**Conteúdo mais difícil:**

> Triggers (`OLD`/`NEW`) e subconsultas correlacionadas.

**Código do Module-2 que considero mais importante:**

> `vw_pedidos_abertos` e `sp_alterar_status_pedido`.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> JOIN, subconsulta com `IN`, Views, `COMMIT` x `ROLLBACK`.


---

# 21. Estrutura do SPRINT5-5.sql

`USE`, JOINs, subconsultas, Views, Procedures/Function/Triggers, teste do trigger, `COMMIT`, `ROLLBACK`, limpeza, validação final e, por último, o teste de erro do trigger.

---

# 22. Arquivos esperados no Module-2

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

---

# 23. Checklist final

- [x] mantive os arquivos do Module-1;
- [x] utilizei a mesma branch `team-03`;
- [x] concluí as cinco Sprints do Module-2;
- [x] todos os `.md` estão preenchidos;
- [x] todos os `.sql` foram testados;
- [x] JOINs funcionam;
- [x] subconsultas funcionam;
- [x] Views funcionam;
- [x] Procedures funcionam;
- [x] Function funciona;
- [x] Trigger funciona;
- [x] COMMIT e ROLLBACK foram demonstrados;
- [ ] compreendo o código entregue; <!-- marque depois de estudar -->
- [x] revisei os nomes dos arquivos;
- [x] nenhum arquivo foi colocado fora de `Module-2`.

---

# 24. Commit da Sprint 5/5

```text
Conclui Module 2 Sprint 5 de 5 - triggers e transacoes
```

---

# 25. Pull Request final do Module-2

Origem `team-03` → destino `main`.

```text
[N2][UFR][Team 03] Sprints 1-5 - Restaurante Sabor
```

---

# 26. Descrição do Pull Request

```text
## Identificação

Aluno: Gabriel Sakaizawa Campos
Instituição: UFR
Branch: team-03
Banco: db_restaurante_sabor (Restaurante Sabor)
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

Usei uma LLM como apoio. Segui o fluxo COMPREENDER → ADAPTAR → EXECUTAR → TESTAR → VALIDAR: li cada código, adaptei ao meu banco, executei e conferi os resultados.

