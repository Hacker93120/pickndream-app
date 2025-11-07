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

type BookingData = {
  id: string;
  totalPrice: number;
  status: string;
  createdAt: string;
};

export default function StatsPage() {
  const router = useRouter();
  const [stats, setStats] = useState<AdminStats | null>(null);
  const [bookings, setBookings] = useState<BookingData[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAllData();
  }, []);

  const fetchAllData = async () => {
    try {
      const token = localStorage.getItem("pd_token");

      const [statsRes, bookingsRes] = await Promise.all([
        fetch("/api/admin/stats", {
          headers: { Authorization: `Bearer ${token}` },
        }),
        fetch("/api/admin/bookings", {
          headers: { Authorization: `Bearer ${token}` },
        }),
      ]);

      if (statsRes.ok) {
        const statsData = await statsRes.json();
        setStats(statsData.stats);
      }

      if (bookingsRes.ok) {
        const bookingsData = await bookingsRes.json();
        setBookings(bookingsData.bookings);
      }
    } catch (error) {
      console.error("Erreur chargement données:", error);
    } finally {
      setLoading(false);
    }
  };

  // Calculer les revenus mensuels
  const getMonthlyRevenue = () => {
    const monthlyData: { [key: string]: number } = {};

    bookings.forEach((booking) => {
      if (booking.status === "COMPLETED" || booking.status === "CONFIRMED") {
        const date = new Date(booking.createdAt);
        const monthKey = `${date.getMonth() + 1}/${date.getFullYear()}`;
        monthlyData[monthKey] = (monthlyData[monthKey] || 0) + booking.totalPrice;
      }
    });

    return Object.entries(monthlyData)
      .sort((a, b) => {
        const [monthA, yearA] = a[0].split('/').map(Number);
        const [monthB, yearB] = b[0].split('/').map(Number);
        return yearA === yearB ? monthA - monthB : yearA - yearB;
      })
      .slice(-6);
  };

  const monthlyRevenue = getMonthlyRevenue();
  const maxRevenue = Math.max(...monthlyRevenue.map(([, value]) => value), 1);

  const getStatusDistribution = () => {
    const distribution = {
      PENDING: 0,
      CONFIRMED: 0,
      COMPLETED: 0,
      CANCELLED: 0,
    };

    bookings.forEach((booking) => {
      if (distribution[booking.status as keyof typeof distribution] !== undefined) {
        distribution[booking.status as keyof typeof distribution]++;
      }
    });

    return distribution;
  };

  const statusDistribution = getStatusDistribution();
  const totalDistribution = Object.values(statusDistribution).reduce((a, b) => a + b, 0);

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Statistiques Détaillées
            </h1>
            <button
              onClick={fetchAllData}
              className="px-4 py-2 rounded-lg bg-purple-600/20 border border-purple-500/30 text-purple-300 hover:bg-purple-600/30 text-sm transition-all duration-200 flex items-center gap-2"
            >
              <span>🔄</span>
              Actualiser
            </button>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-4 sm:px-6 lg:px-8 py-8">
        {loading ? (
          <div className="text-center py-12">
            <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-purple-500/20 mb-4 animate-pulse">
              <span className="text-2xl">📊</span>
            </div>
            <p className="text-sm opacity-60">Chargement des statistiques...</p>
          </div>
        ) : (
          <div className="space-y-8">
            {/* Vue d'ensemble */}
            <section>
              <h2 className="text-xl font-bold mb-4 flex items-center gap-2">
                <span>📈</span>
                Vue d'Ensemble
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <StatCard
                  label="Total Utilisateurs"
                  value={stats?.totalUsers || 0}
                  icon="👥"
                  color="bg-blue-500"
                />
                <StatCard
                  label="Total Hôtels"
                  value={stats?.totalHotels || 0}
                  icon="🏨"
                  color="bg-green-500"
                />
                <StatCard
                  label="Total Réservations"
                  value={stats?.totalBookings || 0}
                  icon="📅"
                  color="bg-purple-500"
                />
                <StatCard
                  label="Revenus Total"
                  value={`${stats?.totalRevenue || 0}€`}
                  icon="💰"
                  color="bg-yellow-500"
                />
              </div>
            </section>

            {/* Graphique des revenus mensuels */}
            <section>
              <h2 className="text-xl font-bold mb-4 flex items-center gap-2">
                <span>💹</span>
                Revenus Mensuels (6 derniers mois)
              </h2>
              <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                <div className="h-64 flex items-end justify-around gap-4">
                  {monthlyRevenue.length > 0 ? (
                    monthlyRevenue.map(([month, revenue]) => {
                      const heightPercent = (revenue / maxRevenue) * 100;
                      return (
                        <div key={month} className="flex-1 flex flex-col items-center gap-2">
                          <div className="text-xs font-semibold text-green-400">
                            {revenue}€
                          </div>
                          <div
                            className="w-full bg-gradient-to-t from-green-600 to-green-400 rounded-t-lg transition-all duration-500 hover:from-green-500 hover:to-green-300"
                            style={{ height: `${heightPercent}%` }}
                          ></div>
                          <div className="text-xs opacity-60">{month}</div>
                        </div>
                      );
                    })
                  ) : (
                    <p className="text-sm opacity-60">Aucune donnée disponible</p>
                  )}
                </div>
              </div>
            </section>

            {/* Distribution des statuts */}
            <section className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <div>
                <h2 className="text-xl font-bold mb-4 flex items-center gap-2">
                  <span>📊</span>
                  Distribution des Réservations
                </h2>
                <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                  <div className="space-y-4">
                    <StatusBar
                      label="En attente"
                      count={statusDistribution.PENDING}
                      total={totalDistribution}
                      color="bg-yellow-500"
                    />
                    <StatusBar
                      label="Confirmé"
                      count={statusDistribution.CONFIRMED}
                      total={totalDistribution}
                      color="bg-blue-500"
                    />
                    <StatusBar
                      label="Terminé"
                      count={statusDistribution.COMPLETED}
                      total={totalDistribution}
                      color="bg-green-500"
                    />
                    <StatusBar
                      label="Annulé"
                      count={statusDistribution.CANCELLED}
                      total={totalDistribution}
                      color="bg-red-500"
                    />
                  </div>
                </div>
              </div>

              {/* Métriques clés */}
              <div>
                <h2 className="text-xl font-bold mb-4 flex items-center gap-2">
                  <span>🎯</span>
                  Métriques Clés
                </h2>
                <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                  <div className="space-y-4">
                    <MetricRow
                      label="Taux de confirmation"
                      value={
                        totalDistribution > 0
                          ? `${Math.round(
                              ((statusDistribution.CONFIRMED + statusDistribution.COMPLETED) /
                                totalDistribution) *
                                100
                            )}%`
                          : "0%"
                      }
                    />
                    <MetricRow
                      label="Taux d'annulation"
                      value={
                        totalDistribution > 0
                          ? `${Math.round(
                              (statusDistribution.CANCELLED / totalDistribution) * 100
                            )}%`
                          : "0%"
                      }
                    />
                    <MetricRow
                      label="Revenu moyen/réservation"
                      value={
                        stats?.totalBookings
                          ? `${Math.round(stats.totalRevenue / stats.totalBookings)}€`
                          : "0€"
                      }
                    />
                    <MetricRow
                      label="Hôtels actifs"
                      value={`${stats?.activeHotels || 0} / ${stats?.totalHotels || 0}`}
                    />
                    <MetricRow
                      label="Utilisateurs actifs (avec réservations)"
                      value={
                        stats?.totalUsers && totalDistribution > 0
                          ? `${Math.round((totalDistribution / stats.totalUsers) * 100)}%`
                          : "0%"
                      }
                    />
                  </div>
                </div>
              </div>
            </section>

            {/* Activité récente */}
            <section>
              <h2 className="text-xl font-bold mb-4 flex items-center gap-2">
                <span>⚡</span>
                Activité Récente (7 derniers jours)
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm opacity-60">Nouvelles réservations</span>
                    <span className="text-2xl">📅</span>
                  </div>
                  <p className="text-3xl font-bold text-purple-400">
                    {stats?.recentBookings || 0}
                  </p>
                </div>
                <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm opacity-60">En attente</span>
                    <span className="text-2xl">⏳</span>
                  </div>
                  <p className="text-3xl font-bold text-yellow-400">
                    {stats?.pendingBookings || 0}
                  </p>
                </div>
                <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm opacity-60">Terminées</span>
                    <span className="text-2xl">✅</span>
                  </div>
                  <p className="text-3xl font-bold text-green-400">
                    {stats?.completedBookings || 0}
                  </p>
                </div>
              </div>
            </section>
          </div>
        )}
      </main>
    </div>
  );
}

function StatCard({
  label,
  value,
  icon,
  color,
}: {
  label: string;
  value: string | number;
  icon: string;
  color: string;
}) {
  return (
    <div className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-4 hover:border-purple-500/40 transition-all duration-300">
      <div className="flex items-center gap-3 mb-2">
        <div className={`w-10 h-10 rounded-lg ${color} flex items-center justify-center`}>
          <span className="text-lg">{icon}</span>
        </div>
        <div className="flex-1">
          <p className="text-xs opacity-60">{label}</p>
          <p className="text-xl font-bold">{value}</p>
        </div>
      </div>
    </div>
  );
}

function StatusBar({
  label,
  count,
  total,
  color,
}: {
  label: string;
  count: number;
  total: number;
  color: string;
}) {
  const percentage = total > 0 ? (count / total) * 100 : 0;

  return (
    <div>
      <div className="flex items-center justify-between mb-1">
        <span className="text-sm">{label}</span>
        <span className="text-sm font-semibold">
          {count} ({percentage.toFixed(1)}%)
        </span>
      </div>
      <div className="h-3 bg-slate-800 rounded-full overflow-hidden">
        <div
          className={`h-full ${color} transition-all duration-500`}
          style={{ width: `${percentage}%` }}
        ></div>
      </div>
    </div>
  );
}

function MetricRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center justify-between p-3 rounded-xl bg-slate-800/40 border border-slate-700/40">
      <span className="text-sm opacity-70">{label}</span>
      <span className="text-sm font-bold text-purple-400">{value}</span>
    </div>
  );
}
