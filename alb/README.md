<h1>ALB module for terraform</h1>

This module will create ALB for given config.

**Example usage for a basic ALB:**

```hcl
module "alb" {
  source = "git::https://github.com/kloia/terraform-modules-v0.13//alb"
  name   = "MyBasicALB"
}
```

You can enable access logs by `access_logs_enabled` boolean variable. You can also pass existing bucket name by `access_log_bucket_name` if you don't module will create for you.

```hcl
module "alb" {
  source                 = "git::https://github.com/kloia/terraform-modules-v0.13//alb"
  name                   = "MyBasicALB"
  access_logs_enabled    = true
  access_log_bucket_name = "my-access-logs" //if you don't pass this a bucket named tf-alb-module-(NAME)-(random 6 character long string) will be created
}
```


<h3>Additional variables:</h3>

`create_alb`: Enable creation of the ALB or not. (default is true)

`internal`: Controls if the ALB is internal. (default is false)

`subnets`: A list of subnets to place the ALB. (default is [])

`security_groups`: A list of security groups for the ALB. (default is [])

`enable_deletion_protection`: Enable deletion protection for the ALB. (default is false)

`tags`: A map of extra tags for each resource. (Name tags are present in each resource, no need to override.)

else are same as the `aws_lb` resource variables...

<h3>Output variables</h3>

`access_log_bucket_prefix`: Enabled if access logs are enabled.

`access_log_bucket_name`: Enabled if access logs are enabled.

`alb_resource`: Whole alb resource is exported, you can use as sub element.