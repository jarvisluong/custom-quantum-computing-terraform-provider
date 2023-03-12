import boto3
from botocore.config import Config
import sys
import time

# Let's use Amazon S3
braket_config = Config(
    region_name = 'us-west-1'
)
braket = boto3.client('braket', config=braket_config)
s3 = boto3.resource('s3')

while True:
    response = braket.get_quantum_task(
        quantumTaskArn=sys.argv[1]
    )
    if response['status'] == 'COMPLETED':
        s3.meta.client.download_file(response['outputS3Bucket'], f"{response['outputS3Directory']}/results.json", "out/results.json")
        break
    time.sleep(5.0)