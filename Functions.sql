USE AutoArmando;
-- Dita se um veículo está em atraso

DELIMITER $$

CREATE FUNCTION FnVeiculoAtrasado(id_veiculo_pretendido INT)
RETURNS TINYINT
DETERMINISTIC
BEGIN
	DECLARE veiculo_estado ENUM('ALUGADO', 'LIVRE', 'MANUTENCAO');
    
    SELECT estado INTO veiculo_estado
    FROM ViAluguerVeiculo
    WHERE id_veiculo = id_veiculo_pretendido;

    IF veiculo_estado = 'ALUGADO' AND data_fim < CURDATE() THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END$$

DELIMITER ;

SELECT FnVeiculoAtrasado();