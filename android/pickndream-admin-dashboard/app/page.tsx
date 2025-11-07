"use client";

import { FormEvent, useState } from "react";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const res = await fetch("/api/auth/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      });

      const data = await res.json();

      if (!res.ok || !data.success) {
        setError(data.message || "Erreur de connexion.");
        return;
      }

      // Vérifier que c'est un admin
      if (data.user.role !== "admin") {
        setError("Accès réservé aux administrateurs uniquement.");
        return;
      }

      localStorage.setItem("pd_user", JSON.stringify(data.user));
      localStorage.setItem("pd_token", data.token);

      router.push("/dashboard");
    } catch (err) {
      setError("Erreur serveur, réessayez.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-950 via-purple-950 to-slate-950 text-slate-50">
      <div className="w-full max-w-md bg-slate-900/70 border border-slate-700 rounded-2xl shadow-xl p-8 backdrop-blur">
        <div className="mb-6 text-center">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-r from-purple-500/20 to-pink-500/20 border border-purple-400/40 mb-4">
            <span className="text-3xl">👑</span>
          </div>
          <h1 className="text-2xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
            Admin Dashboard
          </h1>
          <p className="text-sm text-slate-300 mt-2">
            Accès réservé aux administrateurs PicknDream
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm mb-1">Email administrateur</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full rounded-xl bg-slate-800 border border-slate-600 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
              placeholder="admin@pickndream.fr"
              required
            />
          </div>

          <div>
            <label className="block text-sm mb-1">Mot de passe</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full rounded-xl bg-slate-800 border border-slate-600 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
              placeholder="••••••••"
              required
            />
          </div>

          {error && (
            <p className="text-sm text-red-400 bg-red-900/30 border border-red-700 rounded-lg px-3 py-2">
              {error}
            </p>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 px-4 py-2.5 text-sm font-medium shadow-lg disabled:opacity-60 disabled:cursor-not-allowed transition-all duration-200"
          >
            {loading ? "Connexion..." : "Accéder au dashboard"}
          </button>
        </form>

        <div className="mt-6 text-center">
          <p className="text-xs text-slate-400">
            Seuls les comptes administrateurs peuvent accéder à cette interface
          </p>
        </div>
      </div>
    </div>
  );
}
