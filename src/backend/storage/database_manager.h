#ifndef DATABASE_MANAGER_H
#define DATABASE_MANAGER_H

#include <vector>
#include "../models/transaction.h"
#include "../models/bill.h"
#include "../models/category.h"
#include "../models/budget.h"

class DatabaseManager {
public:
    DatabaseManager();
    ~DatabaseManager();

    // Các kho chứa dữ liệu tạm thời trong RAM của ứng dụng
    std::vector<Transaction> transactions;
    std::vector<Bill> bills;
    std::vector<Category> categories;
    std::vector<Budget> budgets;

    // Các hàm sườn (chưa viết logic) để sau này đọc/ghi file CSV
    bool loadDataFromStorage();
    bool saveDataToStorage();
};

#endif // DATABASE_MANAGER_H