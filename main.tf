terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

provider "aws" {
  profile = "awsbootstrap"
  region  = "eu-central-1"
}

resource "aws_appconfig_application" "my_app_config" {
  name        = "my app config"
  description = "Example AppConfig Application"

  tags = {
    Type = "Example AppConfig Application"
  }
}

resource "aws_appconfig_environment" "alpha" {
  name           = "alpha"
  description    = "Example AppConfig Environment"
  application_id = aws_appconfig_application.my_app_config.id

  tags = {
    Type = "Example AppConfig Environment"
  }
}

resource "aws_appconfig_configuration_profile" "my_app_config_profile" {
  application_id = aws_appconfig_application.my_app_config.id
  description    = "Example Configuration Profile"
  name           = "example-configuration-profile-tf"
  location_uri   = "hosted"

  tags = {
    Type = "AppConfig Configuration Profile"
  }
}

resource "aws_appconfig_hosted_configuration_version" "example_config" {
  application_id           = aws_appconfig_application.my_app_config.id
  configuration_profile_id = aws_appconfig_configuration_profile.my_app_config_profile.configuration_profile_id
  description              = "Example Freeform Hosted Configuration Version"
  content_type             = "application/json"

  content = jsonencode({
    foo            = "bar",
    fruit          = ["apple", "pear", "orange"],
    isThingEnabled = true
    baz            = { a : 1, b : "2" }
  })
}

resource "aws_appconfig_deployment_strategy" "example_strategy" {
  name                           = "example-deployment-strategy-tf"
  description                    = "Example Deployment Strategy"
  deployment_duration_in_minutes = 1
  final_bake_time_in_minutes     = 1
  growth_factor                  = 10
  growth_type                    = "LINEAR"
  replicate_to                   = "NONE"

  tags = {
    Type = "AppConfig Deployment Strategy"
  }
}

resource "aws_appconfig_deployment" "example_deployment" {
  application_id           = aws_appconfig_application.my_app_config.id
  configuration_profile_id = aws_appconfig_configuration_profile.my_app_config_profile.configuration_profile_id
  configuration_version    = aws_appconfig_hosted_configuration_version.example_config.version_number
  deployment_strategy_id   = aws_appconfig_deployment_strategy.example_strategy.id
  description              = "My example deployment"
  environment_id           = aws_appconfig_environment.alpha.environment_id

  tags = {
    Type = "AppConfig Deployment"
  }
}
