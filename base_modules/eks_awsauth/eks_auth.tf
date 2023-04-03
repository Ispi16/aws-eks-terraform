resource "null_resource" "wait_for_cluster" {

  provisioner "local-exec" {
    environment = {
      ENDPOINT = var.endpoint
    }

    command = "until wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null; do sleep 4; done"
  }
}

resource "kubernetes_config_map" "aws_auth" {

  depends_on = [
    null_resource.wait_for_cluster
  ]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles    = <<EOF
${join("", distinct(data.template_file.map_instances.*.rendered))}
%{if length(var.map_roles) != 0}${yamlencode(var.map_roles)}%{endif}
EOF
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }
}
