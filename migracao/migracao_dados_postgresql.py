
import psycopg2
import pandas as pd
import json
import sqlite3

def conectar_postgresql():
    return psycopg2.connect(
        host="localhost",
        user="postgres",
        password="tua_password",
        dbname="autoarmando"
    )

def migrar_clientes_csv(path_csv, conn):
    df = pd.read_csv(path_csv)
    cursor = conn.cursor()
    for _, row in df.iterrows():
        cursor.execute("""
            INSERT INTO Cliente (id_cliente, nome_completo, numero_telemovel, cidade, rua, numero_porta, codigo_postal, empresa)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            row['id_cliente'], row['nome_completo'], row['numero_telemovel'],
            row['cidade'], row['rua'], row['numero_porta'], row['codigo_postal'],
            bool(row['empresa'])
        ))
    conn.commit()

def migrar_alugueres_json(path_json, conn):
    with open(path_json, 'r', encoding='utf-8') as f:
        alugueres = json.load(f)
    cursor = conn.cursor()
    for i, aluguer in enumerate(alugueres):
        cursor.execute("""
            INSERT INTO Aluguer (id_aluguer, data_inicio, data_fim, pagamento_fisico, montante, id_cliente, id_funcionario, id_veiculo)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            i+1,
            aluguer['data_inicio'], aluguer['data_fim'], aluguer['pagamento_fisico'],
            aluguer['montante'], aluguer['id_cliente'], aluguer['id_funcionario'], aluguer['id_veiculo']
        ))
    conn.commit()

def migrar_veiculos_sqlite(path_sqlite, conn):
    con_sqlite = sqlite3.connect(path_sqlite)
    tabelas = con_sqlite.execute("SELECT name FROM sqlite_master WHERE type='table';").fetchall()
    cursor = conn.cursor()
    for (tabela,) in tabelas:
        df = pd.read_sql_query(f"SELECT * FROM {tabela};", con_sqlite)
        for _, row in df.iterrows():
            cursor.execute("""
                INSERT INTO Veiculo (id_veiculo, matricula, marca, modelo, ano, preco, estado, tipo_veiculo, id_loja)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                row['id_veiculo'], row['matricula'], row['marca'], row['modelo'],
                row['ano'], row['preco'], row['estado'], row['tipo_veiculo'], row['id_loja']
            ))
    conn.commit()
    con_sqlite.close()

def main():
    conn = conectar_postgresql()
    migrar_clientes_csv("clientes.csv", conn)
    migrar_alugueres_json("alugueres.json", conn)
    migrar_veiculos_sqlite("veiculos_antigos.db", conn)
    conn.close()
    print("Migração concluída.")

if __name__ == "__main__":
    main()
