USE AutoArmando;

-- Variáveis de input
SET @id_cliente_pretendido := 1; -- substitui pelo ID desejado
SET @data_atual := CURDATE();   -- ou usa uma data fixa, ex: '2025-05-30'

-- Query 5: Histórico de alugueres terminados de um cliente específico
SELECT *
FROM ViAluguerCliente
WHERE id_cliente = @id_cliente_pretendido
  AND data_inicio <= @data_atual
ORDER BY data_inicio ASC;
