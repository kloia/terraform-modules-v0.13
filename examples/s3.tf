module "s3" {
    source = "git::https://github.com/kloia/terraform-modules-v0.13//s3"
    bucket_name = "kloiabucket"
    tags = {
        "Project" = "Everything-as-a-code"
    }
}
