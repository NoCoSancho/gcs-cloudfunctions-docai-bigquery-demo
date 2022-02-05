##################################################
##
## Deploy Cloud Function
##
##################################################

# source the previously set env variables
source ./config.sh

# prompt user to login
gcloud auth login ${USER_EMAIL}

echo "Set default project"
gcloud config set project ${PROJECT_ID}

#get project number via project id to identify cloudbuild service account name
PROJECT_NUM=`gcloud projects list \
    --filter="$(gcloud config get-value project)" \
    --format="value(PROJECT_NUMBER)"`

echo "Deploying Cloud Function docai-from-bucket-sync" 
echo "this can take a few minutes..."

gcloud functions deploy docai-from-bucket-sync \
--region=${REGION} \
--runtime python39 \
--trigger-resource ${PROJECT_ID}_docai_source_bucket \
--trigger-event google.storage.object.finalize \
--source ./functions/cloud-function-docai-from-bucket-sync \
--entry-point=main_func \
--ingress-settings internal-only \
--set-env-vars PROJECT_ID=${PROJECT_ID},PROJECT_NUM=${PROJECT_NUM},LOCATION=us,PROCESSOR_ID=${DOCAI_PROCESSOR_ID},GCS_OUTPUT_URI=${PROJECT_ID}_docai_dest_bucket,SKIP_HITL=True

echo "Deploying Cloud Function docai-from-bucket-sync" 
echo "this can take a few minutes..."

gcloud functions deploy docai-response-to-bq \
--region=${REGION} \
--runtime python39 \
--trigger-resource ${PROJECT_ID}_docai_dest_bucket \
--trigger-event google.storage.object.finalize \
--source ./functions/cloud-function-docai-response-to-bq \
--entry-point=main_func \
--ingress-settings internal-only \
--set-env-vars BQ_TABLE_ID=${PROJECT_ID}.docai.docai_results
