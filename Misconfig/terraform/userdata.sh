#!/bin/bash

# EC2의 퍼블릭 IP 주소를 가져옵니다.
EC2_PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

# 필요한 패키지 설치
apt-get update -y
apt-get install -y python3 python3-pip

# Flask와 requests 설치
pip3 install flask requests

# Flask 애플리케이션 파일 생성
echo 'from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# EC2 퍼블릭 IP 주소
EC2_PUBLIC_IP = "'$EC2_PUBLIC_IP'"

@app.route("/")
def home():
    return f"""
    <html>
        <head><title>Misconfig SSRF Page</title></head>
        <body>
            <h1>SSRF Testing Application</h1>
            <p>Try accessing the <a href="/fetch?url=http://169.254.169.254/latest/meta-data/">meta-data service</a>.</p>
            <p>Use the /fetch endpoint with a target URL:</p>
            <pre>http://{EC2_PUBLIC_IP}:5000/fetch?url=http://TARGET_URL</pre>
        </body>
    </html>
"""

@app.route("/fetch", methods=["GET"])
def fetch():
    target_url = request.args.get("url")
    if not target_url:
        return jsonify({"status": "error", "message": "No URL provided"}), 400

    try:
        response = requests.get(target_url, timeout=5)
        return jsonify({
            "status": "success",
            "data": response.text,
            "code": response.status_code
        })
    except requests.exceptions.RequestException as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
' > /home/ubuntu/app.py

# Flask 앱을 백그라운드에서 실행
nohup python3 /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &
