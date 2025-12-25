'use client';

import { useState, useEffect } from 'react';

interface Hotel {
  id: string;
  name: string;
  description: string;
  city: string;
  address: string;
  pricePerNight: number;
  createdAt: string;
  owner: {
    name: string;
    email: string;
    phone: string;
  };
  photos: Array<{ url: string }>;
}

export default function PendingHotels() {
  const [hotels, setHotels] = useState<Hotel[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchPendingHotels();
  }, []);

  const fetchPendingHotels = async () => {
    try {
      const response = await fetch('/api/admin/hotels/pending');
      const data = await response.json();
      if (data.success) {
        setHotels(data.hotels);
      }
    } catch (error) {
      console.error('Error:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async (hotelId: string) => {
    try {
      const response = await fetch(`/api/admin/hotels/${hotelId}/approve`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'approve' })
      });

      if (response.ok) {
        fetchPendingHotels(); // Recharger la liste
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  const handleReject = async (hotelId: string) => {
    const reason = prompt('Raison du rejet (optionnel):');
    
    try {
      const response = await fetch(`/api/admin/hotels/${hotelId}/approve`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'reject', reason })
      });

      if (response.ok) {
        fetchPendingHotels(); // Recharger la liste
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  if (loading) {
    return <div className="p-6">Chargement...</div>;
  }

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold mb-6">Demandes d'hôtels en attente ({hotels.length})</h1>
      
      {hotels.length === 0 ? (
        <div className="text-gray-500">Aucune demande en attente</div>
      ) : (
        <div className="grid gap-6">
          {hotels.map((hotel) => (
            <div key={hotel.id} className="bg-white border rounded-lg p-6 shadow-sm">
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h3 className="text-xl font-semibold">{hotel.name}</h3>
                  <p className="text-gray-600">{hotel.city} - {hotel.address}</p>
                  <p className="text-lg font-bold text-green-600">{hotel.pricePerNight}€/nuit</p>
                </div>
                
                {hotel.photos.length > 0 && (
                  <img 
                    src={hotel.photos[0].url} 
                    alt={hotel.name}
                    className="w-24 h-16 object-cover rounded"
                  />
                )}
              </div>

              <p className="text-gray-700 mb-4">{hotel.description}</p>

              <div className="bg-gray-50 p-3 rounded mb-4">
                <h4 className="font-semibold mb-2">Propriétaire :</h4>
                <p><strong>Nom :</strong> {hotel.owner.name}</p>
                <p><strong>Email :</strong> {hotel.owner.email}</p>
                <p><strong>Téléphone :</strong> {hotel.owner.phone}</p>
              </div>

              <div className="flex space-x-3">
                <button
                  onClick={() => handleApprove(hotel.id)}
                  className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
                >
                  ✅ Approuver
                </button>
                <button
                  onClick={() => handleReject(hotel.id)}
                  className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
                >
                  ❌ Rejeter
                </button>
              </div>

              <div className="text-xs text-gray-500 mt-2">
                Demande créée le {new Date(hotel.createdAt).toLocaleDateString('fr-FR')}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
