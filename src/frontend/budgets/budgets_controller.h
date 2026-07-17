#ifndef BUDGETS_CONTROLLER_H
#define BUDGETS_CONTROLLER_H

#include <QObject>
#include <QList>
#include <QString>
#include <QDate>
#include "../../backend/models/budget.h"          // Budget, Priority, BudgetStatus
#include "../../backend/storage/database_manager.h" // DatabaseManager

class BudgetsController : public QObject
{
    Q_OBJECT
public:
    explicit BudgetsController(DatabaseManager* dbManager, QObject* parent = nullptr);

    // Lấy toàn bộ ngân sách từ DatabaseManager (chưa lọc)
    QList<Budget> loadAll() const;

    // Lấy danh sách ngân sách đã áp dụng bộ lọc hiện tại (danh mục + khoảng thời gian)
    QList<Budget> getFilteredBudgets() const;

    // Tạo mới một ngân sách, trả về true nếu thành công
    bool createBudget(const QString& name, Priority priority, int categoryId,
                      double limit, const QDate& startDate, const QDate& endDate);

    // Sửa một ngân sách đã có (giữ nguyên số tiền đã chi), trả về true nếu thành công
    bool editBudget(int budgetId, const QString& name, Priority priority, int categoryId,
                    double limit, const QDate& startDate, const QDate& endDate);

    // Xóa một ngân sách theo id, trả về true nếu thành công
    bool removeBudget(int budgetId);

    // Thiết lập bộ lọc theo danh mục (-1 = không lọc)
    void setCategoryFilter(int categoryId);

    // Thiết lập bộ lọc theo khoảng thời gian
    void setDateRangeFilter(const QDate& from, const QDate& to);

    // Xóa hết bộ lọc hiện tại
    void clearFilters();

    // Chuyển trạng thái ngân sách (Safe/Warning/Danger/Over) sang mã màu hex để GUI tô màu
    static QString statusToColorHex(BudgetStatus status);

signals:
    // Phát ra mỗi khi dữ liệu ngân sách hoặc bộ lọc thay đổi, để GUI biết mà load lại danh sách
    void budgetsChanged();

private:
    DatabaseManager* db;

    // Trạng thái bộ lọc hiện tại
    int filterCategoryId = -1;   // -1 nghĩa là không lọc theo danh mục
    QDate filterFrom;            // không hợp lệ (isValid() == false) nghĩa là không giới hạn từ ngày nào
    QDate filterTo;              // không hợp lệ (isValid() == false) nghĩa là không giới hạn đến ngày nào
};

#endif // BUDGETS_CONTROLLER_H