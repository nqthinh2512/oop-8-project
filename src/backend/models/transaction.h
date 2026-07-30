#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QString>
#include <QDateTime>

// class transaction hiện là abstract class nên nó đang theo tính abstraction & đa hình (polymorphism)
class Transaction {
private:
    int id;                 // Mã định danh duy nhất
    double amount;          // Số tiền (Ví dụ: 50000)
    int categoryId;         // Danh mục ID (Ăn uống, Di chuyển...)
    QDateTime dateTime;     // Thời gian giao dịch
    QString note;           // Ghi chú (Ví dụ: "Mua cơm trưa")

public:
    Transaction();
    Transaction(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0);
    virtual ~Transaction() = default;

    // Getters
    int getId() const { return id; }
    int getCategoryId() const { return categoryId; }
    QString getNote() const { return note; }
    double getAmount() const { return amount; }
    QDateTime getDateTime() const { return dateTime; }

    // cái virtual function này biến class thành abstract class nên.. đừng có xóa, thanks.
    // đồng thời thỏa mãn cái requierment polymorphism
    virtual double getSignedAmount() const = 0;
};

// Class Thu nhập (Income) kế thừa từ Transaction
class Income : public Transaction {
public:
    static const int parentCategory = 1; // 1 chỉ định danh mục Thu nhập

    Income(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0);

    // Ghi đè hàm ảo
    double getSignedAmount() const override;
};

// Class Tiền tiêu (Expense) kế thừa từ Transaction
class Expense : public Transaction {
public:
    static const int parentCategory = 2; // 2 chỉ định danh mục Chi tiêu

    Expense(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0);

    // Ghi đè hàm ảo
    double getSignedAmount() const override;
};

#endif // TRANSACTION_H