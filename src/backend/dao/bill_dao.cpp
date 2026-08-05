#include "bill_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>

BillDAO::BillDAO() {
    loadFromCSV();
}

int BillDAO::generateNextId() const {
    int maxId = 0;
    for (const Bill& b : m_bills) {
        if (b.getId() > maxId) {
            maxId = b.getId();
        }
    }
    return maxId + 1;
}

const QVector<Bill>& BillDAO::getAll() const {
    return m_bills;
}

void BillDAO::add(const Bill& item) {
    Bill newBill = item;
    if (newBill.getId() <= 0) {
        newBill.setId(generateNextId());
    }
    m_bills.append(newBill);
    saveToCSV();
}

bool BillDAO::update(int id, const Bill& item) {
    for (int i = 0; i < m_bills.size(); ++i) {
        if (m_bills[i].getId() == id) {
            Bill b = item;
            b.setId(id);
            m_bills[i] = b;
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool BillDAO::remove(int id) {
    for (int i = 0; i < m_bills.size(); ++i) {
        if (m_bills[i].getId() == id) {
            m_bills.removeAt(i);
            saveToCSV();
            return true;
        }
    }
    return false;
}

void BillDAO::loadFromCSV() {
    m_bills.clear();

    QString dirPath = DatabaseManager::getDataDirectoryPath();
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

    if (m_bills.isEmpty()) {
        qDebug() << "Khởi tạo dữ liệu hóa đơn mẫu ban đầu...";
        int id = 1;
        QDate today = QDate::currentDate();

        m_bills.append(Bill(id++, "Electricity Bill", 650000.0, today.addDays(10), 11, false));
        m_bills.append(Bill(id++, "Water Supply Bill", 180000.0, today.addDays(5), 12, false));
        m_bills.append(Bill(id++, "High-Speed Internet", 250000.0, today.addDays(-2), 13, true));
        m_bills.append(Bill(id++, "Netflix Subscription", 250000.0, today.addDays(-15), 13, true));
        m_bills.append(Bill(id++, "Credit Card Bill", 1250000.0, today.addDays(-5), 11, false));
        m_bills.append(Bill(id++, "Gym Membership", 500000.0, today.addDays(-2), 11, false));
        m_bills.append(Bill(id++, "Car Insurance", 850000.0, today.addDays(-10), 12, false));
        m_bills.append(Bill(id++, "Phone Bill", 150000.0, today.addDays(-1), 13, false));
        saveToCSV();
    }
}

void BillDAO::saveToCSV() const {
    QString dirPath = DatabaseManager::getDataDirectoryPath();
    QDir dir(dirPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString fullPath = dirPath + "/bills.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
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
}

static QString resolveLocalPath(const QString& path) {
    QUrl url(path);
    if (url.isValid() && url.isLocalFile()) {
        return url.toLocalFile();
    }
    if (path.startsWith("file:", Qt::CaseInsensitive)) {
        return QUrl(path).toLocalFile();
    }
    return path;
}

bool BillDAO::exportToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
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
    return true;
}
