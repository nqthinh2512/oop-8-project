#include "bills_controller.h"
#include "../backend/storage/database_manager.h"
#include <QDateTime>
#include <QDebug>

BillsController::BillsController(QObject *parent)
    : QAbstractListModel(parent),
      m_totalPaid(0.0), m_totalOnTime(0.0), m_totalOverdue(0.0),
      m_filterType(-1), m_categoryIdFilter(0)
{
    loadBills();
}

void BillsController::loadBills()
{
    beginResetModel();
    m_allBills = DatabaseManager::instance().getAllBills();
    m_filteredBills.clear();

    m_totalPaid = 0.0;
    m_totalOnTime = 0.0;
    m_totalOverdue = 0.0;
    
    QDate today = QDate::currentDate();

    for (const Bill& b : m_allBills) {
        // Status determination
        int status = 2; // Upcoming
        if (b.checkPaid()) {
            status = 0; // Paid
        } else if (b.getDueDate() < today) {
            status = 1; // Overdue
        }

        // Compute stats (considering all bills)
        if (status == 0) {
            m_totalPaid += b.getAmount();
        } else if (status == 2) {
            m_totalOnTime += b.getAmount();
        } else if (status == 1) {
            m_totalOverdue += b.getAmount();
        }

        // Apply filters
        bool matchType = true;
        if (m_filterType != -1) {
            if (m_filterType == 0 && status != 0) matchType = false;
            else if (m_filterType == 1 && status != 2) matchType = false; // Upcoming button matches Upcoming status (2)
            else if (m_filterType == 2 && status != 1) matchType = false; // Overdue button matches Overdue status (1)
        }

        bool matchCat = true;
        if (m_categoryIdFilter != 0 && b.getCategoryId() != m_categoryIdFilter) {
            matchCat = false;
        }

        bool matchSearch = true;
        if (!m_searchKeyword.isEmpty() && !b.getName().contains(m_searchKeyword, Qt::CaseInsensitive)) {
            matchSearch = false;
        }

        if (matchType && matchCat && matchSearch) {
            m_filteredBills.append(&b);
        }
    }

    std::sort(m_filteredBills.begin(), m_filteredBills.end(), [](const Bill* a, const Bill* b) {
        return a->getDueDate() < b->getDueDate();
    });

    endResetModel();
    emit statsChanged();
}

int BillsController::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_filteredBills.size();
}

QVariant BillsController::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_filteredBills.size())
        return QVariant();

    const Bill* b = m_filteredBills[index.row()];
    
    int status = 2; // Upcoming
    if (b->checkPaid()) status = 0; // Paid
    else if (b->getDueDate() < QDate::currentDate()) status = 1; // Overdue

    switch (role) {
    case IdRole: return b->getId();
    case TitleRole: return b->getName();
    case AmountRole: return QLocale::system().toString(b->getAmount(), 'f', 0);
    case CategoryRole: {
        int catId = b->getCategoryId();
        QString catName = "Unknown";
        for (const auto& cat : DatabaseManager::instance().getAllCategories()) {
            if (cat.getId() == catId) {
                catName = cat.getName();
                break;
            }
        }
        return catName;
    }
    case DateRole: return b->getDueDate().toString("dd/MM/yyyy");
    case StatusRole: return status;
    }
    return QVariant();
}

QHash<int, QByteArray> BillsController::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "tId";
    roles[TitleRole] = "tName";
    roles[AmountRole] = "tAmount";
    roles[CategoryRole] = "tCat";
    roles[DateRole] = "tDate";
    roles[StatusRole] = "tStatus";
    return roles;
}

double BillsController::totalPaid() const { return m_totalPaid; }
double BillsController::totalOnTime() const { return m_totalOnTime; }
double BillsController::totalOverdue() const { return m_totalOverdue; }

int BillsController::filterType() const { return m_filterType; }
void BillsController::setFilterType(int type) {
    if (m_filterType != type) {
        m_filterType = type;
        emit filterChanged();
        loadBills();
    }
}

int BillsController::categoryIdFilter() const { return m_categoryIdFilter; }
void BillsController::setCategoryIdFilter(int catId) {
    if (m_categoryIdFilter != catId) {
        m_categoryIdFilter = catId;
        emit filterChanged();
        loadBills();
    }
}

QString BillsController::searchKeyword() const { return m_searchKeyword; }
void BillsController::setSearchKeyword(const QString& keyword) {
    if (m_searchKeyword != keyword) {
        m_searchKeyword = keyword;
        emit filterChanged();
        loadBills();
    }
}

void BillsController::addBill(const QString& title, double amount, const QString& dateStr, int categoryId)
{
    QDate date = QDate::fromString(dateStr, "dd/MM/yyyy");
    if (!date.isValid()) date = QDate::currentDate();

    // Default to unpaid when adding
    Bill b(0, title, amount, date, categoryId, false);
    DatabaseManager::instance().addBill(b);
    loadBills();
}

void BillsController::updateBill(int id, const QString& title, double amount, const QString& dateStr, int categoryId)
{
    QDate date = QDate::fromString(dateStr, "dd/MM/yyyy");
    if (!date.isValid()) date = QDate::currentDate();

    bool currentIsPaid = false;
    for (const Bill& existingBill : m_allBills) {
        if (existingBill.getId() == id) {
            currentIsPaid = existingBill.checkPaid();
            break;
        }
    }

    Bill b(id, title, amount, date, categoryId, currentIsPaid);
    DatabaseManager::instance().updateBill(id, b);
    loadBills();
}

void BillsController::deleteBill(int id)
{
    DatabaseManager::instance().deleteBill(id);
    loadBills();
}

void BillsController::togglePaidStatus(int id)
{
    for (const Bill& existingBill : m_allBills) {
        if (existingBill.getId() == id) {
            Bill updatedBill(existingBill.getId(), existingBill.getName(), existingBill.getAmount(), existingBill.getDueDate(), existingBill.getCategoryId(), !existingBill.checkPaid());
            DatabaseManager::instance().updateBill(id, updatedBill);
            loadBills();
            return;
        }
    }
}