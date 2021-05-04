cd $1
git add . && git commit -m "commit"
git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch ${$2}" HEAD
git push -f origin master