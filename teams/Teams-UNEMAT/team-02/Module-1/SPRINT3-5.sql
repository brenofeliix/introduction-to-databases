-- ============================================================
-- IDENTIFICAÇÃO
-- ============================================================
-- Aluna: Geovanna Gaspar Ribeiro
-- Banco: gerenciamento_incidentes
 
 
-- ============================================================
-- SELECIONAR O BANCO
-- ============================================================
 
USE gerenciamento_incidentes;
 
 
-- ============================================================
-- INSERTS — ANALISTAS (independente)
-- ============================================================
 
INSERT INTO analistas (nome, email, cargo)
VALUES
    ('Mariana Alves',   'mariana.alves@empresa.com',   'Analista de Segurança Pleno'),
    ('Pedro Santos',    'pedro.santos@empresa.com',    'Analista de Segurança Júnior'),
    ('Juliana Costa',   'juliana.costa@empresa.com',   'Analista de Segurança Sênior'),
    ('Rafael Oliveira', 'rafael.oliveira@empresa.com', 'Coordenador de SOC'),
    ('Beatriz Lima',    'beatriz.lima@empresa.com',    'Analista de Segurança Pleno');
 
 
-- ============================================================
-- INSERTS — DISPOSITIVOS (independente)
-- ============================================================
 
INSERT INTO dispositivos (nome_dispositivo, tipo_dispositivo, ip_address, ativo)
VALUES
    ('Servidor-Web-01',        'Servidor',  '192.168.1.10', TRUE),
    ('Notebook-Financeiro-03', 'Notebook',  '192.168.1.55', TRUE),
    ('Firewall-Principal',     'Firewall',  '10.0.0.1',     TRUE),
    ('Switch-Core-01',         'Switch',    '10.0.0.2',     TRUE),
    ('Servidor-BD-02',         'Servidor',  '192.168.1.20', FALSE);
 
 
-- ============================================================
-- INSERTS — TIPOS_AMEACAS (independente)
-- ============================================================
 
INSERT INTO tipos_ameacas (nome_ameaca, descricao)
VALUES
    ('Phishing',                    'Tentativa de obter dados sensíveis se passando por uma fonte confiável.'),
    ('Ransomware',                  'Software malicioso que sequestra e criptografa arquivos, exigindo resgate.'),
    ('Malware',                     'Software desenvolvido para causar danos ou obter acesso não autorizado.'),
    ('Ataque de Força Bruta',       'Tentativas repetidas de adivinhar credenciais de acesso.'),
    ('Negação de Serviço (DDoS)',   'Sobrecarga de um serviço ou rede para torná-lo indisponível.');
 
 
-- ============================================================
-- INSERTS — ALERTAS (depende de DISPOSITIVOS)
-- ============================================================
 
INSERT INTO alertas (titulo, descricao, id_dispositivo, status)
VALUES
    ('Tentativa de login suspeita',                 'Diversas tentativas de login falharam em curto intervalo de tempo.', 1, 'ABERTO'),
    ('Tráfego anômalo detectado',                    'Volume de tráfego muito acima do padrão identificado no firewall.',  3, 'ABERTO'),
    ('Uso elevado de CPU',                           'Servidor de banco de dados apresentou uso de CPU acima do normal.',  5, 'EM_ANALISE'),
    ('Múltiplas tentativas de acesso negadas',       'Switch registrou diversas tentativas de acesso não autorizadas.',    4, 'ABERTO'),
    ('Arquivo suspeito identificado',                'Antivírus identificou um arquivo potencialmente malicioso.',         2, 'RESOLVIDO');
 
 
-- ============================================================
-- INSERTS — INCIDENTES (depende de ANALISTAS, DISPOSITIVOS,
--            TIPOS_AMEACAS e ALERTAS)
-- ============================================================
 
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
 
-- Registro do encerramento do incidente 5 (único já concluído no momento da carga inicial)
UPDATE incidentes
SET data_encerramento = CURRENT_TIMESTAMP
WHERE id_incidente = 5;
 
 
-- ============================================================
-- INSERTS — ACOES_RESPOSTA (depende de INCIDENTES)
-- ============================================================
 
INSERT INTO acoes_resposta (descricao, id_incidente)
VALUES
    ('Bloqueio temporário do IP de origem do ataque.', 1),
    ('Redefinição de senha do usuário afetado.', 1),
    ('Isolamento do notebook da rede corporativa.', 2),
    ('Execução de verificação antivírus completa.', 2),
    ('Ativação de regras de mitigação de DDoS no firewall.', 4),
    ('Verificação de logs e encerramento do incidente.', 5);
 
 
-- ============================================================
-- VERIFICAÇÕES
-- ============================================================
 
SELECT * FROM analistas;
SELECT * FROM dispositivos;
SELECT * FROM tipos_ameacas;
SELECT * FROM alertas;
SELECT * FROM incidentes;
SELECT * FROM acoes_resposta;
 
 
-- ============================================================
-- TESTES DE RESTRIÇÕES DE INTEGRIDADE (apenas para conferência)
-- ============================================================
-- Os comandos abaixo foram executados manualmente no MySQL
-- Workbench durante os testes e retornaram erro, como esperado.
-- Foram mantidos AQUI SOMENTE COMO COMENTÁRIO, conforme orientação
-- da Sprint (não deixar comandos inválidos ativos no script final).
--
-- Teste 1 - UNIQUE (e-mail duplicado):
-- INSERT INTO analistas (nome, email) VALUES ('Teste', 'mariana.alves@empresa.com');
-- Resultado: Error Code 1062 - Duplicate entry 'mariana.alves@empresa.com' for key 'email'
--
-- Teste 2 - NOT NULL (título ausente):
-- INSERT INTO incidentes (descricao, severidade, status) VALUES ('Teste', 'BAIXA', 'ABERTO');
-- Resultado: Error Code 1364 - Field 'titulo' doesn't have a default value
--
-- Teste 3 - FOREIGN KEY (analista inexistente):
-- INSERT INTO incidentes (titulo, descricao, severidade, status, id_analista)
-- VALUES ('Teste FK', 'Teste', 'BAIXA', 'ABERTO', 999);
-- Resultado: Error Code 1452 - Cannot add or update a child row: a foreign key
-- constraint fails
 
 
-- ============================================================
-- UPDATES
-- ============================================================
 
-- UPDATE 1: reativa o servidor de banco de dados após manutenção
UPDATE dispositivos
SET ativo = TRUE
WHERE id_dispositivo = 5;
 
-- UPDATE 2: encerra o incidente 1 após a execução das ações de resposta
UPDATE incidentes
SET status = 'RESOLVIDO',
    data_encerramento = CURRENT_TIMESTAMP
WHERE id_incidente = 1;
 
-- UPDATE 3: promoção de cargo de um analista
UPDATE analistas
SET cargo = 'Analista de Segurança Sênior'
WHERE id_analista = 2;
 
 
-- ============================================================
-- DELETES
-- ============================================================
 
-- DELETE 1: remove um alerta que não está vinculado a nenhum incidente
DELETE FROM alertas
WHERE id_alerta = 4;
 
-- DELETE 2: remove uma ação de resposta registrada em duplicidade
DELETE FROM acoes_resposta
WHERE id_acao = 6;
 
 
-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================
 
SELECT * FROM analistas;
SELECT * FROM dispositivos;
SELECT * FROM tipos_ameacas;
SELECT * FROM alertas;
SELECT * FROM incidentes;
SELECT * FROM acoes_resposta;
 