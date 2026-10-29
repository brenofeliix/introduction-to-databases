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

> Raquel Silva dos Santos

**Banco utilizado:**

```text
series_watchlist_db
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

> Consistência e integridade de domínio: quando um item for inserido ou atualizado na watchlist com o status 'Quero Ver', a sua nota deve ser compulsoriamente forçada para NULL, impedindo a avaliação prévia de uma produção ainda não assistida.

**Evento:**

- [x] BEFORE INSERT
- [ ] AFTER INSERT
- [x] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
item_watchlist
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
DELIMITER //

CREATE TRIGGER trg_validar_status_nota_bi
BEFORE INSERT ON item_watchlist
FOR EACH ROW
BEGIN
    IF NEW.status_assistindo = 'Quero Ver' THEN
        SET NEW.nota = NULL;
    END IF;
END //

CREATE TRIGGER trg_validar_status_nota_bu
BEFORE UPDATE ON item_watchlist
FOR EACH ROW
BEGIN
    IF NEW.status_assistindo = 'Quero Ver' THEN
        SET NEW.nota = NULL;
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> DELIMITER //: altera o delimitador padrão para compilar instruções SQL compostas.

CREATE TRIGGER trg_validar_status_nota_bi: define o gatilho nomeado para o evento de inserção.

BEFORE INSERT ON item_watchlist: determina que o gatilho será disparado antes da persistência física na tabela item_watchlist.

FOR EACH ROW: indica que a verificação é realizada linha a linha (nível de tupla).

BEGIN ... END: bloco delimitador do corpo procedural do gatilho.

IF NEW.status_assistindo = 'Quero Ver' THEN: verifica se o novo registro a ser gravado possui o status 'Quero Ver'.

SET NEW.nota = NULL;: intercepta a coluna e anula o valor de nota em memória antes da escrita em disco.

A mesma lógica é aplicada no BEFORE UPDATE para interceptar alterações via comando UPDATE.

DELIMITER ;: restaura o delimitador padrão do MySQL.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
-- SELECT * FROM item_watchlist WHERE id_usuario = 5 AND id_serie = 5;
```

**Operação executada:**

```sql
-- -- Tentativa de atualizar com status 'Quero Ver' atribuindo nota indevida 10.0
UPDATE item_watchlist
SET status_assistindo = 'Quero Ver', nota = 10.0
WHERE id_usuario = 5 AND id_serie = 5;
```

**Estado depois do teste:**

```sql
-- SELECT * FROM item_watchlist WHERE id_usuario = 5 AND id_serie = 5;
```

**Resultado observado:**

> O gatilho BEFORE UPDATE interceptou a instrução antes da gravação: o status foi gravado como 'Quero Ver', mas o campo nota foi automaticamente persistido como NULL, garantindo a integridade sem disparar erro em tempo de execução.

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

> Registrar simultaneamente um novo usuário e associar a sua primeira série de interesse na watchlist, consolidando a operação em lote no banco.

```sql
START TRANSACTION;

INSERT INTO usuario (nome, email, data_cadastro)
VALUES ('Juliana Ferreira', 'juliana.f@email.com', '2026-05-10');

SET @id_novo_usuario = LAST_INSERT_ID();

INSERT INTO item_watchlist (id_usuario, id_serie, status_assistindo, nota, comentario)
VALUES (@id_novo_usuario, 1, 'Quero Ver', NULL, 'Adicionada na criação da conta');

COMMIT;

-- operações

COMMIT;
```

**O que aconteceu após o COMMIT?**

> As duas inclusões foram gravadas de forma permanente e atômica nas tabelas usuario e item_watchlist. Ambas as linhas passam a ser visíveis por todas as conexões simultâneas do banco.

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
START TRANSACTION;

-- operações

ROLLBACK;
```

**Verificação antes:**

```sql
-- SELECT COUNT(*) AS total_usuarios FROM usuario;
```

**Verificação depois:**

```sql
--SELECT COUNT(*) AS total_usuarios FROM usuario;
SELECT * FROM item_watchlist WHERE id_usuario = 1;
```

**O que o ROLLBACK fez?**

> Desfez todas as modificações realizadas após a instrução START TRANSACTION. O novo usuário não foi persistido e os itens da watchlist do usuário 1 foram restaurados ao seu estado original antes do bloco transacional.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Confirma e grava definitivamente todas as operações executadas dentro da transação corrente, tornando as modificações permanentes no armazenamento do banco de dados.

## ROLLBACK

> Aborta a transação e descarta todas as operações realizadas desde o início do bloco, restaurando os dados para o estado exato em que estavam antes do START TRANSACTION.

## Por que transações são importantes?

> Garantem os princípios ACID (Atomicidade, Consistência, Isolamento e Durabilidade). Em sistemas relacionais, impedem inconsistências graves decorrentes de falhas de hardware, erros de rede ou operações parciais (por exemplo, criar um usuário e falhar ao registrar seus vínculos obrigatórios).

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

> Qual é a listagem analítica das séries, exibindo o título, o serviço de streaming, a quantidade total de adições na watchlist e a quantidade de resenhas com nota?

```sql
SELECT 
    s.titulo AS serie,
    p.nome_plataforma AS plataforma,
    COUNT(w.id_usuario) AS total_watchlist,
    COUNT(w.nota) AS total_avaliacoes
FROM serie AS s
INNER JOIN plataforma AS p
    ON s.id_plataforma = p.id_plataforma
LEFT JOIN item_watchlist AS w
    ON s.id_serie = w.id_serie
GROUP BY s.id_serie, s.titulo, p.nome_plataforma
ORDER BY total_watchlist DESC;
```

**Explique:**

> Realiza a junção entre serie e plataforma e utiliza LEFT JOIN com item_watchlist para não omitir produções recém-adicionadas sem audiência. Agrupa pelas chaves e calcula métricas simultâneas de adoção.

---

# 12. Subconsulta final

**Pergunta:**

> Quais usuários atribuíram a alguma série uma nota estritamente maior que a média global de todas as notas do sistema?

```sql
SELECT 
    u.id_usuario, 
    u.nome, 
    w.id_serie, 
    w.nota
FROM usuario AS u
INNER JOIN item_watchlist AS w
    ON u.id_usuario = w.id_usuario
WHERE w.nota > (
    SELECT AVG(nota)
    FROM item_watchlist
    WHERE nota IS NOT NULL
);
```

**Explique:**

> A subconsulta calcula o valor escalar da média aritmética geral do sistema; a consulta externa junta usuários e itens, filtrando os registros que superam essa média.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_estatisticas_series
```

**Por que é importante?**

> Fornece um painel agregado completo com a contagem de interessados, total de avaliações, nota mínima, nota máxima e média aritmética por título, abstraindo agrupamentos para relatórios e dashboards.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_atualizar_status_watchlist
```

**Entrada:**

```text
p_id_usuario INT, p_id_serie INT, p_novo_status VARCHAR(20), p_nota TINYINT
```

**Resultado:**

> Atualiza o status e a nota do item aplicando as validações de negócio e retornando mensagens de feedback ao cliente.

---

# 15. Function final

**Nome:**

```text
fn_classificar_desempenho_serie
```

**O que retorna?**

> Retorna um VARCHAR(30) classificando a aprovação da série em categorias conceituais ('Excelente', 'Bom', 'Regular / Baixo' ou 'Sem Avaliações').

---

# 16. Trigger final

**Nome:**

```text
trg_validar_status_nota_bi / trg_validar_status_nota_bu
```

**Regra automatizada:**

> Força NEW.nota = NULL caso o status atribuído seja 'Quero Ver', impedindo inconsistências diretamente na camada de persistência.

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
| Comportamento de autocommit impedindo teste de ROLLBACK | Modo padrão do Workbench com autocommit ativo | Uso explícito da instrução START TRANSACTION; antes do bloco de comandos |
| Disparo de gatilho em updates manuais | O gatilho original cobria apenas inserções (BEFORE INSERT) | Criação do gatilho espelho para BEFORE UPDATE |
| Erro de variável nula em subconsulta escalar | Cálculo de média executado em tabelas sem notas | Inclusão da cláusula WHERE nota IS NOT NULL |

---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> Operações de manipulação de dados (`INSERT`, `UPDATE` e `DELETE`) e consultas `SELECT`, que foram a base do Módulo 1.

**Conteúdo mais difícil:**

> As consultas do Módulo 2, em especial: `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, consultas com agrupamento e agregação (`GROUP BY`, `HAVING`, `COUNT`,`), subconsultas (subqueries) e rotinas armazenadas (`Stored Procedures` e `Functions`).

**Código do Module-2 que considero mais importante:**

> A procedure `sp_atualizar_status_watchlist'.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> A execução de rotinas com o comando `CALL`: consigo explicar que, diferentemente de uma consulta comum (`SELECT`), uma stored procedure precisa ser chamada com a palavra `CALL` passando os valores desejados entre parênteses, por exemplo `CALL sp_listar_series_por_plataforma('Netflix');`.

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
