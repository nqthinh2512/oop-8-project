#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QString>
#include <QDateTime>

// class transaction hiện là abstract class nên nó đang theo tính abstraction & đa hình (polymorphism)
class Transaction {
private:
    int id;                 // Mã định danh duy nhất
    QString title;          // Tên/tiêu đề giao dịch (Ví dụ: "Mua cơm trưa")
    double amount;          // Số tiền (Ví dụ: 50000)
    int categoryId;         // Danh mục ID (Ăn uống, Di chuyển...)
    QDateTime dateTime;     // Thời gian giao dịch
    QString method;         // Phương thức thanh toán (Ví dụ: "Cash", "Bank Transfer")
    
    int linkedBillId;       // Link to Bill (mặc định -1 nếu không có)
    int linkedSavingId;     // Link to Saving (mặc định -1 nếu không có)
    int linkedBudgetId;     // Link to Budget (mặc định -1 nếu không có)

public:
    Transaction();
    Transaction(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_method="", int n_categoryid=0, int n_linkedBillId=-1, int n_linkedSavingId=-1, int n_linkedBudgetId=-1);
    virtual ~Transaction() = default;

    // Getters
    int getId() const { return id; }
    QString getTitle() const { return title; }
    int getCategoryId() const { return categoryId; }
    QString getMethod() const { return method; }
    QString getNote() const { return title; }
    double getAmount() const { return amount; }
    QDateTime getDateTime() const { return dateTime; }
    int getLinkedBillId() const { return linkedBillId; }
    int getLinkedSavingId() const { return linkedSavingId; }
    int getLinkedBudgetId() const { return linkedBudgetId; }

    // Setters
    void setId(int newId) { id = newId; }
    void setTitle(const QString& n_title) { title = n_title; }
    void setCategoryId(int n_categoryId) { categoryId = n_categoryId; }
    void setMethod(const QString& n_method) { method = n_method; }
    void setNote(const QString& n_note) { title = n_note; }
    void setLinkedBillId(int id) { linkedBillId = id; }
    void setLinkedSavingId(int id) { linkedSavingId = id; }
    void setLinkedBudgetId(int id) { linkedBudgetId = id; }

    // cái virtual function này biến class thành abstract class nên.. đừng có xóa, thanks.
    // đồng thời thỏa mãn cái requierment polymorphism
    virtual double getSignedAmount() const = 0;
};

// Class Thu nhập (Income) kế thừa từ Transaction
class Income : public Transaction {
public:
    static const int parentCategory = 1; // 1 chỉ định danh mục Thu nhập

    Income(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_method="", int n_categoryid=0, int n_linkedBillId=-1, int n_linkedSavingId=-1, int n_linkedBudgetId=-1);

    // Ghi đè hàm ảo
    double getSignedAmount() const override;
};

// Class Tiền tiêu (Expense) kế thừa từ Transaction
class Expense : public Transaction {
public:
    static const int parentCategory = 2; // 2 chỉ định danh mục Chi tiêu

    Expense(int n_id, const QString& n_title, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_method="", int n_categoryid=0, int n_linkedBillId=-1, int n_linkedSavingId=-1, int n_linkedBudgetId=-1);

    // Ghi đè hàm ảo
    double getSignedAmount() const override;
};

#endif // TRANSACTION_H