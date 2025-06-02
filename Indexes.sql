USE AutoArmando;

-- DROP INDEX index_estado_veiculo ON Veiculo(estado);
CREATE INDEX index_estado_veiculo ON Veiculo(estado);

-- DROP INDEX index_tipo_veiculo ON Veiculo(tipo_veiculo);
CREATE INDEX index_tipo_veiculo ON Veiculo(tipo_veiculo);