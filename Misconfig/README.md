
# Scenario: Misconfig

**Size:** Medium        

**Difficulty:** Moderate    

**Command:**

- creation: `$ terraform init; terraform apply`
- destruction: `$ terraform destroy`

## Scenario Resources

- 1 VPC with:
    - EC2 x 1
    - ALB x 1
    - WAF x 1
- 1 S3 Bucket

## Scenario Start(s)
- main 
    - EC2 PublicIP
- etc
    - alb_arn, alb_dns_name, target_group_arn, 

You are provided with the EC2 PublicIP and you can access to the "http://[EC2_PUBLIC_IP]:5000/"


## Scenario Story

1. **Access the web application via EC2 Public IP:**
The public IP of the EC2 instance is provided. You can access the web application at http://[EC2_PUBLIC_IP]:5000/. This web application has an SSRF vulnerability through the /fetch endpoint that attempts to connect to the metadata service.
2. **Discover the URL to access the metadata server:**
The web application provides a hint through the URL /fetch?url=http://169.254.169.254/latest/meta-data/. This URL points to the basic endpoint of the EC2 metadata service, which provides crucial information regarding metadata and IAM credentials.
3. **Access the metadata server using a curl request:**
Exploiting the SSRF vulnerability, send a curl request to the EC2 instance’s metadata service (169.254.169.254) to retrieve IAM credential-related information. This information allows access to the IAM role credentials assigned to the EC2 instance.
4. **Obtain the credentials of the EC2's assigned IAM role:**
Retrieve the IAM role credentials associated with the EC2 instance. This includes the access key, secret key, and session token.
5. **Escalate privileges using the obtained IAM credentials:**
Use the aws configure command to create a new profile, entering the access key, secret key, and session token to escalate privileges.
6. **Check the policies assigned to the elevated privileges:**
Review the policies that are assigned to the elevated IAM role to verify permissions.
7. **Verify S3 listing permissions and enumerate public objects in the S3 bucket:**
Check the permissions for listing S3 buckets, and list the objects in the publicly accessible S3 bucket.
8. **Download the flag.txt file and view it locally:**
Retrieve the flag.txt file from the S3 bucket and download it to view the flag.

## Scenario Goal(s)
Due to incorrect WAF configuration, exploit an SSRF vulnerability to access the IMDSv1 endpoint, capture IAM credentials, and then download the flag file (flag.txt) stored in an S3 Bucket.
