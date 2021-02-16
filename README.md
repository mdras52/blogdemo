### Setting up a blog in AWS using Ghost and Terraform

This stack represents some realistic usages of Terraform and AWS for reference with some common patterns.

## Usage

Assuming an AWS account is created and credentials are setup that have appropriate  permissions to create the resources specified in the infrastructure directory:

Download Terraform 0.13 + and install
create an infrastructure/variables.tf file from the infrastructure/variables.tf.sample file

Or alternatively, supply them on the command line

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
