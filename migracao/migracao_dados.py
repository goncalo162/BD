import pymysql
import psycopg2
import csv
import json
import os
import sys

mapa_id_clientes = {}
mapa_id_funcionarios = {}
mapa_id_veiculos = {}

def conectar_mysql(host, user, password, db):
    return pymysql.connect(host=host, user=user, password=password, database=db)

def conectar_postgres(host, user, password, db):
    return psycopg2.connect(host=host, user=user, password=password, dbname=db)


def is_cursor(obj):
    return hasattr(obj, 'execute')

def is_csv(path):
    return isinstance(path, str) and path.endswith('.csv')

def is_json(path):
    return isinstance(path, str) and path.endswith('.json')



# Clientes

def migrar_clientes(source, conn_mysql):
    cursor_mysql = conn_mysql.cursor()

    if is_csv(source):
        with open(source, newline='', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                cursor_mysql.execute("""
                    INSERT INTO Cliente (nome_completo, numero_telemovel, cidade, rua, numero_porta, codigo_postal, empresa, nif)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                """, (
                    row['nome_completo'], row['numero_telemovel'], row['cidade'],
                    row['rua'], row['numero_porta'], row['codigo_postal'],
                    row['empresa'].strip().lower() in ['true', '1', 'yes'], row['nif']
                ))
                mapa_id_clientes[int(row['id_cliente'])] = cursor_mysql.lastrowid

    elif is_json(source):
        with open(source, 'r', encoding='utf-8') as f:
            data = json.load(f)
        for row in data:
            cursor_mysql.execute("""
                INSERT INTO Cliente (nome_completo, numero_telemovel, cidade, rua, numero_porta, codigo_postal, empresa, nif)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                row['nome_completo'], row['numero_telemovel'], row['cidade'],
                row['rua'], row['numero_porta'], row['codigo_postal'],
                row['empresa'], row['nif']
            ))
            mapa_id_clientes[int(row['id_cliente'])] = cursor_mysql.lastrowid

    elif is_cursor(source):
        source.execute("SELECT* FROM Cliente")
        for row in source.fetchall():
            cursor_mysql.execute("""
                INSERT INTO Cliente (nome_completo, numero_telemovel, cidade, rua, numero_porta, codigo_postal, empresa, nif)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                row[3], row[1], row[4], row[5], row[6], row[7], row[2], row[10]
            ))
            mapa_id_clientes[row[0]] = cursor_mysql.lastrowid

    conn_mysql.commit()



# Funcionarios

def migrar_funcionarios(source, conn_mysql, id_loja):
    cursor_mysql = conn_mysql.cursor()

    if is_json(source):
        with open(source, 'r', encoding='utf-8') as f:
            data = json.load(f)
        for f in data:
            cursor_mysql.execute("""
                INSERT INTO Funcionario (nome_completo, funcao, id_loja)
                VALUES (%s, %s, %s)
            """, (f['nome_completo'], f['funcao'], id_loja))
            mapa_id_funcionarios[int(f['id_funcionario'])] = cursor_mysql.lastrowid

    elif is_csv(source):
        with open(source, newline='', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for f in reader:
                cursor_mysql.execute("""
                    INSERT INTO Funcionario (nome_completo, funcao, id_loja)
                    VALUES (%s, %s, %s)
                """, (f['nome_completo'], f['funcao'], id_loja))
                mapa_id_funcionarios[int(f['id_funcionario'])] = cursor_mysql.lastrowid

    elif is_cursor(source):
        source.execute("SELECT* FROM Funcionario")
        for row in source.fetchall():
            cursor_mysql.execute("""
                INSERT INTO Funcionario (nome_completo, funcao, id_loja)
                VALUES (%s, %s, %s)
            """, (row[1], row[2], id_loja))
            mapa_id_funcionarios[row[0]] = cursor_mysql.lastrowid

    conn_mysql.commit()



# Veiculos

def migrar_veiculos(source, conn_mysql, id_loja):
    cursor_mysql = conn_mysql.cursor()

    if is_json(source):
        with open(source, 'r', encoding='utf-8') as f:
            data = json.load(f)
        for v in data:
            cursor_mysql.execute("""
                INSERT INTO Veiculo (matricula, preco, estado, marca, tipo_veiculo, ano, id_loja)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                v['matricula'], v['preco'], v['estado'], v['marca'],
                v['tipo_veiculo'], v['ano'], id_loja
            ))
            mapa_id_veiculos[int(v['id_veiculo'])] = cursor_mysql.lastrowid

    elif is_csv(source):
        with open(source, newline='', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            for v in reader:
                cursor_mysql.execute("""
                    INSERT INTO Veiculo (matricula, preco, estado, marca, tipo_veiculo, ano, id_loja)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, (
                    v['matricula'], v['preco'], v['estado'], v['marca'],
                    v['tipo_veiculo'], v['ano'], id_loja
                ))
                mapa_id_veiculos[int(v['id_veiculo'])] = cursor_mysql.lastrowid

    elif is_cursor(source):
        source.execute("SELECT* FROM Veiculo")
        for row in source.fetchall():
            cursor_mysql.execute("""
                INSERT INTO Veiculo (matricula, preco, estado, marca, tipo_veiculo, ano, id_loja)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (row[1], row[2], row[3], row[4], row[5], row[6], id_loja))
            mapa_id_veiculos[row[0]] = cursor_mysql.lastrowid

    conn_mysql.commit()



# Aluguer

def migrar_alugueres(source, conn_mysql):
    cursor_mysql = conn_mysql.cursor()

    if is_json(source):
        with open(source, 'r', encoding='utf-8') as f:
            data = json.load(f)
    elif is_csv(source):
        with open(source, newline='', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            data = list(reader)
    elif is_cursor(source):
        source.execute("SELECT * FROM Aluguer")
        data = source.fetchall()
    else:
        return

    for a in data:
        aluguer = a if isinstance(source, str) else {
            'data_inicio': a[3], 'data_fim': a[4], 'pagamento_fisico': a[1],
            'montante': a[2], 'id_cliente': a[5], 'id_funcionario': a[6], 'id_veiculo': a[7]
        }

        id_cliente = int(aluguer['id_cliente'])
        id_funcionario = int(aluguer['id_funcionario'])
        id_veiculo = int(aluguer['id_veiculo'])

        if id_cliente not in mapa_id_clientes or id_veiculo not in mapa_id_veiculos or id_funcionario not in mapa_id_funcionarios:
            continue

        cursor_mysql.execute("""
            INSERT INTO Aluguer (data_inicio, data_fim, pagamento_fisico, montante, id_cliente, id_funcionario, id_veiculo)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            aluguer['data_inicio'], aluguer['data_fim'], aluguer['pagamento_fisico'],
            aluguer['montante'], mapa_id_clientes[id_cliente],
            mapa_id_funcionarios[id_funcionario], mapa_id_veiculos[id_veiculo]
        ))

    conn_mysql.commit()



# Main

def main():
    if len(sys.argv) != 8:
        print("Uso: <id_loja> <host_mysql> <user_mysql> <pw_mysql> <bd_mysql> <tipo_fonte: csv|json|postgres> <diretoria_ou_host_pg>")
        sys.exit(1)

    id_loja = int(sys.argv[1])
    host_mysql, user_mysql, pw_mysql, db_mysql = sys.argv[2:6]
    tipo_fonte = sys.argv[6].lower()
    origem = sys.argv[7]

    conn_mysql = conectar_mysql(host_mysql, user_mysql, pw_mysql, db_mysql)

    if tipo_fonte in ["csv", "json"]:
        base_path = origem
        ext = tipo_fonte

        migrar_clientes(os.path.join(base_path, f"clientes.{ext}"), conn_mysql)
        migrar_funcionarios(os.path.join(base_path, f"funcionarios.{ext}"), conn_mysql, id_loja)
        migrar_veiculos(os.path.join(base_path, f"veiculos.{ext}"), conn_mysql, id_loja)
        migrar_alugueres(os.path.join(base_path, f"alugueres.{ext}"), conn_mysql)

    elif tipo_fonte == "postgres":
        host_pg = origem
        user_pg = input("Utilizador PostgreSQL: ")
        pw_pg = input("Password PostgreSQL: ")
        db_pg = input("Base de Dados PostgreSQL: ")
        conn_pg = conectar_postgres(host_pg, user_pg, pw_pg, db_pg)
        cur_pg = conn_pg.cursor()

        migrar_clientes(cur_pg, conn_mysql)
        migrar_funcionarios(cur_pg, conn_mysql, id_loja)
        migrar_veiculos(cur_pg, conn_mysql, id_loja)
        migrar_alugueres(cur_pg, conn_mysql)

        cur_pg.close()
        conn_pg.close()

    else:
        print("Fonte inválida. Use 'csv', 'json' ou 'postgres'.")
        sys.exit(1)

    conn_mysql.close()
    print("Migração concluída com sucesso.")

if __name__ == "__main__":
    main()