#pragma once
#include <QObject>
#include <QList>
#include <QDate>
#include "../../backend/models/budget.h"
#include "../../backend/storage/database_manager.h"

// Controller xử lý logic cho TAB NGÂN SÁCH.
// Không được viết layout/widget ở đây - chỉ logic (đúng nguyên tắc tách tầng của project).
class BudgetsController : public QObject
{
    Q_OBJECT
public:
    explicit BudgetsController(DatabaseManager* dbManager, QObject* parent = nullptr);

    // Trả về danh sách ngân sách ĐÃ áp bộ lọc hiện tại -> GUI chỉ việc render
    QList<Budget> getFilteredBudgets() const;

    // ---- CRUD ----
    bool createBudget(const QString& name, Priority priority, int categoryId,
                      double limit, const QDate& startDate, const QDate& endDate);
    bool editBudget(int budgetId, const QString& name, Priority priority, int categoryId,
                    double limit, const QDate& startDate, const QDate& endDate);
    bool removeBudget(int budgetId);

    // ---- Filter ----
    void setCategoryFilter(int categoryId);   // truyền -1 = không lọc, lấy tất cả danh mục
    void setDateRangeFilter(const QDate& from, const QDate& to);
    void clearFilters();

    // ---- Helper cho GUI ----
    static QString statusToColorHex(BudgetStatus status); // map trạng thái -> mã màu hiển thị

signals:
    void budgetsChanged(); // GUI kết nối (connect) signal này để tự reload danh sách khi có thay đổi

private:
    DatabaseManager* db;        // controller không sở hữu, được MainWindow truyền vào (dependency injection)
    int filterCategoryId = -1;  // -1 nghĩa là "tất cả danh mục"
    QDate filterFrom;
    QDate filterTo;

    QList<Budget> loadAll() const; // đọc toàn bộ ngân sách từ database_manager
};