"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

type Hotel = {
  id: string;
  name: string;
  description: string | null;
  city: string;
  address: string;
  country: string;
  rating: number;
  pricePerNight: number;
  status: string;
  isListed: boolean;
  photoUrl: string | null;
  rejectionReason: string | null;
  createdAt: string;
  owner?: {
    id: string;
    name: string;
    email: string;
  };
};

export default function HotelsManagement() {
  const router = useRouter();
  const [hotels, setHotels] = useState<Hotel[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("PENDING");
  const [actionLoading, setActionLoading] = useState<string | null>(null);

  useEffect(() => {
    fetchHotels();
  }, [filter]);

  const fetchHotels = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      console.log("🔑 Token:", token ? "présent" : "absent");
      console.log("🔍 Filtre:", filter);

      const res = await fetch(`/api/admin/hotels?status=${filter}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      console.log("📡 Status de la réponse:", res.status);

      if (res.ok) {
        const data = await res.json();
        console.log("✅ Données reçues:", data);
        setHotels(data.hotels);
      } else {
        const errorData = await res.json().catch(() => ({ message: "Erreur inconnue" }));
        console.error("❌ Erreur API:", res.status, errorData);
      }
    } catch (error) {
      console.error("❌ Erreur chargement hôtels:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async (hotelId: string) => {
    setActionLoading(hotelId);
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/hotels/${hotelId}/approve`, {
        method: "PATCH",
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        fetchHotels();
        alert("Hôtel approuvé avec succès !");
      } else {
        alert("Erreur lors de l'approbation");
      }
    } catch (error) {
      alert("Erreur réseau");
    } finally {
      setActionLoading(null);
    }
  };

  const handleReject = async (hotelId: string) => {
    const reason = prompt("Raison du refus (optionnel):");
    if (reason === null) return;

    setActionLoading(hotelId);
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/hotels/${hotelId}/reject`, {
        method: "PATCH",
        headers: { 
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}` 
        },
        body: JSON.stringify({ reason }),
      });

      if (res.ok) {
        fetchHotels();
        alert("Hôtel rejeté");
      } else {
        alert("Erreur lors du rejet");
      }
    } catch (error) {
      alert("Erreur réseau");
    } finally {
      setActionLoading(null);
    }
  };

  const getStatusBadge = (status: string) => {
    const styles = {
      PENDING: "bg-yellow-500/10 text-yellow-400 border-yellow-500/30",
      ACTIVE: "bg-green-500/10 text-green-400 border-green-500/30",
      INACTIVE: "bg-red-500/10 text-red-400 border-red-500/30",
    };
    return styles[status as keyof typeof styles] || "bg-gray-500/10 text-gray-400";
  };

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-white">Modération des Hôtels</h1>
        
        <div className="flex gap-2">
          {["PENDING", "ACTIVE", "INACTIVE", "all"].map((status) => (
            <button
              key={status}
              onClick={() => setFilter(status)}
              className={`px-4 py-2 rounded-xl text-sm transition-all ${
                filter === status
                  ? "bg-blue-600 text-white"
                  : "bg-slate-800 text-slate-300 hover:bg-slate-700"
              }`}
            >
              {status === "all" ? "Tous" : 
               status === "PENDING" ? "En attente" :
               status === "ACTIVE" ? "Approuvés" : "Rejetés"}
            </button>
          ))}
        </div>
      </div>

      {loading ? (
        <div className="text-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto"></div>
        </div>
      ) : (
        <div className="grid gap-4">
          {hotels.map((hotel) => (
            <div
              key={hotel.id}
              className="bg-slate-900/50 border border-slate-800 rounded-2xl p-6"
            >
              <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
                {/* Photo principale */}
                <div className="lg:col-span-1">
                  <div className="h-48 rounded-xl overflow-hidden bg-gradient-to-br from-blue-500/20 to-purple-500/20 flex items-center justify-center">
                    {hotel.photoUrl ? (
                      <img
                        src={hotel.photoUrl}
                        alt={hotel.name}
                        className="w-full h-full object-contain bg-slate-900"
                        onError={(e) => {
                          // Si l'image ne charge pas, afficher le placeholder
                          e.currentTarget.style.display = 'none';
                          e.currentTarget.nextElementSibling?.classList.remove('hidden');
                        }}
                      />
                    ) : null}
                    <div className={`text-center ${hotel.photoUrl ? 'hidden' : ''}`}>
                      <span className="text-4xl mb-2 block">🏨</span>
                      <p className="text-xs text-slate-400">Photo non disponible</p>
                      <p className="text-xs text-slate-500 mt-1">L'upload de photos sera disponible prochainement</p>
                    </div>
                  </div>
                </div>

                {/* Informations détaillées */}
                <div className="lg:col-span-2">
                  <div className="flex items-center gap-3 mb-4">
                    <h3 className="text-xl font-semibold text-white">{hotel.name}</h3>
                    <span className={`px-3 py-1 rounded-full text-xs border ${getStatusBadge(hotel.status)}`}>
                      {hotel.status}
                    </span>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-slate-300 mb-4">
                    <div>
                      <p><strong>🏙️ Ville:</strong> {hotel.city}, {hotel.country}</p>
                      <p><strong>📍 Adresse:</strong> {hotel.address}</p>
                      <p><strong>💰 Prix:</strong> {hotel.pricePerNight}€/nuit</p>
                      <p><strong>⭐ Note:</strong> {hotel.rating}/5</p>
                    </div>
                    <div>
                      <p><strong>📅 Créé le:</strong> {new Date(hotel.createdAt).toLocaleDateString()}</p>
                      <p><strong>🆔 ID:</strong> {hotel.id.slice(0, 8)}...</p>
                    </div>
                  </div>

                  {/* Description complète */}
                  {hotel.description && (
                    <div className="mb-4">
                      <h4 className="text-sm font-semibold text-white mb-2">📝 Description:</h4>
                      <div className="p-3 bg-slate-800/50 rounded-xl">
                        <p className="text-sm text-slate-300 leading-relaxed">
                          {hotel.description}
                        </p>
                      </div>
                    </div>
                  )}

                  {/* Raison de rejet si applicable */}
                  {hotel.rejectionReason && (
                    <div className="p-3 bg-red-900/20 border border-red-700/50 rounded-xl">
                      <p className="text-sm text-red-300">
                        <strong>❌ Raison du refus:</strong> {hotel.rejectionReason}
                      </p>
                    </div>
                  )}
                </div>

                {/* Actions */}
                <div className="lg:col-span-1 flex flex-col gap-3">
                  {hotel.status === "PENDING" && (
                    <>
                      <button
                        onClick={() => handleApprove(hotel.id)}
                        disabled={actionLoading === hotel.id}
                        className="w-full px-4 py-3 bg-green-600 hover:bg-green-700 text-white rounded-xl text-sm font-medium disabled:opacity-50 transition-colors flex items-center justify-center gap-2"
                      >
                        {actionLoading === hotel.id ? (
                          <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                        ) : (
                          <>✅ Approuver</>
                        )}
                      </button>
                      <button
                        onClick={() => handleReject(hotel.id)}
                        disabled={actionLoading === hotel.id}
                        className="w-full px-4 py-3 bg-red-600 hover:bg-red-700 text-white rounded-xl text-sm font-medium disabled:opacity-50 transition-colors flex items-center justify-center gap-2"
                      >
                        {actionLoading === hotel.id ? (
                          <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                        ) : (
                          <>❌ Rejeter</>
                        )}
                      </button>
                    </>
                  )}
                  
                  {/* Bouton voir détails complets */}
                  <button
                    onClick={() => router.push(`/dashboard/hotels/${hotel.id}`)}
                    className="w-full px-4 py-2 border border-slate-600 hover:bg-slate-800 text-slate-300 rounded-xl text-sm transition-colors"
                  >
                    👁️ Voir détails
                  </button>
                </div>
              </div>
            </div>
          ))}

          {hotels.length === 0 && (
            <div className="text-center py-12">
              <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-slate-800/60 mb-4">
                <span className="text-3xl">🏨</span>
              </div>
              <p className="text-slate-400 text-lg mb-2">
                {filter === "PENDING" 
                  ? "Aucun hôtel en attente de validation" 
                  : `Aucun hôtel ${filter.toLowerCase()}`}
              </p>
              <p className="text-slate-500 text-sm">
                Les nouveaux hôtels soumis apparaîtront ici
              </p>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
