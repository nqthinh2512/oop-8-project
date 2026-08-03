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
        emit budgetsListChanged();
    });
}

QVariantList BudgetsController::budgetsList() const
{
    if (!m_listDirty) return m_cachedList;

    const auto &allBudgets = DatabaseManager::instance().getAllBudgets();
    const auto &allCategories = DatabaseManager::instance().getAllCategories();

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
    const auto &allCategories = DatabaseManager::instance().getAllCategories();
    for (const auto &c : allCategories) {
        if (c.getParentId() != 4) continue; // chỉ lấy danh mục con thuộc gốc "Budget"
        QVariantMap m;
        m["id"] = c.getId();
        m["name"] = c.getName();
        list.append(m);
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
    for (const auto &b : DatabaseManager::instance().getAllBudgets()) total += b.getSpent();
    return formatVnd(total);
}

QString BudgetsController::totalLimitText() const
{
    double total = 0;
    for (const auto &b : DatabaseManager::instance().getAllBudgets()) total += b.getLimit();
    return formatVnd(total);
}

QString BudgetsController::totalRemainingText() const
{
    double spent = 0, limit = 0;
    for (const auto &b : DatabaseManager::instance().getAllBudgets()) {
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

    DatabaseManager::instance().addBudget(name, static_cast<Priority>(priority), categoryId, limit, start, end);

    //DatabaseManager::addBudget() luôn tạo spentAmount = 0.
    if (initialSpent > 0) {
        DatabaseManager::instance().addExpenseToBudget(categoryId, initialSpent);
    }

    refresh();
    return true;
}

bool BudgetsController::updateBudget(int id, const QString &name, int priority, int categoryId,
                                     double limit, const QString &startDateStr, const QString &endDateStr)
{
    if (name.trimmed().isEmpty() || limit <= 0) return false;

    QDate start = QDate::fromString(startDateStr, "dd/MM/yyyy");
    QDate end = QDate::fromString(endDateStr, "dd/MM/yyyy");
    if (!start.isValid() || !end.isValid() || end <= start) return false;

    bool ok = DatabaseManager::instance().updateBudget(id, name, static_cast<Priority>(priority),
                                                       categoryId, limit, start, end);
    if (ok) refresh();
    return ok;
}

bool BudgetsController::removeBudget(int id)
{
    bool ok = DatabaseManager::instance().deleteBudget(id);
    if (ok) refresh();
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
    return DatabaseManager::instance().exportBudgetsToCSV(filePath);
}