import axios from 'axios'

const USE_MOCK = false

export { USE_MOCK }

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://192.168.0.101:8000/api',
  headers: { 'Content-Type': 'application/json' },
})

let mockPatients = []
const mockPrescriptions = {}

export const getPatients = async () => {
  if (USE_MOCK) return mockPatients
  return api.get('/patients').then((r) => r.data)
}

export const getPatient = async (id) => {
  if (USE_MOCK) return mockPatients.find((p) => p.id === id)
  return api.get(`/patients/${id}`).then((r) => r.data)
}

export const createPrescription = async (data) => {
  if (USE_MOCK) {
    const rx = { ...data, id: Date.now().toString(), created_at: new Date().toISOString() }
    if (!mockPrescriptions[data.patient_id]) mockPrescriptions[data.patient_id] = []
    mockPrescriptions[data.patient_id].unshift(rx)
    return rx
  }
  return api.post('/prescriptions', data).then((r) => r.data)
}

export const getPrescriptions = async (patientId) => {
  if (USE_MOCK) return mockPrescriptions[patientId] || []
  return api.get(`/prescriptions/${patientId}`).then((r) => r.data)
}

export const deletePatient = async (id) => {
  if (USE_MOCK) {
    mockPatients = mockPatients.filter((p) => p.id !== id)
    delete mockPrescriptions[id]
    return { success: true }
  }
  return api.delete(`/patients/${id}`).then((r) => r.data)
}

export const login = async (phone, empId) =>
  api.post('/auth/login', { phone, emp_id: empId }).then((r) => r.data)

export const register = (phone, empId, speciality, name) =>
  api.post('/auth/register', { phone, emp_id: empId, speciality, name }).then((r) => r.data)

export default api