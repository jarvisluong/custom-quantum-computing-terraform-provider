## Azure CLI bug (missing reference to azure.storage.blob) to submit quantum tasks. Maybe wait for fixes?

Workaround (in mac): Run az --version to get the python installation location of the cli. For example

`/opt/homebrew/Cellar/azure-cli/2.46.0/libexec/bin/python`

Then we can invoke pip of this python in `/opt/homebrew/Cellar/azure-cli/2.46.0/libexec/bin/pip3` and install the missing package azure.storage.blob.

## Maybe we can use AWS Event Bridge to setup a event handling remotely and send result email to the user?
