#!/bin/bash

# Define the list of buckets
buckets=(
      "*",
      "*"
)

# Define the destination directory for each bucket
destination_base="/Users/user1/Desktop"

# Loop through each bucket and sync its contents
for bucket in "${buckets[@]}"; do
    echo "Syncing s3://$bucket to $destination_base/$bucket"
    aws s3 sync s3://$bucket $destination_base/$bucket
done

echo "All buckets have been synced."
