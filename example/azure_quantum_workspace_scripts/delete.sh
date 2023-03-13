
# read from STDIN to get the repo identifier
IN=$(cat)
workspace_name=$(echo $IN | jq -r .name)

az quantum workspace delete -g $AZURE_RESOURCE_GROUP -w $workspace_name
