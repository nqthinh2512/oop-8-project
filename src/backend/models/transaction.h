#ifndef TRANSACTION_H
#define TRANSACTION_H

#include <QString>
#include <QDateTime>

struct Transaction {
    int id;                 // Mã định danh duy nhất
    double amount;          // Số tiền (Ví dụ: 50000)
    QString type;           // "THU_NHAP" hoặc "CHI_TIEU"
    QString categoryName;   // Danh mục (Ăn uống, Di chuyển...)
    QDateTime dateTime;     // Thời gian giao dịch
    QString note;           // Ghi chú (Ví dụ: "Mua cơm trưa")
};

#endif // TRANSACTION_H