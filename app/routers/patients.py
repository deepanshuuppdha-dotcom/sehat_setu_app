from fastapi import APIRouter, HTTPException, UploadFile, File, Form
from app.models.schemas import PatientSubmit, PatientResponse, Language
from app.services.triage import get_triage_score
from app.services.summariser import get_clinical_summary
from app.services.stt import transcribe_audio
from app.db.supabase import get_supabase
import uuid
from datetime import datetime, timezone

router = APIRouter()

@router.post("/submit-patient", response_model=PatientResponse)
async def submit_patient(patient: PatientSubmit):
    # Step 1 — AI triage
    priority, reasoning = await get_triage_score(
        symptoms=patient.symptoms_text,
        age=patient.age,
        gender=patient.gender,
        language=patient.language.value,
    )

    # Step 2 — AI clinical summary
    summary = await get_clinical_summary(
        name=patient.name,
        age=patient.age,
        gender=patient.gender,
        symptoms=patient.symptoms_text,
        language=patient.language.value,
        priority=priority,
    )

    # Step 3 — Store in Supabase
    record = {
        "id":               str(uuid.uuid4()),
        "name":             patient.name,
        "age":              patient.age,
        "gender":           patient.gender,
        "language":         patient.language.value,
        "symptoms_text":    patient.symptoms_text,
        "urgency_score":    priority.value,
        "ai_summary":       summary,
        "triage_reasoning": reasoning,
        "asha_worker_id":   patient.asha_worker_id,
        "local_id":         patient.local_id,
        "phone":            patient.phone,
        "created_at":       datetime.now(timezone.utc).isoformat(),
        "synced":           True,
    }

    sb = get_supabase()
    result = sb.table("patients").insert(record).execute()

    if not result.data:
        raise HTTPException(status_code=500, detail="Failed to save patient to database")

    row = result.data[0]
    row.setdefault('phone', None)
    return PatientResponse(**row)


@router.get("/patients")
async def get_patients(limit: int = 50):
    sb = get_supabase()
    result = (
        sb.table("patients")
        .select("*")
        .order("urgency_score", desc=False)
        .order("created_at", desc=True)
        .limit(limit)
        .execute()
    )
    return result.data


@router.get("/patients/{patient_id}")
async def get_patient(patient_id: str):
    sb = get_supabase()
    result = sb.table("patients").select("*").eq("id", patient_id).single().execute()
    if not result.data:
        raise HTTPException(status_code=404, detail="Patient not found")
    return result.data


@router.post("/transcribe")
async def transcribe(
    audio: UploadFile = File(...),
    language: str = Form(default="hi"),
):
    audio_bytes = await audio.read()
    text = await transcribe_audio(audio_bytes, language_code=language)
    return {"transcribed_text": text, "language": language}


@router.post("/sync-patients")
async def sync_patients(patients: list[PatientSubmit]):
    results = []
    for patient in patients:
        try:
            result = await submit_patient(patient)
            results.append({"local_id": patient.local_id, "status": "synced", "id": result.id})
        except Exception as e:
            results.append({"local_id": patient.local_id, "status": "error", "error": str(e)})
    return {"synced": len([r for r in results if r["status"] == "synced"]), "results": results}