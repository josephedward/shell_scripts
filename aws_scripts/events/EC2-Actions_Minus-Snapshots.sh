aws events put-rule --name "EC2-Actions_Minus-Snapshots" --event-pattern '
{
  "source": ["aws.ec2"],
   "detail": {
    "state": [ { "anything-but": { "prefix": "snapshot" } } ]
  }
}'

aws sns create-topic --name EC2-Actions_Minus-Snapshots

aws events put-targets --rule EC2-Actions_Minus-Snapshots --targets "Id"="1","Arn"=$(aws sns list-topics --query 'Topics[0].TopicArn' --output text)

aws sns subscribe --topic-arn $(aws sns list-topics --query 'Topics[0].TopicArn' --output text) --protocol email --notification-endpoint josephedwardwork@gmail.com

