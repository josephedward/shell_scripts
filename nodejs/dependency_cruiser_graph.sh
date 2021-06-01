#npm i dependency-cruiser

# global: 
# npm install --global dependency-cruiser

#as validator: 
# npm install --save-dev dependency-cruiser
 
# what is this? 
# depcruise --include-only "^src" --output-type dot $1 | dot -T svg > dependencygraph.svg

# argument is root folder of project you want to analyze 
depcruise --exclude "^node_modules" --output-type dot $1 | dot -T svg > dependencygraph.svg