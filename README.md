# MT Photos人脸识别API

- 基于[serengil/deepface](https://github.com/serengil/deepface)实现的人脸识别API

## 模型选择

### 人脸检测模型

默认的人脸检测模型为retinaface，虽然计算耗时较长，但是最准确；

可通过环境变量 `DETECTOR_BACKEND`来自定义检测模型；

```python
backends = [
    'opencv',
    'ssd',
    'dlib',
    'mtcnn',
    'retinaface',
    'mediapipe',
    'yolov8',
    'yunet',
    'fastmtcnn',
]
detector_backend = os.getenv("DETECTOR_BACKEND", "retinaface")
```

### 人脸特征提取模型

默认的人脸检测模型为Facenet512

可通过环境变量 `RECOGNITION_MODEL`来自定义特征提取模型；

```python
models = [
    "VGG-Face",
    "Facenet",
    "Facenet512",
    "OpenFace",
    "DeepFace",
    "DeepID",
    "ArcFace",
    "Dlib",
    "SFace",
    "GhostFaceNet",
]
recognition_model = os.getenv("RECOGNITION_MODEL", "Facenet512")
```

## 预训练模型

如果容器内下载模型很慢，可以增加 /models 目录映射
```
-v /host_path:/models
```

然后将对应的预训练模型放到容器内的`/models/.deepface/weights/`下；比如`/models/.deepface/weights/retinaface.h5`

### 预训练模型下载地址

https://github.com/serengil/deepface_models/releases/tag/v1.0


## 安装方法

- 下载镜像

```
docker pull mtphotos/mt-photos-deepface:latest
```

- 创建容器

```
docker run -i -p 8066:8066 -e API_AUTH_KEY=mt_photos_ai_extra --name mt-photos-deepface mt-photos-deepface:latest
```



## 打包docker镜像

```bash
docker build  . -t mt-photos-deepface:latest
```

### 运行docker容器

```bash
docker run -i -p 8066:8066 -e API_AUTH_KEY=mt_photos_ai_extra --name mt-photos-deepface --restart="unless-stopped" mt-photos-deepface:latest
```

### 下载源码本地运行

- 安装python **3.8版本**
- 在文件夹下执行`pip install -r requirements.txt`
- 复制`.env.example`生成`.env`文件，然后修改`.env`文件内的API_AUTH_KEY
- 执行 `python server.py` ，启动服务

看到以下日志，则说明服务已经启动成功
```bash
INFO:     Started server process [27336]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8066 (Press CTRL+C to quit)
```


## API

### /check

检测服务是否可用，及api-key是否正确

```bash
curl --location --request POST 'http://127.0.0.1:8000/check' \
--header 'api-key: api_key'
```

**response:**

```json
{
  "result": "pass"
}
```

### /represent

```bash
curl --location --request POST 'http://127.0.0.1:8000/represent' \
--header 'api-key: api_key' \
--form 'file=@"/path_to_file/test.jpg"'
```

**response:**

- detector_backend : 人脸检测模型
- recognition_model : 人脸特征提取模型
- result : 识别到的结果

### 返回数据示例
```json
{
  "detector_backend": "retinaface",
  "recognition_model": "Facenet512",
  "result": [
    {
      "embedding": [ 0.5760641694068909,... 512位向量 ],
      "facial_area": {
        "x": 212,
        "y": 112,
        "w": 179,
        "h": 250,
        "left_eye": [ 271, 201 ],
        "right_eye": [ 354, 205 ]
      },
      "face_confidence": 1.0
    }
  ]
}
```
