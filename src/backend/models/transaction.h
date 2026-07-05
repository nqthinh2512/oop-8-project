#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QString>
#include <QDateTime>

class Transaction {
private:
    int id;                 // Mã định danh duy nhất
    double amount;          // Số tiền (Ví dụ: 50000)
    QString type;           // "THU_NHAP" hoặc "CHI_TIEU"
    QString categoryName;   // Danh mục (Ăn uống, Di chuyển...)
    QDateTime dateTime;     // Thời gian giao dịch
    QString note;           // Ghi chú (Ví dụ: "Mua cơm trưa")
public:
    Transaction();
    Transaction(int n_id, double n_amount, const QString& n_type, const QString& n_name, const QDateTime& n_date, const QString& n_note);
    //đừng viết trực tiếp logic cho các hàm ở đây, đi qua .cpp để viết đi.
};

#endif // TRANSACTION_H