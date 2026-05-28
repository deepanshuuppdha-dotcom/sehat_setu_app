import { useState, useEffect } from 'react'
import { getPrescriptions, createPrescription } from '../api'
import { getPriorityColor, getPriorityLabel, getLanguageEmoji, getLanguageLabel, getTimeAgo } from '../utils/triage'
import { format } from 'date-fns'

export default function PatientDetail({ patient }) {
  const [prescriptions, setPrescriptions] = useState([])
  const [loadingRx, setLoadingRx] = useState(true)
  const [rxError, setRxError] = useState(null)

  // Prescription form state
  const [diagnosis, setDiagnosis] = useState('')
  const [medications, setMedications] = useState([''])
  const [notes, setNotes] = useState('')
  const [followUpDays, setFollowUpDays] = useState(3)
  const [submitting, setSubmitting] = useState(false)
  const [success, setSuccess] = useState(false)
  const [submitError, setSubmitError] = useState(null)

  // Contact state
  const [phone, setPhone] = useState(patient.phone || '')
  const [isEditingPhone, setIsEditingPhone] = useState(false)
  const [copied, setCopied] = useState(false)

  const colors = getPriorityColor(patient.urgency_score)

  const sanitizePhone = (num) => {
    if (!num) return ''
    return num.replace(/[^\d+]/g, '')
  }

  const handleCopy = () => {
    if (!phone) return
    navigator.clipboard.writeText(phone)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  const handleCall = (type) => {
    if (!phone) {
      alert('Please enter a valid phone number first.')
      return
    }
    const sanitized = sanitizePhone(phone)
    const url = type === 'tel' ? `tel:${sanitized}` : `sms:${sanitized}`
    window.location.assign(url)
  }

  useEffect(() => {
    setPrescriptions([])
    setLoadingRx(true)
    setRxError(null)
    setSuccess(false)
    setDiagnosis('')
    setMedications([''])
    setNotes('')
    setFollowUpDays(3)
    setSubmitError(null)
    setPhone(patient.phone || '')
    setIsEditingPhone(false)

    getPrescriptions(patient.id)
      .then((data) => {
        setPrescriptions(Array.isArray(data) ? data : [])
        setLoadingRx(false)
      })
      .catch((err) => {
        setRxError('Could not load prescription history.')
        setLoadingRx(false)
      })
  }, [patient.id])

  const addMedication = () => setMedications([...medications, ''])
  const removeMedication = (idx) => setMedications(medications.filter((_, i) => i !== idx))
  const updateMedication = (idx, val) => setMedications(medications.map((m, i) => i === idx ? val : m))

  const handleSubmit = async () => {
    if (!diagnosis.trim()) {
      setSubmitError('Please enter a diagnosis.')
      return
    }
    const meds = medications.filter(m => m.trim())
    if (meds.length === 0) {
      setSubmitError('Please add at least one medication.')
      return
    }

    setSubmitting(true)
    setSubmitError(null)
    try {
      await createPrescription({
        patient_id: patient.id,
        doctor_id: 'doctor-001',
        diagnosis: diagnosis.trim(),
        medications: meds,
        notes: notes.trim() || undefined,
        follow_up_days: Number(followUpDays)
      })
      setSuccess(true)
      setDiagnosis('')
      setMedications([''])
      setNotes('')
      setFollowUpDays(3)
      const data = await getPrescriptions(patient.id)
      setPrescriptions(Array.isArray(data) ? data : [])
    } catch (err) {
      setSubmitError('Failed to issue prescription. Please try again.')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div style={{
      flex: 1,
      overflowY: 'auto',
      padding: '24px 32px',
      background: '#F3F6F9',
    }}>
      {/* ── Patient Header ── */}
      <div style={{
        background: '#FFFFFF',
        borderRadius: 14,
        padding: '24px 28px',
        marginBottom: 18,
        border: '1px solid #E8EEF3',
        boxShadow: '0 2px 10px rgba(0,0,0,0.03)',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
      }}>
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 8 }}>
            <h1 style={{ margin: 0, fontSize: 26, fontWeight: 800, color: '#1A2332', letterSpacing: '-0.02em' }}>
              {patient.name}
            </h1>
            <span style={{
              background: colors.badgeBg,
              color: colors.badgeText,
              borderRadius: 8,
              fontSize: 11,
              fontWeight: 800,
              padding: '4px 12px',
              textTransform: 'uppercase',
              letterSpacing: '0.04em',
            }}>
              {getPriorityLabel(patient.urgency_score)}
            </span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, fontSize: 13.5, color: '#64748B', fontWeight: 500 }}>
            <span>{patient.age} Years</span>
            <span style={{ color: '#CBD5E1' }}>•</span>
            <span>{patient.gender}</span>
            <span style={{ color: '#CBD5E1' }}>•</span>
            <span>{getLanguageEmoji(patient.language)} {getLanguageLabel(patient.language)}</span>
            <span style={{ color: '#CBD5E1' }}>•</span>
            <span>Arrived {getTimeAgo(patient.created_at)}</span>
          </div>
        </div>
      </div>

      {/* ── Communication & Telehealth ── */}
      <div style={{
        background: '#FFFFFF',
        borderRadius: 14,
        padding: '18px 24px',
        marginBottom: 18,
        border: '1px solid #E8EEF3',
        boxShadow: '0 1px 3px rgba(0,0,0,0.04)',
        display: 'flex',
        flexDirection: 'column',
        gap: 16,
      }}>
        <div style={{ 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'space-between',
          flexWrap: 'wrap',
          gap: 12
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{
              width: 40, height: 40, borderRadius: 10,
              background: '#F1F5F9',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: '#64748B',
            }}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect width="14" height="20" x="5" y="2" rx="2" ry="2"/><path d="M12 18h.01"/></svg>
            </div>
            <div>
              <div style={{ fontSize: 11, fontWeight: 700, color: '#64748B', textTransform: 'uppercase', letterSpacing: '0.04em' }}>
                Patient Contact
              </div>
              {isEditingPhone ? (
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 2 }}>
                  <input
                    type="text"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    style={{
                      fontSize: 14,
                      fontWeight: 600,
                      color: '#1A2332',
                      border: '1px solid #E2E8F0',
                      borderRadius: 4,
                      padding: '2px 6px',
                      width: 140,
                    }}
                    autoFocus
                  />
                  <button
                    onClick={() => setIsEditingPhone(false)}
                    style={{ background: '#1D9E75', color: '#FFF', border: 'none', borderRadius: 4, padding: '2px 8px', fontSize: 12, fontWeight: 600, cursor: 'pointer' }}
                  >
                    Save
                  </button>
                </div>
              ) : (
                <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 2 }}>
                  <span style={{ fontSize: 15, fontWeight: 600, color: '#1A2332' }}>
                    {phone || 'No number entered'}
                  </span>
                  <div style={{ display: 'flex', gap: 8 }}>
                    <button
                      onClick={() => setIsEditingPhone(true)}
                      style={{ background: 'none', border: 'none', color: '#94A3B8', fontSize: 12, cursor: 'pointer', padding: 0 }}
                    >
                      Edit
                    </button>
                    {phone && (
                      <button
                        onClick={handleCopy}
                        style={{
                          background: copied ? '#E8F7F2' : 'none',
                          border: 'none',
                          color: copied ? '#156E52' : '#94A3B8',
                          fontSize: 12,
                          cursor: 'pointer',
                          padding: '2px 6px',
                          borderRadius: 4,
                          display: 'flex',
                          alignItems: 'center',
                          gap: 4,
                          transition: 'all 0.2s',
                        }}
                      >
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                          {copied ? (
                            <polyline points="20 6 9 17 4 12" />
                          ) : (
                            <>
                              <rect width="14" height="14" x="8" y="8" rx="2" ry="2" />
                              <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" />
                            </>
                          )}
                        </svg>
                        {copied ? 'Copied!' : 'Copy'}
                      </button>
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        <div style={{ 
          display: 'flex', 
          gap: 10,
          flexWrap: 'wrap'
        }}>
          <button
            onClick={() => handleCall('tel')}
            style={{
              flex: '1 1 100px',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
              padding: '10px 16px',
              background: '#E8F7F2',
              color: '#156E52',
              borderRadius: 10,
              fontSize: 14,
              fontWeight: 600,
              border: '1px solid #A7DFD0',
              cursor: phone ? 'pointer' : 'not-allowed',
              transition: 'all 0.15s',
              opacity: phone ? 1 : 0.6,
            }}
            onMouseOver={(e) => phone && (e.currentTarget.style.background = '#D1F0E6')}
            onMouseOut={(e) => phone && (e.currentTarget.style.background = '#E8F7F2')}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l2.27-2.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
            Call
          </button>
          <button
            onClick={() => handleCall('sms')}
            style={{
              flex: '1 1 100px',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
              padding: '10px 16px',
              background: '#EFF6FF',
              color: '#1E40AF',
              borderRadius: 10,
              fontSize: 14,
              fontWeight: 600,
              border: '1px solid #BFDBFE',
              cursor: phone ? 'pointer' : 'not-allowed',
              transition: 'all 0.15s',
              opacity: phone ? 1 : 0.6,
            }}
            onMouseOver={(e) => phone && (e.currentTarget.style.background = '#DBEAFE')}
            onMouseOut={(e) => phone && (e.currentTarget.style.background = '#EFF6FF')}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
            Text
          </button>
          <button
            onClick={() => alert(`Initiating video call with ${patient.name}...`)}
            style={{
              flex: '1 1 140px',
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
              padding: '10px 16px',
              background: '#F5F3FF',
              color: '#5B21B6',
              borderRadius: 10,
              fontSize: 14,
              fontWeight: 600,
              border: '1px solid #DDD6FE',
              cursor: 'pointer',
              transition: 'all 0.15s',
            }}
            onMouseOver={(e) => (e.currentTarget.style.background = '#EDE9FE')}
            onMouseOut={(e) => (e.currentTarget.style.background = '#F5F3FF')}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="m22 8-6 4 6 4V8Z"/><rect width="14" height="12" x="2" y="6" rx="2" ry="2"/></svg>
            Video Call
          </button>
        </div>

        {!phone && (
          <div style={{ width: '100%', marginTop: 8, fontSize: 11, color: '#EF4444', fontStyle: 'italic' }}>
            * Please enter a phone number to enable communication options.
          </div>
        )}
        
        {phone && (
          <div style={{ width: '100%', marginTop: 8, fontSize: 11, color: '#94A3B8', fontStyle: 'italic' }}>
            Note: "Call" requires a linked dialer app. Use "Copy" for desktop.
          </div>
        )}
      </div>

      {/* ── AI Summary ── */}
      <div style={{
        background: '#E8F7F2',
        borderRadius: 14,
        padding: '20px 24px',
        marginBottom: 18,
        border: '1.5px solid #A7DFD0',
        boxShadow: '0 1px 3px rgba(29,158,117,0.06)',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
          <div style={{
            width: 28, height: 28, borderRadius: 7,
            background: '#E8F7F2',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: '#15803D',
          }}>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/><path d="M19 3v4"/><path d="M21 5h-4"/></svg>
          </div>
          <span style={{ fontWeight: 700, fontSize: 13, color: '#156E52', textTransform: 'uppercase', letterSpacing: '0.04em' }}>
            AI Clinical Summary
          </span>
        </div>
        <p style={{ margin: 0, fontSize: 14.5, lineHeight: 1.6, color: '#1A2332', fontWeight: 500 }}>
          {patient.ai_summary || 'AI analysis is currently processing medical history…'}
        </p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 18, marginBottom: 18 }}>
        {/* Symptoms Panel */}
        <div style={{
          background: '#FFFFFF',
          borderRadius: 14,
          padding: '20px 24px',
          border: '1px solid #E8EEF3',
          boxShadow: '0 1px 3px rgba(0,0,0,0.03)',
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
            <div style={{
              width: 28, height: 28, borderRadius: 7,
              background: '#F1F5F9',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: '#64748B',
            }}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/><path d="M8 9h8"/><path d="M8 13h6"/></svg>
            </div>
            <span style={{ fontWeight: 700, fontSize: 13, color: '#64748B', textTransform: 'uppercase', letterSpacing: '0.04em' }}>
              Patient Symptoms
            </span>
          </div>
          <div style={{
            fontSize: 14,
            lineHeight: 1.6,
            color: '#475569',
            fontStyle: 'italic',
            background: '#F8FAFC',
            padding: '12px 16px',
            borderRadius: 10,
            border: '1px solid #F1F5F9'
          }}>
            "{patient.symptoms_text || 'No reported symptoms.'}"
          </div>
        </div>

        {/* Prescription History */}
        <div style={{
          background: '#FFFFFF',
          borderRadius: 14,
          padding: '20px 24px',
          border: '1px solid #E8EEF3',
          boxShadow: '0 1px 3px rgba(0,0,0,0.03)',
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 10 }}>
            <div style={{
              width: 28, height: 28, borderRadius: 7,
              background: '#F1F5F9',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: '#64748B',
            }}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
            </div>
            <span style={{ fontWeight: 700, fontSize: 13, color: '#64748B', textTransform: 'uppercase', letterSpacing: '0.04em' }}>
              Prescription History
            </span>
          </div>
          {loadingRx ? (
            <div style={{ fontSize: 13, color: '#94A3B8', textAlign: 'center', padding: '12px 0' }}>Loading records…</div>
          ) : prescriptions.length === 0 ? (
            <div style={{ fontSize: 13, color: '#CBD5E1', textAlign: 'center', padding: '12px 0' }}>No previous records.</div>
          ) : (
            <div style={{ maxHeight: 200, overflowY: 'auto', paddingRight: 4 }}>
              {prescriptions.map((rx, idx) => (
                <div key={idx} style={{
                  padding: '10px 12px',
                  borderRadius: 8,
                  background: '#F8FAFC',
                  marginBottom: 8,
                  border: '1px solid #F1F5F9'
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                    <span style={{ fontSize: 13, fontWeight: 700, color: '#1A2332' }}>{rx.diagnosis}</span>
                    <span style={{ fontSize: 11, color: '#94A3B8' }}>{format(new Date(rx.created_at), 'dd MMM yyyy')}</span>
                  </div>
                  <div style={{ display: 'flex', flexWrap: 'wrap', gap: 4 }}>
                    {rx.medications.map((m, i) => (
                      <span key={i} style={{ background: '#E8F7F2', color: '#156E52', padding: '1px 6px', borderRadius: 4, fontSize: 10, fontWeight: 600 }}>
                        {m}
                      </span>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* ── Issue Prescription Form ── */}
      <div style={{
        background: '#FFFFFF',
        borderRadius: 14,
        padding: '24px 28px',
        border: '1px solid #E8EEF3',
        boxShadow: '0 4px 12px rgba(0,0,0,0.04)',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 18 }}>
          <div style={{
            width: 28, height: 28, borderRadius: 7,
            background: '#E8F7F2',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: '#15803D',
          }}>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
          </div>
          <span style={{ fontWeight: 700, fontSize: 13.5, color: '#1A2332' }}>
            Issue Prescription
          </span>
        </div>

        {/* Success banner */}
        {success && (
          <div
            className="success-banner"
            style={{
              background: '#DCFCE7',
              border: '1.5px solid #86EFAC',
              borderRadius: 10,
              padding: '12px 16px',
              marginBottom: 16,
              display: 'flex',
              alignItems: 'center',
              gap: 8,
              color: '#15803D',
            }}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
            <span style={{ fontWeight: 600, fontSize: 14 }}>
              Prescription issued successfully
            </span>
          </div>
        )}

        {/* Error banner */}
        {submitError && (
          <div style={{
            background: '#FEF2F2',
            border: '1.5px solid #FECACA',
            borderRadius: 10,
            padding: '10px 14px',
            marginBottom: 14,
            fontSize: 13,
            color: '#DC2626',
            display: 'flex',
            alignItems: 'center',
            gap: 8,
          }}>
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            {submitError}
          </div>
        )}

        <div style={{ marginBottom: 16 }}>
          <label style={{ display: 'block', fontSize: 12, fontWeight: 700, color: '#64748B', marginBottom: 6, textTransform: 'uppercase', letterSpacing: '0.02em' }}>Diagnosis</label>
          <input
            type="text"
            value={diagnosis}
            onChange={(e) => setDiagnosis(e.target.value)}
            placeholder="e.g. Acute Gastroenteritis"
            style={{
              width: '100%',
              padding: '10px 14px',
              borderRadius: 10,
              border: '1.5px solid #E2E8F0',
              fontSize: 14,
              fontWeight: 500,
              fontFamily: 'inherit',
              outline: 'none',
              transition: 'border-color 0.15s',
            }}
          />
        </div>

        <div style={{ marginBottom: 16 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6 }}>
            <label style={{ fontSize: 12, fontWeight: 700, color: '#64748B', textTransform: 'uppercase', letterSpacing: '0.02em' }}>Medications</label>
            <button onClick={addMedication} style={{ background: 'none', border: 'none', color: '#1D9E75', fontSize: 12, fontWeight: 700, cursor: 'pointer' }}>+ Add Row</button>
          </div>
          {medications.map((med, idx) => (
            <div key={idx} style={{ display: 'flex', gap: 8, marginBottom: 8 }}>
              <input
                type="text"
                value={med}
                onChange={(e) => updateMedication(idx, e.target.value)}
                placeholder="Name, dosage, and frequency"
                style={{
                  flex: 1,
                  padding: '10px 14px',
                  borderRadius: 10,
                  border: '1.5px solid #E2E8F0',
                  fontSize: 14,
                  fontWeight: 500,
                  fontFamily: 'inherit',
                  outline: 'none',
                }}
              />
              {medications.length > 1 && (
                <button
                  onClick={() => removeMedication(idx)}
                  style={{
                    width: 38,
                    background: '#FEF2F2',
                    border: 'none',
                    borderRadius: 10,
                    color: '#DC2626',
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontSize: 18,
                  }}
                >
                  ×
                </button>
              )}
            </div>
          ))}
        </div>

        <div style={{ marginBottom: 20 }}>
          <label style={{ display: 'block', fontSize: 12, fontWeight: 700, color: '#64748B', marginBottom: 6, textTransform: 'uppercase', letterSpacing: '0.02em' }}>Clinical Notes (Optional)</label>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder="Advice on diet, rest, or follow-up symptoms…"
            style={{
              width: '100%',
              minHeight: 80,
              padding: '10px 14px',
              borderRadius: 10,
              border: '1.5px solid #E2E8F0',
              fontSize: 14,
              fontWeight: 500,
              fontFamily: 'inherit',
              outline: 'none',
              resize: 'vertical',
            }}
          />
        </div>

        <button
          onClick={handleSubmit}
          disabled={submitting}
          style={{
            width: '100%',
            padding: '13px 0',
            background: submitting ? '#94A3B8' : '#1D9E75',
            color: '#FFFFFF',
            border: 'none',
            borderRadius: 10,
            fontSize: 15,
            fontWeight: 700,
            cursor: submitting ? 'not-allowed' : 'pointer',
            fontFamily: 'DM Sans, sans-serif',
            letterSpacing: '0.02em',
            transition: 'background 0.15s, transform 0.1s',
            boxShadow: submitting ? 'none' : '0 4px 14px rgba(29,158,117,0.35)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 10,
          }}
          onMouseDown={(e) => !submitting && (e.currentTarget.style.transform = 'scale(0.99)')}
          onMouseUp={(e) => (e.currentTarget.style.transform = 'scale(1)')}
        >
          {submitting ? (
            <>⏳ Issuing…</>
          ) : (
            <>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
              Issue Prescription
            </>
          )}
        </button>
      </div>
    </div>
  )
}
