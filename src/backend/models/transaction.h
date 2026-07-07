#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QString>
#include <QDateTime>

//chỉ sửa class này thôi nhưng tránh dùng class này, nhìn hai class ở dưới đi.
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
    //ngoại trừ hàm getter và setter thì các hàm khác không được viết logic của nó trực tiếp ở đây, đi qua .cpp để viết đi.

    //getter
    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    QString getNote() const {return note;}
    double getAmount() const {return amount;}
    QDateTime getDateTime() const {return dateTime;}

    //setter, để tránh lỗi đè cùng ID, đừng viết hàm setId.
};

//Class thu nhập
class Income : public Transaction{
public:
    static const int parentCategory = 1; // Danh mục cha, tất cả categoryId của class này là con của danh mục này
    // 1 sẽ là số chỉ định cho danh mục cha này

    Income(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0);
};

//class tiền tiêu
class Expense : public Transaction{
public:
    static const int parentCategory = 2; // Danh mục cha, tất cả categoryId của class này là con của danh mục này
    // 2 sẽ là số chỉ định cho danh mục cha này

    Expense(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0);
};

#endif // TRANSACTION_H