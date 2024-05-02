## ---------------------------------------------------------------------------------------------------------------------
## COREDNS PATCH
## Patches the default CoreDNS deployment to be compatible with
## ---------------------------------------------------------------------------------------------------------------------


resource "null_resource" "coredns" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
        aws eks --region us-east-1 update-kubeconfig --name ${var.aws_eks_cluster_name}
        annotation_value=$(kubectl get deployment -n kube-system "coredns" -o jsonpath="{.spec.template.metadata}" | grep eks.amazonaws.com/compute-type)

        if [ -z "$annotation_value" ]; then
        echo "EC2 not set for deployment"
        else
        echo "Removing annotation from deployment"
        kubectl patch deployment coredns -n kube-system --type=json -p='[{"op": "remove", "path": "/spec/template/metadata/annotations", "value": "eks.amazonaws.com/compute-type"}]'
        kubectl rollout restart -n kube-system deployment coredns
        while [[ $(kubectl get deployment -n kube-system coredns -o 'jsonpath={..status.conditions[?(@.type=="Available")].status}') != "True" ]]; do
        echo "Waiting for the deployment to be ready..."
        sleep 5
        done
        echo "Deployment is now ready"
        fi
    EOF
  }
}


resource "aws_eks_addon" "this" {
  # Not supported on outposts
  for_each = { for k, v in var.cluster_addons : k => v if var.create && !var.create_outposts_local_cluster }

  cluster_name             = var.aws_eks_cluster_name
  addon_name               = try(each.value.name, each.key)
  addon_version            = try(each.value.addon_version, null)
  configuration_values     = try(each.value.configuration_values, null)
  preserve                 = try(each.value.preserve, null)
  resolve_conflicts        = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn = try(each.value.service_account_role_arn, null)

  timeouts {
    create = try(each.value.timeouts.create, var.cluster_addons_timeouts.create, null)
    update = try(each.value.timeouts.update, var.cluster_addons_timeouts.update, null)
    delete = try(each.value.timeouts.delete, var.cluster_addons_timeouts.delete, null)
  }

  depends_on = [null_resource.coredns]
}
