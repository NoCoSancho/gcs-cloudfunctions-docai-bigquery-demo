
import re
import os
import datetime
import base64
import json
import json_minify

from io import BytesIO
from google.cloud import documentai_v1 as documentai
from google.cloud import storage
from google.api_core import exceptions

project_id = os.environ["PROJECT_ID"]
project_num = os.environ["PROJECT_NUM"]
location = os.environ["LOCATION"]
processor_id = os.environ["PROCESSOR_ID"]
gcs_output_uri = os.environ["GCS_OUTPUT_URI"]
skip_human_review = os.environ["SKIP_HITL"]

#HITL stuff not really relevant as not supported for OCR processor.
#this is more of a stub
if skip_human_review == 'False':
    skip_human_review = False
else:
    skip_humane_review = True

def main_func(event, context):

    bucket_name = event['bucket']
    file_name = event['name']
    content_type = event['contentType']

    gcs_input_uri = f"gs://{event['bucket']}/{event['name']}"
    eventid = context.event_id
    extract_timestamp = context.timestamp
    gcs_blob_location = context.resource['name']

    #Print File Information to log

    print(f'input uri: {gcs_input_uri}')

    #Get file from GCS
    gcs_doc_blob, gcs_doc_meta = get_gcs_doc(file_name, bucket_name)

    #Send doc to DAI parser and get results
    doc_entities, hitl_operation_id, doc_results_json = process_doc(gcs_doc_blob, content_type, project_num, location, processor_id)

    #save raw extract results to GCS bucket
    save_extract_to_gcs(gcs_output_uri, doc_results_json, file_name, eventid, hitl_operation_id)

def get_gcs_doc(file_name, bucket_name):

    #Get doc from GCS
    gcs_client = storage.Client()
    bucket = gcs_client.get_bucket(bucket_name)
    gcs_file = bucket.get_blob(file_name)
    file_meta = gcs_file.metadata
    file_blob = gcs_file.download_as_bytes()

    return file_blob, file_meta

def process_doc(gcs_blob, content_type, project_number, location, processor_id):    

    documentai_client = documentai.DocumentProcessorServiceClient()

    document = {
        "content": gcs_blob,
        "mime_type": content_type
    }

    invoice_processor = f"projects/{project_number}/locations/{location}/processors/{processor_id}"

    request = {
        "name": invoice_processor,
        "raw_document": document,
        "skip_human_review": skip_human_review
    }

    results = documentai_client.process_document(request)

    hitl_op = results.human_review_status.human_review_operation
    hitl_op_split = hitl_op.split('/')
    hitl_op_id = hitl_op_split.pop()

    results_json = documentai.types.Document.to_json(results.document)

    return results.document, hitl_op_id, results_json

def save_extract_to_gcs(dest_bucket, content, filename, eventid, hitl_operation_id):

    storageclient = storage.Client()
    bucket = storageclient.get_bucket(dest_bucket)

    fname = f'{filename.split(".")[0]}-{eventid}.json'

    content_json = json.loads(content)
    content_json['uri'] = f'{filename}'
    content = json.dumps(content_json)

    write_file = bucket.blob(fname)
    write_file.metadata = {'hitl_operation_id': hitl_operation_id}
    write_file.metadata = {'filename': filename}
    write_file.upload_from_string(format(content).replace('\n', ' '), content_type='application/json')