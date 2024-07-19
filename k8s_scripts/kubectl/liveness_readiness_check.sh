launch.sh
kubectl apply -f deploy.yaml
cat deploy.yaml
kubectl get pods --selector="name=bad-frontend"
pod=$(kubectl get pods --selector="name=bad-frontend" --output=jsonpath={.items..metadata.name})
kubectl describe pod $pod
kubectl get pods --selector="name=frontend"
pod=$(kubectl get pods --selector="name=frontend" --output=jsonpath={.items..metadata.name})
# execute multiple times
kubectl exec $pod -- /usr/bin/curl -s localhost/unhealthy
# check for restarts
kubectl get pods --selector="name=frontend"