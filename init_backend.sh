#!/bin/bash

terraform -chdir=backend init
terraform -chdir=backend apply -var-file=config.tfvars -auto-approve
terraform -chdir=backend output > backend_config.tfvars