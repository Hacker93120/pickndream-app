"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";
import { ArrowLeft, MapPin, Star, Euro, Calendar, User, Mail } from "lucide-react";

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
  photoUrl: string | null;
  rejectionReason: string | null;
  createdAt: string;
  updatedAt: string;
};

export default function AdminHotelDetailPage() {
  const router = useRouter();
  const params = useParams();
  const [hotel, setHotel] = useState<Hotel | null>(null);
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(false);

  useEffect(() => {
    fetchHotel();
  }, [params.id]);

  const fetchHotel = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/hotels/${params.id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setHotel(data.hotel);
      } else {
        router.push("/dashboard/hotels");
      }
    } catch (error) {
      console.error("Erreur:", error);
      router.push("/dashboard/hotels");
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async () => {
    if (!hotel) return;
    setActionLoading(true);
    
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/hotels/${hotel.id}/approve`, {
        method: "PATCH",
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        alert("Hôtel approuvé avec succès !");
        fetchHotel(); // Rafraîchir
      } else {
        alert("Erreur lors de l'approbation");
      }
    } catch (error) {
      alert("Erreur réseau");
    } finally {
      setActionLoading(false);
    }
  };

  const handleReject = async () => {
    if (!hotel) return;
    const reason = prompt("Raison du refus (optionnel):");
    if (reason === null) return;

    setActionLoading(true);
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/hotels/${hotel.id}/reject`, {
        method: "PATCH",
        headers: { 
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}` 
        },
        body: JSON.stringify({ reason }),
      });

      if (res.ok) {
        alert("Hôtel rejeté");
        fetchHotel(); // Rafraîchir
      } else {
        alert("Erreur lors du rejet");
      }
    } catch (error) {
      alert("Erreur réseau");
    } finally {
      setActionLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-950 text-slate-100">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
      </div>
    );
  }

  if (!hotel) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-950 text-slate-100">
        <p>Hôtel non trouvé</p>
      </div>
    );
  }

  const getStatusBadge = (status: string) => {
    const styles = {
      PENDING: "bg-yellow-500/10 text-yellow-400 border-yellow-500/30",
      ACTIVE: "bg-green-500/10 text-green-400 border-green-500/30",
      INACTIVE: "bg-red-500/10 text-red-400 border-red-500/30",
    };
    return styles[status as keyof typeof styles] || "bg-gray-500/10 text-gray-400";
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 text-slate-50">
      <div className="max-w-6xl mx-auto p-6">
        {/* Header */}
        <div className="flex items-center gap-6 mb-8">
          <button
            onClick={() => router.push("/dashboard/hotels")}
            className="p-3 rounded-2xl border border-slate-700 bg-slate-800/50 hover:bg-slate-700/50 transition-all hover:scale-105"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div className="flex-1">
            <div className="flex items-center gap-4 mb-2">
              <h1 className="text-3xl font-bold">{hotel.name}</h1>
              <span className={`px-4 py-2 rounded-full text-sm border ${getStatusBadge(hotel.status)}`}>
                {hotel.status}
              </span>
            </div>
            <p className="text-sm opacity-60 flex items-center gap-2">
              <MapPin className="w-4 h-4" />
              {hotel.city}, {hotel.country}
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Image principale */}
          <div className="lg:col-span-2">
            <div className="h-96 rounded-3xl overflow-hidden bg-gradient-to-br from-blue-500/20 to-purple-500/20 flex items-center justify-center mb-6">
              {hotel.photoUrl ? (
                <img
                  src={hotel.photoUrl}
                  alt={hotel.name}
                  className="w-full h-full object-contain bg-slate-900"
                />
              ) : (
                <div className="text-center">
                  <span className="text-8xl mb-4 block">🏨</span>
                  <p className="text-slate-400">Aucune photo fournie</p>
                </div>
              )}
            </div>

            {/* Description */}
            <div className="bg-slate-900/50 border border-slate-800 rounded-3xl p-8">
              <h2 className="text-xl font-semibold mb-4 flex items-center gap-2">
                📝 Description de l'établissement
              </h2>
              {hotel.description ? (
                <p className="text-slate-300 leading-relaxed">{hotel.description}</p>
              ) : (
                <p className="text-slate-500 italic">Aucune description fournie par le propriétaire</p>
              )}
            </div>
          </div>

          {/* Informations et actions */}
          <div className="space-y-6">
            {/* Informations détaillées */}
            <div className="bg-slate-900/50 border border-slate-800 rounded-3xl p-6">
              <h3 className="text-lg font-semibold mb-4">📊 Informations</h3>
              <div className="space-y-3 text-sm">
                <div className="flex items-center gap-2">
                  <Euro className="w-4 h-4 text-green-400" />
                  <span className="font-medium">{hotel.pricePerNight}€</span>
                  <span className="text-slate-400">par nuit</span>
                </div>
                <div className="flex items-center gap-2">
                  <Star className="w-4 h-4 text-yellow-400" />
                  <span>{hotel.rating}/5</span>
                </div>
                <div className="flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-blue-400" />
                  <span>Créé le {new Date(hotel.createdAt).toLocaleDateString()}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-purple-400" />
                  <span>Modifié le {new Date(hotel.updatedAt).toLocaleDateString()}</span>
                </div>
              </div>
            </div>

            {/* Localisation */}
            <div className="bg-slate-900/50 border border-slate-800 rounded-3xl p-6">
              <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                <MapPin className="w-5 h-5 text-purple-400" />
                Localisation
              </h3>
              <div className="space-y-2 text-sm">
                <p><strong>Adresse:</strong> {hotel.address}</p>
                <p><strong>Ville:</strong> {hotel.city}</p>
                <p><strong>Pays:</strong> {hotel.country}</p>
              </div>
            </div>

            {/* Raison de rejet */}
            {hotel.rejectionReason && (
              <div className="bg-red-900/20 border border-red-700/50 rounded-3xl p-6">
                <h3 className="text-lg font-semibold mb-4 text-red-300">❌ Raison du refus</h3>
                <p className="text-sm text-red-200">{hotel.rejectionReason}</p>
              </div>
            )}

            {/* Actions admin */}
            {hotel.status === "PENDING" && (
              <div className="space-y-3">
                <button
                  onClick={handleApprove}
                  disabled={actionLoading}
                  className="w-full px-6 py-4 bg-green-600 hover:bg-green-700 text-white rounded-2xl font-medium disabled:opacity-50 transition-all hover:scale-[1.02] shadow-lg shadow-green-500/25"
                >
                  {actionLoading ? (
                    <div className="flex items-center justify-center gap-2">
                      <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                      Traitement...
                    </div>
                  ) : (
                    "✅ Approuver cet hôtel"
                  )}
                </button>
                <button
                  onClick={handleReject}
                  disabled={actionLoading}
                  className="w-full px-6 py-4 bg-red-600 hover:bg-red-700 text-white rounded-2xl font-medium disabled:opacity-50 transition-all hover:scale-[1.02] shadow-lg shadow-red-500/25"
                >
                  {actionLoading ? (
                    <div className="flex items-center justify-center gap-2">
                      <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                      Traitement...
                    </div>
                  ) : (
                    "❌ Rejeter cet hôtel"
                  )}
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
