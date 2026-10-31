-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- Aluna: Geovanna Gaspar Ribeiro
-- Tema:  Sistema de Gerenciamento de Incidentes de Segurança
-- Banco: gerenciamento_incidentes
--
-- Este script reúne, de forma integrada, tudo o que foi
-- desenvolvido nas Sprints 1 a 4: planejamento (Sprint 1),
-- estrutura DDL (Sprint 2), manipulação de dados DML (Sprint 3)
-- e consultas SQL (Sprint 4). Ele pode ser executado do início
-- ao fim, em um banco novo, para reconstruir o projeto completo.
-- ============================================================


-- ============================================================
-- 1. CRIAÇÃO DO BANCO
-- ============================================================

CREATE DATABASE IF NOT EXISTS gerenciamento_incidentes;


-- ============================================================
-- 2. SELEÇÃO DO BANCO
-- ============================================================

USE gerenciamento_incidentes;


-- ============================================================
-- 3. CRIAÇÃO DAS TABELAS
-- ============================================================

-- Tabela 1 — ANALISTAS (independente)
CREATE TABLE analistas (
    id_analista INT PRIMARY KEY AUTO_INCREMENT,
    nome        VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    cargo       VARCHAR(100)
);

-- Tabela 2 — DISPOSITIVOS (independente)
CREATE TABLE dispositivos (
    id_dispositivo   INT PRIMARY KEY AUTO_INCREMENT,
    nome_dispositivo VARCHAR(100) NOT NULL,
    tipo_dispositivo VARCHAR(50)  NOT NULL,
    ip_address       VARCHAR(45)  NOT NULL UNIQUE,
    ativo            BOOLEAN      NOT NULL DEFAULT TRUE
);

-- Tabela 3 — TIPOS_AMEACAS (independente)
CREATE TABLE tipos_ameacas (
    id_ameaca   INT PRIMARY KEY AUTO_INCREMENT,
    nome_ameaca VARCHAR(100) NOT NULL,
    descricao   TEXT
);

-- Tabela 4 — ALERTAS (depende de DISPOSITIVOS)
-- OBS: durante a Sprint 3/5, foi identificado que o campo
-- data_alerta havia sido criado sem o DEFAULT CURRENT_TIMESTAMP
-- previsto. Nesta versão final, a coluna já é criada corretamente.
CREATE TABLE alertas (
    id_alerta      INT PRIMARY KEY AUTO_INCREMENT,
    titulo         VARCHAR(150) NOT NULL,
    descricao      TEXT,
    data_alerta    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status         VARCHAR(30) NOT NULL DEFAULT 'ABERTO',
    id_dispositivo INT NOT NULL,

    CONSTRAINT fk_alertas_dispositivos
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo)
);

-- Tabela 5 — INCIDENTES (depende de ANALISTAS, DISPOSITIVOS,
--            TIPOS_AMEACAS e ALERTAS)
-- OBS: o campo "observacoes" foi incluído aqui diretamente; na
-- Sprint 2/5 ele havia sido adicionado posteriormente por meio
-- de um ALTER TABLE, como exercício daquela etapa.
CREATE TABLE incidentes (
    id_incidente        INT PRIMARY KEY AUTO_INCREMENT,
    titulo              VARCHAR(150) NOT NULL,
    descricao           TEXT NOT NULL,
    severidade          VARCHAR(30) NOT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'ABERTO',
    data_identificacao  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_encerramento   DATETIME NULL,
    observacoes         TEXT,
    id_analista         INT NULL,
    id_dispositivo      INT NULL,
    id_ameaca           INT NULL,
    id_alerta           INT NULL,

    CONSTRAINT fk_incidentes_analistas
        FOREIGN KEY (id_analista)
        REFERENCES analistas(id_analista),

    CONSTRAINT fk_incidentes_dispositivos
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo),

    CONSTRAINT fk_incidentes_tipos_ameacas
        FOREIGN KEY (id_ameaca)
        REFERENCES tipos_ameacas(id_ameaca),

    CONSTRAINT fk_incidentes_alertas
        FOREIGN KEY (id_alerta)
        REFERENCES alertas(id_alerta)
);

-- Tabela 6 — ACOES_RESPOSTA (depende de INCIDENTES)
CREATE TABLE acoes_resposta (
    id_acao      INT PRIMARY KEY AUTO_INCREMENT,
    descricao    TEXT NOT NULL,
    data_acao    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_incidente INT NOT NULL,

    CONSTRAINT fk_acoes_incidentes
        FOREIGN KEY (id_incidente)
        REFERENCES incidentes(id_incidente)
);


-- ============================================================
-- 4. RESTRIÇÕES E RELACIONAMENTOS
-- ============================================================
-- Resumo das restrições já aplicadas nas tabelas acima:
--
-- PRIMARY KEY + AUTO_INCREMENT -> id_analista, id_dispositivo,
--   id_ameaca, id_alerta, id_incidente, id_acao
-- UNIQUE  -> analistas.email / dispositivos.ip_address
-- NOT NULL -> campos obrigatórios de cada tabela (nome, título,
--   descrição, severidade, status, etc.)
-- DEFAULT -> dispositivos.ativo (TRUE), alertas.status ('ABERTO'),
--   alertas.data_alerta / incidentes.data_identificacao /
--   acoes_resposta.data_acao (CURRENT_TIMESTAMP),
--   incidentes.status ('ABERTO')
-- FOREIGN KEY -> alertas -> dispositivos; incidentes -> analistas,
--   dispositivos, tipos_ameacas e alertas; acoes_resposta -> incidentes
--
-- Não há relacionamento N:N no projeto, portanto não existe
-- tabela associativa.


-- ============================================================
-- 5. INSERTS
-- ============================================================

INSERT INTO analistas (nome, email, cargo)
VALUES
    ('Mariana Alves',   'mariana.alves@empresa.com',   'Analista de Segurança Pleno'),
    ('Pedro Santos',    'pedro.santos@empresa.com',    'Analista de Segurança Júnior'),
    ('Juliana Costa',   'juliana.costa@empresa.com',   'Analista de Segurança Sênior'),
    ('Rafael Oliveira', 'rafael.oliveira@empresa.com', 'Coordenador de SOC'),
    ('Beatriz Lima',    'beatriz.lima@empresa.com',    'Analista de Segurança Pleno');

INSERT INTO dispositivos (nome_dispositivo, tipo_dispositivo, ip_address, ativo)
VALUES
    ('Servidor-Web-01',        'Servidor',  '192.168.1.10', TRUE),
    ('Notebook-Financeiro-03', 'Notebook',  '192.168.1.55', TRUE),
    ('Firewall-Principal',     'Firewall',  '10.0.0.1',     TRUE),
    ('Switch-Core-01',         'Switch',    '10.0.0.2',     TRUE),
    ('Servidor-BD-02',         'Servidor',  '192.168.1.20', FALSE);

INSERT INTO tipos_ameacas (nome_ameaca, descricao)
VALUES
    ('Phishing',                    'Tentativa de obter dados sensíveis se passando por uma fonte confiável.'),
    ('Ransomware',                  'Software malicioso que sequestra e criptografa arquivos, exigindo resgate.'),
    ('Malware',                     'Software desenvolvido para causar danos ou obter acesso não autorizado.'),
    ('Ataque de Força Bruta',       'Tentativas repetidas de adivinhar credenciais de acesso.'),
    ('Negação de Serviço (DDoS)',   'Sobrecarga de um serviço ou rede para torná-lo indisponível.');

INSERT INTO alertas (titulo, descricao, id_dispositivo, status)
VALUES
    ('Tentativa de login suspeita',                 'Diversas tentativas de login falharam em curto intervalo de tempo.', 1, 'ABERTO'),
    ('Tráfego anômalo detectado',                    'Volume de tráfego muito acima do padrão identificado no firewall.',  3, 'ABERTO'),
    ('Uso elevado de CPU',                           'Servidor de banco de dados apresentou uso de CPU acima do normal.',  5, 'EM_ANALISE'),
    ('Múltiplas tentativas de acesso negadas',       'Switch registrou diversas tentativas de acesso não autorizadas.',    4, 'ABERTO'),
    ('Arquivo suspeito identificado',                'Antivírus identificou um arquivo potencialmente malicioso.',         2, 'RESOLVIDO');

INSERT INTO incidentes (
    titulo, descricao, severidade, status,
    id_analista, id_dispositivo, id_ameaca, id_alerta
)
VALUES
    ('Acesso não autorizado ao servidor web',
     'Foram identificadas diversas tentativas de acesso indevido ao servidor web principal.',
     'ALTA', 'ABERTO', 1, 1, 4, 1),

    ('Infecção por ransomware em notebook financeiro',
     'O notebook do setor financeiro apresentou arquivos criptografados sem autorização.',
     'CRITICA', 'EM_ANALISE', 3, 2, 2, 5),

    ('Tentativa de phishing direcionado',
     'Colaborador recebeu e-mail fraudulento solicitando credenciais corporativas.',
     'MEDIA', 'ABERTO', 2, NULL, 1, NULL),

    ('Ataque de negação de serviço ao firewall',
     'O firewall principal recebeu um volume de requisições muito acima do esperado.',
     'ALTA', 'EM_ANALISE', 4, 3, 5, 2),

    ('Comportamento anômalo no servidor de banco de dados',
     'Servidor de banco de dados apresentou instabilidade e uso elevado de recursos.',
     'BAIXA', 'ENCERRADO', 5, 5, 3, 3);

INSERT INTO acoes_resposta (descricao, id_incidente)
VALUES
    ('Bloqueio temporário do IP de origem do ataque.', 1),
    ('Redefinição de senha do usuário afetado.', 1),
    ('Isolamento do notebook da rede corporativa.', 2),
    ('Execução de verificação antivírus completa.', 2),
    ('Ativação de regras de mitigação de DDoS no firewall.', 4),
    ('Verificação de logs e encerramento do incidente.', 5);


-- ============================================================
-- 6. UPDATES
-- ============================================================

-- Registro do encerramento do incidente 5 (já concluído na carga inicial)
UPDATE incidentes
SET data_encerramento = CURRENT_TIMESTAMP
WHERE id_incidente = 5;

-- Reativação do servidor de banco de dados após manutenção
UPDATE dispositivos
SET ativo = TRUE
WHERE id_dispositivo = 5;

-- Encerramento do incidente 1 após conclusão das ações de resposta
UPDATE incidentes
SET status = 'RESOLVIDO',
    data_encerramento = CURRENT_TIMESTAMP
WHERE id_incidente = 1;

-- Promoção de cargo de um analista
UPDATE analistas
SET cargo = 'Analista de Segurança Sênior'
WHERE id_analista = 2;


-- ============================================================
-- 7. DELETES
-- ============================================================

-- Remoção de um alerta identificado como falso positivo,
-- sem vínculo com nenhum incidente
DELETE FROM alertas
WHERE id_alerta = 4;

-- Remoção de uma ação de resposta registrada em duplicidade
DELETE FROM acoes_resposta
WHERE id_acao = 6;


-- ============================================================
-- 8. CONSULTAS BÁSICAS
-- ============================================================

-- Visão geral de todos os incidentes cadastrados
SELECT *
FROM incidentes;

-- Apenas as colunas mais relevantes de cada incidente
SELECT titulo, severidade, status
FROM incidentes;


-- ============================================================
-- 9. WHERE
-- ============================================================

-- Pergunta (Sprint 1/5): quais incidentes estão atualmente abertos?
SELECT titulo, severidade, status, data_identificacao
FROM incidentes
WHERE status = 'ABERTO';

-- Pergunta (Sprint 1/5): quais incidentes possuem severidade alta ou crítica?
SELECT titulo, severidade, status
FROM incidentes
WHERE severidade IN ('ALTA', 'CRITICA')
  AND status <> 'ENCERRADO';


-- ============================================================
-- 10. ORDER BY
-- ============================================================

-- Incidentes do mais recente para o mais antigo
SELECT titulo, severidade, data_identificacao
FROM incidentes
ORDER BY data_identificacao DESC;


-- ============================================================
-- 11. FUNÇÕES DE AGREGAÇÃO
-- ============================================================

-- COUNT: total de incidentes registrados
SELECT COUNT(*) AS total_incidentes
FROM incidentes;

-- SUM: quantidade de incidentes críticos por analista
SELECT a.nome AS analista,
       SUM(CASE WHEN i.severidade IN ('ALTA', 'CRITICA') THEN 1 ELSE 0 END) AS incidentes_criticos
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
GROUP BY a.id_analista, a.nome;

-- AVG: média de incidentes por analista
SELECT AVG(quantidade) AS media_incidentes_por_analista
FROM (
    SELECT id_analista, COUNT(*) AS quantidade
    FROM incidentes
    WHERE id_analista IS NOT NULL
    GROUP BY id_analista
) AS incidentes_por_analista;

-- MIN / MAX: incidente mais antigo e mais recente
SELECT MIN(data_identificacao) AS incidente_mais_antigo,
       MAX(data_identificacao) AS incidente_mais_recente
FROM incidentes;


-- ============================================================
-- 12. GROUP BY
-- ============================================================

-- Pergunta (Sprint 1/5): quantos incidentes por tipo de ameaça?
SELECT t.nome_ameaca,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM tipos_ameacas t
LEFT JOIN incidentes i ON i.id_ameaca = t.id_ameaca
GROUP BY t.id_ameaca, t.nome_ameaca
ORDER BY quantidade_incidentes DESC;


-- ============================================================
-- 13. HAVING
-- ============================================================

-- Pergunta (Sprint 1/5): quais dispositivos concentram mais incidentes?
SELECT d.nome_dispositivo,
       COUNT(i.id_incidente) AS quantidade_incidentes
FROM dispositivos d
JOIN incidentes i ON i.id_dispositivo = d.id_dispositivo
GROUP BY d.id_dispositivo, d.nome_dispositivo
HAVING COUNT(i.id_incidente) > 1
ORDER BY quantidade_incidentes DESC;


-- ============================================================
-- 14. EXPRESSÕES SQL
-- ============================================================

-- Dias entre a identificação e o encerramento de cada incidente já resolvido
SELECT titulo,
       data_identificacao,
       data_encerramento,
       TIMESTAMPDIFF(DAY, data_identificacao, data_encerramento) AS dias_para_resolucao
FROM incidentes
WHERE data_encerramento IS NOT NULL;

-- Pergunta (Sprint 1/5): quais incidentes cada analista acompanha?
SELECT a.nome AS analista,
       i.titulo AS incidente,
       i.status
FROM analistas a
JOIN incidentes i ON i.id_analista = a.id_analista
ORDER BY a.nome;


-- ============================================================
-- 15. VALIDAÇÃO FINAL
-- ============================================================

-- Confirma que todas as tabelas foram criadas
SHOW TABLES;

-- Confirma a estrutura de cada tabela
DESCRIBE analistas;
DESCRIBE dispositivos;
DESCRIBE tipos_ameacas;
DESCRIBE alertas;
DESCRIBE incidentes;
DESCRIBE acoes_resposta;

-- Confirma constraints (PK, FK, UNIQUE, DEFAULT) geradas pelo MySQL
SHOW CREATE TABLE incidentes;
SHOW CREATE TABLE alertas;

-- Conferência final dos dados de cada tabela
SELECT * FROM analistas;
SELECT * FROM dispositivos;
SELECT * FROM tipos_ameacas;
SELECT * FROM alertas;
SELECT * FROM incidentes;
SELECT 
    *
FROM
    acoes_resposta;

-- ------------------------------------------------------------
-- Testes de integridade referencial e de restrições (mantidos
-- apenas como comentário, pois retornam erro propositalmente)
-- ------------------------------------------------------------
--
-- Teste de FOREIGN KEY (analista inexistente):
-- INSERT INTO incidentes (titulo, descricao, severidade, status, id_analista)
-- VALUES ('Teste FK', 'Teste', 'BAIXA', 'ABERTO', 999);
-- Resultado: Error Code 1452 - Cannot add or update a child row: a foreign
-- key constraint fails
--
-- Teste de UNIQUE (e-mail duplicado):
-- INSERT INTO analistas (nome, email) VALUES ('Teste', 'mariana.alves@empresa.com');
-- Resultado: Error Code 1062 - Duplicate entry 'mariana.alves@empresa.com'
-- for key 'email'
--
-- Teste de NOT NULL (título ausente):
-- INSERT INTO incidentes (descricao, severidade, status) VALUES ('Teste', 'BAIXA', 'ABERTO');
-- Resultado: Error Code 1364 - Field 'titulo' doesn't have a default value