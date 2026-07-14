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
    //===========================CATEGORY SECTION=============================

    QVector<Category> m_categories;

    int generateNextCategoryId() const;

    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager() = default;

    //=============================BILL SECTION==================================




    //=============================BUDGET SECTION==================================




    //=============================SAVING SECTION==================================





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

    //=============================BILL SECTION==================================




    //=============================BUDGET SECTION==================================




    //=============================SAVING SECTION==================================





    //==========================TRANSACTION SECTION=================================
};

#endif // DATABASE_MANAGER_H