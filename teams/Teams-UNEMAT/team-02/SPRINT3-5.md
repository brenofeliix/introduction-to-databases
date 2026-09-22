# SPRINT 3/5 — Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# Objetivo da Sprint 3/5

Nesta etapa, cada aluno deverá utilizar o banco de dados criado na `SPRINT2-5.sql` para **inserir, alterar e excluir dados** utilizando comandos DML (*Data Manipulation Language*).

Nesta Sprint serão trabalhados principalmente:

```sql
INSERT
UPDATE
DELETE
```

Ao final da atividade, o banco deverá possuir dados coerentes com o domínio escolhido na Sprint 1/5.

O aluno deverá entregar:

```text
SPRINT3-5.md
SPRINT3-5.sql
```

O arquivo `SPRINT3-5.md` documentará o trabalho realizado. O arquivo `SPRINT3-5.sql` deverá conter os comandos SQL produzidos e testados no MySQL Workbench.

> Utilize obrigatoriamente o banco e as tabelas criados na Sprint 2/5.

---

# 1. Antes de começar

1. Abra o MySQL Workbench.
2. Abra sua conexão.
3. Confirme que o banco criado na Sprint 2/5 existe.
4. Abra ou execute o `SPRINT2-5.sql`, se necessário.
5. Selecione o banco:

```sql
USE nome_do_banco;
```

6. Confira as tabelas:

```sql
DESCRIBE nome_da_tabela;
```

---

# 2. Crie o arquivo SPRINT3-5.sql

No MySQL Workbench:

```text
File → New Query Tab
```

Depois:

```text
File → Save Script As...
```

Salve exatamente como:

```text
SPRINT3-5.sql
```

Esse arquivo deverá conter os comandos DML desta Sprint.

---

# 3. INSERT — inserindo dados

Estrutura básica:

```sql
INSERT INTO nome_tabela (
    campo_1,
    campo_2,
    campo_3
)
VALUES (
    valor_1,
    valor_2,
    valor_3
);
```

Exemplo:

```sql
INSERT INTO cliente (
    nome,
    email,
    data_nascimento
)
VALUES (
    'Ana Souza',
    'ana@email.com',
    '2000-05-10'
);
```

---

# 4. Inserindo vários registros

```sql
INSERT INTO cliente (
    nome,
    email
)
VALUES
    ('Ana Souza', 'ana@email.com'),
    ('Carlos Lima', 'carlos@email.com'),
    ('Mariana Silva', 'mariana@email.com');
```

---

# 5. Quantidade mínima de dados

Procure inserir:

```text
pelo menos 5 registros em cada tabela principal
```

Exemplo:

```text
CLIENTE        → pelo menos 5 registros
PRODUTO        → pelo menos 5 registros
PEDIDO         → pelo menos 5 registros
ITEM_PEDIDO    → registros suficientes para representar os relacionamentos
```

Os dados precisam ser coerentes e úteis para as consultas da Sprint 4/5.

---

# 6. Ordem correta dos INSERTs

Quando existem `FOREIGN KEY`, insira primeiro os registros das tabelas independentes.

Exemplo:

```text
CLIENTE
   ↓
PEDIDO
   ↓
ITEM_PEDIDO
```

Ordem recomendada:

```text
1. tabelas independentes;
2. tabelas com FOREIGN KEY;
3. tabelas associativas.
```

---

# 7. Planejamento dos dados

| Tabela | Quantidade prevista | Depende de outra tabela? |
|---|---:|---|
| analistas | 5 | Não |
| dispositivos | 5 | Não |
| tipos_ameacas| 5 | Não |
| alertas| 5 | Sim (dispositivos) |
| incidentes | 5 | Sim (analistas, dispositivos, tipos_ameacas, alertas) |
| acoes_resposta | 6 | Sim (incidentes) |  

---

# 8. INSERTs realizados

## Tabela 1

**Nome:**

```text
analistas
```

```sql
--
   INSERT INTO analistas (nome, email, cargo)
   VALUES
    ('Mariana Alves',   'mariana.alves@empresa.com',   'Analista de Segurança Pleno'),
    ('Pedro Santos',    'pedro.santos@empresa.com',    'Analista de Segurança Júnior'),
    ('Juliana Costa',   'juliana.costa@empresa.com',   'Analista de Segurança Sênior'),
    ('Rafael Oliveira', 'rafael.oliveira@empresa.com', 'Coordenador de SOC'),
    ('Beatriz Lima',    'beatriz.lima@empresa.com',    'Analista de Segurança Pleno');

```

## Tabela 2

**Nome:**

```text
dispositivos
```

```sql
--
   INSERT INTO dispositivos (nome_dispositivo, tipo_dispositivo, ip_address, ativo)
   VALUES
    ('Servidor-Web-01',        'Servidor',  '192.168.1.10', TRUE),
    ('Notebook-Financeiro-03', 'Notebook',  '192.168.1.55', TRUE),
    ('Firewall-Principal',     'Firewall',  '10.0.0.1',     TRUE),
    ('Switch-Core-01',         'Switch',    '10.0.0.2',     TRUE),
    ('Servidor-BD-02',         'Servidor',  '192.168.1.20', FALSE);

```

## Tabela 3

**Nome:**

```text
tipos_ameacas
```

```sql
--
   INSERT INTO tipos_ameacas (nome_ameaca, descricao)
   VALUES
    ('Phishing',                    'Tentativa de obter dados sensíveis se passando por uma fonte confiável.'),
    ('Ransomware',                  'Software malicioso que sequestra e criptografa arquivos, exigindo resgate.'),
    ('Malware',                     'Software desenvolvido para causar danos ou obter acesso não autorizado.'),
    ('Ataque de Força Bruta',       'Tentativas repetidas de adivinhar credenciais de acesso.'),
    ('Negação de Serviço (DDoS)',   'Sobrecarga de um serviço ou rede para torná-lo indisponível.');

```

## Tabela 4

**Nome:**

```text
alertas
```

```sql
--
   INSERT INTO alertas (titulo, descricao, id_dispositivo, status)
   VALUES
    ('Tentativa de login suspeita',           '...', 1, 'ABERTO'),
    ('Tráfego anômalo detectado',              '...', 3, 'ABERTO'),
    ('Uso elevado de CPU',                     '...', 5, 'EM_ANALISE'),
    ('Múltiplas tentativas de acesso negadas', '...', 4, 'ABERTO'),
    ('Arquivo suspeito identificado',          '...', 2, 'RESOLVIDO');

```
## Tabela 5

**Nome:**

```text
incidentes
```

```sql
--
    INSERT INTO incidentes (
    titulo, descricao, severidade, status,
    id_analista, id_dispositivo, id_ameaca, id_alerta)
    VALUES
    ('Acesso não autorizado ao servidor web', '...', 'ALTA', 'ABERTO', 1, 1, 4, 1),
    ('Infecção por ransomware em notebook financeiro', '...', 'CRITICA', 'EM_ANALISE', 3, 2, 2, 5),
    ('Tentativa de phishing direcionado', '...', 'MEDIA', 'ABERTO', 2, NULL, 1, NULL),
    ('Ataque de negação de serviço ao firewall', '...', 'ALTA', 'EM_ANALISE', 4, 3, 5, 2),
    ('Comportamento anômalo no servidor de banco de dados', '...', 'BAIXA', 'ENCERRADO', 5, 5, 3, 3);

```

## Tabela 6

**Nome:**

```text
acoes_resposta
```

```sql
--
    INSERT INTO acoes_resposta (descricao, id_incidente)
    VALUES
    ('Bloqueio temporário do IP de origem do ataque.', 1),
    ('Redefinição de senha do usuário afetado.', 1),
    ('Isolamento do notebook da rede corporativa.', 2),
    ('Execução de verificação antivírus completa.', 2),
    ('Ativação de regras de mitigação de DDoS no firewall.', 4),
    ('Verificação de logs e encerramento do incidente.', 5);

```

---

# 9. AUTO_INCREMENT

Se a chave primária utiliza `AUTO_INCREMENT`, normalmente você não informa o identificador no `INSERT`.

Exemplo:

```sql
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);
```

Inserção:

```sql
INSERT INTO cliente (nome)
VALUES ('Maria');
```

---

# 10. Tipos de valores

Texto:

```sql
'João da Silva'
```

Inteiro:

```sql
10
```

Decimal:

```sql
199.90
```

Data:

```sql
'2026-09-02'
```

Booleano:

```sql
TRUE
```

ou:

```sql
FALSE
```

Ausência de valor:

```sql
NULL
```

---

# 11. Testando restrições de integridade

Agora que existem dados, teste restrições criadas na Sprint 2/5.

Exemplo:

```sql
email VARCHAR(150) UNIQUE
```

Pergunte:

- o banco impede valores duplicados?
- `NOT NULL` está funcionando?
- a `FOREIGN KEY` impede referências inexistentes?

Registre os resultados:

| Restrição testada | O que foi testado? | Resultado |
|---|---|---|
| UNIQUE (email) | Tentativa de cadastrar um novo analista com o e-mail mariana.alves@empresa.com, já existente | O MySQL recusou o comando com o erro "Duplicate entry ... for key 'email' |
| NOT NULL (titulo) | Tentativa de inserir um incidente sem informar o campo titulo | O MySQL recusou o comando com o erro "Field 'titulo' doesn't have a default value" |
| FOREIGN KEY (id_analista) | Tentativa de inserir um incidente com id_analista = 999, que não existe na tabela analistas | O MySQL recusou o comando com o erro "Cannot add or update a child row: a foreign key constraint fails" |

> Não mantenha comandos propositalmente inválidos no `SPRINT3-5.sql` final.

---

# 12. UPDATE — alterando registros

Estrutura:

```sql
UPDATE nome_tabela
SET campo = novo_valor
WHERE condicao;
```

Exemplo:

```sql
UPDATE cliente
SET email = 'novo@email.com'
WHERE id_cliente = 1;
```

---

# 13. Atenção ao WHERE no UPDATE

Este comando:

```sql
UPDATE cliente
SET ativo = FALSE;
```

pode alterar **todos os registros**.

Já:

```sql
UPDATE cliente
SET ativo = FALSE
WHERE id_cliente = 3;
```

altera somente o registro escolhido.

> Confira sempre o `WHERE` antes da execução.

---

# 14. UPDATEs obrigatórios

Execute pelo menos:

```text
3 operações UPDATE
```

## UPDATE 1

```sql
-- UPDATE dispositivos
SET ativo = TRUE
WHERE id_dispositivo = 5;

```

**O que foi alterado?**

> O Servidor-BD-02, que estava cadastrado como inativo (ativo = FALSE), foi reativado após a conclusão de uma manutenção preventiva.

## UPDATE 2

```sql
-- UPDATE incidentes
SET status = 'RESOLVIDO',
    data_encerramento = CURRENT_TIMESTAMP
WHERE id_incidente = 1;

```

**O que foi alterado?**

> O incidente 1 (acesso não autorizado ao servidor web) teve seu status alterado de ABERTO para RESOLVIDO, e a data de encerramento foi preenchida automaticamente, refletindo a conclusão das ações de resposta já registradas para esse incidente.

## UPDATE 3

```sql
-- UPDATE analistas
SET cargo = 'Analista de Segurança Sênior'
WHERE id_analista = 2;.

```

**O que foi alterado?**

> O cargo do analista Pedro Santos foi atualizado de "Analista de Segurança Júnior" para "Analista de Segurança Sênior", em razão de uma promoção.

---

# 15. DELETE — removendo registros

Estrutura:

```sql
DELETE FROM nome_tabela
WHERE condicao;
```

Exemplo:

```sql
DELETE FROM cliente
WHERE id_cliente = 5;
```

---

# 16. Atenção ao WHERE no DELETE

Este comando:

```sql
DELETE FROM cliente;
```

remove todos os registros.

Este:

```sql
DELETE FROM cliente
WHERE id_cliente = 5;
```

remove apenas o registro selecionado.

> Nunca execute `DELETE` sem conferir a condição.

---

# 17. DELETE e FOREIGN KEY

Uma exclusão pode ser impedida pela integridade referencial.

Exemplo:

```text
CLIENTE
   ↓
PEDIDO
```

Se um pedido depende de um cliente, o MySQL pode impedir:

```sql
DELETE FROM cliente
WHERE id_cliente = 1;
```

Isso pode indicar que a `FOREIGN KEY` está funcionando corretamente.

---

# 18. DELETEs obrigatórios

Execute pelo menos:

```text
2 operações DELETE
```

## DELETE 1

```sql
-- DELETE FROM alertas
   WHERE id_alerta = 4;

```

**Registro removido:**

> O alerta "Múltiplas tentativas de acesso negadas" (id_alerta = 4) foi removido por ter sido identificado como um falso positivo do monitoramento do switch. Esse alerta não estava referenciado por nenhum incidente, então a exclusão foi realizada sem conflito de FOREIGN KEY.

## DELETE 2

```sql
-- DELETE FROM acoes_resposta
   WHERE id_acao = 6;
```

**Registro removido:**

> A ação de resposta "Verificação de logs e encerramento do incidente" (id_acao = 6), vinculada ao incidente 5, foi removida por ter sido registrada em duplicidade durante a digitação inicial. Como acoes_resposta é a tabela do lado "filho" da relação com incidentes, a exclusão não afeta nenhuma outra tabela.

---

# 19. Conferindo os registros

Nesta Sprint, você pode utilizar `SELECT` apenas para verificar o estado das tabelas.

```sql
SELECT * FROM nome_tabela;
```

Antes de um `UPDATE` ou `DELETE`, é recomendável verificar o registro.

```sql
SELECT *
FROM cliente
WHERE id_cliente = 3;
```

Depois execute a alteração e consulte novamente.

---

# 20. Modelo genérico para adaptar

**Não entregue o código abaixo sem adaptação.**

```sql
USE nome_do_banco;

-- INSERTS

INSERT INTO tabela_a (
    campo_a1,
    campo_a2
)
VALUES (
    'Valor 1',
    'Valor 2'
);

INSERT INTO tabela_a (
    campo_a1,
    campo_a2
)
VALUES
    ('Valor 3', 'Valor 4'),
    ('Valor 5', 'Valor 6'),
    ('Valor 7', 'Valor 8');

INSERT INTO tabela_b (
    id_a,
    campo_b1
)
VALUES (
    1,
    'Outro valor'
);

-- VERIFICAÇÕES

SELECT * FROM tabela_a;
SELECT * FROM tabela_b;

-- UPDATES

UPDATE tabela_a
SET campo_a1 = 'Valor atualizado'
WHERE id_a = 1;

UPDATE tabela_a
SET campo_a2 = 'Outro valor'
WHERE id_a = 2;

UPDATE tabela_b
SET campo_b1 = 'Atualizado'
WHERE id_b = 1;

-- DELETES

DELETE FROM tabela_b
WHERE id_b = 3;

DELETE FROM tabela_a
WHERE id_a = 5;
```

---

# 21. Estrutura recomendada do SPRINT3-5.sql

```sql
-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno:
-- Banco:


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE nome_do_banco;


-- ============================================================
-- INSERTS — TABELA 1
-- ============================================================


-- ============================================================
-- INSERTS — TABELA 2
-- ============================================================


-- ============================================================
-- INSERTS — TABELA 3
-- ============================================================


-- ============================================================
-- INSERTS — TABELA 4
-- ============================================================


-- ============================================================
-- VERIFICAÇÕES
-- ============================================================


-- ============================================================
-- UPDATES
-- ============================================================


-- ============================================================
-- DELETES
-- ============================================================


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

```

---

# 22. Passo a passo no MySQL Workbench

## Etapa 1 — Abra o banco

No painel `Schemas`, confirme se o banco e as tabelas da Sprint 2/5 estão disponíveis.

## Etapa 2 — Selecione o banco

```sql
USE nome_do_banco;
```

## Etapa 3 — Insira dados nas tabelas independentes

Comece pelas tabelas que não possuem dependências.

## Etapa 4 — Confira os dados

```sql
SELECT * FROM nome_tabela;
```

## Etapa 5 — Insira dados nas tabelas dependentes

Respeite as `FOREIGN KEY`.

## Etapa 6 — Execute os UPDATEs

Realize pelo menos três alterações coerentes.

## Etapa 7 — Execute os DELETEs

Realize pelo menos duas exclusões seguras.

## Etapa 8 — Faça a verificação final

Confira o conteúdo das tabelas.

## Etapa 9 — Salve o arquivo

```text
File → Save Script As...
```

Nome obrigatório:

```text
SPRINT3-5.sql
```

---

# 23. Resumo dos dados

| Tabela | Quantidade aproximada de registros ao final |
|---|---:|
| analistas | 5 |
| dispositivos | 5|
| tipos_ameacas | 5 |
| alertas | 4 (5 inseridos, 1 excluído) |
| incidentes | 5 |
| acoes_resposta | 5 (6 inseridos, 1 excluído) |

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos:

```text
30 registros no total (5 + 5 + 5 + 5 + 5 + 6, entre as 6 tabelas)
```

## UPDATE

Quantidade de operações:

```text
3
```

## DELETE

Quantidade de operações:

```text
2
```

---

# 25. Problemas encontrados

| Problema | Possível causa | Solução aplicada |
|---|---|---|
|Duplicate entry ao testar UNIQUE  | E-mail repetido inserido de propósito para teste | Comando removido do script final; restrição confirmada como funcional |
| Cannot add or update a child row | id_analista inexistente inserido de propósito para teste | Comando removido do script final; FK confirmada como funcional |
| Column 'titulo' cannot be null | Tentativa de inserir incidente sem título, de propósito, para teste | Comando removido do script final; restrição NOT NULL confirmada como funcional |

Mensagens que podem aparecer:

```text
Duplicate entry
Cannot add or update a child row
Cannot delete or update a parent row
Column cannot be null
Data too long for column
Unknown column
```

---

# 26. O que deve existir ao final desta Sprint

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql
```

Não exclua arquivos das etapas anteriores.

---

# 27. Checklist da Sprint 3/5

- [x] utilizei o banco criado na Sprint 2/5;
- [x] utilizei `USE`;
- [x] inseri dados coerentes com o projeto;
- [x] respeitei a ordem das tabelas;
- [x] procurei inserir pelo menos 5 registros nas tabelas principais;
- [x] testei restrições de integridade;
- [x] executei pelo menos 3 `UPDATE`;
- [x] os `UPDATE` possuem condição adequada;
- [x] executei pelo menos 2 `DELETE`;
- [x] os `DELETE` possuem condição adequada;
- [x] verifiquei dependências de `FOREIGN KEY`;
- [x] utilizei `SELECT` para conferência;
- [x] registrei os problemas encontrados;
- [x] salvei o código como `SPRINT3-5.sql`;
- [x] preenchi completamente o `SPRINT3-5.md`;
- [x] revisei os arquivos antes do commit.

---

# 28. Regras de Git/GitHub

A atividade continua **individual**.

Utilize a mesma branch individual das Sprints anteriores.

Não crie uma branch nova.

## Arquivos obrigatórios no commit desta Sprint

```text
SPRINT3-5.md
SPRINT3-5.sql
```

Mensagem sugerida:

```text
Conclui Sprint 3 de 5 - operações DML
```

---

# 29. Pull Request

**Ainda não abra o Pull Request final.**

O PR será aberto somente após a Sprint 5/5.

```text
SPRINT1-5.md
      ↓ commit

SPRINT2-5.md + SPRINT2-5.sql
      ↓ commit

SPRINT3-5.md + SPRINT3-5.sql
      ↓ commit

SPRINT4-5.md + SPRINT4-5.sql
      ↓ commit

SPRINT5-5.md + SPRINT5-5.sql
      ↓ commit

PULL REQUEST FINAL
      ↓
main
```

---

# 30. Critério de conclusão

A Sprint 3/5 será considerada concluída quando o aluno:

1. utilizar o banco criado anteriormente;
2. popular suas tabelas;
3. respeitar os relacionamentos existentes;
4. utilizar corretamente `INSERT`;
5. realizar pelo menos 3 `UPDATE`;
6. realizar pelo menos 2 `DELETE`;
7. preservar a integridade dos dados;
8. documentar a atividade no `SPRINT3-5.md`;
9. salvar o código executável em `SPRINT3-5.sql`;
10. incluir os dois arquivos no commit.

---

# Próxima etapa

Na **Sprint 4/5**, os dados criados nesta etapa serão utilizados para consultas SQL.

Serão trabalhados:

```sql
SELECT
WHERE
ORDER BY
GROUP BY
HAVING
COUNT
SUM
AVG
MIN
MAX
```

> **Não desenvolva a Sprint 4/5 neste arquivo.**
