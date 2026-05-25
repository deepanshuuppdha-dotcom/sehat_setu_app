from openai import AsyncOpenAI
from app.config import settings
from app.models.schemas import TriagePriority

# Using OpenRouter instead of Gemini directly
client = AsyncOpenAI(
    api_key=settings.OPENAI_API_KEY,
    base_url="https://openrouter.ai/api/v1"
)

SUMMARY_PROMPT = """You are a clinical assistant helping a rural doctor in India.
Write a concise, professional 2-3 sentence clinical summary in English from the
patient information below. Focus on: key presenting symptoms, age/gender context,
and what the doctor should check first. Do NOT diagnose — only summarise.

Patient info:
Name: {name}
Age: {age}, Gender: {gender}
Triage priority: {priority}
Reported symptoms ({language}): {symptoms}
"""

async def get_clinical_summary(
    name: str,
    age: int,
    gender: str,
    symptoms: str,
    language: str,
    priority: TriagePriority,
) -> str:
    prompt = SUMMARY_PROMPT.format(
        name=name,
        age=age,
        gender=gender,
        priority=priority.value,
        language=language,
        symptoms=symptoms,
    )

    response = await client.chat.completions.create(
        model="google/gemini-2.0-flash-001",
        max_tokens=300,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )

    try:
        return response.choices[0].message.content.strip()
    except Exception:
        return f"Patient {name}, {age}y {gender}. Reported: {symptoms[:200]}. Please review urgently (priority {priority.value})."