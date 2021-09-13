for f in **/; 
do 
cd $f 
ls -lash
../shell_scripts/git/git_oneshot.sh 
cd ..; 
done

