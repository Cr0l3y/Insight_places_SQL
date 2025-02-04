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
SELECT * FROM reservas WHERE reserva_id = '10001'
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
CALL novoAluguel_22('10002', '1003', '8635', '2023-03-06', '2023-03-10', 600)
SELECT * FROM reservas WHERE reserva_id = '10002';

-- criando e chamando novoAluguel_23 - 10003
CALL novoAluguel_23('10003', '1004', '8635', '2023-03-10', '2023-03-12', 250)
SELECT * FROM reservas WHERE reserva_id = '10003';

-- chamando as 2 informações
SELECT * FROM reservas WHERE reserva_id IN ('10002', 10003);
















