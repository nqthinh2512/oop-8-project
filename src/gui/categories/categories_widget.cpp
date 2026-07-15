#include "categories_widget.h"
#include "ui_categories_widget.h"


CategoriesWidget::CategoriesWidget(QWidget *parent) : QWidget(parent), ui(new Ui::CategoriesWidget) {
    ui->setupUi(this);
    ui->txtCategoryName->setPlaceholderText("e.g., Groceries, Rent, Salary...");
}
CategoriesWidget::~CategoriesWidget() {
    delete ui;
}