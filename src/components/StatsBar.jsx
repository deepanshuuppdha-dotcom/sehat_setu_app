export default function StatsBar({ patients }) {
  const total = patients.length

  const p1Count = patients.filter((p) => p.urgency_score === 'P1').length
  const p2Count = patients.filter((p) => p.urgency_score === 'P2').length

  const StatPill = ({ label, value, color, bg, border }) => (
    <div style={{
      flex: 1,
      background: bg,
      border: `1px solid ${border}`,
      borderRadius: 8,
      padding: '6px 8px',
      textAlign: 'center',
      minWidth: 0,
    }}>
      <div style={{
        fontSize: 18,
        fontWeight: 700,
        color,
        lineHeight: 1.1,
        fontVariantNumeric: 'tabular-nums',
      }}>
        {value}
      </div>
      <div style={{
        fontSize: 10,
        color: '#64748B',
        fontWeight: 500,
        marginTop: 1,
        whiteSpace: 'nowrap',
        overflow: 'hidden',
        textOverflow: 'ellipsis',
        letterSpacing: '0.02em',
      }}>
        {label}
      </div>
    </div>
  )

  return (
    <div style={{
      display: 'flex',
      gap: 6,
      padding: '0 16px 12px',
    }}>
      <StatPill
        label="Today"
        value={total}
        color="#1A2332"
        bg="#F8FAFC"
        border="#E2E8F0"
      />
      <StatPill
        label="Critical"
        value={p1Count}
        color="#DC2626"
        bg="#FEF2F2"
        border="#FECACA"
      />
      <StatPill
        label="Urgent"
        value={p2Count}
        color="#EA580C"
        bg="#FFF7ED"
        border="#FED7AA"
      />
      <StatPill
        label="Avg Wait"
        value="< 2m"
        color="#1D9E75"
        bg="#E8F7F2"
        border="#A7DFD0"
      />
    </div>
  )
}
