# gcs-cloudfunctions-docai-bigquery-demo

**Purpose**
This document outlines the steps required to deploy a demo environment.  The demo environment will allow for the following functionality in order of execution:


pdf file can be placed into a source GCS bucket
The file written to GCS will trigger a cloud function to execute
The cloud function will send the pdf to a DocumentAI OCR processor  for synchronous processing, and the response written to a separate destination GCS bucket
The resulting file write to GCS will trigger another cloud function to execute
The cloud function will write the results to BigQuery

**Special Considerations**
Since the cloud functions make synchronous DocumentAI parser calls, the input pdf files must be 10 pages or less.  If you submit files larger than 10 pages you will encounter errors.

**GCP Demo Architecture**

![Demo Architecture-Document AI](https://user-images.githubusercontent.com/56175623/156226683-5e65cb5a-73fa-48ed-b4b4-c4e8014a7447.png)


**Deployment Steps**

1) Clone this git repo to your cloudshell env or Cloud SDK env.
2) cd into the repo directory
3) make all the scripts executable: chmod +x *.sh
4) Update the config.sh script variables for your environment.  See example values in bottom of script.  *NOTE* you will have to come back and update this script again mid deployment.
5) Run the scripts in the following order:
./setup_project.sh
./setup_network.sh
./setup_cloud_storage.sh
./setup_bigquery.sh
6) MANUALLY create your document AI processor via the Google Cloud Console.  At this time this step cannot be scripted.
7) Update your config.sh script with the Processor Name and Processor ID values from your new OCR processor.
8) Run the remaining scripts
./setup_cloud_function.sh
./setup_iam.sh

**Demo Steps**
TBD
