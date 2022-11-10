# Install Python Packages for AWS Lambda Layers
docker run -it ubuntu 
docker images
apt update
 apt install python3.9  
apt install python3-pip
apt install zip
mkdir -p layer/python/lib/python3.9/site-packages
pip3 install requests -t layer/python/lib/python3.9/site-packages/
cd layer  
zip -r mypackage.zip *

# New Terminal
docker ps -a
docker cp <Container-ID:path_of_zip_file>   <path_where_you_want_to_copy>
docker cp 5776ce552a74:/layer/mypackage.zip ./pymysql_layer.zip


