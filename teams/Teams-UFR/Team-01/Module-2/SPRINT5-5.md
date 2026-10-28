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

**Banco utilizado:**

```text

```

---

# 2. Revisão do Module-2

| Sprint | Conteúdo | Concluído? |
|---|---|---|
| 1/5 | JOINs |  |
| 2/5 | Subconsultas |  |
| 3/5 | Views |  |
| 4/5 | Procedures e Functions |  |
| 5/5 | Triggers e Transações |  |

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

**Evento:**

- [ ] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text

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
```

**Explique linha por linha:**

> Escreva aqui.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
-- SELECT utilizado.
```

**Operação executada:**

```sql
-- INSERT ou UPDATE utilizado.
```

**Estado depois do teste:**

```sql
-- SELECT utilizado.
```

**Resultado observado:**

> Escreva aqui.

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

```sql
START TRANSACTION;

-- operações

COMMIT;
```

**O que aconteceu após o COMMIT?**

> Escreva aqui.

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
-- SELECT
```

**Verificação depois:**

```sql
-- SELECT
```

**O que o ROLLBACK fez?**

> Escreva aqui.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Explique com suas palavras.

## ROLLBACK

> Explique com suas palavras.

## Por que transações são importantes?

> Escreva aqui.

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

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique:**

> Escreva aqui.

---

# 12. Subconsulta final

**Pergunta:**

> Escreva aqui.

```sql
-- Cole aqui.
```

**Explique:**

> Escreva aqui.

---

# 13. VIEW final mais útil

**Nome:**

```text

```

**Por que é importante?**

> Escreva aqui.

---

# 14. Procedure final mais útil

**Nome:**

```text

```

**Entrada:**

```text

```

**Resultado:**

> Escreva aqui.

---

# 15. Function final

**Nome:**

```text

```

**O que retorna?**

> Escreva aqui.

---

# 16. Trigger final

**Nome:**

```text

```

**Regra automatizada:**

> Escreva aqui.

---

# 17. Teste operacional final

O aluno deverá executar o projeto no MySQL Workbench e verificar:

- [ ] JOINs funcionam;
- [ ] subconsultas funcionam;
- [ ] Views funcionam;
- [ ] Procedures funcionam;
- [ ] Function funciona;
- [ ] Trigger funciona;
- [ ] COMMIT funciona;
- [ ] ROLLBACK funciona.

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

> Escreva aqui.

**Conteúdo mais difícil:**

> Escreva aqui.

**Código do Module-2 que considero mais importante:**

> Escreva aqui.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> Escreva aqui.

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
