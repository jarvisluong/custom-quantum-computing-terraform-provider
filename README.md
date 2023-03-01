# Setup local development to run the provider and scripts

You need to have this file `.terraformrc` under `$HOME`:

```
provider_installation {

  dev_overrides {
      "hashicorp.com/edu/quantumrunners" = "<REPLACE YOUR HOME>/go/bin"
      "hashicorp/local" = "<REPLACE YOUR HOME>/.terraform.d/plugins/registry.terraform.io/hashicorp/local/2.3.0/darwin_amd64"
  }

  # For all other providers, install them directly from their origin provider
  # registries as normal. If you omit this, Terraform will _only_ use
  # the dev_overrides block, and so no other providers will be available.
  direct {
  }
}
```

Run `terraform init`to download the third party providers such as aws, local, azure etc..., then copy the content of `.terraform/providers` to `$HOME/.terraform.d/plugins`

# Terraform Provider Quantum Runner

Run the following command to build the provider

```shell
make build
```

## Test sample configuration

First, build and install the provider.

```shell
make install
```

Then, run the following command to initialize the workspace and apply the sample configuration.

```shell
terraform init && terraform apply
```