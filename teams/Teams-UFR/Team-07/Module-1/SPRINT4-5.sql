sprint4-5
SELECT *
FROM nome_tabela;

SELECT campo_1, campo_2
FROM nome_tabela;

SELECT nome_completo, cpf, telefone
FROM colaborador;

SELECT nome_completo, data_nascimento, observacoes_medicas
FROM atleta
WHERE observacoes_medicas <> 'Nenhuma restrição médica.'
  AND observacoes_medicas IS NOT NULL;
  
  SELECT nome_completo, data_nascimento, endereco
FROM atleta
ORDER BY nome_completo ASC, data_nascimento ASC;

SELECT MIN(campo_numerico) AS menor_valor,
       MAX(campo_numerico) AS maior_valor
FROM nome_tabela;

SELECT COUNT(*) AS total_atletas
FROM atleta;

SELECT SUM(idade_minima + idade_maxima) AS soma_total_idades_referencia
FROM categoria;

SELECT AVG(idade_minima) AS media_idade_minima_categorias
FROM categoria;

SELECT MIN(data_nascimento) AS atleta_mais_velho,
       MAX(data_nascimento) AS atleta_mais_novo
FROM atleta;

SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id;

SELECT status,
       COUNT(*) AS quantidade
FROM pedido
GROUP BY status;

SELECT e.tipo_rede, COUNT(a.id_atleta) AS total_atletas
FROM escola e
JOIN atleta a ON e.id_escola = a.id_escola
GROUP BY e.tipo_rede;

SELECT categoria_id,
       COUNT(*) AS quantidade
FROM produto
GROUP BY categoria_id
HAVING COUNT(*) > 5;

SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 1;

SELECT nome,
       preco,
       preco * 0.90 AS preco_com_desconto
FROM produto;

SELECT quantidade,
       valor_unitario,
       quantidade * valor_unitario AS subtotal
FROM item_pedido;


SELECT nome_categoria,
       idade_minima,
       idade_maxima,
       (idade_maxima - idade_minima) AS amplitude_faixa_etaria
FROM categoria;

SELECT e.tipo_rede, COUNT(a.id_atleta) AS total_atletas
FROM escola e
JOIN atleta a ON e.id_escola = a.id_escola
GROUP BY e.tipo_rede;

SELECT c.nome_categoria, COUNT(a.id_atleta) AS total_atletas
FROM categoria c
LEFT JOIN atleta a ON c.id_categoria = a.id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING COUNT(a.id_atleta) > 1;