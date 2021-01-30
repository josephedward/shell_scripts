RAW=$(curl -sb -H https://coderbyte.com/api/challenges/logs/web-logs-raw)
# echo $RAW
IFS="
"
SPLIT=($RAW)
# echo ${SPLIT[0]}
arrVar=()

for i in ${SPLIT[@]};
do 
IFS=" "
line=$(echo $i | grep "coderbyte heroku/router" )
sLine=($line)
request=${sLine[9]}
# echo $request
IFS="="
sReq=($request)
rId=${sReq[1]}
# echo $rId

fwd=${sLine[10]}
sFwd=($fwd)
fIp=${sFwd[1]}
# echo $fIp


echo $fIp
if [[ $fIp == \"MASKED\" ]] 
then
# echo stuff  
symbol=${fIp/MASKED/[M]}
symbol=${symbol%\"}
symbol=${symbol#\"}
echo $symbol
fi


arrVar+=($rId' '$symbol)
echo "
" 
done

for x in ${arrVar[@]};
do
echo $x
done