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

-- DROP TABLE GestorFilialLoja
CREATE TABLE GestorFilialLoja
(
  nome_completo VARCHAR(100) PRIMARY KEY NOT NULL,
  id_loja       INT NOT NULL
);

-- REVOKE SELECT, INSERT, DELETE, UPDATE ON GestorFilialLoja FROM Administrador;
GRANT SELECT, INSERT, DELETE, UPDATE ON GestorFilialLoja TO Administrador;


-- DROP VIEW VeiculosLojaGestorFilial
CREATE OR REPLACE VIEW VeiculosLojaGestorFilial AS
SELECT *
FROM Veiculo AS V
NATURAL JOIN GestorFilialLoja AS G
	WHERE CURRENT_USER() = G.nome_completo  -- CURRENT_USER é o nome do utilizador atual
		  AND V.id_loja = G.id_loja;
          
          
-- DROP VIEW FuncionariosLojaGestorFilial
CREATE OR REPLACE VIEW FuncionariosLojaGestorFilial AS
SELECT *
FROM Funcionario AS F
NATURAL JOIN GestorFilialLoja AS G
	WHERE CURRENT_USER() = G.nome_completo  -- CURRENT_USER é o nome do utilizador atual
		  AND F.id_loja = G.id_loja;         
          
          
-- DROP VIEW LojaGestorFilial
CREATE OR REPLACE VIEW LojaGestorFilial AS
SELECT *
FROM Loja AS L
NATURAL JOIN GestorFilialLoja AS G
	WHERE CURRENT_USER() = G.nome_completo  -- CURRENT_USER é o nome do utilizador atual
		  AND L.id_loja = G.id_loja;               


-- REVOKE SELECT, INSERT, DELETE, UPDATE ON VeiculosLojaGestorFilial FROM GestorFilial;
GRANT SELECT, INSERT, DELETE, UPDATE ON VeiculosLojaGestorFilial TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON FuncionariosLojaGestorFilial FROM GestorFilial;
GRANT SELECT, INSERT, DELETE, UPDATE ON FuncionariosLojaGestorFilial TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON LojaGestorFilial FROM GestorFilial;
GRANT SELECT, INSERT, DELETE, UPDATE ON LojaGestorFilial TO GestorFilial;
-- REVOKE SELECT, INSERT, DELETE, UPDATE ON Cliente FROM Administrador
GRANT SELECT, INSERT, DELETE, UPDATE ON Cliente TO Administrador;
-- REVOKE SELECT, INSERT, UPDATE ON Aluguer FROM Administrador
GRANT SELECT, INSERT, UPDATE ON Aluguer TO Administrador;

-- REVOKE Funcionario FROM GestorFilial WITH ADMIN OPTION;
GRANT Funcionario TO GestorFilial WITH ADMIN OPTION;


-- DROP ROLE Funcionario
CREATE ROLE Funcionario;