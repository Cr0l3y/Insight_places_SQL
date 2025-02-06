/*
CALL ola;
CALL listaClientes;
CALL listHospedagem;
DROP PROCEDURE listHospedagem;
CALL tiposDados;
CALL dataHora;
*/


CREATE DEFINER=`root`@`localhost` PROCEDURE `dataHora`()
BEGIN
	DECLARE ts DATETIME DEFAULT localtimestamp();
    SELECT ts;
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `listaClientes`()
BEGIN
	SELECT * FROM clientes;
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `tiposDados`()
BEGIN
  DECLARE vAluguel VARCHAR(10) DEFAULT 10001;
  DECLARE vCliente VARCHAR(10) DEFAULT 1002;
  DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
  DECLARE vDataInicio DATE DEFAULT '2023-03-01';
  DECLARE vDataFinal DATE DEFAULT '2023-03-05';
  DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
END



/*Modificandoe criando novoAluguel_21*/
USE `inc_places`;
DROP procedure IF EXISTS `inc_places`.`novoAluguel_21`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_21`()
BEGIN
  DECLARE vAluguel VARCHAR(10) DEFAULT 10001;
  DECLARE vCliente VARCHAR(10) DEFAULT 1002;
  DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
  DECLARE vDataInicio DATE DEFAULT '2023-03-01';
  DECLARE vDataFinal DATE DEFAULT '2023-03-05';
  DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
  SELECT vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal;
END$$

DELIMITER ;

/*Modificandoe criando novoAluguel_22*/
USE `inc_places`;
DROP procedure IF EXISTS `inc_places`.`novoAluguel_22`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_22`()
BEGIN
  DECLARE vAluguel VARCHAR(10) DEFAULT 10001;
  DECLARE vCliente VARCHAR(10) DEFAULT 1002;
  DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
  DECLARE vDataInicio DATE DEFAULT '2023-03-01';
  DECLARE vDataFinal DATE DEFAULT '2023-03-05';
  DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
  INSERT INTO reservas VALUE (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$

DELIMITER ;


/*chamando não vai achar ate chamar o dado */
SELECT * FROM reservas WHERE reserva_id = '10001';
CALL novoAluguel_22;

/*Modificandoe criando novoAluguel_23 pássando parametros*/
USE `inc_places`;
DROP PROCEDURE IF EXISTS `inc_places`.`novoAluguel_23`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_23`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoTotal DECIMAL(10,2))
BEGIN
    INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;

-- criando e chamando novoAluguel_22 - 10002
CALL novoAluguel_22('10002', '1003', '8635', '2023-03-06', '2023-03-10', 600);
SELECT * FROM reservas WHERE reserva_id = '10002';

-- criando e chamando novoAluguel_23 - 10003
CALL novoAluguel_23('10003', '1004', '8635', '2023-03-10', '2023-03-12', 250);
SELECT * FROM reservas WHERE reserva_id = '10003';

-- chamando as 2 informações
SELECT * FROM reservas WHERE reserva_id IN ('10002', 10003);

-- O resultado é 2 porque temos dois dias entre o dia 03/04 e o dia 01/04. Então, essa consulta retorna o número de dias entre as datas.
SELECT DATEDIFF ('2023-04-03','2023-04-01') AS diferenca_dias;


-- criando novoAluguel_24 pássando parametros
USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_24`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_24`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    
    INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;

CALL novoAluguel_24('10004', '1004', '8635', '2023-03-13', '2023-03-16', 40);
SELECT * FROM reservas WHERE reserva_id = 10004;


-- Procedure


SELECT * FROM clientes WHERE cliente_id= 10001;
CALL novoAluguel_24('10005','10001','8635','2023-03-17','2023-03-25',40);

-- Tratando Erros com Chave Estrangeira na Procedure
USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_25`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_25`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = "Problema de chave estrangeira associado a alguma entidade da base.";
		SELECT vMensagem;
    END;
-- atribuir uma variavel uma função 
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    
    INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = "Aluguel incluído na base com sucesso.";
        SELECT vMensagem;
END$$
DELIMITER ;

CALL novoAluguel_25('10005','1004','8635','2023-03-17','2023-03-25',40);



-- modificar o script para, ao registrar um aluguel, entrarmos com o nome em vez do código da pessoa cliente
SELECT * FROM clientes WHERE nome = 'Luana Moura';


USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_31`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_31`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE VPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio)); -- atribuir uma variavel uma função 
    SET vPrecoTotal = vDias * vPrecoUnitario;
    SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
    INSERT INTO reervas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucesso.';
    SELECT vMensagem;
END$$
DELIMITER ;

-- retorna o codigo ID do cliente
CALL novoAluguel_31('10006','Luana Moura','8635','2023-03-26','2023-03-30',40);


/*O exemplo prático envolveu a criação de uma Procedure chamada novoAluguel_32, 
que verifica se o nome do cliente possui mais de um registro na tabela de clientes. 
Se houver mais de um cliente com o mesmo nome, a Procedure exibe uma mensagem informando 
que não é possível incluir o aluguel. Caso contrário, o aluguel é incluído normalmente.
*/

CALL novoAluguel_31('10007','Júlia Pires','8635','2023-03-30','2023-04-04',40);
SELECT *FROM clientes WHERE nome = 'Júlia Pires';



USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_31`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_32`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR (10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    END IF;
END$$
DELIMITER ;

CALL novoAluguel_32('10007','Júlia Pires','8635','2023-03-30','2023-04-04',40);

-- Alterando para dados menores que 1
USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_33`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_33`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR (10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
	ELSEIF vNumClient = 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    END IF;
END$$
DELIMITER ;

DELETE FROM reservas WHERE reserva_id = '10007';
CALL novoAluguel_33('10007','Victorino Vila','8635','2023-03-30','2023-04-04',40);



-- CASE-END CASE
USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_34`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_34`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR (10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE vNumCliente
    WHEN 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    ELSE
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;

CALL novoAluguel_34('10007','Luana Moura','8635','2023-03-30','2023-04-04',40);

-- CASE-END CASE so que com CASE WHEN
USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_35`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_35`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR (10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE 
    WHEN vNumCliente =0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente =1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    WHEN vNumCliente >1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;

DELETE FROM reservas WHERE reserva_id = 1007;
CALL novoAluguel_35('10007','Victorino Vila','8635','2023-03-30','2023-04-04',40);
CALL novoAluguel_35('10007','Júlia Pires','8635','2023-03-30','2023-04-04',40);
CALL novoAluguel_35('10007','Luana Moura','8635','2023-03-30','2023-04-04',40);


-- alterar o parâmetro de data final que temos atualmente na procedure para o número de dias
SELECT '2023-01-01' + INTERVAL 5 DAY;

USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_41`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_41` (
    IN vAluguel VARCHAR(10),
    IN vClienteNome VARCHAR(150),
    IN vHospedagem VARCHAR(10),
    IN vDataInicio DATE,
    IN vDias INTEGER,
    IN vPrecoUnitario DECIMAL(10,2)
)
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    -- Handler para erro de chave estrangeira
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    -- Verificação da existência do cliente
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE 
        WHEN vNumCliente = 0 THEN
            SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
            SELECT vMensagem;
        WHEN vNumCliente = 1 THEN
            -- Obtendo o ID do cliente -- SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
            SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
            -- Calculando a data final e o preço total
            SET vDataFinal = DATE_ADD(vDataInicio, INTERVAL vDias DAY);
            SET vPrecoTotal = vDias * vPrecoUnitario;
            -- Inserção do aluguel
            INSERT INTO reservas (reserva_id, cliente_id, hospedagem_id, data_inicio, data_final, preco_total)
            VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
            SET vMensagem = 'Aluguel incluído na base com sucesso.';
            SELECT vMensagem;
        WHEN vNumCliente > 1 THEN
            SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque há múltiplos registros com o mesmo nome.';
            SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;





-- kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk


-- alterar o parâmetro de data final que temos atualmente na procedure para o número de dias

USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_42`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_42`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
 vDataInicio  DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR (10);
    DECLARE vContador INTEGER;
    DECLARE vDiaSemana INTEGER;
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE 
    WHEN vNumCliente =0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente =1 THEN
        -- SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);
        -- SET vDias = (SELECT DATADIFF (vDataFinal, vDataInicio));
        SET vContador =1;
        SET vDataFinal = vDataInicio;
        WHILE vContador < vDias
        DO
			SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, '%Y-%m-%d')));
            IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
				SET vContador = vContador + 1;
			END IF;
            SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
		END WHILE;        
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientclienteses WHERE nome = vClienteNome;
        INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    WHEN vNumCliente >1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;

CALL novoAluguel_42('10010','Gabriela Pires', '8635', '2023-04-12',5,40);
SELECT * FROM reservas WHERE reserva_id = 10010;

-- criação da procude

CREATE DEFINER=`root`@`localhost` PROCEDURE `calculaDataFinal_43`(vDataInicio DATE, INOUT vDataFinal DATE, vDias INTEGER)
BEGIN
DECLARE vContador INTEGER;
DECLARE vDiaSemana INTEGER;
SET vContador =1;
SET vDataFinal = vDataInicio;
WHILE vContador < vDias
DO
	SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, '%Y-%m-%d')));
    IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
		SET vContador = vContador + 1;
    END IF;
	SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
END WHILE;
END








-- Mudando alguns pareametros e removendo 2 declare de vDataInicio, vDataFinal, e fazendo a call ela onde ficava o while end while

USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_43`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_43`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
 vDataInicio  DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR (10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE 
    WHEN vNumCliente =0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente =1 THEN
		CALL calculaDataFinal_43(vDataInicio, vDataFinal, vDias);
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    WHEN vNumCliente >1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;

CALL novoAluguel_43 ('10011', 'Livia Fogaça', '8635', '2023-04-20',10,40);
SELECT * FROM reservas WHERE reserva_id = '10011';

-- melhoramos a procedure e não precisamos mais entrar com o identificador do aluguel. alem de usar CONCAT para informar o ID adicionado quando for bem sucedido

USE `inc_places`;
DROP PROCEDURE IF EXISTS `novoAluguel_44`;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_44`
(vClienteNome VARCHAR(150), vHospedagem VARCHAR(10),
 vDataInicio  DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vAluguel VARCHAR(10);
    DECLARE vCliente VARCHAR (10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE 
    WHEN vNumCliente =0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente =1 THEN
		SELECT CAST(MAX(CAST(reserva_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM reservas;
		CALL calculaDataFinal_43(vDataInicio, vDataFinal, vDias);
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = CONCAT('Aluguel incluído na base com sucesso. - ID', vAluguel);
        SELECT vMensagem;
    WHEN vNumCliente >1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;

DELETE FROM reservas WHERE reserva_id = '10012'
CALL novoAluguel_44('Livia Fogaça', '8635', '2023-05-15', 5, 45);

-- criando a procude da lista temporaria

CREATE DEFINER=`root`@`localhost` PROCEDURE `inclui_usuarios_lista_52`(lista VARCHAR(255))
BEGIN
	DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante, ',') >0 DO
		SET pos =INSTR(restante, ',');
        SET nome = LEFT(restante, pos -1);
        INSERT INTO temp_nome VALUES (nome);
        SET restante = SUBSTRING(restante, pos+1);
    END WHILE;
    IF TRIM(restante) <> '' THEN
    INSERT INTO temp_nome VALUES (TRIM(restante));
    END IF;
END

-- exercendo tabela temporaria

DROP TEMPORARY TABLE IF EXISTS tempo_nomes; -- dropa tabea temporaria
CREATE TEMPORARY TABLE temp_nome(nome VARCHAR(255)); -- criar tabela temporaria
CALL inclui_usuarios_lista_52('Luana Moura,Enrico Correia,Paulo Vieira,Marina Nunes'); -- vamos testar a procedure
SELECT * FROM temp_nome; -- e olhar o modelo da tabela



-- Adicionando um CURSOR que permitir uma interatividade linha a linha através de uma determinada ordem.

CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_54`()
BEGIN
	DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor =1;
    OPEN cursor1;
	FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO
        SELECT vnome;
		FETCH cursor1 INTO vnome;
	END WHILE;
    CLOSE cursor1;
END

DROP TEMPORARY TABLE IF EXISTS temp_nome;
CREATE TEMPORARY TABLE temp_nome (nome VARCHAR(255));
CALL inclui_usuarios_lista_52('João, Pedro, Maria, Lucia, Joana, Beatriz');
SELECT * FROM temp_nome;
CALL looping_cursor_54();

-- adicionando múltiplos aluguéis

USE `inc_places`;
DROP PROCEDURE IF EXISTS `inc_places`.`novosAlugueis_55`;
;
DELIMITER $$
USE `inc_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novosAlugueis_55`(lista VARCHAR(255), vHospedagem VARCHAR(10), vDataInicio DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vClienteNome VARCHAR(150);
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    DROP TEMPORARY TABLE IF EXISTS temp_nome;
    CREATE TEMPORARY TABLE temp_nome (nome VARCHAR(255));
    CALL inclui_usuarios_lista_52(lista);
    OPEN cursor1;
    FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO
        SET vClienteNome = vnome;
        CALL novoAluguel_44 (vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vnome;
    END WHILE;
    CLOSE cursor1;
    DROP TEMPORARY TABLE IF EXISTS temp_nome;
END$$

DELIMITER ;
;

CALL novosAlugueis_55('Gabriel Carvalho,Erick Oliveira,Catarina Correia,Lorena Jesus', '8635', '2023-06-03', 7, 45);

SELECT * FROM reservas WHERE reserva_id IN ('10017', '10016', '10015', '10014');




