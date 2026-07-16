#include "transactions_widget.h"
#include "ui_transactions_widget.h"
#include "../../frontend/transactions/transactions_controller.h"
#include "add_transaction_dialog.h"
#include <QMessageBox>

TransactionsWidget::TransactionsWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::TransactionsWidget)
{
    ui->setupUi(this);
    m_controller = new TransactionsController(this);
    
    // Ẩn filter theo yêu cầu người dùng
    ui->filterLabel->setVisible(false);
    ui->categoryFilter->setVisible(false);
    ui->startDateEdit->setVisible(false);
    ui->endDateEdit->setVisible(false);
    
    ui->categoryFilter->addItem("All Categories", -1);
    auto categories = m_controller->getCategories();
    for (const auto& cat : categories) {
        ui->categoryFilter->addItem(cat.getName(), cat.getId());
    }
    
    // Stretch columns
    ui->table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);

    // Connect signals
    connect(ui->searchEdit, &QLineEdit::textChanged, this, &TransactionsWidget::onSearchChanged);
    connect(ui->categoryFilter, &QComboBox::currentIndexChanged, this, &TransactionsWidget::onFilterChanged);
    connect(ui->startDateEdit, &QDateEdit::dateChanged, this, &TransactionsWidget::onFilterChanged);
    connect(ui->endDateEdit, &QDateEdit::dateChanged, this, &TransactionsWidget::onFilterChanged);
    connect(ui->addBtn, &QPushButton::clicked, this, &TransactionsWidget::onAddClicked);
    
    loadData();
}

TransactionsWidget::~TransactionsWidget()
{
    delete ui;
}

void TransactionsWidget::loadData() {
    QString keyword = ui->searchEdit->text();
    int categoryId = ui->categoryFilter->currentData().toInt();
    QDate startDate = ui->startDateEdit->date();
    QDate endDate = ui->endDateEdit->date();

    QVector<Transaction*> transactions = m_controller->getFilteredTransactions(keyword, categoryId, startDate, endDate);

    ui->table->setRowCount(0);

    QString lastDate = "";

    for (Transaction* tx : transactions) {
        QString txDateStr = tx->getDateTime().toString("dd.MM.yyyy");
        
        if (txDateStr != lastDate) {
            int row = ui->table->rowCount();
            ui->table->insertRow(row);
            QTableWidgetItem* dateItem = new QTableWidgetItem(txDateStr);
            dateItem->setFont(QFont("Arial", 10, QFont::Bold));
            dateItem->setBackground(QColor("#F8F9FA"));
            ui->table->setItem(row, 0, dateItem);
            ui->table->setSpan(row, 0, 1, 4);
            lastDate = txDateStr;
        }

        int row = ui->table->rowCount();
        ui->table->insertRow(row);

        // Transaction
        ui->table->setItem(row, 0, new QTableWidgetItem(tx->getDescription()));

        // Amount
        QString sign = (tx->getType() == "Income") ? "+" : "-";
        QString amountStr = sign + QString::number(tx->getAmount(), 'f', 0) + " VND";
        QTableWidgetItem* amountItem = new QTableWidgetItem(amountStr);
        if (tx->getType() == "Income") amountItem->setForeground(QColor("#28a745"));
        else amountItem->setForeground(QColor("#dc3545"));
        ui->table->setItem(row, 1, amountItem);

        // Category
        ui->table->setItem(row, 2, new QTableWidgetItem(m_controller->getCategoryName(tx->getCategoryId())));

        // Created
        QTableWidgetItem* createdItem = new QTableWidgetItem(txDateStr);
        createdItem->setForeground(QColor("#2D68FE"));
        ui->table->setItem(row, 3, createdItem);
    }
}

void TransactionsWidget::onSearchChanged() { loadData(); }
void TransactionsWidget::onFilterChanged() { loadData(); }

void TransactionsWidget::onAddClicked() {
    AddTransactionDialog dialog(m_controller, this);
    if (dialog.exec() == QDialog::Accepted) {
        m_controller->addTransaction(
            dialog.getType(),
            dialog.getAmount(),
            dialog.getDateTime(),
            dialog.getCategoryId(),
            dialog.getDescription(),
            dialog.getAccount()
        );
        loadData();
    }
}

void TransactionsWidget::onEditClicked(int id) {
    auto txs = m_controller->getAllTransactions();
    Transaction* target = nullptr;
    for (auto tx : txs) {
        if (tx->getId() == id) { target = tx; break; }
    }
    
    if (!target) return;

    AddTransactionDialog dialog(m_controller, this);
    dialog.setTransactionData(target->getId(), target->getType(), target->getAmount(), target->getDateTime(), target->getCategoryId(), target->getDescription(), target->getAccount());
    
    if (dialog.exec() == QDialog::Accepted) {
        m_controller->updateTransaction(
            id,
            dialog.getAmount(),
            dialog.getDateTime(),
            dialog.getCategoryId(),
            dialog.getDescription(),
            dialog.getAccount()
        );
        loadData();
    }
}

void TransactionsWidget::onDeleteClicked(int id) {
    QMessageBox::StandardButton reply = QMessageBox::question(this, "Xác nhận", "Bạn có chắc chắn muốn xóa giao dịch này?", QMessageBox::Yes | QMessageBox::No);
    if (reply == QMessageBox::Yes) {
        m_controller->deleteTransaction(id);
        loadData();
    }
}