#ifndef TRANSACTIONS_CONTROLLER_H
#define TRANSACTIONS_CONTROLLER_H

#include <QObject>
#include <QVector>
#include <QString>
#include <QDate>
#include "../../backend/models/transaction.h"
#include "../../backend/models/category.h"

// Controller đóng vai trò cầu nối giữa Giao diện (View) và Dữ liệu (Model/DatabaseManager)
// Thỏa mãn yêu cầu của Leader: "Frontend nên chỉ nhận dữ liệu nhập vào và gọi các hàm xử lý."
class TransactionsController : public QObject {
    Q_OBJECT
public:
    explicit TransactionsController(QObject *parent = nullptr);

    // Lấy toàn bộ giao dịch
    QVector<Transaction*> getAllTransactions() const;

    // Hàm lọc dữ liệu (Tìm kiếm, Category, Khoảng thời gian)
    // keyword: tìm trong description hoặc account
    // categoryId: truyền -1 nếu muốn lấy tất cả danh mục
    // startDate, endDate: truyền QDate() (invalid) nếu không muốn giới hạn
    QVector<Transaction*> getFilteredTransactions(const QString& keyword, int categoryId, const QDate& startDate, const QDate& endDate) const;

    // Các hàm bọc (Wrappers) gọi xuống DatabaseManager để CRUD
    void addTransaction(const QString& type, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account);
    bool updateTransaction(int id, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account);
    bool deleteTransaction(int id);
    
    // Lấy danh sách category để hiển thị trên ComboBox
    QVector<Category> getCategories() const;
    QString getCategoryName(int categoryId) const;
};

#endif // TRANSACTIONS_CONTROLLER_H