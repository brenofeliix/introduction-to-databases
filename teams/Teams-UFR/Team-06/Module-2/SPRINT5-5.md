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

> Anna Beatriz Oliveira Moura

**Banco utilizado:**

```text
locacao_de_filmes
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

> Impedir que um item de locação seja cadastrado com valor de diária igual a zero, negativo ou nulo. Essa regra ajuda a evitar registros de cobrança inválidos.

**Evento:**

- [x] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
item_locacao
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
DELIMITER $$

CREATE TRIGGER trg_validar_valor_diaria
BEFORE INSERT ON item_locacao
FOR EACH ROW
BEGIN
    IF NEW.valor_diaria IS NULL OR NEW.valor_diaria <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A diaria deve ser maior que zero';
    END IF;
END$$

DELIMITER ;
```

**Explique linha por linha:**

> DELIMITER ($$): altera temporariamente o delimitador para permitir comandos dentro do Trigger. CREATE TRIGGER trg_validar_valor_diaria: cria a automação com esse nome. BEFORE INSERT ON item_locacao: executa a validação antes de inserir um item. FOR EACH ROW: aplica a regra a cada linha que estiver sendo inserida. NEW.valor_diaria: acessa o valor da diária que está prestes a ser gravado. IF ... THEN: verifica se o valor é nulo, zero ou negativo. SIGNAL SQLSTATE '45000': interrompe a inserção com erro definido pela aplicação. END IF e END: encerram a condição e o corpo do Trigger. DELIMITER ;: restaura o delimitador padrão.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
SELECT COUNT(*) AS itens_antes
FROM item_locacao
WHERE id_locacao = @id_locacao_teste;
```

**Operação executada:**

```sql
INSERT INTO item_locacao (id_locacao, id_filme, valor_diaria)
VALUES (@id_locacao_teste, @id_filme_teste, 8.00);
```

**Estado depois do teste:**

```sql
SELECT id_item, id_locacao, id_filme, valor_diaria
FROM item_locacao
WHERE id_locacao = @id_locacao_teste;
```

**Resultado observado:**

> A inserção com diária 8.00 é aceita, enquanto que a tentativa com 0.00 gera um erro com a mensagem A diaria deve ser maior que zero, sem gravar o registro inválido. O segundo teste está comentado no MySQL Workbench para que a execução integral não pare intencionalmente em erro.

---

# 6. START TRANSACTION

Uma transação permite tratar um conjunto de operações como uma unidade.

Estrutura:

```sql
START TRANSACTION;

-- operação 1
INSERT INTO locacao (
    id_cliente, id_funcionario, data_locacao, data_devolucao
)
SELECT c.id_cliente, fu.id_funcionario, '2026-11-18', '2026-11-21'
FROM cliente AS c
CROSS JOIN funcionario AS fu
ORDER BY c.id_cliente, fu.id_funcionario
LIMIT 1;

SET @id_locacao_teste = LAST_INSERT_ID();

-- operação 2
INSERT INTO item_locacao (id_locacao, id_filme, valor_diaria)
VALUES (@id_locacao_teste, @id_filme_teste, 8.00);

COMMIT;
```

---

# 7. Teste com COMMIT

Crie uma transação coerente com o domínio.

**Objetivo:**

> Escreva aqui.

```sql
START TRANSACTION;

INSERT INTO locacao (
    id_cliente, id_funcionario, data_locacao, data_devolucao
)
SELECT c.id_cliente, fu.id_funcionario, '2026-11-18', '2026-11-21'
FROM cliente AS c
CROSS JOIN funcionario AS fu
ORDER BY c.id_cliente, fu.id_funcionario
LIMIT 1;

SET @id_locacao_teste = LAST_INSERT_ID();

-- ESTADO ANTES: nenhum item associado a esta nova locacao.
SELECT COUNT(*) AS itens_antes
FROM item_locacao
WHERE id_locacao = @id_locacao_teste;

INSERT INTO item_locacao (id_locacao, id_filme, valor_diaria)
VALUES (@id_locacao_teste, @id_filme_teste, 8.00);

-- ESTADO DEPOIS DO INSERT: 1 item valido dentro da transacao.
SELECT id_item, id_locacao, id_filme, valor_diaria
FROM item_locacao
WHERE id_locacao = @id_locacao_teste;

COMMIT;
```

**O que aconteceu após o COMMIT?**

> A locação de teste e seu item permanecem disponíveis nas consultas executadas depois do COMMIT, até a limpeza controlada no final do arquivo

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
START TRANSACTION;

UPDATE item_locacao
SET valor_diaria = 99.00
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;

SELECT valor_diaria AS diaria_durante_transacao
FROM item_locacao
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;

ROLLBACK;
```

**Verificação antes:**

```sql
SELECT valor_diaria AS diaria_antes_do_rollback
FROM item_locacao
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;
```

**Verificação depois:**

```sql
SELECT valor_diaria AS diaria_depois_do_rollback
FROM item_locacao
WHERE id_locacao = @id_locacao_teste
  AND id_filme = @id_filme_teste;
```

**O que o ROLLBACK fez?**

> Desfez a alteração realizada na transação de 99.00, preservando o valor anterior do registro que volta a ser 8.00.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Confirma definitivamente as operações realizadas dentro da transação. No projeto, permite salvar conjuntamente uma locação e seu item.

## ROLLBACK

> Cancela as alterações ainda não confirmadas na transação. No teste, devolve a diária de 99.00 para 8.00.

## Por que transações são importantes?

> Porque uma locação pode exigir várias operações relacionadas. As transações evitam que parte dos dados seja gravada e outra parte fique inconsistente quando ocorre algum problema.

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

> Quais filmes foram alugados, por quais clientes, com qual funcionário responsável e a qual gênero pertencem?

```sql
SELECT
    l.id_locacao,
    c.nome AS cliente,
    fu.nome AS funcionario,
    fi.titulo AS filme,
    g.nome AS genero,
    l.data_locacao,
    l.data_devolucao,
    i.valor_diaria
FROM locacao AS l
INNER JOIN cliente AS c ON c.id_cliente = l.id_cliente
INNER JOIN funcionario AS fu ON fu.id_funcionario = l.id_funcionario
INNER JOIN item_locacao AS i ON i.id_locacao = l.id_locacao
INNER JOIN filme AS fi ON fi.id_filme = i.id_filme
INNER JOIN genero AS g ON g.id_genero = fi.id_genero
ORDER BY l.id_locacao, fi.titulo;
```

**Explique:**

> Os INNER JOINs relacionam as chaves primárias e estrangeiras das seis tabelas. A consulta apresenta apenas os registros com correspondência em todas as tabelas relacionadas, organizados pelo ID da locação e pelo título do filme.

---

# 12. Subconsulta final

**Pergunta:**

> Quais filmes possuem avaliação acima da média do catálogo?

```sql
SELECT f.id_filme, f.titulo, f.avaliacao
FROM filme AS f
WHERE f.avaliacao > (
    SELECT AVG(f2.avaliacao)
    FROM filme AS f2
)
ORDER BY f.avaliacao DESC;
```

**Explique:**

> A consulta interna calcula a média das avaliações. A consulta externa compara a avaliação de cada filme com essa média e mostra somente os que possuem nota superior.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_resumo_locacoes_sprint5
```

**Por que é importante?**

> Reúne, em uma consulta reutilizável, o cliente, as datas, a quantidade de filmes e o valor calculado de cada locação. Facilita a visualização das informações sem repetir vários JOINs e agregações.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_calcular_total_locacao
```

**Entrada:**

```text
p_id_locacao INT (IN)
p_valor_total DECIMAL(10,2) (OUT)
```

**Resultado:**

> Calcula o valor total de uma locação, somando os valores dos itens obtidos pela Function fn_calcular_valor_item. Se o ID da locação não existir, retorna NULL no parâmetro de saída

---

# 15. Function final

**Nome:**

```text
fn_calcular_valor_item
```

**O que retorna?**

> Um valor DECIMAL(10,2) correspondente à diária multiplicada pela diferença entre as datas de locação e devolução. Na versão didática adotada, dados inválidos ou ausência de data de devolução produzem 0.00.

---

# 16. Trigger final

**Nome:**

```text
trg_validar_valor_diaria
```

**Regra automatizada:**

> Impede a inserção de itens de locação com valor de diária menor ou igual a zero ou nulo, gerando uma mensagem de erro antes da gravação.

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
|  |  |  |
|  |  |  |
|  |  |  |

---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> Subconsultas, por no começo não entender como aplicar, mas após a realização percebi que era a realização de consultas em que um SELECT depende do resultado de outro SELECT.

**Conteúdo mais difícil:**

> Peocedures e Functions, pela necessidade de tentar entender como desenvolver os pequenos programas dentro do próprio MySQL para executar tarefas do banco.

**Código do Module-2 que considero mais importante:**

> Código: sp_calcular_total_locacao, porque combina Procedure, Function, parâmetros e tabelas relacionadas.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> Joins, por serem consultas, muito parecidas com alguma realizadas no Module 1, além de que ser o uso de comandos para realizar consultas entre as tabelas do banco.

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

- [ ] mantive os arquivos do Module-1;
- [ ] utilizei a mesma branch `team-XX`;
- [ ] concluí as cinco Sprints do Module-2;
- [ ] todos os `.md` estão preenchidos;
- [ ] todos os `.sql` foram testados;
- [ ] JOINs funcionam;
- [ ] subconsultas funcionam;
- [ ] Views funcionam;
- [ ] Procedures funcionam;
- [ ] Function funciona;
- [ ] Trigger funciona;
- [ ] COMMIT e ROLLBACK foram demonstrados;
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
