<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="max-w-md w-full bg-white rounded-lg shadow-lg p-8">
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-gray-800">Accesso Amministratore</h1>
        <p class="text-gray-600 mt-2">Inserisci la password per accedere alla dashboard</p>
      </div>

      <form @submit.prevent="handleLogin" class="space-y-6">
        <div>
          <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
            Password Amministratore
          </label>
          <input
            id="password"
            v-model="password"
            type="password"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Inserisci la password"
          />
        </div>

        <div v-if="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
          {{ error }}
        </div>

        <button
          type="submit"
          :disabled="isLoading"
          class="w-full bg-blue-600 text-white py-3 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
        >
          <span v-if="isLoading">Accesso in corso...</span>
          <span v-else>Accedi</span>
        </button>
      </form>

      <div class="mt-6 text-center">
        <a href="/" class="text-blue-600 hover:text-blue-800 text-sm">
          ← Torna alla homepage
        </a>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const emit = defineEmits<{
  authenticated: []
}>()

const password = ref('')
const error = ref('')
const isLoading = ref(false)

// Password admin (in produzione dovresti usare una variabile d'ambiente)
const ADMIN_PASSWORD = import.meta.env.PUBLIC_ADMIN_PASSWORD || 'admin123'

const handleLogin = async () => {
  isLoading.value = true
  error.value = ''

  try {
    // Simula un piccolo delay per l'autenticazione
    await new Promise(resolve => setTimeout(resolve, 500))

    if (password.value === ADMIN_PASSWORD) {
      // Salva lo stato di autenticazione nel localStorage
      localStorage.setItem('admin_authenticated', 'true')
      localStorage.setItem('admin_auth_time', Date.now().toString())
      
      emit('authenticated')
    } else {
      error.value = 'Password non corretta'
    }
  } catch (err) {
    error.value = 'Errore durante l\'autenticazione'
  } finally {
    isLoading.value = false
  }
}
</script>
