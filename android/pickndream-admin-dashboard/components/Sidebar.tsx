"use client";

import { useRouter, usePathname } from "next/navigation";
import { useState, useEffect } from "react";

type SidebarProps = {
  user: {
    name: string;
    email: string;
    role: string;
  };
  onLogout: () => void;
};

export default function Sidebar({ user, onLogout }: SidebarProps) {
  const router = useRouter();
  const pathname = usePathname();
  const [collapsed, setCollapsed] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  // Fermer le menu mobile lors du changement de route
  useEffect(() => {
    setMobileOpen(false);
  }, [pathname]);

  const menuItems = [
    {
      icon: "📊",
      label: "Dashboard",
      path: "/dashboard",
    },
    {
      icon: "👥",
      label: "Utilisateurs",
      path: "/dashboard/users",
    },
    {
      icon: "🏨",
      label: "Hôtels",
      path: "/dashboard/hotels",
    },
    {
      icon: "📅",
      label: "Réservations",
      path: "/dashboard/bookings",
    },
    {
      icon: "📈",
      label: "Statistiques",
      path: "/dashboard/stats",
    },
    {
      icon: "📝",
      label: "Logs",
      path: "/dashboard/logs",
    },
  ];

  return (
    <>
      {/* Bouton hamburger mobile */}
      <button
        onClick={() => setMobileOpen(!mobileOpen)}
        className="lg:hidden fixed top-4 left-4 z-50 p-2 rounded-lg bg-slate-900/90 border border-slate-800/60 backdrop-blur-sm"
      >
        <svg
          className="w-6 h-6 text-white"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          {mobileOpen ? (
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M6 18L18 6M6 6l12 12"
            />
          ) : (
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M4 6h16M4 12h16M4 18h16"
            />
          )}
        </svg>
      </button>

      {/* Overlay mobile */}
      {mobileOpen && (
        <div
          className="lg:hidden fixed inset-0 bg-black/50 z-40"
          onClick={() => setMobileOpen(false)}
        />
      )}

      {/* Sidebar */}
      <div
        className={`${
          collapsed ? "w-20" : "w-64"
        } bg-slate-900/90 backdrop-blur-sm border-r border-slate-800/60 flex flex-col transition-all duration-300
        fixed lg:static inset-y-0 left-0 z-40
        ${mobileOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"}
        `}
      >
      {/* Header */}
      <div className="p-4 border-b border-slate-800/60">
        <div className="flex items-center justify-between">
          {!collapsed && (
            <div className="flex items-center gap-2">
              <span className="text-2xl">👑</span>
              <div>
                <h2 className="font-bold text-sm bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                  PicknDream
                </h2>
                <p className="text-xs opacity-60">Admin Panel</p>
              </div>
            </div>
          )}
          <button
            onClick={() => setCollapsed(!collapsed)}
            className="hidden lg:block p-1.5 rounded-lg hover:bg-slate-800 transition-all duration-200"
          >
            {collapsed ? "→" : "←"}
          </button>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-2">
        {menuItems.map((item) => {
          const isActive = pathname === item.path;
          return (
            <button
              key={item.path}
              onClick={() => router.push(item.path)}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 ${
                isActive
                  ? "bg-gradient-to-r from-purple-600/20 to-pink-600/20 border border-purple-500/40 text-purple-300"
                  : "hover:bg-slate-800/60 text-slate-300"
              }`}
            >
              <span className="text-xl">{item.icon}</span>
              {!collapsed && (
                <span className="text-sm font-medium">{item.label}</span>
              )}
            </button>
          );
        })}
      </nav>

      {/* User Info */}
      <div className="p-4 border-t border-slate-800/60">
        {!collapsed ? (
          <div className="mb-3">
            <div className="flex items-center gap-3 mb-3">
              <div className="w-10 h-10 rounded-full bg-gradient-to-r from-purple-500 to-pink-500 flex items-center justify-center text-white font-bold">
                {user.name.charAt(0).toUpperCase()}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium truncate">{user.name}</p>
                <p className="text-xs opacity-60 truncate">{user.email}</p>
              </div>
            </div>
            <button
              onClick={onLogout}
              className="w-full px-4 py-2 rounded-xl bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 text-sm transition-all duration-200 flex items-center justify-center gap-2"
            >
              <span>🚪</span>
              Déconnexion
            </button>
          </div>
        ) : (
          <button
            onClick={onLogout}
            className="w-full p-2 rounded-xl bg-red-600/20 border border-red-500/30 text-red-300 hover:bg-red-600/30 transition-all duration-200 flex items-center justify-center"
            title="Déconnexion"
          >
            <span className="text-xl">🚪</span>
          </button>
        )}
      </div>
    </div>
    </>
  );
}
