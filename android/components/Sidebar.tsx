'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { 
  Home, 
  BarChart3, 
  Users, 
  Settings, 
  Download, 
  Bell, 
  Search, 
  X,
  Calendar
} from 'lucide-react'

interface SidebarProps {
  isOpen: boolean
  onClose: () => void
}

export default function Sidebar({ isOpen, onClose }: SidebarProps) {
  const pathname = usePathname()

  const navigation = [
    { name: 'Tableau de bord', href: '/', icon: Home, badge: '5', current: pathname === '/' },
    { name: 'Analytiques', href: '/analytics', icon: BarChart3, badge: '↗ +12%', current: pathname === '/analytics' },
    { name: 'Réservations', href: '/reservations', icon: Calendar, badge: '3', current: pathname === '/reservations' },
    { name: 'Utilisateurs', href: '/users', icon: Users, badge: '247', current: pathname === '/users' },
    { name: 'Téléchargements', href: '/downloads', icon: Download, current: pathname === '/downloads' },
    { name: 'Paramètres', href: '/settings', icon: Settings, current: pathname === '/settings' },
  ]

  const tools = [
    { name: 'Notifications', icon: Bell, hasNotification: true },
    { name: 'Recherche', icon: Search },
  ]

  return (
    <div className={`fixed inset-y-0 left-0 z-50 w-64 bg-white dark:bg-gray-800 shadow-lg transform ${isOpen ? 'translate-x-0' : '-translate-x-full'} transition-transform duration-300 ease-in-out lg:translate-x-0 lg:static lg:inset-0 flex flex-col`}>
      {/* Header */}
      <div className="flex items-center justify-between h-16 px-6 border-b dark:border-gray-700 bg-gradient-to-r from-blue-600 to-purple-600">
        <div className="flex items-center">
          <div className="w-8 h-8 bg-white rounded-lg flex items-center justify-center mr-3">
            <span className="text-blue-600 font-bold text-lg">P</span>
          </div>
          <h1 className="text-xl font-bold text-white">Pickn Dream</h1>
        </div>
        <button 
          onClick={onClose}
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
          {navigation.map((item) => {
            const Icon = item.icon
            return (
              <Link
                key={item.name}
                href={item.href}
                className={`flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors ${
                  item.current
                    ? 'text-white bg-gradient-to-r from-blue-500 to-purple-600 shadow-sm'
                    : 'text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
                }`}
              >
                <Icon className="h-5 w-5 mr-3" />
                {item.name}
                {item.badge && (
                  <span className={`ml-auto text-xs px-2 py-1 rounded-full ${
                    item.current 
                      ? 'bg-white bg-opacity-20' 
                      : item.name === 'Analytiques' 
                        ? 'text-green-500' 
                        : 'bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200'
                  }`}>
                    {item.badge}
                  </span>
                )}
              </Link>
            )
          })}
        </div>
        
        {/* Section séparée */}
        <div className="mt-8">
          <p className="px-4 text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wider mb-3">
            Outils
          </p>
          <div className="space-y-1">
            {tools.map((tool) => {
              const Icon = tool.icon
              return (
                <button
                  key={tool.name}
                  className="w-full flex items-center px-4 py-3 text-sm font-medium text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors"
                >
                  <Icon className="h-5 w-5 mr-3" />
                  {tool.name}
                  {tool.hasNotification && (
                    <span className="ml-auto w-2 h-2 bg-red-500 rounded-full"></span>
                  )}
                </button>
              )
            })}
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
      </div>
    </div>
  )
}
