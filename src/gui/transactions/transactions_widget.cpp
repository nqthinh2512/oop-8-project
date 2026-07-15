#include "transactions_widget.h"
#include "../../frontend/transactions/transactions_controller.h"
#include "add_transaction_dialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QHeaderView>
#include <QMessageBox>

TransactionsWidget::TransactionsWidget(QWidget *parent) : QWidget(parent) {
    m_controller = new TransactionsController(this);
    setupUI();
    loadData();
}

TransactionsWidget::~TransactionsWidget() {}

void TransactionsWidget::setupUI() {
    // 1. Main Layout
    QVBoxLayout *mainLayout = new QVBoxLayout(this);
    mainLayout->setContentsMargins(20, 20, 20, 20);
    mainLayout->setSpacing(20);

    // Style the main widget background
    this->setStyleSheet("QWidget { background-color: #FFFFFF; font-family: 'Segoe UI', Arial, sans-serif; }");

    // 2. Title
    QLabel *titleLabel = new QLabel("Transactions", this);
    titleLabel->setStyleSheet("font-size: 24px; font-weight: bold; color: #000000;");
    mainLayout->addWidget(titleLabel);

    // 3. Toolbar (Search, Filters, Add Button)
    QHBoxLayout *toolbarLayout = new QHBoxLayout();
    
    m_searchEdit = new QLineEdit(this);
    m_searchEdit->setPlaceholderText("Search bar");
    m_searchEdit->setFixedWidth(250);
    m_searchEdit->setStyleSheet("QLineEdit { padding: 8px; border: 1px solid #E0E0E0; border-radius: 6px; background-color: #FAFAFA; }");

    m_addBtn = new QPushButton("Add Transaction", this);
    m_addBtn->setStyleSheet("QPushButton { background-color: #2D68FE; color: white; border: none; border-radius: 6px; padding: 8px 16px; font-weight: bold; } QPushButton:disabled { background-color: #a0bbfb; }");
    m_addBtn->setEnabled(false); // Vô hiệu hóa theo yêu cầu người dùng để chờ Figma

    QLabel *filterLabel = new QLabel("Filter by date", this);
    filterLabel->setStyleSheet("color: #666666; font-size: 12px;");
    
    m_startDateEdit = new QDateEdit(this);
    m_startDateEdit->setCalendarPopup(true);
    m_startDateEdit->setDate(QDate());
    m_startDateEdit->setVisible(false); // Ẩn theo yêu cầu

    m_endDateEdit = new QDateEdit(this);
    m_endDateEdit->setCalendarPopup(true);
    m_endDateEdit->setDate(QDate());
    m_endDateEdit->setVisible(false); // Ẩn theo yêu cầu

    m_categoryFilter = new QComboBox(this);
    m_categoryFilter->addItem("All Categories", -1);
    m_categoryFilter->setVisible(false); // Ẩn theo yêu cầu

    toolbarLayout->addWidget(m_searchEdit);
    toolbarLayout->addWidget(m_addBtn);
    toolbarLayout->addStretch();
    
    // Khối Filter bên phải
    QVBoxLayout* rightFilterLayout = new QVBoxLayout();
    rightFilterLayout->addWidget(filterLabel);
    
    QHBoxLayout* dateLayout = new QHBoxLayout();
    dateLayout->addWidget(m_categoryFilter);
    dateLayout->addWidget(m_startDateEdit);
    dateLayout->addWidget(m_endDateEdit);
    
    rightFilterLayout->addLayout(dateLayout);
    toolbarLayout->addLayout(rightFilterLayout);

    mainLayout->addLayout(toolbarLayout);

    // 4. Table
    m_table = new QTableWidget(this);
    m_table->setColumnCount(4); // Giảm cột theo yêu cầu: Transaction, Amount, Category, Created
    m_table->setHorizontalHeaderLabels({"Transaction", "Amount", "Category", "Created"});
    
    // Style Table to match Figma
    m_table->setStyleSheet(
        "QTableWidget { border: 1px solid #E0E0E0; border-radius: 8px; background-color: white; gridline-color: #F0F0F0; }"
        "QHeaderView::section { background-color: white; color: #333333; font-weight: bold; padding: 10px; border: none; border-bottom: 2px solid #E0E0E0; }"
        "QTableWidget::item { padding: 10px; border-bottom: 1px solid #F0F0F0; color: #555555; }"
    );
    
    m_table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    m_table->setSelectionBehavior(QAbstractItemView::SelectRows);
    m_table->setEditTriggers(QAbstractItemView::NoEditTriggers);
    m_table->setShowGrid(false);
    m_table->verticalHeader()->setVisible(false);

    mainLayout->addWidget(m_table);

    // Connect signals
    connect(m_searchEdit, &QLineEdit::textChanged, this, &TransactionsWidget::onSearchChanged);
    connect(m_categoryFilter, &QComboBox::currentIndexChanged, this, &TransactionsWidget::onFilterChanged);
    connect(m_startDateEdit, &QDateEdit::dateChanged, this, &TransactionsWidget::onFilterChanged);
    connect(m_endDateEdit, &QDateEdit::dateChanged, this, &TransactionsWidget::onFilterChanged);
    connect(m_addBtn, &QPushButton::clicked, this, &TransactionsWidget::onAddClicked);
}

void TransactionsWidget::loadData() {
    QString keyword = m_searchEdit->text();
    int categoryId = m_categoryFilter->currentData().toInt();
    QDate startDate = m_startDateEdit->date();
    QDate endDate = m_endDateEdit->date();

    QVector<Transaction*> transactions = m_controller->getFilteredTransactions(keyword, categoryId, startDate, endDate);

    m_table->setRowCount(0);

    QString lastDate = "";

    for (Transaction* tx : transactions) {
        QString txDateStr = tx->getDateTime().toString("dd.MM.yyyy");
        
        if (txDateStr != lastDate) {
            int row = m_table->rowCount();
            m_table->insertRow(row);
            QTableWidgetItem* dateItem = new QTableWidgetItem(txDateStr);
            dateItem->setFont(QFont("Arial", 10, QFont::Bold));
            dateItem->setBackground(QColor("#F8F9FA"));
            m_table->setItem(row, 0, dateItem);
            m_table->setSpan(row, 0, 1, 4); // Cập nhật Span thành 4 cột
            lastDate = txDateStr;
        }

        int row = m_table->rowCount();
        m_table->insertRow(row);

        // Transaction
        m_table->setItem(row, 0, new QTableWidgetItem(tx->getDescription()));

        // Amount
        QString sign = (tx->getType() == "Income") ? "+" : "-";
        QString amountStr = sign + QString::number(tx->getAmount(), 'f', 0) + " VND";
        QTableWidgetItem* amountItem = new QTableWidgetItem(amountStr);
        if (tx->getType() == "Income") amountItem->setForeground(QColor("#28a745"));
        else amountItem->setForeground(QColor("#dc3545"));
        m_table->setItem(row, 1, amountItem);

        // Category
        m_table->setItem(row, 2, new QTableWidgetItem(m_controller->getCategoryName(tx->getCategoryId())));

        // Created
        QTableWidgetItem* createdItem = new QTableWidgetItem(txDateStr);
        createdItem->setForeground(QColor("#2D68FE"));
        m_table->setItem(row, 3, createdItem);
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