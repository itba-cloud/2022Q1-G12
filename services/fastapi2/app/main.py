from fastapi import FastAPI

app     = FastAPI()

@app.get("/")
def healthcheck():
    return "Healthcheck"

@app.get("/api/fastapi2")
def home():
    return "FastApi2 says: Hello World!"

@app.get("/fastapi2")
def private_home():
    return "FastApi2 privately says: Hello World!"

