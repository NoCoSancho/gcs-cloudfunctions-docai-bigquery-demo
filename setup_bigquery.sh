##################################################
##
## Create BigQuery Dataset and Table for demo
##
##################################################

# source the previously set env variables
source ./config.sh

# prompt user to login
gcloud auth login ${USER_EMAIL}

echo "Set default project"
gcloud config set project ${PROJECT_ID}

echo "Creating Big Query Dataset" 

bq --location=US mk \
--dataset \
${PROJECT_ID}:docai

echo "Creating Big Query Table using json schema" 

bq mk \
  --table \
  ${PROJECT_ID}:docai.docai_results \
 ./bigquery/docai_results_schema.json
 