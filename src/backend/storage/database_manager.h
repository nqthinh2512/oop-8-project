// database_manager.h
#ifndef DATABASE_MANAGER_H
#define DATABASE_MANAGER_H

/*
 * Đây sẽ là nơi mng khai báo các hàm/biến backend gì gì đó cho phần của mình
 * Để nhắc lại đây sẽ CHỈ LÀ NƠI để khai báo, còn để viết logic ra hoàn chỉnh hãy vào file .cpp tương ứng để sửa
 * Và có lý do tại sao tui mới để nhiều comment đến vậy, để còn đường đọc code cho hiểu nữa
*/

#include <QObject>
#include <QVector>
#include <QString>
#include "../models/category.h"
#include "../models/bill.h"
#include "../models/budget.h"
#include "../models/saving.h"
#include "../models/transaction.h"

class DatabaseManager : public QObject {
    Q_OBJECT

private:

    explicit DatabaseManager(QObject *parent = nullptr): QObject(parent){
        loadBillsFromCSV();
        loadCategoriesFromCSV();
        loadBudgetsFromCSV();
        loadSavingsFromCSV();
    }
    ~DatabaseManager() = default;

    //===========================CATEGORY SECTION=============================

    QVector<Category> m_categories;

    int generateNextCategoryId() const;


    //=============================BILL SECTION==================================

    QVector<Bill> m_bills;
    int generateNextBillId() const;


    //=============================BUDGET SECTION==================================
    QVector<Budget> m_budgets;
    int generateNextBudgetId() const;

    //=============================SAVING SECTION==================================
    QVector<Saving> m_savings;
    int generateNextSavingId() const;





    //==========================TRANSACTION SECTION=================================





public:

    // Hàm lấy instance duy nhất để sử dụng toàn hệ thống
    static DatabaseManager& instance() {
        static DatabaseManager instance;
        return instance;
    }

    // Ngăn chặn sao chép dữ liệu database
    DatabaseManager(const DatabaseManager&) = delete;
    DatabaseManager& operator=(const DatabaseManager&) = delete;

    //=============================CATEGORY SECTION================================

    // Đọc và Ghi file CSV
    void loadCategoriesFromCSV();
    void saveCategoriesToCSV() const;

    // API lấy danh sách danh mục cấp cho giao diện UI hiển thị
    const QVector<Category>& getAllCategories() const { return m_categories; }

    // Hàm thêm danh mục tùy chỉnh từ Giao diện (UI truyền: Tên, và Root ID từ 1 đến 5)
    void addUserCustomCategory(const QString& name, int parentId);

    void updateCategoryParent(int id, int newParentId);
    void removeCategory(int id);

    //=============================BILL SECTION==================================


    // Đọc và Ghi file CSV
    void loadBillsFromCSV();
    void saveBillsToCSV();
    // API lấy danh sách các hóa đơn cho giao diện UI hiển thị
    const QVector<Bill>& getAllBill() const { return m_bills; }
    // Thêm hóa đơn mới từ UI (id được tự sinh)
    void addBill(const QString& name, double amount, const QDate& dueDate);
    // Sửa thông tin hóa đơn đã có
    bool updateBill(int billId, const QString& name, double amount, const QDate& dueDate);
    // Xóa hóa đơn theo id
    bool deleteBill(int billId);
    // Trả tiền hóa đơn
    void payBill(int billId);

    //=============================BUDGET SECTION==================================
    // Đọc và Ghi file CSV
    void loadBudgetsFromCSV();
    void saveBudgetsToCSV() const;
    // API lấy danh sách ngân sách cấp cho giao diện UI hiển thị
    const QVector<Budget>& getAllBudgets() const { return m_budgets; }
    // Thêm ngân sách mới từ UI (id được tự sinh, spentAmount bắt đầu = 0)
    void addBudget(const QString& name, Priority priority, int categoryId,
                   double limit, const QDate& startDate, const QDate& endDate);
    // Sửa thông tin ngân sách đã có (giữ nguyên spentAmount hiện tại, không reset)
    bool updateBudget(int budgetId, const QString& name, Priority priority, int categoryId,
                      double limit, const QDate& startDate, const QDate& endDate);
    // Xóa ngân sách theo id
    bool deleteBudget(int budgetId);
    // Cộng dồn 1 khoản chi vào (các) ngân sách có cùng categoryId
    // (hàm này sẽ được TransactionController gọi mỗi khi user tạo 1 giao dịch chi tiêu mới)
    void addExpenseToBudget(int categoryId, double amount);

    //=============================SAVING SECTION==================================
    // Đọc và Ghi file CSV
    void loadSavingsFromCSV();
    void saveSavingsToCSV() const;
    // API lấy danh sách hũ tiết kiệm cấp cho giao diện UI hiển thị
    const QVector<Saving>& getAllSavings() const { return m_savings; }
    // Thêm hũ tiết kiệm mới từ UI (id được tự sinh, currentAmount bắt đầu = 0)
    void addSaving(const QString& name, const QDate& dueDate, double target);
    // Góp tiền vào 1 hũ tiết kiệm theo id
    bool contributeToSaving(int savingId, double amount);
    // Xóa hũ tiết kiệm theo id
    bool deleteSaving(int savingId);






    //==========================TRANSACTION SECTION=================================
};

#endif // DATABASE_MANAGER_H