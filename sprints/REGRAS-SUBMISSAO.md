# Regras de Submissão — Modules, Branch, Commits e Pull Request

**Disciplina:** Laboratório de Banco de Dados

Estas regras organizam as entregas da disciplina por módulos:

```text
Module-1
Module-2
Module-3
```

Cada módulo possui suas próprias Sprints e seu próprio Pull Request final.

---

# 1. Estrutura do repositório

Cada aluno continuará utilizando seu diretório individual:

```text
teams/
└── Teams-UNEMAT/
    └── team-XX/
        ├── Module-1/
        ├── Module-2/
        └── Module-3/
```

ou, para a UFR:

```text
teams/
└── Teams-UFR/
    └── team-XX/
        ├── Module-1/
        ├── Module-2/
        └── Module-3/
```

Substitua `XX` pelo número definido para o aluno.

Exemplo:

```text
teams/Teams-UNEMAT/team-08/Module-2/
```

## Regra importante

Cada módulo deve permanecer separado.

Não coloque arquivos do `Module-2` dentro do `Module-1`.

Não mova, apague ou modifique arquivos de outro aluno.

---

# 2. Branch

Cada aluno deverá utilizar a mesma branch individual durante a disciplina.

Padrão obrigatório:

```text
team-XX
```

Exemplos:

```text
team-01
team-02
team-09
team-15
```

## Regras

- não desenvolver diretamente na `main`;
- não criar uma branch diferente para cada Sprint;
- não criar uma nova branch para cada Module;
- utilizar sempre a branch `team-XX` atribuída ao aluno;
- não alterar arquivos de outro `team-XX`;
- não alterar arquivos da outra instituição;
- não alterar arquivos administrativos do repositório.

---

# 3. Antes de iniciar um novo Module

Depois que o Pull Request do módulo anterior for aceito e integrado à `main`, atualize sua branch antes de iniciar o próximo módulo.

O objetivo é garantir que sua branch contenha a versão atual do repositório.

Se estiver trabalhando pelo GitHub Desktop ou Git, sincronize sua branch com a `main` antes de começar.

Não recrie a branch.

---

# 4. Module-1 — N1

O `Module-1` representa:

```text
Planejamento
DDL
DML
Consultas SQL
Integração e validação
```

## Arquivos esperados

```text
Module-1/
├── SPRINT1-5.md
├── SPRINT2-5.md
├── SPRINT2-5.sql
├── SPRINT3-5.md
├── SPRINT3-5.sql
├── SPRINT4-5.md
├── SPRINT4-5.sql
├── SPRINT5-5.md
└── SPRINT5-5.sql
```

Total:

```text
9 arquivos
```

---

# 5. Module-2 — N2

O `Module-2` representa:

```text
JOINs
Subconsultas
Views
Stored Procedures e Functions
Triggers e Transações
```

## Arquivos esperados

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

Total:

```text
10 arquivos
```

---

# 6. Module-3 — N3

A pasta deverá permanecer reservada para a terceira etapa da disciplina:

```text
Module-3/
```

As regras específicas de arquivos, Sprints e validação do `Module-3` serão disponibilizadas pelo professor antes do início dessa etapa.

> O workflow atual valida automaticamente `Module-1` e `Module-2`. O `Module-3` será incorporado quando seus requisitos forem definidos.

---

# 7. Commits

Cada Sprint deverá possuir pelo menos um commit próprio.

Ao final de cada módulo, o Pull Request deverá possuir no mínimo:

```text
5 commits
```

## Module-1

Padrão recomendado:

```text
Conclui Module 1 Sprint 1 de 5 - planejamento do banco
Conclui Module 1 Sprint 2 de 5 - estrutura DDL
Conclui Module 1 Sprint 3 de 5 - operações DML
Conclui Module 1 Sprint 4 de 5 - consultas SQL
Conclui Module 1 Sprint 5 de 5 - validação final
```

## Module-2

Padrão recomendado:

```text
Conclui Module 2 Sprint 1 de 5 - JOINs
Conclui Module 2 Sprint 2 de 5 - subconsultas
Conclui Module 2 Sprint 3 de 5 - views
Conclui Module 2 Sprint 4 de 5 - procedures e functions
Conclui Module 2 Sprint 5 de 5 - triggers e transacoes
```

## Regras

- não deixar todos os commits para o último dia;
- cada commit deverá representar trabalho real da Sprint correspondente;
- não apagar arquivos das Sprints anteriores;
- manter os arquivos do módulo anterior;
- continuar utilizando `team-XX`;
- não utilizar commits artificiais apenas para atingir a quantidade mínima.

---

# 8. Pull Request

Cada módulo terá um Pull Request final próprio.

O PR deverá ser aberto somente depois da Sprint 5/5 do módulo correspondente.

Destino obrigatório:

```text
main
```

Origem:

```text
team-XX
```

---

# 9. Título do Pull Request — Module-1

## UNEMAT

```text
[N1][UNEMAT][Team XX] Sprints 1-5 - Nome do Banco
```

## UFR

```text
[N1][UFR][Team XX] Sprints 1-5 - Nome do Banco
```

Exemplo:

```text
[N1][UNEMAT][Team 09] Sprints 1-5 - Sistema de Biblioteca
```

---

# 10. Título do Pull Request — Module-2

## UNEMAT

```text
[N2][UNEMAT][Team XX] Sprints 1-5 - Nome do Banco
```

## UFR

```text
[N2][UFR][Team XX] Sprints 1-5 - Nome do Banco
```

Exemplo:

```text
[N2][UNEMAT][Team 09] Sprints 1-5 - Sistema de Biblioteca
```

## Atenção

O número de `Team` no título deve ser o mesmo da branch.

Exemplo:

```text
branch: team-09
```

deve utilizar:

```text
[Team 09]
```

---

# 11. Descrição do Pull Request — Module-1

```text
## Identificação

Aluno: NOME COMPLETO
Instituição: UNEMAT ou UFR
Branch: team-XX
Banco desenvolvido: NOME DO BANCO
Module: 1

## Arquivos entregues

- Module-1/SPRINT1-5.md
- Module-1/SPRINT2-5.md
- Module-1/SPRINT2-5.sql
- Module-1/SPRINT3-5.md
- Module-1/SPRINT3-5.sql
- Module-1/SPRINT4-5.md
- Module-1/SPRINT4-5.sql
- Module-1/SPRINT5-5.md
- Module-1/SPRINT5-5.sql

## Validação

- [x] Banco testado no MySQL Workbench
- [x] Arquivos revisados
- [x] Scripts SQL executados
- [x] Projeto final validado
```

---

# 12. Descrição do Pull Request — Module-2

```text
## Identificação

Aluno: NOME COMPLETO
Instituição: UNEMAT ou UFR
Branch: team-XX
Banco desenvolvido: NOME DO BANCO
Module: 2

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
- [x] Código compreendido e validado no MySQL Workbench
```

---

# 13. GitHub Actions

Depois de abrir o Pull Request, aguarde a validação automática.

Se aparecer:

```text
Successful
```

a validação automática foi concluída.

Se aparecer:

```text
Failed
```

abra o job `validate-pr`, localize a etapa que falhou e leia a mensagem.

Depois:

1. corrija o arquivo na mesma branch `team-XX`;
2. faça um novo commit;
3. faça o push;
4. aguarde a nova execução automática.

## Não abra outro Pull Request

O mesmo PR é atualizado automaticamente quando novos commits são enviados para a mesma branch.

---

# 14. O que o GitHub Actions valida

A validação automática verifica, entre outros pontos:

- formato da branch;
- instituição;
- número do Team;
- Module informado pelo título do PR;
- diretório correto;
- arquivos obrigatórios;
- arquivos vazios;
- preenchimento dos `.md`;
- presença mínima dos comandos SQL exigidos;
- mínimo de cinco commits;
- ausência de arquivos alterados fora da pasta permitida.

> O GitHub Actions verifica requisitos estruturais mínimos. Uma validação `Successful` não significa automaticamente que o SQL está conceitualmente correto. O professor poderá revisar e solicitar demonstração prática do código.

---

# 15. Validação prática presencial

O aluno deverá compreender o código entregue.

O professor poderá selecionar qualquer parte do projeto para:

```text
EXECUTAR
EXPLICAR
ALTERAR
TESTAR
CORRIGIR
```

O aluno poderá ser solicitado a:

- alterar um filtro;
- explicar PK e FK;
- modificar um JOIN;
- alterar uma subconsulta;
- executar uma View;
- trocar parâmetros de uma Procedure;
- executar uma Function;
- demonstrar um Trigger;
- demonstrar `COMMIT`;
- demonstrar `ROLLBACK`;
- interpretar uma mensagem de erro.

O uso de LLMs como apoio não substitui a compreensão do código.

---

# 16. Uso de LLMs

Quando utilizadas, as sugestões de uma LLM deverão seguir:

```text
COMPREENDER
→ ADAPTAR
→ EXECUTAR
→ TESTAR
→ VALIDAR
```

Não entregue código que você não consiga explicar ou executar.

---

# 17. Arquivos não permitidos

O aluno não deverá modificar:

```text
.github/
README administrativo
workflows
arquivos de outro team
arquivos da outra instituição
arquivos fora do seu Module atual
```

Caso o GitHub Actions indique:

```text
Arquivo não permitido
```

verifique se algum arquivo foi criado fora do caminho esperado.

---

# 18. Exemplos de caminhos válidos

## Module-1

```text
teams/Teams-UNEMAT/team-08/Module-1/SPRINT3-5.sql
```

## Module-2

```text
teams/Teams-UNEMAT/team-08/Module-2/SPRINT3-5.sql
```

## UFR

```text
teams/Teams-UFR/team-08/Module-2/SPRINT3-5.sql
```

---

# 19. Fluxo do Module-1

```text
team-XX
   ↓
Module-1/SPRINT 1 → COMMIT
   ↓
Module-1/SPRINT 2 → COMMIT
   ↓
Module-1/SPRINT 3 → COMMIT
   ↓
Module-1/SPRINT 4 → COMMIT
   ↓
Module-1/SPRINT 5 → COMMIT
   ↓
PR [N1] → main
   ↓
GitHub Actions
   ↓
Correções, se necessário
   ↓
Entrega N1
```

---

# 20. Fluxo do Module-2

```text
ATUALIZAR team-XX COM A main
   ↓
Module-2/SPRINT 1 → COMMIT
   ↓
Module-2/SPRINT 2 → COMMIT
   ↓
Module-2/SPRINT 3 → COMMIT
   ↓
Module-2/SPRINT 4 → COMMIT
   ↓
Module-2/SPRINT 5 → COMMIT
   ↓
PR [N2] → main
   ↓
GitHub Actions
   ↓
Correções, se necessário
   ↓
Entrega N2
```

---

# 21. Resumo

## Module-1

```text
1 branch team-XX
+ 5 Sprints
+ mínimo de 5 commits no PR
+ 9 arquivos em Module-1
+ 1 Pull Request [N1]
```

## Module-2

```text
mesma branch team-XX
+ 5 Sprints
+ mínimo de 5 commits no PR
+ 10 arquivos em Module-2
+ 1 Pull Request [N2]
```

Regra principal:

```text
UM ALUNO
→ UMA BRANCH team-XX
→ UM DIRETÓRIO POR MODULE
→ UM COMMIT POR SPRINT
→ UM PR FINAL POR MODULE
```
