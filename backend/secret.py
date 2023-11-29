import boto3
import json
import psycopg2
import contextlib
from botocore.exceptions import ClientError
def main():
    client = boto3.client('secretsmanager')

    response = client.get_secret_value(SecretId='REPLACE')

    secretDict = json.loads(response['SecretString'])

    print(secretDict['host'])
    print(secretDict['username'])
    print(secretDict['password'])
    print(secretDict['dbname'])
    print(secretDict)
    get_secret(secretDict['dbname'], secretDict['host'])

def get_secret(db, host_aws):

    secret_name = "REPLACE"
    region_name = "REPLACE"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    # Decrypts secret using the associated KMS key.
    secret_string = get_secret_value_response['SecretString']
    secret = json.loads(secret_string)
    print(secret['password'])
    # Your code goes here.
    with psycopg2.connect(database=db, user=secret['username'], password=secret['password'], host=host_aws, port="5432", sslmode="require") as connection:
        with contextlib.closing(connection.cursor()) as cursor:
            query_str = 'SELECT * FROM artworks LIMIT 5'
            cursor.execute(query_str, )
            print(cursor.fetchall())



if __name__ == '__main__':
    main()