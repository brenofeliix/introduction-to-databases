# CONTRATO DE ENTREGA SEMANAL

**Disciplina:** Fundamentos em Banco de Dados  
**Repositório:** `introduction-to-databases`  
**Branch base:** `main`

> Este documento deve ser utilizado como modelo para **todas as entregas semanais**.
> Cada equipe deve preencher os campos indicados antes de iniciar a implementação e atualizar a seção de resultado antes de submeter a entrega final.

---

## 1. IDENTIFICAÇÃO DA ENTREGA

- **Equipe:** `team-XX`
- **Semana / Sprint:** `XX`
- **Período da entrega:** `DD/MM/AAAA a DD/MM/AAAA`
- **Issue da semana:** `#XX`
- **Branch da equipe:** `team-XX-sprint-XX`
- **Pull Request:** `#XX`

### Integrantes

- Nome 1
- Nome 2
- Nome 3
- Nome 4

---

## 2. TAREFA DA SEMANA

### Objetivo

Descreva, em uma frase clara e objetiva, o que deverá estar funcionando ao final da semana.

> Exemplo: Criar o esquema inicial do banco de dados da equipe contendo as tabelas `cliente`, `produto` e `pedido`, com suas respectivas chaves primárias e estrangeiras.

### Está dentro do escopo

- <item 1>
- <item 2>
- <item 3>

### Está fora do escopo

- <item 1>
- <item 2>
- <item 3>

Não implemente funcionalidades adicionais apenas porque "sobrou tempo".  
Qualquer alteração fora do escopo deve ser registrada e, quando necessário, autorizada pelo professor.

---

## 3. ARQUIVOS E MÓDULOS PREVISTOS

Liste os arquivos que deverão ser criados ou modificados.

- `<caminho/arquivo-1.sql>`
- `<caminho/arquivo-2.sql>`
- `<caminho/README.md>`
- `<outro arquivo, quando aplicável>`

A equipe deve alterar somente os arquivos relacionados à sua entrega.

---

## 4. ISSUE OBRIGATÓRIA

O repositório possui **Issues habilitadas**. Cada entrega semanal deve possuir uma Issue correspondente.

### Título sugerido

```text
[team-XX][Sprint XX] Nome resumido da entrega
```

### A Issue deve conter

- objetivo da semana;
- tarefas previstas;
- critérios de aceitação;
- responsáveis;
- eventuais impedimentos ou dúvidas.

### Checklist da Issue

- [ ] Objetivo definido.
- [ ] Escopo definido.
- [ ] Responsáveis definidos.
- [ ] Critérios de aceitação definidos.
- [ ] Branch criada.
- [ ] Implementação realizada.
- [ ] Testes realizados.
- [ ] Pull Request aberto.

> A Issue deverá ser vinculada ao Pull Request. O repositório está configurado para fechar automaticamente Issues vinculadas quando o respectivo Pull Request for incorporado.

---

## 5. BRANCH DE TRABALHO

A branch padrão do repositório é:

```text
main
```

A equipe **não deve desenvolver diretamente na `main`**.

Para cada entrega semanal, utilize uma branch própria.

### Padrão

```text
team-XX-sprint-XX
```

### Exemplos

```text
team-01-sprint-01
team-01-sprint-02
team-03-sprint-04
```

Antes de iniciar uma nova entrega, certifique-se de que sua branch parte da versão atualizada da `main`.

---

## 6. COMMITS

Os commits devem representar etapas compreensíveis do trabalho.

### Evite mensagens como

```text
update
alteração
teste
final
funcionando
commit 1
commit novo
```

### Utilize mensagens descritivas

Exemplos:

```text
feat: cria tabela de clientes
feat: adiciona relacionamentos entre pedido e produto
fix: corrige chave estrangeira da tabela pedido
docs: atualiza documentação da sprint
test: adiciona consultas para validação do esquema
refactor: reorganiza script de criação das tabelas
```

### Regras

- [ ] Não realizar um único commit contendo toda a semana, quando o trabalho puder ser dividido logicamente.
- [ ] Não incluir arquivos não relacionados à tarefa.
- [ ] Não inserir senhas, tokens, credenciais ou dados sensíveis.
- [ ] Não apagar trabalho de outras equipes.
- [ ] Não modificar arquivos compartilhados sem necessidade ou autorização.

---

## 7. CRITÉRIOS DE ACEITAÇÃO

A entrega somente será considerada concluída quando todos os critérios aplicáveis estiverem atendidos.

- [ ] <critério 1>
- [ ] <critério 2>
- [ ] <critério 3>
- [ ] <critério 4>

### Exemplo para Banco de Dados

- [ ] O script executa sem erros.
- [ ] O banco de dados é criado corretamente.
- [ ] Todas as tabelas previstas são criadas.
- [ ] As chaves primárias estão definidas.
- [ ] As chaves estrangeiras funcionam corretamente.
- [ ] As restrições definidas no modelo foram implementadas.
- [ ] Os dados de teste podem ser inseridos.
- [ ] As consultas solicitadas retornam o resultado esperado.

---

## 8. TESTES E VALIDAÇÃO

### Validação mínima

Descreva como outra pessoa poderá executar e verificar a entrega.

1. Abrir o MySQL Workbench.
2. Conectar ao MySQL Server.
3. Abrir o arquivo SQL da equipe.
4. Executar o script.
5. Verificar se não existem erros.
6. Atualizar o painel `SCHEMAS`.
7. Verificar os objetos criados.
8. Executar as consultas de validação.
9. Comparar os resultados com os critérios de aceitação.

### Testes realizados pela equipe

| Teste | Resultado esperado | Resultado obtido | Status |
|---|---|---|---|
| <teste 1> | <resultado> | <resultado> | ✅ / ❌ |
| <teste 2> | <resultado> | <resultado> | ✅ / ❌ |
| <teste 3> | <resultado> | <resultado> | ✅ / ❌ |

---

## 9. PULL REQUEST

O repositório possui **Pull Requests habilitados**.

Toda entrega deve chegar à `main` por meio de Pull Request.

### Origem

```text
team-XX-sprint-XX
```

### Destino

```text
main
```

### Título

```text
[team-XX][Sprint XX] Nome resumido da entrega
```

### Exemplo

```text
[team-03][Sprint 02] Modelo relacional inicial
```

### Descrição obrigatória

O Pull Request deve informar:

- o que foi desenvolvido;
- quais arquivos foram criados ou alterados;
- como testar a entrega;
- quais critérios de aceitação foram atendidos;
- quais critérios não foram atendidos, se houver;
- pendências conhecidas;
- número da Issue relacionada.

### Vinculação com a Issue

Na descrição do PR, utilize:

```text
Closes #XX
```

Substitua `XX` pelo número da Issue correspondente.

Isso permite que a Issue vinculada seja fechada automaticamente quando o Pull Request for incorporado.

---

## 10. MERGE E REVISÃO

O repositório aceita tecnicamente:

- Merge Commit;
- Squash Merge;
- Rebase Merge.

Para as entregas da disciplina, entretanto:

> **A abertura do Pull Request faz parte da entrega. A equipe não deve contornar regras de proteção da branch `main` nem forçar alterações diretamente nela.**

Quando a revisão do professor ou do responsável for exigida, aguarde a revisão antes de considerar a entrega definitivamente incorporada.

Se forem solicitadas correções:

1. mantenha a mesma branch;
2. realize as alterações necessárias;
3. faça novos commits;
4. envie os commits para a mesma branch;
5. o Pull Request será atualizado automaticamente.

---

## 11. AÇÕES PROIBIDAS

A equipe não deve:

1. fazer alterações diretamente na `main`;
2. tentar contornar ou desabilitar regras de proteção de branch;
3. alterar arquivos de outra equipe sem autorização;
4. apagar arquivos ou código de outra equipe;
5. realizar mudanças fora do escopo sem registrar a justificativa;
6. adicionar ou remover dependências sem necessidade;
7. modificar configurações gerais do repositório;
8. alterar configurações de segurança;
9. publicar senhas, tokens, chaves ou credenciais;
10. inserir dados pessoais ou informações confidenciais no repositório público;
11. sobrescrever o histórico do trabalho de outros alunos;
12. entregar código que não tenha sido testado minimamente.

---

## 12. SEGURANÇA E REPOSITÓRIO PÚBLICO

O repositório é público.

Portanto, nunca publique:

```text
senha
password
token
API key
credenciais
dados pessoais
arquivos .env com informações reais
informações privadas de terceiros
```

Quando necessário, utilize valores fictícios nos exemplos.

---

## 13. RESULTADO DA SEMANA

Esta seção deve ser preenchida **antes da entrega final**.

### O que foi concluído?

<descreva objetivamente>

### O que ficou incompleto?

<descreva ou escreva `Nada`>

### O escopo inicial mudou?

- [ ] Não.
- [ ] Sim.

Se sim, explique:

<justificativa>

### Problemas encontrados

- <problema 1>
- <problema 2>

### Pendências para a próxima semana

- <pendência 1>
- <pendência 2>

---

## 14. CHECKLIST FINAL DA ENTREGA

### Organização

- [ ] A Issue da semana foi criada.
- [ ] O contrato da semana foi preenchido.
- [ ] A branch segue o padrão definido.
- [ ] O trabalho foi desenvolvido na branch da equipe.
- [ ] Os commits possuem mensagens compreensíveis.

### Implementação

- [ ] O escopo da semana foi atendido.
- [ ] Os arquivos necessários foram criados ou modificados.
- [ ] O projeto/script executa sem erros impeditivos.
- [ ] Os critérios de aceitação foram verificados.
- [ ] Os testes foram realizados.

### GitHub

- [ ] Nenhum trabalho foi enviado diretamente para a `main`.
- [ ] O Pull Request foi aberto.
- [ ] O destino do PR é a `main`.
- [ ] O PR possui título conforme o padrão.
- [ ] O PR descreve claramente o trabalho realizado.
- [ ] A Issue está vinculada ao PR com `Closes #XX`.
- [ ] As pendências foram informadas.

### Segurança

- [ ] Nenhuma senha foi publicada.
- [ ] Nenhum token ou chave foi publicado.
- [ ] Nenhuma informação sensível foi enviada ao repositório.
- [ ] Nenhum arquivo de outra equipe foi alterado indevidamente.

---

## 15. STATUS FINAL

Marque apenas uma opção:

- [ ] **CONCLUÍDA** — todos os critérios obrigatórios foram atendidos.
- [ ] **PARCIAL** — parte do escopo foi concluída e as pendências foram registradas.
- [ ] **NÃO CONCLUÍDA** — os critérios mínimos da semana não foram atendidos.

---

## DECLARAÇÃO DA EQUIPE

Ao realizar a entrega, a equipe declara que:

1. o conteúdo submetido corresponde ao trabalho desenvolvido durante a semana;
2. as alterações estão relacionadas ao escopo registrado;
3. os testes e validações informados foram realmente executados;
4. as pendências conhecidas foram declaradas;
5. nenhuma regra de segurança ou proteção do repositório foi intencionalmente contornada;
6. o Pull Request representa a versão que a equipe considera pronta para avaliação.
