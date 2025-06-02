USE AutoArmando

-- Query 1 - Resumo Semanal

-- DROP PROCEDURE PrFazResumoSemanal
DELIMITER $$
CREATE PROCEDURE PrFazResumoSemanal()
BEGIN
	SET @data_inicio_semana = DATE_SUB(CURDATE(), INTERVAL 6 DAY); -- retira 6 dias ao valor da data atual
    SELECT V.tipo_veiculo AS 'Tipo de Veículo', 
             
		SUM(CASE WHEN A.data_inicio BETWEEN @data_inicio_semana AND CURDATE() 
            THEN A.montante ELSE 0 END) AS 'Lucro da Semana',
		
        COUNT(DISTINCT CASE WHEN A.data_inicio BETWEEN @data_inicio_semana AND CURDATE() 
			  THEN A.id_aluguer ELSE 0 END) AS 'Número de Alugueres na Última Semana',
        
		COUNT(DISTINCT CASE WHEN estado = 'LIVRE' 
			  THEN V.id_veiculo ELSE NULL END) AS 'Número de Veículos Livres',
        
		COUNT(DISTINCT CASE WHEN estado = 'MANUTENCAO' 
			  THEN V.id_veiculo ELSE NULL END) AS 'Número de Veículos em Manutenção',
        
		COUNT(CASE WHEN estado = 'ALUGADO' 
					AND A.data_fim > CURDATE() 
			  THEN V.id_veiculo ELSE NULL END) AS 'Número Total de Veículos Atualmente Alugados',
              
  		COUNT(CASE WHEN estado = 'ALUGADO' 
					AND A.data_fim <= CURDATE() 
			  THEN V.id_veiculo ELSE NULL END) AS 'Número Total de Veículos Atrasados'

	FROM Veiculo AS V
    LEFT OUTER JOIN Aluguer AS A        -- Para manter todos os tipo_veiculo da esquerda mesmo aqueles sem alugueres
		ON V.id_veiculo = A.id_veiculo
	GROUP BY V.tipo_veiculo
    ORDER BY `Lucro da Semana` DESC;
END$$
DELIMITER ;

-- DROP EVENT EvFazResumoSemanal;
CREATE EVENT EvFazResumoSemanal
ON SCHEDULE
	EVERY 1 WEEK
    STARTS TIMESTAMP('2025-05-31 23:55:00')
DO
	CALL PrFazResumoSemanal();