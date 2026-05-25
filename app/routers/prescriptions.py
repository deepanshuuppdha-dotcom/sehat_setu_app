from fastapi import APIRouter, HTTPException
from app.models.schemas import PrescriptionCreate, PrescriptionResponse
from app.db.supabase import get_supabase
import uuid
from datetime import datetime, timezone

router = APIRouter()

@router.post("/prescriptions", response_model=PrescriptionResponse)
async def create_prescription(rx: PrescriptionCreate):
    """
    Doctor issues a prescription from the dashboard.
    Deepanshu's POST call from the 'Issue Rx' button.
    """
    record = {
        "id":             str(uuid.uuid4()),
        "patient_id":     rx.patient_id,
        "doctor_id":      rx.doctor_id,
        "diagnosis":      rx.diagnosis,
        "medications":    rx.medications,
        "notes":          rx.notes,
        "follow_up_days": rx.follow_up_days,
        "created_at":     datetime.now(timezone.utc).isoformat(),
    }

    sb = get_supabase()

    rx_result = sb.table("prescriptions").insert(record).execute()
    if not rx_result.data:
        raise HTTPException(status_code=500, detail="Failed to save prescription")

    sb.table("health_timeline").insert({
        "id":              str(uuid.uuid4()),
        "patient_id":      rx.patient_id,
        "visit_date":      datetime.now(timezone.utc).isoformat(),
        "diagnosis":       rx.diagnosis,
        "prescription_id": record["id"],
    }).execute()

    return PrescriptionResponse(**rx_result.data[0])


@router.get("/prescriptions/{patient_id}")
async def get_patient_prescriptions(patient_id: str):
    """Returns all past prescriptions for a patient — for health timeline."""
    sb = get_supabase()
    result = (
        sb.table("prescriptions")
        .select("*")
        .eq("patient_id", patient_id)
        .order("created_at", desc=True)
        .execute()
    )
    return result.data