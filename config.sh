##################################################
##
## Set these Variables
## Note that the last two are set by the user
## later in the deployment process
##
##################################################

# existing GCP user that will:
# create the project
# attach a billing id (needs to have permission)
# and provision resources
export USER_EMAIL=<insert gcp user email>

# project id for your NEW GCP project
export PROJECT_ID=<insert project id>

# the new project will need to be tied to a billing account
export BILLING_ACCOUNT_ID=<insert billing account>

# desired GCP region for networking and compute resources
export REGION=<insert gcp region>

# desired GCP zone for networking and compute resources
export ZONE=<insert gcp zone>

# desired GCP VPC name
export VPC_NAME=<insert vpc name>

# desired GCP subnet name
export SUBNET_NAME=<insert subnet name>

# The next variables are updated later in the deployment process
# since Document AI processors could only be deployed through 
# the Cloud Console at the time of script development

# document AI processor name (manually created in console)
export DOCAI_PROCESSOR_NAME=<insert processor name>

# document AI processor ID (manually created in console)
export DOCAI_PROCESSOR_ID=<insert processor ID>

##################################################
#Example
##################################################
# export USER_EMAIL=myuser@mydomain.com
# export PROJECT_ID=csek-gcs-demo-project-01
# export BILLING_ACCOUNT_ID=123456-123456-123456
# export REGION=us-central1
# export ZONE=us-central1-a
# export VPC_NAME=demo-vpc
# export SUBNET_NAME=demo-subnet-1
#export DOCAI_PROCESSOR_NAME=generic-ocr-processor
#export DOCAI_PROCESSOR_ID=7f71070285413940
##################################################
