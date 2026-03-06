---
publish: true
---



tags: [[kubernetes]] [[devops]]

####  Kubernetes

* Container Orchestration Platform
* Open Source
* Automates deployment, scaling and management of containerized application.

* Kubernetes achieves this by providing a robust and scalable platform for deploying, scaling, and managing containerized applications
* provides a consistent API for interacting with the cluster


#### K8s Architecture

- Master Node
	- Description
		- Heart of K8s cluster
		- Control plane of cluster and manages it
		- make global decisions about cluster
			- scheduling new pod, monitoring health of nodes & pods and scaling on demand
	- Components
		- API Server
			- central managment point of cluster.
			- exposes k8s apis to interact with cluster
		- etcd
			- distributed key-value store
			- stores configuration data and info of cluster
		- Controller Manager
			- includes several controllers 
				- that watch the cluster state through the API Server
				- take corrective actions
			- ex: ReplicaSet controller ensures the specified number of pod replicas are running.
		- Scheduler
			- assigns new pods to node on requirement and availability/
				- help: distribute workload
- Worker Nodes
	- Description
		- machines where containers(pods) are scheduled and run
		- DataPlane of cluster
		- executes actual workloads
	- Components(of each node)
		- Kubelet
			- is a **agent** runs on each node
			- communicates with master node
			- ensures that containers described in podSpec are running and healthy
		- Container Runtime
			- responsible for pulling container images and running containers on workers nodes
			- k8s supports multiple runtimes ex: Docker or containerd
		- Kube Proxy
			- responsible for network communication within cluster
			- manages routing for services and load balancing
- How they interact
	- Master and Worker nodes communicate through k8s API server.
	- Users and other comp interact with cluster through the API Server as well.
	- ControllerManager monitor cluster state through API server. Takes corrective action to reconcile state
	- scheduler select worker node base on resource availability and other constraints. 
	- API server informs worker mode and kubelet on that node starts the container
	- Worker Nodes report that status of the running pods back to the master node throughthe kubelet. 



### Main K8s Components

- Nodes
	- represents individual machines(physical or virtual) in a cluster.
	- More
		- worker machine where containers are deployed and run
		- responsible for running actual workloads
		- provides necessary resources to run
- Pods
	- smallest deployable units that can hold one or more tightly coupled containers.
	- More 
		- containers within pods share same network namespace (can communicate over localhost)
		- pods represents a single instance of a process in the cluster
		- ex:
			- deploy simple webapp over k8s cluster
			- package application server and database into single pods
	- Why Pods and Not just containers
		- additional layer of abstraction
		- facilities managements and enables advance scheduling and resource sharing capabilites
		- Benefits
			- Grouping Containers
				- group logically related containers together. 
				- simplifies scheduling, scaling and management
			- Shared Resource
				- containers in a pods share same network namespace and can share volumnes, making it easier for them to communicate and share data
			- Atomic Unit
				- atomic unit of deployment
				- scaling and managing is done at pod level
			- Scheduling Affinity
				- k8s schedules pods to nodes, not individual containers.
- Deployment
- Service
	- service enables internal communication between pods within the cluster
	- More
		- abstraction that defines a stable endpoint to access a group of pods.
		- allows to expose your application to other pods within cluster to external clients
		- Services provide load balancing and automatic scaling for the pods behind them, thus ensures availability
- Ingress
	- `Ingress` provides a way to expose your services to external clients outside the cluster.
	- external entry point to your applications
	- enables you to configure routing rules and load balancing
- ConfigMap
	- store configuration data that can be consumed by pods as environment variables
	- or mounted as configuration files.
	- separate the configuration from the container image,
	- help to update configurations without rebuilding the container.
- Secret
	- to store sensitive information
		- ex: passwords, API keys, or TLS certificates.
	- base64-encoded
	-  can be mounted as files or used as environment variables in pods.
- Volume
	- directory that is accessible to all containers in a pod
	- decouples the storage from the containers
	- that data persists even if a container is restarted or rescheduled.
- StatefulSet
	- used for stateful applications
	- where each pod has a unique identity and persistent storage
	-  StatefulSets provide stable network identities and are suitable for databases, key-value stores, and other applications that require unique persistent storage and ordered scaling.



### Kubernetes Configuration

* Written in YAML format
* used to define and configure varioux k8s resources such as Pods, Services, Deployments, Statefulsets, ConfigMaps, Secrets, and more.


### Minikube and Kubectl -- Setting up K8s Cluster locally

* `minikube version`
* `minikube start`
* `kubectl cluster-info`
* Verify nodes
	* `kubectl get nodes`
* Deploy a test application
	* create yam file
	* apply config
		* `kubectl apply -f test-app.yaml`
	* Check status
		* `kubectl get pods`
	* Access test application
		* `kubectl port-forward test-app-pod 8080:80`


#### Interacting with Kubernetes Cluster

* Inspecting Cluster info
	* `kubectl cluster-info`
* view nodes
	* `kubectl get nodes`
* working with resources
	* `kubectl get <resource>`
* get detailed info of specific resource
	* `kubectl describe <resource> <resource_name>`
* Managing resources
	* apply k8s resource from YAML config file
		* `kubectl apply -f <filename>`
		* filename is name of yam config file
	* to delete resource
		* `kubectl delete <resource> <resource_name>`


Interacting with pods
* View pods
	* `kubectl get pods`
* view logs
	* `kubectl logs <pod_name>`
* access shell inside pod
	* `kubectl exec -it <pod_name> -/bin/bash`


Interacting with Services
* To view the services in your namespace
	* `kubectl get services`
* To access a service from your local machine
	* `kubectl port-forward <service_name> <local_port>:<service_port>`







Overall, Kubernetes is a powerful container orchestration platform that automates the deployment, scaling, and management of containerized applications. With its robust architecture and key components like Nodes, Pods, Deployments, Services, and more, Kubernetes provides a scalable and efficient solution for managing containerized workloads. By using YAML configuration files and tools like Minikube and Kubectl, developers can easily set up and interact with Kubernetes clusters both locally and in production environments.




```dataview
List
from [[csfundamental]] 
```
