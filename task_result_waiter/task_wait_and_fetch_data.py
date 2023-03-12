import boto3
import sys
import time

# Let's use Amazon S3
braket = boto3.resource('braket')
s3 = boto3.resource('s3')

while True:
    response = braket.get_quantum_task(
        quantumTaskArn=sys.argv[1]
    )
    if response['status'] == 'COMPLETED':
        s3.meta.client.download_file(response['outputS3Bucket'], f"{response['outputS3Directory']}/results.json", f"results_{sys.argv[1]}.json")
        break
    time.sleep(5.0)