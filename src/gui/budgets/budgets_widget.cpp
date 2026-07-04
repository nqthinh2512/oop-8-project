#include "budgets_widget.h"
#include <QLabel>
#include <QVBoxLayout>
BudgetsWidget::BudgetsWidget(QWidget *parent) : QWidget(parent) {
    QVBoxLayout *layout = new QVBoxLayout(this);
    QLabel *label = new QLabel("Trang 5: Tiết Kiệm & Ngân Sách (Trống)", this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
}
BudgetsWidget::~BudgetsWidget() {}