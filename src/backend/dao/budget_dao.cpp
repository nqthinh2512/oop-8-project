#include "budget_dao.h"
#include "../storage/database_manager.h" // For getDataDirectoryPath
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QDebug>
#include <QUrl>

BudgetDAO::BudgetDAO() {
    loadFromCSV();
}

int BudgetDAO::generateNextId() const {
    int maxId = 0;
    for (const Budget& b : m_budgets) {
        if (b.getId() > maxId) {
            maxId = b.getId();
        }
    }
    return maxId + 1;
}

const QVector<Budget>& BudgetDAO::getAll() const {
    return m_budgets;
}

void BudgetDAO::add(const Budget& item) {
    Budget newItem = item;
    if (newItem.getId() <= 0) {
        newItem.setId(generateNextId());
    }
    m_budgets.append(newItem);
    saveToCSV();
}

bool BudgetDAO::update(int id, const Budget& item) {
    for (int i = 0; i < m_budgets.size(); ++i) {
        if (m_budgets[i].getId() == id) {
            m_budgets[i] = item;
            m_budgets[i].setId(id);
            saveToCSV();
            return true;
        }
    }
    return false;
}

bool BudgetDAO::remove(int id) {
    for (int i = 0; i < m_budgets.size(); ++i) {
        if (m_budgets[i].getId() == id) {
            m_budgets.removeAt(i);
            saveToCSV();
            return true;
        }
    }
    return false;
}

void BudgetDAO::addExpenseToBudget(int categoryId, double amount) {
    bool changed = false;
    for (Budget& b : m_budgets) {
        if (b.getCategoryId() == categoryId) {
            b.addExpense(amount);
            changed = true;
        }
    }
    if (changed) {
        saveToCSV();
    }
}

void BudgetDAO::loadFromCSV() {
    m_budgets.clear();

    QString fullPath = DatabaseManager::getDataDirectoryPath() + "/budgets.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return; 

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (line.trimmed().isEmpty())
            continue;

        QStringList f = line.split(';');
        if (f.size() < 8)
            continue; 

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
    file.close();

    if (m_budgets.isEmpty()) {
        QDate today = QDate::currentDate();
        QDate monthStart(today.year(), today.month(), 1);
        QDate monthEnd = monthStart.addMonths(1).addDays(-1);

        m_budgets.append(Budget(1, "Monthly Living Budget", Priority::High, 15, 5000000.0, monthStart, monthEnd, 1300000.0));
        m_budgets.append(Budget(2, "Dining & Entertainment", Priority::Medium, 5, 2000000.0, monthStart, monthEnd, 850000.0));

        saveToCSV();
    }
}

void BudgetDAO::saveToCSV() const {
    QString fullPath = DatabaseManager::getDataDirectoryPath() + "/budgets.csv";
    QFile file(fullPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate))
        return;

    QTextStream out(&file);
    for (const Budget& b : m_budgets) {
        out << b.getId() << ";"
            << b.getName() << ";"
            << static_cast<int>(b.getPriority()) << ";"
            << b.getCategoryId() << ";"
            << QString::number(b.getLimit(), 'f', 2) << ";"
            << QString::number(b.getSpent(), 'f', 2) << ";"
            << b.getStartDate().toString(Qt::ISODate) << ";"
            << b.getEndDate().toString(Qt::ISODate) << "\n";
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

bool BudgetDAO::exportToCSV(const QString& targetFilePath) const {
    QString cleanPath = resolveLocalPath(targetFilePath);
    QFile file(cleanPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        return false;
    }

    QTextStream out(&file);
    for (const Budget& b : m_budgets) {
        out << b.getId() << ";"
            << b.getName() << ";"
            << static_cast<int>(b.getPriority()) << ";"
            << b.getCategoryId() << ";"
            << QString::number(b.getLimit(), 'f', 2) << ";"
            << QString::number(b.getSpent(), 'f', 2) << ";"
            << b.getStartDate().toString(Qt::ISODate) << ";"
            << b.getEndDate().toString(Qt::ISODate) << "\n";
    }
    file.close();
    return true;
}
