## Azure CLI bug (missing reference to azure.storage.blob) to submit quantum tasks. Maybe wait for fixes?

Workaround (in mac): Run az --version to get the python installation location of the cli. For example

`/opt/homebrew/Cellar/azure-cli/2.46.0/libexec/bin/python`

Then we can invoke pip of this python in `/opt/homebrew/Cellar/azure-cli/2.46.0/libexec/bin/pip3` and install the missing package azure.storage.blob.

## Azure cli for quantum job submission is in a very broken state

* The cli does not respect CLI flag override, we need to set default workspace, resource group and location before actual execution of job submission.
* No documentation of supported circuit format or output format. Job submission will only show that unexpected input format

## Maybe we can use AWS Event Bridge to setup a event handling remotely and send result email to the user?
