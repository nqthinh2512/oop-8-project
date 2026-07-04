#include "categories_widget.h"
#include <QLabel>
#include <QVBoxLayout>
CategoriesWidget::CategoriesWidget(QWidget *parent) : QWidget(parent) {
    QVBoxLayout *layout = new QVBoxLayout(this);
    QLabel *label = new QLabel("Trang 4: Quản Lý Danh Mục (Trống)", this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
}
CategoriesWidget::~CategoriesWidget() {}