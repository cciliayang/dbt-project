import os
import json
import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator
from google.cloud import storage

# Path to Google Cloud Storage bucket and file
bucket_name = "us-central1-dbt-airflow-dem-d47c3bd1-bucket"
blob_path = "data/target/manifest.json"

# Initialize Google Cloud Storage client
client = storage.Client()
bucket = client.bucket(bucket_name)
blob = bucket.blob(blob_path)

# Download the manifest file to a local temporary path
manifest_local_path = "/tmp/manifest.json"
blob.download_to_filename(manifest_local_path)

# Load the manifest file
with open(manifest_local_path) as f:
    manifest = json.load(f)
    nodes = manifest["nodes"]

# Build an Airflow DAG
with DAG(
    # Name that will show in the UI
    dag_id="dbt_ecommerce_example2",
    # Creation date
    start_date= pendulum.today(),
    schedule_interval='*/10 * * * *',
    catchup=False,
) as dag:

    # Create a dict of Operators
    dbt_tasks = dict()
    for node_id, node_info in nodes.items():
        dbt_tasks[node_id] = BashOperator(
            task_id=".".join(
                [
                    node_info["resource_type"],
                    node_info["package_name"],
                    node_info["name"],
                ]
            ),
            bash_command="dbt run "
                + f" --models {node_info['name']}"
                + f" --target prod",
        )

    # Print available task IDs for debugging
    print("Available keys in dbt_tasks:", dbt_tasks.keys())

    # Define relationships between Operators
    for node_id, node_info in nodes.items():
        if node_info['resource_type'] == 'model':
            upstream_nodes = node_info['depends_on']['nodes']
            if upstream_nodes:
                for upstream_node in upstream_nodes:
                    if upstream_node in dbt_tasks:
                        dbt_tasks[upstream_node] >> dbt_tasks[node_id]
                    else:
                        print(f"Warning: Upstream node {upstream_node} not found in dbt_tasks")
