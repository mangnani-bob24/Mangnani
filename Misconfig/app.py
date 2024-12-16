from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# EC2 퍼블릭 IP 주소 (고정값)
EC2_PUBLIC_IP = "52.195.82.56"

# 기본 경로
@app.route('/')
def home():
    return f'''
    <html>
        <head><title>Misconfig SSRF Page</title></head>
        <body>
            <h1>SSRF Testing Application</h1>
            <p>Try accessing the <a href="/fetch?url=http://169.254.169.254/latest/meta-data/">meta-data service</a>.</p>
            <p>Use the /fetch endpoint with a target URL:</p>
            <pre>http://{EC2_PUBLIC_IP}:5000/fetch?url=http://TARGET_URL</pre>
        </body>
    </html>
    '''

# SSRF 취약점이 있는 엔드포인트
@app.route('/fetch', methods=['GET'])
def fetch():
    # URL 매개변수 가져오기
    target_url = request.args.get('url')
    if not target_url:
        return jsonify({"status": "error", "message": "No URL provided"}), 400

    try:
        # 서버 측에서 대상 URL로 요청 보내기
        response = requests.get(target_url, timeout=5)
        return jsonify({
            "status": "success",
            "data": response.text,  # 응답 내용
            "code": response.status_code
        })
    except requests.exceptions.RequestException as e:
        # 요청 실패 시 에러 메시지 반환
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

# Flask 애플리케이션 실행
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
