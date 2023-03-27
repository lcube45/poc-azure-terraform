# POC Azure Terraform

## Setup Terraform backend
```
az group create --name rg-poc-azure --location francecentral
az storage account create --resource-group rg-poc-azure --name tfstatepocazure --location francecentral --sku Standard_LRS --encryption-services blob
az storage container create --name tfstate --account-name tfstatepocazure

ACCOUNT_KEY=$(az storage account keys list --resource-group rg-poc-azure --account-name tfstatepocazure --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
```

##
