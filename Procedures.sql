-- Atualiza apenas o estado do veículo, útil para os funcionários que não podem atualizar diretamente a tabela dos veiculos

-- DROP PROCEDURE PrUpdateEstadoVeiculo
DELIMITER $$
CREATE PROCEDURE PrUpdateEstadoVeiculo
(
  IN id_veiculo_a_atualizar INT,
  IN estado_novo_veiculo ENUM('ALUGADO', 'LIVRE', 'MANUTENCAO')
) 
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro a atualizar o estado do veículo';
    END;
    
    START TRANSACTION;
    procedimento: BEGIN
		IF id_veiculo_a_atualizar IS NULL THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possivel atualizar os dados de um veículo pois não foi fornecido um ID';
			LEAVE procedimento;
		END IF;      
		IF estado_novo_veiculo IS NOT NULL THEN
			UPDATE Veiculo
            SET estado = estado_novo_veiculo
            WHERE id_veiculo = id_veiculo_a_atualizar;
        END IF;
    COMMIT;
    END procedimento;
END$$
DELIMITER ;