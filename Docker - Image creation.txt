# Environment
1 VMs - ubuntu 16.04 LTS Or docker for mac in Mac

#check
docker version  ---> 17.06EE
docker image prune -a   ----> get rid of any image if exist


# Image is executable package - think container that is not running
# images are read only, can build further images based on them (i.e. images are made of layers)
# Container - runtime instance of an image
# When image is run(instantiated) -> a top writable layer is created (which is deleted when container is removed)
# under the hood, docker uses "storage drivers" to mangage contents in layers using CoW startegy. Docker images uses union filesystem.


-------------------------------------|
Writable layer (when container run)
-------------------------------------|
more changes
-------------------------------------|
Application
-------------------------------------|
conf changes
-------------------------------------|
OS
-------------------------------------|
Manifest
-------------------------------------|

# Dockerfile - text file , commands to create image, executed usign "docker build" command
Docker Client performs the build(using docker file). Docker daemon creates the image.

man dockerfile # How docker is used/structured
man docker build # How to use "Docker build" commands - it reads Dockerfile from directory specified(or current directory)
# https://docs.docker.com/engine/reference/builder/ (get example docker file)
vi Dockerfile
-----------------------------
# Nginx
#
# VERSION               0.0.1

FROM      ubuntu
LABEL Description="This image is used to start the foobar executable" Vendor="ACME Products" Version="1.0"
RUN apt-get update && apt-get install -y inotify-tools \
nginx \
apache2 \
openssh-server
==============================
Basics
==============================
FROM -> define base image; it must be the first instrction except any comments
LABEL -> Describe="" Version="" Anyinfoaboutimageaskeyvaluepair=""
MAINTAINER -> depricated, typically emailaddess
WORKDIR -> define working directory of containers
RUN -> run a new command in a new layer of the image
ADD -> copy file into image but also support tar and remote URL
COPY -> copy file into the image (simple form of ADD)
VOLUME -> creates a mount point (as defined), when the container is run
ENTRYPOINT -> the executable runs when a container is run (start to start a service) - can include some parameters
CMD -> provides argumnets for ENTRYPOINT  (only one CMD is allowed per Dockerfile, if multiple specified only last command will be used)
ENV -> usdd to define env variable in the container
EXPOSE -> documents the ports that should be published (when image is used as contained)
ONBUILD -> define commands when another image is built using this image

Examples:
----------
COPY fiel_from_host  file_on_image
COPY ./passwd passwd    


--------------------------------------------------------------------------------

CREATE IMAGE
=============
docker build .  # read Dockerfile in current directory and build conetxt to create image, return image id
docker image ls   # list images from host  
# Questions: How many layers created? what is the size of each layer?
docker image inspect/ docker inspect <image id>  -> give layer ids
docker image history <image id>  -> give briefly what cmd ran and size 


Example of docker build [options] 
----------------------------------\
docker build -f docker_file_name . # (specify Dockerfile and Build context: any document in Build context will be added to image)

#checkout best practices to build docker file

#--no-cache=true #if don't want to use build cache - poor choice, slow down the build
#use .dockerignore file --> to ignore certain files to land in image from build context
#sort multi line arguments (use \ in RUN instruction)
#link together apt update and install with && -> if seperated apt update will be cached and will not run again
# -t image:tag   # tag an im--squashage during build
# reduce image size: use --squash during build OR from image, run container, export container as tar, import as image  

MANAGE IMAGES
=============
docker image  #see what can you do - help file
docker image ls/ docker images -> list images
docker image rm/ docker image rmi (name|tag|id)   #remove an image #### Image can be removed only if not used by container(running/stopped) docker container ls -a # see stopped and running containers Otherwise, use --force
docker image prune  	# remove all dangling images (untagged image) that are not in use
docker image prune -a 	# remove all images that are not in use

INSPECT AN IMAGE/CONTAINERS
=================
docker image inspect image_name:tag --help
docker image inspect image_name:tag --format='{{.Id}}'   # get image id
docker image inspect image_name:tag --format='{{.ContainerConfig}}' # values of this section in a hash 
docker image inspect image_name:tag --format='{{json .ContainerConfig}}' # key-value pair in this sectoin as a hash
docker image inspect image_name:tag --format='{{.ContainerConfig.Hostname}}' # give hostname of the container from this image

TAG
======
Typically Helps to identify the VERSION of OS, Application.
However, Multiple Tags can point to same image(can see it by image id). Don't know the use case for it though.

docker image tag/ docker tag  image_id target_image[:tag]  # tag an image after it is created # if no tag provided then it will be tagged as "default"

# for public registry -> registyname/image:tag
# for private regisrty -> ipadd[:port]/Org|user/image:tag

+++++++++++++++++++++++++++++++++++++++
REDUCE IMAGE SIZE (REDUCE No of LAYERS)
+++++++++++++++++++++++++++++++++++++++
Squash down image layers to single layer:
---------------------------------------
docker version # enable "Experiment=true" # edit docker service json file and restart docker -- google it, if required

docker build --squash -f file -t image:tag .

Other way
--------------
docker container run -d image_name 
docker container export container_name > name.tar
docker image import name.tar
docker image history image_name


**************************************
DOCKER REGISTRY
**************************************
- Stateless
- highly scalable app
- stores and distribute docker images
- could be local(private) or cloud-based(private/public)
- Example : 
	Docker registy (local open source)
	DTR - Docker Trusted Registry (commercial - entriprise grade) : GUI, create multiple Orgs and users, secure image scaaning,  image can be immutable (means tags cannot be changed)
	Docker Hub (cloud based registry from docker - public and private registry)
	3rd paty - like Harbour by VMWare

Deploy a registry server (see documentation)
-------------------------------------------------------------------
docker run -d -p 5000:5000 --restart=always --name registy \
registry:2 #run a registry container


Configuring a registry server (see documentation) - its a Yaml file
-------------------------------------------------------------------
docker run -d -p 5000:5000 --restart=always --name registy \
-v `pwd`/config.yml:/etc/docker/registry/config.yml \
registry:2 #run a registry container

Login to Registry
-----------------------------
docker login localhost:5000
docker logout

#to Docker Hub registry
docker login --> need docker id form docker hub
docker logout

Pull and push images
------------------------
docker push image:tag
docker image rm image:tag
docker pull image:tag
docker images 

#for Docker hub, tag you images like "docker_username/image:tag" <equivalent to> "registry/repo:tag"


Search in regisry
--------------------
docker search [filter_opentions] search_term
--filter=starts=3
--filter "is-automated=true"
--filter=is-official=true"
--limit=100   # default is 25 result # min=1, max=100


Delete images from registry
----------------------------
docker image rm image:tag --force # delete local image
How fro non-GUI??


Docker content trust (only in Docker EE) / Docker Notary (Open source) allow self-signing image
----------------------------------------------------------------------------------
you can sign images with your private key. It will be verified when downloaded from registry.
Image signing- verify publisher
Image scanning (DTR provides it) - identigy vunaribities inside the image 