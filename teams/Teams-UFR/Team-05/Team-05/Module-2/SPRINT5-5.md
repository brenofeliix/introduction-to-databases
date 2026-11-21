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

> NICOLAS LINO OLIVEIRA

**Banco utilizado:**

```text
banco_imobiliaria
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

> Foram criados dois Triggers:
> 1. **Validação:** uma proposta não pode ter valor menor ou igual a zero (regra de negócio 4 da Sprint 1 do Module 1). O banco bloqueia o `INSERT` inválido, mesmo que ele não venha da Procedure.
> 2. **Automação:** quando um contrato é fechado, o status do imóvel é atualizado sozinho para 'vendido' (venda) ou 'alugado' (aluguel). Isso apoia a regra de negócio 1: um imóvel não pode ficar 'vendido' sem contrato associado.

**Evento:**

- [x] BEFORE INSERT
- [x] AFTER INSERT
- [ ] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

> Trigger 1: **BEFORE INSERT**. Trigger 2: **AFTER INSERT**.

**Tabela envolvida:**

```text
Trigger 1: propostas
Trigger 2: contratos (atualiza imoveis)
```

---

# 4. Implementação do TRIGGER

**SQL do seu Trigger:**

```sql
DELIMITER //

CREATE TRIGGER tg_proposta_valida_valor
BEFORE INSERT ON propostas
FOR EACH ROW
BEGIN
    IF NEW.valor_proposto <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Valor da proposta deve ser maior que zero.';
    END IF;
END //

CREATE TRIGGER tg_contrato_atualiza_status_imovel
AFTER INSERT ON contratos
FOR EACH ROW
BEGIN
    IF NEW.tipo = 'venda' THEN
        UPDATE imoveis
        SET status = 'vendido'
        WHERE id_imovel = NEW.id_imovel;
    ELSEIF NEW.tipo = 'aluguel' THEN
        UPDATE imoveis
        SET status = 'alugado'
        WHERE id_imovel = NEW.id_imovel;
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> **Trigger 1 (`tg_proposta_valida_valor`)**
> - `BEFORE INSERT ON propostas`: executa antes de cada nova proposta ser gravada.
> - `FOR EACH ROW`: roda uma vez para cada linha inserida.
> - `NEW.valor_proposto`: `NEW` representa a linha que está sendo inserida.
> - `IF NEW.valor_proposto <= 0`: verifica a regra de negócio.
> - `SIGNAL SQLSTATE '45000'`: gera um erro definido pelo usuário, que cancela o `INSERT`, com a mensagem do `MESSAGE_TEXT`.
>
> **Trigger 2 (`tg_contrato_atualiza_status_imovel`)**
> - `AFTER INSERT ON contratos`: executa depois que o contrato foi gravado com sucesso.
> - `NEW.tipo` e `NEW.id_imovel`: leem o tipo e o imóvel do contrato recém-inserido.
> - `IF` / `ELSEIF`: se for 'venda', o imóvel vira 'vendido'; se for 'aluguel', vira 'alugado'.
> - `UPDATE imoveis ... WHERE id_imovel = NEW.id_imovel`: altera somente o imóvel do contrato.
> - `DELIMITER //`: necessário porque o corpo do Trigger tem vários `;`.

---

# 5. Testando o Trigger

## Trigger 1: validação

**Estado antes do teste:**

```sql
SELECT * FROM propostas WHERE id_cliente = 6;
```

**Operação executada:**

```sql
START TRANSACTION;
CALL sp_registrar_proposta(6, 4, 300000.00);
SELECT * FROM propostas WHERE id_cliente = 6;
ROLLBACK;
```

**Estado depois do teste:**

```sql
SELECT * FROM propostas WHERE id_cliente = 6;
```

**Resultado observado:**

> Antes do teste, a consulta retorna vazio (a cliente 6 não possui proposta cadastrada). Ao inserir com valor válido (R$ 300.000,00), o Trigger valida e permite a gravação, exibindo a proposta dentro da transação. Com o `ROLLBACK`, a inserção é desfeita e a consulta final volta a retornar vazio. Ao testar um valor inválido (`-500.00`), o `INSERT` é bloqueado imediatamente com o erro 1644 (`SQLSTATE '45000'`) e a mensagem `"Valor da proposta deve ser maior que zero."` (teste deixado comentado no `.sql` para não interromper a execução sequencial do script).

## Trigger 2: atualização automática do status

**Estado antes do teste:**

```sql
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 2;
```

**Operação executada:**

```sql
INSERT INTO contratos (id_imovel, id_cliente, id_corretor, valor_final, tipo, data_fechamento)
VALUES (2, 3, 2, 750000.00, 'venda', CURDATE());
```

**Estado depois do teste:**

```sql
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 2;
```

**Resultado observado:**

> Antes do `INSERT`, o imóvel 2 consta com status `'disponível'`. Logo após a inserção do contrato de venda na tabela `contratos`, sem executar nenhum comando `UPDATE` manualmente, o status do imóvel 2 foi alterado automaticamente para `'vendido'` pelo Trigger `tg_contrato_atualiza_status_imovel`.

---

# 6. START TRANSACTION

Uma transação trata um conjunto de operações como uma unidade: ou todas são confirmadas (`COMMIT`), ou todas são desfeitas (`ROLLBACK`).

```sql
START TRANSACTION;

-- operação 1
-- operação 2

COMMIT;
```

---

# 7. Teste com COMMIT

**Objetivo:**

> Aceitar a proposta 3 (Guilherme, imóvel 2) e fechar o contrato de venda desse imóvel. As duas operações precisam acontecer juntas: não faz sentido ter contrato sem a proposta aceita.

```sql
START TRANSACTION;

UPDATE propostas
SET status = 'aceita'
WHERE id_proposta = 3;

INSERT INTO contratos (id_imovel, id_cliente, id_corretor, valor_final, tipo, data_fechamento)
VALUES (2, 3, 2, 750000.00, 'venda', CURDATE());

COMMIT;
```

**O que aconteceu após o COMMIT?**

> As alterações foram gravadas definitivamente no banco: a proposta 3 passou para `'aceita'`, o contrato foi registrado e o Trigger marcou o imóvel 2 como `'vendido'`. A tabela `contratos` passou de 1 para 2 registros, e a VIEW `vw_resumo_corretores` passou a exibir Mariana Albuquerque com 1 contrato fechado, R$ 750.000,00 vendidos e R$ 41.250,00 de comissão (5,5%). Ao final do bloco de teste no `.sql`, os dados originais foram restaurados via `DELETE` e `UPDATE` para permitir a reexecução limpa do script.

---

# 8. Teste com ROLLBACK

```sql
START TRANSACTION;

UPDATE propostas
SET status = 'aceita'
WHERE id_proposta = 4;

INSERT INTO contratos (id_imovel, id_cliente, id_corretor, valor_final, tipo, data_fechamento)
VALUES (6, 4, 1, 560000.00, 'venda', CURDATE());

ROLLBACK;
```

**Verificação antes:**

```sql
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 6;
SELECT id_proposta, status FROM propostas WHERE id_proposta = 4;
SELECT COUNT(*) AS total_contratos FROM contratos;
```

**Verificação depois:**

```sql
SELECT id_imovel, status FROM imoveis WHERE id_imovel = 6;
SELECT id_proposta, status FROM propostas WHERE id_proposta = 4;
SELECT COUNT(*) AS total_contratos FROM contratos;
```

**O que o ROLLBACK fez?**

> Antes da transação, o imóvel 6 estava `'disponível'`, a proposta 4 `'em análise'` e havia 1 contrato na base. Durante a transação, o imóvel 6 chegou a ser alterado para `'vendido'` pela ação do Trigger. Após o `ROLLBACK`, todas as operações foram revertidas e o banco voltou exatamente ao estado inicial: imóvel 6 `'disponível'`, proposta 4 `'em análise'` e 1 contrato cadastrado — desfazendo inclusive o efeito disparado automaticamente pelo Trigger.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Confirma a transação: todas as alterações feitas desde o `START TRANSACTION` passam a ser definitivas e visíveis para outros usuários. Depois do `COMMIT`, não dá mais para desfazer com `ROLLBACK`.

## ROLLBACK

> Cancela a transação: todas as alterações feitas desde o `START TRANSACTION` são desfeitas e o banco volta ao estado anterior, como se nada tivesse acontecido.

## Por que transações são importantes?

> Porque várias operações relacionadas precisam acontecer por inteiro ou não acontecer. No fechamento de um contrato, por exemplo, atualizar a proposta, criar o contrato e mudar o status do imóvel formam uma única operação. Se algo der errado no meio, o `ROLLBACK` evita dados inconsistentes, como um imóvel marcado como 'vendido' sem contrato.

---

# 10. Integração do Module-2

O `SPRINT5-5.sql` integra os conteúdos do `Module-2` usando o banco já existente, sem recriar as tabelas do Module-1:

```text
1. USE banco
2. consulta com JOIN
3. subconsulta
4. Views (3)
5. Procedures (2)
6. Function (1)
7. Triggers (2)
8. teste de COMMIT
9. teste de ROLLBACK
10. consultas de validação
```

---

# 11. Consulta relacional final

**Pergunta:**

> Para cada imóvel, quem é o corretor responsável (gestão ativa) e quantas visitas o imóvel já recebeu?

```sql
SELECT
    i.id_imovel,
    i.endereco,
    cor.nome AS corretor_responsavel,
    COUNT(v.id_visita) AS total_visitas
FROM imoveis AS i
INNER JOIN gestoes AS g
    ON i.id_imovel = g.id_imovel
   AND g.data_fim IS NULL
INNER JOIN corretores AS cor
    ON g.id_corretor = cor.id_corretor
LEFT JOIN visitas AS v
    ON i.id_imovel = v.id_imovel
GROUP BY i.id_imovel, i.endereco, cor.nome
ORDER BY total_visitas DESC, i.id_imovel ASC;
```

**Explique:**

> Liga quatro tabelas: `imoveis`, `gestoes` e `corretores` (com `INNER JOIN`, para pegar o corretor da gestão ativa) e `visitas` (com `LEFT JOIN`, para manter imóveis sem visita). O `GROUP BY` forma um grupo por imóvel, e `COUNT(v.id_visita)` conta as visitas de cada um. O imóvel 3 aparece primeiro, com 2 visitas; os imóveis 1, 2 e 6 têm 1 visita; os imóveis 4 e 5 têm 0.

---

# 12. Subconsulta final

**Pergunta:**

> Quais clientes interessados em compra têm orçamento acima do preço médio dos imóveis disponíveis?

```sql
SELECT
    nome,
    contato,
    orcamento
FROM clientes
WHERE tipo_interesse = 'compra'
  AND orcamento > (
      SELECT AVG(preco)
      FROM imoveis
      WHERE status = 'disponível'
  )
ORDER BY orcamento DESC;
```

**Explique:**

> A consulta interna calcula o preço médio dos imóveis com status 'disponível' (cerca de R$ 406.520,00). A consulta externa mostra apenas os clientes de compra cujo orçamento é maior que esse valor. Retornam Guilherme Antunes (R$ 800.000), Camila Duarte Ramos (R$ 600.000) e Lucas Henrique Ferreira (R$ 480.000). A Larissa (R$ 320.000) fica de fora.

---

# 13. VIEW final mais útil

**Nome:**

```text
vw_resumo_corretores
```

**Por que é importante?**

> Reúne em um só lugar o desempenho de cada corretor: contratos fechados, total vendido e comissão a receber. Como é uma VIEW, sempre mostra os dados atuais. Na demonstração do `COMMIT`, ela passou a mostrar o novo contrato assim que ele foi gravado.

---

# 14. Procedure final mais útil

**Nome:**

```text
sp_registrar_proposta
```

**Entrada:**

```text
p_id_cliente INT, p_id_imovel INT, p_valor DECIMAL(12,2)
```

**Resultado:**

> Se o valor for maior que zero, insere a proposta com a data atual e status 'em análise', e devolve uma mensagem de sucesso com o id gerado. Se for zero ou negativo, devolve uma mensagem de erro e não insere nada. Além disso, o Trigger `tg_proposta_valida_valor` protege a tabela contra valores inválidos mesmo em `INSERT` diretos.

---

# 15. Function final

**Nome:**

```text
fn_calcular_comissao
```

**O que retorna?**

> Retorna, em reais, a comissão de um corretor sobre um valor (`valor * percentual / 100`), usando o percentual cadastrado em `corretores`. Se o corretor não existir, retorna 0. Exemplo: `fn_calcular_comissao(1, 500000)` retorna R$ 30.000,00.

---

# 16. Trigger final

**Nome:**

```text
tg_contrato_atualiza_status_imovel
```

**Regra automatizada:**

> Ao inserir um contrato, o status do imóvel é atualizado automaticamente: 'vendido' para contratos de venda e 'alugado' para contratos de aluguel. Isso evita esquecer de atualizar o imóvel e mantém o catálogo (e a VIEW `vw_imoveis_disponiveis`) sempre correto.

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

---

# 18. Validação prática/oral

Estou preparado para executar, explicar, alterar, testar e corrigir qualquer parte do código entregue, incluindo:

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
| Erro 1442 ao tentar atualizar tabela dentro do Trigger | Tentativa inicial de alterar a mesma tabela que disparou o Trigger (`propostas`) | Manter o Trigger da tabela `propostas` apenas para validação (`BEFORE INSERT` com `SIGNAL`) e atualizar somente a tabela `imoveis` a partir de `contratos` |
| Teste de valor inválido interrompia a execução do `.sql` inteiro | O `SIGNAL SQLSTATE '45000'` aborta o script no Workbench quando ocorre erro | Manter o teste negativo comentado no script principal e validar com transação e `ROLLBACK` no fluxo contínuo |
| Dados alterados após o teste de `COMMIT` impediam reexecutar o script com o estado inicial | O `COMMIT` grava definitivamente a alteração do status do imóvel e o novo contrato | Adicionar comandos de limpeza (`DELETE` e `UPDATE`) ao final do teste para restaurar o banco ao estado original |

---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> JOINs, Views e a lógica de controle transacional (`START TRANSACTION`, `COMMIT` e `ROLLBACK`). Ficou muito claro como relacionar várias tabelas para gerar relatórios úteis (como comissões e visitas) e como encapsular essas consultas em Views para facilitar o uso no dia a dia.

**Conteúdo mais difícil:**

> Subconsultas correlacionadas e a combinação de Triggers com transações, principalmente entender as restrições do MySQL dentro de Triggers (como não poder modificar a própria tabela que acionou o evento) e garantir que o script pudesse ser executado várias vezes sem deixar dados sujos.

**Código do Module-2 que considero mais importante:**

> A integração entre a transação de fechamento de contrato (`COMMIT`/`ROLLBACK`), o Trigger `tg_contrato_atualiza_status_imovel` e a VIEW `vw_resumo_corretores`, pois mostra na prática o banco garantindo consistência dos dados e atualizando indicadores de negócio automaticamente.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> A diferença entre `INNER JOIN` e `LEFT JOIN`, o funcionamento de `COMMIT` e `ROLLBACK`, a estrutura de uma `VIEW`, como funciona o `DELIMITER` em Procedures/Functions e como o Trigger `tg_contrato_atualiza_status_imovel` usa `NEW` para atualizar o status do imóvel automaticamente.

---

# 21. Estrutura do SPRINT5-5.sql

O arquivo segue a estrutura recomendada: `USE`, JOINs, subconsultas, Views, Procedures e Function, Triggers, transação com `COMMIT`, transação com `ROLLBACK` e validação final (`SHOW TRIGGERS`, `SHOW PROCEDURE STATUS`, `SHOW FUNCTION STATUS` e conferência dos dados). Os testes que alteram dados restauram o estado original no final.

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

Total: 10 arquivos.

---

# 23. Checklist final

- [x] mantive os arquivos do Module-1;
- [x] utilizei a mesma branch `team-05`;
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

```text
Conclui Module 2 Sprint 5 de 5 - triggers e transacoes
```

---

# 25. Pull Request final do Module-2

Origem:

```text
team-05
```

Destino:

```text
main
```

Título:

```text
[N2][UFR][Team 05] Sprints 1-5 - banco_imobiliaria
```

---

# 26. Descrição do Pull Request

```text
## Identificação

Aluno: NICOLAS LINO OLIVEIRA
Instituição: UFR
Branch: team-05
Banco: banco_imobiliaria
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

Foi utilizada uma LLM como apoio para estruturar o código. Todo o código foi compreendido, adaptado, executado, testado e validado no MySQL Workbench, e consigo explicar presencialmente qualquer parte entregue.
