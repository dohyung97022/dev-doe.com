BUCKET_NAME=dev-doe.com
WWW_BUCKET_NAME=www.$BUCKET_NAME
REGION=ap-northeast-2
FRONTEND_LOCATION=$PWD/templates/dist

# build
cd templates
npm run build
cd ..

# bucket 생성
aws s3api create-bucket --bucket ${BUCKET_NAME} --region ${REGION}  --create-bucket-configuration LocationConstraint=${REGION}
aws s3api create-bucket --bucket ${WWW_BUCKET_NAME} --region ${REGION}  --create-bucket-configuration LocationConstraint=${REGION}

# bucket public access 허용
aws s3api delete-public-access-block --bucket ${BUCKET_NAME}
aws s3api delete-public-access-block --bucket ${WWW_BUCKET_NAME}

echo "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Effect\": \"Allow\",
            \"Principal\": \"*\",
            \"Action\": \"s3:GetObject\",
            \"Resource\": \"arn:aws:s3:::$BUCKET_NAME/*\"
        },
        {
            \"Effect\": \"Allow\",
            \"Principal\": {
               \"AWS\": \"*\"
            },
            \"Action\": \"S3:PutBucketWebsite\",
            \"Resource\": \"arn:aws:s3:::$BUCKET_NAME\"
         }
    ]
}" > bucket_policy.json

# policy 적용
aws s3api put-bucket-policy --bucket ${BUCKET_NAME} --policy file://$PWD/bucket_policy.json
sed -i "" "s/${BUCKET_NAME}/${WWW_BUCKET_NAME}/g" bucket_policy.json
aws s3api put-bucket-policy --bucket ${WWW_BUCKET_NAME} --policy file://$PWD/bucket_policy.json

# rm policy
rm bucket_policy.json

# 파일 업로드
aws s3 sync ${FRONTEND_LOCATION} s3://${BUCKET_NAME}/

# s3 website 적용
aws s3 website s3://${BUCKET_NAME}/ --index-document index.html --error-document index.html

# www bucket 은 redirect
echo "{
  \"RedirectAllRequestsTo\": {
    \"HostName\": \"${BUCKET_NAME}\",
    \"Protocol\": \"https\"
  }
}" > redirect_policy.json
aws s3api put-bucket-website --bucket ${WWW_BUCKET_NAME} --website-configuration file://redirect_policy.json
rm redirect_policy.json

# 엔드포인트
echo https://${BUCKET_NAME}.s3.${REGION}.amazonaws.com/index.html

# certificate, cloudfront, route53 should be manually configured
# https://www.youtube.com/watch?v=mls8tiiI3uc