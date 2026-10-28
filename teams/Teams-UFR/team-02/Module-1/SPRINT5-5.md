# SPRINT 5/5 — Validação Final, Integração e Entrega do Banco de Dados

**Disciplina:** Laboratório de Banco de Dados
**Modalidade:** Atividade individual
**Aluno:** Rafael Tokashiki Souza
**Instituição:** UFR
**Banco:** `imobiliaria`
**Entrega desta Sprint:** `SPRINT5-5.md` + `SPRINT5-5.sql`

---

# 3. Revisão da Sprint 1/5 — Planejamento

## Tema do banco

```text
Imobiliária — gestão de imóveis, proprietários, clientes e negociações
```

## Objetivo principal

> Centralizar em uma única base relacional as informações da carteira de
> imóveis e das negociações da imobiliária, garantindo integridade entre os
> dados (nenhum imóvel sem proprietário, nenhum contrato sem cliente) e
> permitindo consultas que apoiem a tomada de decisão comercial.

## Quantidade final de tabelas

```text
6
```

## Principais entidades do banco

1. `proprietarios` — donos dos imóveis administrados pela imobiliária
2. `imoveis` — unidades da carteira, para venda ou locação
3. `clientes` — pessoas interessadas em comprar ou alugar
4. `corretores` — profissionais responsáveis pelo atendimento
5. `visitas` — registro de cada visita de um cliente a um imóvel
6. `contratos` — negócios de venda e locação fechados

## O projeto final permaneceu igual ao planejamento inicial?

- [x] Sim

As seis entidades, os sete relacionamentos e as regras de negócio definidos na
Sprint 1/5 foram implementados integralmente. As mudanças que ocorreram foram
de nomenclatura e detalhe, não de estrutura, e estão registradas na seção 4.

---

# 4. Mudanças realizadas ao longo das Sprints

| Alteração | Sprint em que ocorreu | Justificativa |
|---|---|---|
| Chaves primárias renomeadas de `id` para `id_proprietario`, `id_cliente`, `id_imovel`, `id_corretor`, `id_visita` e `id_contrato` | 2/5 | Com sete chaves estrangeiras no projeto, nomes específicos tornam os `JOIN` legíveis e eliminam ambiguidade entre tabelas |
| Coluna `valor_condominio` acrescentada à tabela `imoveis` via `ALTER TABLE` | 2/5 | Apartamentos, kitnets e salas comerciais possuem essa cobrança, que influencia diretamente a decisão do cliente e não constava no planejamento |
| Campo `interesse` da tabela `clientes` recebeu `DEFAULT 'Compra'` | 2/5 | A maior parte dos interessados cadastrados busca compra; o padrão evita valores nulos |
| Uso de `ROUND()` nas consultas com `AVG` | 4/5 | O `AVG` do MySQL expande a precisão para seis casas decimais, inadequado para valores monetários |

Nenhuma dessas mudanças alterou as regras de negócio nem os relacionamentos
planejados.

---

# 5. Revisão da estrutura do banco

| Tabela | PK correta? | FKs corretas? | Tipos corretos? | Restrições corretas? |
|---|---|---|---|---|
| proprietarios | Sim | Não possui | Sim | Sim — `UNIQUE` em `cpf_cnpj` |
| clientes | Sim | Não possui | Sim | Sim — `UNIQUE` em `cpf`, `DEFAULT` em `interesse` |
| corretores | Sim | Não possui | Sim | Sim — `UNIQUE` em `creci` |
| imoveis | Sim | Sim (1) | Sim | Sim — `DEFAULT` em 5 campos |
| visitas | Sim | Sim (3) | Sim | Sim — `NOT NULL` nas três FKs |
| contratos | Sim | Sim (3) | Sim | Sim — `data_fim` aceita `NULL` para vendas |

---

# 6. Revisão das PRIMARY KEY

| Tabela | PRIMARY KEY | AUTO_INCREMENT? |
|---|---|---|
| proprietarios | `id_proprietario` | Sim |
| clientes | `id_cliente` | Sim |
| corretores | `id_corretor` | Sim |
| imoveis | `id_imovel` | Sim |
| visitas | `id_visita` | Sim |
| contratos | `id_contrato` | Sim |

Todas as tabelas usam identificador numérico gerado pelo banco. Mesmo onde
existe atributo naturalmente único (CPF, CNPJ, CRECI), esses campos recebem
`UNIQUE` em vez de virarem chave primária — assim as chaves estrangeiras
permanecem curtas e documentos pessoais não são usados como referência entre
tabelas.

---

# 7. Revisão das FOREIGN KEY

| Tabela | FOREIGN KEY | Tabela referenciada | Campo referenciado |
|---|---|---|---|
| imoveis | `fk_imoveis_proprietarios` | proprietarios | `id_proprietario` |
| visitas | `fk_visitas_imoveis` | imoveis | `id_imovel` |
| visitas | `fk_visitas_clientes` | clientes | `id_cliente` |
| visitas | `fk_visitas_corretores` | corretores | `id_corretor` |
| contratos | `fk_contratos_imoveis` | imoveis | `id_imovel` |
| contratos | `fk_contratos_clientes` | clientes | `id_cliente` |
| contratos | `fk_contratos_corretores` | corretores | `id_corretor` |

Todas as constraints foram nomeadas explicitamente, em vez de deixar o MySQL
gerar nomes automáticos. Isso torna as mensagens de erro compreensíveis: ao
violar uma restrição, o banco informa exatamente qual relacionamento foi
quebrado.

A ordem de criação das tabelas no `SPRINT5-5.sql` respeita as dependências:
as três tabelas independentes primeiro, depois `imoveis`, e por último as duas
tabelas associativas.

---

# 8. Revisão das restrições

| Tabela | Campo | Restrição | Regra de negócio protegida |
|---|---|---|---|
| imoveis | `id_proprietario` | `FOREIGN KEY` + `NOT NULL` | Regra 1: todo imóvel deve estar associado a um proprietário cadastrado |
| proprietarios | `cpf_cnpj` | `UNIQUE` | Regra 2: um proprietário não pode ser cadastrado duas vezes |
| clientes | `cpf` | `UNIQUE` | Regra 2: um cliente não pode ser cadastrado duas vezes |
| imoveis | `preco` | `NOT NULL` | Regra 3: um imóvel na carteira precisa ter valor definido |
| visitas | `id_imovel`, `id_cliente`, `id_corretor` | `FOREIGN KEY` + `NOT NULL` | Regra 4: toda visita exige imóvel, cliente e corretor existentes |
| contratos | `valor`, `data_inicio` | `NOT NULL` | Regra 5: todo contrato precisa de valor e data de início |
| imoveis | `disponivel` | `DEFAULT TRUE` | Regra 6: imóvel entra disponível e só sai da carteira quando negociado |
| corretores | `creci` | `UNIQUE` | Regra 7: o registro profissional é individual |

As sete regras de negócio definidas na Sprint 1/5 estão protegidas por
restrições do próprio banco, e não apenas por convenção.

---

# 9. Revisão dos dados inseridos

| Tabela | Registros |
|---|---:|
| proprietarios | 5 |
| clientes | 4 |
| corretores | 5 |
| imoveis | 8 |
| visitas | 5 |
| contratos | 3 |

`clientes` termina com 4 e `visitas` com 5 porque cada uma teve um registro
removido pelos `DELETE` da Sprint 3/5.

**Os dados são suficientes para testar o banco?**

- **Relacionamentos:** sim. Há proprietários com mais de um imóvel, clientes com
  mais de uma visita e corretores atuando em visitas e contratos.
- **Filtros:** sim. Os preços vão de R$ 950,00 a R$ 1.150.000,00, há duas
  finalidades e seis bairros distintos.
- **`GROUP BY`:** sim. Existem seis tipos de imóvel e duas finalidades.
- **`SUM`, `AVG`, `MIN`, `MAX`:** sim. As faixas de preço são bem distribuídas.
- **`HAVING`:** sim. Dois proprietários possuem dois imóveis cada e três
  possuem apenas um, o que faz o filtro sobre grupos retornar um subconjunto
  real em vez de todos ou nenhum.

---

# 10. Revisão dos INSERTs

- [x] os INSERTs executam sem erro;
- [x] respeitam as chaves estrangeiras;
- [x] não existem duplicações indevidas;
- [x] respeitam `NOT NULL`;
- [x] respeitam `UNIQUE`;
- [x] os dados fazem sentido no domínio.

| Problema | Correção realizada |
|---|---|
| Na Sprint 3/5, executar o script de INSERT duas vezes gerou registros duplicados | O `SPRINT5-5.sql` começa com `DROP DATABASE IF EXISTS`, o que garante que o script sempre parta de um banco limpo e possa ser executado quantas vezes for necessário |

---

# 11. Revisão dos UPDATEs

- [x] os UPDATEs possuem `WHERE`;
- [x] alteram os registros esperados;
- [x] não modificam toda a tabela acidentalmente;
- [x] mantêm a integridade do banco.

```sql
-- Redução de preço autorizada pelo proprietário
UPDATE imoveis
SET preco = 1150000.00
WHERE id_imovel = 3;

-- Imóvel vendido sai da carteira ativa (regra de negócio 6)
UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 7;

-- Imóvel alugado sai da carteira ativa
UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 2;

-- Cliente trocou de telefone e mudou de objetivo
UPDATE clientes
SET telefone  = '66988889999',
    interesse = 'Aluguel'
WHERE id_cliente = 1;
```

Os dois `UPDATE` de disponibilidade são os mais relevantes: sem eles, um imóvel
já negociado continuaria aparecendo nas consultas de imóveis à venda — o
problema que motivou a criação deste banco.

---

# 12. Revisão dos DELETEs

- [x] os DELETEs possuem `WHERE`;
- [x] não removem registros necessários ao funcionamento do projeto;
- [x] respeitam as dependências de `FOREIGN KEY`;
- [x] não comprometem consultas posteriores.

```sql
-- Visita cancelada; nenhuma tabela referencia visitas
DELETE FROM visitas
WHERE id_visita = 4;

-- Cliente solicitou exclusão; não possui visitas nem contratos vinculados
DELETE FROM clientes
WHERE id_cliente = 5;
```

Antes de cada exclusão verifiquei se existiam registros dependentes. O cliente 5
foi escolhido justamente por não ter vínculos — tentar excluir o cliente 2, por
exemplo, seria bloqueado pelo banco, porque ele possui visitas e contratos.

---

# 13. Revisão das consultas da Sprint 4/5

| Recurso SQL | Possui consulta válida? | Pergunta respondida |
|---|---|---|
| SELECT | Sim | Quais imóveis estão cadastrados na carteira? |
| WHERE | Sim | Quais imóveis de aluguel custam até R$ 2.000 e estão disponíveis? |
| ORDER BY | Sim | Quais são os imóveis mais caros da carteira? |
| COUNT | Sim | Quantos imóveis existem em cada tipo? |
| SUM | Sim | Qual o valor total movimentado pelos contratos? |
| AVG | Sim | Qual o preço médio dos imóveis por finalidade? |
| MIN/MAX | Sim | Qual o imóvel mais barato e o mais caro? |
| GROUP BY | Sim | Quantas visitas cada corretor realizou? |
| HAVING | Sim | Quais proprietários possuem 2 ou mais imóveis conosco? |

---

# 14. As perguntas da Sprint 1/5 foram respondidas?

## Pergunta 1

> Quais imóveis estão disponíveis para venda em um determinado bairro?

**Foi respondida?** - [x] Sim

```sql
SELECT titulo, bairro, preco
FROM imoveis
WHERE finalidade = 'Venda'
  AND bairro = 'Vila Aurora';
```

---

## Pergunta 2

> Quais imóveis de aluguel custam até um valor definido pelo cliente?

**Foi respondida?** - [x] Sim

```sql
SELECT titulo, bairro, preco, valor_condominio
FROM imoveis
WHERE finalidade = 'Aluguel'
  AND preco <= 2000.00
  AND disponivel = TRUE;
```

---

## Pergunta 3

> Quantos imóveis existem na carteira em cada tipo?

**Foi respondida?** - [x] Sim

```sql
SELECT tipo,
       COUNT(*) AS quantidade
FROM imoveis
GROUP BY tipo
ORDER BY quantidade DESC;
```

---

## Pergunta 4

> Qual é o preço médio dos imóveis por finalidade?

**Foi respondida?** - [x] Sim

```sql
SELECT finalidade,
       COUNT(*) AS quantidade,
       ROUND(AVG(preco), 2) AS preco_medio
FROM imoveis
GROUP BY finalidade;
```

---

## Pergunta 5

> Quem é o proprietário de cada imóvel da carteira?

**Foi respondida?** - [x] Sim

```sql
SELECT imoveis.titulo,
       imoveis.tipo,
       imoveis.preco,
       proprietarios.nome     AS proprietario,
       proprietarios.telefone
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
ORDER BY proprietarios.nome;
```

---

# 19. Validação com SHOW TABLES

### Resultado esperado

Quantidade de tabelas:

```text
6
```

Quantidade encontrada:

```text
6
```

- [x] corresponde ao esperado.

---

# 20. Validação com DESCRIBE

Executei `DESCRIBE` nas seis tabelas. Confirmei em cada uma:

- os tipos de dados correspondem ao planejado;
- os campos obrigatórios aparecem com `NULL = NO`;
- as chaves aparecem marcadas (`PRI` para primárias, `MUL` para estrangeiras,
  `UNI` para os campos únicos);
- os valores padrão aparecem na coluna `Default`, incluindo o `valor_condominio`
  com `0.00` e o `interesse` com `Compra`.

---

# 21. Validação com SHOW CREATE TABLE

Executei `SHOW CREATE TABLE` em `imoveis`, `visitas` e `contratos` — as três
tabelas que possuem chaves estrangeiras. Confirmei:

- as sete `FOREIGN KEY` foram criadas com os nomes de constraint definidos no
  script (`fk_imoveis_proprietarios`, `fk_visitas_clientes`, etc.);
- os tipos das colunas referenciadas são compatíveis (`INT` em ambos os lados);
- as restrições `UNIQUE` aparecem como índices únicos;
- os `DEFAULT` foram aplicados.

---

# 22. Testando a integridade referencial

### Tabela testada

```text
imoveis (FK para proprietarios)
```

### Restrição testada

```text
fk_imoveis_proprietarios — FOREIGN KEY (id_proprietario)
```

### Resultado

> A chave estrangeira foi testada nos dois sentidos.
>
> **No INSERT:** tentei cadastrar um imóvel com `id_proprietario = 999`, valor
> que não existe na tabela `proprietarios`. O banco recusou a operação — o total
> de imóveis permaneceu em 8.
>
> **No DELETE:** tentei excluir o proprietário 1, que possui dois imóveis
> cadastrados. O banco bloqueou a exclusão — o total de proprietários permaneceu
> em 5.
>
> O segundo teste é o mais relevante conceitualmente: mostra que a chave
> estrangeira não apenas impede criar um imóvel sem dono, como também impede
> apagar um dono que deixaria imóveis órfãos na base. É a integridade
> referencial funcionando nas duas direções.

Os comandos usados nesses testes estão comentados no final do `SPRINT5-5.sql`,
seção 17, documentados mas não executáveis.

---

# 23. Testando UNIQUE

### Campo testado

```text
clientes.cpf
```

### Resultado

> Tentei inserir um cliente com o CPF `567.890.123-45`, já utilizado pelo
> cliente 1. O banco recusou a inserção — o total de clientes permaneceu em 4,
> confirmando que a restrição `UNIQUE` impede o cadastro duplicado da mesma
> pessoa.

---

# 24. Testando NOT NULL

### Campo testado

```text
imoveis.preco
```

### Resultado

> Tentei cadastrar um imóvel sem informar o preço. O banco recusou a operação —
> o total de imóveis permaneceu em 8. A restrição `NOT NULL` garante a regra de
> negócio de que nenhum imóvel entra na carteira sem valor definido.

---

# 26. Consulta final mais importante

### Pergunta

> Quais imóveis de aluguel custam até R$ 2.000,00 e ainda estão disponíveis?

### SQL

```sql
SELECT titulo, bairro, preco, valor_condominio
FROM imoveis
WHERE finalidade = 'Aluguel'
  AND preco <= 2000.00
  AND disponivel = TRUE;
```

### Resultado esperado

> Apenas a kitnet mobiliada (R$ 950,00). O apartamento do Centro, que também
> custa menos de R$ 2.000,00, não aparece — ele foi alugado e está marcado como
> indisponível.

### Por que essa consulta é importante?

É a consulta que um corretor executaria várias vezes por dia, enquanto atende um
cliente ao telefone. Responde à pergunta mais comum do negócio: "o que vocês têm
para alugar dentro do meu orçamento?".

O que a torna confiável é a condição `disponivel = TRUE`. Sem ela, o corretor
ofereceria um imóvel já alugado — exatamente a falha do controle em planilha que
motivou este banco lá na Sprint 1/5. É o ponto em que o projeto resolve o
problema que se propôs a resolver.

---

# 27. Consulta final mais complexa

### Pergunta

> Quais proprietários possuem 2 ou mais imóveis conosco, e qual o valor total da
> carteira de cada um?

### SQL

```sql
SELECT proprietarios.nome AS proprietario,
       COUNT(imoveis.id_imovel) AS total_imoveis,
       SUM(imoveis.preco) AS valor_total_carteira
FROM imoveis
INNER JOIN proprietarios ON imoveis.id_proprietario = proprietarios.id_proprietario
GROUP BY proprietarios.nome
HAVING COUNT(imoveis.id_imovel) >= 2
ORDER BY valor_total_carteira DESC;
```

### Conceitos utilizados

- [x] ORDER BY
- [x] agregação
- [x] GROUP BY
- [x] HAVING
- [x] outro — `INNER JOIN`

### Explique

A consulta combina cinco recursos. O `INNER JOIN` liga as duas tabelas para
trazer o nome do proprietário, já que `imoveis` guarda apenas a chave
estrangeira. O `GROUP BY` agrupa as linhas por proprietário. `COUNT` e `SUM`
operam sobre cada grupo separadamente. O `HAVING` descarta os grupos com menos
de dois imóveis.

O ponto conceitual mais importante é por que o filtro usa `HAVING` e não
`WHERE`. A ordem de execução do SQL é:

```text
FROM → JOIN → WHERE → GROUP BY → agregação → HAVING → ORDER BY
```

O `WHERE` é avaliado **antes** do agrupamento, quando `COUNT(*)` ainda não foi
calculado. Por isso `WHERE COUNT(*) >= 2` resulta em erro de sintaxe. Resumindo:
**`WHERE` filtra linhas, `HAVING` filtra grupos.**

Comercialmente, a consulta identifica os proprietários que concentram mais
imóveis na carteira — os que merecem atendimento prioritário.

---

# 28. Registro dos testes finais

| Teste | Resultado | Correção necessária? |
|---|---|---|
| CREATE DATABASE | Banco criado sem erro | Não |
| CREATE TABLE | 6 tabelas criadas na ordem correta | Não |
| PRIMARY KEY | 6 chaves primárias com `AUTO_INCREMENT` funcionando | Não |
| FOREIGN KEY | 7 chaves estrangeiras criadas e testadas nos dois sentidos | Não |
| NOT NULL | Inserção sem preço recusada | Não |
| UNIQUE | Inserção com CPF duplicado recusada | Não |
| INSERT | 32 registros inseridos respeitando a ordem das dependências | Não |
| UPDATE | 4 operações, todas com `WHERE` | Não |
| DELETE | 2 operações, ambas com `WHERE`, sem violar dependências | Não |
| SELECT | Consultas básicas e com colunas específicas funcionando | Não |
| WHERE | Testado com `AND`, `BETWEEN`, `IN`, `LIKE` e `IS NOT NULL` | Não |
| ORDER BY | Testado com uma e com duas colunas | Não |
| GROUP BY | Testado isolado e combinado com `JOIN` | Não |
| HAVING | Filtro sobre grupos retornando subconjunto correto | Não |
| funções de agregação | `COUNT`, `SUM`, `AVG`, `MIN` e `MAX` funcionando | Não |

---

# 29. Problemas encontrados na validação final

| Problema | Causa | Solução |
|---|---|---|
| O script não podia ser executado duas vezes sem gerar erro de banco existente e dados duplicados | Os scripts das Sprints 2/5 e 3/5 eram separados e não limpavam o estado anterior | Inclusão de `DROP DATABASE IF EXISTS` no início do `SPRINT5-5.sql`, tornando o script reexecutável do zero |
| As mensagens de erro dos testes de restrição não apareciam no MySQL Workbench | A área de saída (`Output`) estava fechada na janela do programa | Verificação feita por contagem de registros antes e depois de cada teste; posteriormente o painel foi reaberto em `View → Panels` |
| Os comandos de teste eram propositalmente inválidos e não podiam permanecer no script final | Exigência do próprio enunciado | Os testes foram mantidos comentados na seção 17 do `SPRINT5-5.sql`, documentados mas não executáveis |

---

# 42. Checklist técnico final

## Banco

- [x] `CREATE DATABASE` funciona;
- [x] `USE` funciona;
- [x] todas as tabelas são criadas;
- [x] nenhuma tabela necessária está ausente.

## Estrutura

- [x] todas as tabelas possuem PK;
- [x] FKs estão corretas;
- [x] tipos de dados estão coerentes;
- [x] `NOT NULL` está coerente;
- [x] `UNIQUE` está coerente;
- [x] `DEFAULT` está coerente.

## Dados

- [x] INSERTs funcionam;
- [x] dados são coerentes;
- [x] FKs são respeitadas.

## Manipulação

- [x] UPDATEs funcionam;
- [x] UPDATEs possuem `WHERE`;
- [x] DELETEs funcionam;
- [x] DELETEs possuem `WHERE`.

## Consultas

- [x] SELECT funciona;
- [x] WHERE funciona;
- [x] ORDER BY funciona;
- [x] COUNT funciona;
- [x] SUM funciona;
- [x] AVG funciona;
- [x] MIN/MAX funcionam;
- [x] GROUP BY funciona;
- [x] HAVING funciona.

## Arquivos

- [x] `SPRINT1-5.md`;
- [x] `SPRINT2-5.md`;
- [x] `SPRINT2-5.sql`;
- [x] `SPRINT3-5.md`;
- [x] `SPRINT3-5.sql`;
- [x] `SPRINT4-5.md`;
- [x] `SPRINT4-5.sql`;
- [x] `SPRINT5-5.md`;
- [x] `SPRINT5-5.sql`.

---

# 43. Autoavaliação

## O que você considera que aprendeu melhor?

> A diferença entre `WHERE` e `HAVING`, e o motivo por trás dela. No começo
> pareciam dois filtros intercambiáveis. Entender a ordem de execução do SQL —
> que o `WHERE` roda antes do `GROUP BY`, quando a agregação ainda não existe —
> mudou a forma como leio qualquer consulta. Depois disso, montar as consultas
> da Sprint 4/5 ficou muito mais direto.

## Qual conteúdo apresentou maior dificuldade?

> O relacionamento N:N entre clientes e imóveis. Passei um tempo tentando
> resolver com uma chave estrangeira direta até entender que isso não é
> possível, e que o caminho é uma tabela associativa. A decisão seguinte também
> deu trabalho: usar chave primária própria em `visitas` e `contratos` em vez de
> chave composta, porque o mesmo cliente pode visitar o mesmo imóvel mais de uma
> vez e com chave composta o segundo registro seria recusado.

## Qual erro mais contribuiu para seu aprendizado?

> Executar o script de INSERT duas vezes na Sprint 3/5 e acabar com 12 imóveis
> em vez de 6. Foi um erro bobo, mas ensinou que um script de dados não é
> idempotente por natureza — rodar de novo não repete o resultado, acumula. Foi
> por causa desse erro que o `SPRINT5-5.sql` começa com `DROP DATABASE IF
> EXISTS`, podendo ser executado quantas vezes for necessário sempre com o mesmo
> resultado.
>
> Tive também um erro de digitação em um `UPDATE` que deixou uma aspa aberta e
> travou o terminal no prompt `'>`. Aprendi a sair com `\c` e, mais importante,
> a conferir o comando antes de apertar Enter.

## Qual parte do banco você considera mais bem implementada?

> As chaves estrangeiras. As sete foram nomeadas explicitamente, o que torna as
> mensagens de erro compreensíveis, e os testes mostraram que funcionam nos dois
> sentidos: impedem criar um imóvel sem proprietário e impedem apagar um
> proprietário que tem imóveis. É a parte do projeto em que o banco realmente
> protege os dados sozinho, sem depender de disciplina de quem digita.

## Se tivesse mais tempo, o que melhoraria?

> Três coisas. Primeira: usar `TRIGGER` para marcar automaticamente um imóvel
> como indisponível quando um contrato é fechado — hoje isso depende de um
> `UPDATE` manual, e um esquecimento recolocaria o imóvel vendido nas consultas.
> Segunda: trocar os campos `finalidade`, `tipo` e `interesse` por `ENUM`, para
> impedir variações de digitação como "venda" e "Venda". Terceira: separar o
> endereço completo em uma tabela própria, já que hoje guardo apenas bairro e
> cidade.
