USE AutoArmando

-- DROP TRIGGER calcula_montante
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