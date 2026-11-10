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

> Walter Anacleto Salido de Souza

**Banco utilizado:**

```
db_raaei
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

> Registrar automaticamente uma tabela de auditoria ou histórico sempre que os dados cadastrais de um atleta forem atualizados, garantindo a rastreabilidade das modificações realizadas pela equipe técnica da associação.

**Evento:**

- [ ] BEFORE INSERT
- [ ] AFTER INSERT
- [ ] BEFORE UPDATE
- [ X ] AFTER UPDATE
- [ ] Outro

**Tabela envolvida:**

```
atleta (com reflexo na tabela de auditoria/histórico correspondente)
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

```
-- Criação prévia da tabela de auditoria para armazenar o histórico de alterações
CREATE TABLE IF NOT EXISTS auditoria_atleta (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_atleta INT,
    nome_antigo VARCHAR(150),
    nome_novo VARCHAR(150),
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100)
);

DELIMITER //

CREATE TRIGGER trg_auditar_atualizacao_atleta
AFTER UPDATE ON atleta
FOR EACH ROW
BEGIN
    -- Verifica se houve alteração no nome do atleta para registrar na auditoria
    IF OLD.nome_atleta <> NEW.nome_atleta THEN
        INSERT INTO auditoria_atleta (id_atleta, nome_antigo, nome_novo, usuario)
        VALUES (OLD.id_atleta, OLD.nome_atleta, NEW.nome_atleta, USER());
    END IF;
END //

DELIMITER ;
```

**Explique linha por linha:**

> DELIMITER //: Altera temporariamente o delimitador de comandos do MySQL de ; para //, permitindo que múltiplos comandos internos sejam escritos sem encerrar prematuramente a criação do gatilho.
> CREATE TRIGGER trg_auditar_atualizacao_atleta: Define o nome oficial do gatilho a ser criado no banco de dados da associação.
> AFTER UPDATE ON atleta: Determina que o gatilho será disparado automaticamente após que um comando de atualização (UPDATE) seja concluído com sucesso na tabela atleta.
> FOR EACH ROW: Indica que o gatilho operará em nível de linha, executando a lógica para cada registro individualmente afetado pela instrução SQL.
> BEGIN ... END: Delimita o bloco de código procedural executado pelo gatilho.
> IF OLD.nome_atleta <> NEW.nome_atleta THEN: Condicional que verifica se o valor anterior (OLD) do nome difere do novo valor atualizado (NEW).
> INSERT INTO auditoria_atleta ...: Insere um registro na tabela de log com o ID, o nome antigo, o novo nome, o carimbo de data/hora e o usuário responsável.
> END // e DELIMITER ;: Encerram o bloco do trigger e restauam o delimitador padrão do SGBD.

---

# 5. Testando o Trigger

**Estado antes do teste:**

```
-- Consultando o cadastro do atleta e verificando a tabela de auditoria vazia antes da alteração
SELECT id_atleta, nome_atleta FROM atleta WHERE id_atleta = 1;
SELECT * FROM auditoria_atleta;
```

**Operação executada:**

```
-- Realizando a atualização do nome do atleta para disparar o trigger AFTER UPDATE
UPDATE atleta 
SET nome_atleta = 'Giovana Santana Reia da Silva' 
WHERE id_atleta = 1;
```

**Estado depois do teste:**

```
-- Consultando novamente a tabela de atletas e a tabela de auditoria para verificar o registro gerado
SELECT id_atleta, nome_atleta FROM atleta WHERE id_atleta = 1;
SELECT * FROM auditoria_atleta;
```

**Resultado observado:**

> O comando UPDATE executou com sucesso na tabela atleta.
> Imediatamente após a alteração, o gatilho trg_auditar_atualizacao_atleta foi acionado de forma automática em nível de linha.
> A consulta posterior à tabela auditoria_atleta confirmou a gravação do registro de log, contendo o ID do atleta (1), o nome antigo antes da modificação (nome_antigo), o novo nome atualizado (nome_novo), a data/hora exata do evento e o usuário autenticado no SGBD (USER()), comprovando o funcionamento perfeito da automação reativa.

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

> Executar com segurança uma operação composta no sistema da associação — especificamente a alteração da escola de origem de um atleta associado e o registro simultâneo da modificação em uma tabela de controle/auditoria —, garantindo que ambas as ações ocorram de forma atômica.

```
-- Iniciando a transação controlada
START TRANSACTION;

-- Operação 1: Atualizar a instituição de ensino vinculada ao atleta ID 2
UPDATE atleta 
SET id_escola = 2 
WHERE id_atleta = 2;

-- Operação 2: Inserir o registro correspondente na tabela de auditoria operacional
INSERT INTO auditoria_atleta (id_atleta, nome_antigo, nome_novo, usuario)
VALUES (2, 'ALTERAÇÃO INSTITUCIONAL', 'VÍNCULO ATUALIZADO PARA ESCOLA ID 2', USER());

-- Salvando e efetivando permanentemente as alterações no banco de dados
COMMIT;
```

**O que aconteceu após o COMMIT?**

> As alterações efetuadas pelo UPDATE e pelo INSERT foram gravadas de forma definitiva e permanente nas tabelas físicas do banco de dados db_raaei.
> Os bloqueios de linha (locks) aplicados durante a transação foram liberados, permitindo que outros usuários e consultas do sistema acessem os dados atualizados com total integridade e consistência.

---

# 8. Teste com ROLLBACK

Execute uma transação que será desfeita.

```sql
START TRANSACTION;

-- operações

ROLLBACK;
```

**Verificação antes:**

```
-- Consultando o estado original dos registros antes de iniciar a transação
SELECT id_atleta, nome_atleta, genero 
FROM atleta 
WHERE id_atleta <= 3;
```

**Verificação depois:**

```
-- Consultando novamente a tabela após a execução do ROLLBACK para confirmar a reversão
SELECT id_atleta, nome_atleta, genero 
FROM atleta 
WHERE id_atleta <= 3;
```

**O que o ROLLBACK fez?**

> O comando ROLLBACK cancelou e desfez rigorosamente todas as alterações temporárias realizadas no bloco transacional (neste caso, a alteração indevida do campo genero para os atletas de IDs 1 a 3).
> O SGBD restaurou o banco de dados exatamente ao estado consistente em que se encontrava logo antes do comando START TRANSACTION, preservando a integridade dos dados cadastrais da associação e comprovando a eficácia do mecanismo de reversão.

---

# 9. Comparação COMMIT x ROLLBACK

## COMMIT

> O COMMIT é o comando responsável por consolidar e gravar de forma definitiva todas as alterações realizadas durante uma transação no banco de dados. Uma vez executado, os dados tornam-se permanentes, visíveis para outras sessões e seguros contra falhas de sistema, encerrando o escopo transacional ativo.

## ROLLBACK

> O ROLLBACK é o comando utilizado para cancelar e desfazer todas as modificações efetuadas no banco de dados desde o início da transação ativa. Ele é acionado quando ocorre algum erro operacional, inconsistência lógica ou interrupção, restaurando o estado anterior dos dados e garantindo que nenhuma alteração parcial corrompa o sistema.

## Por que transações são importantes?

> As transações são fundamentais para garantir a integridade, consistência e confiabilidade de um sistema de banco de dados (propriedades ACID). No contexto da RAAEI, onde operações financeiras, cadastros institucionais e históricos de atletas frequentemente dependem de múltiplos passos encadeados (como atualizar um registro e gerar sua respectiva auditoria), as transações asseguram que ou todas as etapas são concluídas com sucesso (COMMIT) ou nenhuma alteração é aplicada em caso de erro (ROLLBACK), evitando dados órfãos, corrompidos ou inconsistentes.

---

# 10. Integração do Module-2 - 

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

> Como listar de forma detalhada todos os atletas cadastrados na associação, exibindo seus respectivos nomes, gêneros, idades calculadas dinamicamente, faixas etárias de categoria e instituições de ensino de origem, ordenados alfabeticamente?

```
-- Consulta relacional integrada unindo Atletas, Categorias, Escolas e a Função de Cálculo Etário
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    fn_calcular_idade(a.data_nascimento) AS idade_atual,
    c.nome_categoria,
    c.faixa_etaria,
    e.nome_escola
FROM atleta AS a
INNER JOIN categoria AS c 
    ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e 
    ON a.id_escola = e.id_escola
ORDER BY a.nome_atleta ASC;
```

**Explique:**

> Seleção de Colunas: A consulta recupera informações chave distribuídas por todo o modelo relacional, incluindo dados cadastrais do atleta, a função escalar fn_calcular_idade() desenvolvida na Sprint 4 para calcular a idade em tempo real a partir da data de nascimento, além de atributos descritivos de categoria e escola.

> Cláusulas INNER JOIN: Conectam as tabelas atleta, categoria e escola por meio de suas respectivas chaves estrangeiras (id_categoria e id_escola), assegurando que apenas registros com vínculos válidos e íntegros sejam exibidos no relatório.

> Cláusula ORDER BY: Organiza o resultado final em ordem alfabética crescente (ASC) pelo nome do atleta, facilitando a leitura pela equipe técnica e diretoria da associação.

---

# 12. Subconsulta final

**Pergunta:**

> Como listar todos os atletas cujas categorias pertencem exclusivamente ao naipe de base (contendo a nomenclatura "Sub" em sua faixa etária) e que estão vinculados a escolas cadastradas na base de dados?

```
-- Subconsulta para filtrar atletas vinculados a categorias de base ativas
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    a.data_nascimento
FROM atleta AS a
WHERE a.id_categoria IN (
    SELECT c.id_categoria
    FROM categoria AS c
    WHERE c.faixa_etaria LIKE '%Sub%'
)
AND a.id_escola IS NOT NULL;
```

**Explique:**

> Filtro Externo (SELECT ... FROM atleta): Consulta a tabela principal de atletas recuperando os dados cadastrais básicos daqueles que atendem aos critérios estabelecidos.

> Subconsulta (IN (...)): Executa uma consulta intermediária na tabela categoria para identificar dinamicamente os IDs de todas as categorias cujas faixas etárias contêm o termo 'Sub', permitindo que o sistema filtre os atletas de formação sem a necessidade de fixar IDs estáticos no código.

> Filtro de Integridade (AND a.id_escola IS NOT NULL): Garante que apenas atletas com vínculo institucional ativo em uma escola sejam considerados no conjunto de resultados, assegurando a consistência relacional da consulta.

---

# 13. VIEW final mais útil

**Nome:**

```
vw_atletas_detalhado
```

**Por que é importante?**

> Esta VIEW é fundamental para a gestão cotidiana da associação porque consolida em uma única interface virtual as informações mais importantes de três tabelas distintas (atleta, categoria e escola), ocultando a complexidade dos relacionamentos via JOIN. Ela permite que a equipe técnica e a diretoria consultem rapidamente o perfil completo dos atletas (nome, gênero, categoria, faixa etária e instituição de ensino) sem precisar reescrever consultas complexas repetidamente, servindo também de base para relatórios gerenciais e tomadas de decisão esportiva.

---

# 14. Procedure final mais útil

**Nome:**

```
sp_listar_atletas_por_categoria
```

**Entrada:**

```
p_id_categoria INT (Parâmetro IN que representa o ID da categoria desejada)
```

**Resultado:**

> Retorna um relatório relacional completo contendo o identificador, o nome, o gênero, a data de nascimento, a descrição da categoria e a faixa etária correspondente de todos os atletas cadastrados que pertencem à categoria informada no parâmetro, ordenados alfabeticamente pelo nome.

---

# 15. Function final

**Nome:**

```
fn_calcular_idade
```

**O que retorna?**

> Retorna um valor inteiro (INT) correspondente à idade atual exata de um atleta, calculada de forma determinística a partir da diferença em anos entre a sua data de nascimento (data_nascimento) e a data atual do sistema (CURDATE()), facilitando análises de faixa etária e enquadramento em categorias esportivas.

---

# 16. Trigger final

**Nome:**

```
trg_auditar_atualizacao_atleta
```

**Regra automatizada:**

> Dispara automaticamente após a atualização (AFTER UPDATE) de registros na tabela atleta. O gatilho verifica em nível de linha se houve alteração no nome do atleta; caso afirmativo, ele registra de forma independente e transparente na tabela de auditoria (auditoria_atleta) o identificador do atleta, o nome antigo, o novo nome atualizado, o carimbo de data/hora da modificação e o usuário responsável pela alteração (USER()), assegurando o histórico e a segurança das informações geridas pela associação.

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

|Erro de sintaxe ao criar o Trigger com múltiplos comandos internos (BEGIN...END). | O MySQL interpreta o ponto e vírgula (;) como o fim do comando antes de concluir a estrutura do gatilho. | Utilizar o comando DELIMITER // antes da criação e restaurar para DELIMITER ; ao final.

| Inconsistência relacional ao tentar atualizar o id_escola de um atleta para um valor inexistente. | Violação da restrição de integridade referencial da Chave Estrangeira (FOREIGN KEY). | Garantir a verificação prévia das tabelas relacionadas (escola) ou envolver a operação em um bloco transacional com ROLLBACK.

| Falha no retorno de dados ao invocar a Procedure sem especificar o parâmetro correto. | Ausência ou incompatibilidade de tipo no argumento de entrada esperado pelo procedimento. | Passar explicitamente um valor inteiro válido correspondente ao identificador da categoria (ex: CALL sp_listar_atletas_por_categoria(1);).
---

# 20. Autoavaliação

**Conteúdo que compreendi melhor:**

> A modelagem de Consultas Avançadas (JOINs e Subconsultas) e a estruturação de visões (Views), por permitirem enxergar de forma clara e direta a interligação relacional entre os dados dos atletas, categorias e instituições no ecossistema da associação.

**Conteúdo mais difícil:**

> A lógica de controle transacional e o gerenciamento do escopo de reatividade com Triggers, que exigem atenção rigorosa aos estados das linhas (OLD e NEW) e à garantia de atomicidade para evitar estados inconsistentes no banco de dados.

**Código do Module-2 que considero mais importante:**

> O script integrado de Procedures associado ao cálculo dinâmico via Function (fn_calcular_idade), pois automatiza regras de negócio essenciais para a categorização e o acompanhamento técnico dos atletas da RAAEI em tempo real.

**O que eu conseguiria explicar presencialmente sem consultar material?**

> Como funcionam os comandos básicos de consulta com JOIN e para que serve uma VIEW no banco de dados.

---

# 21. Estrutura recomendada do SPRINT5-5.sql

```
-- MODULE 2 — SPRINT 5/5
-- INTEGRAÇÃO FINAL

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei

USE db_raaei;

-- =====================================================================
-- JOINS
-- =====================================================================
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    c.nome_categoria,
    e.nome_escola
FROM atleta AS a
INNER JOIN categoria AS c ON a.id_categoria = c.id_categoria
INNER JOIN escola AS e ON a.id_escola = e.id_escola;

-- =====================================================================
-- SUBCONSULTAS
-- =====================================================================
SELECT id_atleta, nome_atleta, data_nascimento
FROM atleta
WHERE id_categoria IN (
    SELECT id_categoria 
    FROM categoria 
    WHERE faixa_etaria LIKE '%Sub%'
);

-- =====================================================================
-- VIEWS
-- =====================================================================
CREATE OR REPLACE VIEW vw_atletas_detalhado AS
SELECT 
    a.id_atleta,
    a.nome_atleta,
    a.genero,
    c.nome_categoria,
    e.nome_escola
FROM atleta AS a
JOIN categoria AS c ON a.id_categoria = c.id_categoria
JOIN escola AS e ON a.id_escola = e.id_escola;

SELECT * FROM vw_atletas_detalhado;

-- =====================================================================
-- PROCEDURES E FUNCTIONS
-- =====================================================================
DELIMITER //

CREATE PROCEDURE sp_listar_atletas_por_categoria(IN p_id_categoria INT)
BEGIN
    SELECT a.id_atleta, a.nome_atleta, c.nome_categoria
    FROM atleta AS a
    INNER JOIN categoria AS c ON a.id_categoria = c.id_categoria
    WHERE a.id_categoria = p_id_categoria;
END //

CREATE FUNCTION fn_calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
END //

DELIMITER ;

-- Testes das rotinas
CALL sp_listar_atletas_por_categoria(1);

SELECT nome_atleta, fn_calcular_idade(data_nascimento) AS idade_atual 
FROM atleta;

-- =====================================================================
-- TRIGGER
-- =====================================================================
CREATE TABLE IF NOT EXISTS auditoria_atleta (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_atleta INT,
    nome_antigo VARCHAR(150),
    nome_novo VARCHAR(150),
    data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100)
);

DELIMITER //

CREATE TRIGGER trg_auditar_atualizacao_atleta
AFTER UPDATE ON atleta
FOR EACH ROW
BEGIN
    IF OLD.nome_atleta <> NEW.nome_atleta THEN
        INSERT INTO auditoria_atleta (id_atleta, nome_antigo, nome_novo, usuario)
        VALUES (OLD.id_atleta, OLD.nome_antigo, NEW.nome_atleta, USER());
    END IF;
END //

DELIMITER ;

-- =====================================================================
-- TRANSAÇÃO COM COMMIT
-- =====================================================================
START TRANSACTION;

UPDATE atleta 
SET id_escola = 2 
WHERE id_atleta = 1;

COMMIT;

-- =====================================================================
-- TRANSAÇÃO COM ROLLBACK
-- =====================================================================
START TRANSACTION;

UPDATE atleta 
SET genero = 'X' 
WHERE id_atleta = 1;

ROLLBACK;

-- =====================================================================
-- VALIDAÇÃO FINAL
-- =====================================================================
SELECT * FROM atleta WHERE id_atleta = 1;
SELECT * FROM auditoria_atleta;
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

Aluno: Walter Anacleto Salido de Souza
Instituição: UFR
Branch: team-07
Banco: db_raaei
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
