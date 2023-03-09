package provider

import (
	"context"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/braket"
	"github.com/hashicorp/terraform-plugin-framework/resource"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema/int64planmodifier"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema/planmodifier"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema/stringplanmodifier"
	"github.com/hashicorp/terraform-plugin-framework/types"
	"github.com/hashicorp/terraform-plugin-log/tflog"
)

// Ensure the implementation satisfies the expected interfaces.
var (
	_ resource.Resource              = &taskResource{}
	_ resource.ResourceWithConfigure = &taskResource{}
)

// NewTaskResource is a helper function to simplify the provider implementation.
func NewTaskResource() resource.Resource {
	return &taskResource{}
}

// taskResource is the resource implementation.
type taskResource struct {
	client *braket.Client
}

type taskResourceModel struct {
	DeviceId          types.String `tfsdk:"device_id"`
	Circuit           types.String `tfsdk:"circuit"`
	ClientToken       types.String `tfsdk:"client_token"`
	OutputDestination types.String `tfsdk:"output_destination"`
	OutputKeyPrefix   types.String `tfsdk:"output_key_prefix"`
	Shots             types.Int64  `tfsdk:"shots"`
	TaskId            types.String `tfsdk:"task_id"`
	TaskStatus        types.String `tfsdk:"task_status"`
}

// Metadata returns the resource type name.
func (r *taskResource) Metadata(_ context.Context, req resource.MetadataRequest, resp *resource.MetadataResponse) {
	resp.TypeName = req.ProviderTypeName + "_task"
}

// Schema defines the schema for the resource.
func (r *taskResource) Schema(_ context.Context, _ resource.SchemaRequest, resp *resource.SchemaResponse) {
	resp.Schema = schema.Schema{
		Attributes: map[string]schema.Attribute{
			"task_id": schema.StringAttribute{
				Description: "The task id",
				Computed:    true,
			},
			"task_status": schema.StringAttribute{
				Description: "The task status",
				Computed:    true,
			},
			"device_id": schema.StringAttribute{
				Description: "Device ID that the task should run on",
				Required:    true,
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
			"circuit": schema.StringAttribute{
				Description: "The QASM string of the circuit to run",
				Required:    true,
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
			"client_token": schema.StringAttribute{
				Description: "Unique id that identity the task run. This is different than the task id",
				Computed:    true,
			},
			"output_destination": schema.StringAttribute{
				Description: "The target to store the result. In AWS it has to be an s3 bucket that braket has write permission to",
				Required:    true,
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
			"output_key_prefix": schema.StringAttribute{
				Description: "The file name prefix that the result should be stored to",
				Required:    true,
				PlanModifiers: []planmodifier.String{
					stringplanmodifier.RequiresReplace(),
				},
			},
			"shots": schema.Int64Attribute{
				Description: "The number of shots that we should run",
				Required:    true,
				PlanModifiers: []planmodifier.Int64{
					int64planmodifier.RequiresReplace(),
				},
			},
		},
	}
}

// Create creates the resource and sets the initial Terraform state.
func (r *taskResource) Create(ctx context.Context, req resource.CreateRequest, resp *resource.CreateResponse) {
	var plan taskResourceModel
	diags := req.Plan.Get(ctx, &plan)
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}

	tflog.Info(ctx, plan.Circuit.ValueString())

	clientId := time.Now().Format(time.RFC850)

	quantumTask, err := r.client.CreateQuantumTask(ctx, &braket.CreateQuantumTaskInput{
		Action:            aws.String(plan.Circuit.ValueString()),
		ClientToken:       aws.String(clientId),
		DeviceArn:         aws.String(plan.DeviceId.ValueString()),
		OutputS3Bucket:    aws.String(plan.OutputDestination.ValueString()),
		OutputS3KeyPrefix: aws.String(plan.OutputKeyPrefix.ValueString()),
		Shots:             aws.Int64(plan.Shots.ValueInt64()),
	})

	if err != nil {
		resp.Diagnostics.AddError(
			"Unable to create quantum task",
			err.Error(),
		)
		return
	}

	taskDetail, err := r.client.GetQuantumTask(ctx, &braket.GetQuantumTaskInput{
		QuantumTaskArn: quantumTask.QuantumTaskArn,
	})

	if err != nil {
		resp.Diagnostics.AddWarning(
			"Unable to get quantum task details",
			err.Error(),
		)
	} else {
		plan.TaskStatus = types.StringValue(string(taskDetail.Status))
	}

	plan.TaskId = types.StringValue(*quantumTask.QuantumTaskArn)
	plan.ClientToken = types.StringValue(clientId)

	resp.State.Set(ctx, &plan)
}

// Read refreshes the Terraform state with the latest data.
func (r *taskResource) Read(ctx context.Context, req resource.ReadRequest, resp *resource.ReadResponse) {
	var state taskResourceModel
	diags := req.State.Get(ctx, &state)
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}

	taskDetail, err := r.client.GetQuantumTask(ctx, &braket.GetQuantumTaskInput{
		QuantumTaskArn: aws.String(state.TaskId.ValueString()),
	})

	if err != nil {
		resp.Diagnostics.AddWarning(
			"Unable to get quantum task details",
			err.Error(),
		)
	} else {
		state.TaskStatus = types.StringValue(string(taskDetail.Status))
	}

	diags = resp.State.Set(ctx, &state)
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}
}

// Update updates the resource and sets the updated Terraform state on success.
func (r *taskResource) Update(ctx context.Context, req resource.UpdateRequest, resp *resource.UpdateResponse) {
}

// Delete deletes the resource and removes the Terraform state on success.
func (r *taskResource) Delete(ctx context.Context, req resource.DeleteRequest, resp *resource.DeleteResponse) {
}

// Configure adds the provider configured client to the resource.
func (r *taskResource) Configure(_ context.Context, req resource.ConfigureRequest, _ *resource.ConfigureResponse) {
	if req.ProviderData == nil {
		return
	}

	r.client = req.ProviderData.(*braket.Client)
}
