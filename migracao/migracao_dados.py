import mysql.connector
import csv
import json
import sys

def conectar_mysql(nomeHost, nomeUser, password, nomeBD):
    return mysql.connector.connect(
        host=nomeHost,
        user=nomeUser,
        password=password,
        database=nomeBD
    )

def migrar_clientes_csv(path_csv, conn):
    with open(path_csv, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        cursor = conn.cursor()
        for row in reader:
            cursor.execute("""
                INSERT INTO Cliente (nome_completo, numero_telemovel, cidade, rua, numero_porta, codigo_postal, empresa, nif)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                row['nome_completo'], row['numero_telemovel'],
                row['cidade'], row['rua'], row['numero_porta'], row['codigo_postal'],
                row['empresa'].strip().lower() in ['true', '1', 'yes'], row['nif']
            ))
    conn.commit()

def migrar_veiculos_json(path_json, conn, id_loja):
    with open(path_json, 'r', encoding='utf-8') as f:
        veiculos = json.load(f)
    cursor = conn.cursor()
    for veiculo in veiculos:
        try:
            cursor.execute("""
                INSERT INTO Veiculo (matricula, preco, estado, marca, tipo_veiculo, ano, id_loja)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                veiculo['matricula'], veiculo['preco'], veiculo['estado'],
                veiculo['marca'], veiculo['tipo_veiculo'], veiculo['ano'], id_loja
            ))
        except Exception as e:
            print(f"❌ Erro ao inserir veículo {veiculo['matricula']}: {e}")
    conn.commit()

def migrar_alugueres_json(path_json, conn):
    with open(path_json, 'r', encoding='utf-8') as f:
        alugueres = json.load(f)
    cursor = conn.cursor()
    for aluguer in alugueres:
        cursor.execute("SELECT COUNT(*) FROM Veiculo WHERE id_veiculo = %s", (aluguer['id_veiculo'],))
        if cursor.fetchone()[0] == 0:
            print(f"Veículo com id {aluguer['id_veiculo']} não encontrado. Ignorado.")
            continue

        cursor.execute("SELECT COUNT(*) FROM Funcionario WHERE id_funcionario = %s", (aluguer['id_funcionario'],))
        if cursor.fetchone()[0] == 0:
            print(f"Funcionário com id {aluguer['id_funcionario']} não encontrado. Ignorado.")
            continue

        cursor.execute("""
            INSERT INTO Aluguer (data_inicio, data_fim, pagamento_fisico, montante, id_cliente, id_funcionario, id_veiculo)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            aluguer['data_inicio'], aluguer['data_fim'], aluguer['pagamento_fisico'],
            aluguer['montante'], aluguer['id_cliente'], aluguer['id_funcionario'], aluguer['id_veiculo']
        ))
    conn.commit()

def migrar_funcionarios_json(path_json, conn, id_loja):
    with open(path_json, 'r', encoding='utf-8') as f:
        funcionarios = json.load(f)
    cursor = conn.cursor()
    for f in funcionarios:
        try:
            cursor.execute("""
                INSERT INTO Funcionario (id_funcionario, nome_completo, funcao, id_loja)
                VALUES (%s, %s, %s, %s)
            """, (
                f['id_funcionario'], f['nome_completo'], f['funcao'], id_loja
            ))
        except Exception as e:
            print(f"❌ Erro ao inserir funcionário {f.get('id_funcionario', '')}: {e}")
    conn.commit()

def main():
    
    if len(sys.argv) != 6:
        print("Desculpe mas faltam argumentos para correr o script: <id_loja>, <host>, <utilizador>, <password>, <nomeBD>")
        print("<id_loja>: Id da loja de onde provêm estes dados")
        print("<host>: Endereço do Host para o Utilizador que quer migrar os dados")
        print("<utilizador>: Nome do Utilizador que quer migrar os dados")
        print("<password>: Password do Utilizador que quer migrar os dados")
        print("<nomeBD>: Nome da Base de Dados para onde queremos migrar os dados")
        sys.exit(1)

    id_loja = int(sys.argv[1])
    conn = conectar_mysql(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    migrar_clientes_csv("clientes.csv", conn)
    migrar_veiculos_json("veiculos.json", conn, id_loja)
    migrar_funcionarios_json("funcionarios.json", conn, id_loja)
    migrar_alugueres_json("alugueres.json", conn)
    conn.close()
    print("Migração concluída.")

if __name__ == "__main__":
    main()