#include "saving_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>

SavingDAO::SavingDAO() {
    loadFromCSV();
}

int SavingDAO::generateNextId() const {
    int maxId = 0;
    for (const Saving& s : m_savings) {
        if (s.getId() > maxId) {
            maxId = s.getId();
        }
    }
    return maxId + 1;
}

const QVector<Saving>& SavingDAO::getAll() const {
    return m_savings;
}

void SavingDAO::add(const Saving& item) {
    Saving newSaving = item;
    if (newSaving.getId() <= 0) {
        newSaving.setId(generateNextId());
    }
    m_savings.append(newSaving);
    saveToCSV();
}

bool SavingDAO::update(int id, const Saving& item) {
    for (int i = 0; i < m_savings.size(); ++i) {
        if (m_savings[i].getId() == id) {
            m_savings[i] = item;
            m_savings[i].setId(id);
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool SavingDAO::remove(int id) {
    for (int i = 0; i < m_savings.size(); ++i) {
        if (m_savings[i].getId() == id) {
            m_savings.removeAt(i);
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool SavingDAO::contributeToSaving(int savingId, double amount) {
    for (Saving& s : m_savings) {
        if (s.getId() == savingId) {
            s.contribute(amount); 
            saveToCSV();
            return true;
        }
    }
    return false;
}

void SavingDAO::loadFromCSV() {
    m_savings.clear();

    QString fullPath = DatabaseManager::getDataDirectoryPath() + "/savings.csv";
    QFile file(fullPath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Không mở được file:" << fullPath << "- sẽ dùng dữ liệu mẫu tạm thời.";
    } else {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (line.trimmed().isEmpty())
                continue;

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

    if (m_savings.isEmpty()) {
        QDate today = QDate::currentDate();

        m_savings.append(Saving(1, "Emergency Fund", Priority::High, today.addMonths(6), 20000000.0, 1000000.0, 17));
        m_savings.append(Saving(2, "Summer Vacation Fund", Priority::Medium, today.addMonths(3), 5000000.0, 2000000.0, 18));

        saveToCSV();
    }
}

void SavingDAO::saveToCSV() const {
    QString fullPath = DatabaseManager::getDataDirectoryPath() + "/savings.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        return;
    }

    QTextStream out(&file);
    for (const Saving& s : m_savings) {
        out << s.getId() << ";"
            << s.getName() << ";"
            << static_cast<int>(s.getPriority()) << ";"
            << s.getCategoryId() << ";"
            << QString::number(s.getTarget(), 'f', 2) << ";"
            << QString::number(s.getCurrent(), 'f', 2) << ";"
            << s.getDueDate().toString(Qt::ISODate) << "\n";
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

bool SavingDAO::exportToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }

    QTextStream out(&file);
    for (const Saving& s : m_savings) {
        out << s.getId() << ";"
            << s.getName() << ";"
            << static_cast<int>(s.getPriority()) << ";"
            << s.getCategoryId() << ";"
            << QString::number(s.getTarget(), 'f', 2) << ";"
            << QString::number(s.getCurrent(), 'f', 2) << ";"
            << s.getDueDate().toString(Qt::ISODate) << "\n";
    }
    file.close();
    return true;
}
