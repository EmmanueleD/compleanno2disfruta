<template>
  <div class="max-w-6xl mx-auto p-6">
    <h1 class="text-3xl font-bold text-center mb-8 text-gray-800">
      Dashboard Amministratore
    </h1>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
      <div class="bg-blue-100 p-6 rounded-lg">
        <h3 class="text-lg font-semibold text-blue-800">Totale Iscrizioni</h3>
        <p class="text-3xl font-bold text-blue-600">{{ totalRegistrations }}</p>
      </div>
      
      <div class="bg-green-100 p-6 rounded-lg">
        <h3 class="text-lg font-semibold text-green-800">Quilling</h3>
        <div class="text-sm text-green-600">
          <div>Sessione 1: {{ workshopStats.quilling[1] || 0 }}</div>
          <div>Sessione 2: {{ workshopStats.quilling[2] || 0 }}</div>
          <div>Sessione 3: {{ workshopStats.quilling[3] || 0 }}</div>
        </div>
      </div>
      
      <div class="bg-yellow-100 p-6 rounded-lg">
        <h3 class="text-lg font-semibold text-yellow-800">Ricamo</h3>
        <div class="text-sm text-yellow-600">
          <div>Sessione 1: {{ workshopStats.ricamo[1] || 0 }}</div>
          <div>Sessione 2: {{ workshopStats.ricamo[2] || 0 }}</div>
          <div>Sessione 3: {{ workshopStats.ricamo[3] || 0 }}</div>
        </div>
      </div>
      
      <div class="bg-purple-100 p-6 rounded-lg">
        <h3 class="text-lg font-semibold text-purple-800">Psicologia</h3>
        <div class="text-sm text-purple-600">
          <div>Sessione 1: {{ workshopStats.psicologia[1] || 0 }}/15</div>
          <div>Sessione 2: {{ workshopStats.psicologia[2] || 0 }}/15</div>
          <div>Sessione 3: {{ workshopStats.psicologia[3] || 0 }}/15</div>
        </div>
      </div>
    </div>

    <!-- Search and Actions -->
    <div class="bg-white p-4 rounded-lg shadow mb-6">
      <div class="flex flex-col md:flex-row gap-4">
        <input
          v-model="searchTerm"
          type="text"
          placeholder="Cerca per nome, cognome o email..."
          class="flex-1 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        <button
          @click="showAddParticipantModal = true"
          class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
        >
          Aggiungi Partecipante
        </button>
        <button
          @click="exportToCSV"
          class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700"
        >
          Esporta CSV
        </button>
      </div>
    </div>

    <!-- Registrations Table -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Partecipante
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Email
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Quilling
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Ricamo
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Psicologia
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Data Iscrizione
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Azioni
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="registration in filteredRegistrations" :key="registration.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">
                  {{ registration.nome }} {{ registration.cognome }}
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ registration.email }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                  Sessione {{ registration.quilling_session }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  Sessione {{ registration.ricamo_session }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                  Sessione {{ registration.psicologia_session }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ formatDate(registration.created_at) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                <button
                  @click="deleteParticipant(registration.id)"
                  class="text-red-600 hover:text-red-800 font-medium"
                  title="Rimuovi partecipante"
                >
                  Rimuovi
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div v-if="filteredRegistrations.length === 0" class="text-center py-8 text-gray-500">
        Nessuna iscrizione trovata
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-8">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      <p class="mt-2 text-gray-600">Caricamento...</p>
    </div>

    <!-- Error State -->
    <div v-if="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mt-4">
      {{ error }}
    </div>

    <!-- Add Participant Modal -->
    <div v-if="showAddParticipantModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-6 w-full max-w-md mx-4">
        <h3 class="text-lg font-semibold mb-4">Aggiungi Partecipante</h3>
        
        <form @submit.prevent="addParticipant" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Nome *</label>
            <input
              v-model="newParticipant.nome"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Cognome *</label>
            <input
              v-model="newParticipant.cognome"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Email *</label>
            <input
              v-model="newParticipant.email"
              type="email"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div class="grid grid-cols-3 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Quilling</label>
              <select
                v-model="newParticipant.quilling_session"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Seleziona</option>
                <option value="1">Sessione 1</option>
                <option value="2">Sessione 2</option>
                <option value="3">Sessione 3</option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Ricamo</label>
              <select
                v-model="newParticipant.ricamo_session"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Seleziona</option>
                <option value="1">Sessione 1</option>
                <option value="2">Sessione 2</option>
                <option value="3">Sessione 3</option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Psicologia</label>
              <select
                v-model="newParticipant.psicologia_session"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">Seleziona</option>
                <option value="1" :disabled="sessionCounts[1] >= 15">
                  Sessione 1 {{ sessionCounts[1] >= 15 ? '(Completa)' : `(${sessionCounts[1] || 0}/15)` }}
                </option>
                <option value="2" :disabled="sessionCounts[2] >= 15">
                  Sessione 2 {{ sessionCounts[2] >= 15 ? '(Completa)' : `(${sessionCounts[2] || 0}/15)` }}
                </option>
                <option value="3" :disabled="sessionCounts[3] >= 15">
                  Sessione 3 {{ sessionCounts[3] >= 15 ? '(Completa)' : `(${sessionCounts[3] || 0}/15)` }}
                </option>
              </select>
            </div>
          </div>

          <div v-if="addError" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
            {{ addError }}
          </div>

          <div class="flex gap-3 pt-4">
            <button
              type="submit"
              :disabled="isAdding"
              class="flex-1 bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 disabled:opacity-50"
            >
              {{ isAdding ? 'Aggiunta...' : 'Aggiungi' }}
            </button>
            <button
              type="button"
              @click="closeAddModal"
              class="flex-1 bg-gray-300 text-gray-700 py-2 px-4 rounded-md hover:bg-gray-400"
            >
              Annulla
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { supabase, type Registration } from '../lib/supabase'

const registrations = ref<Registration[]>([])
const loading = ref(true)
const error = ref('')
const searchTerm = ref('')
const sessionCounts = ref<Record<number, number>>({})
const showAddParticipantModal = ref(false)
const isAdding = ref(false)
const addError = ref('')

const newParticipant = ref({
  nome: '',
  cognome: '',
  email: '',
  quilling_session: null as number | null,
  ricamo_session: null as number | null,
  psicologia_session: null as number | null
})

const totalRegistrations = computed(() => registrations.value.length)

const workshopStats = computed(() => {
  const stats = {
    quilling: {} as Record<number, number>,
    ricamo: {} as Record<number, number>,
    psicologia: {} as Record<number, number>
  }

  registrations.value.forEach(reg => {
    // Count Quilling sessions
    stats.quilling[reg.quilling_session] = (stats.quilling[reg.quilling_session] || 0) + 1
    
    // Count Ricamo sessions
    stats.ricamo[reg.ricamo_session] = (stats.ricamo[reg.ricamo_session] || 0) + 1
    
    // Count Psicologia sessions
    stats.psicologia[reg.psicologia_session] = (stats.psicologia[reg.psicologia_session] || 0) + 1
  })

  return stats
})

const filteredRegistrations = computed(() => {
  let filtered = registrations.value

  // Search filter
  if (searchTerm.value) {
    const term = searchTerm.value.toLowerCase()
    filtered = filtered.filter(reg => 
      reg.nome.toLowerCase().includes(term) ||
      reg.cognome.toLowerCase().includes(term) ||
      reg.email.toLowerCase().includes(term)
    )
  }

  return filtered
})

const loadSessionCounts = async () => {
  try {
    const { data, error: supabaseError } = await supabase
      .from('sessions')
      .select('session_number, current_participants')
      .eq('workshop_id', 3) // Psychology workshop

    if (supabaseError) throw supabaseError

    const counts: Record<number, number> = {}
    data?.forEach(session => {
      counts[session.session_number] = session.current_participants
    })
    sessionCounts.value = counts
  } catch (error) {
    console.error('Error loading session counts:', error)
  }
}

const loadRegistrations = async () => {
  try {
    loading.value = true
    const { data, error: supabaseError } = await supabase
      .from('registrations')
      .select('*')
      .order('created_at', { ascending: false })

    if (supabaseError) throw supabaseError

    registrations.value = data || []
    await loadSessionCounts()
  } catch (err: any) {
    error.value = err.message || 'Errore nel caricamento delle iscrizioni'
  } finally {
    loading.value = false
  }
}

const addParticipant = async () => {
  if (!newParticipant.value.nome || !newParticipant.value.cognome || !newParticipant.value.email ||
      !newParticipant.value.quilling_session || !newParticipant.value.ricamo_session || !newParticipant.value.psicologia_session) {
    addError.value = 'Tutti i campi sono obbligatori'
    return
  }

  if (sessionCounts.value[newParticipant.value.psicologia_session] >= 15) {
    addError.value = 'La sessione selezionata per il Laboratorio di Psicologia è al completo'
    return
  }

  isAdding.value = true
  addError.value = ''

  try {
    const { error: supabaseError } = await supabase
      .from('registrations')
      .insert([{
        nome: newParticipant.value.nome,
        cognome: newParticipant.value.cognome,
        email: newParticipant.value.email,
        quilling_session: newParticipant.value.quilling_session,
        ricamo_session: newParticipant.value.ricamo_session,
        psicologia_session: newParticipant.value.psicologia_session
      }])

    if (supabaseError) {
      if (supabaseError.message.includes('duplicate key')) {
        throw new Error('Questa email è già stata utilizzata per una prenotazione')
      }
      if (supabaseError.message.includes('al completo')) {
        throw new Error(supabaseError.message)
      }
      throw supabaseError
    }

    // Reload data and close modal
    await loadRegistrations()
    closeAddModal()
  } catch (err: any) {
    addError.value = err.message || 'Si è verificato un errore durante l\'aggiunta del partecipante'
  } finally {
    isAdding.value = false
  }
}

const deleteParticipant = async (id: number) => {
  if (!confirm('Sei sicuro di voler rimuovere questo partecipante?')) {
    return
  }

  console.log('Attempting to delete participant with ID:', id)

  try {
    // First check if the record exists
    const { data: existingRecord, error: checkError } = await supabase
      .from('registrations')
      .select('*')
      .eq('id', id)
      .single()

    console.log('Existing record check:', { existingRecord, checkError })

    if (checkError || !existingRecord) {
      throw new Error('Partecipante non trovato')
    }

    // Try to delete without .select() first
    const { error: deleteError } = await supabase
      .from('registrations')
      .delete()
      .eq('id', id)

    console.log('Delete error:', deleteError)

    if (deleteError) {
      console.error('Supabase delete error:', deleteError)
      throw deleteError
    }

    console.log('Successfully deleted participant with ID:', id)
    
    // Reload data
    await loadRegistrations()
  } catch (err: any) {
    console.error('Error in deleteParticipant:', err)
    error.value = err.message || 'Errore nella rimozione del partecipante'
  }
}

const closeAddModal = () => {
  showAddParticipantModal.value = false
  addError.value = ''
  newParticipant.value = {
    nome: '',
    cognome: '',
    email: '',
    quilling_session: null,
    ricamo_session: null,
    psicologia_session: null
  }
}

const formatDate = (dateString: string): string => {
  return new Date(dateString).toLocaleDateString('it-IT', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const exportToCSV = () => {
  const headers = ['Nome', 'Cognome', 'Email', 'Quilling', 'Ricamo', 'Psicologia', 'Data Iscrizione']
  const csvContent = [
    headers.join(','),
    ...filteredRegistrations.value.map(reg => [
      reg.nome,
      reg.cognome,
      reg.email,
      `Sessione ${reg.quilling_session}`,
      `Sessione ${reg.ricamo_session}`,
      `Sessione ${reg.psicologia_session}`,
      formatDate(reg.created_at)
    ].join(','))
  ].join('\n')

  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement('a')
  const url = URL.createObjectURL(blob)
  link.setAttribute('href', url)
  link.setAttribute('download', `iscrizioni_laboratori_${new Date().toISOString().split('T')[0]}.csv`)
  link.style.visibility = 'hidden'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

onMounted(() => {
  loadRegistrations()
})
</script>
