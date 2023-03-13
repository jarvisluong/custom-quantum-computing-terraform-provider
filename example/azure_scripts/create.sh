# Environment variables are injected in azure_cli_main.tf

# Create quantum workspace
az quantum workspace create -g $AZURE_RESOURCE_GROUP -w $WORKSPACE_NAME -l "$AZURE_LOCATION" \
    -a $AZURE_STORAGE_ACCOUNT
