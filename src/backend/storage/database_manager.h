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
#include <QCoreApplication>
#include "../models/category.h"
#include "../models/bill.h"
#include "../models/budget.h"
#include "../models/saving.h"
#include "../models/transaction.h"

class DatabaseManager : public QObject {
    Q_OBJECT

private:

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
    QVector<Transaction*> m_transactions;
    int generateNextTransactionId() const;





public:

    explicit DatabaseManager(QObject *parent = nullptr): QObject(parent){}
    ~DatabaseManager() {
        qDeleteAll(m_transactions);
        m_transactions.clear();
    }

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

    void addUserCustomCategory(const QString& name, int parentId, bool active = true);
    void updateCategory(int id, const QString& name, int newParentId, bool active);
    void updateCategoryParent(int id, int newParentId);
    void removeCategory(int id);
    void migrateAndRemoveCategory(int sourceCatId, int targetCatId);
    void deactivateCategory(int id);

    //=============================BILL SECTION==================================
    void loadBillsFromCSV();
    void saveBillsToCSV() const;
    const QVector<Bill>& getAllBills() const { return m_bills; }
    void addBill(const Bill& b);
    void updateBill(int id, const Bill& b);
    void deleteBill(int id);

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
    // Thêm hũ tiết kiệm mới từ UI (id được tự sinh)
    void addSaving(const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate);
    // Sửa hũ tiết kiệm
    bool updateSaving(int savingId, const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate);
    // Góp tiền vào 1 hũ tiết kiệm theo id
    bool contributeToSaving(int savingId, double amount);
    // Xóa hũ tiết kiệm theo id
    bool deleteSaving(int savingId);



    //==========================TRANSACTION SECTION=================================
    void loadTransactionsFromCSV();
    void saveTransactionsToCSV() const;
    const QVector<Transaction*>& getAllTransactions() const { return m_transactions; }
    void addTransaction(Transaction* transaction);
    bool updateTransaction(int id, Transaction* newTransaction);
    bool deleteTransaction(int id);
};

#endif // DATABASE_MANAGER_H