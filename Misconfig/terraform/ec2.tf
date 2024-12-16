# web-ec2 role
resource "aws_iam_role" "misconfig_vulnEC2Role_terraform" {
    name = "Misconfig-VulnEC2Role-terraform"
    assume_role_policy = <<ARP
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": ["sts:AssumeRole"],
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                }
            }
        ]
    }
    ARP
}

# web-ec2 policy for web-ec2 role
resource "aws_iam_policy" "misconfig_s3policy_terraform" {
    name = "Misconfig-S3Policy-terraform"
    policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": ["s3:ListAllMyBuckets"],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": ["s3:ListBucket"],
                "Resource": "arn:aws:s3:::vulnerables3"
            },
            {
                "Effect": "Allow",
                "Action": ["s3:GetObject"],
                "Resource": "arn:aws:s3:::vulnerables3/*"
            }
        ]
    }
    POLICY
}

# attach web-ec2 policy to web-ec2 role
resource "aws_iam_role_policy_attachment" "misconfig_vulnEC2Role_policy_attachment_terraform" {
    role = "${aws_iam_role.misconfig_vulnEC2Role_terraform.name}"
    policy_arn = "${aws_iam_policy.misconfig_s3policy_terraform.arn}" 
}

# profile web-ec2 instance profile
resource "aws_iam_instance_profile" "misconfig_vulnEC2Profile_terraform" {
    name = "Misconfig-VulnEC2Profile-terraform"
    role = "${aws_iam_role.misconfig_vulnEC2Role_terraform.name}"
}

resource "tls_private_key" "misconfig_EC2KeyPair_terraform" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "misconfig_EC2KeyPair_terraform" {
    key_name = "Misconfig-EC2KeyPair-terraform"
    public_key = "${tls_private_key.misconfig_EC2KeyPair_terraform.public_key_openssh}"
    provisioner "local-exec" {
    command = <<-EOT
      echo "${tls_private_key.misconfig_EC2KeyPair_terraform.private_key_pem}" > misconfig_EC2KeyPair_terraform.pem
    EOT
  }
}



resource "aws_security_group" "misconfig_EC2SecurityGroup_terraform" {
    name = "Misconfig-EC2SecurityGroup-terraform"
    vpc_id = "${aws_vpc.misconfig_vpc.id}"

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# web-ec2 instance
resource "aws_instance" "misconfig_ec2_terraform" {
  ami                    = "ami-0b2cd2a95639e0e5b"
  instance_type          = "t2.micro"
  iam_instance_profile   = "${aws_iam_instance_profile.misconfig_vulnEC2Profile_terraform.name}"
  subnet_id              = "${aws_subnet.misconfig_subnet_az1_terraform.id}"
  associate_public_ip_address = true

  # security groups
  vpc_security_group_ids = [
    "${aws_security_group.misconfig_ALBSecurityGroup_terraform.id}",
    "${aws_security_group.misconfig_EC2SecurityGroup_terraform.id}"
  ]
  key_name               = "${aws_key_pair.misconfig_EC2KeyPair_terraform.key_name}"
  
  # IMDS settings
  metadata_options {
    http_tokens = "optional"
    http_put_response_hop_limit = 1
  }

  user_data = <<-USER_DATA
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3
    pip3 install flask requests
    
    # Flask 애플리케이션 생성
    echo 'from flask import Flask, request' > /home/ubuntu/app.py
    echo 'import requests' >> /home/ubuntu/app.py
    echo 'app = Flask(__name__)' >> /home/ubuntu/app.py
    
    # /fetch 엔드포인트 추가
    echo '@app.route("/fetch", methods=["GET"])' >> /home/ubuntu/app.py
    echo 'def fetch():' >> /home/ubuntu/app.py
    echo '    url = request.args.get("url")' >> /home/ubuntu/app.py
    echo '    try:' >> /home/ubuntu/app.py
    echo '        response = requests.get(url)' >> /home/ubuntu/app.py
    echo '        return response.text' >> /home/ubuntu/app.py
    echo '    except Exception as e:' >> /home/ubuntu/app.py
    echo '        return str(e), 500' >> /home/ubuntu/app.py
    
    echo 'if __name__ == "__main__":' >> /home/ubuntu/app.py
    echo '    app.run(host="0.0.0.0", port=80)' >> /home/ubuntu/app.py
    
    # 백그라운드에서 Flask 앱 실행
    python3 /home/ubuntu/app.py &
  USER_DATA
}

# Fetch the public IP of the EC2 instance dynamically (this is for WAF usage)
data "aws_instance" "misconfig_ec2_instance_terraform" {
  instance_id = aws_instance.misconfig_ec2_terraform.id
}