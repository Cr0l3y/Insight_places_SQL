/*
CALL ola;
CALL listaClientes;
CALL listHospedagem;
DROP PROCEDURE listHospedagem;
CALL tiposDados;
CALL dataHora;
*/


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






