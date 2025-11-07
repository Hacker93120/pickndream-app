"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

type AdminStats = {
  totalUsers: number;
  totalHotels: number;
  totalBookings: number;
  totalRevenue: number;
  recentBookings: number;
  activeHotels: number;
  pendingBookings: number;
  completedBookings: number;
};

export default function AdminDashboard() {
  const router = useRouter();
  const [stats, setStats] = useState<AdminStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAdminData();
  }, []);

  const fetchAdminData = async () => {
    try {
      const token = localStorage.getItem("pd_token");

      const statsRes = await fetch("/api/admin/stats", {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (statsRes.ok) {
        const statsData = await statsRes.json();
        setStats(statsData.stats);
      }
    } catch (error) {
      console.error("Erreur chargement données admin:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Tableau de Bord
            </h1>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="text-center py-12">
            <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-purple-500/20 mb-4 animate-pulse">
              <span className="text-2xl">👑</span>
            </div>
            <p className="text-sm opacity-60">Chargement des données admin...</p>
          </div>
        ) : (
          <>
            {/* Statistiques principales */}
            <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
              <AdminStatCard
                title="Utilisateurs Total"
                value={stats?.totalUsers || 0}
                icon="👥"
                color="from-blue-500 to-cyan-500"
                change="+12%"
              />
              <AdminStatCard
                title="Hôtels Actifs"
                value={stats?.activeHotels || 0}
                icon="🏨"
                color="from-green-500 to-emerald-500"
                change="+8%"
              />
              <AdminStatCard
                title="Réservations"
                value={stats?.totalBookings || 0}
                icon="📅"
                color="from-purple-500 to-violet-500"
                change="+25%"
              />
              <AdminStatCard
                title="Revenus"
                value={`${stats?.totalRevenue || 0}€`}
                icon="💰"
                color="from-yellow-500 to-orange-500"
                change="+18%"
              />
            </section>

            {/* Actions rapides */}
            <section className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
              <ActionCard
                title="Gestion Hôtels"
                description="Ajouter et gérer les hôtels"
                icon="🏨"
                color="bg-blue-600/20 border-blue-500/30 text-blue-300"
                onClick={() => router.push("/dashboard/hotels")}
              />
              <ActionCard
                title="Réservations"
                description="Valider les réservations"
                icon="📅"
                color="bg-green-600/20 border-green-500/30 text-green-300"
                onClick={() => router.push("/dashboard/bookings")}
              />
              <ActionCard
                title="Utilisateurs"
                description="Gérer les comptes utilisateurs"
                icon="👥"
                color="bg-purple-600/20 border-purple-500/30 text-purple-300"
                onClick={() => router.push("/dashboard/users")}
              />
              <ActionCard
                title="Statistiques"
                description="Voir les statistiques détaillées"
                icon="📊"
                color="bg-orange-600/20 border-orange-500/30 text-orange-300"
                onClick={() => router.push("/dashboard/stats")}
              />
            </section>

            {/* Métriques détaillées */}
            <section className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                  <span>📈</span>
                  Métriques de Performance
                </h3>
                <div className="space-y-4">
                  <MetricItem
                    label="Réservations récentes (7j)"
                    value={stats?.recentBookings || 0}
                  />
                  <MetricItem
                    label="Réservations en attente"
                    value={stats?.pendingBookings || 0}
                  />
                  <MetricItem
                    label="Réservations terminées"
                    value={stats?.completedBookings || 0}
                  />
                  <MetricItem
                    label="Taux de conversion"
                    value={
                      stats?.totalBookings && stats?.totalUsers
                        ? `${Math.round(
                            (stats.totalBookings / stats.totalUsers) * 100
                          )}%`
                        : "0%"
                    }
                  />
                </div>
              </div>

              <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                <h3 className="text-lg font-semibold mb-4 flex items-center gap-2">
                  <span>🎯</span>
                  Actions Rapides
                </h3>
                <div className="space-y-3">
                  <button
                    onClick={() => router.push("/dashboard/hotels")}
                    className="w-full px-4 py-3 rounded-xl bg-blue-600/20 border border-blue-500/30 text-blue-300 hover:bg-blue-600/30 transition-all duration-200 text-sm flex items-center gap-2"
                  >
                    <span>🏨</span>
                    Gérer les hôtels
                  </button>
                  <button
                    onClick={() => router.push("/dashboard/bookings")}
                    className="w-full px-4 py-3 rounded-xl bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 transition-all duration-200 text-sm flex items-center gap-2"
                  >
                    <span>📅</span>
                    Voir les réservations
                  </button>
                  <button
                    onClick={() => router.push("/dashboard/users")}
                    className="w-full px-4 py-3 rounded-xl bg-purple-600/20 border border-purple-500/30 text-purple-300 hover:bg-purple-600/30 transition-all duration-200 text-sm flex items-center gap-2"
                  >
                    <span>👥</span>
                    Gérer les utilisateurs
                  </button>
                  <button
                    onClick={fetchAdminData}
                    className="w-full px-4 py-3 rounded-xl bg-orange-600/20 border border-orange-500/30 text-orange-300 hover:bg-orange-600/30 transition-all duration-200 text-sm flex items-center gap-2"
                  >
                    <span>🔄</span>
                    Actualiser les données
                  </button>
                </div>
              </div>
            </section>
          </>
        )}
      </main>
    </div>
  );
}

function AdminStatCard({
  title,
  value,
  icon,
  color,
  change,
}: {
  title: string;
  value: string | number;
  icon: string;
  color: string;
  change: string;
}) {
  return (
    <div className="group rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 hover:border-purple-500/40 transition-all duration-300">
      <div className="flex items-center justify-between mb-4">
        <div
          className={`w-12 h-12 rounded-xl bg-gradient-to-r ${color} flex items-center justify-center`}
        >
          <span className="text-xl">{icon}</span>
        </div>
        <span className="text-xs text-green-400 bg-green-500/10 px-2 py-1 rounded-full">
          {change}
        </span>
      </div>
      <p className="text-xs uppercase tracking-wide opacity-60 mb-1">{title}</p>
      <p className="text-2xl font-bold">
        {typeof value === "number" ? value.toLocaleString() : value}
      </p>
    </div>
  );
}

function ActionCard({
  title,
  description,
  icon,
  color,
  onClick,
}: {
  title: string;
  description: string;
  icon: string;
  color: string;
  onClick?: () => void;
}) {
  return (
    <div
      onClick={onClick}
      className={`rounded-2xl border p-4 hover:scale-105 transition-all duration-200 cursor-pointer ${color}`}
    >
      <div className="flex items-center gap-3 mb-2">
        <span className="text-2xl">{icon}</span>
        <h3 className="font-semibold">{title}</h3>
      </div>
      <p className="text-xs opacity-70">{description}</p>
    </div>
  );
}

function MetricItem({ label, value }: { label: string; value: string | number }) {
  return (
    <div className="flex items-center justify-between p-3 rounded-xl bg-slate-800/40 border border-slate-700/40">
      <p className="text-sm opacity-70">{label}</p>
      <p className="font-semibold">{value}</p>
    </div>
  );
}
