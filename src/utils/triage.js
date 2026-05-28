import { formatDistanceToNow } from 'date-fns'

/**
 * Returns Tailwind-compatible inline style classes for each priority.
 * Returns an object: { bg, text, border, badge } for flexible usage.
 */
export function getPriorityColor(score) {
  const map = {
    P1: {
      bg: '#FEF2F2',
      text: '#DC2626',
      border: '#FECACA',
      badgeBg: '#DC2626',
      badgeText: '#FFFFFF',
      ring: 'rgba(220,38,38,0.3)',
    },
    P2: {
      bg: '#FFF7ED',
      text: '#EA580C',
      border: '#FED7AA',
      badgeBg: '#EA580C',
      badgeText: '#FFFFFF',
      ring: 'rgba(234,88,12,0.2)',
    },
    P3: {
      bg: '#EFF6FF',
      text: '#2563EB',
      border: '#DBEAFE',
      badgeBg: '#2563EB',
      badgeText: '#FFFFFF',
      ring: 'rgba(37,99,235,0.2)',
    },
    P4: {
      bg: '#F8FAFC',
      text: '#64748B',
      border: '#E2E8F0',
      badgeBg: '#64748B',
      badgeText: '#FFFFFF',
      ring: 'rgba(100,116,139,0.2)',
    },
  }
  return map[score] || map['P4']
}

export function getPriorityLabel(score) {
  const labels = {
    P1: 'Critical',
    P2: 'Urgent',
    P3: 'Semi-Urgent',
    P4: 'Routine',
  }
  return labels[score] || 'Unknown'
}

export function getTimeAgo(datetime) {
  if (!datetime) return '—'
  try {
    const date = new Date(datetime)
    return formatDistanceToNow(date, { addSuffix: true })
  } catch {
    return '—'
  }
}

export function getLanguageEmoji(lang) {
  const map = {
    hi: '🇮🇳',
    ta: '🇮🇳',
    mr: '🇮🇳',
    en: '🇬🇧',
  }
  return map[lang] || '🌐'
}

export function getLanguageLabel(lang) {
  const map = {
    hi: 'Hindi',
    ta: 'Tamil',
    mr: 'Marathi',
    en: 'English',
  }
  return map[lang] || lang
}
