<template>
  <div>
    <AdminLogin v-if="!isAuthenticated" @authenticated="handleAuthenticated" />
    <div v-else>
      <div class="bg-white shadow-sm border-b mb-6">
        <div class="max-w-6xl mx-auto px-6 py-4 flex justify-between items-center">
          <h1 class="text-xl font-semibold text-gray-800">Dashboard Amministratore</h1>
          <button
            @click="logout"
            class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 text-sm"
          >
            Esci
          </button>
        </div>
      </div>
      <AdminDashboard />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import AdminLogin from './AdminLogin.vue'
import AdminDashboard from './AdminDashboard.vue'

const isAuthenticated = ref(false)

// Controlla se l'utente è già autenticato
const checkAuthentication = () => {
  const authStatus = localStorage.getItem('admin_authenticated')
  const authTime = localStorage.getItem('admin_auth_time')
  
  if (authStatus === 'true' && authTime) {
    const timeElapsed = Date.now() - parseInt(authTime)
    const maxSessionTime = 24 * 60 * 60 * 1000 // 24 ore in millisecondi
    
    if (timeElapsed < maxSessionTime) {
      isAuthenticated.value = true
    } else {
      // Sessione scaduta
      logout()
    }
  }
}

const handleAuthenticated = () => {
  isAuthenticated.value = true
}

const logout = () => {
  localStorage.removeItem('admin_authenticated')
  localStorage.removeItem('admin_auth_time')
  isAuthenticated.value = false
}

onMounted(() => {
  checkAuthentication()
})
</script>
