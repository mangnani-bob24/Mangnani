# **Scenario: API**

- **Size**: Medium
- **Difficulty**: Easy
- **Command**:
  
  - **Terraform Installation**
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
      
  - **Install AWS CLI**
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
      
  - **Configure AWS CLI**
    ```bash
    $ aws configure
      # AWS Access Key ID: <Your Access Key>
      # AWS Secret Access Key: <Your Secret Key>
      # Default region name: <ap-northeast-1>
      # Default output format: json
    ```
    
  - **Clone the Git Repository**
    ```bash
    git clone https://github.com/mangnani-bob24/mang_wargame.git
    cd mang_wargame
    cd API
    ```
    
  - **Start Terraform**
     ```bash
    # Terraform 초기화
    terraform init
    # Terraform 계획 확인
    terraform plan
    # Terraform 실행 계획 자동 승인 및 적용
    terraform apply -auto-approve
    ```
     
  - **Terminate Terraform**
    ```bash
    # Terraform 생성된 모든 리소스 리스트
    terraform state list
    # Terraform 생성된 모든 리소스 확인 요청 없이 삭제
    terraform destroy -auto-approve
    ```
   
## **Scenario Resources**

- **1 VPC**:  
   - Public Subnet
   - VPC Endpoints  
   - Internet Gateway
   - Route Table  
   - Security Groups for SSM
     
- **1 EC2 Instance**
  
- **1 IAM**
   - IAM Role
   - Instance Profile 
   - IAM Policies

- **1 S3 Bucket**   

- **1 API Gateway** 

- **5 AWS Lambda Functions**

## **Scenario Start(s)**
- API Gateway base URL provided: https://your-api-gateway-url/prod/
- Valid AWS credentials must be configured in the AWS CLI.

## **Scenario Goal(s)**
- **Explore the API and S3 to retrieve the final flag from the EC2 server's log file.**
  
  - **Steps**
     1. **AWS Access Configuration**  
         - Set up valid AWS credentials to prepare for resource access.  
  
     2. **API Endpoint Exploration**  
         - Explore the base path and vulnerable endpoints to gather hints.  
  
     3. **File Retrieval**  
         - Download critical files from the S3 bucket and extract additional information.  
  
     4. **External Server Access**  
         - Connect to the EC2 server and analyze the log file to retrieve the final flag.
            
  - **Final Goal**  
    - **Retrieve the final flag from the EC2 server's log file.**  

## **Summary**
The attacker exploits security vulnerabilities in the API Gateway and S3 bucket to obtain sensitive data and accesses the EC2 instance to retrieve the flag.

## **Exploitation Route(s)**
<img width="890" alt="API_Exploitation Route(s)" src="https://github.com/user-attachments/assets/bc003e4c-2587-4065-8c5e-127c5ef57c80" />
