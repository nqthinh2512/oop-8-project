#include "add_transaction_dialog.h"
#include "../../frontend/transactions/transactions_controller.h"
#include <QVBoxLayout>
#include <QFormLayout>
#include <QHBoxLayout>

AddTransactionDialog::AddTransactionDialog(TransactionsController* controller, QWidget *parent)
    : QDialog(parent), m_controller(controller) {
    
    setWindowTitle("Giao Dịch");
    setMinimumWidth(300);

    QFormLayout* formLayout = new QFormLayout();
    
    m_typeCombo = new QComboBox(this);
    m_typeCombo->addItem("Income", "Income");
    m_typeCombo->addItem("Expense", "Expense");
    
    m_amountSpin = new QDoubleSpinBox(this);
    m_amountSpin->setMaximum(999999999.99);
    m_amountSpin->setDecimals(0);
    
    m_dateEdit = new QDateEdit(QDate::currentDate(), this);
    m_dateEdit->setCalendarPopup(true);
    
    m_categoryCombo = new QComboBox(this);
    if (m_controller) {
        auto categories = m_controller->getCategories();
        for (const auto& cat : categories) {
            m_categoryCombo->addItem(cat.getName(), cat.getId());
        }
    }
    
    m_descEdit = new QLineEdit(this);
    m_accountEdit = new QLineEdit(this);
    
    formLayout->addRow("Loại:", m_typeCombo);
    formLayout->addRow("Số tiền:", m_amountSpin);
    formLayout->addRow("Ngày:", m_dateEdit);
    formLayout->addRow("Danh mục:", m_categoryCombo);
    formLayout->addRow("Ghi chú:", m_descEdit);
    formLayout->addRow("Tài khoản:", m_accountEdit);
    
    QHBoxLayout* btnLayout = new QHBoxLayout();
    m_saveBtn = new QPushButton("Lưu", this);
    m_cancelBtn = new QPushButton("Hủy", this);
    
    m_saveBtn->setStyleSheet("background-color: #2D68FE; color: white; border-radius: 5px; padding: 5px 15px; font-weight: bold;");
    m_cancelBtn->setStyleSheet("background-color: #f1f3f5; color: #495057; border-radius: 5px; padding: 5px 15px; font-weight: bold;");
    
    btnLayout->addStretch();
    btnLayout->addWidget(m_saveBtn);
    btnLayout->addWidget(m_cancelBtn);
    
    QVBoxLayout* mainLayout = new QVBoxLayout(this);
    mainLayout->addLayout(formLayout);
    mainLayout->addLayout(btnLayout);
    
    connect(m_saveBtn, &QPushButton::clicked, this, &QDialog::accept);
    connect(m_cancelBtn, &QPushButton::clicked, this, &QDialog::reject);
}

void AddTransactionDialog::setTransactionData(int id, const QString& type, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account) {
    m_editId = id;
    
    int typeIndex = m_typeCombo->findData(type);
    if (typeIndex != -1) m_typeCombo->setCurrentIndex(typeIndex);
    
    m_amountSpin->setValue(amount);
    m_dateEdit->setDate(dateTime.date());
    
    int catIndex = m_categoryCombo->findData(categoryId);
    if (catIndex != -1) m_categoryCombo->setCurrentIndex(catIndex);
    
    m_descEdit->setText(description);
    m_accountEdit->setText(account);
}

int AddTransactionDialog::getTransactionId() const { return m_editId; }
QString AddTransactionDialog::getType() const { return m_typeCombo->currentData().toString(); }
double AddTransactionDialog::getAmount() const { return m_amountSpin->value(); }
QDateTime AddTransactionDialog::getDateTime() const { 
    return QDateTime(m_dateEdit->date(), QTime(0,0)); 
}
int AddTransactionDialog::getCategoryId() const { return m_categoryCombo->currentData().toInt(); }
QString AddTransactionDialog::getDescription() const { return m_descEdit->text(); }
QString AddTransactionDialog::getAccount() const { return m_accountEdit->text(); }
