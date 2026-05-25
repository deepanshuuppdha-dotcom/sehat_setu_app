from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum

# ─── Shared enums ────────────────────────────────────────────────────────────

class TriagePriority(str, Enum):
    P1 = "P1"   # Critical — immediate attention
    P2 = "P2"   # Urgent — within 1 hour
    P3 = "P3"   # Semi-urgent — within 4 hours
    P4 = "P4"   # Non-urgent — routine

class Language(str, Enum):
    HINDI   = "hi"
    TAMIL   = "ta"
    MARATHI = "mr"
    ENGLISH = "en"
    BENGALI = "bn"
    TELUGU  = "te"
    KANNADA = "kn"

# ─── Patient submission (Flutter → API) ──────────────────────────────────────

class PatientSubmit(BaseModel):
    name: str
    age: int
    gender: str
    phone: Optional[str] = None
    language: Language = Language.HINDI
    symptoms_text: str
    symptoms_english: Optional[str] = None
    asha_worker_id: Optional[str] = None
    local_id: Optional[str] = None

class PatientResponse(BaseModel):
    id: str
    name: str
    age: int
    gender: str
    language: str
    symptoms_text: str
    urgency_score: TriagePriority
    ai_summary: str
    created_at: datetime
    synced: bool = True
    phone: Optional[str] = None

# ─── Prescription (Doctor Dashboard → API) ───────────────────────────────────

class PrescriptionCreate(BaseModel):
    patient_id: str
    doctor_id: str
    diagnosis: str
    medications: list[str]
    notes: Optional[str] = None
    follow_up_days: Optional[int] = None

class PrescriptionResponse(BaseModel):
    id: str
    patient_id: str
    doctor_id: str
    diagnosis: str
    medications: list[str]
    notes: Optional[str]
    follow_up_days: Optional[int]
    created_at: datetime

# ─── Health timeline entry ────────────────────────────────────────────────────

class TimelineEntry(BaseModel):
    patient_id: str
    visit_date: datetime
    symptoms: str
    urgency_score: TriagePriority
    diagnosis: Optional[str] = None
    prescription_id: Optional[str] = None