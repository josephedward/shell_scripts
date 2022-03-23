git add . && git commit -m "commit"
git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch $1" HEAD
git push -f origin main