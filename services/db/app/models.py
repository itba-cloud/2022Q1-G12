from pydantic import BaseModel

class CreateUserReq(BaseModel):
    name: str
