# S3 Study Hall Project

From your Cloud9 development environment you should be able to use these AWS CLI commands to complete hosting a static site on S3.

## Create a Bucket via CLI

* Create your new bucket: `aws s3 mb s3://$BUCKET_NAME --region us-east-1`
* Delete the Block Public Access on your bucket: `aws s3api delete-public-access-block --bucket $BUCKET_NAME --region us-east-1`
* Enable Static Website Hosting `aws s3 website $BUCKET_NAME --index-document index.html --error-document error.html`
* Put Bucket Policy on your bucket to allow Public Access: `aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://example-policy.json`
    * Note: You must modify the Bucket Policy to include *YOUR* Bucket ARN or the policy will not work.
    * *Stretch Goal* how can you get the bucket ARN via AWS CLI? What commands would you use?
* Change your directory to the cafe-site directory: `cd cafe-site`
* Put the static objects into your bucket: `aws s3 cp --recursive . s3://$BUCKET_NAME`
* Visit your site from the Bucket Endpoint: http://bucket-name.s3-website-region.amazonaws.com (Must change the bucket name and region to the ones you are using!)
* *Stretch Goal* How can you remove files from your S3 bucket via AWS CLI? 
* Can you remove a bucket that still has files in it?
* *REALLY BIG Stretch Goal* How can you grant another AWS Account access to update your `index.html` file only? Can you test this with a bucket policy with one of your fellow students?


## Example Bucket Policy:

``{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::YourBucketName/*"
      ]
    }
  ]
}``
