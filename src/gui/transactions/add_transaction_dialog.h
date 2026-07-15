#ifndef ADD_TRANSACTION_DIALOG_H
#define ADD_TRANSACTION_DIALOG_H

#include <QDialog>
#include <QLineEdit>
#include <QComboBox>
#include <QDateEdit>
#include <QDoubleSpinBox>
#include <QPushButton>

class TransactionsController;

class AddTransactionDialog : public QDialog {
    Q_OBJECT
public:
    // Truyền pointer controller để có thể lấy danh sách category
    explicit AddTransactionDialog(TransactionsController* controller, QWidget *parent = nullptr);
    
    // Dùng khi Edit một giao dịch đã có
    void setTransactionData(int id, const QString& type, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account);
    
    // Getters để form trả dữ liệu về
    int getTransactionId() const; // -1 nếu là tạo mới
    QString getType() const;
    double getAmount() const;
    QDateTime getDateTime() const;
    int getCategoryId() const;
    QString getDescription() const;
    QString getAccount() const;

private:
    int m_editId = -1;
    TransactionsController* m_controller;
    
    QComboBox* m_typeCombo;
    QDoubleSpinBox* m_amountSpin;
    QDateEdit* m_dateEdit;
    QComboBox* m_categoryCombo;
    QLineEdit* m_descEdit;
    QLineEdit* m_accountEdit;
    
    QPushButton* m_saveBtn;
    QPushButton* m_cancelBtn;
};

#endif // ADD_TRANSACTION_DIALOG_H
