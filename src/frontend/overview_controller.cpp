#include "overview_controller.h"
#include <QLocale>

OverviewController::OverviewController(QObject *parent)
    : QObject(parent) {}

double OverviewController::totalIncome() const {
    double income = 0;
    // DatabaseManager transaction querying will populate this
    return income;
}

double OverviewController::totalExpense() const {
    double expense = 0;
    // DatabaseManager transaction querying will populate this
    return expense;
}

double OverviewController::netBalance() const {
    return totalIncome() - totalExpense();
}

static QString formatVND(double amount) {
    QLocale locale(QLocale::Vietnamese, QLocale::Vietnam);
    return locale.toString(static_cast<qlonglong>(amount)) + " VND";
}

QString OverviewController::totalIncomeFormatted() const {
    return formatVND(totalIncome());
}

QString OverviewController::totalExpenseFormatted() const {
    return formatVND(totalExpense());
}

QString OverviewController::netBalanceFormatted() const {
    return formatVND(netBalance());
}

QVariantList OverviewController::recentTransactions() const {
    QVariantList list;
    // Populated from DatabaseManager
    return list;
}

void OverviewController::refresh() {
    emit dataChanged();
}