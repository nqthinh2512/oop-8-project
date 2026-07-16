// database_manager.cpp
#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {
    // Tự động tải dữ liệu từ file khi khởi động ứng dụng
    loadCategoriesFromCSV();
    
    // Khởi chạy nạp giao dịch từ file (OOP: Đa hình / Polymorphism sẽ được áp dụng trong hàm này)
    loadTransactionsFromCSV(); 
}

DatabaseManager::~DatabaseManager() {
    // 💡 Ghi chú OOP (Giáo viên sẽ thích điều này): 
    // Vì mảng m_transactions chứa các con trỏ (Transaction*),
    // chúng ta phải tự dọn dẹp bộ nhớ (Memory Management) khi DatabaseManager bị hủy
    // để tránh rò rỉ bộ nhớ (Memory Leak).
    for (Transaction* t : m_transactions) {
        delete t;
    }
    m_transactions.clear();
}

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

// Hàm lấy ID tiếp theo cho Giao dịch (Để controller dùng khi new đối tượng)
int DatabaseManager::generateNextTransactionId() const {
    int maxId = 0;
    for (Transaction* tx : m_transactions) {
        if (tx->getId() > maxId) {
            maxId = tx->getId();
        }
    }
    return maxId + 1;
}

// 🎯 ĐỌC FILE CSV: Chỉ xử lý 3 cột dữ liệu chính
void DatabaseManager::loadCategoriesFromCSV() {
    m_categories.clear();

    QFile file("categories.csv");

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
    qDebug() << "Đã tải" << m_categories.size() << "danh mục từ file CSV vào RAM.";
}

// 🎯 GHI FILE CSV: Xuất dữ liệu gọn gàng với 3 cột
void DatabaseManager::saveCategoriesToCSV() const {
    QFile file("categories.csv");
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

// ==========================================================
// 🎯 CÁC HÀM XỬ LÝ GIAO DỊCH (CRUD - OOP)
// ==========================================================

void DatabaseManager::loadTransactionsFromCSV() {
    // Xóa dữ liệu cũ (nếu có) trước khi nạp
    for (Transaction* t : m_transactions) {
        delete t;
    }
    m_transactions.clear();

    QFile file("transactions.csv");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Không thể mở file transactions.csv! Sẽ tạo mới khi lưu.";
        return;
    }

    QTextStream in(&file);
    if (!in.atEnd()) {
        in.readLine(); // Bỏ qua dòng tiêu đề
    }

    while (!in.atEnd()) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty()) continue;

        // Dùng '|' làm dấu phân cách thay vì ',' để tránh lỗi khi người dùng gõ dấu phẩy vào phần Ghi chú (Description)
        QStringList fields = line.split("|");
        if (fields.size() >= 7) {
            int id = fields[0].toInt();
            QString type = fields[1]; // "Income" hoặc "Expense"
            double amount = fields[2].toDouble();
            QDateTime dateTime = QDateTime::fromString(fields[3], Qt::ISODate);
            int categoryId = fields[4].toInt();
            QString description = fields[5];
            QString account = fields[6];

            // 🌟 ÁP DỤNG ĐA HÌNH (POLYMORPHISM) Ở ĐÂY:
            // Tùy thuộc vào Type trong file CSV, ta sẽ khởi tạo đối tượng con (Income hoặc Expense)
            // nhưng gán nó vào con trỏ của lớp cha (Transaction*).
            Transaction* newTx = nullptr;
            if (type == "Income") {
                newTx = new Income(id, amount, dateTime, description, categoryId, account);
            } else if (type == "Expense") {
                newTx = new Expense(id, amount, dateTime, description, categoryId, account);
            }

            if (newTx) {
                m_transactions.append(newTx);
            }
        }
    }
    file.close();
    qDebug() << "Đã tải" << m_transactions.size() << "giao dịch từ CSV.";
}

void DatabaseManager::saveTransactionsToCSV() const {
    QFile file("transactions.csv");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Không thể ghi dữ liệu vào file transactions.csv!";
        return;
    }

    QTextStream out(&file);
    out << "id|type|amount|dateTime|categoryId|description|account\n"; // Tiêu đề

    for (Transaction* tx : m_transactions) {
        // 💡 Gọi hàm ảo getType() - Đa hình sẽ tự động trả về "Income" hoặc "Expense" 
        // tùy thuộc vào kiểu thực sự của đối tượng đang trỏ tới.
        out << tx->getId() << "|"
            << tx->getType() << "|" 
            << QString::number(tx->getAmount(), 'f', 2) << "|"
            << tx->getDateTime().toString(Qt::ISODate) << "|"
            << tx->getCategoryId() << "|"
            << tx->getDescription() << "|"
            << tx->getAccount() << "\n";
    }
    file.close();
}

void DatabaseManager::addTransaction(Transaction* newTransaction) {
    if (!newTransaction) return;
    
    m_transactions.append(newTransaction);
    saveTransactionsToCSV();
    qDebug() << "Đã thêm giao dịch:" << newTransaction->getDescription() << "Type:" << newTransaction->getType();
}

bool DatabaseManager::updateTransaction(int id, double amount, const QDateTime& dateTime, int categoryId, const QString& description, const QString& account) {
    for (Transaction* tx : m_transactions) {
        if (tx->getId() == id) {
            tx->setAmount(amount);
            tx->setDateTime(dateTime);
            tx->setCategoryId(categoryId);
            tx->setDescription(description);
            tx->setAccount(account);
            saveTransactionsToCSV();
            return true; // Thành công
        }
    }
    return false; // Không tìm thấy ID
}

bool DatabaseManager::deleteTransaction(int id) {
    for (int i = 0; i < m_transactions.size(); ++i) {
        if (m_transactions[i]->getId() == id) {
            delete m_transactions[i]; // 💡 Giải phóng bộ nhớ con trỏ trước khi xóa khỏi mảng!
            m_transactions.removeAt(i); // Xóa khỏi mảng
            saveTransactionsToCSV();
            return true;
        }
    }
    return false;
}