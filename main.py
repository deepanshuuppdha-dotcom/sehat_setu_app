from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import patients, prescriptions, auth
from app.db.supabase import init_supabase

app = FastAPI(
    title="SehatSetu API",
    description="Offline-first AI triage platform for rural India",
    version="1.0.0"
)

# Allow Flutter app and React dashboard to call this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(patients.router,      prefix="/api", tags=["patients"])
app.include_router(prescriptions.router, prefix="/api", tags=["prescriptions"])
app.include_router(auth.router,          prefix="/api", tags=["auth"])

@app.get("/")
def health():
    return {"status": "ok", "service": "SehatSetu API"}