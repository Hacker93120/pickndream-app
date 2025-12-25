"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";

type BookingDetail = {
  id: string;
  userId: string;
  hotelId: string;
  checkIn: string;
  checkOut: string;
  totalPrice: number;
  status: string;
  createdAt: string;
  updatedAt: string;
  user_name: string;
  user_email: string;
  user_phone: string | null;
  hotel_name: string;
  hotel_city: string;
  hotel_address: string;
  hotel_country: string;
  hotel_photo: string | null;
};

export default function BookingDetail() {
  const router = useRouter();
  const params = useParams();
  const bookingId = params.id as string;

  const [booking, setBooking] = useState<BookingDetail | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchBookingDetails();
  }, [bookingId]);

  const fetchBookingDetails = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/bookings/${bookingId}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setBooking(data.booking);
      }
    } catch (error) {
      console.error("Erreur chargement réservation:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateStatus = async (newStatus: string) => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/bookings", {
        method: "PATCH",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ bookingId, status: newStatus }),
      });

      if (res.ok) {
        fetchBookingDetails();
      }
    } catch (error) {
      console.error("Erreur mise à jour réservation:", error);
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "PENDING":
        return "bg-yellow-500/20 text-yellow-300 border-yellow-500/30";
      case "CONFIRMED":
        return "bg-blue-500/20 text-blue-300 border-blue-500/30";
      case "COMPLETED":
        return "bg-green-500/20 text-green-300 border-green-500/30";
      case "CANCELLED":
        return "bg-red-500/20 text-red-300 border-red-500/30";
      default:
        return "bg-gray-500/20 text-gray-300 border-gray-500/30";
    }
  };

  const getStatusLabel = (status: string) => {
    switch (status) {
      case "PENDING":
        return "En attente";
      case "CONFIRMED":
        return "Confirmé";
      case "COMPLETED":
        return "Terminé";
      case "CANCELLED":
        return "Annulé";
      default:
        return status;
    }
  };

  const calculateNights = (checkIn: string, checkOut: string) => {
    const start = new Date(checkIn);
    const end = new Date(checkOut);
    const diffTime = Math.abs(end.getTime() - start.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-sm opacity-60">Chargement...</p>
      </div>
    );
  }

  if (!booking) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-sm opacity-60">Réservation non trouvée</p>
      </div>
    );
  }

  const nights = calculateNights(booking.checkIn, booking.checkOut);

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-4">
              <button
                onClick={() => router.push("/dashboard/bookings")}
                className="px-3 py-1.5 rounded-lg border border-slate-700 text-sm hover:bg-slate-800 transition-all duration-200"
              >
                ← Retour
              </button>
              <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                Détails de la réservation
              </h1>
            </div>
            <div className={`px-4 py-2 rounded-xl border text-sm font-medium ${getStatusColor(booking.status)}`}>
              {getStatusLabel(booking.status)}
            </div>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Informations de l'hôtel */}
          <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
            <h2 className="text-lg font-bold mb-4">Hôtel</h2>

            {booking.hotel_photo && (
              <div className="w-full h-48 rounded-xl overflow-hidden mb-4">
                <img
                  src={booking.hotel_photo}
                  alt={booking.hotel_name}
                  className="w-full h-full object-contain bg-slate-900"
                />
              </div>
            )}

            <div className="space-y-3">
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Nom</p>
                <p className="font-semibold text-lg">{booking.hotel_name}</p>
              </div>
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Adresse</p>
                <p className="text-sm">
                  {booking.hotel_address}<br />
                  {booking.hotel_city}, {booking.hotel_country}
                </p>
              </div>
              <button
                onClick={() => router.push(`/dashboard/hotels/${booking.hotelId}`)}
                className="w-full px-4 py-2 rounded-xl bg-purple-600/20 border border-purple-500/30 text-purple-300 hover:bg-purple-600/30 text-sm transition-all duration-200"
              >
                Voir les détails de l'hôtel
              </button>
            </div>
          </div>

          {/* Informations du client */}
          <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
            <h2 className="text-lg font-bold mb-4">Client</h2>

            <div className="flex items-center gap-4 mb-4">
              <div className="w-16 h-16 rounded-full bg-gradient-to-r from-purple-500 to-pink-500 flex items-center justify-center text-white font-bold text-2xl">
                {booking.user_name.charAt(0).toUpperCase()}
              </div>
              <div className="flex-1">
                <p className="font-semibold text-lg">{booking.user_name}</p>
                <p className="text-sm opacity-60">{booking.user_email}</p>
              </div>
            </div>

            <div className="space-y-3">
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Téléphone</p>
                <p className="text-sm">{booking.user_phone || "Non renseigné"}</p>
              </div>
              <button
                onClick={() => router.push(`/dashboard/users/${booking.userId}`)}
                className="w-full px-4 py-2 rounded-xl bg-purple-600/20 border border-purple-500/30 text-purple-300 hover:bg-purple-600/30 text-sm transition-all duration-200"
              >
                Voir le profil du client
              </button>
            </div>
          </div>

          {/* Détails de la réservation */}
          <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 lg:col-span-2">
            <h2 className="text-lg font-bold mb-4">Informations de réservation</h2>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Date d'arrivée</p>
                <p className="font-semibold text-lg">
                  {new Date(booking.checkIn).toLocaleDateString("fr-FR", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })}
                </p>
              </div>
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Date de départ</p>
                <p className="font-semibold text-lg">
                  {new Date(booking.checkOut).toLocaleDateString("fr-FR", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                  })}
                </p>
              </div>
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Nombre de nuits</p>
                <p className="font-semibold text-lg">{nights} nuit{nights > 1 ? "s" : ""}</p>
              </div>
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Prix total</p>
                <p className="font-bold text-2xl text-purple-400">{booking.totalPrice}€</p>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6 pt-6 border-t border-slate-800">
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Réservé le</p>
                <p className="text-sm">
                  {new Date(booking.createdAt).toLocaleDateString("fr-FR", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                    hour: "2-digit",
                    minute: "2-digit",
                  })}
                </p>
              </div>
              <div>
                <p className="text-xs uppercase opacity-60 mb-1">Dernière modification</p>
                <p className="text-sm">
                  {new Date(booking.updatedAt).toLocaleDateString("fr-FR", {
                    day: "numeric",
                    month: "long",
                    year: "numeric",
                    hour: "2-digit",
                    minute: "2-digit",
                  })}
                </p>
              </div>
            </div>

            {/* Actions sur le statut */}
            <div className="mt-6 pt-6 border-t border-slate-800">
              <p className="text-xs uppercase opacity-60 mb-3">Actions</p>
              <div className="flex flex-wrap gap-3">
                {booking.status === "PENDING" && (
                  <>
                    <button
                      onClick={() => handleUpdateStatus("CONFIRMED")}
                      className="px-4 py-2 rounded-xl bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 text-sm transition-all duration-200"
                    >
                      Confirmer la réservation
                    </button>
                    <button
                      onClick={() => handleUpdateStatus("CANCELLED")}
                      className="px-4 py-2 rounded-xl bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 text-sm transition-all duration-200"
                    >
                      Annuler la réservation
                    </button>
                  </>
                )}
                {booking.status === "CONFIRMED" && (
                  <>
                    <button
                      onClick={() => handleUpdateStatus("COMPLETED")}
                      className="px-4 py-2 rounded-xl bg-blue-600/20 border border-blue-500/30 text-blue-300 hover:bg-blue-600/30 text-sm transition-all duration-200"
                    >
                      Marquer comme terminé
                    </button>
                    <button
                      onClick={() => handleUpdateStatus("CANCELLED")}
                      className="px-4 py-2 rounded-xl bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 text-sm transition-all duration-200"
                    >
                      Annuler la réservation
                    </button>
                  </>
                )}
                {booking.status === "CANCELLED" && (
                  <p className="text-sm opacity-60">Cette réservation a été annulée</p>
                )}
                {booking.status === "COMPLETED" && (
                  <p className="text-sm opacity-60">Cette réservation est terminée</p>
                )}
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
