module "s3" {
    source = "./s3"
    bucket_name = "kloiabucket"
    tags = {
        "Project" = "Everything-as-a-code"
    }
}
