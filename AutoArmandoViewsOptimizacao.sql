USE AutoArmando;

-- DROP VIEW AluguerVeiculo
CREATE VIEW AluguerVeiculo AS
SELECT *
FROM Veiculo
NATURAL JOIN Aluguer;


-- DROP VIEW AluguerCliente
CREATE VIEW AluguerCliente AS
SELECT *
FROM Cliente
NATURAL JOIN Aluguer;