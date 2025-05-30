USE AutoArmando;

-- DELETE FROM Loja WHERE email = 'autoarmando_montalegre@gmail.com'
-- DELETE FROM Loja WHERE email = 'autoarmando_braga@gmail.com'
-- DELETE FROM Loja WHERE email = 'autoarmando_viana_do_castelo@gmail.com'
INSERT INTO Loja(email, cidade, rua, numero_porta, codigo_postal) VALUES
('autoarmando_montalegre@gmail.com', 'Montalegre', 'Rua do Monte', 12, '5470-202'),
('autoarmando_braga@gmail.com', 'Braga', 'Rua da Quinta da Armada', 67, '4700-162'),
('autoarmando_viana_do_castelo@gmail.com', 'Viana do Castelo', 'Travessa de Viana', 22, '4900-580');


-- DELETE FROM Veiculo WHERE matricula = '16BA23'
-- DELETE FROM Veiculo WHERE matricula = '25QI03'
INSERT INTO Veiculo(matricula, preco, estado, marca, tipo_veiculo, ano, id_loja) VALUES
('16BA23', 800, 'LIVRE', 'CAT', 'Escavadora', 2017, 2),
('25QI03', 550, 'ALUGADO', 'Betumix', 'Betuneira', 2021, 3);