import os
from typing import Any, Dict

import boto3
import uvicorn
from fastapi import FastAPI, UploadFile
from fastapi.responses import Response

AWS_BINARIES_BUCKET = os.getenv('AWS_BINARIES_BUCKET')

app = FastAPI()

@app.get("/")
def healthcheck():
    return "Healthcheck"

@app.get("/api/balde")
def home():
    return "Balde says: Hello World!"

@app.get("/balde")
def private_home():
    return "Balde privately says: Hello World!"

@app.get("/api/balde/games/{file}")
def download_file(file):
    try:
        obj: Dict[str, Any] = boto3.resource('s3').Object(AWS_BINARIES_BUCKET, file).get()
        return Response(obj['Body'].read(), media_type=obj['ContentType'])
    except Exception as e:
        return Response(e, status_code=400)

@app.get("/api/balde/games")
def get_files():
    try:
        file_names = []
        result = boto3.client('s3').list_objects_v2(Bucket=AWS_BINARIES_BUCKET)
        for item in result['Contents']:
           file_names.append(item['Key'])

        return file_names
        
    except Exception as e:
        return Response(e, status_code=400)

@app.post("/api/balde/games")
def upload_file(file: UploadFile):
    try:
        boto3.client('s3').upload_fileobj(
            file.file,
            AWS_BINARIES_BUCKET,
            file.filename,
            ExtraArgs={"ContentType": file.content_type}
        )
    except Exception as e:
        return Response(e, status_code=400)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
