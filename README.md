# Setup local development to run the provider and scripts

## Requirements

* Terraform cli (x86_64)
* Golang (x86_64)
* azure-cli
* Set this environment variable on your shell: `export GOBIN=$HOME/go/bin # can be other directory`
* AWS credentials setup under `~/.aws`
* Azure credentials setup

## Installations

### Compile custom provider implementation

```bash
$ go mod tidy
$ go install .
```

### Mirror all standard terraform providers to your system

This step is needed because terraform only supports either running all providers from remote sources, or local sources. Since we have a custom local provider, we have to download all the standard providers that we need. Run these commands under `deploy_quantum_task` directory:

```bash
$ mkdir -p ~/.terraform.d/plugins
$ terraform providers mirror ~/.terraform.d/plugins
```

The command will fail with provider local and our custom providers, which are missing. This is expected because those are not available online.

### Configure terraform to use downloaded providers

Have this file `.terraformrc` under `$HOME` (replace all $HOME with actual absolute paths). Please note the actual downloaded version of the providers might differ, so let's double check the version in the path.

```
provider_installation {

  dev_overrides {
      "hashicorp.com/edu/quantumrunners" = "$HOME/go/bin"
      "hashicorp/local" = "$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/local/<VERSION>/darwin_amd64"
      "registry.terraform.io/hashcorp/local" = "$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/local/<VERSION>/darwin_amd64"
      "hashicorp/aws" = "$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/aws/<VERSION>/darwin_amd64"
      "registry.terraform.io/hashicorp/aws" = "$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/aws/<VERSION>/darwin_amd64"
      "hashicorp/azurerm" = "$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/azurerm/<VERSION>/darwin_amd64"
      "registry.terraform.io/hashicorp/azurerm" = "$HOME/.terraform.d/plugins/registry.terraform.io/hashicorp/azurerm/<VERSION>/darwin_amd64"
      "scottwinkler/shell" = "$HOME/.terraform.d/plugins/registry.terraform.io/scottwinkler/shell/<VERSION>/darwin_amd64"
      "registry.terraform.io/scottwinkler/shell" = "$HOME/.terraform.d/plugins/registry.terraform.io/scottwinkler/shell/<VERSION>/darwin_amd64"
  }
}
```

### Disable a cloud provider if not needed.

The project supports AWS braket and Azure Quantum service. Each service is defined under aws_ and azure_ prefix under `deploy_quantum_task`. Change the file extension of those service from .tf to .xtf will disable the deployment on those cloud. If such cloud services are needed, simply change the file name back again.

## Deploy the terraform code

Under `deploy_quantum_task`, run

```bash
$ terraform plan # This will make terraform to describe what it will do
$ # This -var will not be needed if azure platform are not deployed.
$ terraform apply -var azure_subscription_id=<YOUR AZURE SUBSCRIPTION ID>
```

# Develop the custom Terraform Provider Quantum Runner

Run the following command to build the provider and install to the target destination ($GOBIN)

```shell
$ go install .
```
