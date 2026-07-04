#include "overview_widget.h"
#include <QLabel>
#include <QVBoxLayout>
OverviewWidget::OverviewWidget(QWidget *parent) : QWidget(parent) {
    QVBoxLayout *layout = new QVBoxLayout(this);
    QLabel *label = new QLabel("Trang 1: Tổng Quan (Trống)", this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
}
OverviewWidget::~OverviewWidget() {}