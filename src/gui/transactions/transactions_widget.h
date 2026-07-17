#ifndef TRANSACTIONS_WIDGET_H
#define TRANSACTIONS_WIDGET_H

#include <QWidget>

namespace Ui {
class TransactionsWidget;
}

class TransactionsWidget : public QWidget {
    Q_OBJECT

public:
    explicit TransactionsWidget(QWidget *parent = nullptr);
    ~TransactionsWidget();

private:
    Ui::TransactionsWidget *ui;
    
    // Hàm tải dữ liệu vào bảng
    void loadTransactionsToTable();
};

#endif