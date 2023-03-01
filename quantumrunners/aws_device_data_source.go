package quantumrunners

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/service/braket"
	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/datasource/schema"
	"github.com/hashicorp/terraform-plugin-framework/types"
)

// Ensure the implementation satisfies the expected interfaces.
var (
	_ datasource.DataSource              = &awsDeviceDataSource{}
	_ datasource.DataSourceWithConfigure = &awsDeviceDataSource{}
)

// NewCoffeesDataSource is a helper function to simplify the provider implementation.
func NewAwsDeviceDataSource() datasource.DataSource {
	return &awsDeviceDataSource{}
}

// awsDeviceDataSource is the data source implementation.
type awsDeviceDataSource struct {
	client *braket.Client
}

// coffeesDataSourceModel maps the data source schema data.
type devicesDataSourceModel struct {
	Devices []deviceModel `tfsdk:"devices"`
}

// deviceModel maps coffees schema data.
type deviceModel struct {
	DeviceArn    types.String `tfsdk:"arn"`
	DeviceName   types.String `tfsdk:"name"`
	DeviceStatus types.String `tfsdk:"status"`
	DeviceType   types.String `tfsdk:"type"`
	ProviderName types.String `tfsdk:"providerName"`
}

// Metadata returns the data source type name.
func (d *awsDeviceDataSource) Metadata(_ context.Context, req datasource.MetadataRequest, resp *datasource.MetadataResponse) {
	resp.TypeName = req.ProviderTypeName + "_devices"
}

// Schema defines the schema for the data source.
func (d *awsDeviceDataSource) Schema(_ context.Context, _ datasource.SchemaRequest, resp *datasource.SchemaResponse) {
	resp.Schema = schema.Schema{
		Description: "Fetches the list of devices.",
		Attributes: map[string]schema.Attribute{
			"devices": schema.ListNestedAttribute{
				Description: "List of devices.",
				Computed:    true,
				NestedObject: schema.NestedAttributeObject{
					Attributes: map[string]schema.Attribute{
						"arn": schema.StringAttribute{
							Description: "Device ARN.",
							Computed:    true,
						},
						"name": schema.StringAttribute{
							Description: "Device name.",
							Computed:    true,
						},
						"status": schema.StringAttribute{
							Description: "Device Status, OFFLINE, ONLINE or RETIRED",
							Computed:    true,
						},
						"type": schema.StringAttribute{
							Description: "Device type, SIMULATOR or QPU.",
							Computed:    true,
						},
						"providerName": schema.StringAttribute{
							Description: "Provider name of the device.",
							Computed:    true,
						},
					},
				},
			},
		},
	}
}

// Configure adds the provider configured client to the data source.
func (d *awsDeviceDataSource) Configure(_ context.Context, req datasource.ConfigureRequest, _ *datasource.ConfigureResponse) {
	if req.ProviderData == nil {
		return
	}

	d.client = req.ProviderData.(*braket.Client)

}

// Read refreshes the Terraform state with the latest data.
func (d *awsDeviceDataSource) Read(ctx context.Context, req datasource.ReadRequest, resp *datasource.ReadResponse) {
	var state devicesDataSourceModel

	devicesOutput, err := d.client.SearchDevices(ctx, &braket.SearchDevicesInput{})
	if err != nil {
		resp.Diagnostics.AddError(
			"Unable to search quantum devices",
			err.Error(),
		)
		return
	}

	// Map response body to model
	for _, device := range devicesOutput.Devices {
		deviceState := deviceModel{
			DeviceArn:    types.StringValue(*device.DeviceArn),
			DeviceName:   types.StringValue(*device.DeviceName),
			DeviceStatus: types.StringValue(string(device.DeviceStatus)),
			DeviceType:   types.StringValue(string(device.DeviceType)),
			ProviderName: types.StringValue(*device.ProviderName),
		}

		state.Devices = append(state.Devices, deviceState)
	}

	// Set state
	diags := resp.State.Set(ctx, &state)
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}
}
