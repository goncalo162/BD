USE AutoArmando;

-- Query 2 - Funcionário que realizou mais alugueres por loja

	WITH 
	NumAlugueres AS -- Calcula o número de alugueres para cada funcionário
	(
		SELECT FA.id_funcionario, FA.id_loja,
		COUNT(FA.id_aluguer) AS num_alugueres
		FROM ViFuncionariosAluguer AS FA
		GROUP BY FA.id_funcionario, FA.id_loja
	),
		
	MaxAlugueresPorLoja AS -- Diz qual é o máximo de alugueres em cada loja
	(
		SELECT id_loja,
		MAX(num_alugueres) AS num_alugueres_max
		FROM NumAlugueres
		GROUP BY id_loja
	)
        
SELECT N.id_funcionario AS 'ID do Funcionário', 
	   N.num_alugueres AS 'Número de Alugueres', 
	   N.id_loja AS 'ID da Loja do Funcionário'
FROM NumAlugueres AS N
NATURAL JOIN MaxAlugueresPorLoja AS M;