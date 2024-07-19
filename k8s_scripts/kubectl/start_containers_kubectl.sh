minikube start --wait=false
kubectl get node
# start a container based on the Docker Image katacoda/docker-http-server:latest
kubectl run http --image=katacoda/docker-http-server:latest --replicas=1
kubectl get deployments
kubectl describe deployment http
# expose container port 80 on the host 8000 binding to the external-ip of the host.
kubectl expose deployment http --external-ip="172.17.0.42" --port=8000 --target-port=80
# verifry
curl http://172.17.0.42:8000
# deploy and expose as single command
kubectl run httpexposed --image=katacoda/docker-http-server:latest --replicas=1 --port=80 --hostport=8001
curl http://172.17.0.42:8001
# exposes the Pod via Docker Port Mapping
# will not see the service listed using 'kubectl get svc'
# see details with: 
docker ps | grep httpexposed
# adjust the number of Pods running for this deployment
kubectl scale --replicas=3 deployment http
# 3 running pods for http deployment
kubectl get pods
#  describing the service you can view the endpoint and the associated Pods which are included.
kubectl describe svc http
# requests to the service will request in different nodes processing the request.
curl http://172.17.0.42:8000
