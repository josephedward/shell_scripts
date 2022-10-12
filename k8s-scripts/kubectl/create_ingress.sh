cat deployment.yaml
kubectl apply -f deployment.yaml
kubectl get deployment

cat ingress.yaml
kubectl create -f ingress.yaml
kubectl get deployment -n nginx-ingress

cat ingress-rules.yaml
kubectl create -f ingress-rules.yaml
kubectl get ing

curl -H "Host: my.kubernetes.example" 172.17.0.12/webapp1
curl -H "Host: my.kubernetes.example" 172.17.0.12/webapp2
curl -H "Host: my.kubernetes.example" 172.17.0.12
