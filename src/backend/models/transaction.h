#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QString>
#include <QDateTime>

// Lớp cơ sở (Base Class) trừu tượng cho tất cả giao dịch.
// Ghi chú cho giáo viên: Áp dụng tính trừu tượng (Abstraction) và tính kế thừa (Inheritance).
class Transaction {
protected: // Đổi thành protected để các lớp con (Income, Expense) có thể truy cập nếu cần thiết
    int id;                 // 1. Mã định danh duy nhất
    double amount;          // 3. Số tiền (Ví dụ: 50000)
    int categoryId;         // 5. Danh mục ID (Ăn uống, Di chuyển...)
    QDateTime dateTime;     // 4. Thời gian giao dịch (Đại diện cho Date)
    QString description;    // 6. Mô tả (Ghi chú chi tiết giao dịch)
    QString account;        // 7. Tài khoản (Ví dụ: "Tiền mặt", "Momo", "Ngân hàng")
    // Thuộc tính 2 (Type) sẽ được xử lý thông qua Đa hình (Polymorphism) bằng hàm ảo (virtual function)

public:
    Transaction();
    Transaction(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_desc="", int n_categoryid=0, const QString& n_account="");
    
    // Khai báo Destructor ảo (Virtual Destructor) - Rất quan trọng trong OOP C++
    // Để khi xóa con trỏ lớp cơ sở, nó sẽ gọi đúng destructor của lớp con.
    virtual ~Transaction() = default;

    // Hàm ảo thuần túy (Pure virtual function). 
    // Trả về "Income" hoặc "Expense". Điều này bắt buộc các lớp con phải ghi đè (override) hàm này.
    // Thể hiện tính đa hình (Polymorphism) trong OOP.
    virtual QString getType() const = 0; 

    // Các hàm Getters
    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    QString getDescription() const {return description;}
    double getAmount() const {return amount;}
    QDateTime getDateTime() const {return dateTime;}
    QString getAccount() const {return account;}

    // Các hàm Setters (Không viết setId để tránh đè ID)
    void setAmount(double newAmount) { amount = newAmount; }
    void setCategoryId(int newCategoryId) { categoryId = newCategoryId; }
    void setDateTime(const QDateTime& newDateTime) { dateTime = newDateTime; }
    void setDescription(const QString& newDescription) { description = newDescription; }
    void setAccount(const QString& newAccount) { account = newAccount; }
};

// Lớp thu nhập (Income) kế thừa (Inherits) từ Transaction
class Income : public Transaction{
public:
    static const int parentCategory = 1; // Danh mục cha, tất cả categoryId của class này là con của danh mục này

    Income(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_desc="", int n_categoryid=0, const QString& n_account="");
    
    // Ghi đè (Override) hàm của lớp cha để trả về Type
    QString getType() const override { return "Income"; }
};

// Lớp chi tiêu (Expense) kế thừa (Inherits) từ Transaction
class Expense : public Transaction{
public:
    static const int parentCategory = 2; // Danh mục cha, tất cả categoryId của class này là con của danh mục này

    Expense(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_desc="", int n_categoryid=0, const QString& n_account="");
    
    // Ghi đè (Override) hàm của lớp cha để trả về Type
    QString getType() const override { return "Expense"; }
};

#endif // TRANSACTION_H