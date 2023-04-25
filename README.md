# Prometheus Operator

## Step 1 - Prerequisites

Install Kubernetes on Instance
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Install Minikube
https://minikube.sigs.k8s.io/docs/start/

Install Virtualbox

Start minikube on virtualbox virtual machine
```
minikube start --driver=virtualbox
```
```
kubectl create namespace prometheus-operator
```
I use the commands of the guide
https://blog.container-solutions.com/prometheus-operator-beginners-guide

it requires a web application exposing Prometheus metrics: https://microservices-demo.github.io/deployment/kubernetes-minikube.html

## Step 2 - Create empty Prometheus. Generic

we can use
```
kubectl create -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/master/bundle.yaml
```
or
```
kubectl create -f 01-bundle.yaml 
```
![My Image](Step%206a.png)

The Prometheus server needs access to the Kubernetes API to scrape targets and reach the Alertmanager clusters. Therefore, a ServiceAccount is required to provide access to those resources, which must be created and bound to a ClusterRole accordingly.
```
kubectl create -f 02-prom_rbac.yaml
```
In this step, you’ll launch a 2-replica HA Prometheus deployment into your Kubernetes cluster using a Prometheus resource defined by Prometheus Operator.
```
kubectl create -f 03-prometheus.yaml
```

![My Image](Step%206b.png)

I can do
```
kubectl port-forward svc/prometheus-operated 9090:9090
```
and in my browser: localhost:9090
I can see Prometheus console, but its empty

![My Image](Step%207.png)

## Step 3 - Create service monitor

The operator uses ServiceMonitors to define a set of targets to be monitored by Prometheus. It uses label selectors to define which Services to monitor, the namespaces to look for, and the port on which the metrics are exposed:
```
kubectl create -f 04-service-monitor.yaml
```
![My Image](Step%208a.png)

![My Image](Step%208b.png)

## Step 4 - Create service pod monitor

There could be use cases that require scraping Pods directly, without direct association with services (for instance scraping sidecars). The operator also includes a PodMonitor CR, which is used to declaratively specify groups of pods that should be monitored. 
As an example, we’re using the front-end app from the microservices-demo project, which, simulates the user-facing part of an e-commerce website that exposes a /metrics endpoint.
```
kubectl create -f 05-podmonitor.yaml
```

## Step 5 - Append aditional scrape configurations

It’s possible to append additional scrape configurations to the Prometheus instance via secret files. These files must follow the Prometheus configuration scheme and the user is responsible to make sure that they are valid.
```
kubectl create secret generic 07-additional-scrape-configs --from-file=prometheus-additional-job.yaml --dry-run=client -oyaml > 07-additional-scrape-configs.yaml
kubectl create -f 07-additional-scrape-configs.yaml
```
## Step 6 - Alert Manager

The Prometheus Operator also introduces an Alertmanager resource, which allows users to declaratively describe an Alertmanager cluster. It also adds an AlertmanagerConfig CR, which allows users to declaratively describe Alertmanager configurations.
```
kubectl create -f 08-alertmanager-config.yaml 
kubectl create -f 09-alertmanager.yaml
```
![My Image](Step%2011a.png)
```	
kubectl port-forward svc/alertmanager-operated 9093:9093
```
In the browser to lo localhost:9093

![My Image](Step%2011b.png)

The PrometheusRule CR supports defining one or more RuleGroups. These groups consist of a set of rule objects that can represent either of the two types of rules supported by Prometheus, recording or alerting.
```
kubectl create -f 10-prometheus-rule.yaml 
kubectl delete -f 03-prometheus.yaml
kubectl create -f 11-modify-prometheus.yaml
```
