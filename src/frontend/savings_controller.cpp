#include "savings_controller.h"
#include <QLocale>
#include <QDate>
#include <QLocale>
#include <cmath>
#include <QDebug>
#include "../backend/storage/database_manager.h"
#include "../backend/models/transaction_factory.h"

namespace {
QString formatVnd(double amount) {
    return QLocale(QLocale::Vietnamese).toString(amount, 'f', 0) + " VND";
}

QDate parseDateStr(const QString &str) {
    QDate d = QDate::fromString(str, "dd/MM/yyyy");
    if (!d.isValid()) {
        d = QDate::fromString(str, Qt::ISODate);
    }
    return d;
}
}

SavingsController::SavingsController(QObject *parent) : QObject(parent) {
    connect(&DatabaseManager::instance(), &DatabaseManager::dataChanged, this, [this]() {
        m_listDirty = true;
        emit savingsListChanged();
    });
}

QVariantList SavingsController::savingsList() const
{
    if (!m_listDirty) return m_cachedList;

    const auto &allSavings = DatabaseManager::instance().savingDAO()->getAll();
    const auto &allCategories = DatabaseManager::instance().categoryDAO()->getAll();

    QVariantList list;
    for (const auto &s : allSavings) {
        // Filter by search text
        if (!m_searchText.isEmpty() && !s.getName().contains(m_searchText, Qt::CaseInsensitive))
            continue;

        // Filter by priority (-1 = All)
        if (m_priorityFilter != -1 && static_cast<int>(s.getPriority()) != m_priorityFilter)
            continue;

        // Filter by category (0 = All)
        if (m_categoryFilter != 0 && s.getCategoryId() != m_categoryFilter)
            continue;

        QString categoryName = (s.getCategoryId() == 0) ? "Uncategorized" : "General";
        for (const auto &c : allCategories) {
            if (c.getId() == s.getCategoryId()) {
                categoryName = c.getName();
                break;
            }
        }

        double target = s.getTarget();
        double current = s.getCurrent();
        double fraction = (target > 0.0) ? (current / target) : 0.0;
        if (fraction > 1.0) fraction = 1.0;
        if (fraction < 0.0) fraction = 0.0;

        int percent = qRound(s.getProgressPercent());

        QVariantMap m;
        m["id"] = s.getId();
        m["sName"] = s.getName();
        m["name"] = s.getName();
        m["priorityVal"] = static_cast<int>(s.getPriority());
        m["priority"] = static_cast<int>(s.getPriority());
        m["categoryId"] = s.getCategoryId();
        m["cat"] = categoryName;
        m["categoryText"] = categoryName;
        m["currentAmount"] = current;
        m["targetAmount"] = target;
        m["sText"] = formatVnd(current);
        m["savedText"] = formatVnd(current);
        m["gText"] = "/ " + formatVnd(target);
        m["goalText"] = "/ " + formatVnd(target);
        m["pFrac"] = fraction;
        m["progressFraction"] = fraction;
        m["subT"] = QString::number(percent) + "% saved";
        m["progressSubText"] = QString::number(percent) + "% saved";
        m["dDate"] = s.getDueDate().toString("dd/MM/yyyy");
        m["dueDateText"] = s.getDueDate().toString("dd/MM/yyyy");

        // Auto-Planner logic
        QString plannerText = "";
        double remaining = target - current;
        if (remaining > 0.0) {
            int daysLeft = QDate::currentDate().daysTo(s.getDueDate());
            if (daysLeft > 0) {
                // Estimate months and round up to whole month
                int monthsLeft = qMax(1, (int)std::ceil(daysLeft / 30.0));
                double monthlyNeeded = remaining / monthsLeft;
                // Round up to nearest 1,000 to avoid weird numbers (số lẻ)
                monthlyNeeded = std::ceil(monthlyNeeded / 1000.0) * 1000.0;
                plannerText = "Need: " + formatVnd(monthlyNeeded) + " / month";
            } else {
                plannerText = "Overdue!";
            }
        } else {
            plannerText = "Goal Reached!";
        }
        m["plannerText"] = plannerText;

        list.append(m);
    }

    m_cachedList = list;
    m_listDirty = false;
    return m_cachedList;
}

QVariantList SavingsController::categoryOptions() const
{
    const auto &allCats = DatabaseManager::instance().categoryDAO()->getAll();
    QVariantList options;

    QVariantMap allMap;
    allMap["id"] = 0;
    allMap["name"] = "All Categories";
    options.append(allMap);

    for (const auto &c : allCats) {
        // SỬA: chỉ lấy đúng các category CON của Saving (parentId == 5).
        // Trước đây có thêm "|| c.getId() == Saving::parentCategory" khiến
        // category nào có ID trùng số 5 (vd "Food & Dining", con của Expense)
        // cũng bị lọt vào danh sách category của Savings do trùng số ngẫu nhiên.
        if (c.getParentId() == Saving::parentCategory) {
            QVariantMap m;
            m["id"] = c.getId();
            m["name"] = c.getName();
            options.append(m);
        }
    }
    return options;
}

void SavingsController::setSearchText(const QString &text)
{
    if (m_searchText != text) {
        m_searchText = text;
        m_listDirty = true;
        emit filterChanged();
        emit savingsListChanged();
    }
}

void SavingsController::setPriorityFilter(int filter)
{
    if (m_priorityFilter != filter) {
        m_priorityFilter = filter;
        m_listDirty = true;
        emit filterChanged();
        emit savingsListChanged();
    }
}

void SavingsController::setCategoryFilter(int filter)
{
    if (m_categoryFilter != filter) {
        m_categoryFilter = filter;
        m_listDirty = true;
        emit filterChanged();
        emit savingsListChanged();
    }
}

QString SavingsController::totalSavedText() const
{
    double total = 0.0;
    for (const auto &s : DatabaseManager::instance().savingDAO()->getAll()) {
        total += s.getCurrent();
    }
    return formatVnd(total);
}

QString SavingsController::totalRemainingText() const
{
    double totalRem = 0.0;
    for (const auto &s : DatabaseManager::instance().savingDAO()->getAll()) {
        totalRem += s.getRemainingAmount();
    }
    return formatVnd(totalRem);
}

QString SavingsController::completedText() const
{
    int completedCount = 0;
    const auto &all = DatabaseManager::instance().savingDAO()->getAll();
    for (const auto &s : all) {
        if (s.isCompleted()) {
            completedCount++;
        }
    }
    return QString("%1 / %2").arg(completedCount).arg(all.size());
}

bool SavingsController::addSaving(const QString &name, int priority, int categoryId,
                                  double target, double current,
                                  const QString &dueDateStr)
{
    QDate dueDate = parseDateStr(dueDateStr);
    if (!dueDate.isValid()) {
        dueDate = QDate::currentDate().addMonths(1);
    }

    Priority p = static_cast<Priority>(qBound(0, priority, 2));
    int catId = (categoryId == 0 ? Saving::parentCategory : categoryId);
    Saving s(0, name, p, dueDate, target, current, catId);
    DatabaseManager::instance().savingDAO()->add(s);
    
    if (current > 0) {
        // Find the new Saving ID (assume it's the last one added)
        const auto& allSavings = DatabaseManager::instance().savingDAO()->getAll();
        int newId = allSavings.isEmpty() ? 0 : allSavings.last().getId();
        
        QString autoTitle = QString("[Auto-Saving ID:%1] Deposit to %2").arg(newId).arg(name);
        Transaction* newTx = TransactionFactory::createTransaction(
            1, 0, autoTitle, current, QDateTime::currentDateTime(), "Saving Deposit", catId
        );
        DatabaseManager::instance().transactionDAO()->add(newTx);
        DatabaseManager::instance().budgetDAO()->addExpenseToBudget(catId, current);
    }
    
    DatabaseManager::instance().triggerDataChanged();

    refresh();
    return true;
}

bool SavingsController::updateSaving(int id, const QString &name, int priority, int categoryId,
                                     double target, double current,
                                     const QString &dueDateStr)
{
    QDate dueDate = parseDateStr(dueDateStr);
    if (!dueDate.isValid()) {
        dueDate = QDate::currentDate().addMonths(1);
    }

    Priority p = static_cast<Priority>(qBound(0, priority, 2));
    bool success = false;
    for (const Saving& s : DatabaseManager::instance().savingDAO()->getAll()) {
        if (s.getId() == id) {
            Saving updatedS = s;
            double delta = current - s.getCurrent();
            
            updatedS.setName(name);
            updatedS.setPriority(p);
            if (categoryId != 0) updatedS.setCategoryId(categoryId);
            updatedS.setTarget(target);
            updatedS.setCurrent(current);
            updatedS.setDueDate(dueDate);
            success = DatabaseManager::instance().savingDAO()->update(id, updatedS);
            
            if (success && delta != 0) {
                QString autoTitle = QString("[Auto-Saving ID:%1] %2 %3").arg(id).arg(delta > 0 ? "Deposit to" : "Withdraw from").arg(name);
                int typeIndex = (delta > 0) ? 1 : 0; // 1 = Expense (Deposit to saving), 0 = Income (Withdraw from saving)
                Transaction* newTx = TransactionFactory::createTransaction(
                    typeIndex, 0, autoTitle, std::abs(delta), QDateTime::currentDateTime(), "Saving Transfer", updatedS.getCategoryId()
                );
                DatabaseManager::instance().transactionDAO()->add(newTx);
                
                if (typeIndex == 1) {
                    DatabaseManager::instance().budgetDAO()->addExpenseToBudget(updatedS.getCategoryId(), std::abs(delta));
                } else {
                    // Income doesn't affect budgets typically, but if it was an expense refund, it could.
                    // For now, Income just adds to Net Balance.
                }
            }
            break;
        }
    }

    if (success) {
        refresh();
    }
    return success;
}

bool SavingsController::removeSaving(int id)
{
    bool success = DatabaseManager::instance().savingDAO()->remove(id);
    if (success) {
        DatabaseManager::instance().triggerDataChanged();
        refresh();
    }
    return success;
}

void SavingsController::refresh()
{
    m_listDirty = true;
    emit savingsListChanged();
    emit totalsChanged();
}

bool SavingsController::exportToCSV(const QString &filePath)
{
    return DatabaseManager::instance().savingDAO()->exportToCSV(filePath);
}