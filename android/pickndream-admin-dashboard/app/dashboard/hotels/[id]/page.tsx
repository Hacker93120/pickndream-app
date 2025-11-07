"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";

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
  createdAt: string;
  updatedAt: string;
};

type Booking = {
  id: string;
  checkIn: string;
  checkOut: string;
  totalPrice: number;
  status: string;
  createdAt: string;
  user_name: string;
  user_email: string;
};

export default function HotelDetail() {
  const router = useRouter();
  const params = useParams();
  const hotelId = params.id as string;

  const [hotel, setHotel] = useState<Hotel | null>(null);
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [editForm, setEditForm] = useState({
    name: "",
    description: "",
    city: "",
    address: "",
    country: "",
    rating: 0,
    pricePerNight: 0,
    photoUrl: "",
  });

  useEffect(() => {
    fetchHotelDetails();
  }, [hotelId]);

  const fetchHotelDetails = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/hotels/${hotelId}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setHotel(data.hotel);
        setBookings(data.bookings);
        setEditForm({
          name: data.hotel.name,
          description: data.hotel.description || "",
          city: data.hotel.city,
          address: data.hotel.address,
          country: data.hotel.country,
          rating: data.hotel.rating,
          pricePerNight: data.hotel.pricePerNight,
          photoUrl: data.hotel.photoUrl || "",
        });
      }
    } catch (error) {
      console.error("Erreur chargement hôtel:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateHotel = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/hotels/${hotelId}`, {
        method: "PATCH",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(editForm),
      });

      if (res.ok) {
        setIsEditing(false);
        fetchHotelDetails();
      }
    } catch (error) {
      console.error("Erreur mise à jour hôtel:", error);
    }
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);
    try {
      const token = localStorage.getItem("pd_token");
      const formData = new FormData();
      formData.append("file", file);

      const res = await fetch("/api/admin/upload", {
        method: "POST",
        headers: { Authorization: `Bearer ${token}` },
        body: formData,
      });

      if (res.ok) {
        const data = await res.json();
        setEditForm({ ...editForm, photoUrl: data.url });
      }
    } catch (error) {
      console.error("Erreur upload image:", error);
    } finally {
      setUploading(false);
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "PENDING":
        return "bg-yellow-500/20 text-yellow-300";
      case "CONFIRMED":
        return "bg-blue-500/20 text-blue-300";
      case "COMPLETED":
        return "bg-green-500/20 text-green-300";
      case "CANCELLED":
        return "bg-red-500/20 text-red-300";
      default:
        return "bg-gray-500/20 text-gray-300";
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-sm opacity-60">Chargement...</p>
      </div>
    );
  }

  if (!hotel) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-sm opacity-60">Hôtel non trouvé</p>
      </div>
    );
  }

  const totalRevenue = bookings
    .filter((b) => b.status === "COMPLETED" || b.status === "CONFIRMED")
    .reduce((sum, b) => sum + b.totalPrice, 0);

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-4">
              <button
                onClick={() => router.push("/dashboard/hotels")}
                className="px-3 py-1.5 rounded-lg border border-slate-700 text-sm hover:bg-slate-800 transition-all duration-200"
              >
                ← Retour
              </button>
              <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                Détails de l'hôtel
              </h1>
            </div>
            {!isEditing && (
              <button
                onClick={() => setIsEditing(true)}
                className="px-4 py-2 rounded-xl bg-purple-600/20 border border-purple-500/30 text-purple-300 hover:bg-purple-600/30 text-sm transition-all duration-200"
              >
                Modifier
              </button>
            )}
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-4 sm:px-6 lg:px-8 py-8">
        {/* Informations hôtel */}
        <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 mb-6">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
            <div>
              {isEditing ? (
                <div className="space-y-3">
                  <div>
                    <label className="block text-xs uppercase opacity-60 mb-2">
                      Nom de l'hôtel
                    </label>
                    <input
                      type="text"
                      value={editForm.name}
                      onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                      className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                    />
                  </div>
                  <div>
                    <label className="block text-xs uppercase opacity-60 mb-2">
                      Description
                    </label>
                    <textarea
                      value={editForm.description}
                      onChange={(e) => setEditForm({ ...editForm, description: e.target.value })}
                      rows={4}
                      className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs uppercase opacity-60 mb-2">
                        Ville
                      </label>
                      <input
                        type="text"
                        value={editForm.city}
                        onChange={(e) => setEditForm({ ...editForm, city: e.target.value })}
                        className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                      />
                    </div>
                    <div>
                      <label className="block text-xs uppercase opacity-60 mb-2">
                        Pays
                      </label>
                      <input
                        type="text"
                        value={editForm.country}
                        onChange={(e) => setEditForm({ ...editForm, country: e.target.value })}
                        className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                      />
                    </div>
                  </div>
                  <div>
                    <label className="block text-xs uppercase opacity-60 mb-2">
                      Adresse
                    </label>
                    <input
                      type="text"
                      value={editForm.address}
                      onChange={(e) => setEditForm({ ...editForm, address: e.target.value })}
                      className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs uppercase opacity-60 mb-2">
                        Prix/Nuit (€)
                      </label>
                      <input
                        type="number"
                        value={editForm.pricePerNight}
                        onChange={(e) => setEditForm({ ...editForm, pricePerNight: parseFloat(e.target.value) })}
                        className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                      />
                    </div>
                    <div>
                      <label className="block text-xs uppercase opacity-60 mb-2">
                        Note (0-5)
                      </label>
                      <input
                        type="number"
                        step="0.1"
                        min="0"
                        max="5"
                        value={editForm.rating}
                        onChange={(e) => setEditForm({ ...editForm, rating: parseFloat(e.target.value) })}
                        className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                      />
                    </div>
                  </div>
                  <div className="flex gap-2 mt-4">
                    <button
                      onClick={handleUpdateHotel}
                      className="px-4 py-2 rounded-xl bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 text-sm transition-all duration-200"
                    >
                      Enregistrer
                    </button>
                    <button
                      onClick={() => {
                        setIsEditing(false);
                        setEditForm({
                          name: hotel.name,
                          description: hotel.description || "",
                          city: hotel.city,
                          address: hotel.address,
                          country: hotel.country,
                          rating: hotel.rating,
                          pricePerNight: hotel.pricePerNight,
                          photoUrl: hotel.photoUrl || "",
                        });
                      }}
                      className="px-4 py-2 rounded-xl bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 text-sm transition-all duration-200"
                    >
                      Annuler
                    </button>
                  </div>
                </div>
              ) : (
                <>
                  <h2 className="text-2xl font-bold mb-2">{hotel.name}</h2>
                  <p className="text-sm opacity-60 mb-4">{hotel.description || "Pas de description"}</p>
                  <div className="space-y-2">
                    <p className="text-sm">
                      <span className="opacity-60">📍 </span>
                      {hotel.address}, {hotel.city}, {hotel.country}
                    </p>
                    <p className="text-sm">
                      <span className="opacity-60">⭐ </span>
                      Note: {hotel.rating.toFixed(1)}/5
                    </p>
                    <p className="text-sm">
                      <span className="opacity-60">💰 </span>
                      {hotel.pricePerNight}€ par nuit
                    </p>
                    <span
                      className={`inline-block text-xs px-3 py-1 rounded-full ${
                        hotel.status === "ACTIVE"
                          ? "bg-green-500/20 text-green-300"
                          : "bg-red-500/20 text-red-300"
                      }`}
                    >
                      {hotel.status}
                    </span>
                  </div>
                </>
              )}
            </div>

            <div>
              {isEditing ? (
                <div className="space-y-3">
                  <label className="block text-xs uppercase opacity-60 mb-2">
                    Image de l'hôtel
                  </label>
                  {editForm.photoUrl && (
                    <div className="w-full h-64 rounded-xl overflow-hidden mb-3">
                      <img
                        src={editForm.photoUrl}
                        alt="Aperçu"
                        className="w-full h-full object-cover"
                      />
                    </div>
                  )}
                  <input
                    type="file"
                    accept="image/*"
                    onChange={handleImageUpload}
                    disabled={uploading}
                    className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                  />
                  {uploading && (
                    <p className="text-xs text-purple-400">Upload en cours...</p>
                  )}
                </div>
              ) : (
                <div className="w-full h-64 rounded-xl bg-slate-800 overflow-hidden">
                  {hotel.photoUrl ? (
                    <img
                      src={hotel.photoUrl}
                      alt={hotel.name}
                      className="w-full h-full object-cover"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-6xl">
                      🏨
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4 pt-4 border-t border-slate-800">
            <div>
              <p className="text-xs uppercase opacity-60 mb-1">Réservations</p>
              <p className="text-2xl font-bold">{bookings.length}</p>
            </div>
            <div>
              <p className="text-xs uppercase opacity-60 mb-1">Revenu Total</p>
              <p className="text-2xl font-bold">{totalRevenue}€</p>
            </div>
            <div>
              <p className="text-xs uppercase opacity-60 mb-1">Créé le</p>
              <p className="text-sm font-semibold">
                {new Date(hotel.createdAt).toLocaleDateString("fr-FR", {
                  year: "numeric",
                  month: "long",
                  day: "numeric",
                })}
              </p>
            </div>
          </div>
        </div>

        {/* Réservations */}
        <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
          <h3 className="text-lg font-bold mb-4">
            Réservations ({bookings.length})
          </h3>

          {bookings.length === 0 ? (
            <p className="text-sm opacity-60 text-center py-8">
              Aucune réservation
            </p>
          ) : (
            <div className="space-y-3">
              {bookings.map((booking) => (
                <div
                  key={booking.id}
                  className="rounded-xl border border-slate-800 bg-slate-900/40 p-4 hover:border-purple-500/40 transition-all duration-300"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-2">
                        <h4 className="font-semibold">{booking.user_name}</h4>
                        <span className={`text-xs px-2 py-1 rounded-full ${getStatusColor(booking.status)}`}>
                          {booking.status}
                        </span>
                      </div>
                      <p className="text-sm opacity-60">📧 {booking.user_email}</p>
                      <p className="text-xs opacity-40">
                        📅 {new Date(booking.checkIn).toLocaleDateString()} → {new Date(booking.checkOut).toLocaleDateString()}
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Prix Total</p>
                      <p className="font-bold text-lg">{booking.totalPrice}€</p>
                      <p className="text-xs opacity-40">
                        {new Date(booking.createdAt).toLocaleDateString()}
                      </p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
