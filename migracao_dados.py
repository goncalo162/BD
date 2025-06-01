import mysql.connector
import pandas as pd
import json

def conectar_mysql():
    return mysql.connector.connect(
        host="localhost",
        user="dahmer",
        password="dahmer",
        database="AutoArmando"
    )

def migrar_clientes_csv(path_csv, conn):
    df = pd.read_csv(path_csv)
    cursor = conn.cursor()
    for _, row in df.iterrows():
        cursor.execute("""
            INSERT INTO Cliente (nome_completo, numero_telemovel, cidade, rua, numero_porta, codigo_postal, empresa, nif)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            row['nome_completo'], row['numero_telemovel'],
            row['cidade'], row['rua'], row['numero_porta'], row['codigo_postal'],
            bool(row['empresa']), row['nif']
        ))
    conn.commit()

def migrar_lojas_json(path_json, conn):
    with open(path_json, 'r', encoding='utf-8') as f:
        lojas = json.load(f)
    cursor = conn.cursor()
    for loja in lojas:
        cursor.execute("""
    INSERT INTO Loja (email, cidade, rua, numero_porta, codigo_postal)
    VALUES (%s, %s, %s, %s, %s)
""", (loja['email'], loja['cidade'], loja['rua'], loja['numero_porta'], loja['codigo_postal']))

    conn.commit()


def migrar_veiculos_json(path_json, conn):
    with open(path_json, 'r', encoding='utf-8') as f:
        veiculos = json.load(f)
    cursor = conn.cursor()
    for veiculo in veiculos:
        # Verifica se id_loja existe para evitar erro de FK
        cursor.execute("SELECT COUNT(*) FROM Loja WHERE id_loja = %s", (veiculo['id_loja'],))
        if cursor.fetchone()[0] == 0:
            print(f"Loja com id {veiculo['id_loja']} não encontrada. Veículo {veiculo['matricula']} ignorado.")
            continue

        try:
            cursor.execute("""
                INSERT INTO Veiculo (matricula, preco, estado, marca, tipo_veiculo, ano, id_loja)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                veiculo['matricula'], veiculo['preco'], veiculo['estado'],
                veiculo['marca'], veiculo['tipo_veiculo'], veiculo['ano'], veiculo['id_loja']
            ))
        except Exception as e:
            print(f"❌ Erro ao inserir veículo {veiculo['matricula']}: {e}")

    conn.commit()

def migrar_alugueres_json(path_json, conn):
    with open(path_json, 'r', encoding='utf-8') as f:
        alugueres = json.load(f)
    cursor = conn.cursor()
    for aluguer in alugueres:
        # Verificar se id_veiculo existe
        cursor.execute("SELECT COUNT(*) FROM Veiculo WHERE id_veiculo = %s", (aluguer['id_veiculo'],))
        if cursor.fetchone()[0] == 0:
            print(f"Veículo com id {aluguer['id_veiculo']} não encontrado. Ignorado.")
            continue
        
        # Verificar se id_funcionario existe
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

def migrar_funcionarios_json(path_json, conn):
    with open(path_json, 'r', encoding='utf-8') as f:
        funcionarios = json.load(f)
    cursor = conn.cursor()
    for f in funcionarios:
        try:
            cursor.execute("""
                INSERT INTO Funcionario (id_funcionario, nome_completo, funcao, id_loja)
                VALUES (%s, %s, %s, %s)
            """, (
                f['id_funcionario'], f['nome_completo'], f['funcao'], f['id_loja']
            ))
        except Exception as e:
            print(f"❌ Erro ao inserir funcionário {f.get('id_funcionario', '')}: {e}")
    conn.commit()



def main():
    conn = conectar_mysql()
    migrar_clientes_csv("clientes.csv", conn)
    migrar_lojas_json("lojas.json", conn)         # <-- Migrar lojas primeiro
    migrar_veiculos_json("veiculos.json", conn)   # <-- Depois migrar veículos
    migrar_funcionarios_json("funcionarios.json", conn)
    migrar_alugueres_json("alugueres.json", conn) # <-- Finalmente migrar alugueres
    conn.close()
    print("Migração concluída.")

if __name__ == "__main__":
    main()
