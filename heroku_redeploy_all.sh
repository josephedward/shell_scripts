heroku login 
heroku plugins:install heroku-releases-retry
apps=$(heroku apps) 
IFS=" "
apps1=($apps)
IFS="
"
appList=(${apps1[@]:2})
set +e
for x in ${appList[@]};
    do
    heroku releases:retry --app $x
    done
