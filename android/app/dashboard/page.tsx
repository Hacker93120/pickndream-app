'use client'

import { useEffect } from 'react'
import { useRouter } from 'next/navigation'

export default function DashboardRedirect() {
  const router = useRouter()

  useEffect(() => {
    // Rediriger vers la page principale
    router.push('/')
  }, [router])

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 flex items-center justify-center">
      <p className="text-gray-600 dark:text-gray-400">Redirection...</p>
    </div>
  )
}
