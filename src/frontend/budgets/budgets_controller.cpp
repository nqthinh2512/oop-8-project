#include "budgets_controller.h"

BudgetsController::BudgetsController(DatabaseManager* dbManager, QObject* parent)
    : QObject(parent), db(dbManager)
{
}

QList<Budget> BudgetsController::loadAll() const
{
    return db->loadAllBudgets();
}

QList<Budget> BudgetsController::getFilteredBudgets() const
{
    QList<Budget> all = loadAll();
    QList<Budget> filtered;

    for (const Budget& b : all) {
        // Lọc theo danh mục: nếu filterCategoryId = -1 thì bỏ qua bước lọc này
        if (filterCategoryId != -1 && b.getCategoryId() != filterCategoryId)
            continue;

        // Lọc theo khoảng thời gian: giữ lại ngân sách có khoảng thời gian
        // GIAO NHAU với khoảng filter (không cần trùng khớp tuyệt đối)
        if (filterFrom.isValid() && b.getEndDate() < filterFrom)
            continue;
        if (filterTo.isValid() && b.getStartDate() > filterTo)
            continue;

        filtered.append(b);
    }
    return filtered;
}

bool BudgetsController::createBudget(const QString& name, Priority priority, int categoryId,
                                     double limit, const QDate& startDate, const QDate& endDate)
{
    // id = 0 -> báo cho DatabaseManager biết đây là bản ghi mới, cần tự sinh id
    Budget newBudget(0, name, priority, categoryId, limit, startDate, endDate, 0.0);
    bool ok = db->addBudget(newBudget);
    if (ok)
        emit budgetsChanged(); // báo GUI reload lại danh sách
    return ok;
}

bool BudgetsController::editBudget(int budgetId, const QString& name, Priority priority, int categoryId,
                                   double limit, const QDate& startDate, const QDate& endDate)
{
    QList<Budget> all = loadAll();
    for (const Budget& b : all) {
        if (b.getId() == budgetId) {
            // Giữ nguyên spentAmount cũ - sửa ngân sách không được reset số tiền đã tiêu
            Budget updated(budgetId, name, priority, categoryId, limit, startDate, endDate, b.getSpent());
            bool ok = db->updateBudget(updated);
            if (ok)
                emit budgetsChanged();
            return ok;
        }
    }
    return false; // không tìm thấy budgetId
}

bool BudgetsController::removeBudget(int budgetId)
{
    bool ok = db->deleteBudget(budgetId);
    if (ok)
        emit budgetsChanged();
    return ok;
}

void BudgetsController::setCategoryFilter(int categoryId)
{
    filterCategoryId = categoryId;
    emit budgetsChanged();
}

void BudgetsController::setDateRangeFilter(const QDate& from, const QDate& to)
{
    filterFrom = from;
    filterTo = to;
    emit budgetsChanged();
}

void BudgetsController::clearFilters()
{
    filterCategoryId = -1;
    filterFrom = QDate();
    filterTo = QDate();
    emit budgetsChanged();
}

// Ngưỡng màu khớp với BudgetStatus trong budget.h (Safe/Warning/Danger/Over)
QString BudgetsController::statusToColorHex(BudgetStatus status)
{
    switch (status) {
    case BudgetStatus::Safe:    return "#4CAF50"; // xanh lá - tiêu ít
    case BudgetStatus::Warning: return "#FFC107"; // vàng - tiêu vừa
    case BudgetStatus::Danger:  return "#FF9800"; // cam - sắp hết
    case BudgetStatus::Over:    return "#F44336"; // đỏ - đã vượt
    }
    return "#4CAF50";
}