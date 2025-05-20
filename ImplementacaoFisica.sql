-- DROP DATABASE AUTOARMANDO
CREATE DATABASE Auto_Armando;
USE Auto_Armando;

-- DROP TABLE Cliente
CREATE TABLE Cliente
(
  id_cliente              INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  numero_telemovel        INT NOT NULL,
  empresa                 TINYINT NOT NULL,
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


-- DROP TABLE Loja
CREATE TABLE Loja
(
  id_loja       INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  email         VARCHAR(150) NOT NULL,
								                      -- Morada
  cidade        VARCHAR(100) NOT NULL, 
  rua           VARCHAR(120) NOT NULL, 
  numero_porta  INT NOT NULL,          
  codigo_postal VARCHAR(10) NOT NULL  
);


-- DROP TABLE Funcionario
CREATE TABLE Funcionario
(
	id_funcionario INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  nome_completo  VARCHAR(150) NOT NULL,
  funcao         VARCHAR(150) NOT NULL,
  
  id_loja        INT NOT NULL,
	  FOREIGN KEY (id_loja) REFERENCES Loja(id_loja)
);


-- DROP TABLE Veiculo
CREATE TABLE Veiculo
(
  id_veiculo   INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  matricula    VARCHAR(6) NOT NULL,
  preco        DECIMAL(10,2) NOT NULL,
  estado       ENUM('ALUGADO', 'LIVRE', 'MANUTENCAO') NOT NULL,
  marca        VARCHAR(100) NOT NULL,
  tipo_veiculo VARCHAR(200) NOT NULL,
  ano          INT NOT NULL,
  
  id_loja      INT NOT NULL,
	  FOREIGN KEY (id_loja) REFERENCES Loja(id_loja)    
);


-- DROP TABLE Aluguer
CREATE TABLE Aluguer
(
  id_aluguer       INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  pagamento_fisico TINYINT NOT NULL,
  montante         DECIMAL(10,2) NOT NULL,
  data_inicio      DATE NOT NULL,
  data_fim         DATE NOT NULL,
  
  id_cliente       INT NOT NULL,
	  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  id_veiculo       INT NOT NULL,
	  FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id_veiculo),
  id_funcionario   INT NOT NULL,
	  FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)               
);