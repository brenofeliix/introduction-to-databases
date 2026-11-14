# SPRINT 3/5 — Views e Abstração de Consultas

**Disciplina:** Laboratório de Banco de Dados  
**Módulo:** 2  
**Modalidade:** Atividade individual  
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

# Objetivo da Sprint 3/5

Criar Views para consultas relevantes e reutilizáveis do banco `Rh_sorveteria`.

```sql
CREATE VIEW
CREATE OR REPLACE VIEW
SELECT
DROP VIEW
SHOW FULL TABLES
```

# 1. Identificação

**Nome completo:**

```text
Marcos Aurélio Bastos Stanguerlin
```

**Banco utilizado:**

```text
Rh_sorveteria
```

# 2. Consultas do projeto que merecem reutilização

| Consulta | Por que é útil? | Será transformada em VIEW? |
|---|---|---|
| Qual filial possui a maior quantidade de funcionários? | Permite comparar o número de funcionários por filial. | SIM |
| Quais funcionários não possuem expediente cadastrado? | Ajuda a identificar funcionários sem registro de expediente. | SIM |
| Quantos funcionários existem em cada filial, qual é o total de horas extras registrado e qual é o salário médio dos funcionários? | Reúne informações de funcionários, horas extras e salários por filial. | SIM |
| Quais produtos possuem menos de 40 unidades em estoque? | Ajuda a localizar produtos com estoque baixo. | NÃO |

# 3. Criando uma VIEW

Uma VIEW armazena uma consulta que pode ser chamada como uma tabela virtual.

```sql
CREATE VIEW nome_view AS
SELECT ...
FROM ...;
```

# 4. VIEW 1 — relacionamento entre tabelas

**Nome da VIEW:**

```text
vw_funcionarios_sem_expediente
```

**Pergunta que ela representa:**

```text
Quais funcionários não possuem expediente cadastrado?
```

**SQL:**

```sql
CREATE VIEW vw_funcionarios_sem_expediente AS
SELECT
    f.id_func,
    f.nome_func,
    f.id_filial
FROM FUNCIONARIO f
WHERE NOT EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
);
```

**Tabelas utilizadas:**

```text
FUNCIONARIO e EXPEDIENTE
```

**Como consultar essa VIEW?**

```sql
SELECT *
FROM vw_funcionarios_sem_expediente;
```

# 5. VIEW 2 — agregação ou resumo

**Pergunta:**

```text
Quantos funcionários existem em cada filial, qual é o total de horas extras registrado e qual é o salário médio dos funcionários?
```

```sql
CREATE VIEW vw_resumo_filiais AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    COALESCE(SUM(e.total_horas_extras), 0) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN (
    SELECT
        id_func,
        SUM(CAST(hora_extra AS DECIMAL(10,2))) AS total_horas_extras
    FROM EXPEDIENTE
    GROUP BY id_func
) e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao;
```

**Explique:**

```text
A VIEW agrupa os dados por filial. COUNT conta os funcionários, SUM soma as horas extras e AVG calcula o salário médio. A subconsulta soma as horas extras por funcionário antes do relacionamento para evitar repetir os valores quando há mais de um expediente.
```

# 6. VIEW 3 — consulta operacional do sistema

**Nome da VIEW:**

```text
vw_funcionarios_por_filial
```

```sql
CREATE VIEW vw_funcionarios_por_filial AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao;
```

**Por que essa VIEW é útil?**

```text
Permite comparar a quantidade de funcionários de cada filial. A filial com maior equipe pode ser encontrada ordenando a quantidade do maior para o menor.
```

# 7. Consultando uma VIEW

**SQL executado:**

```sql
SELECT *
FROM vw_funcionarios_por_filial
ORDER BY quantidade_funcionarios DESC;

SELECT *
FROM vw_funcionarios_por_filial
WHERE quantidade_funcionarios > 0;
```

**Resultado observado:**

```text
A primeira consulta lista as filiais da maior para a menor quantidade de funcionários. A segunda mostra apenas as filiais com pelo menos um funcionário. Os valores exatos dependem dos dados atuais do banco e devem ser conferidos no MySQL Workbench.
```

# 8. CREATE OR REPLACE VIEW

**VIEW original:**

```sql
CREATE VIEW vw_funcionarios_por_filial AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao;
```

**Nova versão:**

```sql
CREATE OR REPLACE VIEW vw_funcionarios_por_filial AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(f.id_func) > 0;
```

**O que mudou?**

```text
A nova versão mostra somente as filiais que possuem pelo menos 4 funcionário.
```

# 9. DROP VIEW — exercício controlado

**Código utilizado:**

```sql
CREATE VIEW vw_teste AS
SELECT id_produto, nome_produto
FROM PRODUTO;

DROP VIEW vw_teste;
```

**Qual a diferença entre `DROP VIEW` e `DROP TABLE`?**

```text
DROP VIEW remove uma consulta virtual. DROP TABLE remove a tabela e os dados armazenados nela.
```

# 10. Validando as Views

```sql
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
```

**Views encontradas:**

```text
vw_funcionarios_sem_expediente
vw_resumo_filiais
vw_funcionarios_por_filial
```

# 11. Teste de atualização dos dados-base

**VIEW testada:**

```text
vw_funcionarios_por_filial
```

**Alteração realizada:**

```sql
START TRANSACTION;

UPDATE FUNCIONARIO
SET id_filial = 2
WHERE id_func = 2;

SELECT *
FROM vw_funcionarios_por_filial;

ROLLBACK;
```

# 12. Validação prática obrigatória

```sql
CREATE VIEW vw_resumo_filiais AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    COALESCE(SUM(e.total_horas_extras), 0) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN (
    SELECT
        id_func,
        SUM(CAST(hora_extra AS DECIMAL(10,2))) AS total_horas_extras
    FROM EXPEDIENTE
    GROUP BY id_func
) e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao;
```

```text
1. Depende das tabelas FILIAL, FUNCIONARIO, CARGO e EXPEDIENTE.
2. Usa os relacionamentos por id_filial, id_cargo e id_func.
3. Apresenta filial, quantidade de funcionários, total de horas extras e salário médio.
4. Reúne indicadores de Recursos Humanos por filial.
5. Os resultados refletem os dados atuais das tabelas-base quando a VIEW é consultada novamente.
```

# 13. Quantidade mínima exigida

```text
3 VIEWs úteis
1 VIEW com relacionamento
1 VIEW com agregação ou resumo
1 CREATE OR REPLACE VIEW
1 teste com DROP VIEW
```

# 14. Estrutura recomendada do SPRINT3-5.sql

```text

-- View 1

CREATE VIEW vw_funcionarios_sem_expediente AS
SELECT
    f.id_func,
    f.nome_func,
    f.id_filial
FROM FUNCIONARIO f
WHERE NOT EXISTS (
    SELECT 1
    FROM EXPEDIENTE e
    WHERE e.id_func = f.id_func
);
-- Validação
SELECT *
FROM vw_funcionarios_sem_expediente;

-- View 2

CREATE VIEW vw_resumo_filiais AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    COALESCE(SUM(e.total_horas_extras), 0) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN (
    SELECT
        id_func,
        SUM(CAST(hora_extra AS DECIMAL(10,2))) AS total_horas_extras
    FROM EXPEDIENTE
    GROUP BY id_func
) e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao;

-- Validação
SELECT *
FROM vw_resumo_filiais;

-- View 3

CREATE VIEW vw_funcionarios_por_filial AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao;

-- Validação
SELECT *
FROM vw_funcionarios_por_filial;

-- https://www.youtube.com/watch?v=LuM0KFukml0


-- Replace View

CREATE OR REPLACE VIEW vw_funcionarios_por_filial AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(f.id_func) AS quantidade_funcionarios
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
GROUP BY fi.id_filial, fi.Localizacao
HAVING COUNT(f.id_func) > 3;
-- Validação
SELECT *
FROM vw_funcionarios_por_filial;

-- DROP VIEW

CREATE VIEW vw_teste AS
SELECT id_produto, nome_produto
FROM PRODUTO;

SELECT *
FROM vw_teste;

DROP VIEW vw_teste;

SELECT *
FROM vw_teste;

-- Validando as View
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

-- Teste de atualização

START TRANSACTION;

UPDATE FUNCIONARIO
SET id_filial = 2
WHERE id_func = 1;

SELECT *
FROM vw_funcionarios_por_filial;

ROLLBACK;

-- Pratica obrigatoria

CREATE OR REPLACE VIEW  vw_resumo_filiais AS
SELECT
    fi.id_filial,
    fi.Localizacao AS filial,
    COUNT(DISTINCT f.id_func) AS quantidade_funcionarios,
    COALESCE(SUM(e.total_horas_extras), 0) AS total_horas_extras,
    AVG(c.salario_base) AS salario_medio
FROM FILIAL fi
LEFT JOIN FUNCIONARIO f
    ON fi.id_filial = f.id_filial
LEFT JOIN CARGO c
    ON f.id_cargo = c.id_cargo
LEFT JOIN (
    SELECT
        id_func,
        SUM(CAST(hora_extra AS DECIMAL(10,2))) AS total_horas_extras
    FROM EXPEDIENTE
    GROUP BY id_func
) e
    ON f.id_func = e.id_func
GROUP BY fi.id_filial, fi.Localizacao;

SELECT *
FROM vw_resumo_filiais;
```

# 15. Problemas encontrados

| Problema | Causa | Solução |
|---|---|---|
|  |  |  |
|  |  |  |
|  |  |  |

# 16. Uso de LLMs

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

# 17. Checklist

- [x] utilizei o banco do projeto;
- [x] defini 3 Views úteis;
- [x] uma View usa relacionamento;
- [x] uma View usa agregação ou resumo;
- [x] incluí consultas sobre as Views;
- [x] utilizei `CREATE OR REPLACE VIEW`;
- [x] incluí um teste com `DROP VIEW`;
- [x] incluí a validação das Views;
- [x] incluí um teste de alteração em tabela-base;
- [x] identifiquei as tabelas utilizadas pelas Views;
- [x] executei e conferi os comandos no MySQL Workbench;
- [x] salvei `SPRINT3-5.md`.

# 18. Git/GitHub

**Branch:**

```text
team-04
```

**Arquivo:**

```text
Module-2/SPRINT3-5.md
```

**Commit sugerido:**

```text
Conclui Module 2 Sprint 3 de 5 - views
```

Ainda não abra o Pull Request final.

# Próxima etapa

```sql
CREATE PROCEDURE
CALL
IN
OUT
CREATE FUNCTION
RETURN
IF
ELSE
```
