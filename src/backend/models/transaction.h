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
    QString transactionType;// Loại giao dịch (Nạp/Rút/Chuyển)
    QString paymentMethod;  // Phương thức thanh toán (CreditCard, EWallet, BankTransfer)
    QString receiptImagePath; // Ảnh hóa đơn đính kèm
    QString status;         // Trạng thái (Thành công, Đang chờ, Đã hủy)

public:
    Transaction();
    Transaction(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0, const QString& n_txType="", const QString& n_payMethod="", const QString& n_receipt="", const QString& n_status="Thành công");
    virtual ~Transaction() = default; // Thêm virtual destructor cho đa hình an toàn

    //getter
    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    QString getNote() const {return note;}
    double getAmount() const {return amount;}
    QDateTime getDateTime() const {return dateTime;}
    QString getTransactionType() const {return transactionType;}
    QString getPaymentMethod() const {return paymentMethod;}
    QString getReceiptImagePath() const {return receiptImagePath;}
    QString getStatus() const {return status;}

    //setter, để tránh lỗi đè cùng ID, đừng viết hàm setId.
    void setAmount(double n_amount) { amount = n_amount; }
    void setCategoryId(int n_categoryid) { categoryId = n_categoryid; }
    void setNote(const QString& n_note) { note = n_note; }
    void setDateTime(const QDateTime& n_date) { dateTime = n_date; }
    void setTransactionType(const QString& n_type) { transactionType = n_type; }
    void setPaymentMethod(const QString& n_method) { paymentMethod = n_method; }
    void setReceiptImagePath(const QString& n_receipt) { receiptImagePath = n_receipt; }
    void setStatus(const QString& n_status) { status = n_status; }
};

//Class thu nhập
class Income : public Transaction{
private:
    QString payer; // Người/Tổ chức gửi tiền (Công ty FPT, Khách hàng...)

public:
    static const int parentCategory = 1; // Danh mục cha, tất cả categoryId của class này là con của danh mục này

    Income(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0, const QString& n_txType="", const QString& n_payMethod="", const QString& n_receipt="", const QString& n_status="Thành công", const QString& n_payer="");

    QString getPayer() const { return payer; }
    void setPayer(const QString& n_payer) { payer = n_payer; }
};

//class tiền tiêu
class Expense : public Transaction{
private:
    QString payee;       // Người nhận tiền (Chủ nhà trọ, Cô bán phở...)
    bool isEssential;    // Chi tiêu thiết yếu?

public:
    static const int parentCategory = 2; // Danh mục cha, tất cả categoryId của class này là con của danh mục này

    Expense(int n_id, double n_amount, const QDateTime& n_date=QDateTime::currentDateTime(), const QString& n_note="", int n_categoryid=0, const QString& n_txType="", const QString& n_payMethod="", const QString& n_receipt="", const QString& n_status="Thành công", const QString& n_payee="", bool n_isEssential=true);

    QString getPayee() const { return payee; }
    void setPayee(const QString& n_payee) { payee = n_payee; }
    bool getIsEssential() const { return isEssential; }
    void setIsEssential(bool n_isEssential) { isEssential = n_isEssential; }
};

#endif // TRANSACTION_H