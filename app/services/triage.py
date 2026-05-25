from openai import AsyncOpenAI
from app.config import settings
from app.models.schemas import TriagePriority
import json

client = AsyncOpenAI(
    api_key=settings.OPENAI_API_KEY,
    base_url="https://openrouter.ai/api/v1"
)

TRIAGE_SYSTEM_PROMPT = """You are a medical triage AI assistant for rural India.
Given patient symptoms, assign a triage priority and return ONLY valid JSON.

Priority levels:
- P1 (Critical): Life-threatening — chest pain, severe breathing difficulty, unconscious, seizure, heavy bleeding
- P2 (Urgent): Needs attention within 1 hour — high fever in infant, moderate injury, severe pain
- P3 (Semi-urgent): Needs attention within 4 hours — moderate fever, persistent vomiting, minor injury
- P4 (Non-urgent): Routine — mild cold, minor skin rash, general checkup

Return ONLY this JSON, no other text:
{
  "priority": "P1"|"P2"|"P3"|"P4",
  "reasoning": "one sentence clinical reason"
}"""

async def get_triage_score(
    symptoms: str,
    age: int,
    gender: str,
    language: str
) -> tuple[TriagePriority, str]:
    user_message = f"""
Patient: {age}-year-old {gender}
Language of input: {language}
Symptoms reported: {symptoms}
"""

    response = await client.chat.completions.create(
        model="gpt-4o-mini",
        max_tokens=150,
        temperature=0,
        messages=[
            {"role": "system", "content": TRIAGE_SYSTEM_PROMPT},
            {"role": "user",   "content": user_message},
        ]
    )

    raw = response.choices[0].message.content.strip()

    try:
        data = json.loads(raw)
        priority  = TriagePriority(data["priority"])
        reasoning = data.get("reasoning", "")
    except (json.JSONDecodeError, KeyError, ValueError):
        priority  = TriagePriority.P3
        reasoning = "Could not parse AI response — defaulting to semi-urgent."

    return priority, reasoning