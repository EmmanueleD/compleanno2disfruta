<template>
  <div class="max-w-2xl mx-auto p-6 bg-white rounded-lg shadow-lg">
    <h1 class="text-3xl font-bold text-center mb-8 text-gray-800">
      Prenotazione Laboratori
    </h1>

    <form @submit.prevent="submitRegistration" class="space-y-6">
      <!-- Personal Information -->
      <div class="bg-gray-50 p-4 rounded-lg">
        <h2 class="text-xl font-semibold mb-4 text-gray-700">Informazioni Personali</h2>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="nome" class="block text-sm font-medium text-gray-700 mb-1">
              Nome *
            </label>
            <input id="nome" v-model="form.nome" type="text" required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>

          <div>
            <label for="cognome" class="block text-sm font-medium text-gray-700 mb-1">
              Cognome *
            </label>
            <input id="cognome" v-model="form.cognome" type="text" required
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
        </div>

        <div class="mt-4">
          <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
            Email *
          </label>
          <input id="email" v-model="form.email" type="email" required
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>
      </div>

      <!-- Workshop Sessions -->
      <div class="space-y-6">
        <!-- Quilling Workshop -->
        <div class="bg-blue-50 p-6 rounded-lg">
          <h3 class="text-lg font-semibold mb-4 text-blue-800">
            Laboratorio di Quilling *
          </h3>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
            <button v-for="session in 3" :key="`quilling-${session}`" type="button"
              @click="form.quilling_session = session" :class="[
                'p-4 rounded-lg border-2 transition-all duration-200 font-medium',
                form.quilling_session === session
                  ? 'border-blue-500 bg-blue-100 text-blue-700 shadow-md'
                  : 'border-blue-200 bg-white text-blue-600 hover:border-blue-300 hover:bg-blue-50'
              ]">
              <div class="text-center">
                <div class="text-lg font-bold">Sessione {{ session }}</div>
                <div class="text-sm opacity-75">Posti illimitati</div>
              </div>
            </button>
          </div>
        </div>

        <!-- Ricamo Workshop -->
        <div class="bg-green-50 p-6 rounded-lg">
          <h3 class="text-lg font-semibold mb-4 text-green-800">
            Laboratorio di Ricamo *
          </h3>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
            <button v-for="session in 3" :key="`ricamo-${session}`" type="button" @click="form.ricamo_session = session"
              :class="[
                'p-4 rounded-lg border-2 transition-all duration-200 font-medium',
                form.ricamo_session === session
                  ? 'border-green-500 bg-green-100 text-green-700 shadow-md'
                  : 'border-green-200 bg-white text-green-600 hover:border-green-300 hover:bg-green-50'
              ]">
              <div class="text-center">
                <div class="text-lg font-bold">Sessione {{ session }}</div>
                <div class="text-sm opacity-75">Posti illimitati</div>
              </div>
            </button>
          </div>
        </div>

        <!-- Psychology Workshop -->
        <div class="bg-purple-50 p-6 rounded-lg">
          <h3 class="text-lg font-semibold mb-4 text-purple-800">
            Laboratorio di Psicologia *
            <span class="text-sm font-normal text-purple-600">(Max 15 partecipanti per sessione)</span>
          </h3>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
            <button v-for="session in 3" :key="`psicologia-${session}`" type="button"
              @click="!isSessionFull(session) && (form.psicologia_session = session)" :disabled="isSessionFull(session)"
              :class="[
                'p-4 rounded-lg border-2 transition-all duration-200 font-medium',
                isSessionFull(session)
                  ? 'border-red-300 bg-red-50 text-red-400 cursor-not-allowed opacity-60'
                  : form.psicologia_session === session
                    ? 'border-purple-500 bg-purple-100 text-purple-700 shadow-md'
                    : 'border-purple-200 bg-white text-purple-600 hover:border-purple-300 hover:bg-purple-50'
              ]">
              <div class="text-center">
                <div class="text-lg font-bold mb-2">Sessione {{ session }}</div>

                <!-- Avatar Grid -->
                <div class="grid grid-cols-5 gap-1 mb-2 justify-center">
                  <!-- Occupied slots with avatars -->
                  <div v-for="i in (sessionCounts[session] || 0)" :key="`occupied-${session}-${i}`"
                    class="w-6 h-6 rounded-full overflow-hidden border border-purple-300">
                    <img :src="`https://avatar.iran.liara.run/public/${session}${i}&size=24`" :alt="`Partecipante ${i}`"
                      class="w-full h-full object-cover" />
                  </div>

                  <!-- Empty slots -->
                  <div v-for="i in (15 - (sessionCounts[session] || 0))" :key="`empty-${session}-${i}`"
                    class="w-6 h-6 rounded-full bg-gray-200 border border-gray-300"></div>
                </div>

                <div class="text-sm">
                  <span v-if="isSessionFull(session)" class="text-red-500 font-medium">
                    COMPLETA
                  </span>
                  <span v-else class="opacity-75">
                    {{ sessionCounts[session] || 0 }}/15 posti occupati
                  </span>
                </div>
                <div v-if="!isSessionFull(session)" class="text-xs mt-1 opacity-60">
                  {{ 15 - (sessionCounts[session] || 0) }} posti disponibili
                </div>
              </div>
            </button>
          </div>
        </div>
      </div>

      <!-- Error Message -->
      <div v-if="errorMessage" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
        {{ errorMessage }}
      </div>

      <!-- Success Message -->
      <div v-if="successMessage" class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded">
        {{ successMessage }}
      </div>

      <!-- Submit Button -->
      <button type="submit" :disabled="isSubmitting"
        class="w-full bg-blue-600 text-white py-3 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed">
        <span v-if="isSubmitting">Invio in corso...</span>
        <span v-else>Conferma Prenotazione</span>
      </button>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '../lib/supabase'

const form = ref({
  nome: '',
  cognome: '',
  email: '',
  quilling_session: null as number | null,
  ricamo_session: null as number | null,
  psicologia_session: null as number | null
})

const sessionCounts = ref<Record<number, number>>({})
const isSubmitting = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const isSessionFull = (session: number): boolean => {
  return sessionCounts.value[session] >= 15
}

const loadSessionCounts = async () => {
  try {
    // Get all registrations and count psychology sessions directly
    const { data, error } = await supabase
      .from('registrations')
      .select('psicologia_session')

    if (error) throw error

    // Count participants for each psychology session
    const counts: Record<number, number> = { 1: 0, 2: 0, 3: 0 }
    data?.forEach(registration => {
      if (registration.psicologia_session) {
        counts[registration.psicologia_session] = (counts[registration.psicologia_session] || 0) + 1
      }
    })

    sessionCounts.value = counts
    console.log('Session counts loaded:', counts)
  } catch (error) {
    console.error('Error loading session counts:', error)
  }
}

const submitRegistration = async () => {
  if (!form.value.nome || !form.value.cognome || !form.value.email ||
    !form.value.quilling_session || !form.value.ricamo_session || !form.value.psicologia_session) {
    errorMessage.value = 'Tutti i campi sono obbligatori'
    return
  }

  if (isSessionFull(form.value.psicologia_session)) {
    errorMessage.value = 'La sessione selezionata per il Laboratorio di Psicologia è al completo'
    return
  }

  isSubmitting.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const { error } = await supabase
      .from('registrations')
      .insert([{
        nome: form.value.nome,
        cognome: form.value.cognome,
        email: form.value.email,
        quilling_session: form.value.quilling_session,
        ricamo_session: form.value.ricamo_session,
        psicologia_session: form.value.psicologia_session
      }])

    if (error) {
      if (error.message.includes('duplicate key')) {
        throw new Error('Questa email è già stata utilizzata per una prenotazione')
      }
      if (error.message.includes('al completo')) {
        throw new Error(error.message)
      }
      throw error
    }

    // Redirect to confirmation page with booking data
    const params = new URLSearchParams({
      nome: form.value.nome,
      cognome: form.value.cognome,
      email: form.value.email,
      quilling: form.value.quilling_session.toString(),
      ricamo: form.value.ricamo_session.toString(),
      psicologia: form.value.psicologia_session.toString()
    });
    
    window.location.href = `/conferma?${params.toString()}`;

  } catch (error: any) {
    errorMessage.value = error.message || 'Si è verificato un errore durante la prenotazione'
  } finally {
    isSubmitting.value = false
  }
}

onMounted(() => {
  loadSessionCounts()
})
</script>
