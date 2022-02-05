##################################################
##
## Create GCS buckets for demo
##
##################################################

# source the previously set env variables
source ./config.sh

# prompt user to login
gcloud auth login ${USER_EMAIL}

echo "Set default project"
gcloud config set project ${PROJECT_ID}

echo "Creating source and dest DocAI GCS Buckets" 

gsutil mb -b on -l ${REGION} gs://${PROJECT_ID}_docai_source_bucket

gsutil mb -b on -l ${REGION} gs://${PROJECT_ID}_docai_dest_bucket