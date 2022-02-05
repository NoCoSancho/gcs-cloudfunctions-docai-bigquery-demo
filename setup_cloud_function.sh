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

echo "Deploying Cloud Function" 

gcloud functions deploy gcs-uri-to-pubsub \
--region=${REGION} \
--runtime python39 \
--trigger-resource gs://${PROJECT_ID}-csek-objects-bucket \
--trigger-event google.storage.object.finalize \
--source ./functions/gcs_uri_to_pubsub/ \
--entry-point=main_func \
--ingress-settings internal-only \
--set-env-vars TOPIC_NAME=${PS_TOPIC_NAME},PROJECT_ID=${PROJECT_ID}