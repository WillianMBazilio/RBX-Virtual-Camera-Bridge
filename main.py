import numpy as np
import cv2
import pyvirtualcam
from flask import Flask, request
import threading

app = Flask(__name__)

# Saída HD para o OBS reconhecer como câmera de alta qualidade
WIDTH, HEIGHT = 1280, 720
latest_frame = np.zeros((HEIGHT, WIDTH, 3), np.uint8)
lock = threading.Lock()

@app.route('/vision', methods=['POST'])
def vision():
    global latest_frame
    data = request.get_json()
    if not data: return "Err", 400

    res_x, res_y = data['resX'], data['resY']
    pixels = np.array(data['pixels'], dtype=np.uint8)
    
    # 1. Monta a imagem bruta
    img = pixels.reshape((res_y, res_x, 3))
    img_bgr = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
    
    # 2. Upscale Inteligente (LANCZOS4 é o melhor para preservar detalhes)
    img_big = cv2.resize(img_bgr, (WIDTH, HEIGHT), interpolation=cv2.INTER_LANCZOS4)

    # 3. FILTRO DE NITIDEZ (O segredo para parar de ser um quadrado borrado)
    kernel = np.array([[-1,-1,-1], 
                       [-1, 9,-1],
                       [-1,-1,-1]])
    img_sharp = cv2.filter2D(img_big, -1, kernel)

    # 4. Ajuste de Contraste e Brilho Automático (Faz as cores "saltarem")
    img_final = cv2.convertScaleAbs(img_sharp, alpha=1.2, beta=10)

    with lock:
        latest_frame = img_final
        
    return "OK", 200

def main():
    threading.Thread(target=lambda: app.run(host='127.0.0.1', port=5000, threaded=True), daemon=True).start()
    
    print("🚀 RBX-Webcam PRO iniciada!")
    with pyvirtualcam.Camera(width=WIDTH, height=HEIGHT, fps=30, fmt=pyvirtualcam.PixelFormat.BGR) as cam:
        while True:
            with lock:
                cam.send(latest_frame)
            cam.sleep_until_next_frame()

if __name__ == "__main__":
    main()
