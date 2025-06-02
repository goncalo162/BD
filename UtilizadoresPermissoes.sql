USE AutoArmando;

-- DROP USER firmino_coelho@localhost
CREATE USER firmino_coelho@localhost IDENTIFIED BY '@Password123';
-- DROP USER filipa_coelho@localhost
CREATE USER filipa_coelho@localhost IDENTIFIED BY '@Password123';
-- DROP USER jorge_coelho@localhost
CREATE USER jorge_coelho@localhost IDENTIFIED BY '@Password123';
-- DROP USER marcelo_meireles@localhost
CREATE USER marcelo_meireles@localhost IDENTIFIED BY '@Password123';


-- DROP ROLE FuncionarioCargo
CREATE ROLE FuncionarioCargo;


-- ==Administrador==


-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM firmino_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO firmino_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Veiculo FROM firmino_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Veiculo TO firmino_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Funcionario FROM firmino_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Funcionario TO firmino_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Loja FROM firmino_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Loja TO firmino_coelho@localhost;
-- REVOKE SELECT, INSERT, UPDATE ON Aluguer FROM firmino_coelho@localhost
GRANT SELECT, INSERT, UPDATE ON Aluguer TO firmino_coelho@localhost;
-- REVOKE FuncionarioCargo FROM firmino_coelho@localhost WITH ADMIN OPTION;
GRANT FuncionarioCargo TO firmino_coelho@localhost WITH ADMIN OPTION;

-- == Gestor Filial==


REVOKE ALL PRIVILEGES, GRANT OPTION FROM filipa_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViVeiculosUtilizador FROM filipa_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Veiculo TO filipa_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViFuncionariosLojaUtilizador FROM filipa_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Funcionario TO filipa_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViLojaUtilizador FROM filipa_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Loja TO filipa_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM filipa_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO filipa_coelho@localhost;
-- REVOKE SELECT, INSERT, UPDATE ON Aluguer FROM filipa_coelho@localhost
GRANT SELECT, INSERT, UPDATE ON Aluguer TO filipa_coelho@localhost;

REVOKE ALL PRIVILEGES, GRANT OPTION FROM jorge_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViVeiculosUtilizador FROM jorge_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Veiculo TO jorge_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViFuncionariosLojaUtilizador FROM jorge_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Funcionario TO jorge_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON ViLojaUtilizador FROM jorge_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Loja TO jorge_coelho@localhost;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM jorge_coelho@localhost
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO jorge_coelho@localhost;
-- REVOKE SELECT, INSERT, UPDATE ON Aluguer FROM jorge_coelho@localhost
GRANT SELECT, INSERT, UPDATE ON Aluguer TO jorge_coelho@localhost;

-- == Funcionario ==

REVOKE ALL PRIVILEGES, GRANT OPTION FROM FuncionarioCargo;
-- REVOKE EXECUTE ON PROCEDURE PrUpdateEstadoVeiculo FROM FuncionarioCargo   
GRANT EXECUTE ON PROCEDURE PrUpdateEstadoVeiculo TO FuncionarioCargo;
-- REVOKE SELECT ON Funcionario FROM FuncionarioCargo  
GRANT SELECT ON Funcionario TO FuncionarioCargo;
-- REVOKE SELECT ON Veiculo FROM FuncionarioCargo
GRANT SELECT ON Veiculo TO FuncionarioCargo;
-- REVOKE SELECT ON Loja FROM FuncionarioCargo
GRANT SELECT ON Loja TO FuncionarioCargo;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM FuncionarioCargo
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO FuncionarioCargo;
-- REVOKE SELECT, INSERT ON Aluguer FROM FuncionarioCargo
GRANT SELECT, INSERT ON Aluguer TO FuncionarioCargo;

-- REVOKE FuncionarioCargo FROM marcelo_meireles@localhost
GRANT FuncionarioCargo TO marcelo_meireles@localhost;
SET DEFAULT ROLE FuncionarioCargo TO marcelo_meireles@localhost;