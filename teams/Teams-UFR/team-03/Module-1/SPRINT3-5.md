# SPRINT 3/5 — Manipulação de Dados com DML

**Disciplina:** Laboratório de Banco de Dados
**Modalidade:** Atividade individual
**Aluno:** Gabriel Sakaizawa Campos
**Entrega desta Sprint:** `SPRINT3-5.md` + `SPRINT3-5.sql`

---

# 7. Planejamento dos dados

| Tabela | Quantidade prevista | Depende de outra tabela? |
|---|---:|---|
| cliente | 5 | Não |
| funcionario | 5 | Não |
| mesa | 5 | Não |
| produto | 5 | Não |
| pedido | 5 | Sim (cliente, mesa, funcionario) |
| item_pedido | 11 | Sim (pedido, produto) |

---

# 8. INSERTs realizados

## Tabela 1

**Nome:** cliente

```sql
INSERT INTO cliente (nome, cpf, telefone, data_cadastro)
VALUES
    ('Ana Souza',      '11122233344', '11988887777', '2026-08-20'),
    ('Carlos Lima',    '22233344455', '11977776666', '2026-08-21'),
    ('Mariana Silva',  '33344455566', '11966665555', '2026-08-22'),
    ('Pedro Santos',   '44455566677', '11955554444', '2026-08-25'),
    ('Juliana Costa',  '55566677788', '11944443333', '2026-08-28');
```

## Tabela 2

**Nome:** funcionario

```sql
INSERT INTO funcionario (nome, cargo, email, ativo)
VALUES
    ('João Pereira',    'Garçom',     'joao.pereira@sabor.com',    TRUE),
    ('Marcos Almeida',  'Garçom',     'marcos.almeida@sabor.com',  TRUE),
    ('Fernanda Dias',   'Gerente',    'fernanda.dias@sabor.com',   TRUE),
    ('Rafael Nunes',    'Garçom',     'rafael.nunes@sabor.com',    TRUE),
    ('Patrícia Rocha',  'Atendente',  'patricia.rocha@sabor.com',  TRUE);
```

## Tabela 3

**Nome:** mesa

```sql
INSERT INTO mesa (numero, capacidade, status)
VALUES
    (1, 2, 'livre'),
    (2, 4, 'livre'),
    (3, 4, 'livre'),
    (4, 6, 'livre'),
    (5, 2, 'livre');
```

## Tabela 4

**Nome:** produto

```sql
INSERT INTO produto (nome, categoria, preco)
VALUES
    ('Feijoada Completa', 'Prato principal', 45.90),
    ('Picanha na Chapa',  'Prato principal', 68.50),
    ('Refrigerante Lata', 'Bebida',           6.00),
    ('Suco Natural',      'Bebida',           8.50),
    ('Pudim de Leite',    'Sobremesa',       12.00);
```

## Tabela 5 (dependente)

**Nome:** pedido

```sql
INSERT INTO pedido (id_cliente, id_mesa, id_funcionario, data_pedido, status)
VALUES
    (1, 1, 1, '2026-09-01', 'aberto'),
    (2, 2, 2, '2026-09-01', 'aberto'),
    (1, 3, 1, '2026-09-02', 'aberto'),
    (3, 4, 4, '2026-09-02', 'aberto'),
    (4, 5, 5, '2026-09-03', 'aberto');
```

## Tabela 6 (dependente)

**Nome:** item_pedido

```sql
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES
    (1, 1, 2, 45.90),
    (1, 3, 2, 6.00),
    (2, 2, 1, 68.50),
    (2, 4, 1, 8.50),
    (3, 1, 1, 45.90),
    (3, 5, 1, 12.00),
    (4, 2, 2, 68.50),
    (4, 3, 2, 6.00),
    (5, 4, 2, 8.50),
    (5, 5, 1, 12.00),
    (1, 5, 1, 12.00);
```

---

# 11. Testando restrições de integridade

| Restrição testada | O que foi testado? | Resultado |
|---|---|---|
| cliente.cpf UNIQUE | Tentativa de inserir um cliente com CPF já existente (11122233344) | Falhou com erro "Duplicate entry" — a restrição funcionou |
| pedido.id_cliente FOREIGN KEY | Tentativa de excluir o cliente id_cliente = 1, que está referenciado nos pedidos 1 e 3 | Falhou com erro "Cannot delete or update a parent row" — a integridade referencial impediu a exclusão |

---

# 14. UPDATEs obrigatórios

## UPDATE 1

```sql
UPDATE cliente
SET telefone = '11999990000'
WHERE id_cliente = 2;
```

**O que foi alterado?** Atualização do telefone de contato do cliente Carlos Lima.

## UPDATE 2

```sql
UPDATE mesa
SET status = 'ocupada'
WHERE id_mesa = 1;
```

**O que foi alterado?** A mesa 1 passou de "livre" para "ocupada", refletindo a chegada de um cliente.

## UPDATE 3

```sql
UPDATE pedido
SET status = 'finalizado'
WHERE id_pedido = 1;
```

**O que foi alterado?** O pedido 1 foi marcado como finalizado após o atendimento ser concluído.

---

# 18. DELETEs obrigatórios

## DELETE 1

```sql
DELETE FROM item_pedido
WHERE id_item_pedido = 11;
```

**Registro removido:** item de pedido inserido por engano (Pudim de Leite duplicado no Pedido 1, que já continha Feijoada e Refrigerante).

## DELETE 2

```sql
DELETE FROM cliente
WHERE id_cliente = 5;
```

**Registro removido:** cliente Juliana Costa, que não possuía nenhum pedido vinculado, podendo ser removido com segurança sem violar a integridade referencial.

---

# 23. Resumo dos dados

| Tabela | Quantidade aproximada de registros ao final |
|---|---:|
| cliente | 4 |
| funcionario | 5 |
| mesa | 5 |
| produto | 5 |
| pedido | 5 |
| item_pedido | 10 |

---

# 24. Resumo das operações

## INSERT

Quantidade aproximada de registros inseridos: 36 (5 cliente + 5 funcionario + 5 mesa + 5 produto + 5 pedido + 11 item_pedido)

## UPDATE

Quantidade de operações: 3

## DELETE

Quantidade de operações: 2

---

# 25. Problemas encontrados

Nenhum problema identificado após a execução final. Os testes de restrição de
integridade (CPF duplicado e exclusão de cliente referenciado) se comportaram
como esperado e não geraram inconsistências no banco.

---

# 27. Checklist da Sprint 3/5

- [x] utilizei o banco criado na Sprint 2/5
- [x] utilizei `USE`
- [x] inseri dados coerentes com o projeto
- [x] respeitei a ordem das tabelas
- [x] inseri pelo menos 5 registros nas tabelas principais
- [x] testei restrições de integridade
- [x] executei pelo menos 3 `UPDATE`
- [x] os `UPDATE` possuem condição adequada
- [x] executei pelo menos 2 `DELETE`
- [x] os `DELETE` possuem condição adequada
- [x] verifiquei dependências de `FOREIGN KEY`
- [x] utilizei `SELECT` para conferência
- [x] registrei os problemas encontrados
- [x] salvei o código como `SPRINT3-5.sql`
- [x] preenchi completamente o `SPRINT3-5.md`
- [x] revisei os arquivos antes do commit