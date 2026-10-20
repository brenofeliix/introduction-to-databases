# SPRINT 3/5 — Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados
**Modalidade:** Atividade individual
**Aluno:** Rafael Tokashiki Souza
**Banco:** `imobiliaria`
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# 1. Antes de começar

Utilizei o banco `imobiliaria` e as seis tabelas criadas na Sprint 2/5. Nenhuma
alteração de estrutura foi feita nesta etapa — apenas manipulação de dados.

Antes de inserir, confirmei a estrutura com `DESCRIBE` e verifiquei no painel
`Schemas` que as tabelas `proprietarios`, `clientes`, `corretores`, `imoveis`,
`visitas` e `contratos` estavam disponíveis.

---

# 7. Planejamento dos dados

| Tabela | Quantidade prevista | Depende de outra tabela? |
|---|---:|---|
| proprietarios | 5 | Não — tabela independente |
| clientes | 5 | Não — tabela independente |
| corretores | 5 | Não — tabela independente |
| imoveis | 8 | Sim — depende de `proprietarios` |
| visitas | 6 | Sim — depende de `imoveis`, `clientes` e `corretores` |
| contratos | 3 | Sim — depende de `imoveis`, `clientes` e `corretores` |

---

# 8. INSERTs realizados

## Tabela 1

**Nome:**

```text
proprietarios
```

```sql
INSERT INTO proprietarios (nome, cpf_cnpj, telefone, email, cidade)
VALUES
    ('Joao Pereira da Silva',   '123.456.789-01',     '66999990001', 'joao.pereira@email.com',  'Rondonopolis'),
    ('Maria Santos Oliveira',   '234.567.890-12',     '66999990002', 'maria.santos@email.com',  'Rondonopolis'),
    ('Carlos Alberto Moraes',   '345.678.901-23',     '66999990003', 'carlos.moraes@email.com', 'Cuiaba'),
    ('Construtora Horizonte',   '12.345.678/0001-90', '66999990004', 'contato@horizonte.com',   'Rondonopolis'),
    ('Ana Lucia Ferreira',      '456.789.012-34',     '66999990005', 'ana.ferreira@email.com',  'Primavera do Leste');
```

O quarto registro é uma pessoa jurídica, por isso o campo `cpf_cnpj` recebe um
CNPJ. O tipo `VARCHAR(18)` foi escolhido justamente para comportar os dois
formatos.

## Tabela 2

**Nome:**

```text
clientes
```

```sql
INSERT INTO clientes (nome, cpf, telefone, email, interesse, data_cadastro)
VALUES
    ('Bruno Almeida Costa',    '567.890.123-45', '66988880001', 'bruno.almeida@email.com',  'Compra',  '2026-02-10'),
    ('Fernanda Ribeiro Lima',  '678.901.234-56', '66988880002', 'fernanda.lima@email.com',  'Aluguel', '2026-03-05'),
    ('Ricardo Tanaka',         '789.012.345-67', '66988880003', 'ricardo.tanaka@email.com', 'Compra',  '2026-04-18');

INSERT INTO clientes (nome, cpf, telefone, email, data_cadastro)
VALUES
    ('Juliana Prado Mendes',   '890.123.456-78', '66988880004', 'juliana.prado@email.com',  '2026-05-22');

INSERT INTO clientes (nome, cpf, telefone, email, interesse, data_cadastro)
VALUES
    ('Marcos Vinicius Souza',  '901.234.567-89', '66988880005', 'marcos.souza@email.com',   'Aluguel', '2026-06-30');
```

O registro de Juliana Prado Mendes foi inserido **sem informar o campo
`interesse`**, de propósito, para testar o `DEFAULT 'Compra'` definido na Sprint
2/5. O resultado está registrado na seção 11.

## Tabela 3

**Nome:**

```text
corretores
```

```sql
INSERT INTO corretores (nome, creci, telefone, email, data_admissao)
VALUES
    ('Paulo Henrique Dias',   'CRECI-MT 12345', '66977770001', 'paulo.dias@imobiliaria.com',       '2022-01-15'),
    ('Camila Rocha Barbosa',  'CRECI-MT 23456', '66977770002', 'camila.rocha@imobiliaria.com',     '2023-03-20'),
    ('Eduardo Nakamura',      'CRECI-MT 34567', '66977770003', 'eduardo.nakamura@imobiliaria.com', '2023-08-01'),
    ('Patricia Gomes Reis',   'CRECI-MT 45678', '66977770004', 'patricia.reis@imobiliaria.com',    '2024-02-12'),
    ('Rafael Tokashiki',      'CRECI-MT 56789', '66977770005', 'rafael.tokashiki@imobiliaria.com', '2024-07-01');
```

## Tabela 4

**Nome:**

```text
imoveis
```

```sql
INSERT INTO imoveis
    (titulo, tipo, finalidade, bairro, cidade, quartos, banheiros, vagas,
     area_m2, preco, data_cadastro, id_proprietario, valor_condominio)
VALUES
    ('Casa terrea com quintal amplo', 'Casa',        'Venda',   'Vila Aurora',          'Rondonopolis', 3, 2, 2, 180.00,  450000.00, '2026-01-10', 1,   0.00),
    ('Apartamento mobiliado centro',  'Apartamento', 'Aluguel', 'Centro',               'Rondonopolis', 2, 1, 1,  68.50,    1800.00, '2026-01-25', 1, 350.00),
    ('Sobrado alto padrao',           'Sobrado',     'Venda',   'Jardim Atlantico',     'Rondonopolis', 4, 4, 3, 320.00, 1250000.00, '2026-02-08', 2,   0.00),
    ('Kitnet mobiliada proxima UFR',  'Kitnet',      'Aluguel', 'Vila Birigui',         'Rondonopolis', 1, 1, 0,  32.00,     950.00, '2026-02-20', 2, 180.00),
    ('Terreno em condominio fechado', 'Terreno',     'Venda',   'Parque Universitario', 'Rondonopolis', 0, 0, 0, 400.00,  280000.00, '2026-03-12', 3,   0.00),
    ('Sala comercial avenida',        'Comercial',   'Aluguel', 'Centro',               'Rondonopolis', 0, 1, 1,  45.00,    2200.00, '2026-03-30', 3, 420.00),
    ('Casa nova tres quartos',        'Casa',        'Venda',   'Residencial Sao Jose', 'Rondonopolis', 3, 2, 2, 150.00,  380000.00, '2026-04-15', 4,   0.00),
    ('Apartamento dois quartos',      'Apartamento', 'Venda',   'Jardim Guanabara',     'Rondonopolis', 2, 2, 1,  75.00,  295000.00, '2026-05-02', 5, 290.00);
```

Os campos `quartos`, `banheiros` e `vagas` recebem `0` nos terrenos e na sala
comercial, coerente com o `DEFAULT 0` definido na Sprint 2/5. O campo
`valor_condominio` só recebe valor nos apartamentos, na kitnet e na sala
comercial — casas e terrenos não possuem essa cobrança.

## Tabela 5

**Nome:**

```text
visitas
```

```sql
INSERT INTO visitas (id_imovel, id_cliente, id_corretor, data_visita, observacao)
VALUES
    (1, 1, 1, '2026-03-14', 'Cliente gostou do quintal, achou o preco alto'),
    (3, 1, 1, '2026-03-21', 'Cliente considerou o imovel acima do orcamento'),
    (2, 2, 2, '2026-04-02', 'Cliente aprovou a localizacao'),
    (4, 2, 3, '2026-04-10', 'Kitnet pequena para a necessidade do cliente'),
    (7, 3, 2, '2026-05-18', 'Cliente pediu segunda visita com a familia'),
    (8, 4, 4, '2026-06-05', 'Cliente questionou o valor do condominio');
```

Esta é uma das tabelas associativas que resolvem o relacionamento N:N entre
clientes e imóveis. O cliente 1 aparece em duas visitas, a imóveis diferentes,
o que demonstra o funcionamento do relacionamento.

## Tabela 6

**Nome:**

```text
contratos
```

```sql
INSERT INTO contratos
    (id_imovel, id_cliente, id_corretor, tipo_contrato, valor, data_inicio, data_fim)
VALUES
    (7, 3, 2, 'Venda',   380000.00, '2026-05-30', NULL),
    (2, 2, 2, 'Aluguel',   1800.00, '2026-04-15', '2027-04-14'),
    (4, 2, 3, 'Aluguel',    950.00, '2026-04-25', '2027-04-24');
```

O contrato de venda recebe `NULL` em `data_fim`, porque uma venda não possui
prazo de término. Foi para permitir esse caso que o campo não recebeu
`NOT NULL` na Sprint 2/5.

---

# 9. AUTO_INCREMENT

Em nenhum `INSERT` informei o valor da chave primária. Todas as seis tabelas
usam `AUTO_INCREMENT`, então o próprio MySQL gerou os identificadores em
sequência. Isso pode ser conferido nos `SELECT` de verificação: os `id` foram
numerados de 1 em diante sem intervenção.

---

# 11. Testando restrições de integridade

Os testes foram executados em um arquivo separado, e não no `SPRINT3-5.sql`
final, seguindo a orientação de não manter comandos propositalmente inválidos
no script entregue.

A verificação foi feita por **contagem de registros antes e depois** de cada
tentativa: se o total não muda após um `INSERT`, o comando foi recusado pelo
banco; se não muda após um `DELETE`, a exclusão foi bloqueada.

| Restrição testada | O que foi testado? | Resultado |
|---|---|---|
| `UNIQUE` em `clientes.cpf` | Inserir um cliente com CPF `567.890.123-45`, já usado pelo cliente 1 | Recusado. O total de clientes permaneceu em 4, confirmando que o registro duplicado não entrou |
| `NOT NULL` em `imoveis.preco` | Inserir um imóvel sem informar o preço | Recusado. O total de imóveis permaneceu em 8 |
| `FOREIGN KEY` em `imoveis.id_proprietario` (INSERT) | Inserir um imóvel com `id_proprietario = 999`, que não existe | Recusado. O total de imóveis permaneceu em 8, confirmando que o banco impede referência a registro inexistente |
| `FOREIGN KEY` em `imoveis.id_proprietario` (DELETE) | Excluir o proprietário 1, que possui dois imóveis cadastrados | Bloqueado. O total de proprietários permaneceu em 5, confirmando a integridade referencial |
| `DEFAULT 'Compra'` em `clientes.interesse` | Inserir a cliente Juliana Prado Mendes sem informar o campo | Funcionou. O campo foi preenchido automaticamente com `Compra` |

O quarto teste é o mais relevante do ponto de vista conceitual: ele mostra que
a chave estrangeira protege os dados nos **dois sentidos**. Não apenas impede
criar um imóvel sem dono, como também impede apagar um proprietário que
deixaria imóveis órfãos na base.

---

# 14. UPDATEs obrigatórios

## UPDATE 1

```sql
UPDATE imoveis
SET preco = 1150000.00
WHERE id_imovel = 3;
```

**O que foi alterado?**

> O preço do sobrado de alto padrão caiu de R$ 1.250.000,00 para
> R$ 1.150.000,00, após o proprietário autorizar a redução para acelerar a
> venda. Antes de executar, rodei um `SELECT` no registro 3 para confirmar qual
> imóvel seria afetado.

## UPDATE 2

```sql
UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 7;
```

**O que foi alterado?**

> A casa nova de três quartos foi vendida — o contrato 1 registra essa venda.
> O campo `disponivel` passou de `TRUE` para `FALSE`, aplicando a regra de
> negócio 6 definida na Sprint 1/5: um imóvel vendido deve sair das consultas
> de imóveis disponíveis.

## UPDATE 3

```sql
UPDATE imoveis
SET disponivel = FALSE
WHERE id_imovel = 2;
```

**O que foi alterado?**

> O apartamento mobiliado do Centro foi alugado (contrato 2) e também saiu da
> carteira ativa, pela mesma regra do `UPDATE` anterior.

## UPDATE 4

```sql
UPDATE clientes
SET telefone = '66988889999',
    interesse = 'Aluguel'
WHERE id_cliente = 1;
```

**O que foi alterado?**

> O cliente Bruno Almeida Costa trocou de telefone e mudou de objetivo: passou
> a buscar locação em vez de compra. Este `UPDATE` altera dois campos no mesmo
> comando, separados por vírgula após o `SET`.

---

# 18. DELETEs obrigatórios

## DELETE 1

```sql
DELETE FROM visitas
WHERE id_visita = 4;
```

**Registro removido:**

> A visita do cliente 2 à kitnet, realizada em 10/04/2026, foi cancelada e
> retirada do histórico. Nenhuma tabela possui chave estrangeira apontando para
> `visitas`, portanto a exclusão ocorreu sem bloqueio.

## DELETE 2

```sql
DELETE FROM clientes
WHERE id_cliente = 5;
```

**Registro removido:**

> O cliente Marcos Vinicius Souza solicitou a exclusão do cadastro. Antes de
> executar, verifiquei que ele não possuía visitas nem contratos vinculados —
> por isso a exclusão foi permitida. Se tivesse algum registro dependente, o
> banco teria bloqueado a operação, como aconteceu no teste com o proprietário
> 1 registrado na seção 11.

---

# 19. Conferindo os registros

Antes de cada `UPDATE` e de cada `DELETE`, executei um `SELECT` sobre o
registro que seria afetado, e outro logo depois, para comparar o resultado.
Essa prática evita alterar ou remover a linha errada e está registrada no
`SPRINT3-5.sql`.

---

# 23. Resumo dos dados

| Tabela | Quantidade de registros ao final |
|---|---:|
| proprietarios | 5 |
| clientes | 4 |
| corretores | 5 |
| imoveis | 8 |
| visitas | 5 |
| contratos | 3 |

A tabela `clientes` termina com 4 registros porque 5 foram inseridos e 1 foi
removido pelo `DELETE 2`. A tabela `visitas` termina com 5 pelo mesmo motivo:
6 inseridas, 1 removida pelo `DELETE 1`.

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos:

```text
32 registros (5 proprietarios + 5 clientes + 5 corretores + 8 imoveis + 6 visitas + 3 contratos)
```

## UPDATE

Quantidade de operações:

```text
4
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
| As mensagens de erro dos testes não apareciam no MySQL Workbench | A área de saída (`Output`) estava fechada na janela do programa | Verificação feita por contagem de registros antes e depois de cada teste, comparando os totais para confirmar se o comando foi aceito ou recusado |
| Risco de inserir dados duplicados ao executar o script mais de uma vez | O `SPRINT3-5.sql` contém apenas `INSERT`, sem limpeza prévia | O script foi executado uma única vez sobre a estrutura criada na Sprint 2/5; caso precise repetir, é necessário executar antes o `SPRINT2-5.sql` para recriar as tabelas vazias |

---

# 26. O que deve existir ao final desta Sprint

```text
SPRINT1-5.md

SPRINT2-5.md
SPRINT2-5.sql

SPRINT3-5.md
SPRINT3-5.sql
```

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
