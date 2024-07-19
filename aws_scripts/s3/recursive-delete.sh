for bucket in $(aws s3api list-buckets --query "Buckets[].Name" --output text); do
  aws s3 rm s3://$bucket --recursive
done

# Then, delete all buckets
for bucket in $(aws s3api list-buckets --query "Buckets[].Name" --output text); do
  aws s3api delete-bucket --bucket $bucket
done