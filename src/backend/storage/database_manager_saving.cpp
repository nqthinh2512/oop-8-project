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

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Không mở được file:" << fullPath << "- sẽ dùng dữ liệu mẫu tạm thời.";
    } else {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (line.trimmed().isEmpty())
                continue;

            // Cấu trúc 1 dòng mới: id;name;priority;categoryId;target;current;dueDate
            // Hoặc hỗ trợ cấu trúc cũ 6 phần: id;name;dueDate;target;current;categoryId
            QStringList f = line.split(';');
            if (f.size() >= 7) {
                int id            = f[0].toInt();
                QString name      = f[1];
                Priority p        = static_cast<Priority>(f[2].toInt());
                int categoryId    = f[3].toInt();
                double target     = f[4].toDouble();
                double current    = f[5].toDouble();
                QDate dueDate     = QDate::fromString(f[6], Qt::ISODate);

                m_savings.append(Saving(id, name, p, dueDate, target, current, categoryId));
            } else if (f.size() >= 6) {
                int id            = f[0].toInt();
                QString name      = f[1];
                QDate dueDate     = QDate::fromString(f[2], Qt::ISODate);
                double target     = f[3].toDouble();
                double current    = f[4].toDouble();
                int categoryId    = f[5].toInt();

                m_savings.append(Saving(id, name, Priority::High, dueDate, target, current, categoryId));
            }
        }
        file.close();
    }

    // khởi tạo dữ liệu __TẠM THỜI__ để test tính năng nếu file rỗng hoặc không đọc được
    if (m_savings.isEmpty()) {
        QDate today = QDate::currentDate();

        m_savings.append(Saving(1, "Emergency Fund", Priority::High, today.addMonths(6), 20000000.0, 1000000.0, 17));
        m_savings.append(Saving(2, "Summer Vacation Fund", Priority::Medium, today.addMonths(3), 5000000.0, 2000000.0, 18));

        saveSavingsToCSV();
    }

    qDebug() << "Đã tải" << m_savings.size() << "hũ tiết kiệm từ savings.csv vào RAM.";
}

void DatabaseManager::saveSavingsToCSV() const
{
    QString fullPath = QCoreApplication::applicationDirPath() + "/data/savings.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        qWarning() << "Không ghi được file:" << fullPath;
        return;
    }

    QTextStream out(&file);
    for (const Saving& s : m_savings) {
        out << s.getId() << ";"
            << s.getName() << ";"
            << static_cast<int>(s.getPriority()) << ";"
            << s.getCategoryId() << ";"
            << s.getTarget() << ";"
            << s.getCurrent() << ";"
            << s.getDueDate().toString(Qt::ISODate) << "\n";
    }
    file.close();
}

int DatabaseManager::generateNextSavingId() const
{
    int maxId = 0;
    for (const Saving& s : m_savings)
        maxId = std::max(maxId, s.getId());
    return maxId + 1;
}

void DatabaseManager::addSaving(const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate)
{
    int newId = generateNextSavingId();
    int catId = (categoryId == 0 ? Saving::parentCategory : categoryId);
    m_savings.append(Saving(newId, name, priority, dueDate, target, currentAmount, catId));
    saveSavingsToCSV();
}

bool DatabaseManager::updateSaving(int savingId, const QString& name, Priority priority, int categoryId, double target, double currentAmount, const QDate& dueDate)
{
    for (Saving& s : m_savings) {
        if (s.getId() == savingId) {
            s.setName(name);
            s.setPriority(priority);
            if (categoryId != 0) s.setCategoryId(categoryId);
            s.setTarget(target);
            s.setCurrent(currentAmount);
            s.setDueDate(dueDate);
            saveSavingsToCSV();
            return true;
        }
    }
    return false;
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