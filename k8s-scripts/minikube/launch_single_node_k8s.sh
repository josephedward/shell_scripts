minikube version
minikube start
kubectl cluster-info
kubectl get nodes
kubectl create deployment first-deployment --image=katacoda/docker-http-server
kubectl get pods
kubectl expose deployment first-deployment --port=80 --type=NodePort
# test command 
export PORT=$(kubectl get svc first-deployment -o go-template='{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}')
echo "Accessing host01:$PORT"
curl host01:$PORT
minikube addons enable dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
minikube dashboard --url
