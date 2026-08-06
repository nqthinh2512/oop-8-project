pragma Singleton
import QtQuick

QtObject {
    id: root

    property bool isDark: typeof settingsController !== "undefined" ? settingsController.theme === "Dark" : false

    property color bgApp: isDark ? "#1E1F29" : "#f8fafc"
    property color bgCard: isDark ? "#2A2B36" : "#e6ffffff"
    property color bgHover: isDark ? "#3f3f46" : "#f1f5f9"
    property color bgInput: isDark ? "#1E1F29" : "#f8fafc"

    property color textMain: isDark ? "#e6ffffff" : "#0f172a"
    property color textSub: isDark ? "#94a3b8" : "#64748b"
    property color textMuted: isDark ? "#475569" : "#94a3b8"

    property color border: isDark ? "#3f3f46" : "#e2e8f0"
    property color divider: isDark ? "#334155" : "#cbd5e1"

    property color primary: isDark ? "#FD5EF3" : "#3b82f6"
    property color secondary: isDark ? "#4DD4FF" : "#10b981"
    
    property color success: isDark ? "#34c759" : "#10b981"
    property color danger: isDark ? "#ff383c" : "#ef4444"
    property color warning: isDark ? "#f8cb51" : "#f97316"
}
