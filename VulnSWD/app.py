from flask import Flask, request, send_file
import os

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the Financial AI SaaS System"

# File download endpoint with directory traversal vulnerability
@app.route('/download', methods=['GET'])
def download_file():
    file_path = request.args.get('file')  # 취약한 파일 경로 입력 처리
    if file_path:
        full_path = os.path.join(os.getcwd(), file_path)
        if os.path.exists(full_path):
            return send_file(full_path, as_attachment=True)
    return "Invalid file request", 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
