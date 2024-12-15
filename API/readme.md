# **Scenario: API**

- **Size**: Medium
- **Difficulty**: Moderate
- **Command**: 

---

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

---

## **Scenario Start(s)**
- API Gateway base URL provided: https://your-api-gateway-url/prod/
- Valid AWS credentials must be configured in the AWS CLI.

---

## **Scenario Goal(s)**
- Retrieve the flag from within the EC2 instance.

---

## **Summary**
The attacker exploits security vulnerabilities in the API Gateway and S3 bucket to obtain sensitive data and accesses the EC2 instance to retrieve the flag.

---

## **Exploitation Route(s)**
<img width="890" alt="API_Exploitation Route(s)" src="https://github.com/user-attachments/assets/bc003e4c-2587-4065-8c5e-127c5ef57c80" />

---


