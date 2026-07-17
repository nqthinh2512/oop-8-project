#include "categories_widget.h"
#include "ui_categories_widget.h"
#include "add_category_dialog.h"
#include "category_remove_button.h"
#include <QMessageBox>
#include <QAbstractItemView>
#include <QHeaderView>

CategoriesWidget::CategoriesWidget(QWidget *parent) : QWidget(parent), ui(new Ui::CategoriesWidget) {
    ui->setupUi(this);

    ui->tableWidget->setColumnCount(4);
    ui->searchLineEdit->setPlaceholderText("Search by name...");
    ui->tableWidget->setHorizontalHeaderLabels({"ID", "Name", "Parent Category", "Actions"});
    ui->tableWidget->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableWidget->verticalHeader()->setVisible(false);
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(1, QHeaderView::Stretch);
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(2, QHeaderView::ResizeToContents);
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(3, QHeaderView::ResizeToContents);

    ui->tableWidget->setStyleSheet(
        "QTableView{"
        "   font-size: 14px;"
        "}"
        );

    ui->pushButton->setStyleSheet(
        "QPushButton {"
        "   background-color: #f5f5f5;"
        "   border: 1px solid #cccccc;"
        "   border-radius: 4px;"
        "   padding: 4px 10px;"
        "}"
        "QPushButton:hover {"
        "   background-color: #19c902;"
        "   color: white;"
        "}"
        );

    ui->filterComboBox->addItem("All Categories", 0);
    for (int parentId = 1; parentId <= 5; ++parentId) {
        ui->filterComboBox->addItem(Category::parentCategoryName(parentId), parentId);
    }

    connect(ui->filterComboBox, &QComboBox::currentIndexChanged, this, &CategoriesWidget::onFilterChanged);
    connect(ui->pushButton, &QPushButton::clicked, this, &CategoriesWidget::onAddButtonClicked);
    connect(ui->searchLineEdit, &QLineEdit::textChanged, this, &CategoriesWidget::searchTextChanged);
}

CategoriesWidget::~CategoriesWidget() {
    delete ui;
}

void CategoriesWidget::onAddButtonClicked() {
    AddCategoryDialog dialog(this);

    if (dialog.exec() == QDialog::Accepted) {
        ui->filterComboBox->setCurrentIndex(0);
        ui->searchLineEdit->clear();
        emit addCategoryRequested(dialog.getCategoryName(), dialog.getParentId());
    }
}

void CategoriesWidget::onFilterChanged(int index){
    int parentId = ui->filterComboBox->itemData(index).toInt();
    emit filterChanged(parentId);
}

void CategoriesWidget::displayCategories(const QVector<Category>& categories) {
    ui->tableWidget->setRowCount(categories.size());

    for (int row = 0; row < categories.size(); ++row) {
        const Category& cat = categories[row];
        int categoryId = cat.getId();

        ui->tableWidget->setItem(row, 0, new QTableWidgetItem(QString::number(cat.getId())));
        ui->tableWidget->setItem(row, 1, new QTableWidgetItem(cat.getName()));

        QComboBox *parentCombo = new QComboBox();
        for (int parentId = 1; parentId<=5;++parentId){
            parentCombo->addItem(Category::parentCategoryName(parentId),parentId);
        }
        int currentIndex = parentCombo->findData(cat.getParentId());
        parentCombo->setCurrentIndex(currentIndex);

        connect(parentCombo, &QComboBox::currentIndexChanged, this, [this, categoryId, parentCombo](int index) {
            int newParentId = parentCombo->itemData(index).toInt();
            emit categoryParentChanged(categoryId, newParentId);
        });

        ui->tableWidget->setCellWidget(row, 2, parentCombo);

        CategoryRemoveButton* removeButton = new CategoryRemoveButton(categoryId,cat.getName());
        connect(removeButton, &CategoryRemoveButton::removeRequested, this, &CategoriesWidget::removeCategoryRequested);

        ui->tableWidget->setCellWidget(row, 3, removeButton);
    }
}

void CategoriesWidget::showError(const QString &message) {
    QMessageBox::warning(this, "Invalid Input", message);
}