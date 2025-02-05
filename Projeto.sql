/*Tudo que foi trabalhado*/
/*Filtramos as hospedagens mais bem avaliadas, ou seja, que tiveram como nota 4 ou 5.*/
SELECT * FROM avaliacoes
WHERE nota >=4;

/*Fitrando todas as hospedagens disponíveis que fossem do tipo hotel e estivessem ativas na plataforma*/
SELECT * FROM hospedagens
WHERE tipo = 'hotel' AND ativo = 1;

/*Gasto médio de cada cliente dentro da plataforma*/
SELECT cliente_id, AVG(preco_total) AS ticket_medio
FROM alugueis
GROUP BY cliente_id;




/*Média de dias de estadia de cada cliente*/
SELECT cliente_id, AVG(DATEDIFF(data_fim,data_inicio)) AS media_dias_estadia
FROM alugueis
GROUP BY cliente_id
ORDER BY media_dias_estadia DESC;

/*Filtramos os top 10 proprietários com mais hospedagens ativas na plataforma*/
SELECT p.nome AS nome_proprietario, COUNT(h.hospedagem_id) 
AS total_hospedagens_ativas
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = h.proprietario_id
WHERE h.ativo = 1
GROUP BY p.nome
ORDER BY total_hospedagens_ativas DESC
LIMIT 10;


/*Número de hospedagens inativas por proprietário*/
SELECT p.nome AS nome_proprietario, COUNT(*) AS total_hospedagens_inativas
FROM proprietarios p
JOIN hospedagens h ON p.proprietario_id = 
h.proprietario_id
WHERE h.ativo = 0
GROUP BY p.nome;

/*Períodos de maior e menor demanda de aluguel na plataforma*/
SELECT YEAR(data_inicio) AS ano,
MONTH(data_inicio) AS mes,
COUNT(*) AS total_alugueis
FROM alugueis
GROUP BY ano, mes
ORDER BY total_alugueis DESC;

/*Adicionando uma coluna na tabela de proprietários*/
ALTER TABLE proprietarios
ADD COLUMN qtd_hospedagens INT;

/*alteração do nome da tabela de alugueis e, por consequência, o nome de uma das colunas dessa tabela*/
ALTER TABLE alugueis RENAME TO reservas;

ALTER TABLE reservas RENAME COLUMN aluguel_id TO reserva_id;


/*Hospedagens que estavam inativas para ativas*/
UPDATE hospedagens
SET ativo=1
WHERE hospedagem_id IN ('1','10','100');


/*Atualização da informação de contato de uma pessoa proprietária na tabela de proprietarios*/
UPDATE proprietarios
SET contato = 'daniela_120@email.com'
WHERE proprietario_id = '1009';


/*Dados de duas hospedagens do banco de dados, utilizando o comando DELETE
Um por vez*/

DELETE FROM avaliacoes
WHERE hospedagem_id IN ('10000','1001');

DELETE FROM reservas
WHERE hospedagem_id IN ('10000','1001');

DELETE FROM hospedagens
WHERE hospedagem_id IN ('10000','1001');





