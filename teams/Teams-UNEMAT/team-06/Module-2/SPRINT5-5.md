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

> Mariano Lino da Silva Neto

**Banco utilizado:**

```
DB_Conveniencia
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

> Atualizar o estoque automaticamente dando baixa na quantidade de um produto sempre que um novo registro de venda for inserido na tabela Item_venda.

**Evento:**

- [ ] BEFORE INSERT
- [x] AFTER INSERT
- [ ] BEFORE UPDATE
- [ ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```
Item_venda
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
CREATE TRIGGER trg_atualiza_estoque_venda
AFTER INSERT ON Item_venda
FOR EACH ROW
BEGIN
UPDATE Produto
SET quantidade_estoque = quantidade_estoque - NEW.quantidade
WHERE id_produto = NEW.id_produto;
END //

DELIMITER ;
```

**Explique linha por linha:**

> Delimiter vai mudar o cacactere de encerramento temporario, ai o TRIGER vai criar o gatilho com um nome descritivo, em sequencia o INSERT ON vai definir o gatilho que só vai disparar depois de uma nova linha for inserida na tabela, no EACH ROW ele vai garantir que a regra seja executada para cada linha inserida, caso um INSERT adicione Multiplos registros de uma vez, o BEGIN vai começar o bloco de comandos, UPDATE vai chamar a tabela que vai acontecer a alteração, o SET quantidade vai pegar o estado atual e subtrai pelo valor da coluna quantidade que acabou de ser inserida pelo prefixo NEW, o WHERE do new.id_produto vai garantir que a baixa do estoque será feita apenas no produto correto, e por fim o END Finaliza o bloco do trigger,

---

# 5. Testando o Trigger

**Estado antes do teste:**

```sql
SELECT nome_produto, quantidade_estoque FROM Produto WHERE id_produto = 1;
```

**Operação executada:**

```sql
INSERT INTO Item_venda(quantidade, id_venda, id_produto) VALUES (3, 2, 1);
```

**Estado depois do teste:**

```sql
SELECT nome_produto, quantidade_estoque FROM Produto WHERE id_produto = 1;
```

**Resultado observado:**

> Sem a gente precisar executar nenhum UPDATE manual o banco de dados sozinha vai notar o INSERT na tabela Item_venda e o trigger vai disparar sozinho reduzindo as 3 unidades do pão frito, indo de 40 para 37

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

> Registrar o cabeçalho de uma venda e seus itens em um bloco seguro, se os dois funcionarem a gente confirma a gravação de tudo junto.

```sql
START TRANSACTION;

INSERT INTO Venda(valor_total) VALUES(20.00);

SET @id_nova_venda = LAST_INSERT_ID();

INSERT INTO Item_venda(quantidade, id_venda, id_produto) VALUES(2,@id_nova_venda,4);

COMMIT;
```

**O que aconteceu após o COMMIT?**

> Todas as operações que estavam pendentes na memoria durante a transação foram oficializadas e gravadas fisicamente no banco de dados. A venda e o item foram registrados permanentemente. 

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
START TRANSACTION;

INSERT INTO Venda(valor_total) VALUES(150.00);
SET @id_venda_cancelada = LAST_INSERT_ID();

ROLLBACK;
```

**Verificação antes:**

```sql
-- SELECT
```

**Verificação depois:**

```sql
SELECT MAX(id_venda) AS ultima_venda FROM Venda;
```

**O que o ROLLBACK fez?**

> O ROLLBACK desfaz o INSERT da venda de 150 que estava temporariamente na memoria, na verificação retornou o mesmo id_venda de antes do inicio da transação, comprovando que o banco de dados abortou a inserção e voltou ao seu estado anterior.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> Ele basicamente salva, ele diz ao banco de dados que todas as etapas da transação deram certo e que ele pode confirmar e gravar os dados definitvamente no disco.

## ROLLBACK

> Ele cancela as coisas basicamente, ele diz ao banco de dados que aconteceu um erro no meio de alguma ação e que ele pode jogar fora todas as alterações que foram feitas desde o START TRANSACTION e que ele pode voltar como estava antes.

## Por que transações são importantes?

> São importantes no meu sistema visto que uma venda pode depender de inserir dados na tabela Venda e em Item_venda e caso aconteça alguma queda de energia ou erro de rede entre algumas das duas inserções, a gente acabaria ficando com uma Venda sem Itens ou Itens sem vendas associadas e acabaria gerando no Banco dados sem valor, e então por isso a transação garante que tudo vá ser salvo no COMMIT ou nada ser salvo no ROLLBACK.

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

> Como exibir o historico de todas as vendas detalhando o nome do produto, o nome de sua categoria e a data exata da venda?

```sql
SELECT 
v.id_venda,
v.data_venda,
c.nome_categoria,
p.nome_produto,
iv.quantidade
FROM Venda AS v
INNER JOIN Item_venda AS iv ON v.id_venda = iv.id_venda
INNER JOIN Produto AS p ON iv.id_produto = p.id_produto
INNER JOIN Categoria AS c ON p.id_categoria = c.id_categoria
ORDER BY v.data_venda DESC;
```

**Explique:**

> Em poucas palavras essa consulta vai conectar as quatro tabelas simultaneamente usando as chaves primarias e estrangeiras para transformar o ID numerido cru de todo mundo em informações legiveis e gerenciais para o dono do Negocio.

---

# 12. Subconsulta final

**Pergunta:**

> Quais Categorias possuem produtos com preços acima da media geral de todos os produtos da loja? 

```sql
SELECT nome_categoria
FROM Categoria
WHERE id_categoria IN (
SELECT DISTINCT id_categoria
FROM Produto
WHERE preco_venda > (SELECT AVG(preco_venda) FROM Produto)
);
```

**Explique:**

> Ele cria uma Subconsulta aninhada, a mais interna vai calcula a media geral dos preços e a intermediaria vai buscar as categorias com os produtos mais caros que essa media, e a consulta principal vai trazer o nome descritivo dessas categorias usando o operador IN

---

# 13. VIEW final mais útil

**Nome:**

```
vw_estoque_critico
```

**Por que é importante?**

> Porque ele tira a complexidade de regras e relacionamentos para o dia a dia operacional, o repositor na conveniencia só vai precisar de um SELECT simples para saber o que vai precisar repor nas prateleiras, sem risco e errar digitações complexas.

---

# 14. Procedure final mais útil

**Nome:**

```
sp_produtos_por_categoria

```

**Entrada:**

```
p_nome_categoria VARCHAR(50)
```

**Resultado:**

> Retorna de forma rápida e parametrizada uma tabela com o catálogo de produtos inteiros de apenas um setor(ex:"bebidas") simplificando integrações com o backend da aplicação

---

# 15. Function final

**Nome:**

```
fn_aplicar_desconto

```

**O que retorna?**

> Retorna o valor numérico recalculado(DECIMAL 10,2) de um produto ou de uma compra após a aplicação de um percentual de desconto fornecido.

---

# 16. Trigger final

**Nome:**

```
trg_atualiza_estoque_venda

```

**Regra automatizada:**

> Controle de inventario invisivel para o usuario final: abate o estoque sempre que uma venda ocorre com sucesso na tabela de itens

---

# 17. Teste operacional final

O aluno deverá executar o projeto no MySQL Workbench e verificar:

- [X] JOINs funcionam;
- [x] subconsultas funcionam;
- [x] Views funcionam;
- [x] Procedures funcionam;
- [x] Function funciona;
- [x] Trigger funciona;
- [X] COMMIT funciona;
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

> JOINS E VIEW são os mais de boas para poder ficar entendendo pq são bem simples.

**Conteúdo mais difícil:**

> Aqui não tem outro né, tem que ser a bomba do TRIGGER, acho que não tem nada mais chato do que esse conteudo embora seja muito util.

**Código do Module-2 que considero mais importante:**

> Com toda certeza o sistema de segurança composto por: START TRANSACTION, COMMIT e ROLLBACK, são basicamente necessarios e fundamentais para quando você for mexer com dinheiro e como você não quer tomar um processo ferrado e perder dinheiro, eles são de extrema importancia.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> Inner e LEFT Join, acho que são os mais de boas pra explicar

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
- [X] subconsultas funcionam;
- [X] Views funcionam;
- [x] Procedures funcionam;
- [X] Function funciona;
- [x] Trigger funciona;
- [x] COMMIT e ROLLBACK foram demonstrados;
- [x] compreendo o código entregue;
- [X] revisei os nomes dos arquivos;
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
