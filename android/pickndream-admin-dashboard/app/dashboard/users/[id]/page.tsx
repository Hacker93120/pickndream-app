"use client";

import { useEffect, useState } from "react";
import { useRouter, useParams } from "next/navigation";

type User = {
  id: string;
  email: string;
  name: string;
  role: string;
  phone: string | null;
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
  hotel_name: string;
  hotel_city: string;
};

export default function UserDetail() {
  const router = useRouter();
  const params = useParams();
  const userId = params.id as string;

  const [user, setUser] = useState<User | null>(null);
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [loading, setLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [editForm, setEditForm] = useState({
    name: "",
    email: "",
    phone: "",
    role: "",
  });

  useEffect(() => {
    fetchUserDetails();
  }, [userId]);

  const fetchUserDetails = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/users/${userId}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setUser(data.user);
        setBookings(data.bookings);
        setEditForm({
          name: data.user.name,
          email: data.user.email,
          phone: data.user.phone || "",
          role: data.user.role,
        });
      }
    } catch (error) {
      console.error("Erreur chargement utilisateur:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateUser = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch(`/api/admin/users/${userId}`, {
        method: "PATCH",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(editForm),
      });

      if (res.ok) {
        setIsEditing(false);
        fetchUserDetails();
      }
    } catch (error) {
      console.error("Erreur mise à jour utilisateur:", error);
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

  if (!user) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-sm opacity-60">Utilisateur non trouvé</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-4">
              <button
                onClick={() => router.push("/dashboard/users")}
                className="px-3 py-1.5 rounded-lg border border-slate-700 text-sm hover:bg-slate-800 transition-all duration-200"
              >
                ← Retour
              </button>
              <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                Détails de l'utilisateur
              </h1>
            </div>
            {!isEditing && user.role !== "ADMIN" && (
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
        {/* Informations utilisateur */}
        <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 mb-6">
          <div className="flex items-center gap-6 mb-6">
            <div className="w-24 h-24 rounded-full bg-gradient-to-r from-purple-500 to-pink-500 flex items-center justify-center text-white font-bold text-3xl">
              {user.name.charAt(0).toUpperCase()}
            </div>
            <div className="flex-1">
              {isEditing ? (
                <div className="space-y-3">
                  <input
                    type="text"
                    value={editForm.name}
                    onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                    className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                    placeholder="Nom"
                  />
                  <input
                    type="email"
                    value={editForm.email}
                    onChange={(e) => setEditForm({ ...editForm, email: e.target.value })}
                    className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                    placeholder="Email"
                  />
                  <input
                    type="tel"
                    value={editForm.phone}
                    onChange={(e) => setEditForm({ ...editForm, phone: e.target.value })}
                    className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                    placeholder="Téléphone"
                  />
                  <select
                    value={editForm.role}
                    onChange={(e) => setEditForm({ ...editForm, role: e.target.value })}
                    className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                  >
                    <option value="USER">USER</option>
                    <option value="ADMIN">ADMIN</option>
                  </select>
                  <div className="flex gap-2">
                    <button
                      onClick={handleUpdateUser}
                      className="px-4 py-2 rounded-xl bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 text-sm transition-all duration-200"
                    >
                      Enregistrer
                    </button>
                    <button
                      onClick={() => {
                        setIsEditing(false);
                        setEditForm({
                          name: user.name,
                          email: user.email,
                          phone: user.phone || "",
                          role: user.role,
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
                  <h2 className="text-2xl font-bold mb-2">{user.name}</h2>
                  <p className="text-sm opacity-60 mb-1">{user.email}</p>
                  <p className="text-sm opacity-60 mb-2">{user.phone || "Pas de téléphone"}</p>
                  <span
                    className={`text-xs px-3 py-1 rounded-full ${
                      user.role === "ADMIN"
                        ? "bg-purple-500/20 text-purple-300"
                        : "bg-blue-500/20 text-blue-300"
                    }`}
                  >
                    {user.role}
                  </span>
                </>
              )}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4 pt-4 border-t border-slate-800">
            <div>
              <p className="text-xs uppercase opacity-60 mb-1">Inscrit le</p>
              <p className="text-sm font-semibold">
                {new Date(user.createdAt).toLocaleDateString("fr-FR", {
                  year: "numeric",
                  month: "long",
                  day: "numeric",
                })}
              </p>
            </div>
            <div>
              <p className="text-xs uppercase opacity-60 mb-1">Dernière modification</p>
              <p className="text-sm font-semibold">
                {new Date(user.updatedAt).toLocaleDateString("fr-FR", {
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
                        <h4 className="font-semibold">{booking.hotel_name}</h4>
                        <span className={`text-xs px-2 py-1 rounded-full ${getStatusColor(booking.status)}`}>
                          {booking.status}
                        </span>
                      </div>
                      <p className="text-sm opacity-60">📍 {booking.hotel_city}</p>
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
