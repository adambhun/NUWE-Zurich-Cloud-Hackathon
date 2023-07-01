plugin "aws" {
    enabled = true
    version = "0.24.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
    enabled = true
    version = "0.4.0"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}
