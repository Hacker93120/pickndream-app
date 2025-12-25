'use client'

import { useState, useEffect } from 'react'

interface Reservation {
  id: string
  hotel: {
    name: string
    city: string
    rating: number
  }
  checkIn: string
  checkOut: string
  guests: number
  totalPrice: number
  status: 'confirmed' | 'pending' | 'cancelled'
  bookingDate: string
}

export default function ReservationsPage() {
  const [reservations, setReservations] = useState<Reservation[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Simulation des données de réservation
    const mockReservations: Reservation[] = [
      {
        id: '1',
        hotel: {
          name: 'Hôtel Le Grand Paris',
          city: 'Paris',
          rating: 4.5
        },
        checkIn: '2024-12-15',
        checkOut: '2024-12-18',
        guests: 2,
        totalPrice: 450,
        status: 'confirmed',
        bookingDate: '2024-11-01'
      },
      {
        id: '2',
        hotel: {
          name: 'Villa Méditerranée',
          city: 'Nice',
          rating: 4.8
        },
        checkIn: '2024-11-25',
        checkOut: '2024-11-28',
        guests: 4,
        totalPrice: 680,
        status: 'pending',
        bookingDate: '2024-11-05'
      }
    ]
    
    setTimeout(() => {
      setReservations(mockReservations)
      setLoading(false)
    }, 1000)
  }, [])

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'confirmed': return 'bg-green-100 text-green-800'
      case 'pending': return 'bg-yellow-100 text-yellow-800'
      case 'cancelled': return 'bg-red-100 text-red-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  const getStatusText = (status: string) => {
    switch (status) {
      case 'confirmed': return 'Confirmée'
      case 'pending': return 'En attente'
      case 'cancelled': return 'Annulée'
      default: return status
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Chargement de vos réservations...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Mes Réservations</h1>
          <p className="text-gray-600">Gérez vos réservations d'hôtels</p>
        </div>

        {reservations.length === 0 ? (
          <div className="text-center py-12">
            <div className="w-24 h-24 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-4xl">📅</span>
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Aucune réservation</h3>
            <p className="text-gray-600 mb-6">Vous n'avez pas encore de réservations d'hôtel.</p>
            <button className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors">
              Réserver un hôtel
            </button>
          </div>
        ) : (
          <div className="space-y-6">
            {reservations.map((reservation) => (
              <div key={reservation.id} className="bg-white rounded-lg shadow-md overflow-hidden">
                <div className="md:flex">
                  <div className="md:w-1/3">
                    <div className="h-48 md:h-full bg-gradient-to-br from-blue-100 to-purple-100 flex items-center justify-center">
                      <span className="text-6xl">🏨</span>
                    </div>
                  </div>
                  <div className="md:w-2/3 p-6">
                    <div className="flex justify-between items-start mb-4">
                      <div>
                        <h3 className="text-xl font-semibold text-gray-900">{reservation.hotel.name}</h3>
                        <div className="flex items-center text-gray-600 mt-1">
                          <span className="mr-1">📍</span>
                          <span>{reservation.hotel.city}</span>
                          <div className="flex items-center ml-4">
                            <span className="text-yellow-400">★</span>
                            <span className="ml-1">{reservation.hotel.rating}</span>
                          </div>
                        </div>
                      </div>
                      <span className={`px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(reservation.status)}`}>
                        {getStatusText(reservation.status)}
                      </span>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                      <div className="flex items-center text-gray-600">
                        <span className="mr-2">📅</span>
                        <div>
                          <p className="text-sm">Arrivée</p>
                          <p className="font-medium">{new Date(reservation.checkIn).toLocaleDateString('fr-FR')}</p>
                        </div>
                      </div>
                      <div className="flex items-center text-gray-600">
                        <span className="mr-2">📅</span>
                        <div>
                          <p className="text-sm">Départ</p>
                          <p className="font-medium">{new Date(reservation.checkOut).toLocaleDateString('fr-FR')}</p>
                        </div>
                      </div>
                      <div className="flex items-center text-gray-600">
                        <span className="mr-2">💰</span>
                        <div>
                          <p className="text-sm">Prix total</p>
                          <p className="font-medium">{reservation.totalPrice}€</p>
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center justify-between">
                      <div className="text-sm text-gray-500">
                        <span className="mr-1">🕒</span>
                        Réservé le {new Date(reservation.bookingDate).toLocaleDateString('fr-FR')}
                      </div>
                      <div className="space-x-2">
                        <button className="text-blue-600 hover:text-blue-800 text-sm font-medium">
                          Voir détails
                        </button>
                        {reservation.status === 'confirmed' && (
                          <button className="text-red-600 hover:text-red-800 text-sm font-medium">
                            Annuler
                          </button>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
