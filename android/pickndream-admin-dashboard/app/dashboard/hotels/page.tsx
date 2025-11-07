"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Pagination from "@/components/Pagination";
import { exportToCSV } from "@/utils/exportCSV";

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
  bookings_count: number;
};

export default function HotelsManagement() {
  const router = useRouter();
  const [hotels, setHotels] = useState<Hotel[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const hotelsPerPage = 10;

  useEffect(() => {
    fetchHotels();
  }, []);

  const fetchHotels = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/hotels", {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setHotels(data.hotels);
      }
    } catch (error) {
      console.error("Erreur chargement hôtels:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleToggleStatus = async (hotelId: string, currentStatus: string) => {
    const newStatus = currentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE";

    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/hotels", {
        method: "PATCH",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ hotelId, status: newStatus }),
      });

      if (res.ok) {
        fetchHotels();
      }
    } catch (error) {
      console.error("Erreur mise à jour hôtel:", error);
    }
  };

  const handleDeleteHotel = async (hotelId: string) => {
    if (!confirm("Êtes-vous sûr de vouloir supprimer cet hôtel ?")) {
      return;
    }

    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/hotels", {
        method: "DELETE",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ hotelId }),
      });

      if (res.ok) {
        fetchHotels();
      }
    } catch (error) {
      console.error("Erreur suppression hôtel:", error);
    }
  };

  const filteredHotels = hotels.filter(
    (hotel) =>
      hotel.name.toLowerCase().includes(filter.toLowerCase()) ||
      hotel.city.toLowerCase().includes(filter.toLowerCase())
  );

  const totalPages = Math.ceil(filteredHotels.length / hotelsPerPage);
  const startIndex = (currentPage - 1) * hotelsPerPage;
  const paginatedHotels = filteredHotels.slice(startIndex, startIndex + hotelsPerPage);

  const handleExport = () => {
    const exportData = filteredHotels.map(hotel => ({
      Nom: hotel.name,
      Ville: hotel.city,
      Pays: hotel.country,
      Adresse: hotel.address,
      "Prix/Nuit": hotel.pricePerNight,
      Note: hotel.rating,
      Statut: hotel.status,
      Réservations: hotel.bookings_count,
      "Date de création": new Date(hotel.createdAt).toLocaleDateString()
    }));
    exportToCSV(exportData, "hotels_pickndream");
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Gestion des Hôtels
            </h1>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-4 sm:px-6 lg:px-8 py-8">
        {/* Barre de recherche et actions */}
        <div className="mb-6 flex items-center gap-4">
          <input
            type="text"
            placeholder="Rechercher par nom ou ville..."
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="flex-1 max-w-md px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
          />
          <button
            onClick={handleExport}
            className="px-4 py-2 rounded-xl bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 text-sm transition-all duration-200 flex items-center gap-2"
          >
            <span>📊</span>
            Exporter CSV
          </button>
          <button
            onClick={() => router.push("/dashboard/hotels/new")}
            className="px-4 py-2 rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 text-sm font-medium transition-all duration-200 flex items-center gap-2"
          >
            <span>➕</span>
            Créer un hôtel
          </button>
        </div>

        {/* Liste des hôtels */}
        {loading ? (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Chargement...</p>
          </div>
        ) : (
          <div className="grid gap-4">
            {paginatedHotels.map((hotel) => (
              <div
                key={hotel.id}
                onClick={() => router.push(`/dashboard/hotels/${hotel.id}`)}
                className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 hover:border-purple-500/40 transition-all duration-300 cursor-pointer"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4 flex-1">
                    <div className="w-16 h-16 rounded-xl bg-slate-800 overflow-hidden">
                      {hotel.photoUrl ? (
                        <img
                          src={hotel.photoUrl}
                          alt={hotel.name}
                          className="w-full h-full object-cover"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-2xl">
                          🏨
                        </div>
                      )}
                    </div>
                    <div className="flex-1">
                      <h3 className="font-semibold">{hotel.name}</h3>
                      <p className="text-sm opacity-60">
                        {hotel.city}, {hotel.country}
                      </p>
                      <p className="text-xs opacity-40">{hotel.address}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-4">
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Prix/Nuit</p>
                      <p className="font-bold">{hotel.pricePerNight}€</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Note</p>
                      <p className="font-bold">⭐ {hotel.rating.toFixed(1)}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Réservations</p>
                      <p className="font-bold">{hotel.bookings_count}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Statut</p>
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          handleToggleStatus(hotel.id, hotel.status);
                        }}
                        className={`text-xs px-2 py-1 rounded-full ${
                          hotel.status === "ACTIVE"
                            ? "bg-green-500/20 text-green-300"
                            : "bg-red-500/20 text-red-300"
                        }`}
                      >
                        {hotel.status}
                      </button>
                    </div>
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        handleDeleteHotel(hotel.id);
                      }}
                      className="px-3 py-1.5 rounded-lg bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 text-sm transition-all duration-200"
                    >
                      Supprimer
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {!loading && filteredHotels.length === 0 && (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Aucun hôtel trouvé</p>
          </div>
        )}

        {!loading && filteredHotels.length > 0 && (
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
