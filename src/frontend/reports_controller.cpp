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

void ReportsController::refresh() {
    emit reportChanged();
}