kubectl apply -f clusterip.yaml
cat clusterip.yaml
kubectl get pods
kubectl get svc
kubectl describe svc/webapp1-clusterip-svc
export CLUSTER_IP=$(kubectl get services/webapp1-clusterip-svc -o go-template='{{(index .spec.clusterIP)}}')
echo CLUSTER_IP=$CLUSTER_IP
curl $CLUSTER_IP:80

kubectl apply -f clusterip-target.yaml
cat clusterip-target.yaml
kubectl get svc
kubectl describe svc/webapp1-clusterip-targetport-svc
export CLUSTER_IP=$(kubectl get services/webapp1-clusterip-targetport-svc -o go-template='{{(index .spec.clusterIP)}}')
echo CLUSTER_IP=$CLUSTER_IP
curl $CLUSTER_IP:8080

kubectl apply -f nodeport.yaml
cat nodeport.yaml
kubectl get svc
kubectl describe svc/webapp1-nodeport-svc

sed -i 's/HOSTIP/172.17.0.20/g' externalip.yaml
cat externalip.yaml
kubectl apply -f externalip.yaml
kubectl get svc
kubectl describe svc/webapp1-externalip-svc
curl 172.17.0.20

kubectl apply -f cloudprovider.yaml
kubectl get pods -n kube-system
kubectl apply -f loadbalancer.yaml
kubectl get svc
kubectl describe svc/webapp1-loadbalancer-svc
export LoadBalancerIP=$(kubectl get services/webapp1-loadbalancer-svc -o go-template='{{(index .status.loadBalancer.ingress 0).ip}}')
echo LoadBalancerIP=$LoadBalancerIP
curl $LoadBalancerIP

