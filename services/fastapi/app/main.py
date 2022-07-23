import requests
from fastapi import FastAPI


app = FastAPI()

@app.get("/")
def healthcheck():
    return "Healthcheck"

@app.get("/api/fastapi")
def home():
    return "FastApi says: Hello World!"

@app.get("/api/fastapi/apicall")
def api_call():
    return requests.get("http://services.private.cloud.com/fastapi2").text

@app.get("/fastapi")
def private_home():
    return "FastApi privately says: Hello World!"

@app.get("/api/fastapi/external/ip")
def private_home():
    return "Current ip is: " + requests.get("https://ipinfo.io/ip").text
