"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useToast } from "@/hooks/useToast";

export default function NewHotelPage() {
  const router = useRouter();
  const { showToast, ToastContainer } = useToast();
  const [loading, setLoading] = useState(false);
  const [uploading, setUploading] = useState(false);

  const [formData, setFormData] = useState({
    name: "",
    description: "",
    city: "",
    address: "",
    country: "France",
    pricePerNight: "",
    photoUrl: "",
  });

  const handleInputChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);
    try {
      const token = localStorage.getItem("pd_token");
      const uploadFormData = new FormData();
      uploadFormData.append("file", file);

      const res = await fetch("/api/admin/upload", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
        },
        body: uploadFormData,
      });

      const data = await res.json();

      if (data.success) {
        setFormData((prev) => ({ ...prev, photoUrl: data.url }));
        showToast("Image uploadée avec succès", "success");
      } else {
        showToast("Erreur lors de l'upload", "error");
      }
    } catch (error) {
      showToast("Erreur lors de l'upload", "error");
    } finally {
      setUploading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.name || !formData.city || !formData.pricePerNight) {
      showToast("Veuillez remplir tous les champs requis", "warning");
      return;
    }

    setLoading(true);
    try {
      const token = localStorage.getItem("pd_token");
      const res = await fetch("/api/admin/hotels", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          ...formData,
          pricePerNight: parseInt(formData.pricePerNight),
        }),
      });

      const data = await res.json();

      if (data.success) {
        showToast("Hôtel créé avec succès", "success");
        setTimeout(() => {
          router.push("/dashboard/hotels");
        }, 1500);
      } else {
        showToast(data.message || "Erreur lors de la création", "error");
      }
    } catch (error) {
      showToast("Erreur serveur", "error");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen">
      <ToastContainer />

      {/* Header */}
      <header className="border-b border-slate-800/60 bg-slate-900/60 backdrop-blur-sm pt-16 lg:pt-0">
        <div className="px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <h1 className="text-lg font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              Créer un Nouvel Hôtel
            </h1>
            <button
              onClick={() => router.push("/dashboard/hotels")}
              className="px-4 py-2 rounded-lg border border-slate-700 text-sm hover:bg-slate-800 transition-all duration-200"
            >
              ← Retour
            </button>
          </div>
        </div>
      </header>

      {/* Formulaire */}
      <main className="px-4 sm:px-6 lg:px-8 py-8">
        <div className="max-w-3xl mx-auto">
          <form
            onSubmit={handleSubmit}
            className="rounded-2xl border border-slate-800/60 bg-slate-900/60 backdrop-blur-sm p-6 space-y-6"
          >
            {/* Image */}
            <div>
              <label className="block text-sm font-medium mb-2">
                Photo de l'hôtel
              </label>
              {formData.photoUrl ? (
                <div className="relative w-full h-64 rounded-xl overflow-hidden mb-4">
                  <img
                    src={formData.photoUrl}
                    alt="Preview"
                    className="w-full h-full object-cover"
                  />
                  <button
                    type="button"
                    onClick={() =>
                      setFormData((prev) => ({ ...prev, photoUrl: "" }))
                    }
                    className="absolute top-2 right-2 p-2 bg-red-600 rounded-lg hover:bg-red-500"
                  >
                    ✕
                  </button>
                </div>
              ) : (
                <label className="flex flex-col items-center justify-center w-full h-64 border-2 border-dashed border-slate-700 rounded-xl cursor-pointer hover:border-purple-500 transition-colors">
                  <div className="flex flex-col items-center justify-center pt-5 pb-6">
                    {uploading ? (
                      <div className="text-center">
                        <div className="animate-spin text-4xl mb-2">⏳</div>
                        <p className="text-sm opacity-60">Upload en cours...</p>
                      </div>
                    ) : (
                      <>
                        <span className="text-4xl mb-2">📷</span>
                        <p className="mb-2 text-sm opacity-60">
                          Cliquez pour uploader une image
                        </p>
                        <p className="text-xs opacity-40">PNG, JPG (MAX. 5MB)</p>
                      </>
                    )}
                  </div>
                  <input
                    type="file"
                    className="hidden"
                    accept="image/*"
                    onChange={handleImageUpload}
                    disabled={uploading}
                  />
                </label>
              )}
            </div>

            {/* Nom */}
            <div>
              <label className="block text-sm font-medium mb-2">
                Nom de l'hôtel *
              </label>
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                placeholder="Hotel Prestige Paris"
                required
              />
            </div>

            {/* Description */}
            <div>
              <label className="block text-sm font-medium mb-2">
                Description
              </label>
              <textarea
                name="description"
                value={formData.description}
                onChange={handleInputChange}
                rows={4}
                className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                placeholder="Description de l'hôtel..."
              />
            </div>

            {/* Ville et Pays */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-2">Ville *</label>
                <input
                  type="text"
                  name="city"
                  value={formData.city}
                  onChange={handleInputChange}
                  className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                  placeholder="Paris"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium mb-2">Pays</label>
                <input
                  type="text"
                  name="country"
                  value={formData.country}
                  onChange={handleInputChange}
                  className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                  placeholder="France"
                />
              </div>
            </div>

            {/* Adresse */}
            <div>
              <label className="block text-sm font-medium mb-2">Adresse</label>
              <input
                type="text"
                name="address"
                value={formData.address}
                onChange={handleInputChange}
                className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                placeholder="123 Rue de Rivoli"
              />
            </div>

            {/* Prix */}
            <div>
              <label className="block text-sm font-medium mb-2">
                Prix par nuit (€) *
              </label>
              <input
                type="number"
                name="pricePerNight"
                value={formData.pricePerNight}
                onChange={handleInputChange}
                className="w-full px-4 py-2 rounded-xl bg-slate-800 border border-slate-700 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                placeholder="150"
                min="0"
                required
              />
            </div>

            {/* Boutons */}
            <div className="flex gap-4">
              <button
                type="button"
                onClick={() => router.push("/dashboard/hotels")}
                className="flex-1 px-4 py-2 rounded-xl border border-slate-700 text-sm hover:bg-slate-800 transition-all duration-200"
              >
                Annuler
              </button>
              <button
                type="submit"
                disabled={loading || uploading}
                className="flex-1 px-4 py-2 rounded-xl bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
              >
                {loading ? "Création..." : "Créer l'hôtel"}
              </button>
            </div>
          </form>
        </div>
      </main>
    </div>
  );
}
