"use client";

import { useEffect } from "react";

type ToastProps = {
  message: string;
  type: "success" | "error" | "info" | "warning";
  onClose: () => void;
  duration?: number;
};

export default function Toast({ message, type, onClose, duration = 3000 }: ToastProps) {
  useEffect(() => {
    const timer = setTimeout(() => {
      onClose();
    }, duration);

    return () => clearTimeout(timer);
  }, [duration, onClose]);

  const colors = {
    success: "bg-green-600 border-green-500",
    error: "bg-red-600 border-red-500",
    info: "bg-blue-600 border-blue-500",
    warning: "bg-yellow-600 border-yellow-500",
  };

  const icons = {
    success: "✅",
    error: "❌",
    info: "ℹ️",
    warning: "⚠️",
  };

  return (
    <div
      className={`fixed top-4 right-4 z-50 ${colors[type]} border-l-4 px-6 py-4 rounded-lg shadow-2xl backdrop-blur-sm animate-slideIn`}
    >
      <div className="flex items-center gap-3">
        <span className="text-2xl">{icons[type]}</span>
        <p className="text-white font-medium">{message}</p>
        <button
          onClick={onClose}
          className="ml-4 text-white hover:text-gray-200 transition-colors"
        >
          ✕
        </button>
      </div>
    </div>
  );
}
