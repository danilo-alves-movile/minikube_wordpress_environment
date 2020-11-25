## Summary
* Deployment
[X] Wordpress image build.
[X] Kubernetes cluster (version from 1.17 onwards)
[X] MySQL 5.7
[X] Deploy custom WordPress image on port 8080
[] Install plugin on Wordpress
[X] Install Prometheus and Grafana in the cluster (without version restrictions), configuring the interface on port 3000;
[] two performance widgets in Grafana one for the database and one for Apache

* Documentation
[] Diagrams and other documentation 

## Documentation
### Instalation
* For Ubuntu family you can execute: `cd resources && ./minikube_install.sh`
* Enable Minikube features: 
    * `minikube addons enable helm-tiller`
    * `minikube addons enable ingress`
* Install resources first:
    * Minikube or K8S (change provider file `provider.tf`).
    * Apply Terraform files (homologated Terraform 13):
        * `terraform init`
        * `terraform plan`
        * `terraform apply`

### Access
* Local access local browser (port-forward): `minikube service nginx-service`