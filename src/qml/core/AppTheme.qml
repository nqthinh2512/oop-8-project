pragma Singleton
import QtQuick

QtObject {
    id: root

    // Lắng nghe trạng thái từ SettingsController (nếu được đăng ký, nếu không mặc định false để an toàn trong Design mode)
    property bool isDark: typeof settingsController !== "undefined" ? settingsController.theme === "Dark" : false

    // ==========================================
    // 1. BACKGROUND COLORS (Nền)
    // ==========================================
    property color bgApp: isDark ? "#1E1F29" : AppTheme.bgApp         // Nền ứng dụng chính
    property color bgCard: isDark ? "#2A2B36" : AppTheme.bgCard        // Nền thẻ, bảng
    property color bgHover: isDark ? "#3f3f46" : AppTheme.bgHover       // Nền khi hover
    property color bgInput: isDark ? "#1E1F29" : AppTheme.bgApp       // Nền TextField

    // ==========================================
    // 2. TEXT COLORS (Chữ)
    // ==========================================
    property color textMain: isDark ? AppTheme.bgCard : AppTheme.textMain      // Tiêu đề, chữ chính
    property color textSub: isDark ? AppTheme.textMuted : AppTheme.textSub       // Chữ phụ, mô tả
    property color textMuted: isDark ? "#475569" : AppTheme.textMuted     // Chữ rất mờ

    // ==========================================
    // 3. BORDERS & DIVIDERS (Viền)
    // ==========================================
    property color border: isDark ? "#3f3f46" : AppTheme.border        // Đường viền thẻ
    property color divider: isDark ? "#334155" : AppTheme.divider       // Kẻ ngang phân cách

    // ==========================================
    // 4. ACCENT COLORS (Màu nhấn)
    // ==========================================
    // Dark mode sử dụng Neon Pink & Cyan. Light mode sử dụng Tailwind Blue.
    property color primary: isDark ? "#FD5EF3" : AppTheme.primary       // Nút bấm chính
    property color secondary: isDark ? "#4DD4FF" : AppTheme.success     // Màu hỗ trợ
    
    // Status (Trạng thái)
    property color success: isDark ? "#34c759" : AppTheme.success       // Tăng trưởng, hoàn thành
    property color danger: isDark ? "#ff383c" : AppTheme.danger        // Chi tiêu, xóa
    property color warning: isDark ? "#f8cb51" : AppTheme.warning       // Đang chờ, cảnh báo
}
