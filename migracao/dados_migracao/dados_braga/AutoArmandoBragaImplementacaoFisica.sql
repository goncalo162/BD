CREATE TABLE Cliente
(
  id_cliente              INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
  numero_telemovel        INT NOT NULL,
  empresa                 BOOLEAN NOT NULL,
  nome_completo           VARCHAR(150) NOT NULL,
											                           -- Morada
  cidade                  VARCHAR(100) NOT NULL, 
  rua                     VARCHAR(120) NOT NULL, 
  numero_porta            INT NOT NULL,          
  codigo_postal           VARCHAR(10) NOT NULL,  
											                           -- Carta de Conducao
  numero_carta            INT NULL,          
  data_validade_carta     DATE NULL,
											                           -- Documento de Identificaco
  nif                     INT NOT NULL,
  numero_documento        INT NULL,
  data_validade_documento DATE NULL            
);


-- DROP TABLE Funcionario
CREATE TABLE Funcionario
(
  id_funcionario INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
  nome_completo  VARCHAR(150) NOT NULL,
  funcao         VARCHAR(150) NOT NULL
);

CREATE TYPE estado_veiculo AS ENUM('ALUGADO', 'LIVRE', 'MANUTENCAO');

-- DROP TABLE Veiculo
CREATE TABLE Veiculo
(
  id_veiculo   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
  matricula    VARCHAR(6) NOT NULL,
  preco        DECIMAL(10,2) NOT NULL,
  estado       estado_veiculo NOT NULL,
  marca        VARCHAR(100) NOT NULL,
  tipo_veiculo VARCHAR(200) NOT NULL,
  ano          INT NOT NULL
);

-- DROP TABLE Aluguer
CREATE TABLE Aluguer
(
  id_aluguer       INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
  pagamento_fisico BOOLEAN NOT NULL,
  montante         DECIMAL(10,2) NOT NULL,
  data_inicio      DATE NOT NULL,
  data_fim         DATE NOT NULL,
  
  id_cliente       INT NOT NULL,
	  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
		ON DELETE RESTRICT
		ON UPDATE NO ACTION,
  id_veiculo       INT NOT NULL,
	  FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo)
		ON DELETE RESTRICT
		ON UPDATE NO ACTION,      
  id_funcionario   INT NOT NULL,
	  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)   
		ON DELETE RESTRICT
		ON UPDATE NO ACTION
);