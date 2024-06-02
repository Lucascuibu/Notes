#!/bin/zsh

# 确保输入了文件名
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <file1> [file2] ..."
    exit 1
fi

file_name="$1"
api_token="NB4AN5VaQKqWULicmQ28zW_Cb0rC9Uj6aD5XR43X"
for file_name in "$@"
do
    response=$(curl -s -X POST -F file=@"$file_name" -H "Authorization: Bearer $api_token" https://api.cloudflare.com/client/v4/accounts/a80a07ab720e8c829dcde19109361170/images/v1)
    variant_url=$(echo "$response" | jq -r '.result.variants[0]')
    echo "$variant_url"
done