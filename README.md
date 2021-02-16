### Setting up a blog in AWS using Ghost and Terraform

This stack represents some realistic usages of Terraform and AWS for reference with some common patterns.

Specifically, this stack will provision the required (outside of the few noted exceptions) resources in AWS along with executing setup code to install and host a Ghost blog on an AWS ec2 instance using a RDS Aurora serverless MySQL database for persistence.

* You should be familiar with AWS billing and cost for resources provisioned before provisioning resources.  The following usage section will provision AWS resources and you will be billed for the expense of those resources. *

## Setup

An AWS account should be created and credentials should be setup so that Terraform has the appropriate permissions to create the necessary resources.

You will need Terraform 0.13+ installed.

The infrastructure/variables.tf.sample file illustrates all the necessary configuration options that need to be specified for this to run appropriately. Copying that file to infrastructure/*.tf and replacing the placeholders is one way of specifying the parameters for this stack.

Alternatively, these can be specified on the command line.  See https://www.terraform.io/docs/language/values/variables.html for more information on this.

## Usage

The first time terraform is run, Terraform will need to be initialized with:
`terraform init`

run:

`terraform plan`

 in the infrastructure directory, check that the output plan looks correct, then run:

`terraform apply`

to create the infrastructure.

After the infrastructure has been provisioned, it may take several minutes for the user data script to fully finish.

If you wish to permanently delete the AWS resources provisioned, run:

`terraform destroy`

See https://www.terraform.io/docs/cli/commands/index.html for more information on the Terraform CLI.

## Important
This is intended to be informative, but not a complete configuration for a robust and secure web hosted blog.  Many considerations for security have been omitted for the sake of clarity of the demonstrated topics.

Another consideration of this architecture is: if the user data (scripts/blog_instance_prereqs.sh) file changes, it will force a replacement of the underlying ec2 instance.  This may not be favorable.  There are other approaches that should be considered if this is not acceptable.
