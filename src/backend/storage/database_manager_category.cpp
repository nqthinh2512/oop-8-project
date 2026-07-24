// database_manager.cpp
#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

// Hàm tìm ID lớn nhất hiện tại trong mảng để tự động cộng 1 cho phần tử tiếp theo
int DatabaseManager::generateNextCategoryId() const {
    int maxId = 0;
    for (const Category& cat : m_categories) {
        if (cat.getId() > maxId) {
            maxId = cat.getId();
        }
    }
    return maxId + 1;
}

// 🎯 ĐỌC FILE CSV: Chỉ xử lý 3 cột dữ liệu chính
void DatabaseManager::loadCategoriesFromCSV() {
    m_categories.clear();

    QString fullPath = QCoreApplication::applicationDirPath() + "/data/categories.csv";
    QFile file(fullPath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Không thể mở file categories.csv! Khởi tạo danh sách rỗng.";
        return;
    }

    QTextStream in(&file);

    // Bỏ qua dòng tiêu đề cột đầu tiên (id,name,parentId)
    if (!in.atEnd()) {
        in.readLine();
    }

    // Đọc từng dòng dữ liệu cho đến khi hết file
    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty()) continue; // Bỏ qua nếu có dòng trống

        QStringList fields = line.split(",");
        if (fields.size() >= 3) {
            int id = fields[0].toInt();
            QString name = fields[1];
            int parentId = fields[2].toInt();

            // Khôi phục đối tượng Category (Chỉ nhận 3 tham số)
            m_categories.append(Category(id, parentId, name));
        }
    }
    file.close();
    qDebug() << "Đã tải" << m_categories.size() << "danh mục từ categories.CSV vào RAM.";
}

// 🎯 GHI FILE CSV: Xuất dữ liệu gọn gàng với 3 cột
void DatabaseManager::saveCategoriesToCSV() const {
    QString fullPath = QCoreApplication::applicationDirPath() + "/data/categories.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Không thể ghi dữ liệu vào file categories.csv!";
        return;
    }

    QTextStream out(&file);
    out << "id,name,parentId\n"; // Tiêu đề cột tối giản

    // Lặp qua mảng và ghi thô xuống file text
    for (const Category& cat : m_categories) {
        out << cat.getId() << ","
            << cat.getName() << ","
            << cat.getParentId() << "\n";
    }
    file.close();
}

// 🎯 THÊM MỚI DANH MỤC: Do ứng dụng tự tính toán ID và lưu ngay lập tức
void DatabaseManager::addUserCustomCategory(const QString& name, int parentId) {
    int newId = generateNextCategoryId();

    // Tạo đối tượng danh mục mới với 3 thông tin cơ bản
    Category newCat(newId, parentId, name);

    m_categories.append(newCat);

    // Lưu ngay xuống file để tránh mất dữ liệu khi tắt app đột ngột
    saveCategoriesToCSV();
    qDebug() << "Đã tạo danh mục mới thành công! Tên:" << name << "| ID:" << newId << "| Thuộc nhóm gốc:" << parentId;
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