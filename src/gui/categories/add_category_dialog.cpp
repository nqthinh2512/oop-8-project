#include "add_category_dialog.h"
#include "ui_add_category_dialog.h"
#include "../../backend/models/category.h"
#include <QPushButton>

AddCategoryDialog::AddCategoryDialog(QWidget *parent) : QDialog(parent), ui(new Ui::AddCategoryDialog) {
    ui->setupUi(this);
    this->setMinimumSize(480,270);
    ui->txtCategoryName->setPlaceholderText("e.g., Groceries, Rent, Salary...");

    for (int parentId = 1; parentId <= 5; ++parentId) {
        ui->comboBox->addItem(Category::parentCategoryName(parentId), parentId);
    }

    ui->buttonBox->button(QDialogButtonBox::Ok)->setText("Add");
}

AddCategoryDialog::~AddCategoryDialog() {
    delete ui;
}

QString AddCategoryDialog::getCategoryName() const {
    return ui->txtCategoryName->text();
}

int AddCategoryDialog::getParentId() const {
    return ui->comboBox->currentData().toInt();
}