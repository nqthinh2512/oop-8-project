#include "overview_controller.h"
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

        QVariantMap item;
        item["id"] = t->getId();
        item["note"] = t->getNote();
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

void OverviewController::refresh() {
    emit dataChanged();
}