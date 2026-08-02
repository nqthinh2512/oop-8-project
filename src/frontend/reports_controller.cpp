#include "reports_controller.h"
#include <QLocale>
#include <QDate>
#include <QDebug>

ReportsController::ReportsController(QObject *parent)
    : QObject(parent) {
    connect(&DatabaseManager::instance(), &DatabaseManager::dataChanged, this, &ReportsController::reportChanged);
}

QString ReportsController::formatVND(double amount) {
    QLocale locale(QLocale::Vietnamese, QLocale::Vietnam);
    return locale.toString(static_cast<qlonglong>(qAbs(amount))) + " VND";
}

static bool isCurrentPeriod(const QDate& itemDate, const QDate& today) {
    if (itemDate.month() == today.month() && itemDate.year() == today.year())
        return true;
    return qAbs(itemDate.daysTo(today)) <= 30;
}

QString ReportsController::monthlyIncomeFormatted() const {
    double total = 0.0;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    QDate today = QDate::currentDate();

    for (const Transaction* t : transactions) {
        if (t && t->getSignedAmount() > 0) {
            if (isCurrentPeriod(t->getDateTime().date(), today)) {
                total += t->getAmount();
            }
        }
    }
    return formatVND(total);
}

QString ReportsController::monthlyExpenseFormatted() const {
    double total = 0.0;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    QDate today = QDate::currentDate();

    for (const Transaction* t : transactions) {
        if (t && t->getSignedAmount() < 0) {
            if (isCurrentPeriod(t->getDateTime().date(), today)) {
                total += t->getAmount();
            }
        }
    }
    return formatVND(total);
}

QString ReportsController::netWorthFormatted() const {
    double balance = 0.0;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    for (const Transaction* t : transactions) {
        if (t) balance += t->getSignedAmount();
    }
    return formatVND(balance);
}

QString ReportsController::savingsRateFormatted() const {
    double income = 0.0;
    double expense = 0.0;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    QDate today = QDate::currentDate();

    for (const Transaction* t : transactions) {
        if (t && isCurrentPeriod(t->getDateTime().date(), today)) {
            if (t->getSignedAmount() > 0) {
                income += t->getAmount();
            } else if (t->getSignedAmount() < 0) {
                expense += t->getAmount();
            }
        }
    }

    if (income <= 0) return "0%";
    double rate = ((income - expense) / income) * 100.0;
    if (rate < 0) rate = 0;
    return QString::number(rate, 'f', 1) + "%";
}

QVariantMap ReportsController::billsSnapshot() const {
    QVariantMap map;
    double due = 0.0;
    double overdue = 0.0;
    double paid = 0.0;

    const auto& bills = DatabaseManager::instance().getAllBills();
    QDate today = QDate::currentDate();

    for (const Bill& b : bills) {
        if (b.checkPaid()) {
            paid += b.getAmount();
        } else if (b.getDueDate() < today) {
            overdue += b.getAmount();
        } else {
            due += b.getAmount();
        }
    }

    map["dueFormatted"] = formatVND(due);
    map["overdueFormatted"] = formatVND(overdue);
    map["paidFormatted"] = formatVND(paid);
    return map;
}

QVariantMap ReportsController::budgetsSnapshot() const {
    QVariantMap map;
    double spent = 0.0;
    double limit = 0.0;

    const auto& budgets = DatabaseManager::instance().getAllBudgets();
    for (const Budget& b : budgets) {
        spent += b.getSpent();
        limit += b.getLimit();
    }

    double remaining = qMax(0.0, limit - spent);

    map["spentFormatted"] = formatVND(spent);
    map["limitFormatted"] = formatVND(limit);
    map["remainingFormatted"] = formatVND(remaining);
    return map;
}

QVariantMap ReportsController::savingsSnapshot() const {
    QVariantMap map;
    double saved = 0.0;
    double target = 0.0;

    const auto& savings = DatabaseManager::instance().getAllSavings();
    for (const Saving& s : savings) {
        saved += s.getCurrent();
        target += s.getTarget();
    }

    double remaining = qMax(0.0, target - saved);

    map["savedFormatted"] = formatVND(saved);
    map["targetFormatted"] = formatVND(target);
    map["remainingFormatted"] = formatVND(remaining);
    return map;
}

QVariantList ReportsController::categoryExpenseReport() const {
    QVariantList result;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    const auto& categories = DatabaseManager::instance().getAllCategories();

    QMap<int, QString> catNames;
    for (const auto& c : categories) {
        catNames[c.getId()] = c.getName();
    }

    QMap<int, double> catTotals;
    double grandTotal = 0.0;

    for (const Transaction* t : transactions) {
        if (t && t->getSignedAmount() < 0) {
            double amt = t->getAmount();
            catTotals[t->getCategoryId()] += amt;
            grandTotal += amt;
        }
    }

    if (grandTotal <= 0) return result;

    struct CatItem {
        QString name;
        double amount;
    };
    QVector<CatItem> items;
    for (auto it = catTotals.begin(); it != catTotals.end(); ++it) {
        QString name = catNames.value(it.key(), "Uncategorized");
        items.append({name, it.value()});
    }

    std::sort(items.begin(), items.end(), [](const CatItem& a, const CatItem& b) {
        return a.amount > b.amount;
    });

    QStringList palette = {"#3b82f6", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6", "#94a3b8"};

    double unlistedSum = 0.0;
    for (int i = 0; i < items.size(); ++i) {
        if (i < 5) {
            double pct = (items[i].amount / grandTotal) * 100.0;
            QVariantMap m;
            m["name"] = items[i].name;
            m["amount"] = items[i].amount;
            m["amountFormatted"] = formatVND(items[i].amount);
            m["percentage"] = pct;
            m["color"] = palette[i];
            result.append(m);
        } else {
            unlistedSum += items[i].amount;
        }
    }

    if (unlistedSum > 0) {
        double pct = (unlistedSum / grandTotal) * 100.0;
        QVariantMap m;
        m["name"] = "Unlisted";
        m["amount"] = unlistedSum;
        m["amountFormatted"] = formatVND(unlistedSum);
        m["percentage"] = pct;
        m["color"] = palette[5];
        result.append(m);
    }

    return result;
}

QVariantList ReportsController::categoryIncomeReport() const {
    QVariantList result;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    const auto& categories = DatabaseManager::instance().getAllCategories();

    QMap<int, QString> catNames;
    for (const auto& c : categories) {
        catNames[c.getId()] = c.getName();
    }

    QMap<int, double> catTotals;
    double grandTotal = 0.0;

    for (const Transaction* t : transactions) {
        if (t && t->getSignedAmount() > 0) {
            double amt = t->getAmount();
            catTotals[t->getCategoryId()] += amt;
            grandTotal += amt;
        }
    }

    if (grandTotal <= 0) return result;

    struct CatItem {
        QString name;
        double amount;
    };
    QVector<CatItem> items;
    for (auto it = catTotals.begin(); it != catTotals.end(); ++it) {
        QString name = catNames.value(it.key(), "Uncategorized");
        items.append({name, it.value()});
    }

    std::sort(items.begin(), items.end(), [](const CatItem& a, const CatItem& b) {
        return a.amount > b.amount;
    });

    QStringList palette = {"#10b981", "#3b82f6", "#f59e0b", "#8b5cf6", "#ec4899", "#94a3b8"};

    double unlistedSum = 0.0;
    for (int i = 0; i < items.size(); ++i) {
        if (i < 5) {
            double pct = (items[i].amount / grandTotal) * 100.0;
            QVariantMap m;
            m["name"] = items[i].name;
            m["amount"] = items[i].amount;
            m["amountFormatted"] = formatVND(items[i].amount);
            m["percentage"] = pct;
            m["color"] = palette[i];
            result.append(m);
        } else {
            unlistedSum += items[i].amount;
        }
    }

    if (unlistedSum > 0) {
        double pct = (unlistedSum / grandTotal) * 100.0;
        QVariantMap m;
        m["name"] = "Unlisted";
        m["amount"] = unlistedSum;
        m["amountFormatted"] = formatVND(unlistedSum);
        m["percentage"] = pct;
        m["color"] = palette[5];
        result.append(m);
    }

    return result;
}

QVariantMap ReportsController::monthlyChartData() const {
    QVariantMap res;
    QDate today = QDate::currentDate();

    QStringList months;
    QVector<double> incomeTotals(6, 0.0);
    QVector<double> expenseTotals(6, 0.0);

    QVector<QDate> monthDates;
    for (int i = 5; i >= 0; --i) {
        QDate d = today.addMonths(-i);
        months.append(d.toString("MMM"));
        monthDates.append(d);
    }

    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    for (const Transaction* t : transactions) {
        if (!t) continue;
        QDate td = t->getDateTime().date();
        for (int i = 0; i < 6; ++i) {
            if (td.year() == monthDates[i].year() && td.month() == monthDates[i].month()) {
                if (t->getSignedAmount() > 0) {
                    incomeTotals[i] += t->getAmount();
                } else if (t->getSignedAmount() < 0) {
                    expenseTotals[i] += t->getAmount();
                }
                break;
            }
        }
    }

    double maxVal = 0.0;
    for (int i = 0; i < 6; ++i) {
        if (incomeTotals[i] > maxVal) maxVal = incomeTotals[i];
        if (expenseTotals[i] > maxVal) maxVal = expenseTotals[i];
    }

    if (maxVal <= 0.0) {
        maxVal = 10000000.0;
    }

    double scale = (maxVal > 5000000.0) ? std::ceil(maxVal / 5000000.0) * 5000000.0 : std::ceil(maxVal / 1000000.0) * 1000000.0;

    QVariantList incomeRatios;
    QVariantList expenseRatios;
    for (int i = 0; i < 6; ++i) {
        incomeRatios.append(incomeTotals[i] / scale);
        expenseRatios.append(expenseTotals[i] / scale);
    }

    auto fmtShort = [](double val) -> QString {
        if (val >= 1000000.0) return QString::number(val / 1000000.0, 'f', (fmod(val, 1000000.0) == 0 ? 0 : 1)) + "M";
        if (val >= 1000.0) return QString::number(val / 1000.0, 'f', 0) + "K";
        return QString::number(val, 'f', 0);
    };

    QStringList yTicks;
    yTicks.append(fmtShort(scale));
    yTicks.append(fmtShort(scale * 0.75));
    yTicks.append(fmtShort(scale * 0.50));
    yTicks.append(fmtShort(scale * 0.25));
    yTicks.append("0");

    res["months"] = months;
    res["incomeRatios"] = incomeRatios;
    res["expenseRatios"] = expenseRatios;
    res["yTicks"] = yTicks;
    return res;
}

QVariantMap ReportsController::netWorthChartData() const {
    QVariantMap res;
    QDate today = QDate::currentDate();

    QStringList months;
    QVector<QDate> monthDates;
    for (int i = 5; i >= 0; --i) {
        QDate d = today.addMonths(-i);
        months.append(d.toString("MMM"));
        monthDates.append(d);
    }

    QVector<double> nwTotals(6, 0.0);
    const auto& transactions = DatabaseManager::instance().getAllTransactions();

    for (int i = 0; i < 6; ++i) {
        QDate monthEnd(monthDates[i].year(), monthDates[i].month(), monthDates[i].daysInMonth());
        double cumNet = 0.0;
        for (const Transaction* t : transactions) {
            if (t && t->getDateTime().date() <= monthEnd) {
                cumNet += t->getSignedAmount();
            }
        }
        nwTotals[i] = cumNet > 0 ? cumNet : 0.0;
    }

    double maxVal = 0.0;
    for (int i = 0; i < 6; ++i) {
        if (nwTotals[i] > maxVal) maxVal = nwTotals[i];
    }
    if (maxVal <= 0.0) maxVal = 20000000.0;

    double scale = (maxVal > 5000000.0) ? std::ceil(maxVal / 5000000.0) * 5000000.0 : std::ceil(maxVal / 1000000.0) * 1000000.0;

    QVariantList nwRatios;
    for (int i = 0; i < 6; ++i) {
        nwRatios.append(nwTotals[i] / scale);
    }

    auto fmtShort = [](double val) -> QString {
        if (val >= 1000000.0) return QString::number(val / 1000000.0, 'f', (fmod(val, 1000000.0) == 0 ? 0 : 1)) + "M";
        if (val >= 1000.0) return QString::number(val / 1000.0, 'f', 0) + "K";
        return QString::number(val, 'f', 0);
    };

    QStringList yTicks;
    yTicks.append(fmtShort(scale));
    yTicks.append(fmtShort(scale * 0.75));
    yTicks.append(fmtShort(scale * 0.50));
    yTicks.append(fmtShort(scale * 0.25));
    yTicks.append("0");

    res["months"] = months;
    res["nwRatios"] = nwRatios;
    res["yTicks"] = yTicks;
    return res;
}

void ReportsController::refresh() {
    emit reportChanged();
}