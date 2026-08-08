#include "budgets_controller.h"
#include <QLocale>


namespace {
QString formatVnd(double amount) {
    return QLocale(QLocale::Vietnamese).toString(amount, 'f', 0) + " VND";
}
}

BudgetsController::BudgetsController(QObject *parent) : QObject(parent) {
    connect(&DatabaseManager::instance(), &DatabaseManager::dataChanged, this, [this]() {
        m_listDirty = true;
        emit categoriesChanged();
        emit budgetsListChanged();
    });
}

QVariantList BudgetsController::budgetsList() const
{
    if (!m_listDirty) return m_cachedList;

    const auto &allBudgets = DatabaseManager::instance().budgetDAO()->getAll();
    const auto &allCategories = DatabaseManager::instance().categoryDAO()->getAll();

    QVariantList list;
    for (const auto &b : allBudgets) {
        // --- filter tìm kiếm theo tên ---
        if (!m_searchText.isEmpty() && !b.getName().contains(m_searchText, Qt::CaseInsensitive))
            continue;
        // --- filter priority ---
        if (m_priorityFilter != -1 && static_cast<int>(b.getPriority()) != m_priorityFilter)
            continue;
        // --- filter category ---
        if (m_categoryFilter != 0 && b.getCategoryId() != m_categoryFilter)
            continue;

        QString categoryName = (b.getCategoryId() == 0) ? "Uncategorized" : "Category";
        for (const auto &c : allCategories) {
            if (c.getId() == b.getCategoryId()) { categoryName = c.getName(); break; }
        }

        QVariantMap m;
        m["id"] = b.getId();
        m["name"] = b.getName();
        m["priority"] = static_cast<int>(b.getPriority());
        m["priorityLabel"] = b.getPriorityLabel();
        m["categoryId"] = b.getCategoryId();
        m["categoryText"] = categoryName;
        m["spentAmount"] = b.getSpent();          // số thô, dùng khi Edit (đổ vào ô input)
        m["limitAmount"] = b.getLimit();          // số thô, dùng khi Edit
        m["spentText"] = formatVnd(b.getSpent());  // đã format, dùng khi hiển thị (không edit)
        m["limitText"] = "/ " + formatVnd(b.getLimit());
        m["progressFraction"] = qBound(0.0, b.getLimit() > 0 ? b.getSpent() / b.getLimit() : 0.0, 1.0);
        m["progressSubText"] = QString::number(qRound(b.getProgressPercent())) + "% used";
        m["startDateText"] = b.getStartDate().toString("dd/MM/yyyy");
        m["endDateText"] = b.getEndDate().toString("dd/MM/yyyy");
        m["isOverBudget"] = b.isOverBudget();
        m["status"] = static_cast<int>(b.getStatus());
        // period (Weekly/Monthly/Yearly) chưa có field thật trong Budget backend,
        // tạm suy ra từ khoảng cách ngày. 0=Weekly, 1=Monthly, 2=Yearly.
        qint64 days = b.getStartDate().daysTo(b.getEndDate());
        m["period"] = (days <= 10) ? 0 : (days <= 45 ? 1 : 2);

        list.append(m);
    }

    m_cachedList = list;
    m_listDirty = false;
    return m_cachedList;
}

QVariantList BudgetsController::categoryOptions() const
{
    QVariantList list;
    const auto &allCategories = DatabaseManager::instance().categoryDAO()->getAll();
    for (const auto &c : allCategories) {
        if ((c.getParentId() == 4 || c.getParentId() == 2) && c.isActive()) {
            QVariantMap m;
            m["id"] = c.getId();
            m["name"] = c.getName();
            list.append(m);
        }
    }
    return list;
}

void BudgetsController::setSearchText(const QString &text)
{
    if (m_searchText == text) return;
    m_searchText = text;
    m_listDirty = true;
    emit filterChanged();
    emit budgetsListChanged();
}

void BudgetsController::setPriorityFilter(int filter)
{
    if (m_priorityFilter == filter) return;
    m_priorityFilter = filter;
    m_listDirty = true;
    emit filterChanged();
    emit budgetsListChanged();
}

void BudgetsController::setCategoryFilter(int filter)
{
    if (m_categoryFilter == filter) return;
    m_categoryFilter = filter;
    m_listDirty = true;
    emit filterChanged();
    emit budgetsListChanged();
}

QString BudgetsController::totalSpentText() const
{
    double total = 0;
    for (const auto &b : DatabaseManager::instance().budgetDAO()->getAll()) total += b.getSpent();
    return formatVnd(total);
}

QString BudgetsController::totalLimitText() const
{
    double total = 0;
    for (const auto &b : DatabaseManager::instance().budgetDAO()->getAll()) total += b.getLimit();
    return formatVnd(total);
}

QString BudgetsController::totalRemainingText() const
{
    double spent = 0, limit = 0;
    for (const auto &b : DatabaseManager::instance().budgetDAO()->getAll()) {
        spent += b.getSpent();
        limit += b.getLimit();
    }
    return formatVnd(limit - spent);
}

bool BudgetsController::addBudget(const QString &name, int priority, int categoryId,
                                  double limit, double initialSpent,
                                  const QString &startDateStr, const QString &endDateStr)
{
    if (name.trimmed().isEmpty() || limit <= 0) return false;

    QDate start = QDate::fromString(startDateStr, "dd/MM/yyyy");
    QDate end = QDate::fromString(endDateStr, "dd/MM/yyyy");
    if (!start.isValid() || !end.isValid() || end <= start) return false;

    Budget b(0, name, static_cast<Priority>(priority), categoryId, limit, start, end);
    DatabaseManager::instance().budgetDAO()->add(b);

    if (initialSpent > 0) {
        DatabaseManager::instance().budgetDAO()->addExpenseToBudget(categoryId, initialSpent);
    }
    
    DatabaseManager::instance().triggerDataChanged();

    refresh();
    return true;
}

bool BudgetsController::updateBudget(int id, const QString &name, int priority, int categoryId,
                                     double limit, double spent, const QString &startDateStr, const QString &endDateStr)
{
    if (name.trimmed().isEmpty() || limit <= 0) return false;

    QDate start = QDate::fromString(startDateStr, "dd/MM/yyyy");
    QDate end = QDate::fromString(endDateStr, "dd/MM/yyyy");
    if (!start.isValid() || !end.isValid() || end <= start) return false;

    bool ok = false;
    for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
        if (b.getId() == id) {
            Budget updatedB = b;
            updatedB.setName(name);
            updatedB.setPriority(static_cast<Priority>(priority));
            updatedB.setCategoryId(categoryId);
            updatedB.setLimit(limit);
            updatedB.setSpent(spent);
            updatedB.setStartDate(start);
            updatedB.setEndDate(end);
            ok = DatabaseManager::instance().budgetDAO()->update(id, updatedB);
            break;
        }
    }
    
    if (ok) {
        DatabaseManager::instance().triggerDataChanged();
        refresh();
    }
    return ok;
}

bool BudgetsController::removeBudget(int id)
{
    bool ok = DatabaseManager::instance().budgetDAO()->remove(id);
    if (ok) {
        DatabaseManager::instance().triggerDataChanged();
        refresh();
    }
    return ok;
}

void BudgetsController::refresh()
{
    m_listDirty = true;
    emit budgetsListChanged();
    emit totalsChanged();
    emit categoriesChanged();
}

bool BudgetsController::exportToCSV(const QString &filePath)
{
    return DatabaseManager::instance().budgetDAO()->exportToCSV(filePath);
}