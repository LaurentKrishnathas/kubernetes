# @author Laurent Krishnathas
# @version 2017/10/19

# common variables
container_name=docker_init
image_name=laurent_krishnathas/docker_init

version=snapshot-`git rev-parse --short HEAD`
created=""
image_version=snapshot_$(git rev-parse --short HEAD)
dockerfile=app.Dockerfile

FUNC=makefile.sh

# DEPLOYMENT_NAME=nginx-deployment

DEPLOYMENT_NAME=mysql-deployment

k8s_getpods:
	kubectl get pods

k8s_apply:
	kubectl apply -f $(DEPLOYMENT_NAME).yml
	
k8s_describe:
	kubectl describe deployment $(DEPLOYMENT_NAME)

k8s_delete:
	kubectl delete deployment  $(DEPLOYMENT_NAME)

k8s_connnect_mysql:
	kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword


# 
# hello:
# 	echo "hello this is the version $(version)"
# 	echo "created on $(created)"
# 
# hello_script:
# 	$(FUNC) test
# 
# docker_build:
# 	docker build -t $(image_name):$(image_version) --rm=false -f $(dockerfile) .
# 
# docker_stop:
# 	docker stop $(container_name) || echo WARNING $(container_name) may not exist 
# 	docker rm -f $(container_name) || echo WARNING $(container_name)  may not exist 
# 
# docker_run: docker_stop docker_build
# 	docker image ls |grep $(container_name) 
# 	docker run -d --name $(container_name) -v $$HOME/.aws:/root/.aws  $(image_name):$(image_version)
# 
# docker_log: 
# 	docker image ls |grep $(container_name) 
# 	docker ps |grep $(container_name) 
# 	docker logs -f $(container_name) 
# 
# docker_push: docker_build
# 	docker tag $(image_name):$(image_version) $$ECR_REGISTRY_URI/$(image_name):$(image_version)
# 	docker push $$ECR_REGISTRY_URI/$(image_name):$(image_version)
# 
# docker_all: docker_run docker_log
# 
# docker_exec:
# 	docker exec $(container_name) tail -f /var/log/script.log