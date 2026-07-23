#ifndef BILL_H
#define BILL_H

#include <QString>
#include <QDate>

enum class Test {
    One,
    Two,
    Three
};

class Bill {
private:
    int id;                 // ID, bất đầu từ 1.
    int categoryId;         // Danh mục ID, nhớ đây sẽ là danh mục con của parentCategory
    QString name;       // Tên hóa đơn (Tiền điện, Tiền nước...)
    double amount;          // Số tiền cần đóng
    QDate dueDate;          // Hạn chót thanh toán
    QDate paidDate;         // Ngày thanh toán
    bool isPaid;           // Trạng thái: true (đã đóng) / false (chưa đóng)
public:
    static const int parentCategory = 3; // Danh mục cha, tất cả categoryId của class này là con của danh mục này.
    // 3 sẽ là số chỉ định cho danh mục cha này

    Bill();
    Bill(int n_id, const QString &n_name, double n_amount, const QDate &n_dueDate, const QDate &n_paidDate=QDate(0,0,0), int n_categoryid=0, bool n_isPaid=false);
    // ngoại trừ hàm getter và setter thì các hàm khác không được viết logic của nó trực tiếp ở đây, đi qua .cpp để viết đi.

    // getter
    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    QString getName() const {return name;}
    double getAmount() const {return amount;}
    QDate getDueDate() const {return dueDate;}
    bool checkPaid() const {return isPaid;} //parentcategory mng có thể lấy trực tiếp được, không cần tới getter

    // setter, để tránh lỗi đè cùng ID, đừng viết hàm setId.

    void setCategoryId(int n_categoryId);
    void setName(const QString& n_name);
    void setAmount(double n_amount);
    void setDueDate(const QDate& n_dueDate);

    // nghiệp vụ - chi tiết trong bill.cpp
    void markAsPaid(QDate n_paidDate);
    int getDaysUntilDue();
    bool isOverdue();

};

#endif // BILL_H