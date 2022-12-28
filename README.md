Terraform AWS ACM Certificate
=============================

[![CircleCI](https://circleci.com/gh/infrablocks/terraform-aws-acm-certificate.svg?style=svg)](https://circleci.com/gh/infrablocks/terraform-aws-acm-certificate)

A Terraform module to create and DNS validate an ACM certificate.

The certificate deployment depends on an existing Route53 hosted zone.

The certificate deployment consists of:

* an ACM certificate for the specified domain and SANs
* domain validation records fot the specified domain and all SANs

Usage
-----

To use the module, include something like the following in your Terraform
configuration:

```hcl-terraform
module "acm_certificate" {
  source  = "infrablocks/acm-certificate/aws"
  version = "1.1.0"

  domain_name    = "*.${data.terraform_remote_state.domain.outputs.domain_name}"
  domain_zone_id = data.terraform_remote_state.domain.outputs.public_zone_id

  subject_alternative_names        = []
  subject_alternative_name_zone_id = data.terraform_remote_state.domain.outputs.public_zone_id

  providers = {
    aws.certificate       = aws
    aws.domain_validation = aws
    aws.san_validation    = aws
  }
}
```

See the
[Terraform registry entry](https://registry.terraform.io/modules/infrablocks/acm-certificate/aws/latest)
for more details.

### Inputs

| Name                             | Description                                                                               | Default | Required |
|----------------------------------|-------------------------------------------------------------------------------------------|:-------:|:--------:|
| domain_name                      | The domain name of the certificate to manage.                                             |    -    |   yes    |
| domain_zone_id                   | The ID of the hosted zone in which to manage domain validation records.                   |    -    |   yes    |
| subject_alternative_names        | The subject alternative names of the certificate to manage.                               |   []    |    no    |
| subject_alternative_name_zone_id | The ID of the hosted zone in which to create subject alternative name validation records. |    -    |   yes    |

### Outputs

| Name               | Description                                                                            |
|--------------------|----------------------------------------------------------------------------------------|
| certificate_arn    | The ARN of the managed certificate.                                                    |
| domain_validations | A list of the domain validations that have been performed for the managed certificate. |

### Compatibility

This module is compatible with Terraform versions greater than or equal to
Terraform 1.0.

Development
-----------

### Machine Requirements

In order for the build to run correctly, a few tools will need to be installed
on your development machine:

* Ruby (3.1.1)
* Bundler
* git
* git-crypt
* gnupg
* direnv
* aws-vault

#### Mac OS X Setup

Installing the required tools is best managed by [homebrew](http://brew.sh).

To install homebrew:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Then, to install the required tools:

```
# ruby
brew install rbenv
brew install ruby-build
echo 'eval "$(rbenv init - bash)"' >> ~/.bash_profile
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
eval "$(rbenv init -)"
rbenv install 3.1.1
rbenv rehash
rbenv local 3.1.1
gem install bundler

# git, git-crypt, gnupg
brew install git
brew install git-crypt
brew install gnupg

# aws-vault
brew cask install

# direnv
brew install direnv
echo "$(direnv hook bash)" >> ~/.bash_profile
echo "$(direnv hook zsh)" >> ~/.zshrc
eval "$(direnv hook $SHELL)"

direnv allow <repository-directory>
```

### Running the build

Running the build requires an AWS account and AWS credentials. You are free to
configure credentials however you like as long as an access key ID and secret
access key are available. These instructions utilise
[aws-vault](https://github.com/99designs/aws-vault) which makes credential
management easy and secure.

To run the full build, including unit and integration tests, execute:

```bash
aws-vault exec <profile> -- ./go
```

To run the unit tests, execute:

```bash
aws-vault exec <profile> -- ./go test:unit
```

To run the integration tests, execute:

```bash
aws-vault exec <profile> -- ./go test:integration
```

To provision the module prerequisites:

```bash
aws-vault exec <profile> -- ./go deployment:prerequisites:provision[<deployment_identifier>]
```

To provision the module contents:

```bash
aws-vault exec <profile> -- ./go deployment:root:provision[<deployment_identifier>]
```

To destroy the module contents:

```bash
aws-vault exec <profile> -- ./go deployment:root:destroy[<deployment_identifier>]
```

To destroy the module prerequisites:

```bash
aws-vault exec <profile> -- ./go deployment:prerequisites:destroy[<deployment_identifier>]
```

Configuration parameters can be overridden via environment variables. For
example, to run the unit tests with a seed of `"testing"`, execute:

```bash
SEED=testing aws-vault exec <profile> -- ./go test:unit
```

When a seed is provided via an environment variable, infrastructure will not be
destroyed at the end of test execution. This can be useful during development
to avoid lengthy provision and destroy cycles.

To subsequently destroy unit test infrastructure for a given seed:

```bash
FORCE_DESTROY=yes SEED=testing aws-vault exec <profile> -- ./go test:unit
```

### Common Tasks

#### Generating an SSH key pair

To generate an SSH key pair:

```
ssh-keygen -m PEM -t rsa -b 4096 -C integration-test@example.com -N '' -f config/secrets/keys/bastion/ssh
```

#### Generating a self-signed certificate

To generate a self signed certificate:

```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
```

To decrypt the resulting key:

```
openssl rsa -in key.pem -out ssl.key
```

#### Managing CircleCI keys

To encrypt a GPG key for use by CircleCI:

```bash
openssl aes-256-cbc \
  -e \
  -md sha1 \
  -in ./config/secrets/ci/gpg.private \
  -out ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

To check decryption is working correctly:

```bash
openssl aes-256-cbc \
  -d \
  -md sha1 \
  -in ./.circleci/gpg.private.enc \
  -k "<passphrase>"
```

Contributing
------------

Bug reports and pull requests are welcome on GitHub at
https://github.com/infrablocks/terraform-aws-acm-certificate.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
-------

The library is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
