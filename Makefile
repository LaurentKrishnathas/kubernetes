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
JENKINS_CHART=jenkins

k8s_getpods:
	kubectl get pods,svc,deployment

k8s_apply:
	kubectl apply -f $(DEPLOYMENT_NAME).yml
	
k8s_describe:
	kubectl describe deployment $(DEPLOYMENT_NAME)

k8s_delete:
	kubectl delete deployment  $(DEPLOYMENT_NAME)

k8s_connnect_mysql:
	kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword

ps:
#	@docker ps | echo "?"
	@echo "----------------------------------------------------------------------------------------------------------"
	@helm ls
	@echo "----------------------------------------------------------------------------------------------------------"
	@kubectl get pods,svc,deployment
	@echo "----------------------------------------------------------------------------------------------------------"
	@docker stats --no-stream | grep jenkins


helm_jenkins_install:
#	helm install --name $(JENKINS_CHART)  --set Master.ServiceType=NodePort,Persistence.Enabled=false stable/jenkins
	helm install --name $(JENKINS_CHART)   -f jenkins-values.yml stable/jenkins

helm_jenkins_purge:
	helm del --purge $(JENKINS_CHART)

helm_jenkins_password:
	printf $$(kubectl get secret --namespace default $(JENKINS_CHART)-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

jenkins_url:
	minikube service $(JENKINS_CHART)-jenkins

helm_jenkins_delete:
	helm delete $(JENKINS_CHART)
	helm del --purge $(JENKINS_CHART) | echo "ignored"

logs:
	minikube logs
	minikube logs -f
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