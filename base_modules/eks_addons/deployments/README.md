# Manual dependencies to be installed as addons on the cluster

Here are some:

- EFS CSI to facilitate communication to storage EFS.
- aws-load-balancer-controller to facilitate communication to ALB.
- cluster-autoscaler to make nodes autoscale automatically.

Ingress:

- ingress.yaml spawns an ALB to connect to istio.
- ingress-monitoring.yaml has the observability stack expose for services using istio
