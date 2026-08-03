#ifndef BUDGETS_CONTROLLER_H
#define BUDGETS_CONTROLLER_H
#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include "../backend/storage/database_manager.h"
class BudgetsController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList budgetsList READ budgetsList NOTIFY budgetsListChanged)
    Q_PROPERTY(QVariantList categoryOptions READ categoryOptions NOTIFY categoriesChanged)
    Q_PROPERTY(QString searchText READ searchText WRITE setSearchText NOTIFY filterChanged)
    // -1 = All, còn lại là giá trị enum Priority của backend (Low=0, Medium=1, High=2)
    Q_PROPERTY(int priorityFilter READ priorityFilter WRITE setPriorityFilter NOTIFY filterChanged)
    // 0 = "All Main Categories", còn lại là categoryId thật
    Q_PROPERTY(int categoryFilter READ categoryFilter WRITE setCategoryFilter NOTIFY filterChanged)
    Q_PROPERTY(QString totalSpentText READ totalSpentText NOTIFY totalsChanged)
    Q_PROPERTY(QString totalLimitText READ totalLimitText NOTIFY totalsChanged)
    Q_PROPERTY(QString totalRemainingText READ totalRemainingText NOTIFY totalsChanged)
private:
    QString m_searchText;
    int m_priorityFilter = -1;
    int m_categoryFilter = 0;
    // Cache danh sách đã lọc: budgetsList() được QML gọi rất thường xuyên (mỗi lần
    // binding re-evaluate), nếu dữ liệu/filter chưa đổi thì trả lại bản đã tính sẵn
    // thay vì quét + build QVariantMap lại từ đầu mỗi lần.
    mutable QVariantList m_cachedList;
    mutable bool m_listDirty = true;
public:
    explicit BudgetsController(QObject *parent = nullptr);
    QVariantList budgetsList() const;
    QVariantList categoryOptions() const; // danh mục con thuộc gốc "Budget" (parentId == 4)
    QString searchText() const { return m_searchText; }
    void setSearchText(const QString &text);
    int priorityFilter() const { return m_priorityFilter; }
    void setPriorityFilter(int filter);
    int categoryFilter() const { return m_categoryFilter; }
    void setCategoryFilter(int filter);
    QString totalSpentText() const;
    QString totalLimitText() const;
    QString totalRemainingText() const;
    // priority: giá trị enum Priority backend (0=Low,1=Medium,2=High)
    // startDateStr / endDateStr: định dạng "dd/MM/yyyy" (đúng định dạng Date_Input_Field_1 trả về)
    Q_INVOKABLE bool addBudget(const QString &name, int priority, int categoryId,
                               double limit, double initialSpent,
                               const QString &startDateStr, const QString &endDateStr);
    Q_INVOKABLE bool updateBudget(int id, const QString &name, int priority, int categoryId,
                                  double limit, const QString &startDateStr, const QString &endDateStr);
    Q_INVOKABLE bool removeBudget(int id);
    Q_INVOKABLE void refresh();
    Q_INVOKABLE bool exportToCSV(const QString &filePath);
signals:
    void budgetsListChanged(); // danh sách hiển thị: đổi khi filter đổi HOẶC khi dữ liệu ngân sách đổi
    void totalsChanged();      // 3 ô tổng quan: chỉ đổi khi dữ liệu ngân sách THẬT SỰ đổi (add/update/remove)
    void categoriesChanged();  // danh sách category cho dropdown: hiếm khi đổi, không phụ thuộc filter
    void filterChanged();      // giá trị filter hiện tại (để QML tô màu nút đang được chọn)
};
#endif // BUDGETS_CONTROLLER_H
