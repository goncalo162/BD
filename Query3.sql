USE AutoArmando;

-- Query 3 - Veículo mais barato para um stand específico

SET @id_loja_especifico := 1; -- substitui pelo ID desejado

SELECT MIN(V.preco)
FROM Veiculo AS V
NATURAL JOIN Loja AS L
	WHERE L.id_loja = id_loja_especifico;