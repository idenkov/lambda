import boto3
import os

#Get AWS credentials from environment variables
aws_key_id = os.getenv('AWS_SECRET_ACCESS_ID')
aws_key = os.environ.get('AWS_SECRET_ACCESS_KEY')

#Set region
region_name='eu-central-1'

ssm = boto3.client('ssm', region_name, aws_access_key_id=aws_key_id, aws_secret_access_key=aws_key)
rds = boto3.client('rds', region_name, aws_access_key_id=aws_key_id, aws_secret_access_key=aws_key)

#get credentials from ssm parameter store
rds_user = ssm.get_parameter(Name='/lambda/postgresql/user/master')
rds_password = ssm.get_parameter(Name='/lambda/postgresql/password/master', WithDecryption=True)

#Get instance details
response = rds.describe_db_instances()
n='\n'
for r in response['DBInstances']:
        db_type = r['DBInstanceClass']
        db_storage = r['AllocatedStorage']
        db_engine =  r['EngineVersion']
        db_instane_address = r['Endpoint']['Address']
        db_name = r['DBName']
        print ("Instance address:",db_instane_address,n,"Database name:",db_name,n,"Instance size:",db_type,n,"Allocated storage:",db_storage,"GB",n,"RDS version:",db_engine,n,"Database user:",rds_user['Parameter']['Value'],n,"Database password:",rds_password['Parameter']['Value'])
