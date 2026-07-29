#ifndef OVERVIEW_CONTROLLER_H
#define OVERVIEW_CONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include "../backend/storage/database_manager.h"

class OverviewController : public QObject {
    Q_OBJECT

    Q_PROPERTY(double totalIncome READ totalIncome NOTIFY dataChanged)
    Q_PROPERTY(double totalExpense READ totalExpense NOTIFY dataChanged)
    Q_PROPERTY(double netBalance READ netBalance NOTIFY dataChanged)

    Q_PROPERTY(QString totalIncomeFormatted READ totalIncomeFormatted NOTIFY dataChanged)
    Q_PROPERTY(QString totalExpenseFormatted READ totalExpenseFormatted NOTIFY dataChanged)
    Q_PROPERTY(QString netBalanceFormatted READ netBalanceFormatted NOTIFY dataChanged)

    Q_PROPERTY(QVariantList recentTransactions READ recentTransactions NOTIFY dataChanged)

public:
    explicit OverviewController(QObject *parent = nullptr);

    double totalIncome() const;
    double totalExpense() const;
    double netBalance() const;

    QString totalIncomeFormatted() const;
    QString totalExpenseFormatted() const;
    QString netBalanceFormatted() const;

    QVariantList recentTransactions() const;

    Q_INVOKABLE void refresh();

signals:
    void dataChanged();
};

#endif // OVERVIEW_CONTROLLER_H