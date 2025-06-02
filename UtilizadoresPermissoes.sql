USE AutoArmando;

-- DROP USER 'firmino_coelho'@'localhost'
CREATE USER 'firmino_coelho'@'localhost' IDENTIFIED BY '@Password123';

-- DROP USER 'filipa_coelho'@'localhost'
CREATE USER 'filipa_coelho'@'localhost' IDENTIFIED BY '@Password123';
-- DROP USER 'jorge_coelho'@'localhost'
CREATE USER 'jorge_coelho'@'localhost' IDENTIFIED BY '@Password123';

-- DROP USER 'marcelo_meireles'@'localhost'
CREATE USER 'marcelo_meireles'@'localhost' IDENTIFIED BY '@Password123';
-- DROP USER 'marcio_meireles'@'localhost'
CREATE USER 'marcio_meireles'@'localhost' IDENTIFIED BY '@Password123';
-- DROP USER 'jaime_figueiredo'@'localhost'
CREATE USER 'jaime_figueiredo'@'localhost' IDENTIFIED BY '@Password123';
-- DROP USER 'julia_jardim'@'localhost'
CREATE USER 'julia_jardim'@'localhost' IDENTIFIED BY '@Password123';
-- DROP USER 'simao_ferreira'@'localhost'
CREATE USER 'simao_ferreira'@'localhost' IDENTIFIED BY '@Password123';
-- DROP USER 'sidonio_antunes'@'localhost'
CREATE USER 'sidonio_antunes'@'localhost' IDENTIFIED BY '@Password123';

-- DROP ROLE Administrador
CREATE ROLE Administrador;
-- DROP ROLE GestorFilial
CREATE ROLE GestorFilial;
-- DROP ROLE FuncionarioCargo
CREATE ROLE FuncionarioCargo;

-- DROP TABLE AuxFuncionarioUtilizador
CREATE TABLE AuxUtilizador 
(
	id_funcionario INT PRIMARY KEY NOT NULL,
	username       VARCHAR(150) NOT NULL,
	cargo          ENUM('ADMINISTRADOR', 'GESTORFILIAL', 'FUNCIONARIO'),
    
	FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
		ON DELETE RESTRICT
        ON UPDATE NO ACTION
);



-- ==Administrador==

-- REVOKE SELECT, INSERT, DELETE, UPDATE ON AuxUtilizador FROM Administrador
GRANT SELECT, INSERT, DELETE, UPDATE ON AuxUtilizador TO Administrador;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM Administrador
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO Administrador;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Veiculo FROM Administrador
GRANT SELECT, INSERT, DELETE, UPDATE ON Veiculo TO Administrador;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Funcionario FROM Administrador
GRANT SELECT, INSERT, DELETE, UPDATE ON Funcionario TO Administrador;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Loja FROM Administrador
GRANT SELECT, INSERT, DELETE, UPDATE ON Loja TO Administrador;
-- REVOKE SELECT, INSERT, UPDATE ON Aluguer FROM Administrador
GRANT SELECT, INSERT, UPDATE ON Aluguer TO Administrador;

-- REVOKE GestorFilial FROM Administrador WITH ADMIN OPTION;
GRANT GestorFilial TO Administrador WITH ADMIN OPTION;
-- REVOKE FuncionarioCargo FROM Administrador WITH ADMIN OPTION;
GRANT FuncionarioCargo TO Administrador WITH ADMIN OPTION;

-- REVOKE Administrador TO 'firmino_coelho'@'localhost';
GRANT Administrador TO 'firmino_coelho'@'localhost';
SET DEFAULT ROLE Administrador TO 'firmino_coelho'@'localhost';

INSERT INTO AuxUtilizador VALUES
(1, 'firmino_coelho', 'ADMINISTRADOR');


-- == Gestor Filial==

-- DROP VIEW ViVeiculosUtilizador
CREATE OR REPLACE VIEW ViVeiculosUtilizador AS
SELECT V.id_veiculo, V.matricula, V.preco, V.estado, V.marca, V.tipo_veiculo, V.ano, V.id_loja
FROM AuxUtilizador AS U
NATURAL JOIN Funcionario AS F -- id_loja
NATURAL JOIN Veiculo AS V -- id_funcionario
	WHERE U.username = SUBSTRING_INDEX(USER(), '@', 1);
          
          
-- DROP VIEW ViFuncionariosLojaUtilizador
CREATE OR REPLACE VIEW ViFuncionariosLojaUtilizador AS
SELECT F2.id_funcionario, F2.nome_completo, F2.funcao, F2.id_loja
FROM AuxUtilizador AS U
NATURAL JOIN Funcionario AS F1 -- id_funcionario
INNER JOIN Funcionario AS F2  -- id_loja
	ON F1.id_loja = F2.id_loja
WHERE U.username = SUBSTRING_INDEX(USER(), '@', 1);
          
-- DROP VIEW ViLojaUtilizador
CREATE OR REPLACE VIEW ViLojaUtilizador AS
SELECT L.id_loja, L.email, L.cidade, L.rua, L.numero_porta, L.codigo_postal
FROM AuxUtilizador AS U
NATURAL JOIN Funcionario AS F -- id_funcionario
NATURAL JOIN Loja AS L -- id_loja
	WHERE U.username = SUBSTRING_INDEX(USER(), '@', 1);  -- CURRENT_USER é o nome do utilizador atual
          

-- DROP PROCEDURE PrUpdateVeiculos
DELIMITER $$
CREATE PROCEDURE PrUpdateVeiculos
(
  IN id_veiculo_a_atualizar INT,
  IN matricula_nova VARCHAR(6),
  IN estado_novo_veiculo ENUM('ALUGADO', 'LIVRE', 'MANUTENCAO'),
  IN marca_nova VARCHAR(100),
  IN tipo_veiculo_novo VARCHAR(200),
  IN ano_novo INT
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Erro a atualizar os dados do veículo';
    END;
    
    START TRANSACTION;
    procedimento: BEGIN
		IF id_veiculo_a_atualizar IS NULL THEN
			SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Não é possivel atualizar os dados de um veículo pois não foi fornecido um ID';
			LEAVE procedimento;
		END IF;
		IF matricula_nova IS NOT NULL THEN
			UPDATE ViVeiculosUtilizador
            SET matricula = matricula_nova
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;        
		IF estado_novo_veiculo IS NOT NULL THEN
			UPDATE ViVeiculosUtilizador
            SET estado = estado_novo_veiculo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
		IF marca_nova IS NOT NULL THEN
			UPDATE ViVeiculosUtilizador
            SET marca = marca_nova
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
		IF tipo_veiculo_novo IS NOT NULL THEN
			UPDATE ViVeiculosUtilizador
            SET tipo_veiculo = tipo_veiculo_novo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
		IF ano_novo IS NOT NULL THEN
			UPDATE ViVeiculosUtilizador
            SET ano = ano_novo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
    COMMIT;
    END procedimento;
END$$
DELIMITER ;

-- REVOKE EXECUTE ON PROCEDURE PrUpdateVeiculos FROM GestorFilial
GRANT EXECUTE ON PROCEDURE PrUpdateVeiculos TO GestorFilial;

-- REVOKE SELECT ON AuxUtilizador FROM GestorFilial
GRANT SELECT ON AuxUtilizador TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViVeiculosUtilizador FROM GestorFilial
GRANT SELECT, INSERT, DELETE ON ViVeiculosUtilizador TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViFuncionariosLojaUtilizador FROM GestorFilial
GRANT SELECT, INSERT, DELETE, UPDATE ON ViFuncionariosLojaUtilizador TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViLojaUtilizador FROM GestorFilial
GRANT SELECT, INSERT, DELETE, UPDATE ON ViLojaUtilizador TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM GestorFilial
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO GestorFilial;
-- REVOKE SELECT, INSERT, UPDATE ON Aluguer FROM GestorFilial
GRANT SELECT, INSERT, UPDATE ON Aluguer TO GestorFilial;

-- REVOKE GestorFilial FROM 'filipa_coelho'@'localhost'
GRANT GestorFilial TO 'filipa_coelho'@'localhost';
SET DEFAULT ROLE GestorFilial TO 'filipa_coelho'@'localhost';
-- REVOKE GestorFilial FROM 'jorge_coelho'@'localhost'
GRANT GestorFilial TO 'jorge_coelho'@'localhost';
SET DEFAULT ROLE GestorFilial TO 'jorge_coelho'@'localhost';

-- DELETE FROM AuxTGestorFilialLoja WHERE nome_completo = 'filipa_coelho@localhost'
-- DELETE FROM AuxTGestorFilialLoja WHERE nome_completo = 'jorge_coelho@localhost'
INSERT INTO AuxUtilizador VALUES
(2, 'filipa_coelho', 'GESTORFILIAL'),
(3, 'jorge_coelho', 'GESTORFILIAL');



-- == Funcionario ==

-- DROP PROCEDURE PrUpdateEstadoVeiculo
DELIMITER $$
CREATE PROCEDURE PrUpdateEstadoVeiculo
(
  IN id_veiculo_a_atualizar INT,
  IN estado_novo_veiculo ENUM('ALUGADO', 'LIVRE', 'MANUTENCAO')
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'Erro a atualizar o estado do veículo';
    END;
    
    START TRANSACTION;
    procedimento: BEGIN
		IF id_veiculo_a_atualizar IS NULL THEN
			SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Não é possivel atualizar os dados de um veículo pois não foi fornecido um ID';
			LEAVE procedimento;
		END IF;      
		IF estado_novo_veiculo IS NOT NULL THEN
			UPDATE ViVeiculosUtilizador
            SET estado = estado_novo_veiculo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
    COMMIT;
    END procedimento;
END$$
DELIMITER ;

-- REVOKE EXECUTE ON PROCEDURE PrUpdateEstadoVeiculo FROM FuncionarioCargo   
GRANT EXECUTE ON PROCEDURE PrUpdateEstadoVeiculo TO FuncionarioCargo;

-- REVOKE SELECT ON ViVeiculosLoja FROM FuncionarioCargo  
GRANT SELECT ON ViFuncionariosLojaUtilizador TO FuncionarioCargo;
-- REVOKE SELECT ON ViVeiculosUtilizador FROM FuncionarioCargo
GRANT SELECT ON ViVeiculosUtilizador TO FuncionarioCargo;
-- REVOKE SELECT ON ViLojaUtilizador FROM FuncionarioCargo
GRANT SELECT ON ViLojaUtilizador TO FuncionarioCargo;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM FuncionarioCargo
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO FuncionarioCargo;
-- REVOKE SELECT, INSERT ON ViVeiculosLojaFuncionario FROM FuncionarioCargo
GRANT SELECT, INSERT ON Aluguer TO FuncionarioCargo;

-- REVOKE FuncionarioCargo FROM 'marcelo_meireles'@'localhost'
GRANT FuncionarioCargo TO 'marcelo_meireles'@'localhost';
SET DEFAULT ROLE FuncionarioCargo TO 'marcelo_meireles'@'localhost';
-- REVOKE FuncionarioCargo FROM 'marcio_meireles'@'localhost'
GRANT FuncionarioCargo TO 'marcio_meireles'@'localhost';
SET DEFAULT ROLE FuncionarioCargo TO 'marcio_meireles'@'localhost';
-- REVOKE FuncionarioCargo FROM 'jaime_figueiredo'@'localhost'
GRANT FuncionarioCargo TO 'jaime_figueiredo'@'localhost';
SET DEFAULT ROLE FuncionarioCargo TO 'jaime_figueiredo'@'localhost';
-- REVOKE FuncionarioCargo FROM 'julia_jardim'@'localhost'
GRANT FuncionarioCargo TO 'julia_jardim'@'localhost';
SET DEFAULT ROLE FuncionarioCargo TO 'julia_jardim'@'localhost';
-- REVOKE FuncionarioCargo FROM 'simao_ferreira'@'localhost'
GRANT FuncionarioCargo TO 'simao_ferreira'@'localhost';
SET DEFAULT ROLE FuncionarioCargo TO 'simao_ferreira'@'localhost';
-- REVOKE FuncionarioCargo FROM 'sidonio_antunes'@'localhost'
GRANT FuncionarioCargo TO 'sidonio_antunes'@'localhost';
SET DEFAULT ROLE FuncionarioCargo TO 'sidonio_antunes'@'localhost';


INSERT INTO AuxUtilizador VALUES
(4, 'marcelo_meireles', 'FUNCIONARIO'),
(5, 'marcio_meireles', 'FUNCIONARIO'),
(6, 'simao_ferreira', 'FUNCIONARIO'),
(7, 'sidonio_antunes', 'FUNCIONARIO'),
(8, 'julia_jardim', 'FUNCIONARIO'),
(9, 'jaime_figueiredo', 'FUNCIONARIO');