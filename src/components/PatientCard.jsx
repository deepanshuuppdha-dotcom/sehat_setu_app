import { getPriorityColor, getPriorityLabel, getTimeAgo } from '../utils/triage'

export default function PatientCard({ patient, isSelected, isNew, onClick }) {
  const colors = getPriorityColor(patient.urgency_score)
  const isP1 = patient.urgency_score === 'P1'
  const timeAgo = getTimeAgo(patient.created_at)

  // Show "Syncing" chip if patient arrived within last 30 seconds
  const arrivedAt = new Date(patient.created_at)
  const isRecentlySynced = Date.now() - arrivedAt.getTime() < 30000

  const summaryPreview = patient.ai_summary
    ? patient.ai_summary.split('.')[0].trim()
    : 'No summary available'

  return (
    <div
      onClick={onClick}
      className={`card-hover ${isNew ? 'patient-card-enter' : ''} ${isP1 ? 'priority-p1' : ''}`}
      style={{
        margin: '0 8px 8px',
        borderRadius: 10,
        border: `1.5px solid ${isSelected ? '#1D9E75' : colors.border}`,
        background: isSelected ? '#E8F7F2' : '#FFFFFF',
        cursor: 'pointer',
        overflow: 'hidden',
        position: 'relative',
        transition: 'border-color 0.15s, background 0.15s',
      }}
    >
      {/* Selected left accent bar */}
      {isSelected && (
        <div style={{
          position: 'absolute',
          left: 0, top: 0, bottom: 0,
          width: 3,
          background: '#1D9E75',
          borderRadius: '10px 0 0 10px',
        }} />
      )}

      <div style={{ display: 'flex', alignItems: 'stretch',padding: '14px 14px 14px 16px', gap: 10 }}>
        {/* Priority Badge */}
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'flex-start',
          paddingTop: 2,
          gap: 3,
          flexShrink: 0,
        }}>
          <div style={{
            background: colors.badgeBg,
            color: colors.badgeText,
            borderRadius: 6,
            fontSize: 11,
            fontWeight: 700,
            padding: '2px 7px',
            letterSpacing: '0.04em',
            fontVariantNumeric: 'tabular-nums',
          }}>
            {patient.urgency_score}
          </div>
          <div style={{
            fontSize: 9,
            color: colors.text,
            fontWeight: 600,
            letterSpacing: '0.03em',
            whiteSpace: 'nowrap',
          }}>
            {getPriorityLabel(patient.urgency_score)}
          </div>
        </div>

        {/* Content */}
        <div style={{ flex: 1, minWidth: 0 }}>
          {/* Name + time row */}
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 4 }}>
            <span style={{
              fontWeight: 600,
              fontSize: 13.5,
              color: '#1A2332',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
            }}>
              {patient.name}
            </span>
            <span style={{
              fontSize: 10.5,
              color: '#94A3B8',
              whiteSpace: 'nowrap',
              flexShrink: 0,
              fontWeight: 400,
            }}>
              {timeAgo}
            </span>
          </div>

          {/* Age + gender */}
          <div style={{
            fontSize: 11,
            color: '#64748B',
            marginTop: 1,
            marginBottom: 4,
            fontWeight: 400,
          }}>
            {patient.age}y · {patient.gender}
          </div>

          {/* AI Summary preview */}
          <div style={{
            fontSize: 11.5,
            color: '#475569',
            lineHeight: 1.45,
            overflow: 'hidden',
            display: '-webkit-box',
            WebkitLineClamp: 2,
            WebkitBoxOrient: 'vertical',
          }}>
            {summaryPreview}
          </div>

          {/* Syncing chip */}
          {isRecentlySynced && (
            <div
              className="syncing-chip"
              style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: 4,
                marginTop: 6,
                borderRadius: 4,
                padding: '2px 7px',
                fontSize: 10,
                fontWeight: 600,
                color: '#156E52',
              }}
            >
              🔄 Syncing
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
