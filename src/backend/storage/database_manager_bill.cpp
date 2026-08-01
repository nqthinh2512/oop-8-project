// database_manager_bill.cpp
#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>

int DatabaseManager::generateNextBillId() const {
    int maxId = 0;
    for (const Bill& b : m_bills) {
        if (b.getId() > maxId) {
            maxId = b.getId();
        }
    }
    return maxId + 1;
}

// đọc file csv: Đọc id, name, amount, dueDate, categoryId, isPaid
void DatabaseManager::loadBillsFromCSV() {
    m_bills.clear();

    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/bills.csv";
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
            if (fields.size() >= 6) {
                int id = fields[0].toInt();
                QString name = fields[1];
                double amount = fields[2].toDouble();
                QDate dueDate = QDate::fromString(fields[3], Qt::ISODate);
                if (!dueDate.isValid()) dueDate = QDate::currentDate();
                int catId = fields[4].toInt();
                bool isPaid = (fields[5].toInt() != 0);

                m_bills.append(Bill(id, name, amount, dueDate, catId, isPaid));
            }
        }
        file.close();
    }

    // khởi tạo dữ liệu __TẠM THỜI__ để test tính năng
    if (m_bills.isEmpty()) {
        qDebug() << "Khởi tạo dữ liệu hóa đơn mẫu ban đầu...";
        int id = 1;
        QDate today = QDate::currentDate();

        m_bills.append(Bill(id++, "Electricity Bill", 650000.0, today.addDays(10), 11, false)); // Upcoming
        m_bills.append(Bill(id++, "Water Supply Bill", 180000.0, today.addDays(5), 12, false)); // Upcoming
        m_bills.append(Bill(id++, "High-Speed Internet", 250000.0, today.addDays(-2), 13, true)); // Paid
        m_bills.append(Bill(id++, "Netflix Subscription", 250000.0, today.addDays(-15), 13, true)); // Paid
        m_bills.append(Bill(id++, "Credit Card Bill", 1250000.0, today.addDays(-5), 11, false)); // Overdue
        m_bills.append(Bill(id++, "Gym Membership", 500000.0, today.addDays(-2), 11, false)); // Overdue
        m_bills.append(Bill(id++, "Car Insurance", 850000.0, today.addDays(-10), 12, false)); // Overdue
        m_bills.append(Bill(id++, "Phone Bill", 150000.0, today.addDays(-1), 13, false)); // Overdue
        saveBillsToCSV();
    }

    qDebug() << "Đã tải" << m_bills.size() << "hóa đơn từ bills.csv vào RAM.";
}

// ghi file csv: Ghi id, name, amount, dueDate, categoryId, isPaid
void DatabaseManager::saveBillsToCSV() const {
    QString dirPath = QCoreApplication::applicationDirPath() + "/data";
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/bills.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Không thể ghi dữ liệu vào file bills.csv!";
        return;
    }

    QTextStream out(&file);
    out << "id,name,amount,dueDate,categoryId,isPaid\n";

    for (const Bill& b : m_bills) {
        out << b.getId() << ","
            << b.getName() << ","
            << QString::number(b.getAmount(), 'f', 2) << ","
            << b.getDueDate().toString(Qt::ISODate) << ","
            << b.getCategoryId() << ","
            << (b.checkPaid() ? 1 : 0) << "\n";
    }
    file.close();
    const_cast<DatabaseManager*>(this)->emit dataChanged();
}

void DatabaseManager::addBill(const Bill& b) {
    Bill newBill = b;
    if (newBill.getId() <= 0) {
        newBill = Bill(generateNextBillId(), b.getName(), b.getAmount(), b.getDueDate(), b.getCategoryId(), b.checkPaid());
    }
    m_bills.append(newBill);
    saveBillsToCSV();
}

void DatabaseManager::updateBill(int id, const Bill& b) {
    for (int i = 0; i < m_bills.size(); ++i) {
        if (m_bills[i].getId() == id) {
            m_bills[i] = Bill(id, b.getName(), b.getAmount(), b.getDueDate(), b.getCategoryId(), b.checkPaid());
            saveBillsToCSV();
            return;
        }
    }
}

void DatabaseManager::deleteBill(int id) {
    for (int i = 0; i < m_bills.size(); ++i) {
        if (m_bills[i].getId() == id) {
            m_bills.removeAt(i);
            saveBillsToCSV();
            return;
        }
    }
}