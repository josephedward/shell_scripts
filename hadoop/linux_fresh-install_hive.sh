# ************ INCOMPLETE ************

sudo apt install default-jre
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
sudo apt-get install ssh
sudo apt-get install pdsh
# uninstall old docker stuff 
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
# setup repository
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
# official docker pgp key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
wget http://apache.mirrors.tds.net/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz