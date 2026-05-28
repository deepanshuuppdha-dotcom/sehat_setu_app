import { useState, useEffect, useRef, useCallback } from 'react'
import { getPatients } from './api'
import PatientCard from './components/PatientCard'
import PatientDetail from './components/PatientDetail'
import StatsBar from './components/StatsBar'
import StatusDot from './components/StatusDot'

function playP1Beep() {
  try {
    const ctx = new (window.AudioContext || window.webkitAudioContext)()
    const oscillator = ctx.createOscillator()
    const gainNode = ctx.createGain()
    oscillator.connect(gainNode)
    gainNode.connect(ctx.destination)
    oscillator.type = 'sine'
    oscillator.frequency.setValueAtTime(880, ctx.currentTime)
    oscillator.frequency.setValueAtTime(660, ctx.currentTime + 0.15)
    gainNode.gain.setValueAtTime(0.35, ctx.currentTime)
    gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.5)
    oscillator.start(ctx.currentTime)
    oscillator.stop(ctx.currentTime + 0.5)
  } catch (e) {}
}

export default function App() {
  const [patients, setPatients] = useState([])
  const [selectedId, setSelectedId] = useState(null)
  const [drawerOpen, setDrawerOpen] = useState(false)
  const [newPatientIds, setNewPatientIds] = useState(new Set())
  const [loading, setLoading] = useState(true)
  const prevIdsRef = useRef(new Set())
  const isFirstLoadRef = useRef(true)

  const fetchPatients = useCallback(async () => {
    try {
      const data = await getPatients()
      const fetched = Array.isArray(data) ? data : []
      if (isFirstLoadRef.current) {
        prevIdsRef.current = new Set(fetched.map((p) => p.id))
        setPatients(fetched)
        setLoading(false)
        isFirstLoadRef.current = false
        return
      }
      const incoming = new Set(fetched.map((p) => p.id))
      const added = fetched.filter((p) => !prevIdsRef.current.has(p.id))
      if (added.length > 0) {
        const addedIds = new Set(added.map((p) => p.id))
        setNewPatientIds(addedIds)
        if (added.some((p) => p.urgency_score === 'P1')) playP1Beep()
        setTimeout(() => {
          setNewPatientIds((prev) => {
            const next = new Set(prev)
            addedIds.forEach((id) => next.delete(id))
            return next
          })
        }, 3000)
      }
      prevIdsRef.current = incoming
      setPatients(fetched)
    } catch (err) {
      if (isFirstLoadRef.current) {
        setLoading(false)
        isFirstLoadRef.current = false
      }
    }
  }, [])

  useEffect(() => {
    fetchPatients()
    const interval = setInterval(fetchPatients, 8000)
    return () => clearInterval(interval)
  }, [fetchPatients])

  const handleCardClick = (patientId) => {
    if (selectedId === patientId && drawerOpen) {
      setDrawerOpen(false)
      setTimeout(() => setSelectedId(null), 300)
    } else {
      setSelectedId(patientId)
      setDrawerOpen(true)
    }
  }

  const handleCloseDrawer = () => {
    setDrawerOpen(false)
    setTimeout(() => setSelectedId(null), 300)
  }

  const selectedPatient = patients.find((p) => p.id === selectedId) || null
  const p1Count = patients.filter((p) => p.urgency_score === 'P1').length

  return (
    <div style={{
      display: 'flex',
      height: '100vh',
      width: '100vw',
      overflow: 'hidden',
      background: '#F3F6F9',
      fontFamily: 'DM Sans, sans-serif',
      position: 'relative',
    }}>

      {/* ── LEFT SIDEBAR ── */}
      <div style={{
        width: 380,
        flexShrink: 0,
        display: 'flex',
        flexDirection: 'column',
        background: '#FFFFFF',
        borderRight: '1px solid #E8EEF3',
        boxShadow: '2px 0 12px rgba(0,0,0,0.04)',
        zIndex: 10,
        height: '100vh',
      }}>
        {/* Logo */}
        <div style={{ padding: '20px 18px 14px', borderBottom: '1px solid #F1F5F9' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <div style={{
                width: 32, height: 32,
                background: 'linear-gradient(135deg, #1D9E75 0%, #0D7A59 100%)',
                borderRadius: 8,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: 17,
                boxShadow: '0 2px 8px rgba(29,158,117,0.35)',
              }}>🩺</div>
              <div>
                <div style={{ fontWeight: 800, fontSize: 17, color: '#1A2332', letterSpacing: '-0.02em', lineHeight: 1 }}>
                  Sehat<span style={{ color: '#1D9E75' }}>Setu</span>
                </div>
                <div style={{ fontSize: 9.5, color: '#94A3B8', fontWeight: 500, letterSpacing: '0.06em', textTransform: 'uppercase', marginTop: 1 }}>
                  Doctor Dashboard
                </div>
              </div>
            </div>
            <StatusDot />
          </div>
        </div>

        {/* Stats */}
        <div style={{ paddingTop: 12 }}>
          <StatsBar patients={patients} />
        </div>

        {/* Queue header */}
        <div style={{ padding: '0 16px 8px', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <span style={{ fontSize: 11, fontWeight: 700, color: '#64748B', textTransform: 'uppercase', letterSpacing: '0.06em' }}>
              Patient Queue
            </span>
            {p1Count > 0 && (
              <span style={{ marginLeft: 7, background: '#DC2626', color: '#FFF', borderRadius: 10, fontSize: 10, fontWeight: 700, padding: '1px 7px' }}>
                {p1Count} critical
              </span>
            )}
          </div>
          <span style={{ fontSize: 11, color: '#94A3B8' }}>
            {patients.length} patient{patients.length !== 1 ? 's' : ''}
          </span>
        </div>

        {/* Patient list */}
        <div className="sidebar-scroll" style={{ flex: 1, overflowY: 'auto', paddingBottom: 16 }}>
          {loading ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8, padding: '0 12px' }}>
              {[...Array(4)].map((_, i) => (
                <div key={i} style={{ height: 84, borderRadius: 10, background: '#F1F5F9' }} />
              ))}
            </div>
          ) : patients.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '40px 24px', color: '#94A3B8' }}>
              <div style={{ fontSize: 32, marginBottom: 8 }}>🏥</div>
              <div style={{ fontSize: 13, fontWeight: 500 }}>No patients in queue</div>
              <div style={{ fontSize: 11, marginTop: 4 }}>Waiting for new arrivals…</div>
            </div>
         ) : (
            patients.map((patient) => (
              <PatientCard
                key={patient.id}
                patient={patient}
                isSelected={patient.id === selectedId && drawerOpen}
                isNew={newPatientIds.has(patient.id)}
                onClick={() => handleCardClick(patient.id)}
                onDelete={(id) => setPatients((prev) => prev.filter((p) => p.id !== id))}
              />
            ))
          )}
        </div>

        {/* Footer */}
        <div style={{ padding: '10px 16px', borderTop: '1px solid #F1F5F9', fontSize: 10.5, color: '#CBD5E1', textAlign: 'center' }}>
          NEXA BRIGADE · SehatSetu v0.1 · Auto-refresh 8s
        </div>
      </div>

      {/* ── MAIN AREA ── */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#F3F6F9' }}>
        <div style={{ textAlign: 'center', color: '#94A3B8' }}>
          <div style={{ fontSize: 48, marginBottom: 16 }}>🩺</div>
          <div style={{ fontSize: 16, fontWeight: 600, color: '#94A3B8', marginBottom: 4 }}>
            Select a patient to begin
          </div>
          <div style={{ fontSize: 13, color: '#CBD5E1' }}>
            Click any patient card to open their details
          </div>
          {p1Count > 0 && (
            <div style={{ marginTop: 20, background: '#FEF2F2', border: '1.5px solid #FECACA', borderRadius: 10, padding: '10px 20px', fontSize: 13, color: '#DC2626', fontWeight: 600 }}>
              ⚠️ {p1Count} critical patient(s) need immediate attention
            </div>
          )}
        </div>
      </div>

      {/* ── BACKDROP ── */}
      {drawerOpen && (
        <div
          onClick={handleCloseDrawer}
          style={{
            position: 'fixed',
            inset: 0,
            background: 'rgba(0,0,0,0.35)',
            zIndex: 40,
            transition: 'opacity 0.3s',
          }}
        />
      )}

      {/* ── SLIDING DRAWER ── */}
      <div style={{
        position: 'fixed',
        top: 0,
        right: 0,
        width: 600,
        height: '100vh',
        background: '#F8FAFC',
        boxShadow: '-8px 0 40px rgba(0,0,0,0.15)',
        zIndex: 50,
        transform: drawerOpen ? 'translateX(0)' : 'translateX(100%)',
        transition: 'transform 0.35s cubic-bezier(0.16, 1, 0.3, 1)',
        overflow: 'hidden',
        display: 'flex',
        flexDirection: 'column',
      }}>
        {/* Drawer header with close button */}
        <div style={{
          padding: '16px 20px',
          background: '#FFFFFF',
          borderBottom: '1px solid #E8EEF3',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          flexShrink: 0,
        }}>
          <span style={{ fontWeight: 700, fontSize: 14, color: '#1A2332' }}>
            Patient Details
          </span>
          <button
            onClick={handleCloseDrawer}
            style={{
              width: 32, height: 32,
              borderRadius: 8,
              border: '1px solid #E2E8F0',
              background: '#F8FAFC',
              cursor: 'pointer',
              fontSize: 18,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              color: '#64748B',
            }}
          >
            ×
          </button>
        </div>

        {/* Drawer content */}
        <div style={{ flex: 1, overflow: 'auto' }}>
          {selectedPatient && (
            <PatientDetail key={selectedPatient.id} patient={selectedPatient} />
          )}
        </div>
      </div>
    </div>
  )
}