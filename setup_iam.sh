##################################################
##
## Set required IAM permissions
##
##################################################

# source the previously set env variables
source ./config.sh

# prompt user to login
gcloud auth login ${USER_EMAIL}
echo "Assigning IAM Permissions"


#default app engine service account
#MUST BE RUN AFTER FUNCTION CREATION
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${PROJECT_ID}@appspot.gserviceaccount.com \
    --role=roles/editor