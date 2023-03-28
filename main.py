from python_terraform import Terraform
import json
import pydash as _

t = Terraform(working_dir='./deploy_quantum_task')

def step_print(msg):
    print("\n")
    print(f"===== {msg} =====")    

step_print("Apply latest terraform state")
t.apply_cmd(auto_approve=True, capture_output=False)

step_print("Get terraform state output")
(return_code, stdout, stderr) = t.output_cmd(json=True)
json_out = json.loads(str(stdout))

task_metadata = _.get(json_out, "task_metadata.value")

task_names = list(task_metadata.keys())

ghz_task_names = _.filter_(task_names, lambda x: _.starts_with(x, 'ghz_task'))
ghz_completed_task_arns = _.map_(
    _.filter_(ghz_task_names, lambda name: task_metadata[name]['status'] == 'COMPLETED'),
    lambda name: task_metadata[name]['arn']
)

graph_state_task_names = _.filter_(task_names, lambda x: _.starts_with(x, 'graph_state_task'))
graph_state_completed_task_arns = _.map_(
    _.filter_(ghz_task_names, lambda name: task_metadata[name]['status'] == 'COMPLETED'),
    lambda name: task_metadata[name]['arn']
)

print(ghz_completed_task_arns)
print(graph_state_completed_task_arns)
