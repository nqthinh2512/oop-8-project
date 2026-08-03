#include "overview_controller.h"
#include "../backend/models/transaction.h"
#include <QLocale>

OverviewController::OverviewController(QObject *parent)
    : QObject(parent) {
    connect(&DatabaseManager::instance(), &DatabaseManager::dataChanged, this, &OverviewController::dataChanged);
}

double OverviewController::totalIncome() const {
    double income = 0.0;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    QDate today = QDate::currentDate();

    for (const Transaction* t : transactions) {
        if (!t) continue;
        if (t->getSignedAmount() > 0) {
            QDate tDate = t->getDateTime().date();
            if ((tDate.month() == today.month() && tDate.year() == today.year()) ||
                qAbs(tDate.daysTo(today)) <= 30) {
                income += t->getAmount();
            }
        }
    }
    return income;
}

double OverviewController::totalExpense() const {
    double expense = 0.0;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    QDate today = QDate::currentDate();

    for (const Transaction* t : transactions) {
        if (!t) continue;
        if (t->getSignedAmount() < 0) {
            QDate tDate = t->getDateTime().date();
            if ((tDate.month() == today.month() && tDate.year() == today.year()) ||
                qAbs(tDate.daysTo(today)) <= 30) {
                expense += t->getAmount();
            }
        }
    }
    return expense;
}

double OverviewController::netBalance() const {
    double balance = 0.0;
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    for (const Transaction* t : transactions) {
        if (t) balance += t->getSignedAmount();
    }
    return balance;
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
    const auto& transactions = DatabaseManager::instance().getAllTransactions();
    const auto& categories = DatabaseManager::instance().getAllCategories();

    // Map categoryId to category name
    auto getCatName = [&categories](int catId) -> QString {
        for (const auto& c : categories) {
            if (c.getId() == catId) return c.getName();
        }
        return "General";
    };

    // Take the most recent 5 transactions
    int startIdx = qMax(0, transactions.size() - 5);
    for (int i = transactions.size() - 1; i >= startIdx; --i) {
        const Transaction* t = transactions[i];
        if (!t) continue;

        QString note = t->getNote();
        if (note.startsWith("[TYPE:")) {
            int closeIdx = note.indexOf("]");
            if (closeIdx != -1) note = note.mid(closeIdx + 1);
        }
        int sepIdx = note.indexOf("||");
        if (sepIdx != -1) note = note.left(sepIdx);

        QVariantMap item;
        item["id"] = t->getId();
        item["note"] = note;
        item["categoryName"] = getCatName(t->getCategoryId());
        item["amount"] = t->getAmount();
        item["signedAmount"] = t->getSignedAmount();
        item["amountFormatted"] = ((t->getSignedAmount() > 0) ? "+" : "-") + formatVND(t->getAmount());
        item["dateFormatted"] = t->getDateTime().toString("dd/MM/yyyy");
        item["isIncome"] = (t->getSignedAmount() > 0);

        list.append(item);
    }
    return list;
}

QVariantList OverviewController::upcomingBills() const {
    QVariantList list;
    const auto& bills = DatabaseManager::instance().getAllBills();
    const auto& categories = DatabaseManager::instance().getAllCategories();

    auto getCatName = [&categories](int catId) -> QString {
        for (const auto& c : categories) {
            if (c.getId() == catId) return c.getName();
        }
        return "General";
    };

    // Collect unpaid bills, sorted by due date (soonest first)
    QVector<const Bill*> unpaid;
    for (const Bill& b : bills) {
        if (!b.checkPaid()) unpaid.append(&b);
    }
    std::sort(unpaid.begin(), unpaid.end(), [](const Bill* a, const Bill* b) {
        return a->getDueDate() < b->getDueDate();
    });

    int count = qMin(unpaid.size(), 5);
    for (int i = 0; i < count; ++i) {
        const Bill* b = unpaid[i];
        QVariantMap item;
        item["id"] = b->getId();
        item["name"] = b->getName();
        item["categoryName"] = getCatName(b->getCategoryId());
        item["amount"] = b->getAmount();
        item["amountFormatted"] = formatVND(b->getAmount());
        item["dueDateFormatted"] = b->getDueDate().toString("MMM dd");
        item["daysLeft"] = QDate::currentDate().daysTo(b->getDueDate());
        list.append(item);
    }
    return list;
}

QVariantMap OverviewController::topSaving() const {
    const auto& savings = DatabaseManager::instance().getAllSavings();
    QVariantMap result;

    if (savings.isEmpty()) {
        result["name"] = "No Savings";
        result["current"] = 0.0;
        result["target"] = 0.0;
        result["progress"] = 0.0;
        result["currentFormatted"] = formatVND(0);
        result["targetFormatted"] = formatVND(0);
        return result;
    }

    // Find the saving with most progress (highest %)
    const Saving* best = &savings[0];
    double bestProgress = best->getProgressPercent();
    for (const Saving& s : savings) {
        double p = s.getProgressPercent();
        if (p > bestProgress) {
            bestProgress = p;
            best = &s;
        }
    }

    result["name"] = best->getName();
    result["current"] = best->getCurrent();
    result["target"] = best->getTarget();
    result["progress"] = best->getProgressPercent();
    result["currentFormatted"] = formatVND(best->getCurrent());
    result["targetFormatted"] = formatVND(best->getTarget());
    return result;
}

QVariantMap OverviewController::topBudget() const {
    const auto& budgets = DatabaseManager::instance().getAllBudgets();
    QVariantMap result;

    if (budgets.isEmpty()) {
        result["name"] = "No Budgets";
        result["spent"] = 0.0;
        result["limit"] = 0.0;
        result["progress"] = 0.0;
        result["spentFormatted"] = formatVND(0);
        result["limitFormatted"] = formatVND(0);
        return result;
    }

    // Find the budget with most progress (highest spend %)
    const Budget* best = &budgets[0];
    double bestProgress = best->getProgressPercent();
    for (const Budget& b : budgets) {
        double p = b.getProgressPercent();
        if (p > bestProgress) {
            bestProgress = p;
            best = &b;
        }
    }

    result["name"] = best->getName();
    result["spent"] = best->getSpent();
    result["limit"] = best->getLimit();
    result["progress"] = best->getProgressPercent();
    result["spentFormatted"] = formatVND(best->getSpent());
    result["limitFormatted"] = formatVND(best->getLimit());
    return result;
}

QVariantMap OverviewController::monthlyChartData() const {
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

void OverviewController::refresh() {
    emit dataChanged();
}

bool OverviewController::exportToCSV(const QString &filePath) {
    return DatabaseManager::instance().exportTransactionsToCSV(filePath);
}