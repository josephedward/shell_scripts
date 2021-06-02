#npm i dependency-cruiser
# global: 
# npm install --global dependency-cruiser
#as validator: 
# npm install --save-dev dependency-cruiser
 
# 1st argument is build modules to exclude, second is root folder of project you want to analyze 
depcruise --exclude $1 --output-type dot $2 | dot -T svg > dependencygraph.svg