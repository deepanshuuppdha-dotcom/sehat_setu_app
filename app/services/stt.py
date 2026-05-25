from groq import AsyncGroq
from app.config import settings
import tempfile, os

client = AsyncGroq(api_key=settings.GROQ_API_KEY)

SUPPORTED_LANGUAGES = {
    "hi": "hi",
    "ta": "ta",
    "mr": "mr",
    "en": "en",
    "bn": "bn",
    "te": "te",
    "kn": "kn",
}

async def transcribe_audio(audio_bytes: bytes, language_code: str = "hi") -> str:
    """
    Transcribe voice recording using Groq Whisper Large V3.
    audio_bytes: raw audio file bytes (m4a, mp3, wav, webm all work)
    language_code: ISO 639-1 code e.g. "hi", "ta", "mr"
    Returns transcribed text string.
    """
    suffix = ".m4a"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
        tmp.write(audio_bytes)
        tmp_path = tmp.name

    try:
        with open(tmp_path, "rb") as audio_file:
            transcript = await client.audio.transcriptions.create(
                model="whisper-large-v3",
                file=audio_file,
                language=language_code,
            )
        return transcript.text.strip()
    finally:
        os.unlink(tmp_path)