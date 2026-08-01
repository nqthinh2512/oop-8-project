// database_manager_saving.cpp
// File này CHỈ chứa phần định nghĩa (implementation) của các hàm thuộc
// SAVING SECTION đã khai báo trong database_manager.h

#include "database_manager.h"
#include <QFile>
#include <QTextStream>
#include <QStringList>
#include <algorithm>

//=============================SAVING SECTION==================================

void DatabaseManager::loadSavingsFromCSV()
{
    m_savings.clear();

    QString fullPath = QCoreApplication::applicationDirPath() + "/data/savings.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (line.trimmed().isEmpty())
            continue;

        // Cấu trúc 1 dòng: id;name;dueDate;target;current;categoryId
        QStringList f = line.split(';');
        if (f.size() < 6)
            continue;

        int id            = f[0].toInt();
        QString name      = f[1];
        QDate dueDate     = QDate::fromString(f[2], Qt::ISODate);
        double target     = f[3].toDouble();
        double current    = f[4].toDouble();
        int categoryId    = f[5].toInt();

        m_savings.append(Saving(id, name, dueDate, target, current, categoryId));
    }
    file.close();

    // khởi tạo dữ liệu __TẠM THỜI__ để test tính năng
    if (m_savings.isEmpty()) {
        QDate today = QDate::currentDate();

        m_savings.append(Saving(1, "Emergency Fund", today.addMonths(6), 10000000.0, 4500000.0, 17));
        m_savings.append(Saving(2, "Summer Vacation Fund", today.addMonths(3), 5000000.0, 2000000.0, 18));

        saveSavingsToCSV();
    }

    qDebug() << "Đã tải" << m_savings.size() << "hũ tiết kiệm từ savings.csv vào RAM.";
}

void DatabaseManager::saveSavingsToCSV() const
{
    QString fullPath = QCoreApplication::applicationDirPath() + "/data/savings.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate))
        return;

    QTextStream out(&file);
    for (const Saving& s : m_savings) {
        out << s.getId() << ";"
            << s.getName() << ";"
            << s.getDueDate().toString(Qt::ISODate) << ";"
            << s.getTarget() << ";"
            << s.getCurrent() << ";"
            << s.getCategoryId() << "\n";
    }
    file.close();
    const_cast<DatabaseManager*>(this)->emit dataChanged();
}

int DatabaseManager::generateNextSavingId() const
{
    int maxId = 0;
    for (const Saving& s : m_savings)
        maxId = std::max(maxId, s.getId());
    return maxId + 1;
}

void DatabaseManager::addSaving(const QString& name, const QDate& dueDate, double target)
{
    int newId = generateNextSavingId();
    m_savings.append(Saving(newId, name, dueDate, target, 0.0, Saving::parentCategory));
    saveSavingsToCSV();
}

bool DatabaseManager::contributeToSaving(int savingId, double amount)
{
    for (Saving& s : m_savings) {
        if (s.getId() == savingId) {
            s.contribute(amount); // logic chặn vượt target nằm sẵn trong Saving::contribute
            saveSavingsToCSV();
            return true;
        }
    }
    return false;
}

bool DatabaseManager::deleteSaving(int savingId)
{
    for (int i = 0; i < m_savings.size(); ++i) {
        if (m_savings[i].getId() == savingId) {
            m_savings.removeAt(i);
            saveSavingsToCSV();
            return true;
        }
    }
    return false;
}