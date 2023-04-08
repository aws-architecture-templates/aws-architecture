import requests
import pandas as pd
import json
import boto3

#conexão firehose e forçando a usar o profile tf04 que tem permissoes
session = boto3.Session(profile_name='tf04')
firehose = session.client('firehose', region_name='us-east-1')

#chamado API forecast
url = "https://www.mercadobitcoin.net/api/BTC/trades/"

response = requests.get(url)

data = response.json()

'''response = firehose.put_record(
    DeliveryStreamName='mercado-bitcoin-delivery-stream',
    Record={
        'Data': data.encode('utf-8')
    }
)
'''
'''
df2 = pd.DataFrame(data_dict)
df2.to_excel('dados.xlsx', index=False)'''

keys = data[0].keys()
print(keys)
