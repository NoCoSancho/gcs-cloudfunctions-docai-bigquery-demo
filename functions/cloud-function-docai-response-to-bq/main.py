import os
import datetime
import base64
import json
import six

from google.cloud import bigquery

bq_table_id = os.environ["BQ_TABLE_ID"]

def main_func(event, context):

    bucket_name = event['bucket']
    file_name = event['name']
    content_type = event['contentType']

    gcs_input_uri = f"gs://{event['bucket']}/{event['name']}"

    file = event
    print(f"Processing file: {gcs_input_uri}.")

    # Construct a BigQuery client object.
    client = bigquery.Client()

    table_id = bq_table_id
    sa_schema = client.get_table(table_id).schema
    
    job_config = bigquery.LoadJobConfig(
      write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
      source_format=bigquery.SourceFormat.NEWLINE_DELIMITED_JSON,
      ignore_unknown_values=True,
      schema=sa_schema
    )

    load_job = client.load_table_from_uri(
      gcs_input_uri, table_id, job_config=job_config
    )  # Make an API request.

    load_job.result()  # Waits for the job to complete.

    destination_table = client.get_table(table_id)