# Environment variables are injected in azure_cli_main.tf

# Create quantum workspace
az quantum job submit -g $AZURE_RESOURCE_GROUP -w $WORKSPACE_NAME -l "$AZURE_LOCATION" \
    -t $JOB_RUNNER_TARGET \
    --job-input-format "OpenQASM" --job-input-file "$CIRCUIT_CONTENT_PATH" \
    --job-output-format "json"
