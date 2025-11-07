'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { 
  Users, 
  Download, 
  DollarSign, 
  TrendingUp, 
  Menu, 
  X, 
  Home, 
  BarChart3, 
  Settings, 
  Bell,
  Search,
  Sun,
  Moon
} from 'lucide-react'
import { useTheme } from './context/ThemeContext'
import { useAuth } from './context/AuthContext'

export default function AdminDashboard() {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [userMenuOpen, setUserMenuOpen] = useState(false)
  const { theme, toggleTheme } = useTheme()
  const { user, logout } = useAuth()
  const router = useRouter()

  useEffect(() => {
    if (!user) {
      router.push('/login')
      return
    }
  }, [user, router])

  if (!user) {
    return null
  }

  // Données dynamiques selon l'utilisateur
  const getUserStats = () => {
    if (user.role === 'admin') {
      return [
        { title: 'Utilisateurs Total', value: '12,543', change: '+12%', icon: Users, color: 'bg-blue-500' },
        { title: 'Téléchargements', value: '8,765', change: '+8%', icon: Download, color: 'bg-green-500' },
        { title: 'Revenus', value: '€15,420', change: '+23%', icon: DollarSign, color: 'bg-purple-500' },
        { title: 'Croissance', value: '18.2%', change: '+5%', icon: TrendingUp, color: 'bg-orange-500' }
      ]
    } else {
      return [
        { title: 'Mes Voyages', value: user.data.trips.toString(), change: '+2', icon: Users, color: 'bg-blue-500' },
        { title: 'Réservations', value: user.data.bookings.toString(), change: '+1', icon: Download, color: 'bg-green-500' },
        { title: 'Favoris', value: user.data.favorites.toString(), change: '+3', icon: DollarSign, color: 'bg-purple-500' },
        { title: 'Points', value: user.data.points.toString(), change: '+50', icon: TrendingUp, color: 'bg-orange-500' }
      ]
    }
  }

  const stats = getUserStats()

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 flex transition-colors duration-300">
      {/* Sidebar */}
      <div className={`fixed inset-y-0 left-0 z-50 w-64 bg-white dark:bg-gray-800 shadow-lg transform ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0 flex flex-col`}>
        {/* Header */}
        <div className="flex items-center justify-between h-16 px-6 border-b dark:border-gray-700 bg-gradient-to-r from-blue-600 to-purple-600">
          <div className="flex items-center">
            <div className="w-8 h-8 bg-white rounded-lg flex items-center justify-center mr-3">
              <span className="text-blue-600 font-bold text-lg">P</span>
            </div>
            <h1 className="text-xl font-bold text-white">Pickn Dream</h1>
          </div>
          <button 
            onClick={() => setSidebarOpen(false)}
            className="lg:hidden text-white hover:text-gray-200"
          >
            <X className="h-6 w-6" />
          </button>
        </div>
        
        {/* User Profile */}
        <div className="p-4 border-b dark:border-gray-700">
          <div className="flex items-center">
            <div className="h-10 w-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center">
              <span className="text-white text-sm font-medium">AD</span>
            </div>
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-900 dark:text-white">Admin User</p>
              <p className="text-xs text-gray-500 dark:text-gray-400">Utilisateur connecté</p>
            </div>
          </div>
        </div>
        
        {/* Navigation */}
        <nav className="flex-1 mt-4 px-2">
          <div className="space-y-1">
            <Link href="/" className="flex items-center px-4 py-3 text-sm font-medium text-white bg-gradient-to-r from-blue-500 to-purple-600 rounded-lg shadow-sm">
              <Home className="h-5 w-5 mr-3" />
              Tableau de bord
              <span className="ml-auto bg-white bg-opacity-20 text-xs px-2 py-1 rounded-full">5</span>
            </Link>
            
            <Link href="/analytics" className="flex items-center px-4 py-3 text-sm font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
              <BarChart3 className="h-5 w-5 mr-3" />
              Analytiques
              <span className="ml-auto text-xs text-green-500">↗ +12%</span>
            </Link>
            
            <Link href="/users" className="flex items-center px-4 py-3 text-sm font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
              <Users className="h-5 w-5 mr-3" />
              Utilisateurs
              <span className="ml-auto bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200 text-xs px-2 py-1 rounded-full">247</span>
            </Link>
            
            {/* Nouveau menu déroulant */}
            <div className="space-y-1">
              <button className="w-full flex items-center px-4 py-3 text-sm font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
                <Download className="h-5 w-5 mr-3" />
                Téléchargements
                <span className="ml-auto">
                  <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </span>
              </button>
            </div>
            
            <Link href="/settings" className="flex items-center px-4 py-3 text-sm font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
              <Settings className="h-5 w-5 mr-3" />
              Paramètres
            </Link>
          </div>
          
          {/* Section séparée */}
          <div className="mt-8">
            <p className="px-4 text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-3">
              Outils
            </p>
            <div className="space-y-1">
              <button className="w-full flex items-center px-4 py-3 text-sm font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
                <Bell className="h-5 w-5 mr-3" />
                Notifications
                <span className="ml-auto w-2 h-2 bg-red-500 rounded-full"></span>
              </button>
              
              <button className="w-full flex items-center px-4 py-3 text-sm font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors">
                <Search className="h-5 w-5 mr-3" />
                Recherche
              </button>
            </div>
          </div>
        </nav>
        
        {/* Footer avec stats */}
        <div className="p-4 border-t dark:border-gray-700">
          <div className="bg-gradient-to-r from-green-50 to-blue-50 dark:from-gray-700 dark:to-gray-600 rounded-lg p-3">
            <div className="flex items-center justify-between text-sm">
              <span className="text-gray-600 dark:text-gray-300">Stockage utilisé</span>
              <span className="font-medium text-gray-900 dark:text-white">68%</span>
            </div>
            <div className="mt-2 bg-gray-200 dark:bg-gray-600 rounded-full h-2">
              <div className="bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full" style={{ width: '68%' }}></div>
            </div>
            <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">2.1 GB de 3 GB utilisés</p>
          </div>
          
          {/* Bouton d'aide */}
          <button className="w-full mt-3 flex items-center justify-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white text-sm font-medium rounded-lg transition-colors">
            <svg className="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            Aide & Support
          </button>
          
          {/* Bouton de déconnexion */}
          <Link 
            href="/login"
            className="w-full mt-2 flex items-center justify-center px-4 py-2 bg-red-500 hover:bg-red-600 text-white text-sm font-medium rounded-lg transition-colors"
          >
            <svg className="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
            Déconnexion
          </Link>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Header */}
        <header className="bg-white dark:bg-gray-800 shadow-sm border-b dark:border-gray-700">
          <div className="flex items-center justify-between px-6 py-4">
            <div className="flex items-center">
              <button 
                onClick={() => setSidebarOpen(true)}
                className="lg:hidden mr-4 text-gray-500 dark:text-gray-400"
              >
                <Menu className="h-6 w-6" />
              </button>
              <h2 className="text-2xl font-semibold text-gray-900 dark:text-white">
                {user.role === 'admin' ? 'Tableau de bord Admin' : `Bonjour ${user.name}`}
              </h2>
            </div>
            
            <div className="flex items-center space-x-4">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input 
                  type="text" 
                  placeholder="Rechercher..."
                  className="pl-10 pr-4 py-2 border dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                />
              </div>
              <button 
                onClick={toggleTheme}
                className="p-2 text-gray-400 hover:text-gray-600 dark:text-gray-300 dark:hover:text-gray-100"
              >
                {theme === 'light' ? <Moon className="h-5 w-5" /> : <Sun className="h-5 w-5" />}
              </button>
              <Bell className="h-6 w-6 text-gray-400 hover:text-gray-600 dark:text-gray-300 dark:hover:text-gray-100 cursor-pointer" />
              
              {/* Menu utilisateur */}
              <div className="relative">
                <button 
                  onClick={() => setUserMenuOpen(!userMenuOpen)}
                  className="h-8 w-8 bg-blue-500 rounded-full flex items-center justify-center hover:bg-blue-600 transition-colors"
                >
                  <span className="text-white text-sm font-medium">AD</span>
                </button>
                
                {/* Menu déroulant */}
                {userMenuOpen && (
                  <div className="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 rounded-lg shadow-lg border dark:border-gray-700 z-50">
                    <div className="py-1">
                      <div className="px-4 py-2 border-b dark:border-gray-700">
                        <p className="text-sm font-medium text-gray-900 dark:text-white">{user.name}</p>
                        <p className="text-xs text-gray-500 dark:text-gray-400">{user.email}</p>
                      </div>
                      <Link 
                        href="/profile" 
                        className="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                        onClick={() => setUserMenuOpen(false)}
                      >
                        👤 Mon profil
                      </Link>
                      <Link 
                        href="/settings" 
                        className="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                        onClick={() => setUserMenuOpen(false)}
                      >
                        ⚙️ Paramètres
                      </Link>
                      <button 
                        onClick={toggleTheme}
                        className="w-full text-left px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
                      >
                        {theme === 'light' ? '🌙 Mode sombre' : '☀️ Mode clair'}
                      </button>
                      <hr className="my-1 border-gray-200 dark:border-gray-600" />
                      <button 
                        onClick={() => {
                          logout()
                          setUserMenuOpen(false)
                        }}
                        className="w-full text-left px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 font-medium"
                      >
                        🚪 Se déconnecter
                      </button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </header>

        {/* Overlay pour fermer le menu */}
        {userMenuOpen && (
          <div 
            className="fixed inset-0 z-40" 
            onClick={() => setUserMenuOpen(false)}
          ></div>
        )}

        {/* Dashboard Content */}
        <main className="flex-1 overflow-y-auto p-6">
          {/* Stats Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            {stats.map((stat, index) => (
              <div key={index} className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
                <div className="flex items-center">
                  <div className={`${stat.color} rounded-lg p-3 text-white mr-4`}>
                    <stat.icon className="h-6 w-6" />
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-600 dark:text-gray-400">{stat.title}</p>
                    <p className="text-2xl font-bold text-gray-900 dark:text-white">{stat.value}</p>
                    <p className="text-sm text-green-600 dark:text-green-400">{stat.change}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* Charts Section */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                {user.role === 'admin' ? 'Utilisateurs actifs' : 'Mes voyages récents'}
              </h3>
              <div className="h-64 bg-gray-100 dark:bg-gray-700 rounded flex items-center justify-center">
                <p className="text-gray-500 dark:text-gray-400">
                  {user.role === 'admin' ? 'Graphique des utilisateurs actifs' : 'Historique de vos voyages'}
                </p>
              </div>
            </div>
            
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                {user.role === 'admin' ? 'Revenus mensuels' : 'Points de fidélité'}
              </h3>
              <div className="h-64 bg-gray-100 dark:bg-gray-700 rounded flex items-center justify-center">
                <p className="text-gray-500 dark:text-gray-400">
                  {user.role === 'admin' ? 'Graphique des revenus' : 'Évolution de vos points'}
                </p>
              </div>
            </div>
          </div>

          {/* Recent Activity */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <div className="px-6 py-4 border-b dark:border-gray-700">
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                {user.role === 'admin' ? 'Activité récente' : 'Mes activités récentes'}
              </h3>
            </div>
            <div className="p-6">
              <div className="space-y-4">
                {(user.role === 'admin' ? [
                  { user: 'Jean Dupont', action: 'a téléchargé l\'app', time: 'Il y a 2 min' },
                  { user: 'Marie Martin', action: 'a créé un compte', time: 'Il y a 5 min' },
                  { user: 'Pierre Durand', action: 'a effectué un paiement', time: 'Il y a 10 min' },
                  { user: 'Sophie Leroy', action: 'a mis à jour son profil', time: 'Il y a 15 min' }
                ] : [
                  { user: 'Vous', action: 'avez réservé un voyage à Paris', time: 'Il y a 1h' },
                  { user: 'Vous', action: 'avez ajouté Lyon aux favoris', time: 'Il y a 3h' },
                  { user: 'Vous', action: 'avez gagné 50 points', time: 'Il y a 1j' },
                  { user: 'Vous', action: 'avez complété votre profil', time: 'Il y a 2j' }
                ]).map((activity, index) => (
                  <div key={index} className="flex items-center justify-between py-2">
                    <div className="flex items-center">
                      <div className="h-8 w-8 bg-gray-300 dark:bg-gray-600 rounded-full mr-3 flex items-center justify-center">
                        <span className="text-xs font-medium text-gray-600 dark:text-gray-300">
                          {user.role === 'admin' ? activity.user.charAt(0) : user.name.charAt(0)}
                        </span>
                      </div>
                      <div>
                        <p className="text-sm font-medium text-gray-900 dark:text-white">{activity.user}</p>
                        <p className="text-sm text-gray-600 dark:text-gray-400">{activity.action}</p>
                      </div>
                    </div>
                    <span className="text-sm text-gray-500 dark:text-gray-400">{activity.time}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>
  )
}
