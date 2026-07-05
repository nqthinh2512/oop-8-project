#ifndef BILL_H
#define BILL_H

#include <QString>
#include <QDate>

struct Bill {
    int id;
    QString billName;       // Tên hóa đơn (Tiền điện, Tiền nước...)
    double amount;          // Số tiền cần đóng
    QDate dueDate;          // Hạn chót thanh toán
    bool isPaid;            // Trạng thái: true (đã đóng) / false (chưa đóng)
};

#endif // BILL_H