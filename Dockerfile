FROM python:3.8.10-buster
USER root

# COPY ./sources.list /etc/apt/sources.list
RUN apt update && \
    apt install -y libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libfontconfig1 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/log/*

WORKDIR /app
COPY requirements.txt .

# 安装依赖包
RUN pip3 install --no-cache-dir -r requirements.txt

RUN mkdir -p /models/.deepface/weights && \
    wget -nv -O /models/.deepface/weights/retinaface.h5 https://github.com/serengil/deepface_models/releases/download/v1.0/retinaface.h5 && \
    wget -nv -O /models/.deepface/weights/facenet512_weights.h5 https://github.com/serengil/deepface_models/releases/download/v1.0/facenet512_weights.h5


COPY server.py .
ENV DEEPFACE_HOME=/models
ENV API_AUTH_KEY=mt_photos_ai_extra
EXPOSE 8066

CMD [ "python3", "server.py" ]
