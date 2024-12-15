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

