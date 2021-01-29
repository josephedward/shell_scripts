touch .env
echo "MODULES=numpy,scipy,pandas
FILENAME=main.py" > .env
set -o allexport
[[ -f .env ]] && source .env
set +o allexport
IFS=','
read -ra MODULES <<<"$MODULES" 
touch Dockerfile
echo "FROM python:3" > Dockerfile 
for i in "${MODULES[@]}";
do  
echo "RUN pip install $i" >> Dockerfile  
done  
echo "CMD ['python', $FILENAME]" >> Dockerfile
HASH_OUTPUT=$(shasum -a 1 Dockerfile)
echo "HASH_OUTPUT = " $HASH_OUTPUT
docker -d -D
docker login
docker build - < Dockerfile
