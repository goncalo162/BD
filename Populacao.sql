USE AutoArmando;

-- DELETE FROM Loja WHERE email = 'autoarmando_montalegre@gmail.com'
-- DELETE FROM Loja WHERE email = 'autoarmando_braga@gmail.com'
-- DELETE FROM Loja WHERE email = 'autoarmando_viana_do_castelo@gmail.com'
INSERT INTO Loja(email, cidade, rua, numero_porta, codigo_postal) VALUES
('autoarmando_montalegre@gmail.com', 'Montalegre', 'Rua do Monte', 12, '5470-202'),
('autoarmando_braga@gmail.com', 'Braga', 'Rua da Quinta da Armada', 67, '4700-162'),
('autoarmando_viana_do_castelo@gmail.com', 'Viana do Castelo', 'Travessa de Viana', 22, '4900-580');


-- DELETE FROM Veiculo WHERE matricula = 'xxxxx'
INSERT INTO Veiculo(matricula, preco, estado, marca, tipo_veiculo, ano, id_loja) VALUES
('99ZZ99', 400, 'MANUTENCAO', 'Renault', 'Carrinha', 2015, 1),
('16BA23', 800, 'LIVRE', 'CAT', 'Escavadora', 2017, 2),
('25QI03', 550, 'ALUGADO', 'Betumix', 'Betuneira', 2021, 3),
('11AA11', 650.00, 'LIVRE', 'Toyota', 'Camioneta', 2018, 1),
('22BB22', 1200.00, 'ALUGADO', 'JCB', 'Retroescavadora', 2020, 2),
('33CC33', 500.00, 'LIVRE', 'Iveco', 'Camião de caixa aberta', 2016, 3),
('44DD44', 700.00, 'LIVRE', 'Mercedes', 'Carrinha de passageiros', 2019, 1),
('55EE55', 950.00, 'ALUGADO', 'Volvo', 'Camião', 2022, 2);


-- DELETE FROM Cliente WHERE numero_telemovel = x
INSERT INTO Cliente(numero_telemovel, empresa, nome_completo, cidade, rua, numero_porta, codigo_postal, numero_carta, data_validade_carta, nif, numero_documento, data_validade_documento) VALUES
(912345678, 0, 'João Silva', 'Braga', 'Rua das Flores', 10, '4700-000', 12345678, '2028-05-01', 123456789, 987654321, '2029-12-31'),
(913456789, 1, 'Empresa XPTO Lda', 'Porto', 'Avenida Central', 101, '4000-123', NULL, NULL, 987654321, 123123123, '2030-01-01'),
(916789012, 0, 'Carlos Sousa', 'Faro', 'Travessa do Mar', 2, '8000-123', 56781234, '2026-10-20', 334455667, 778899001, '2027-12-12'),
(914567890, 0, 'Ana Martins', 'Guimarães', 'Rua da Liberdade', 45, '4810-001', 87654321, '2029-06-15', 192837465, 112233445, '2031-02-01'),
(915678901, 1, 'Transportes LIMA SA', 'Lisboa', 'Rua das Indústrias', 88, '1000-200', NULL, NULL, 564738291, 998877665, '2032-03-15'),
(916789012, 0, 'Carlos Sousa', 'Faro', 'Travessa do Mar', 2, '8000-123', 56781234, '2026-10-20', 334455667, 778899001, '2027-12-12'),
(917654321, 0, 'Teresa Carvalho', 'Coimbra', 'Rua da Universidade', 99, '3000-370', 44556677, '2027-08-01', 556677889, 223344556, '2029-04-15'),
(918765432, 1, 'Construtora ABC SA', 'Aveiro', 'Zona Industrial', 10, '3800-305', NULL, NULL, 667788990, 334455667, '2031-11-20');


-- DELETE FROM Aluguer WHERE id_aluguer = x
INSERT INTO Aluguer(pagamento_fisico, data_inicio, data_fim, id_cliente, id_veiculo, id_funcionario) VALUES
(1, '2025-04-01', '2025-04-03', 1, 1, 1),
(0, '2025-04-10', '2025-04-12', 2, 2, 2),
(1, '2025-05-01', '2025-05-02', 3, 3, 3),
(0, '2025-05-28', '2025-05-05', 4, 4, 2),
(1, '2025-05-29', '2025-05-08', 5, 5, 1),
(0, '2025-05-29', '2025-05-30', 1, 4, 2);


-- DELETE FROM Aluguer WHERE id_aluguer = x
INSERT INTO Funcionario(nome_completo, funcao, id_loja) VALUES
('Firmino Coelho', 'Chefe da AutoArmando', 1),
('Filipa Coelho', 'Gestora de Braga', 2),
('Jorge Coelho', 'Gestor de Viana do Castelo', 3),
('Marcelo Meireles', 'Rececionista', 1),
('Márcio Meireles', 'Comercial', 1),
('Simão Ferreira', 'Rececionista', 2),
('Sidónio Antunes', 'Comercial', 2),
('Júlia Jardim', 'Rececionista', 3),
('Jaime Figueiredo', 'Comercial', 3);