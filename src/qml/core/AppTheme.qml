pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool isDark: typeof settingsController !== "undefined" ? settingsController.theme === "Dark" : false

    property color bgApp: isDark ? "#0f172a" : "#f8fafc"
    property color bgCard: isDark ? "#1e293b" : "#ffffff"
    property color bgHover: isDark ? "#334155" : "#f1f5f9"
    property color bgInput: isDark ? "#0f172a" : "#f8fafc"

    property color textMain: isDark ? "#ffffff" : "#0f172a"
    property color textSub: isDark ? "#cbd5e1" : "#64748b"
    property color textMuted: isDark ? "#94a3b8" : "#94a3b8"

    property color border: isDark ? "#334155" : "#e2e8f0"
    property color divider: isDark ? "#1e293b" : "#cbd5e1"

    property color primary: isDark ? "#60a5fa" : "#2563eb"
    property color secondary: isDark ? "#34d399" : "#10b981"
    
    property color success: isDark ? "#34d399" : "#10b981"
    property color danger: isDark ? "#f87171" : "#ef4444"
    property color warning: isDark ? "#fbbf24" : "#f59e0b"
}


