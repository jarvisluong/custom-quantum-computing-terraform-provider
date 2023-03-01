package provider

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/braket"

	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/provider"
	"github.com/hashicorp/terraform-plugin-framework/provider/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource"
	"github.com/hashicorp/terraform-plugin-log/tflog"
)

// Ensure the implementation satisfies the expected interfaces
var (
	_ provider.Provider = &quantumRunnerProvider{}
)

// New is a helper function to simplify provider server and testing implementation.
func New() provider.Provider {
	return &quantumRunnerProvider{}
}

// quantumRunnerProvider is the provider implementation.
type quantumRunnerProvider struct{}

// Metadata returns the provider type name.
func (p *quantumRunnerProvider) Metadata(_ context.Context, _ provider.MetadataRequest, resp *provider.MetadataResponse) {
	resp.TypeName = "quantumrunners"
}

func (p *quantumRunnerProvider) Schema(_ context.Context, _ provider.SchemaRequest, resp *provider.SchemaResponse) {
	resp.Schema = schema.Schema{
		Attributes: map[string]schema.Attribute{},
	}
}

// Configure prepares a AWS Braket API client for data sources and resources.
func (p *quantumRunnerProvider) Configure(ctx context.Context, req provider.ConfigureRequest, resp *provider.ConfigureResponse) {
	tflog.Info(ctx, "Configuring AWS SDK Golang client")

	// Load the Shared AWS Configuration (~/.aws/config)
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		resp.Diagnostics.AddError("Cannot load aws configuration", err.Error())
		return
	}

	// Create an Amazon S3 service client
	client := braket.NewFromConfig(cfg)

	// Make the HashiCups client available during DataSource and Resource
	// type Configure methods.
	resp.DataSourceData = client
	resp.ResourceData = client

	tflog.Info(ctx, "Configured AWS Braket client", map[string]any{"success": true})
}

// DataSources defines the data sources implemented in the provider.
func (p *quantumRunnerProvider) DataSources(_ context.Context) []func() datasource.DataSource {
	return []func() datasource.DataSource{
		NewAwsDeviceDataSource,
	}
}

// Resources defines the resources implemented in the provider.
func (p *quantumRunnerProvider) Resources(_ context.Context) []func() resource.Resource {
	return nil
}
