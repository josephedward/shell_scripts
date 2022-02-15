for f in **/; 
do 
cd $f 
ls -lash
../shell_scripts/git/add_to_gitignore.sh
../shell_scripts/git/git_oneshot.sh 
cd ..; 
done