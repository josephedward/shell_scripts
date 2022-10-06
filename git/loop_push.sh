for f in **/; 
do 
cd $f 
ls -lash
../gh/set_secret.sh $1
../gh/make_autobot.sh
../git/git_oneshot.sh 
cd ..; 
done