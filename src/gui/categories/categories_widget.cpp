#include "categories_widget.h"
#include "ui_categories_widget.h"
#include "add_category_dialog.h"
#include <QMessageBox>
#include <QAbstractItemView>
#include <QHeaderView>

CategoriesWidget::CategoriesWidget(QWidget *parent) : QWidget(parent), ui(new Ui::CategoriesWidget) {
    ui->setupUi(this);

    ui->tableWidget->setColumnCount(3);
    ui->tableWidget->setHorizontalHeaderLabels({"ID", "Name", "Parent Category"});
    ui->tableWidget->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(1, QHeaderView::Stretch);
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(2, QHeaderView::ResizeToContents);

    connect(ui->pushButton, &QPushButton::clicked, this, &CategoriesWidget::onAddButtonClicked);
}

CategoriesWidget::~CategoriesWidget() {
    delete ui;
}

void CategoriesWidget::onAddButtonClicked() {
    AddCategoryDialog dialog(this);

    if (dialog.exec() == QDialog::Accepted) {
        emit addCategoryRequested(dialog.getCategoryName(), dialog.getParentId());
    }
}

void CategoriesWidget::displayCategories(const QVector<Category>& categories) {
    ui->tableWidget->setRowCount(categories.size());

    for (int row = 0; row < categories.size(); ++row) {
        const Category& cat = categories[row];

        ui->tableWidget->setItem(row, 0, new QTableWidgetItem(QString::number(cat.getId())));
        ui->tableWidget->setItem(row, 1, new QTableWidgetItem(cat.getName()));
        ui->tableWidget->setItem(row, 2, new QTableWidgetItem(Category::parentCategoryName(cat.getParentId())));
    }
}

void CategoriesWidget::showError(const QString &message) {
    QMessageBox::warning(this, "Invalid Input", message);
}