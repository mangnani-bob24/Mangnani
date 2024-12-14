# web-ec2 role
resource "aws_iam_role" "misconfig-vulnEC2Role" {
    name = "misconfig-vulnEC2Role"
    assume_role_policy = <<ARP
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Deny",
                "Action": ["*"],
                "Resource": ["*"],
                "Condition": {
                    "DateLessThan": {
                        "aws:TokenIssueTime": "2024-12-01T00:00:00Z"
                    }
                }
            }
        ]
    }
    ARP
}

# web-ec2 policy for web-ec2 role
resource "aws_iam_policy" "misconfig-s3policy" {
    name = "misconfig-s3policy"
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
resource "aws_iam_role_policy_attachment" "misconfig-vulnEC2Role-policy-attachment" {
    role = "${aws_iam_role.misconfig-vulnEC2Role.name}"
    policy_arn = "${aws_iam_policy.misconfig-s3policy.arn}" 
}

# profile web-ec2 instance profile
resource "aws_iam_instance_profile" "misconfig-vulnEC2Profile" {
    name = "misconfig-vulnEC2Profile"
    role = "${aws_iam_role.misconfig-vulnEC2Role.name}"
}

# web-ec2 security groups
resource "aws_security_group" "misconfig-ALBSecurityGroup" {
    name = "misconfig-ALBsecurityGroup"
    vpc_id = "${aws_vpc.misconfig-vpc.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "HTTP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "HTTPS"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "misconfig-EC2SecurityGroup" {
    name = "misconfig-EC2SecurityGroup"
    vpc_id = "${aws_vpc.misconfig-vpc.id}"

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "HTTP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "SSH"
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
        protocol = "HTTP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
# web-ec2 ssh key pair
resource "aws_key_pair" "misconfig-EC2KeyPair" {
    key_name = "misconfig-EC2KeyPair"
    public_key = "${file("${path.module}/misconfig-EC2KeyPair.pub")}"
}

# web-ec2 instance
resource "aws_instance" "misconfig_ec2" {
  ami                    = "ami-0b2cd2a95639e0e5b"
  instance_type          = "t2.micro"
  iam_instance_profile   = "${aws_iam_instance_profile.misconfig-vulnEC2Profile.name}"
  subnet_id              = "${aws_subnet.misconfig_subnet.id}"
  associate_public_ip_address = true

  # security groups
  vpc_security_group_ids = [
    "${aws_security_group.misconfig-ALBSecurityGroup.id}",
    "${aws_security_group.misconfig-EC2SecurityGroup.id}"
  ]
  key_name               = "${aws_key_pair.misconfig-EC2KeyPair.name}"
  
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
data "aws_instance" "misconfig_ec2_instance" {
  instance_id = aws_instance.misconfig_ec2.id
}
