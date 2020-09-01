<h1>ECS Fargate module for terraform</h1>

This module will create Fargate cluster for given config.

**Example usage for a basic Fargate cluster:**

```hcl
module "fargate" {
    source = "git::https://github.com/kloia/terraform-modules-v0.13//fargate"
    name   = "MyBasicFargateCluster"
}
```

- You can choose to create module or not by `enabled` boolean variable.

- You can enable access container insights by `container_insights_enabled` boolean variable.

- You can set capacity provider to **spot instances** instead of normal instances by `spot_enabled` boolean variable.

- You can set tags, there is default implemented `Name` tag in module.

<h3>Full example</h3>

```hcl
module "fargate" {
  source       = "git::https://github.com/kloia/terraform-modules-v0.13//fargate"
  name         = "MyBasicFargateCluster"
  spot_enabled = true
  enabled      = true
  weight       = 80
  base         = 5

  container_insights_enabled = true

  tags = {
    Environment = "Production"
  }
}
```


<h3>Additional variables:</h3>

`weight`: The relative percentage of the total number of launched tasks that should use the specified capacity provider.

`base`: The number of tasks, at a minimum, to run on the specified capacity provider. Only one capacity provider in a capacity provider strategy can have a base defined.



<h3>Output variables</h3>

`arn`: The Amazon Resource Name (ARN) that identifies the cluster.

`fargate_cluster`: Whole fargate cluster resource is exported, you can use as subelement.