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
```bash
# Homebrew 설치 (설치되지 않은 경우)
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Homebrew 업데이트
brew update

# Terraform 설치
brew install terraform

# Terraform 버전 확인
terraform --version
```

- Windows
```bash
# 1. Chocolatey 설치 (PowerShell을 관리자 권한으로 실행)
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# 2. Terraform 설치
choco install terraform -y

# 3. Terraform 설치 확인
terraform --version
```

## **Install AWS CLI**

- Linux
```bash
# 1. AWS CLI 설치 패키지 다운로드
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# 2. 다운로드한 파일 압축 해제
unzip awscliv2.zip

# 3. AWS CLI 설치 실행
sudo ./aws/install

# 4. 설치 확인
aws --version
```

- MacOS
```bash
# 1. AWS CLI 설치 패키지 다운로드
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"

# 2. 설치 실행
sudo installer -pkg AWSCLIV2.pkg -target /

# 3. 설치 확인
aws --version
```

- Windows
```bash
# 1. AWS CLI 설치 파일 다운로드
Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile "AWSCLIV2.msi"

# 2. AWS CLI 설치 실행
Start-Process msiexec.exe -ArgumentList '/i AWSCLIV2.msi /quiet' -Wait

# 3. 설치 확인
aws --version
```

## **Configure AWS CLI**
```bash
$ aws configure
# AWS Access Key ID: <Your Access Key>
# AWS Secret Access Key: <Your Secret Key>
# Default region name: <ap-northeast-1>
# Default output format: json
```

## **Clone the Git Repository**
```bash
git clone https://github.com/mangnani-bob24/mang_wargame.git
cd mang_wargame
cd API
```

## **Start Terraform**
```bash
# Terraform 초기화
terraform init
# Terraform 계획 확인
terraform plan
# Terraform 실행 계획 자동 승인 및 적용
terraform apply -auto-approve
```

## **Explore API Gateway**
```bash
# Example: 사용 가능한 API 엔드포인트 가져오기
curl -X GET https://your-api-gateway-url/prod/<path>
```

## **Access S3 Bucket and Verify Data**
```bash
# 특정 버킷의 내용 확인
aws s3 ls s3://<bucket-name>
# 파일 다운로드
aws s3 cp s3://<bucket-name>/<file_name> .
```

## **Access the EC2 Instance**
```bash
# SSM Session 시작
aws ssm start-session --target <EC2-INSTANCE-ID>
# 파일 확인
cat <file_path>
```

## **Terminate Terraform**
```bash
# Terraform 생성된 모든 리소스 리스트
terraform state list
# Terraform 생성된 모든 리소스 확인 요청 없이 삭제
terraform destroy -auto-approve
```
