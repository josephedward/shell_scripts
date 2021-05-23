./launch.sh
kubectl cluster-info
kubectl get nodes

kubectl create -f redis-master-controller.yaml
kubectl get rc
kubectl get pods

kubectl create -f redis-master-service.yaml
kubectl get services
kubectl describe services redis-master

kubectl create -f redis-slave-controller.yaml
kubectl get rc

kubectl create -f redis-slave-service.yaml
kubectl get services

kubectl create -f frontend-controller.yaml
kubectl get rc
kubectl get pods

kubectl create -f frontend-service.yaml
kubectl get services

kubectl get pods
kubectl describe service frontend | grep NodePort
