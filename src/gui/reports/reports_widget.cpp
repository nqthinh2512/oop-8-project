#include "reports_widget.h"
#include <QLabel>
#include <QVBoxLayout>
ReportsWidget::ReportsWidget(QWidget *parent) : QWidget(parent) {
    QVBoxLayout *layout = new QVBoxLayout(this);
    QLabel *label = new QLabel("Trang 6: Báo Cáo & Phân Tích (Trống)", this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
}
ReportsWidget::~ReportsWidget() {}