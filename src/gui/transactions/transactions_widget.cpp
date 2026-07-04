#include "transactions_widget.h"
#include <QLabel>
#include <QVBoxLayout>
TransactionsWidget::TransactionsWidget(QWidget *parent) : QWidget(parent) {
    QVBoxLayout *layout = new QVBoxLayout(this);
    QLabel *label = new QLabel("Trang 2: Lịch Sử Giao Dịch (Trống)", this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
}
TransactionsWidget::~TransactionsWidget() {}