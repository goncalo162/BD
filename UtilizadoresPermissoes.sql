USE AutoArmando;

-- DROP USER 'firmino_coelho'@'localhost'
CREATE USER 'firmino_coelho'@'localhost' IDENTIFIED BY 'password';

-- DROP USER 'filipa_coelho'@'localhost'
CREATE USER 'filipa_coelho'@'localhost' IDENTIFIED BY 'password';
-- DROP USER 'jorge_coelho'@'localhost'
CREATE USER 'jorge_coelho'@'localhost' IDENTIFIED BY 'password';

-- DROP USER 'marcelo_meireles'@'localhost'
CREATE USER 'marcelo_meireles'@'localhost' IDENTIFIED BY 'password';
-- DROP USER 'marcio_meireles'@'localhost'
CREATE USER 'marcio_meireles'@'localhost' IDENTIFIED BY 'password';
-- DROP USER 'jaime_figueiredo'@'localhost'
CREATE USER 'jaime_figueiredo'@'localhost' IDENTIFIED BY 'password';
-- DROP USER 'julia_jardim'@'localhost'
CREATE USER 'julia_jardim'@'localhost' IDENTIFIED BY 'password';
-- DROP USER 'simao_ferreira'@'localhost'
CREATE USER 'simao_ferreira'@'localhost' IDENTIFIED BY 'password';
-- DROP USER 'sidonio_antunes'@'localhost'
CREATE USER 'sidonio_antunes'@'localhost' IDENTIFIED BY 'password';



-- ==Administrador==

-- DROP ROLE Administrador
CREATE ROLE Administrador;

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
-- REVOKE Funcionario FROM Administrador WITH ADMIN OPTION;
GRANT Funcionario TO Administrador WITH ADMIN OPTION;

-- REVOKE Administrador TO 'firmino_coelho'@'localhost';
GRANT Administrador TO 'firmino_coelho'@'localhost';



-- == Gestor Filial==

-- DROP ROLE GestorFilial
CREATE ROLE GestorFilial;

-- DROP TABLE AuxTGestorFilialLoja
CREATE TABLE AuxTGestorFilialLoja
(
  nome_completo VARCHAR(100) PRIMARY KEY NOT NULL,
  id_loja       INT NOT NULL
);

-- REVOKE SELECT, INSERT, DELETE, UPDATE ON AuxTGestorFilialLoja FROM Administrador;
GRANT SELECT, INSERT, DELETE, UPDATE ON AuxTGestorFilialLoja TO Administrador;


-- DROP VIEW VeiculosLojaGestorFilial
CREATE OR REPLACE VIEW ViVeiculosLojaGestorFilial AS
SELECT *
FROM Veiculo AS V
NATURAL JOIN AuxTGestorFilialLoja AS G
	WHERE CURRENT_USER() = G.nome_completo  -- CURRENT_USER é o nome do utilizador atual
		  AND V.id_loja = G.id_loja;
          
          
-- DROP VIEW FuncionariosLojaGestorFilial
CREATE OR REPLACE VIEW ViFuncionariosLojaGestorFilial AS
SELECT *
FROM Funcionario AS F
NATURAL JOIN AuxTGestorFilialLoja AS G
	WHERE CURRENT_USER() = G.nome_completo  -- CURRENT_USER é o nome do utilizador atual
		  AND F.id_loja = G.id_loja;         
          
          
-- DROP VIEW LojaGestorFilial
CREATE OR REPLACE VIEW ViLojaGestorFilial AS
SELECT *
FROM Loja AS L
NATURAL JOIN AuxTGestorFilialLoja AS G
	WHERE CURRENT_USER() = G.nome_completo  -- CURRENT_USER é o nome do utilizador atual
		  AND L.id_loja = G.id_loja;    
          

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
			UPDATE ViVeiculosLoja
            SET matricula = matricula_nova
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;        
		IF estado_novo_veiculo IS NOT NULL THEN
			UPDATE ViVeiculosLoja
            SET estado = estado_novo_veiculo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
		IF marca_nova IS NOT NULL THEN
			UPDATE ViVeiculosLoja
            SET marca = marca_nova
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
		IF tipo_veiculo_novo IS NOT NULL THEN
			UPDATE ViVeiculosLoja
            SET tipo_veiculo = tipo_veiculo_novo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
		IF ano_novo IS NOT NULL THEN
			UPDATE ViVeiculosLoja
            SET ano = ano_novo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
    COMMIT;
    END procedimento;
END$$
DELIMITER ;

-- REVOKE EXECUTE ON PrUpdateVeiculos FROM GestorFilial;
GRANT EXECUTE ON PrUpdateVeiculos TO GestorFilial;

-- REVOKE SELECT, INSERT, DELETE, UPDATE ON VeiculosLojaGestorFilial FROM GestorFilial;
GRANT SELECT, INSERT, DELETE ON ViVeiculosLojaGestorFilial TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON FuncionariosLojaGestorFilial FROM GestorFilial;
GRANT SELECT, INSERT, DELETE, UPDATE ON ViFuncionariosLojaGestorFilial TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON LojaGestorFilial FROM GestorFilial;
GRANT SELECT, INSERT, DELETE, UPDATE ON ViLojaGestorFilial TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM GestorFilial
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO GestorFilial;
-- REVOKE SELECT, INSERT, UPDATE ON Aluguer FROM GestorFilial
GRANT SELECT, INSERT, UPDATE ON Aluguer TO GestorFilial;

-- REVOKE Funcionario FROM GestorFilial WITH ADMIN OPTION;
GRANT Funcionario TO GestorFilial WITH ADMIN OPTION;

-- REVOKE GestorFilial FROM 'filipa_coelho'@'localhost'
GRANT GestorFilial TO 'filipa_coelho'@'localhost';
-- REVOKE GestorFilial FROM 'jorge_coelho'@'localhost'
GRANT GestorFilial TO 'jorge_coelho'@'localhost';

-- DELETE FROM AuxTGestorFilialLoja WHERE nome_completo = 'filipa_coelho@localhost'
-- DELETE FROM AuxTGestorFilialLoja WHERE nome_completo = 'jorge_coelho@localhost'
INSERT INTO AuxTGestorFilialLoja VALUES
('filipa_coelho@localhost', 2),
('jorge_coelho@localhost', 3);


-- DROP ROLE Funcionario
CREATE ROLE Funcionario;