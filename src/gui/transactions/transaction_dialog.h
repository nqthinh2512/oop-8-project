#ifndef TRANSACTION_DIALOG_H
#define TRANSACTION_DIALOG_H

#include <QDialog>
#include "../../backend/models/transaction.h"

namespace Ui {
class TransactionDialog;
}

class TransactionDialog : public QDialog
{
    Q_OBJECT

public:
    explicit TransactionDialog(QWidget *parent = nullptr);
    ~TransactionDialog();

    // Getters để lấy dữ liệu sau khi người dùng bấm Lưu
    QString getTransactionType() const;
    double getAmount() const;
    int getCategoryId() const;
    QString getPaymentMethod() const;
    QString getNote() const;
    QDateTime getDateTime() const;

private slots:
    void onAmountTextChanged(const QString &text);

private:
    Ui::TransactionDialog *ui;
    
    // Hàm tải danh sách danh mục (Categories) vào ComboBox
    void populateCategories();
};

#endif // TRANSACTION_DIALOG_H
