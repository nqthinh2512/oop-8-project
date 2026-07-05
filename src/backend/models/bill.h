#ifndef BILL_H
#define BILL_H

#include <QString>
#include <QDate>

class Bill {
private:
    int id;
    QString billName;       // Tên hóa đơn (Tiền điện, Tiền nước...)
    double amount;          // Số tiền cần đóng
    QDate dueDate;          // Hạn chót thanh toán
    bool isPaid;           // Trạng thái: true (đã đóng) / false (chưa đóng)
public:
    Bill();
    Bill(int n_id, const QString &n_billName, double n_amount, const QDate &n_dueDate, bool n_isPaid);
    //đừng viết trực tiếp logic cho các hàm ở đây, đi qua .cpp để viết đi.
};

#endif // BILL_H