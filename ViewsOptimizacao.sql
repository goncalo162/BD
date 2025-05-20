USE AutoArmando;

-- DROP VIEW AluguerVeiculo
CREATE VIEW AluguerVeiculo AS
SELECT *
FROM Aluguer
NATURAL JOIN Veiculo;


-- DROP VIEW AluguerCliente
CREATE VIEW AluguerCliente AS
SELECT *
FROM Aluguer
NATURAL JOIN Cliente;


-- DROP VIEW FuncionariosLoja
CREATE VIEW FuncionariosLoja AS
SELECT *
FROM Funcionario
NATURAL JOIN Loja;


-- DROP VIEW 