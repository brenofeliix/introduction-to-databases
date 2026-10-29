-- ============================================================
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS (DML)
-- PROJETO: Gestão de Atletas e Colaboradores da RAAEI
-- AUTOR: Walter Anacleto Salido de Souza
-- ============================================================

USE db_raaei;

-- ------------------------------------------------------------
-- 1. INSERÇÃO DE DADOS NAS TABELAS INDEPENDENTES
-- ------------------------------------------------------------

-- Inserindo Escolas parceiras (pelo menos 5 registros)
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) VALUES
('E. E. Dom Aquino Corrêa', 'Pública', 'Centro', 'Rondonópolis'),
('E. M. Profªicelina G. Carvalho', 'Pública', 'Vila Operária', 'Rondonópolis'),
('E. E. Adventista de Rondonópolis', 'Privada', 'Jardim Atlântico', 'Rondonópolis'),
('E. E. Antonio Guimarães Balbino', 'Pública', 'Sagrada Família', 'Rondonópolis'),
('E. M. Albano Soares Ferreira', 'Pública', 'Jardim das Flores', 'Rondonópolis');

-- Inserindo Categorias de Atletismo (pelo menos 5 registros)
INSERT INTO categoria (nome_categoria, idade_minima, idade_maxima, genero_categoria) VALUES
('Sub-14 Misto', 12, 13, 'Misto'),
('Sub-16 Masculino', 14, 15, 'Masculino'),
('Sub-16 Feminino', 14, 15, 'Feminino'),
('Sub-18 Masculino', 16, 17, 'Masculino'),
('Sub-18 Feminino', 16, 17, 'Feminino');

-- Inserindo Colaboradores e Diretoria (pelo menos 5 registros)
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) VALUES
('Walter Anacleto Salido de Souza', '11122233344', 'Presidente / Treinador', '(66) 99911-2233', '2026-01-15'),
('Vanessa Salido', '22233344455', 'Primeira Tesoureira', '(66) 99922-3344', '2026-01-15'),
('Carlos Eduardo Mendes', '33344455666', 'Treinador de Saltos', '(66) 99933-4455', '2026-02-10'),
('Ana Paula Silveira', '44455667788', 'Professora de Apoio / Base', '(66) 99944-5566', '2026-02-15'),
('Marcos Vinícius Rocha', '55566778899', 'Preparador Físico', '(66) 99955-6677', '2026-03-01');

-- ------------------------------------------------------------
-- 2. INSERÇÃO DE DADOS NA TABELA DEPENDENTE (ATLETA)
-- ------------------------------------------------------------

-- Inserindo Atletas vinculados às Escolas e Categorias (pelo menos 5 registros)
INSERT INTO atleta (nome_completo, cpf, data_nascimento, nome_mae, nome_pai, endereco, id_escola, id_categoria, observacoes_medicas) VALUES
('Gabriel Santos Silva', '66677788899', '2012-04-12', 'Maria Santos Silva', 'João Silva', 'Rua das Flores, 123, Centro', 1, 1, 'Nenhuma restrição médica.'),
('Beatriz Lima Souza', '77788899900', '2010-08-22', 'Ana Lima Souza', 'Carlos Souza', 'Av. dos Estados, 456, Vila Operária', 2, 3, 'Alergia leve a poeira.'),
('Lucas Gabriel Pereira', '88899900011', '2011-01-15', 'Juliana Pereira', 'Marcos Pereira', 'Rua 7, 789, Jardim Atlântico', 3, 2, 'Usa óculos para esporte.'),
('Larissa Vitória Martins', '99900011122', '2009-09-30', 'Fernanda Martins', 'Roberto Martins', 'Rua dos Girassóis, 321, Sagrada Família', 4, 5, 'Sem restrições.'),
('Matheus Henrique Costa', '00011122233', '2009-05-18', 'Sandra Costa', 'Paulo Costa', 'Av. Brasil, 654, Jardim das Flores', 5, 4, 'Acompanhamento ortopédico de rotina.');

-- Atualizando o telefone de contato de um colaborador na tabela colaborador
UPDATE colaborador
SET telefone = '(66) 99988-7766'
WHERE id_colaborador = 2;

-- Atualizando as observações médicas de um atleta na tabela atleta
UPDATE atleta
SET observacoes_medicas = 'Alergia leve a poeira. Uso contínuo de antialérgico sob prescrição.'
WHERE id_atleta = 2;

-- Atualizando a faixa etária de uma categoria de atletismo na tabela categoria
UPDATE categoria
SET idade_maxima = 16
WHERE id_categoria = 3;

-- Criando e removendo um registro temporário para demonstração de exclusão segura
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) 
VALUES ('Escola Teste Temporária', 'Pública', 'Teste', 'Rondonópolis');

-- Removendo o registro temporário criado
DELETE FROM escola
WHERE nome_escola = 'Escola Teste Temporária';

-- Removendo um registro de colaborador inativo ou de teste na tabela colaborador
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) 
VALUES ('Colaborador Temporário', '99988877766', 'Apoio Eventual', '(66) 99900-1122', '2026-03-05');

DELETE FROM colaborador
WHERE cpf = '99988877766';


-- ============================================================
-- SPRINT 3/5 — MANIPULAÇÃO DE DADOS (DML)
-- PROJETO: Gestão de Atletas e Colaboradores da RAAEI
-- AUTOR: Walter Anacleto Salido de Souza
-- ============================================================

USE db_raaei;

-- ------------------------------------------------------------
-- 1. INSERÇÃO DE DADOS (DML - INSERT)
-- ------------------------------------------------------------

-- Inserindo Escolas parceiras (Tabela independente)
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) VALUES
('E. E. Dom Aquino Corrêa', 'Pública', 'Centro', 'Rondonópolis'),
('E. M. Profª Icelina G. Carvalho', 'Pública', 'Vila Operária', 'Rondonópolis'),
('E. E. Adventista de Rondonópolis', 'Privada', 'Jardim Atlântico', 'Rondonópolis'),
('E. E. Antonio Guimarães Balbino', 'Pública', 'Sagrada Família', 'Rondonópolis'),
('E. M. Albano Soares Ferreira', 'Pública', 'Jardim das Flores', 'Rondonópolis');

-- Inserindo Categorias de Atletismo (Tabela independente)
INSERT INTO categoria (nome_categoria, idade_minima, idade_maxima, genero_categoria) VALUES
('Sub-14 Misto', 12, 13, 'Misto'),
('Sub-16 Masculino', 14, 15, 'Masculino'),
('Sub-16 Feminino', 14, 15, 'Feminino'),
('Sub-18 Masculino', 16, 17, 'Masculino'),
('Sub-18 Feminino', 16, 17, 'Feminino');

-- Inserindo Colaboradores e Diretoria (Tabela independente)
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) VALUES
('Walter Anacleto Salido de Souza', '11122233344', 'Presidente / Treinador', '(66) 99911-2233', '2026-01-15'),
('Vanessa Salido', '22233344455', 'Primeira Tesoureira', '(66) 99922-3344', '2026-01-15'),
('Carlos Eduardo Mendes', '33344455666', 'Treinador de Saltos', '(66) 99933-4455', '2026-02-10'),
('Ana Paula Silveira', '44455667788', 'Professora de Apoio / Base', '(66) 99944-5566', '2026-02-15'),
('Marcos Vinícius Rocha', '55566778899', 'Preparador Físico', '(66) 99955-6677', '2026-03-01');

-- Inserindo Atletas vinculados às Escolas e Categorias (Tabela dependente)
INSERT INTO atleta (nome_completo, cpf, data_nascimento, nome_mae, nome_pai, endereco, id_escola, id_categoria, observacoes_medicas) VALUES
('Gabriel Santos Silva', '66677788899', '2012-04-12', 'Maria Santos Silva', 'João Silva', 'Rua das Flores, 123, Centro', 1, 1, 'Nenhuma restrição médica.'),
('Beatriz Lima Souza', '77788899900', '2010-08-22', 'Ana Lima Souza', 'Carlos Souza', 'Av. dos Estados, 456, Vila Operária', 2, 3, 'Alergia leve a poeira.'),
('Lucas Gabriel Pereira', '88899900011', '2011-01-15', 'Juliana Pereira', 'Marcos Pereira', 'Rua 7, 789, Jardim Atlântico', 3, 2, 'Usa óculos para esporte.'),
('Larissa Vitória Martins', '99900011122', '2009-09-30', 'Fernanda Martins', 'Roberto Martins', 'Rua dos Girassóis, 321, Sagrada Família', 4, 5, 'Sem restrições.'),
('Matheus Henrique Costa', '00011122233', '2009-05-18', 'Sandra Costa', 'Paulo Costa', 'Av. Brasil, 654, Jardim das Flores', 5, 4, 'Acompanhamento ortopédico de rotina.');

-- ------------------------------------------------------------
-- 2. VERIFICAÇÃO INICIAL DOS DADOS (SELECT)
-- ------------------------------------------------------------
SELECT * FROM escola;
SELECT * FROM categoria;
SELECT * FROM colaborador;
SELECT * FROM atleta;

-- ------------------------------------------------------------
-- 3. ATUALIZAÇÃO DE DADOS (DML - UPDATE)
-- ------------------------------------------------------------

-- UPDATE 1: Atualizando o telefone de contato de um colaborador
UPDATE colaborador
SET telefone = '(66) 99988-7766'
WHERE id_colaborador = 2;

-- UPDATE 2: Atualizando as observações médicas de um atleta
UPDATE atleta
SET observacoes_medicas = 'Alergia leve a poeira. Uso contínuo de antialérgico sob prescrição.'
WHERE id_atleta = 2;

-- UPDATE 3: Atualizando a idade máxima de uma categoria de atletismo
UPDATE categoria
SET idade_maxima = 16
WHERE id_categoria = 3;

-- ------------------------------------------------------------
-- 4. REMOÇÃO DE DADOS (DML - DELETE)
-- ------------------------------------------------------------

-- Inserindo e removendo um registro temporário para demonstração segura de exclusão
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) 
VALUES ('Escola Teste Temporária', 'Pública', 'Teste', 'Rondonópolis');

DELETE FROM escola
WHERE nome_escola = 'Escola Teste Temporária';

-- Inserindo e removendo um colaborador temporário para teste de exclusão
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) 
VALUES ('Colaborador Temporário', '99988877766', 'Apoio Eventual', '(66) 99900-1122', '2026-03-05');

DELETE FROM colaborador
WHERE cpf = '99988877766';

-- ------------------------------------------------------------
-- 5. VERIFICAÇÃO FINAL DOS DADOS (SELECT)
-- ------------------------------------------------------------
SELECT * FROM colaborador;
SELECT * FROM atleta;
SELECT * FROM categoria;
SELECT * FROM escola;


-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================

-- Aluno: Walter Anacleto Salido de Souza
-- Banco: db_raaei


-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================

USE db_raaei;


-- ============================================================
-- INSERTS — TABELA 1 (escola)
-- ============================================================

INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) VALUES
('E. E. Dom Aquino Corrêa', 'Pública', 'Centro', 'Rondonópolis'),
('E. M. Profª Icelina G. Carvalho', 'Pública', 'Vila Operária', 'Rondonópolis'),
('E. E. Adventista de Rondonópolis', 'Privada', 'Jardim Atlântico', 'Rondonópolis'),
('E. E. Antonio Guimarães Balbino', 'Pública', 'Sagrada Família', 'Rondonópolis'),
('E. M. Albano Soares Ferreira', 'Pública', 'Jardim das Flores', 'Rondonópolis');


-- ============================================================
-- INSERTS — TABELA 2 (categoria)
-- ============================================================

INSERT INTO categoria (nome_categoria, idade_minima, idade_maxima, genero_categoria) VALUES
('Sub-14 Misto', 12, 13, 'Misto'),
('Sub-16 Masculino', 14, 15, 'Masculino'),
('Sub-16 Feminino', 14, 15, 'Feminino'),
('Sub-18 Masculino', 16, 17, 'Masculino'),
('Sub-18 Feminino', 16, 17, 'Feminino');


-- ============================================================
-- INSERTS — TABELA 3 (colaborador)
-- ============================================================

INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) VALUES
('Walter Anacleto Salido de Souza', '11122233344', 'Presidente / Treinador', '(66) 99911-2233', '2026-01-15'),
('Vanessa Salido', '22233344455', 'Primeira Tesoureira', '(66) 99922-3344', '2026-01-15'),
('Carlos Eduardo Mendes', '33344455666', 'Treinador de Saltos', '(66) 99933-4455', '2026-02-10'),
('Ana Paula Silveira', '44455667788', 'Professora de Apoio / Base', '(66) 99944-5566', '2026-02-15'),
('Marcos Vinícius Rocha', '55566778899', 'Preparador Físico', '(66) 99955-6677', '2026-03-01');


-- ============================================================
-- INSERTS — TABELA 4 (atleta)
-- ============================================================

INSERT INTO atleta (nome_completo, cpf, data_nascimento, nome_mae, nome_pai, endereco, id_escola, id_categoria, observacoes_medicas) VALUES
('Gabriel Santos Silva', '66677788899', '2012-04-12', 'Maria Santos Silva', 'João Silva', 'Rua das Flores, 123, Centro', 1, 1, 'Nenhuma restrição médica.'),
('Beatriz Lima Souza', '77788899900', '2010-08-22', 'Ana Lima Souza', 'Carlos Souza', 'Av. dos Estados, 456, Vila Operária', 2, 3, 'Alergia leve a poeira.'),
('Lucas Gabriel Pereira', '88899900011', '2011-01-15', 'Juliana Pereira', 'Marcos Pereira', 'Rua 7, 789, Jardim Atlântico', 3, 2, 'Usa óculos para esporte.'),
('Larissa Vitória Martins', '99900011122', '2009-09-30', 'Fernanda Martins', 'Roberto Martins', 'Rua dos Girassóis, 321, Sagrada Família', 4, 5, 'Sem restrições.'),
('Matheus Henrique Costa', '00011122233', '2009-05-18', 'Sandra Costa', 'Paulo Costa', 'Av. Brasil, 654, Jardim das Flores', 5, 4, 'Acompanhamento ortopédico de rotina.');


-- ============================================================
-- VERIFICAÇÕES
-- ============================================================

SELECT * FROM escola;
SELECT * FROM categoria;
SELECT * FROM colaborador;
SELECT * FROM atleta;


-- ============================================================
-- UPDATES
-- ============================================================

-- UPDATE 1: Atualizando o telefone de contato de um colaborador
UPDATE colaborador
SET telefone = '(66) 99988-7766'
WHERE id_colaborador = 2;

-- UPDATE 2: Atualizando as observações médicas de um atleta
UPDATE atleta
SET observacoes_medicas = 'Alergia leve a poeira. Uso contínuo de antialérgico sob prescrição.'
WHERE id_atleta = 2;

-- UPDATE 3: Atualizando a idade máxima de uma categoria de atletismo
UPDATE categoria
SET idade_maxima = 16
WHERE id_categoria = 3;


-- ============================================================
-- DELETES
-- ============================================================

-- Inserindo e removendo um registro temporário para demonstração segura de exclusão em escola
INSERT INTO escola (nome_escola, tipo_rede, bairro, cidade) 
VALUES ('Escola Teste Temporária', 'Pública', 'Teste', 'Rondonópolis');

DELETE FROM escola
WHERE nome_escola = 'Escola Teste Temporária';

-- Inserindo e removendo um colaborador temporário para teste de exclusão em colaborador
INSERT INTO colaborador (nome_completo, cpf, cargo_funcao, telefone, data_cadastro) 
VALUES ('Colaborador Temporário', '99988877766', 'Apoio Eventual', '(66) 99900-1122', '2026-03-05');

DELETE FROM colaborador
WHERE cpf = '99988877766';


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

SELECT * FROM escola;
SELECT * FROM categoria;
SELECT * FROM colaborador;
SELECT * FROM atleta;