## **Terraform Installation**
- Linux
```bash
# jq 설치 (JSON 데이터 처리 도구)
sudo apt update
sudo apt install -y jq

# HashiCorp Checkpoint API를 통해 최신 버전 확인 후 Terraform 다운로드
wget https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip

# 다운로드한 파일 압축 해제
unzip terraform_*.zip

# Terraform 바이너리를 /usr/local/bin으로 이동 (sudo 권한 필요)
sudo mv terraform /usr/local/bin/

# 설치된 Terraform 버전 확인
terraform --version
```
- MacOS
- Windows
