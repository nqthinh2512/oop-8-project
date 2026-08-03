#ifndef REPORTS_CONTROLLER_H
#define REPORTS_CONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include <QVector>
#include <QMap>
#include <algorithm>
#include "../backend/storage/database_manager.h"
#include "../backend/models/transaction.h"

class ReportsController : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString monthlyIncomeFormatted READ monthlyIncomeFormatted NOTIFY reportChanged)
    Q_PROPERTY(QString monthlyExpenseFormatted READ monthlyExpenseFormatted NOTIFY reportChanged)
    Q_PROPERTY(QString netWorthFormatted READ netWorthFormatted NOTIFY reportChanged)
    Q_PROPERTY(QString savingsRateFormatted READ savingsRateFormatted NOTIFY reportChanged)

    Q_PROPERTY(QVariantMap billsSnapshot READ billsSnapshot NOTIFY reportChanged)
    Q_PROPERTY(QVariantMap budgetsSnapshot READ budgetsSnapshot NOTIFY reportChanged)
    Q_PROPERTY(QVariantMap savingsSnapshot READ savingsSnapshot NOTIFY reportChanged)

    Q_PROPERTY(QVariantList categoryExpenseReport READ categoryExpenseReport NOTIFY reportChanged)
    Q_PROPERTY(QVariantList categoryIncomeReport READ categoryIncomeReport NOTIFY reportChanged)

    Q_PROPERTY(QVariantMap monthlyChartData READ monthlyChartData NOTIFY reportChanged)
    Q_PROPERTY(QVariantMap netWorthChartData READ netWorthChartData NOTIFY reportChanged)

public:
    explicit ReportsController(QObject *parent = nullptr);

    QString monthlyIncomeFormatted() const;
    QString monthlyExpenseFormatted() const;
    QString netWorthFormatted() const;
    QString savingsRateFormatted() const;

    QVariantMap billsSnapshot() const;
    QVariantMap budgetsSnapshot() const;
    QVariantMap savingsSnapshot() const;

    QVariantList categoryExpenseReport() const;
    QVariantList categoryIncomeReport() const;

    QVariantMap monthlyChartData() const;
    QVariantMap netWorthChartData() const;

    Q_INVOKABLE void refresh();
    Q_INVOKABLE bool exportToCSV(const QString &filePath);

signals:
    void reportChanged();

private:
    static QString formatVND(double amount);
};

#endif // REPORTS_CONTROLLER_H