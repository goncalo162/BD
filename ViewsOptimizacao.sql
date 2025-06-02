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