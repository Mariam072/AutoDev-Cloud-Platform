env = "nonprod"

aws_region = "eu-west-1"

vpc_cidr = "10.0.0.0/16"

azs = [
  "eu-west-1a",
  "eu-west-1b"
]

#key_name = "mariam-key"

#cluster_version = "1.27"

instance_types = ["t3.small"]

node_min     = 1
node_max     = 2
node_desired = 1
