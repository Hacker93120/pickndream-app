'use client'

import { useState } from 'react'
import Link from 'next/link'
import { Save, Bell, Shield, Database, Mail, ArrowLeft, Sun, Moon, Palette } from 'lucide-react'
import { useTheme } from '../context/ThemeContext'

export default function SettingsPage() {
  const [notifications, setNotifications] = useState(true)
  const [emailAlerts, setEmailAlerts] = useState(false)
  const [autoSave, setAutoSave] = useState(true)
  const [twoFactor, setTwoFactor] = useState(false)
  const { theme, toggleTheme } = useTheme()

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 p-6 transition-colors duration-300">
      <div className="max-w-4xl mx-auto">
        {/* Header avec bouton retour */}
        <div className="flex items-center mb-6">
          <Link 
            href="/" 
            className="flex items-center text-blue-500 hover:text-blue-600 dark:text-blue-400 dark:hover:text-blue-300 mr-4"
          >
            <ArrowLeft className="h-5 w-5 mr-2" />
            Retour au tableau de bord
          </Link>
        </div>

        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Paramètres</h1>
          <p className="text-gray-600 dark:text-gray-400 mt-2">Gérez les paramètres de votre application</p>
        </div>

        <div className="space-y-6">
          {/* Apparence et Thème */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <div className="px-6 py-4 border-b dark:border-gray-700">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center">
                <Palette className="h-5 w-5 mr-2" />
                Apparence et thème
              </h2>
            </div>
            <div className="p-6 space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-medium text-gray-900 dark:text-white">Mode d'affichage</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">Choisissez entre le mode clair et sombre</p>
                </div>
                <button 
                  onClick={toggleTheme}
                  className="flex items-center px-4 py-2 bg-gray-100 dark:bg-gray-700 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors"
                >
                  {theme === 'light' ? (
                    <>
                      <Moon className="h-4 w-4 mr-2" />
                      <span className="text-gray-900 dark:text-white">Mode sombre</span>
                    </>
                  ) : (
                    <>
                      <Sun className="h-4 w-4 mr-2" />
                      <span className="text-gray-900 dark:text-white">Mode clair</span>
                    </>
                  )}
                </button>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Couleur d'accent
                  </label>
                  <div className="flex space-x-2">
                    {['bg-blue-500', 'bg-green-500', 'bg-purple-500', 'bg-red-500', 'bg-yellow-500'].map((color) => (
                      <button 
                        key={color}
                        className={`w-8 h-8 ${color} rounded-full border-2 border-gray-300 dark:border-gray-600 hover:scale-110 transition-transform`}
                      />
                    ))}
                  </div>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Taille de police
                  </label>
                  <select className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option>Petite</option>
                    <option>Normale</option>
                    <option>Grande</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          {/* General Settings */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <div className="px-6 py-4 border-b dark:border-gray-700">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center">
                <Shield className="h-5 w-5 mr-2" />
                Paramètres généraux
              </h2>
            </div>
            <div className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Nom de l'application
                </label>
                <input 
                  type="text" 
                  defaultValue="Pickn Dream"
                  className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Description
                </label>
                <textarea 
                  rows={3}
                  defaultValue="Application de réservation et de gestion"
                  className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-medium text-gray-900 dark:text-white">Sauvegarde automatique</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">Sauvegarder automatiquement les modifications</p>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input 
                    type="checkbox" 
                    checked={autoSave}
                    onChange={(e) => setAutoSave(e.target.checked)}
                    className="sr-only peer"
                  />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                </label>
              </div>
            </div>
          </div>

          {/* Sécurité */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <div className="px-6 py-4 border-b dark:border-gray-700">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center">
                <Shield className="h-5 w-5 mr-2" />
                Sécurité
              </h2>
            </div>
            <div className="p-6 space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-medium text-gray-900 dark:text-white">Authentification à deux facteurs</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">Ajouter une couche de sécurité supplémentaire</p>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input 
                    type="checkbox" 
                    checked={twoFactor}
                    onChange={(e) => setTwoFactor(e.target.checked)}
                    className="sr-only peer"
                  />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                </label>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <button className="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg">
                  Changer le mot de passe
                </button>
                <button className="px-4 py-2 border dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 text-gray-900 dark:text-white">
                  Voir les sessions actives
                </button>
              </div>
            </div>
          </div>

          {/* Notifications */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <div className="px-6 py-4 border-b dark:border-gray-700">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center">
                <Bell className="h-5 w-5 mr-2" />
                Notifications
              </h2>
            </div>
            <div className="p-6 space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-medium text-gray-900 dark:text-white">Notifications push</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">Recevoir des notifications en temps réel</p>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input 
                    type="checkbox" 
                    checked={notifications}
                    onChange={(e) => setNotifications(e.target.checked)}
                    className="sr-only peer"
                  />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                </label>
              </div>
              
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="text-sm font-medium text-gray-900 dark:text-white">Alertes email</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">Recevoir des alertes par email</p>
                </div>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input 
                    type="checkbox" 
                    checked={emailAlerts}
                    onChange={(e) => setEmailAlerts(e.target.checked)}
                    className="sr-only peer"
                  />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
                </label>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Fréquence des notifications
                </label>
                <select className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                  <option>Immédiatement</option>
                  <option>Toutes les heures</option>
                  <option>Quotidiennement</option>
                  <option>Hebdomadairement</option>
                </select>
              </div>
            </div>
          </div>

          {/* Database */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <div className="px-6 py-4 border-b dark:border-gray-700">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center">
                <Database className="h-5 w-5 mr-2" />
                Base de données
              </h2>
            </div>
            <div className="p-6 space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Sauvegarde automatique
                  </label>
                  <select className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option>Quotidienne</option>
                    <option>Hebdomadaire</option>
                    <option>Mensuelle</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Rétention des données
                  </label>
                  <select className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                    <option>30 jours</option>
                    <option>90 jours</option>
                    <option>1 an</option>
                    <option>Illimitée</option>
                  </select>
                </div>
              </div>
              <div className="flex space-x-4">
                <button className="px-4 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg">
                  Créer une sauvegarde
                </button>
                <button className="px-4 py-2 border dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 text-gray-900 dark:text-white">
                  Restaurer une sauvegarde
                </button>
              </div>
            </div>
          </div>

          {/* Email Configuration */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <div className="px-6 py-4 border-b dark:border-gray-700">
              <h2 className="text-lg font-semibold text-gray-900 dark:text-white flex items-center">
                <Mail className="h-5 w-5 mr-2" />
                Configuration email
              </h2>
            </div>
            <div className="p-6 space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Serveur SMTP
                  </label>
                  <input 
                    type="text" 
                    placeholder="smtp.example.com"
                    className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                    Port
                  </label>
                  <input 
                    type="number" 
                    placeholder="587"
                    className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Email expéditeur
                </label>
                <input 
                  type="email" 
                  placeholder="noreply@pickndream.com"
                  className="w-full px-3 py-2 border dark:border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                />
              </div>
              <button className="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg">
                Tester la configuration
              </button>
            </div>
          </div>

          {/* Save Button */}
          <div className="flex justify-end space-x-4">
            <button className="px-6 py-2 border dark:border-gray-600 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 text-gray-900 dark:text-white">
              Annuler
            </button>
            <button className="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-lg flex items-center">
              <Save className="h-4 w-4 mr-2" />
              Sauvegarder les paramètres
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
