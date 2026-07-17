#include "transactions_widget.h"
#include "ui_transactions_widget.h"
#include "../../backend/storage/database_manager.h"
#include "../../backend/models/transaction.h"
#include "../../backend/models/category.h"
#include "transaction_dialog.h"
#include <QTableWidgetItem>
#include <QLocale>

TransactionsWidget::TransactionsWidget(QWidget *parent)
    : QWidget(parent),
    ui(new Ui::TransactionsWidget)
{
    ui->setupUi(this);
    
    // Ép các cột dãn đều nhau
    ui->tableWidget->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);

    // Tải dữ liệu vào bảng
    loadTransactionsToTable();

    // Xử lý sự kiện bấm nút Add
    connect(ui->btnAdd, &QPushButton::clicked, this, [=]() {
        // Tạo một lớp phủ mờ (overlay) màu đen trên toàn bộ cửa sổ chính
        QWidget* overlay = new QWidget(this->window());
        overlay->setStyleSheet("background-color: rgba(0, 0, 0, 120);");
        overlay->resize(this->window()->size());
        overlay->show();

        TransactionDialog dialog(this);
        if (dialog.exec() == QDialog::Accepted) {
            // Tạo đối tượng Income/Expense tương ứng
            Transaction* newTx = nullptr;
            int newId = DatabaseManager::instance().generateNextTransactionId();
            
            if (dialog.getTransactionType() == "Thu") {
                Income* inc = new Income(newId, dialog.getAmount(), dialog.getDateTime(), dialog.getNote(), dialog.getCategoryId(), "Income", dialog.getPaymentMethod());
                newTx = inc;
            } else {
                Expense* exp = new Expense(newId, dialog.getAmount(), dialog.getDateTime(), dialog.getNote(), dialog.getCategoryId(), "Expense", dialog.getPaymentMethod());
                newTx = exp;
            }

            // Lưu vào Database
            DatabaseManager::instance().addTransaction(newTx);
            DatabaseManager::instance().saveTransactionsToCSV();

            // Cập nhật lại Bảng
            loadTransactionsToTable();
        }

        // Đóng lớp phủ mờ sau khi tắt Dialog
        overlay->hide();
        overlay->deleteLater();
    });
}

TransactionsWidget::~TransactionsWidget() {
    delete ui;
}

void TransactionsWidget::loadTransactionsToTable() {
    // 1. Lấy dữ liệu từ Database
    // (Lưu ý: Bạn phải gọi loadTransactionsFromCSV() ở main.cpp hoặc mainwindow trước đó)
    const QVector<Transaction*>& transactions = DatabaseManager::instance().getAllTransactions();
    const QVector<Category>& categories = DatabaseManager::instance().getAllCategories();

    // 2. Thiết lập số lượng hàng cho bảng
    ui->tableWidget->setRowCount(transactions.size());

    // Định dạng tiền tệ VNĐ
    QLocale locale(QLocale::English, QLocale::Vietnam);

    // 3. Đổ dữ liệu vào từng ô (Cell)
    for (int i = 0; i < transactions.size(); ++i) {
        Transaction* t = transactions[i];

        // Cột 1: Transaction (Note hoặc Tên giao dịch)
        QTableWidgetItem* itemNote = new QTableWidgetItem(t->getNote());
        
        // Cột 2: Amount (Tiền)
        QString sign = (t->getTransactionType() == "Income") ? "+" : (t->getTransactionType() == "Expense" ? "-" : "");
        QString amountStr = sign + locale.toString(t->getAmount(), 'f', 0) + " USD";
        QTableWidgetItem* itemAmount = new QTableWidgetItem(amountStr);
        // Đổi màu xanh/đỏ tùy loại
        if (t->getTransactionType() == "Income") itemAmount->setForeground(QBrush(QColor("#2ecc71"))); // Xanh lá
        else if (t->getTransactionType() == "Expense") itemAmount->setForeground(QBrush(QColor("#e74c3c"))); // Đỏ

        // Cột 3: Category
        QString categoryName = "Không xác định";
        for (const Category& cat : categories) {
            if (cat.getId() == t->getCategoryId()) {
                categoryName = cat.getName();
                break;
            }
        }
        QTableWidgetItem* itemCategory = new QTableWidgetItem(categoryName);

        // Cột 4: Account (Payment Method)
        QTableWidgetItem* itemAccount = new QTableWidgetItem(t->getPaymentMethod());

        // Cột 5: Created Date
        QTableWidgetItem* itemDate = new QTableWidgetItem(t->getDateTime().toString("dd.MM.yyyy"));

        // Không cho phép edit trên bảng
        itemNote->setFlags(itemNote->flags() & ~Qt::ItemIsEditable);
        itemAmount->setFlags(itemAmount->flags() & ~Qt::ItemIsEditable);
        itemCategory->setFlags(itemCategory->flags() & ~Qt::ItemIsEditable);
        itemAccount->setFlags(itemAccount->flags() & ~Qt::ItemIsEditable);
        itemDate->setFlags(itemDate->flags() & ~Qt::ItemIsEditable);

        ui->tableWidget->setItem(i, 0, itemNote);
        ui->tableWidget->setItem(i, 1, itemAmount);
        ui->tableWidget->setItem(i, 2, itemCategory);
        ui->tableWidget->setItem(i, 3, itemAccount);
        ui->tableWidget->setItem(i, 4, itemDate);
    }
}