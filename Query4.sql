-- Selecionar a base de dados correta
USE AutoArmando;

-- Query 4: Percentagem de alugueres por tipo de veículo
-- Esta query calcula a percentagem que cada tipo de veículo representa no total de alugueres

SELECT 
    tipo_veiculo,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Aluguer),
        2
    ) AS percentagem
FROM ViAluguerVeiculo
GROUP BY tipo_veiculo
ORDER BY percentagem DESC;