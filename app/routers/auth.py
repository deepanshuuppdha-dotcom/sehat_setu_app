from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.db.supabase import get_supabase

router = APIRouter()

class LoginRequest(BaseModel):
    phone: str
    pin: str

class LoginResponse(BaseModel):
    worker_id: str
    name: str
    district: str
    token: str

@router.post("/login")
async def login(req: LoginRequest):
    # HACKATHON SHORTCUT: test user works immediately
    if req.phone == "9999999999" and req.pin == "1234":
        return LoginResponse(
            worker_id="demo-worker-001",
            name="Priya Sharma (Demo ASHA)",
            district="Bareilly, UP",
            token="demo-token-hackathon"
        )

    # Real lookup from Supabase
    sb = get_supabase()
    result = sb.table("asha_workers").select("*").eq("phone", req.phone).eq("pin", req.pin).execute()
    if not result.data:
        raise HTTPException(status_code=401, detail="Invalid phone or PIN")

    worker = result.data[0]
    return LoginResponse(
        worker_id=worker["id"],
        name=worker["name"],
        district=worker["district"],
        token=f"token-{worker['id']}"
    )