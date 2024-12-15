#!/bin/bash


#!/bin/bash
yum update -y
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# /var/log/transfer.log에 초기 메시지 작성
echo "Congratulations! You have solved the first challenge of the CSA Threat Classification, \"Insecure Interfaces and APIs\"" | sudo tee /var/log/transfer.log

# 플래그 추가 기록
echo "The flag is \"mn-Final-Flag-Only\"." | sudo tee -a /var/log/transfer.log

# 로그 파일 읽기 권한 설정
sudo chmod 644 /var/log/transfer.log

# 초기화 완료 로그 작성
echo "EC2 instance initialized successfully with flag details logged." | sudo tee -a /var/log/instance-init.log
