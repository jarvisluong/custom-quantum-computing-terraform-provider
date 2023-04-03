import boto3
from botocore.config import Config
from qiskit.visualization import plot_histogram
from pydash import count_by
import json
import sys
import time

# Let's use Amazon S3
braket_config = Config(
    region_name = 'us-east-1'
)
braket = boto3.client('braket', config=braket_config)
s3 = boto3.resource('s3')

while True:
    response = braket.get_quantum_task(
        quantumTaskArn=sys.argv[1]
    )
    if response['status'] == 'COMPLETED':
        target_download_file_path = "out/results.json"
        s3.meta.client.download_file(response['outputS3Bucket'], f"{response['outputS3Directory']}/results.json", target_download_file_path)
        print("Downloaded to out/results.json")
        print("Now plotting the result")
        with open(target_download_file_path) as result_file:
            content = json.load(result_file)
            joined_measurement = map(lambda measurement: ''.join(map(lambda x: str(x), measurement)),content['measurements'])
            counted_measurement = count_by(joined_measurement)
            plot_histogram(counted_measurement, filename="out/result.jpg")
            print("Result printed to out/result.json")
        break
    print(f"Task {sys.argv[1]} status is still {response['status']}")
    time.sleep(5.0)