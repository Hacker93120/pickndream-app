"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Sidebar from "@/components/Sidebar";

type User = {
  email: string;
  name: string;
  role: "admin" | "user";
};

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const storedUser =
      typeof window !== "undefined" ? localStorage.getItem("pd_user") : null;
    if (!storedUser) {
      router.push("/");
      return;
    }

    const userData = JSON.parse(storedUser);
    if (userData.role !== "admin") {
      router.push("/");
      return;
    }

    setUser(userData);
    setLoading(false);
  }, [router]);

  const handleLogout = () => {
    localStorage.removeItem("pd_user");
    localStorage.removeItem("pd_token");
    router.push("/");
  };

  if (loading || !user) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-950 via-purple-950 to-slate-950 text-slate-50">
        <div className="text-center">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-purple-500/20 mb-4 animate-pulse">
            <span className="text-2xl">👑</span>
          </div>
          <p className="text-sm opacity-60">Chargement...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex bg-gradient-to-br from-slate-950 via-purple-950 to-slate-950 text-slate-50">
      <Sidebar user={user} onLogout={handleLogout} />
      <div className="flex-1 overflow-auto w-full lg:w-auto">{children}</div>
    </div>
  );
}
