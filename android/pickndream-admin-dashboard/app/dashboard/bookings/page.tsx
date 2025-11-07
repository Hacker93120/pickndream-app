"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Pagination from "@/components/Pagination";
import { exportToCSV } from "@/utils/exportCSV";

type Booking = {
  id: string;
  userId: string;
  hotelId: string;
  checkIn: string;
  checkOut: string;
  totalPrice: number;
  status: string;
  createdAt: string;
  user_name: string;
  user_email: string;
  hotel_name: string;
  hotel_city: string;
};

export default function BookingsManagement() {
  const router = useRouter();
  const [bookings, setBookings] = useState<Booking[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState("ALL");
  const [currentPage, setCurrentPage] = useState(1);
  const bookingsPerPage = 10;

  useEffect(() => {
    fetchBookings();
  }, []);

  const fetchBookings = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/bookings", {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setBookings(data.bookings);
      }
    } catch (error) {
      console.error("Erreur chargement réservations:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdateStatus = async (bookingId: string, newStatus: string) => {
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
        fetchBookings();
      }
    } catch (error) {
      console.error("Erreur mise à jour réservation:", error);
    }
  };

  const filteredBookings = bookings.filter((booking) => {
    const matchesFilter =
      booking.user_name.toLowerCase().includes(filter.toLowerCase()) ||
      booking.hotel_name.toLowerCase().includes(filter.toLowerCase()) ||
      booking.user_email.toLowerCase().includes(filter.toLowerCase());

    const matchesStatus = statusFilter === "ALL" || booking.status === statusFilter;

    return matchesFilter && matchesStatus;
  });

  const totalPages = Math.ceil(filteredBookings.length / bookingsPerPage);
  const startIndex = (currentPage - 1) * bookingsPerPage;
  const paginatedBookings = filteredBookings.slice(startIndex, startIndex + bookingsPerPage);

  const handleExport = () => {
    const exportData = filteredBookings.map(booking => ({
      Hôtel: booking.hotel_name,
      Ville: booking.hotel_city,
      Client: booking.user_name,
      Email: booking.user_email,
      "Date d'arrivée": new Date(booking.checkIn).toLocaleDateString(),
      "Date de départ": new Date(booking.checkOut).toLocaleDateString(),
      "Prix Total": booking.totalPrice,
      Statut: booking.status,
      "Date de réservation": new Date(booking.createdAt).toLocaleDateString()
    }));
    exportToCSV(exportData, "reservations_pickndream");
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

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Gestion des Réservations
            </h1>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-4 sm:px-6 lg:px-8 py-8">
        {/* Filtres et actions */}
        <div className="mb-6 flex items-center gap-4">
          <input
            type="text"
            placeholder="Rechercher par utilisateur ou hôtel..."
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="flex-1 max-w-md px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
          />
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
          >
            <option value="ALL">Tous les statuts</option>
            <option value="PENDING">En attente</option>
            <option value="CONFIRMED">Confirmé</option>
            <option value="COMPLETED">Terminé</option>
            <option value="CANCELLED">Annulé</option>
          </select>
          <button
            onClick={handleExport}
            className="px-4 py-2 rounded-xl bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 text-sm transition-all duration-200 flex items-center gap-2"
          >
            <span>📊</span>
            Exporter CSV
          </button>
        </div>

        {/* Liste des réservations */}
        {loading ? (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Chargement...</p>
          </div>
        ) : (
          <div className="grid gap-4">
            {paginatedBookings.map((booking) => (
              <div
                key={booking.id}
                onClick={() => router.push(`/dashboard/bookings/${booking.id}`)}
                className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 hover:border-purple-500/40 transition-all duration-300 cursor-pointer"
              >
                <div className="flex items-center justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-2">
                      <h3 className="font-semibold">{booking.hotel_name}</h3>
                      <span className={`text-xs px-2 py-1 rounded-full ${getStatusColor(booking.status)}`}>
                        {booking.status}
                      </span>
                    </div>
                    <p className="text-sm opacity-60">
                      📍 {booking.hotel_city}
                    </p>
                    <p className="text-sm opacity-60">
                      👤 {booking.user_name} ({booking.user_email})
                    </p>
                    <p className="text-xs opacity-40">
                      📅 {new Date(booking.checkIn).toLocaleDateString()} → {new Date(booking.checkOut).toLocaleDateString()}
                    </p>
                  </div>
                  <div className="flex items-center gap-4">
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Prix Total</p>
                      <p className="font-bold text-lg">{booking.totalPrice}€</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Réservé le</p>
                      <p className="text-sm">
                        {new Date(booking.createdAt).toLocaleDateString()}
                      </p>
                    </div>
                    {booking.status === "PENDING" && (
                      <div className="flex gap-2">
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            handleUpdateStatus(booking.id, "CONFIRMED");
                          }}
                          className="px-3 py-1.5 rounded-lg bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 text-sm transition-all duration-200"
                        >
                          Confirmer
                        </button>
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            handleUpdateStatus(booking.id, "CANCELLED");
                          }}
                          className="px-3 py-1.5 rounded-lg bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 text-sm transition-all duration-200"
                        >
                          Annuler
                        </button>
                      </div>
                    )}
                    {booking.status === "CONFIRMED" && (
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          handleUpdateStatus(booking.id, "COMPLETED");
                        }}
                        className="px-3 py-1.5 rounded-lg bg-blue-600/20 border border-blue-500/30 text-blue-300 hover:bg-blue-600/30 text-sm transition-all duration-200"
                      >
                        Terminer
                      </button>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {!loading && filteredBookings.length === 0 && (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Aucune réservation trouvée</p>
          </div>
        )}

        {!loading && filteredBookings.length > 0 && (
          <Pagination
            currentPage={currentPage}
            totalPages={totalPages}
            onPageChange={setCurrentPage}
          />
        )}
      </main>
    </div>
  );
}
