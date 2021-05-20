# 
sudo su


brew services start mongodb-community
echo 'mongo started'

echo 'attempting to close ports'
killall -9 node
echo 'ports test:'
lsof -i tcp:8887 
lsof -i tcp:8888 



 