USE AutoArmando


-- Calcula automaticamente o montante ao inserir na tabela dos alugueres

-- DROP TRIGGER TrCalculaMontante
DELIMITER $$
CREATE TRIGGER TrCalculaMontante
BEFORE INSERT ON Aluguer
FOR EACH ROW
BEGIN
  DECLARE preco_diario DECIMAL(10,2);
  DECLARE dias INT;

  -- Obter o preço diário do veículo
  SELECT preco INTO preco_diario
  FROM Veiculo
  WHERE id_veiculo = NEW.id_veiculo;

  -- Calcular o número de dias do aluguer (mínimo 1 dia)
  SET dias = DATEDIFF(NEW.data_fim, NEW.data_inicio);
  IF dias < 1 THEN
    SET dias = 1;
  END IF;

  -- Calcular o montante total
  SET NEW.montante = dias * preco_diario;
END$$
DELIMITER ;


-- Remove o valor novo se um utilizador que não o Sr. Firmino tente atualizar o valor do preço na tabela dos veículos

-- DROP TRIGGER TrImpedeAtualizarPrecoVeiculo
DELIMITER $$
CREATE TRIGGER TrImpedeAtualizarPrecoVeiculo
BEFORE UPDATE ON Veiculo
FOR EACH ROW
BEGIN
	IF(USER() != 'firmino_coelho@localhost') THEN
		IF(OLD.preco != NEW.preco) THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Apenas o administrador pode mudar o preço dos veículos';
        END IF;
    END IF;
END$$
DELIMITER ;