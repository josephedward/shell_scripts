git add . && git commit -m "commit"
git filter-branch -f --index-filter "git rm -rf --cached --ignore-unmatch $1" HEAD
git push -f origin main


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