Containers are a way to deploy application. Portability is advantage by keeping application isolation. They are not replacting virtualization but compliment it.

Containers Use case:
-------------------------
- CI/CD Automation
- autoscaling microservice architecture
- Container as a service
- Hybrid cloud architecture

Adv of containers:
----------------------
Docker tooling - make linux container easy
Better resource utilization (seperation at process level ant not at OS). They are light weight.
Dependencies packaged into layers
Can package multiple Os and package version
Portability - B/w env (test,dev,prod) B/w providers (Aws, rackspace, on-premise, anyone support container runtime)
Can build Immutable Infrastructure


VM contains Infrastructre, Container contain application.
----------------------------------------------------------
VM: mature, secure, infrastructure focus
Containers: fast Boot speed, small footprint, easy of patching, developer focus, better agiility



		[APP and bin and libs]   | [APP and bin and libs]
-----------------------------------------|---------------	|
GuesOSs : {         GuestOS1, 		 |    Guest OS2		|
----------------------------------------------------------------|	
Hypervisor							|
----------------------------------------------------------------|
Operating system						|
----------------------------------------------------------------|
InfrAstructure							|
----------------------------------------------------------------|




	container1 		| Container2 				|
	[APP and bin and libs]	| [APP(s*) and bin and libs ]}  |
----------------------------------------------------------------|	
Docker Engine							|
----------------------------------------------------------------|
Operating system						|
----------------------------------------------------------------|
InfrAstructure							|
----------------------------------------------------------------|

*Container can run multiple apps sharing binaries and libraries


Each Container is separate stack component means it comes with its own version of OS and Toolsets to support an application. Container needs an underlying operating system to run although the aspects of OS are within the container.
Limitation of containers: cannot mix OS (such as windows and linux)


What is containers about?
------------------------
1. They approach software development differently
2. it is NOT about managing application development process.
3. It is about structure and deployment


In container, we bind APPs to a single platform consist of
----------------------------------------
Load balancer				|
-------------				|
API					|
----					|
IAM (identity access management)	|
-----					|	
OLTP (Online transactional processing)	|
-----					|
Analytics				|
----------------------------------------|
So, its your own PaaS


Containers utilize union file systems and independent layers. OS, Application and lib all resides in container layers. Layers can be cached for fast building.

Container Reference Artitecture: security, config management(docker compose) and image management (docker registry) are other bits to consider.

----------------------------------------------------------------	
App Scheduling	- Hadoop, spark, Chronos, marathon		|
----------------------------------------------------------------|
Container Scheduling - mesos, kubernetes			|
----------------------------------------------------------------|
Service Discovery - etcd (CoreOS), consul (Hashicorp)		|
----------------------------------------------------------------|
Container Cluster Management	- Docker swarm, serf (Hashicorp)|			----------------------------------------------------------------|
Container Networking - flannel (CoreOS), 			|
                       docker plugin, docker networking		|
----------------------------------------------------------------|
Container| Container | container | 	Container| Container 	| 	
----------------------------------------------------------------|
        Container Runtime	 |Container Runtime (Docker,RKT)|
----------------------------------------------------------------|
        Container OS		 |    	Container OS (coreOS)	|
----------------------------------------------------------------|
        Physical Host or VM	 |    	Physical Host or VM	|
----------------------------------------------------------------|
 DevOps Tools - Vagrant, docker machine, AppCatalyst (VMware)	|
----------------------------------------------------------------|


WHERE TO LEVERAGE CONTAINER SUCESSFULLY?
---------------------------------------
1. They are going to add some latency in developemnt
2. They add cost and complexity - Ability to get that application in container, hook it to Db and secure it ( add compexity to dev project).
3. However, we can leverage container abstractions to manage complexity
4. Use case - Devops who want to automate development , test and deployment - automate CI/CD

5. There are more reasons not use containers than to use them - because application need to be rewritten to support container architecture - so may not be cost effective
Application may ned to broken into several component parts ( make it distributed).

6. Understand Difference between macro and micro requirements - understand application workloads requirements. 
Macro - db, applicatios, security, compliance,management, monitoring
Micro - what needs to be changed within app - may be new db, new networking, new middleware
 
7. Weight based on follwoing factors (may add or delete) - to decide whetehr to use container
Code porability
Data portability
Clould native features
App performance
Data performance
Use of service
Governance and secutiry
Business Agility


PLAN CONTAINER APPLICATION
-----------------------------
1. Pick in right applicatio and focus on distribution of services within the containers
2.Focus on what application with do and how it will live within container, remember scaling and sizing of container- what messaging system containers will use? HOw they will sync?. How to protect against simultaneous update?  - some may be handled/ not handled withing container toolset
3. Create a Plan - create structure.. try it


Container holds everything that is needed for aplication to run. It is instance of image. Images are read only templates. There are registries to store/distribute images.

Data needs to be persistent. A types of "Docker data volumes" can do it. 
- Data can be shared between host machine and docker container.
- You can share data with other containers (share common data repository - database)

Build Process
 - Install docker
 - BUild image** or docker has registry of applications available as docker images
**Building Images
docker commit can save container as image Or it can be build using Dockerfile

Launch container
 - Run a dockerised app  - sudo docker run --rm -p 3000:300 image_name (rm - remove container once the task is finished)
- can launch multiple instance of app as seperate container. Can use orchestration tool to lunch multiple instances as a cluster

Deploy
- Orchastartion system can take those images and run in groups(cluster) and canmanage resources required by the cluster - and provide scalibility, robustness and redundantcy
-Docker Trio, K8s, Mesos etc

----------------------
Docker Trio
Swarm - clustering of hosts
Compose - app composition system
machine - allow to run docker on different platform

Universal control panel(UCP) and docker datacenter - provide hoslistic container as a service platform


Docer toolset - docker engine - provide swarm,  docker hub (registry service fro images), docker trusted regisry, docker machine , docker cloud hosted service, docker UCL - manage cluster on on-premise doc host, docker compose - link containers together to from application

Docker engine:
- Orchestartion components : swarm mode manager, swarm mode worked, TLS, CA, Load balancing, service discovery, distributed store
- Others : N/W. Volumes, plugin, container runtime
----------------------------
