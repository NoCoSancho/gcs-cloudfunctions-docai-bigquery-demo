##################################################
##
## Create and Configure GCP project for demo
##
##################################################

# source the previously set env variables
source ./config.sh

# prompt user to login
gcloud auth login ${USER_EMAIL}

##################################################
##
## Project
##
##################################################

echo "Creating new project"

gcloud projects create ${PROJECT_ID}

echo "Set default project"

gcloud config set project ${PROJECT_ID}

##################################################
##
## Billing
##
##################################################

echo "Assigning billing account"

gcloud beta billing projects link ${PROJECT_ID} --billing-account=${BILLING_ACCOUNT_ID}

##################################################
##
## Org Policies
##
##################################################

echo "configuring org policies at project level"

#disable the shielded vm requirement, enabled in argolis
gcloud resource-manager org-policies disable-enforce \
    compute.requireShieldedVm --project=${PROJECT_ID}

#ensure only internal and google cloud load balancer ingress is allowed for functions
gcloud resource-manager org-policies allow \
cloudfunctions.allowedIngressSettings \
--project=${PROJECT_ID} \
ALLOW_INTERNAL_ONLY ALLOW_INTERNAL_AND_GCLB


##################################################
##
## Enable APIs
##
##################################################

echo "enabling the necessary APIs"

gcloud services enable compute.googleapis.com

gcloud services enable storage.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

gcloud services enable cloudbuild.googleapis.com

gcloud services enable documentai.googleapis.com



