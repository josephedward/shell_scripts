for f in **/; 
do 
cd $f 
ls -lash
../shell_scripts/gh/set_secret.sh $1
../shell_scripts/gh/make_autobot.sh
../shell_scripts/git/git_oneshot.sh 
cd ..; 
done