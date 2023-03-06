package provider

import (
	"context"
	"time"

	"github.com/hashicorp/terraform-plugin-framework/resource"
	"github.com/hashicorp/terraform-plugin-framework/resource/schema"
	"github.com/hashicorp/terraform-plugin-framework/types"
)

// Ensure the implementation satisfies the expected interfaces.
var (
	_ resource.Resource = &quantumCircuitResource{}
)

// NewQuantumCircuitResource is a helper function to simplify the provider implementation.
func NewQuantumCircuitResource() resource.Resource {
	return &quantumCircuitResource{}
}

// quantumCircuitResource is the resource implementation.
type quantumCircuitResource struct{}

type quantumCircuitResourceModel struct {
	QasmContent types.String `tfsdk:"qasm_content"`
	LastUpdated types.String `tfsdk:"last_updated"`
}

// Metadata returns the resource type name.
func (r *quantumCircuitResource) Metadata(_ context.Context, req resource.MetadataRequest, resp *resource.MetadataResponse) {
	resp.TypeName = req.ProviderTypeName + "_quantum_circuit"
}

// Schema defines the schema for the resource.
func (r *quantumCircuitResource) Schema(_ context.Context, _ resource.SchemaRequest, resp *resource.SchemaResponse) {
	resp.Schema = schema.Schema{
		Attributes: map[string]schema.Attribute{
			"qasm_content": schema.StringAttribute{
				Description: "QASM format of the quantum circuit",
				Required:    true,
			},
			"last_updated": schema.StringAttribute{
				Computed: true,
			},
		},
	}
}

// Create creates the resource and sets the initial Terraform state.
func (r *quantumCircuitResource) Create(ctx context.Context, req resource.CreateRequest, resp *resource.CreateResponse) {
	var circuit quantumCircuitResourceModel
	diags := req.Plan.Get(ctx, &circuit)
	circuit.LastUpdated = types.StringValue(time.Now().Format(time.RFC850))
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}
	resp.State.Set(ctx, &circuit)
}

// Read refreshes the Terraform state with the latest data.
func (r *quantumCircuitResource) Read(ctx context.Context, req resource.ReadRequest, resp *resource.ReadResponse) {
	var circuit quantumCircuitResourceModel
	diags := req.State.Get(ctx, &circuit)
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}
	diags = resp.State.Set(ctx, &circuit)
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}
}

// Update updates the resource and sets the updated Terraform state on success.
func (r *quantumCircuitResource) Update(ctx context.Context, req resource.UpdateRequest, resp *resource.UpdateResponse) {
	// Retrieve values from plan
	var plan quantumCircuitResourceModel
	diags := req.Plan.Get(ctx, &plan)
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}
	diags = resp.State.Set(ctx, plan)
	plan.LastUpdated = types.StringValue(time.Now().Format(time.RFC850))
	resp.Diagnostics.Append(diags...)
	if resp.Diagnostics.HasError() {
		return
	}
}

// Delete deletes the resource and removes the Terraform state on success.
func (r *quantumCircuitResource) Delete(ctx context.Context, req resource.DeleteRequest, resp *resource.DeleteResponse) {
}
