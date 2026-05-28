import { useState, useEffect } from 'react'
import api, { USE_MOCK } from '../api'

export default function StatusDot() {
  const [online, setOnline] = useState(USE_MOCK ? true : null) // null = checking

  const check = async () => {
    if (USE_MOCK) {
      setOnline(true)
      return
    }
    try {
      await api.get('/patients', { timeout: 4000 })
      setOnline(true)
    } catch {
      setOnline(false)
    }
  }

  useEffect(() => {
    check()
    const interval = setInterval(check, 5000)
    return () => clearInterval(interval)
  }, [])

  if (online === null) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
        <div style={{
          width: 7, height: 7, borderRadius: '50%',
          background: '#94A3B8',
        }} />
        <span style={{ fontSize: 11, color: '#94A3B8', fontWeight: 500, letterSpacing: '0.02em' }}>
          Connecting…
        </span>
      </div>
    )
  }

  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
      <div
        className={online ? 'live-dot' : ''}
        style={{
          width: 7,
          height: 7,
          borderRadius: '50%',
          background: online ? '#1D9E75' : '#EF4444',
          boxShadow: online ? '0 0 0 2px rgba(29,158,117,0.25)' : 'none',
        }}
      />
      <span style={{
        fontSize: 11,
        color: online ? '#1D9E75' : '#EF4444',
        fontWeight: 600,
        letterSpacing: '0.04em',
        textTransform: 'uppercase',
      }}>
        {USE_MOCK ? 'Demo Mode' : (online ? 'Live' : 'Offline')}
      </span>
    </div>
  )
}
