# Overview


## Terraform Installation
- Linux
```
wget https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip
wget https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip
unzip terraform_*.zip
sudo mv terraform /usr/local/bin/
terraform --version
```
- MacOS
```
brew install terraform
terraform --version
```

- Windows
Visit this URL : https://www.terraform.io/
and run this command
```
terraform --version

```
## Install AWS CLI
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```
## configure aws CLI
```
aws configure
# AWS Access Key ID: <Your Access Key>
# AWS Secret Access Key: <Your Secret Key>
# Default region name: <ap-northeast-1>
# Default output format: json

```

## Start Terraform
```
terraform init
terraform plan
terraform apply
```

## Run virtualenv
```
python3 -m venv myenv
source myenv/bin/activate
```

## Run Python App
```
python3 /home/ubuntu/app.py &
```


## Terminate Terraform
```
terraform destroy
```






