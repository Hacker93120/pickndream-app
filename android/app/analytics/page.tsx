'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { ArrowLeft, TrendingUp, TrendingDown, Users, Download, Eye, Clock } from 'lucide-react'

export default function Analytics() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeUsers: 0,
    downloads: 0,
    revenue: 0,
    pageViews: 0,
    avgSession: 0
  })

  const [chartData, setChartData] = useState<{
    dailyUsers: Array<{ day: string; users: number; change: number }>;
    monthlyRevenue: Array<{ month: string; revenue: number }>;
    topPages: Array<{ page: string; views: number; percentage: number }>;
  }>({
    dailyUsers: [],
    monthlyRevenue: [],
    topPages: []
  })

  useEffect(() => {
    setStats({
      totalUsers: 12543,
      activeUsers: 3421,
      downloads: 8765,
      revenue: 15420,
      pageViews: 45678,
      avgSession: 245
    })

    setChartData({
      dailyUsers: [
        { day: 'Lun', users: 1200, change: 5 },
        { day: 'Mar', users: 1350, change: 12 },
        { day: 'Mer', users: 1100, change: -8 },
        { day: 'Jeu', users: 1450, change: 15 },
        { day: 'Ven', users: 1600, change: 10 },
        { day: 'Sam', users: 1800, change: 12 },
        { day: 'Dim', users: 1400, change: -22 }
      ],
      monthlyRevenue: [
        { month: 'Jan', revenue: 12000 },
        { month: 'Fév', revenue: 15000 },
        { month: 'Mar', revenue: 18000 },
        { month: 'Avr', revenue: 16000 },
        { month: 'Mai', revenue: 22000 },
        { month: 'Jun', revenue: 25000 }
      ],
      topPages: [
        { page: '/dashboard', views: 15420, percentage: 35 },
        { page: '/users', views: 8760, percentage: 20 },
        { page: '/analytics', views: 6540, percentage: 15 },
        { page: '/settings', views: 4320, percentage: 10 },
        { page: '/profile', views: 3210, percentage: 8 }
      ]
    })
  }, [])

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 p-6 transition-colors duration-300">
      <div className="max-w-7xl mx-auto">
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

        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 dark:text-white">Analytiques détaillées</h1>
            <p className="text-gray-600 dark:text-gray-400 mt-2">Analyse complète des performances</p>
          </div>
          <div className="flex space-x-2">
            <select className="px-4 py-2 border dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
              <option>7 derniers jours</option>
              <option>30 derniers jours</option>
              <option>3 derniers mois</option>
            </select>
          </div>
        </div>
        
        {/* Cartes de statistiques améliorées */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
          <StatCard 
            title="Utilisateurs Total" 
            value={stats.totalUsers.toLocaleString()} 
            change="+12%"
            icon={Users}
            color="bg-blue-500"
            trend="up"
          />
          <StatCard 
            title="Utilisateurs Actifs" 
            value={stats.activeUsers.toLocaleString()} 
            change="+8%"
            icon={Users}
            color="bg-green-500"
            trend="up"
          />
          <StatCard 
            title="Téléchargements" 
            value={stats.downloads.toLocaleString()} 
            change="+23%"
            icon={Download}
            color="bg-purple-500"
            trend="up"
          />
          <StatCard 
            title="Revenus (€)" 
            value={stats.revenue.toLocaleString()} 
            change="+15%"
            icon={TrendingUp}
            color="bg-yellow-500"
            trend="up"
          />
          <StatCard 
            title="Pages vues" 
            value={stats.pageViews.toLocaleString()} 
            change="-3%"
            icon={Eye}
            color="bg-indigo-500"
            trend="down"
          />
          <StatCard 
            title="Session moyenne" 
            value={`${Math.floor(stats.avgSession / 60)}m ${stats.avgSession % 60}s`}
            change="+5%"
            icon={Clock}
            color="bg-pink-500"
            trend="up"
          />
        </div>

        {/* Graphiques améliorés */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          {/* Graphique utilisateurs quotidiens */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Utilisateurs quotidiens</h3>
            <div className="space-y-3">
              {chartData.dailyUsers.map((data, index) => (
                <div key={index} className="flex items-center justify-between">
                  <span className="text-sm text-gray-600 dark:text-gray-400 w-12">{data.day}</span>
                  <div className="flex-1 mx-4">
                    <div className="bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                      <div 
                        className="bg-blue-500 h-2 rounded-full" 
                        style={{ width: `${(data.users / 2000) * 100}%` }}
                      ></div>
                    </div>
                  </div>
                  <span className="text-sm font-medium text-gray-900 dark:text-white w-16">{data.users}</span>
                  <span className={`text-xs w-12 text-right ${data.change > 0 ? 'text-green-500' : 'text-red-500'}`}>
                    {data.change > 0 ? '+' : ''}{data.change}%
                  </span>
                </div>
              ))}
            </div>
          </div>
          
          {/* Graphique revenus mensuels */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Revenus mensuels (€)</h3>
            <div className="space-y-3">
              {chartData.monthlyRevenue.map((data, index) => (
                <div key={index} className="flex items-center justify-between">
                  <span className="text-sm text-gray-600 dark:text-gray-400 w-12">{data.month}</span>
                  <div className="flex-1 mx-4">
                    <div className="bg-gray-200 dark:bg-gray-700 rounded-full h-3">
                      <div 
                        className="bg-gradient-to-r from-green-400 to-green-600 h-3 rounded-full" 
                        style={{ width: `${(data.revenue / 25000) * 100}%` }}
                      ></div>
                    </div>
                  </div>
                  <span className="text-sm font-medium text-gray-900 dark:text-white">{data.revenue.toLocaleString()}€</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Pages les plus visitées */}
        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 mb-8">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">Pages les plus visitées</h3>
          <div className="space-y-4">
            {chartData.topPages.map((page, index) => (
              <div key={index} className="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
                <div className="flex items-center">
                  <span className="text-sm font-medium text-gray-900 dark:text-white mr-4">#{index + 1}</span>
                  <span className="text-sm text-gray-600 dark:text-gray-400">{page.page}</span>
                </div>
                <div className="flex items-center space-x-4">
                  <span className="text-sm font-medium text-gray-900 dark:text-white">{page.views.toLocaleString()} vues</span>
                  <div className="w-20 bg-gray-200 dark:bg-gray-600 rounded-full h-2">
                    <div 
                      className="bg-blue-500 h-2 rounded-full" 
                      style={{ width: `${page.percentage}%` }}
                    ></div>
                  </div>
                  <span className="text-xs text-gray-500 dark:text-gray-400 w-8">{page.percentage}%</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Métriques en temps réel */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h4 className="text-sm font-medium text-gray-600 dark:text-gray-400 mb-2">Utilisateurs en ligne</h4>
            <div className="flex items-center">
              <span className="text-2xl font-bold text-gray-900 dark:text-white">247</span>
              <div className="ml-2 w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
            </div>
          </div>
          
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h4 className="text-sm font-medium text-gray-600 dark:text-gray-400 mb-2">Taux de conversion</h4>
            <span className="text-2xl font-bold text-gray-900 dark:text-white">3.2%</span>
            <span className="text-sm text-green-500 ml-2">+0.5%</span>
          </div>
          
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
            <h4 className="text-sm font-medium text-gray-600 dark:text-gray-400 mb-2">Taux de rebond</h4>
            <span className="text-2xl font-bold text-gray-900 dark:text-white">42.1%</span>
            <span className="text-sm text-red-500 ml-2">-2.3%</span>
          </div>
        </div>
      </div>
    </div>
  )
}

function StatCard({ title, value, change, icon: Icon, color, trend }: {
  title: string
  value: string
  change: string
  icon: any
  color: string
  trend: 'up' | 'down'
}) {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center">
          <div className={`${color} rounded-lg p-3 text-white mr-4`}>
            <Icon className="h-6 w-6" />
          </div>
          <div>
            <p className="text-sm font-medium text-gray-600 dark:text-gray-400">{title}</p>
            <p className="text-2xl font-bold text-gray-900 dark:text-white">{value}</p>
          </div>
        </div>
        <div className="flex items-center">
          {trend === 'up' ? (
            <TrendingUp className="h-4 w-4 text-green-500 mr-1" />
          ) : (
            <TrendingDown className="h-4 w-4 text-red-500 mr-1" />
          )}
          <span className={`text-sm font-medium ${trend === 'up' ? 'text-green-500' : 'text-red-500'}`}>
            {change}
          </span>
        </div>
      </div>
    </div>
  )
}
