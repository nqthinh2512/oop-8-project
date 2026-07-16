#include "transaction.h"

Transaction::Transaction():
    id(0),
    amount(0),
    categoryId(0),
    dateTime(QDateTime::currentDateTime()),
    note(""),
    transactionType(""),
    paymentMethod(""),
    receiptImagePath(""),
    status("Thành công") {}

Transaction::Transaction(int n_id, double n_amount, const QDateTime& n_date, const QString& n_note, int n_categoryid, const QString& n_txType, const QString& n_payMethod, const QString& n_receipt, const QString& n_status):
    id(n_id),
    amount(n_amount),
    categoryId(n_categoryid),
    dateTime(n_date),
    note(n_note),
    transactionType(n_txType),
    paymentMethod(n_payMethod),
    receiptImagePath(n_receipt),
    status(n_status) {}

Income::Income(int n_id, double n_amount, const QDateTime& n_date, const QString& n_note, int n_categoryid, const QString& n_txType, const QString& n_payMethod, const QString& n_receipt, const QString& n_status, const QString& n_payer):
    Transaction(n_id,n_amount,n_date,n_note,n_categoryid,n_txType,n_payMethod,n_receipt,n_status),
    payer(n_payer) {}

Expense::Expense(int n_id, double n_amount, const QDateTime& n_date, const QString& n_note, int n_categoryid, const QString& n_txType, const QString& n_payMethod, const QString& n_receipt, const QString& n_status, const QString& n_payee, bool n_isEssential):
    Transaction(n_id,n_amount,n_date,n_note,n_categoryid,n_txType,n_payMethod,n_receipt,n_status),
    payee(n_payee),
    isEssential(n_isEssential) {}