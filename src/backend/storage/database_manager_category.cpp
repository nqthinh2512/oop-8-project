// database_manager_category.cpp
#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>

// Tìm ID lớn nhất hiện tại trong mảng để tự động cộng 1
int DatabaseManager::generateNextCategoryId() const {
    int maxId = 0;
    for (const Category& cat : m_categories) {
        if (cat.getId() > maxId) {
            maxId = cat.getId();
        }
    }
    return maxId + 1;
}

// 🎯 ĐỌC FILE CSV: Đọc id, name, parentId, active
void DatabaseManager::loadCategoriesFromCSV() {
    m_categories.clear();

    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/categories.csv";
    QFile file(fullPath);

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        if (!in.atEnd()) {
            in.readLine(); // Bỏ qua dòng tiêu đề
        }

        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (line.isEmpty()) continue;

            QStringList fields = line.split(",");
            if (fields.size() >= 3) {
                int id = fields[0].toInt();
                QString name = fields[1];
                int parentId = fields[2].toInt();
                bool active = (fields.size() >= 4) ? (fields[3].toInt() != 0) : true;

                m_categories.append(Category(id, parentId, name, active));
            }
        }
        file.close();
    }

    // 🌟 KHỞI TẠO DANH MỤC MẶC ĐỊNH CHUẨN NẾU FILE RỖNG
    if (m_categories.isEmpty()) {
        qDebug() << "Khởi tạo danh mục mặc định ban đầu...";
        int id = 1;
        // 1. Income (Parent 1)
        m_categories.append(Category(id++, 1, "Salary", true));
        m_categories.append(Category(id++, 1, "Freelance & Side Income", true));
        m_categories.append(Category(id++, 1, "Investment Returns", true));
        m_categories.append(Category(id++, 1, "Gifts & Allowances", true));

        // 2. Expense (Parent 2)
        m_categories.append(Category(id++, 2, "Food & Dining", true));
        m_categories.append(Category(id++, 2, "Housing & Rent", true));
        m_categories.append(Category(id++, 2, "Transportation & Fuel", true));
        m_categories.append(Category(id++, 2, "Utilities & Services", true));
        m_categories.append(Category(id++, 2, "Entertainment & Leisure", true));
        m_categories.append(Category(id++, 2, "Healthcare & Medical", true));

        // 3. Bill (Parent 3)
        m_categories.append(Category(id++, 3, "Electricity Bill", true));
        m_categories.append(Category(id++, 3, "Water Bill", true));
        m_categories.append(Category(id++, 3, "Internet & Cable", true));
        m_categories.append(Category(id++, 3, "Credit Card Bill", true));

        // 4. Budget (Parent 4)
        m_categories.append(Category(id++, 4, "Monthly Living Budget", true));
        m_categories.append(Category(id++, 4, "Discretionary Budget", true));

        // 5. Saving (Parent 5)
        m_categories.append(Category(id++, 5, "Emergency Savings", true));
        m_categories.append(Category(id++, 5, "Vacation Fund", true));

        saveCategoriesToCSV();
    }

    qDebug() << "Đã tải" << m_categories.size() << "danh mục từ categories.csv vào RAM.";
}

// 🎯 GHI FILE CSV: Ghi id, name, parentId, active
void DatabaseManager::saveCategoriesToCSV() const {
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/categories.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Không thể ghi dữ liệu vào file categories.csv!";
        return;
    }

    QTextStream out(&file);
    out << "id,name,parentId,active\n";

    for (const Category& cat : m_categories) {
        out << cat.getId() << ","
            << cat.getName() << ","
            << cat.getParentId() << ","
            << (cat.isActive() ? 1 : 0) << "\n";
    }
    file.close();
    const_cast<DatabaseManager*>(this)->emit dataChanged();
}

// 🎯 THÊM MỚI DANH MỤC TỪ UI
void DatabaseManager::addUserCustomCategory(const QString& name, int parentId, bool active) {
    int newId = generateNextCategoryId();
    Category newCat(newId, parentId, name, active);
    m_categories.append(newCat);
    saveCategoriesToCSV();
}

// 🎯 CHỈNH SỬA DANH MỤC
void DatabaseManager::updateCategory(int id, const QString& name, int newParentId, bool active) {
    for (Category& cat : m_categories) {
        if (cat.getId() == id) {
            cat = Category(id, newParentId, name, active);
            break;
        }
    }
    saveCategoriesToCSV();
}

void DatabaseManager::updateCategoryParent(int id, int newParentId) {
    for (Category& cat : m_categories) {
        if (cat.getId() == id) {
            cat.setParentId(newParentId);
            break;
        }
    }
    saveCategoriesToCSV();
}

void DatabaseManager::removeCategory(int id) {
    for (int i = 0; i < m_categories.size(); ++i) {
        if (m_categories[i].getId() == id) {
            m_categories.removeAt(i);
            break;
        }
    }
    saveCategoriesToCSV();
}

void DatabaseManager::migrateAndRemoveCategory(int sourceCatId, int targetCatId) {
    // 1. Re-assign linked budgets
    for (Budget& b : m_budgets) {
        if (b.getCategoryId() == sourceCatId) {
            b.setCategoryId(targetCatId);
        }
    }
    saveBudgetsToCSV();

    // 2. Remove category
    removeCategory(sourceCatId);
}

void DatabaseManager::deactivateCategory(int id) {
    for (Category& cat : m_categories) {
        if (cat.getId() == id) {
            cat.setActive(false);
            break;
        }
    }
    saveCategoriesToCSV();
}