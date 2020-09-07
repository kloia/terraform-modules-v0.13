<h1>Lambda module for terraform</h1>

This module will create Lamdba function for given config.

**Example usage for a basic Lambda:**

```hcl
module "lambda" {
  source   = "git::https://github.com/kloia/terraform-modules-v0.13//lambda"
  name     = "MyBasicLambda"
  filename = "main.js"
  handler  = "main"
  runtime  = "nodejs12.x"
}
```

This will zip the given file and stores hash of it to detect further changes. Further changes will be deployed as new versions.

You can also give directory name instead, it wil be zipped too. You can just give a zip file, and module will not create new a zip file.

You can instead give a s3 bucket and s3 key to use that instead. If version variable is given, then version updates will trigger updates. 

If s3 version is not given then module will store hash of last changed time of s3 file and checks it to trigger updates.

```hcl
module "lambda" {
  source    = "git::https://github.com/kloia/terraform-modules-v0.13//lambda"
  name      = "MyBasicLambda"
  s3_bucket = "MyJSBucket"
  s3_key    = "main.js"
  handler   = "main"
  runtime   = "nodejs12.x"
}
```

Full example for s3 based deployment. Note that `create_cw` variable will create cloudwatch log group and fixes permissions. Name will be generated based on function name.

```hcl
module "lamdba" {
  source          = "./lambda"
  create_function = true
  name            = "MyBasicLambda"
  description     = "My Basic JS Lambda"
  s3_bucket       = "MyJSBucket"
  s3_key          = "main.js"
  handler         = "main"
  runtime         = "nodejs12.x"
  create_cw       = true
  dead_letter_arn = "arn:::dlq"
  efs_arn         = "arn:::efs"
  efs_mount_path  = "/mnt/efs/"
  kms_key_arn     = "arn:::kms"
}

```
<h3>Additional variables:</h3>

`create_alb`: Enable creation of the Lambda or not. (default is true)

`tracing_mode`: Controls how the Lambda function will be monitored. (default is "PassThrough")

`dead_letter_arn` : Sets the Lambda function's dead letter que, may SQS que or SNS topic arn. Don't forget to add additional permissions for it.(Default is null)

`publish`: Sets if changes are new versions or not. (default is true)

`kms_key_arn`: Sets the kms arn to encrypt environment variables with. Normally lambda uses default key. If environment variables are not set, this arn is not calculated. (default is null)

`subnets`: A list of subnets to place the Lambda. (default is [])

`security_groups`: A list of security groups for the Lambda. (default is [])

`enable_deletion_protection`: Enable deletion protection for the ALB. (default is false)

`tags`: A map of extra tags for each resource. (Name tags are present in each resource, no need to override.)

else are same as the `aws_lambda_function` resource variables...

<h3>Output variables</h3>

`lambda_arn`: ARN of the Lambda function.

`lambda_id`: ID of the Lambda function.

`lambda_resource`: Whole aws_lambda_function resource is exported, you can use as sub element.