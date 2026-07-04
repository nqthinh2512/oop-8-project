#include "bills_widget.h"
#include <QLabel>
#include <QVBoxLayout>
BillsWidget::BillsWidget(QWidget *parent) : QWidget(parent) {
    QVBoxLayout *layout = new QVBoxLayout(this);
    QLabel *label = new QLabel("Trang 3: Quản Lý Hóa Đơn (Trống)", this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
}
BillsWidget::~BillsWidget() {}