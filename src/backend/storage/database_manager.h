// database_manager.h
#ifndef DATABASE_MANAGER_H
#define DATABASE_MANAGER_H

#include <QObject>
#include <QVector>
#include <QString>
#include "../models/category.h" // File định nghĩa lớp Category của bạn

class DatabaseManager : public QObject {
    Q_OBJECT

private:
    // Kho lưu trữ danh mục duy nhất trong RAM
    QVector<Category> m_categories;

    // Hàm tiện ích nội bộ để tự tăng ID cho danh mục mới
    int generateNextCategoryId() const;

    // Singleton constructor & destructor
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager() = default;

public:
    // Hàm lấy instance duy nhất để sử dụng toàn hệ thống
    static DatabaseManager& instance() {
        static DatabaseManager instance;
        return instance;
    }

    // Ngăn chặn sao chép dữ liệu database
    DatabaseManager(const DatabaseManager&) = delete;
    DatabaseManager& operator=(const DatabaseManager&) = delete;

    // ==========================================================
    // 🎯 CÁC HÀM XỬ LÝ DANH MỤC THUẦN TÚY
    // ==========================================================

    // Đọc và Ghi file CSV
    void loadCategoriesFromCSV();
    void saveCategoriesToCSV() const;

    // API lấy danh sách danh mục cấp cho giao diện UI hiển thị
    const QVector<Category>& getAllCategories() const { return m_categories; }

    // Hàm thêm danh mục tùy chỉnh từ Giao diện (UI truyền: Tên, và Root ID từ 1 đến 5)
    void addUserCustomCategory(const QString& name, int parentId);
};

#endif // DATABASE_MANAGER_H