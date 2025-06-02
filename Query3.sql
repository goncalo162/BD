USE AutoArmando;

-- Query 3 - Veículo mais barato para um stand específico

-- DROP PROCEDURE PrVeiculoMaisBaratoLoja
DELIMITER $$
CREATE PROCEDURE PrVeiculoMaisBaratoLoja(IN id_loja_especifico INT)
BEGIN
	SELECT MIN(V.preco)
	FROM Veiculo AS V
    NATURAL JOIN Loja AS L
		WHERE L.id_loja = id_loja_especifico;
END $$
DELIMITER ;

CALL PrVeiculoMaisBaratoLoja(3);