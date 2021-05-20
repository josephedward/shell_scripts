sudo su 
apt-get update
apt-get install virtualbox
apt-get remove docker docker-engine docker.io containerd runc
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get install docker docker-engine docker.io containerd runc
sudo groupadd docker
sudo usermod -aG docker ${USER}
# su -s ${USER}
docker run hello-world 
# install k3d- unsafe
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
# in case it doesn't take
echo 'K3D_HOME=/home/linuxbrew/.linuxbrew/Cellar/k3d/4.4.3'>> .bashrc
echo 'PATH=$PATH:$K3D_HOME/bin'>> .bashrc
k3d cluster create mycluster
# writes to kubeconfig
k3d kubeconfig merge mycluster --kubeconfig-switch-context
# verify
kubectl get nodes
# install helm - unsafe
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
# verify
helm version
helm repo add verdaccio https://charts.verdaccio.org
helm repo update
# helm install verdaccio-deployment-1 verdaccio/verdaccio
echo $(helm install verdaccio-deployment-1 verdaccio/verdaccio) > verdaccio-deployment-1.info
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=verdaccio,app.kubernetes.io/instance=verdaccio-deployment-1" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT