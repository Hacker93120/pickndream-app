"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Pagination from "@/components/Pagination";
import { exportToCSV } from "@/utils/exportCSV";

type User = {
  id: string;
  email: string;
  name: string;
  role: string;
  phone: string | null;
  photoUrl: string | null;
  createdAt: string;
  bookings_count: number;
};

export default function UsersManagement() {
  const router = useRouter();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const usersPerPage = 10;

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/users", {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setUsers(data.users);
      }
    } catch (error) {
      console.error("Erreur chargement utilisateurs:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteUser = async (userId: string) => {
    if (!confirm("Êtes-vous sûr de vouloir supprimer cet utilisateur ?")) {
      return;
    }

    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/users", {
        method: "DELETE",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ userId }),
      });

      if (res.ok) {
        fetchUsers();
      }
    } catch (error) {
      console.error("Erreur suppression utilisateur:", error);
    }
  };

  const filteredUsers = users.filter(
    (user) =>
      user.name.toLowerCase().includes(filter.toLowerCase()) ||
      user.email.toLowerCase().includes(filter.toLowerCase())
  );

  const totalPages = Math.ceil(filteredUsers.length / usersPerPage);
  const startIndex = (currentPage - 1) * usersPerPage;
  const paginatedUsers = filteredUsers.slice(startIndex, startIndex + usersPerPage);

  const handleExport = () => {
    const exportData = filteredUsers.map(user => ({
      Nom: user.name,
      Email: user.email,
      Téléphone: user.phone || "N/A",
      Rôle: user.role,
      Réservations: user.bookings_count,
      "Date d'inscription": new Date(user.createdAt).toLocaleDateString()
    }));
    exportToCSV(exportData, "utilisateurs_pickndream");
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Gestion des Utilisateurs
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
            placeholder="Rechercher par nom ou email..."
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
        </div>

        {/* Liste des utilisateurs */}
        {loading ? (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Chargement...</p>
          </div>
        ) : (
          <div className="grid gap-4">
            {paginatedUsers.map((user) => (
              <div
                key={user.id}
                onClick={() => router.push(`/dashboard/users/${user.id}`)}
                className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 hover:border-purple-500/40 transition-all duration-300 cursor-pointer"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 rounded-full bg-gradient-to-r from-purple-500 to-pink-500 flex items-center justify-center text-white font-bold">
                      {user.name.charAt(0).toUpperCase()}
                    </div>
                    <div>
                      <h3 className="font-semibold">{user.name}</h3>
                      <p className="text-sm opacity-60">{user.email}</p>
                      <p className="text-xs opacity-40">
                        {user.phone || "Pas de téléphone"}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center gap-4">
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Rôle</p>
                      <span
                        className={`text-xs px-2 py-1 rounded-full ${
                          user.role === "ADMIN"
                            ? "bg-purple-500/20 text-purple-300"
                            : "bg-blue-500/20 text-blue-300"
                        }`}
                      >
                        {user.role}
                      </span>
                    </div>
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Réservations</p>
                      <p className="font-bold">{user.bookings_count}</p>
                    </div>
                    <div className="text-right">
                      <p className="text-xs uppercase opacity-60">Inscrit le</p>
                      <p className="text-sm">
                        {new Date(user.createdAt).toLocaleDateString()}
                      </p>
                    </div>
                    {user.role !== "ADMIN" && (
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          handleDeleteUser(user.id);
                        }}
                        className="px-3 py-1.5 rounded-lg bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 text-sm transition-all duration-200"
                      >
                        Supprimer
                      </button>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {!loading && filteredUsers.length === 0 && (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Aucun utilisateur trouvé</p>
          </div>
        )}

        {!loading && filteredUsers.length > 0 && (
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
