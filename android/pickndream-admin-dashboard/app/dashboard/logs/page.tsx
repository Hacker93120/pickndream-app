"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Pagination from "@/components/Pagination";
import { exportToCSV } from "@/utils/exportCSV";

type Log = {
  id: string;
  action: string;
  user: string;
  details: string;
  timestamp: string;
  type: "CREATE" | "UPDATE" | "DELETE" | "LOGIN" | "LOGOUT";
};

export default function LogsManagement() {
  const router = useRouter();
  const [logs, setLogs] = useState<Log[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("");
  const [typeFilter, setTypeFilter] = useState("ALL");
  const [currentPage, setCurrentPage] = useState(1);
  const logsPerPage = 20;

  useEffect(() => {
    fetchLogs();
  }, []);

  const fetchLogs = async () => {
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/logs", {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (res.ok) {
        const data = await res.json();
        setLogs(data.logs);
      }
    } catch (error) {
      console.error("Erreur chargement logs:", error);
    } finally {
      setLoading(false);
    }
  };

  const filteredLogs = logs.filter((log) => {
    const matchesFilter =
      log.action.toLowerCase().includes(filter.toLowerCase()) ||
      log.user.toLowerCase().includes(filter.toLowerCase()) ||
      log.details.toLowerCase().includes(filter.toLowerCase());

    const matchesType = typeFilter === "ALL" || log.type === typeFilter;

    return matchesFilter && matchesType;
  });

  const totalPages = Math.ceil(filteredLogs.length / logsPerPage);
  const startIndex = (currentPage - 1) * logsPerPage;
  const paginatedLogs = filteredLogs.slice(startIndex, startIndex + logsPerPage);

  const handleExport = () => {
    const exportData = filteredLogs.map(log => ({
      Action: log.action,
      Utilisateur: log.user,
      Détails: log.details,
      Type: log.type,
      "Date et heure": new Date(log.timestamp).toLocaleString("fr-FR")
    }));
    exportToCSV(exportData, "logs_pickndream");
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case "CREATE":
        return "bg-green-500/20 text-green-300";
      case "UPDATE":
        return "bg-blue-500/20 text-blue-300";
      case "DELETE":
        return "bg-red-500/20 text-red-300";
      case "LOGIN":
        return "bg-purple-500/20 text-purple-300";
      case "LOGOUT":
        return "bg-gray-500/20 text-gray-300";
      default:
        return "bg-gray-500/20 text-gray-300";
    }
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case "CREATE":
        return "➕";
      case "UPDATE":
        return "✏️";
      case "DELETE":
        return "🗑️";
      case "LOGIN":
        return "🔓";
      case "LOGOUT":
        return "🔒";
      default:
        return "📝";
    }
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Historique et Logs
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
            placeholder="Rechercher dans les logs..."
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="flex-1 max-w-md px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
          />
          <select
            value={typeFilter}
            onChange={(e) => setTypeFilter(e.target.value)}
            className="px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
          >
            <option value="ALL">Tous les types</option>
            <option value="CREATE">Création</option>
            <option value="UPDATE">Modification</option>
            <option value="DELETE">Suppression</option>
            <option value="LOGIN">Connexion</option>
            <option value="LOGOUT">Déconnexion</option>
          </select>
          <button
            onClick={handleExport}
            className="px-4 py-2 rounded-xl bg-green-600/20 border border-green-500/30 text-green-300 hover:bg-green-600/30 text-sm transition-all duration-200 flex items-center gap-2"
          >
            <span>📊</span>
            Exporter CSV
          </button>
        </div>

        {/* Liste des logs */}
        {loading ? (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Chargement...</p>
          </div>
        ) : (
          <div className="space-y-2">
            {paginatedLogs.map((log) => (
              <div
                key={log.id}
                className="rounded-xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-4 hover:border-purple-500/40 transition-all duration-300"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4 flex-1">
                    <span className="text-2xl">{getTypeIcon(log.type)}</span>
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-1">
                        <h3 className="font-semibold text-sm">{log.action}</h3>
                        <span className={`text-xs px-2 py-1 rounded-full ${getTypeColor(log.type)}`}>
                          {log.type}
                        </span>
                      </div>
                      <p className="text-sm opacity-60">{log.details}</p>
                      <p className="text-xs opacity-40">Par {log.user}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-xs opacity-60">
                      {new Date(log.timestamp).toLocaleDateString("fr-FR")}
                    </p>
                    <p className="text-xs opacity-40">
                      {new Date(log.timestamp).toLocaleTimeString("fr-FR")}
                    </p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {!loading && filteredLogs.length === 0 && (
          <div className="text-center py-12">
            <p className="text-sm opacity-60">Aucun log trouvé</p>
          </div>
        )}

        {!loading && filteredLogs.length > 0 && (
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
