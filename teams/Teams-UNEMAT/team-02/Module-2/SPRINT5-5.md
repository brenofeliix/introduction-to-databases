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

> Geovanna Gaspar Ribeiro

**Banco utilizado:**

```text
gerenciamento_incidentes
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

> Sempre que o status de um incidente for alterado, registrar automaticamente um histórico dessa mudança (status anterior, status novo e o momento da alteração), sem depender de o analista lembrar de registrar isso manualmente.

**Evento:**

- [ ] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [x] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
incidentes (tabela monitorada)
historico_status_incidentes (tabela de auditoria, criada nesta Sprint)
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
CREATE TABLE IF NOT EXISTS historico_status_incidentes (
    id_historico     INT AUTO_INCREMENT PRIMARY KEY,
    id_incidente     INT NOT NULL,
    status_anterior  VARCHAR(20),
    status_novo      VARCHAR(20),
    data_alteracao   DATETIME,
    FOREIGN KEY (id_incidente) REFERENCES incidentes(id_incidente)
);

DELIMITER //

CREATE TRIGGER trg_historico_status_incidentes
AFTER UPDATE ON incidentes
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO historico_status_incidentes (
            id_incidente, status_anterior, status_novo, data_alteracao
        )
        VALUES (
            OLD.id_incidente, OLD.status, NEW.status, NOW()
        );
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> CREATE TABLE IF NOT EXISTS historico_status_incidentes cria a tabela que vai guardar o histórico, com uma FK para incidentes, caso ela ainda não exista. CREATE TRIGGER trg_historico_status_incidentes AFTER UPDATE ON incidentes define que o trigger dispara depois que um UPDATE na tabela incidentes é concluído. FOR EACH ROW indica que o trigger roda uma vez para cada linha afetada pelo UPDATE (e não uma única vez para o comando inteiro). Dentro do BEGIN...END, OLD representa os valores da linha antes da atualização, e NEW representa os valores depois. O IF OLD.status <> NEW.status THEN garante que só é registrado histórico quando o status realmente mudou se o UPDATE alterou outra coluna (por exemplo, só a severidade) sem mexer no status, nada é inserido. O INSERT INTO historico_status_incidentes grava o id do incidente, o status antigo, o novo, e o momento exato da alteração (NOW()).

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
SELECT * FROM historico_status_incidentes;
```

**Operação executada:**

```sql
UPDATE incidentes
SET status = 'RESOLVIDO'
WHERE id_incidente = 3;
```

**Estado depois do teste:**

```sql
SELECT * FROM historico_status_incidentes;
```

**Resultado observado:**

> Antes do UPDATE, a tabela historico_status_incidentes está vazia (ou só com registros de testes anteriores). Depois do UPDATE, aparece uma nova linha automaticamente, com id_incidente = 3, o status_anterior (o valor que o incidente tinha antes) e status_novo = 'RESOLVIDO', sem que nenhum INSERT manual tenha sido feito — confirmando que o trigger disparou sozinho, em resposta ao UPDATE.

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

> Registrar um novo incidente e, na mesma transação, registrar a ação de resposta correspondente, garantindo que as duas inserções aconteçam juntas, já que uma ação de resposta sem o incidente correspondente não faz sentido no domínio.

```sql

START TRANSACTION;

INSERT INTO incidentes (
    titulo, descricao, severidade, status,
    id_analista, id_dispositivo, id_ameaca, id_alerta
)
VALUES (
    'Escaneamento de portas não autorizado',
    'Ferramenta de scan identificada tentando mapear portas abertas no firewall.',
    'MEDIA', 'ABERTO', 4, 3, 4, NULL
);

INSERT INTO acoes_resposta (descricao, id_incidente)
VALUES ('Bloqueio do IP de origem do escaneamento no firewall.', LAST_INSERT_ID());

COMMIT;
```

**O que aconteceu após o COMMIT?**

> As duas inserções foram confirmadas de forma permanente no banco. LAST_INSERT_ID() foi usado para capturar o id_incidente gerado automaticamente pelo primeiro INSERT, garantindo que a ação de resposta fosse vinculada ao incidente correto, mesmo sem saber de antemão qual seria esse id. Depois do COMMIT, tanto o novo incidente quanto a nova ação de resposta ficam visíveis para qualquer consulta feita a partir desse momento, inclusive em outras sessões/conexões. 

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
START TRANSACTION;

DELETE FROM alertas
WHERE id_alerta = 3;

ROLLBACK;
```

**Verificação antes:**

```sql
SELECT * FROM alertas WHERE id_alerta = 3;
```

**Verificação depois:**

```sql
SELECT * FROM alertas WHERE id_alerta = 3;
```

**O que o ROLLBACK fez?**

> Simulei a exclusão acidental de um alerta (id_alerta = 3) dentro de uma transação. Antes do ROLLBACK, se eu consultasse a tabela na mesma sessão, o alerta já apareceria como removido. Mas como a transação nunca foi confirmada com COMMIT, o ROLLBACK desfez a exclusão por completo, a consulta feita depois do ROLLBACK mostra o alerta 3 exatamente como estava antes, como se o DELETE nunca tivesse acontecido.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> COMMIT confirma permanentemente todas as operações realizadas desde o início da transação (START TRANSACTION). Depois do COMMIT, as mudanças não podem mais ser desfeitas por essa transação, elas passam a fazer parte definitiva dos dados do banco.

## ROLLBACK

> ROLLBACK desfaz todas as operações realizadas desde o início da transação, devolvendo os dados ao estado em que estavam antes dela começar. É como um "Ctrl+Z" para tudo o que foi feito dentro daquela transação, desde que ainda não tenha sido confirmado com COMMIT.

## Por que transações são importantes?

> Porque garantem que operações que dependem umas das outras (como inserir um incidente e sua ação de resposta) aconteçam de forma atômica: ou as duas são salvas juntas, ou nenhuma delas é salva. Sem transação, se o banco falhasse ou o script fosse interrompido entre os dois INSERTs, o sistema ficaria com uma ação de resposta "órfã" apontando para um incidente inexistente, ou um incidente sem sua ação correspondente, um estado inconsistente que as transações existem justamente para evitar.
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

> Quais incidentes de severidade crítica estão sob responsabilidade de qual analista? 

```sql
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.severidade
FROM analistas a
INNER JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.severidade = 'CRITICA';
```

**Explique:**

> O INNER JOIN liga cada incidente ao seu analista responsável, e o WHERE restringe o resultado apenas aos incidentes de severidade 'CRITICA', permitindo identificar rapidamente quem está tratando os casos de maior risco no sistema.

---

# 12. Subconsulta final

**Pergunta:**

> Para cada analista, qual foi o incidente mais recente atribuído a ele?

```sql
SELECT a.nome AS analista,
       i.titulo AS incidente_mais_recente,
       i.data_identificacao
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
WHERE i.data_identificacao = (
    SELECT MAX(i2.data_identificacao)
    FROM incidentes i2
    WHERE i2.id_analista = a.id_analista
);
```

**Explique:**

> A subconsulta é correlacionada porque depende do id_analista da linha atual da consulta externa, para cada analista, ela recalcula qual é a maior data_identificacao entre os incidentes daquele analista específico, e a consulta externa mantém apenas o incidente que corresponde a essa data mais recente.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_incidentes_em_aberto
```

**Por que é importante?**

> Representa exatamente o painel operacional que um analista ou coordenador do SOC consultaria no dia a dia, todos os incidentes ainda não resolvidos (ABERTO ou EM_ANALISE), já com analista e dispositivo envolvidos, sem precisar reescrever o JOIN e o filtro toda vez.

---

# 14. Procedure final mais útil

**Nome:**

```text
encerrar_incidente
```

**Entrada:**

```text
p_id_incidente INT
```

**Resultado:**

> Encerra o incidente informado (mudando status para 'ENCERRADO' e preenchendo data_encerramento), mas verifica antes se ele já estava encerrado, evitando reprocessar ou sobrescrever dados indevidamente. É a rotina mais próxima de uma ação real que um analista executaria no sistema.

---

# 15. Function final

**Nome:**

```text
dias_em_aberto
```

**O que retorna?**

> Um número inteiro representando quantos dias se passaram entre a identificação de um incidente e seu encerramento (ou até o momento atual, se ele ainda estiver em aberto), útil para medir o tempo de resposta da equipe a cada incidente.

---

# 16. Trigger final

**Nome:**

```text
trg_historico_status_incidentes
```

**Regra automatizada:**

> Sempre que o status de um incidente é alterado por um UPDATE, o trigger registra automaticamente, na tabela historico_status_incidentes, o status anterior, o novo status e o momento da mudança, criando uma trilha de auditoria sem depender de nenhuma ação manual do analista.

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

> JOINs (INNER, LEFT e RIGHT) e Viewss são os conceitos que mais usei e que ficaram mais intuitivos de explicar.

**Conteúdo mais difícil:**

> Encontro dificuldade principalmente na lógica de construção das consultas. Embora eu compreenda os conceitos e seus significados, tenho dificuldade em aplicá-los na prática, e o uso de aliases também gera confusão.

**Código do Module-2 que considero mais importante:**

> A Procedure encerrar_incidente combinada com o Trigger trg_historico_status_incidentes juntos, representam uma automação real e coerente com o domínio: encerrar um incidente de forma segura e manter um histórico automático dessa mudança.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> JOINs, views e functions pois foram os conteúdos que mais fixei.

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

- [x] mantive os arquivos do Module-1;
- [x] utilizei a mesma branch `team-XX`;
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
- [x] compreendo o código entregue;
- [x] revisei os nomes dos arquivos;
- [x] nenhum arquivo foi colocado fora de `Module-2`.

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
- [] ROLLBACK testado
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
