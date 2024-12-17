# Mangnani WarGame 🐴
** Mangnani WarGame** is an essential educational tool that allows users to practically experience various risk scenarios that could arise in a cloud environment.**
By referencing the risk scenarios outlined in the guidelines, users can anticipate potential threats and prepare response strategies in advance. This helps in thoroughly preparing for security incidents and enhancing awareness of potential threats that could occur in real-world environments.

Specifically, Mangnani WarGame does more than just describe risk scenarios; it enables users to actively experience and respond to scenarios in real-time, which is crucial in learning how to prevent and handle security breaches. By visually presenting these scenarios, Mangnani WarGame plays a key role in helping security professionals clearly understand security risks and recognize potential threats that might occur in actual situations.

Moreover, Mangnani WarGame also serves as a means of proving the feasibility of the outlined security scenarios. By demonstrating the practical execution of these security scenarios, it helps improve security professionals’ understanding and strengthens their ability to respond to security incidents. Additionally, it plays an important role in raising awareness of security in the context of generative AI in SaaS environments. Through Mangnani WarGame, professionals become more alert to security threats and gain a more concrete understanding of the risks in cloud environments.

Lastly, Mangnani WarGame provides scenarios according to CSA risk classifications, offering a more systematic and detailed approach to handling security threats. This allows professionals to better identify various risk factors and prepare appropriate response strategies for different situations.

here is our guideline. 
▶️ https://wikidocs.net/book/16912
By visiting this link, you can find detailed security measures and checklists related to the scenarios used in the WarGame. Have a great time! 🤩


## Terraform Installation
- Linux
```
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






