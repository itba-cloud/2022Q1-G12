import uvicorn
from sqlalchemy.orm import Session

from .database import get_db, Base, engine
from fastapi import Depends, FastAPI

from .models import CreateUserReq
from .schemas import User

# Creamos las tablas
Base.metadata.create_all(bind=engine)

app = FastAPI()

@app.get("/")
def healthcheck():
    return "Healthcheck"

@app.get("/api/db")
def home():
    return "DB says: Hello World!"

@app.get("/db")
def private_home():
    return "DB privately says: Hello World!"

@app.post("/api/db/user")
def create(create_user: CreateUserReq, db: Session = Depends(get_db)):
    user = User(
        name=create_user.name,
    )
    db.add(user)
    db.commit()
    return { 
        "success": True,
        "created_id": user.id
    }

@app.get("/api/db/users")
def get_by_id(db: Session = Depends(get_db)):
    return db.query(User).all()

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
