
global = {
  region                = "us-west-2"
  availability_zones    = "us-west-2a,us-west-2b,us-west-2c"
  key_name              = "redapt-dev"
  environment           = "dev"
  vpc_name              = "redapt-dev"
  vpc_cidr              = "10.0.0.0/16"
  public_sub            = "10.0.10.0/24,10.0.11.0/24"
  private_sub           = "10.0.20.0/24,10.0.21.0/24" 
  enable_dns_hostnames  = "true"
  enable_dns_support    = "true"
}

elb = {
  foo                   = "bar"
}

ec2 = {
  foo                   = "bar"
}
