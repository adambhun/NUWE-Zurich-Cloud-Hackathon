# NUWE-Zurich-Cloud-Hackathon - Preselection Cloud challenge - Ádám Bene
# Prerequistes

- Everything defined in auto-install.sh except for localstack
TODO:
- A folder named `secrets`
- SSH key pair named `client_key` in the secrets folder.
- Python 3.9 (EXACTLY, NOT NEWER!) due to the module lambda_s3_to_dynamodb's runtime input.

## Optional prerequisites

These are the tools that are not strictly necessary for my solution to work or testing it, but I prefer to work with them:
- Taskfile - [taskfile.dev/](taskfile.dev/) - a modern makefile alternative
- tfenv - [https://github.com/tfutils/tfenv](https://github.com/tfutils/tfenv) - terraform version manager
- tflint - [https://github.com/terraform-linters/tflint](https://github.com/terraform-linters/tflint) - terraform linter
- python virtualenv - [https://virtualenv.pypa.io/](https://virtualenv.pypa.io/) - virtual python environments
- infracost - [https://www.infracost.io](https://www.infracost.io) - estimate infrastructure cost based on terraform plans
<!-- - tfcmt - [https://github.com/suzuki-shunsuke/tfcmt](https://github.com/suzuki-shunsuke/tfcmt) -  -->
- pre-commit - [https://pre-commit.com](https://pre-commit.com) - git commit hooks
- gitlint - [https://jorisroovers.com/gitlint/latest/](https://jorisroovers.com/gitlint/latest/) - validate git commit messages

- Infracost API key in the secrets folder in a file named `infracost_api_key`.

# Notes

- Created and tested on Manjaro Linux.
- I did not use localstack and tflocal, because it introduced some problems with Terraform, which I did not have time to debug.
Also, I do not refer to anything regarding AWS accounts in my Terraform code. Terraform reads such things under the hood after setting the AWS_PROFILE environment variable in the same shell session that is to be used by terraform and getting a session token with the command `aws sts get-session-token`.

## Things I did not have time for because I started working on this 1st July

- Code analysis for the lambda code with SonarQube
- Reviewing IAM stuff to grant only the most needed permissions
- Set up SQS queues for S3 upload events
- Nice commit messages

# Infrastructure
## Terraform backend

S3 with DynamoDB. This setup enables multiple users to operate Terraform without the risk of concurrent infrastructure modifications corrupting the Terraform state, by S3 being the single source of truth for the Terraform state and DynamoDB ensuring that only one user at a time can modify it.

# Usage

If you have task file installed, open a terminal in this directory and run the command `task`. It will explain all the commands.

After running `terraform apply` for the fist time, you might want to run `terraform init -force-copy` too, to copy the local state to the remote state backend.

## Uploading files to S3

On a unix-based system from a terminal window in this folder:

`sftp -i ./terraform/client_key client@<transfer_endpoint from terraform output>`

Inside sftp shell:

`put client_data.json`

### Viewing approximate infrastructure costs
The infracost API can show a cost estimation for a Terraform plan file.
Before using it, an API key must be requested by running the `infracost register` command.

First `task plan` must be run, this creates a plan file.
After that `task infracost>` can be executed to estimate the costs of the planned infrastructure.
