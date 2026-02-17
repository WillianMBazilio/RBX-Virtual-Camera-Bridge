# 🎥 RBX Virtual Camera Bridge

Sistema experimental que conecta o Roblox a uma webcam virtual do sistema operacional, permitindo que avatares e ambientes do jogo sejam utilizados como fonte de câmera em aplicações como OBS, Discord e outras plataformas compatíveis.

---

## 🌎 Language

- 🇧🇷 Português (padrão)
- 🇺🇸 [English Version](#-english-version)

---

# 🇧🇷 Versão em Português

## 📖 Visão Geral

O **RBX Virtual Camera Bridge** é um sistema de renderização baseado em raycast dentro do Roblox (Lua) que transmite frames para um servidor local em Python. Esses frames passam por processamento de imagem com OpenCV e são enviados para uma webcam virtual usando `pyvirtualcam`.

O objetivo do projeto é permitir que personagens e ambientes de jogos/metaverso sejam utilizados como webcam para:

- Criação de conteúdo
- Apresentações virtuais
- Videochamadas
- Experimentos em streaming
- Integração entre jogos e aplicações externas

---

## 🧠 Arquitetura Técnica

### 1️⃣ Renderização via Raycast (Roblox - Lua)

- Simulação de câmera usando raycasting com FOV configurável.
- Cada pixel é gerado individualmente através de projeção angular.
- Captura de cores baseada em objetos atingidos pelo raycast.
- Serialização dos pixels em JSON.
- Envio dos dados via HTTP para servidor local.
- Taxa aproximada: ~20 FPS.
- Resolução base: **120x90**

---

### 2️⃣ Processamento de Frame (Python - Flask + OpenCV)

- Recebimento dos dados via endpoint local (`/vision`).
- Reconstrução da imagem a partir dos valores RGB.
- Conversão RGB → BGR para compatibilidade com OpenCV.
- Upscale para 1280x720 utilizando interpolação **LANCZOS4**.
- Aplicação de:
  - Filtro de nitidez (kernel customizado)
  - Ajuste automático de contraste e brilho
- Armazenamento seguro do frame com controle de concorrência (`threading.Lock`).

---

### 3️⃣ Saída como Webcam Virtual

- Envio contínuo dos frames processados usando `pyvirtualcam`.
- Saída em **1280x720 @ 30 FPS**.
- Compatível com OBS, Discord e outros softwares que aceitam webcam.

---

## ⚠️ Limitações Atuais

- Resolução base baixa (120x90).
- Transmissão via JSON gera overhead.
- Não otimizado para latência mínima.
- Sem camada de autenticação ou segurança.
- Projetado para uso local (127.0.0.1).

---

## 🚀 Melhorias Futuras Possíveis

- Transmissão binária em vez de JSON.
- Implementação com WebSocket.
- Resolução adaptativa.
- Compressão de frames.
- Processamento acelerado por GPU.
- Interface gráfica para configuração.
- Expansão para múltiplas engines/metaversos.

---

## 🛠️ Tecnologias Utilizadas

- **Lua (Roblox)**
- **Python 3**
- Flask
- OpenCV
- NumPy
- pyvirtualcam
- Threading

---

## 📌 Status do Projeto

Projeto experimental funcional, desenvolvido como estudo prático de:

- Computação gráfica simplificada
- Processamento de imagem
- Comunicação cliente-servidor
- Integração entre game engine e sistema operacional

---

# 🇺🇸 English Version

## 📖 Overview

**RBX Virtual Camera Bridge** is a raycast-based rendering system built in Roblox (Lua) that streams frames to a local Python server. The frames are processed using OpenCV and broadcast as a virtual webcam via `pyvirtualcam`.

The system enables game avatars and environments to be used as a webcam source for:

- Content creation
- Virtual presentations
- Video calls
- Streaming experiments
- Cross-platform metaverse integration

---

## 🧠 Technical Architecture

### 1️⃣ Raycast Rendering (Roblox - Lua)

- Custom camera simulation using raycasting.
- Each pixel is generated individually using angular projection.
- Color captured from raycast hit objects.
- Pixel data serialized into JSON.
- HTTP transmission to local server.
- Approximate rate: ~20 FPS.
- Base resolution: **120x90**

---

### 2️⃣ Frame Processing (Python - Flask + OpenCV)

- Receives frame data via local `/vision` endpoint.
- Reconstructs image from serialized RGB values.
- Converts RGB → BGR.
- Upscales to 1280x720 using **LANCZOS4** interpolation.
- Applies:
  - Sharpening filter
  - Contrast and brightness enhancement
- Thread-safe frame handling with locking.

---

### 3️⃣ Virtual Camera Output

- Streams processed frames using `pyvirtualcam`.
- Output resolution: **1280x720 @ 30 FPS**
- Recognized by OBS, Discord, and webcam-compatible applications.

---

## ⚠️ Current Limitations

- Low base resolution (120x90).
- JSON transmission overhead.
- Not latency-optimized.
- No authentication layer.
- Designed for local usage.

---

## 🚀 Future Improvements

- Binary frame transmission.
- WebSocket implementation.
- Adaptive resolution.
- Frame compression.
- GPU acceleration.
- GUI configuration panel.
- Multi-engine expansion.

---

## 📌 Project Status

Experimental functional project developed as a practical study in:

- Simplified computer graphics
- Image processing
- Client-server communication
- Game engine to OS-level integration
