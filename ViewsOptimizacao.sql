USE AutoArmando;

-- DROP VIEW ViAluguerVeiculo
CREATE VIEW ViAluguerVeiculo AS
SELECT *
FROM Aluguer
NATURAL JOIN Veiculo;


-- DROP VIEW ViAluguerCliente
CREATE VIEW ViAluguerCliente AS
SELECT *
FROM Aluguer
NATURAL JOIN Cliente;


-- DROP VIEW ViFuncionariosAluguer
CREATE VIEW ViFuncionariosAluguer AS
SELECT*
FROM Funcionario
NATURAL JOIN Aluguer;