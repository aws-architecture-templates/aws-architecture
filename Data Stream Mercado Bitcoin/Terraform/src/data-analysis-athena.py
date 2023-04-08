import boto3

# Configurar o acesso via profile tf04
session = boto3.Session(profile_name='tf04')

# Inicializando Amazon Athena
client = boto3.client('athena', region_name='us-east-1')

# Criando consulta Athena -- buscando
query = 'SELECT * FROM my_database.my_table LIMIT 10'

# Executar a consulta SQL usando o Amazon Athena
response = client.start_query_execution(QueryString=query,
                                        QueryExecutionContext={
                                            'Database': 'my_database'
                                        },
                                        ResultConfiguration={
                                            'OutputLocation': 's3://my-bucket/my-output-folder/'
                                        })

# Obter o ID da execução da consulta do Amazon Athena
query_execution_id = response['QueryExecutionId']

# Esperar até que a consulta seja executada com sucesso
status = None
while status not in ('SUCCEEDED', 'FAILED', 'CANCELLED'):
    response = client.get_query_execution(QueryExecutionId=query_execution_id)
    status = response['QueryExecution']['Status']['State']
    if status == 'FAILED':
        print('A consulta falhou com o erro: {}'.format(response['QueryExecution']['Status']['StateChangeReason']))
        break
    elif status == 'CANCELLED':
        print('A consulta foi cancelada.')
        break
    elif status == 'SUCCEEDED':
        print('A consulta foi executada com sucesso!')

# Obter os resultados da consulta do Amazon Athena
results = client.get_query_results(QueryExecutionId=query_execution_id)
for row in results['ResultSet']['Rows']:
    print(row['Data'])
