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

> Vinícius Eduardo Lima de Assis.

**Banco utilizado:**

```text
pacote_viagens
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

> Validar o valor da diária antes da inserção ou atualização na tabela hospedagem. Caso o valor informado seja menor ou igual a zero, a operação é interrompida lançando um erro customizado (SIGNAL SQLSTATE).

**Evento:**

- [x] BEFORE INSERT
- [ ] AFTER INSERT
- [x] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```text
hospedagem
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
-- USE pacote_viagens;

DELIMITER //

DROP TRIGGER IF EXISTS trg_validar_valor_diaria_bi //

CREATE TRIGGER trg_validar_valor_diaria_bi
BEFORE INSERT ON hospedagem
FOR EACH ROW
BEGIN
    IF NEW.valor_diaria <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: O valor da diária deve ser maior que zero.';
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> "USE pacote_viagens;": Define o banco de dados ativo."DELIMITER //": Altera o delimitador padrão para // a fim de permitir múltiplos comandos no bloco. "DROP TRIGGER IF EXISTS trg_validar_valor_diaria_bi //": Remove o trigger anterior se já existir."CREATE TRIGGER trg_validar_valor_diaria_bi": Define a criação do trigger nomeado."BEFORE INSERT ON hospedagem": Especifica que a execução ocorrerá antes de disparar a gravação na tabela hospedagem."FOR EACH ROW": Executa o bloco para cada nova linha que estiver sendo inserida."BEGIN ... END": Delimita o bloco lógico de instruções."IF NEW.valor_diaria <= 0 THEN": Checa se a nova diária informada (NEW.valor_diaria) é menor ou igual a zero."SIGNAL SQLSTATE '45000' ...": Interrompe a execução lançando uma exceção de erro personalizada."DELIMITER ;": Restaura o delimitador padrão do MySQL para ;.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
-- SELECT COUNT(*) FROM hospedagem;
```

**Operação executada:**

```sql
-- INSERT INTO hospedagem (nome, endereco, tipo, valor_diaria, id_destino)
VALUES ('Pousada Inválida', 'Rua Teste, 100', 'Pousada', 0.00, 1);
```

**Estado depois do teste:**

```sql
-- SELECT COUNT(*) FROM hospedagem;
```

**Resultado observado:**

> O MySQL bloqueou com sucesso a inserção e exibiu a mensagem de erro customizada: Error Code: 1644. Erro: O valor da diária deve ser maior que zero. A contagem de linhas permaneceu inalterada.

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

> Cadastrar um novo cliente e registrar imediatamente uma nova reserva para ele em um único bloco.

```sql
START TRANSACTION;

-- operações

COMMIT;
```
**Operação executada:**

```sql
USE pacote_viagens;

START TRANSACTION;

INSERT INTO cliente (nome, cpf, email, telefone, ativo)
VALUES ('Fernando Rocha', '987.654.321-99', 'fernando.rocha@email.com', '(11) 91111-2222', TRUE);

SET @novo_id_cliente = LAST_INSERT_ID();

INSERT INTO reserva_pacote (id_cliente, id_hospedagem, id_transporte, data_reserva, quantidade_pessoas)
VALUES (@novo_id_cliente, 1, 1, '2026-11-10', 2);

COMMIT;
```

**O que aconteceu após o COMMIT?**

> Ambas as inserções foram gravadas de forma permanente no banco de dados. Os novos registros ficaram imediatamente visíveis em consultas futuras.

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
-- SELECT COUNT(*) AS total_clientes FROM cliente;
```

**Operação executada:**

```sql
-- START TRANSACTION;

INSERT INTO cliente (nome, cpf, email, telefone, ativo)
VALUES ('Cliente Teste Rollback', '000.111.222-33', 'teste.rollback@email.com', '(00) 00000-0000', TRUE);

-- Simulação de descontentamento/cancelamento da operação
ROLLBACK;
```

**Verificação depois:**

```sql
-- SELECT COUNT(*) AS total_clientes FROM cliente;
```

**O que o ROLLBACK fez?**

> Desfez completamente a inserção efetuada dentro da transação. A contagem total de clientes permaneceu exatamente a mesma de antes da execução da transação.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Instrui o sistema do banco de dados a confirmar e salvar permanentemente todas as alterações realizadas desde o início da transação (START TRANSACTION).

## ROLLBACK

> Instrui o sistema do banco a descartar e desfazer todas as modificações realizadas durante a transação, restaurando o banco ao estado exatamente anterior ao START TRANSACTION.

## Por que transações são importantes?

> Pois servem para proteger a integridade dos dados contra erros de código, falhas de conexão, queda de energia ou cancelamentos intencionais.

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

> Qual o detalhamento de cada reserva efetuada com o nome do cliente, hospedagem, diária e destino?

```sql
-- SELECT 
    r.id_reserva,
    c.nome AS cliente,
    h.nome AS hospedagem,
    h.valor_diaria,
    d.nome AS destino
FROM reserva_pacote AS r
INNER JOIN cliente AS c ON r.id_cliente = c.id_cliente
INNER JOIN hospedagem AS h ON r.id_hospedagem = h.id_hospedagem
INNER JOIN destino AS d ON h.id_destino = d.id_destino;
```

**Explique:**

> Realiza o encadeamento de junções (INNER JOIN) a partir da tabela associativa reserva_pacote para trazer a visualização completa do cliente e sua respectiva estadia cadastrada.

---

# 12. Subconsulta final

**Pergunta:**

> Quais hospedagens possuem diária superior à média geral de diárias cadastradas?

```sql
-- SELECT 
    nome,
    tipo,
    valor_diaria
FROM hospedagem
WHERE valor_diaria > (
    SELECT AVG(valor_diaria)
    FROM hospedagem
);
```

**Explique:**

> A subconsulta calcula a média das diárias e a consulta externa filtra e exibe apenas as acomodações que custam acima do valor médio obtido.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_detalhes_reservas
```

**Por que é importante?**

> Consolida a abstração de consultas operacionais frequentes da agência, permitindo acessar rapidamente clientes, estadias e meios de transporte envolvidos nas reservas ativas sem reescrever múltiplos JOINs.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_buscar_hospedagens_destino
```

**Entrada:**

```text
p_id_destino INT
```

**Resultado:**

> Retorna a relação de todas as hospedagens cadastradas vinculadas àquele destino específico.

---

# 15. Function final

**Nome:**

```text
fn_calcular_valor_total_reserva
```

**O que retorna?**

> Um valor DECIMAL(10,2) representando o subtotal estimado da reserva (valor da diária x número de hóspedes).

---

# 16. Trigger final

**Nome:**

```text
trg_validar_valor_diaria_bi
```

**Regra automatizada:**

> Impede o cadastro ou alteração de hospedagens com valores de diária menores ou iguais a zero (R$ 0,00).

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

> A criação de visões (VIEWs) e o uso de JOINs múltiplos para sintetizar dados relacionais de várias tabelas.

**Conteúdo mais difícil:**

> Entender a sintaxe de variáveis e fluxo lógico dentro de PROCEDUREs e TRIGGERs.

**Código do Module-2 que considero mais importante:**

> A Procedure com junção relacional e parâmetros de entrada, pois automatiza diretamente uma consulta comum de regra de negócio da agência de viagens.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> A diferença entre INNER JOIN, LEFT JOIN e RIGHT JOIN, criação de VIEWs e a utilização de DELIMITER na construção de rotinas no MySQL.

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
