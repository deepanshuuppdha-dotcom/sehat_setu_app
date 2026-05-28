# 🏥 SehatSetu — सेहत सेतु

> **AI-powered offline-first healthcare triage platform for rural India**

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.111-009688.svg)](https://fastapi.tiangolo.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-18-61DAFB.svg)](https://reactjs.org)

---

## 🌍 The Problem

India has **1 doctor per 11,000 rural patients**. 10.4 lakh ASHA workers serve 600 million Indians with zero digital tools — just pen and paper. SehatSetu bridges this gap.

---

## ✨ What We Built

SehatSetu is a 3-part system that connects ASHA workers to doctors using AI:
ASHA Worker (Flutter App)
↓ Voice / Text in Hindi/Tamil/Marathi
↓ Works OFFLINE — syncs when internet returns
FastAPI Backend (Python)
↓ GPT-4o-mini → P1/P2/P3/P4 Triage Score
↓ Gemini Flash → English Clinical Summary
↓ Whisper → Voice Transcription
Supabase Database
↑ Real-time sync
Doctor Dashboard (React)
→ Live triaged queue → AI summaries → Digital prescriptions
---

## 🚀 Key Features

### 📱 Flutter Mobile App (ASHA Worker)
- 🔐 Phone + PIN login for ASHA workers
- 🎤 Voice recording → Whisper transcription in 7 languages
- 📵 **Offline-first** — works with zero internet
- 🔄 Auto-sync when connectivity returns
- 🌐 Hindi, Tamil, Marathi, Bengali, Telugu, Kannada, English
- 📋 Patient history and health timeline
- 📞 Patient mobile number capture

### ⚡ FastAPI Backend (AI Engine)
- 🤖 GPT-4o-mini triage → P1/P2/P3/P4 urgency scoring
- 🧠 Gemini Flash → 2-3 sentence clinical summary in English
- 🎙️ Whisper STT → multilingual voice transcription
- 📦 Offline queue sync endpoint
- 🗄️ Supabase PostgreSQL database
- 🔒 ASHA worker authentication

### 💻 React Doctor Dashboard
- 📊 Live patient queue — auto-refreshes every 8 seconds
- 🔴 P1 Critical / 🟠 P2 Urgent / 🟡 P3 Semi-urgent / 🟢 P4 Routine
- 🤖 AI Clinical Summary per patient
- 📝 Digital prescription issuance
- 📅 Patient health timeline
- 📞 Call / Text / Video Call buttons
- 🔔 Audio alert for P1 critical patients
- 📈 Stats bar — total patients, critical count, avg wait time

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter + Dart |
| Offline Storage | Drift (SQLite) |
| Backend | FastAPI (Python) |
| AI Triage | GPT-4o-mini via OpenRouter |
| Clinical Summary | Google Gemini Flash |
| Voice Input | OpenAI Whisper |
| Database | Supabase (PostgreSQL) |
| Doctor Dashboard | React + Vite + Tailwind |

---

## 📁 Repository Structure
sehat_setu_app/
├── main (branch)          → FastAPI Backend
├── flutter-app (branch)   → Flutter Mobile App
└── dashboard (branch)     → React Doctor Dashboard
---

## 🔧 Setup & Running

### Backend (main branch)
```bash
pip install -r requirements.txt
# Create .env file with your API keys
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Flutter App (flutter-app branch)
```bash
flutter pub get
flutter run
```

### Dashboard (dashboard branch)
```bash
npm install
npm run dev
```

---

## 🔑 Environment Variables

Create a `.env` file in the backend folder:
OPENAI_API_KEY=your_openrouter_key
GOOGLE_API_KEY=your_gemini_key
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_anon_key
---

## 📱 Demo Credentials

| Field | Value |
|---|---|
| Phone | `9999999999` |
| PIN | `1234` |
| Role | Demo ASHA Worker — Priya Sharma, Bareilly UP |

---

## 👥 Team NEXA BRIGADE

| Name | Role | Responsibility |
|---|---|---|
| **Saksham** | Backend Lead | FastAPI, AI Services, Supabase, GPT triage, Gemini summaries |
| **Arjun** | Flutter Lead | Mobile app, Offline sync, Voice recording, UI |
| **Deepanshu** | Dashboard Lead | React dashboard, Real-time queue, Prescriptions, UI/UX |

---

## 🌍 Impact Numbers

- 🇮🇳 600 million rural Indians with zero digital health access
- 👩‍⚕️ 10.4 lakh ASHA workers with no digital tools
- 🏥 1:11,000 doctor-patient ratio in rural India
- 💰 $14.5 billion digital health market growing at 25% CAGR
- 🎯 Target: 100K MAU by Year 1

---

## 🗺️ Roadmap

- [ ] AI chatbot for common disease self-assessment
- [ ] SMS prescription delivery via Fast2SMS
- [ ] ONNX on-device NLP (fully offline AI)
- [ ] Ayushman Bharat API integration
- [ ] District health officer analytics dashboard
- [ ] iOS app

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

<div align="center">
Built with ❤️ for rural India by <strong>NEXA BRIGADE</strong>
<br>
SehatSetu — सेहत सेतु — Health Bridge
</div>
