// database_manager.h
#ifndef DATABASE_MANAGER_H
#define DATABASE_MANAGER_H

#include <QObject>
#include <QVector>
#include <QString>
#include "../models/category.h" // File định nghĩa lớp Category của bạn
#include "../models/transaction.h" // Thêm thư viện giao dịch

class DatabaseManager : public QObject {
    Q_OBJECT

private:
    // Kho lưu trữ danh mục duy nhất trong RAM
    QVector<Category> m_categories;
    
    // Kho lưu trữ giao dịch (dùng con trỏ để hỗ trợ Đa hình - Polymorphism)
    // Ghi chú cho giáo viên: Sử dụng mảng con trỏ lớp cơ sở để chứa cả Income và Expense.
    QVector<Transaction*> m_transactions;

    // Hàm tiện ích nội bộ để tự tăng ID cho danh mục mới
    int generateNextCategoryId() const;

    // Singleton constructor & destructor
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager(); // Ghi đè để quản lý bộ nhớ (xóa con trỏ)

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
    
    // ==========================================================
    // 🎯 CÁC HÀM XỬ LÝ GIAO DỊCH (CRUD - OOP)
    // ==========================================================
    
    // Sinh ID mới cho Giao dịch (Public để Controller có thể gọi khi new đối tượng)
    int generateNextTransactionId() const;
    
    // Đọc và Ghi file CSV cho giao dịch
    void loadTransactionsFromCSV();
    void saveTransactionsToCSV() const;
    
    // API Read: Lấy danh sách giao dịch
    const QVector<Transaction*>& getAllTransactions() const { return m_transactions; }
    
    // API Create: Thêm giao dịch (Truyền con trỏ đa hình vào)
    void addTransaction(Transaction* newTransaction);
    
    // API Update: Cập nhật giao dịch bằng ID
    bool updateTransaction(int id, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account);
    
    // API Delete: Xóa giao dịch bằng ID
    bool deleteTransaction(int id);
};

#endif // DATABASE_MANAGER_H