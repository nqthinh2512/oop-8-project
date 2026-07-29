// database_manager_budget.cpp
// File này CHỈ chứa phần định nghĩa (implementation) của các hàm thuộc
// BUDGET SECTION đã khai báo trong database_manager.h

#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QStringList>
#include <algorithm>

//=============================BUDGET SECTION==================================


void DatabaseManager::loadBudgetsFromCSV()
{
    m_budgets.clear();

    QString fullPath = QCoreApplication::applicationDirPath() + "/data/budgets.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return; // file chưa tồn tại (lần chạy đầu) -> giữ m_budgets rỗng

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (line.trimmed().isEmpty())
            continue;

        // Cấu trúc 1 dòng: id;name;priority;categoryId;limit;spent;startDate;endDate
        QStringList f = line.split(';');
        if (f.size() < 8)
            continue; // dòng lỗi định dạng -> bỏ qua

        int id             = f[0].toInt();
        QString name       = f[1];
        Priority priority  = static_cast<Priority>(f[2].toInt());
        int categoryId     = f[3].toInt();
        double limit       = f[4].toDouble();
        double spent       = f[5].toDouble();
        QDate startDate    = QDate::fromString(f[6], Qt::ISODate);
        QDate endDate      = QDate::fromString(f[7], Qt::ISODate);

        m_budgets.append(Budget(id, name, priority, categoryId, limit, startDate, endDate, spent));
    }
    qDebug() << "Đã tải" << m_budgets.size() << "danh mục từ budgets.CSV vào RAM.";
    file.close();
}

void DatabaseManager::saveBudgetsToCSV() const
{
    QString fullPath = QCoreApplication::applicationDirPath() + "/data/budgets.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate))
        return;

    QTextStream out(&file);
    for (const Budget& b : m_budgets) {
        out << b.getId() << ";"
            << b.getName() << ";"
            << static_cast<int>(b.getPriority()) << ";"
            << b.getCategoryId() << ";"
            << b.getLimit() << ";"
            << b.getSpent() << ";"
            << b.getStartDate().toString(Qt::ISODate) << ";"
            << b.getEndDate().toString(Qt::ISODate) << "\n";
    }
    file.close();
}

int DatabaseManager::generateNextBudgetId() const
{
    int maxId = 0;
    for (const Budget& b : m_budgets)
        maxId = std::max(maxId, b.getId());
    return maxId + 1;
}

void DatabaseManager::addBudget(const QString& name, Priority priority, int categoryId,
                                double limit, const QDate& startDate, const QDate& endDate)
{
    int newId = generateNextBudgetId();
    m_budgets.append(Budget(newId, name, priority, categoryId, limit, startDate, endDate, 0.0));
    saveBudgetsToCSV(); // ghi ngay xuống CSV để không mất dữ liệu nếu app đóng đột ngột
}

bool DatabaseManager::updateBudget(int budgetId, const QString& name, Priority priority, int categoryId,
                                   double limit, const QDate& startDate, const QDate& endDate)
{
    for (Budget& b : m_budgets) {
        if (b.getId() == budgetId) {
            // Dùng setter thay vì tạo Budget mới -> giữ nguyên spentAmount đang có
            b.setName(name);
            b.setPriority(priority);
            b.setCategoryId(categoryId);
            b.setLimit(limit);
            b.setStartDate(startDate);
            b.setEndDate(endDate);
            saveBudgetsToCSV();
            return true;
        }
    }
    return false; // không tìm thấy budgetId
}

bool DatabaseManager::deleteBudget(int budgetId)
{
    for (int i = 0; i < m_budgets.size(); ++i) {
        if (m_budgets[i].getId() == budgetId) {
            m_budgets.removeAt(i);
            saveBudgetsToCSV();
            return true;
        }
    }
    return false;
}

// Gọi hàm này từ database_manager_transaction.cpp (hoặc TransactionController)
// mỗi khi có giao dịch chi tiêu mới, để mọi ngân sách cùng categoryId tự cập
// nhật số tiền đã tiêu.
void DatabaseManager::addExpenseToBudget(int categoryId, double amount)
{
    bool changed = false;
    for (Budget& b : m_budgets) {
        if (b.getCategoryId() == categoryId) {
            b.addExpense(amount);
            changed = true;
        }
    }
    if (changed)
        saveBudgetsToCSV();
}
