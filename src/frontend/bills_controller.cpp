#include "bills_controller.h"
#include "../backend/storage/database_manager.h"
#include "../backend/models/transaction_factory.h"
#include <QDateTime>
#include <QDebug>

BillsController::BillsController(QObject *parent)
    : QAbstractListModel(parent),
      m_totalPaid(0.0), m_totalOnTime(0.0), m_totalOverdue(0.0),
      m_filterType(-1), m_categoryIdFilter(0)
{
    connect(&DatabaseManager::instance(), &DatabaseManager::dataChanged, this, &BillsController::loadBills);
    loadBills();
}

void BillsController::loadBills()
{
    beginResetModel();
    m_allBills = DatabaseManager::instance().billDAO()->getAll();
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
        if (catId == 0) return "Uncategorized";
        for (const auto& cat : DatabaseManager::instance().categoryDAO()->getAll()) {
            if (cat.getId() == catId) {
                return cat.getName();
            }
        }
        return "Uncategorized";
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

QVariantList BillsController::getAllBills() const
{
    QVariantList list;
    for (const Bill& b : m_allBills) {
        QVariantMap map;
        map["id"] = b.getId();
        map["name"] = b.getName();
        map["amount"] = b.getAmount();
        map["categoryId"] = b.getCategoryId();
        map["paid"] = b.checkPaid();
        list.append(map);
    }
    return list;
}

void BillsController::addBill(const QString& title, double amount, const QString& dateStr, int categoryId)
{
    QDate date = QDate::fromString(dateStr, "dd/MM/yyyy");
    if (!date.isValid()) date = QDate::currentDate();

    // Default to unpaid when adding
    Bill b(0, title, amount, date, categoryId, false);
    DatabaseManager::instance().billDAO()->add(b);
    DatabaseManager::instance().triggerDataChanged();
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
    DatabaseManager::instance().billDAO()->update(id, b);
    
    if (currentIsPaid) {
        // Find the linked transaction and update its amount & category while preserving linked ids
        const auto& transactions = DatabaseManager::instance().transactionDAO()->getAll();
        for (const Transaction* t : transactions) {
            if (t && t->getLinkedBillId() == id) {
                double oldAmount = t->getAmount();
                int oldCatId = t->getCategoryId();
                int txId = t->getId();
                int oldLinkedBudgetId = t->getLinkedBudgetId();
                int oldLinkedSavingId = t->getLinkedSavingId();
                
                // Reverse old budget deduction
                if (oldLinkedBudgetId != -1) {
                    for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
                        if (b.getId() == oldLinkedBudgetId) {
                            Budget updatedB = b;
                            double newSpent = std::max(0.0, b.getSpent() - oldAmount);
                            updatedB.setSpent(newSpent);
                            DatabaseManager::instance().budgetDAO()->update(oldLinkedBudgetId, updatedB);
                            break;
                        }
                    }
                } else {
                    DatabaseManager::instance().budgetDAO()->addExpenseToBudget(oldCatId, -oldAmount);
                }
                
                // Update transaction preserving linked saving and budget
                Transaction* newTx = TransactionFactory::createTransaction(
                    1, txId, title, amount, t->getDateTime(), t->getMethod(), categoryId, id, oldLinkedSavingId, oldLinkedBudgetId
                );
                DatabaseManager::instance().transactionDAO()->update(txId, newTx);
                
                // Apply new budget deduction
                if (oldLinkedBudgetId != -1) {
                    for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
                        if (b.getId() == oldLinkedBudgetId) {
                            Budget updatedB = b;
                            updatedB.addExpense(amount);
                            DatabaseManager::instance().budgetDAO()->update(oldLinkedBudgetId, updatedB);
                            break;
                        }
                    }
                } else {
                    DatabaseManager::instance().budgetDAO()->addExpenseToBudget(categoryId, amount);
                }
                break;
            }
        }
    }
    
    DatabaseManager::instance().triggerDataChanged();
    loadBills();
}

void BillsController::deleteBill(int id)
{
    // Check if it's paid to clean up the linked transaction
    bool currentIsPaid = false;
    for (const Bill& existingBill : m_allBills) {
        if (existingBill.getId() == id) {
            currentIsPaid = existingBill.checkPaid();
            break;
        }
    }
    
    if (currentIsPaid) {
        const auto& transactions = DatabaseManager::instance().transactionDAO()->getAll();
        for (const Transaction* t : transactions) {
            if (t && t->getLinkedBillId() == id) {
                // Revert Budget Impact
                if (t->getLinkedBudgetId() != -1) {
                    for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
                        if (b.getId() == t->getLinkedBudgetId()) {
                            Budget updatedB = b;
                            double newSpent = std::max(0.0, b.getSpent() - t->getAmount());
                            updatedB.setSpent(newSpent);
                            DatabaseManager::instance().budgetDAO()->update(t->getLinkedBudgetId(), updatedB);
                            break;
                        }
                    }
                } else {
                    DatabaseManager::instance().budgetDAO()->addExpenseToBudget(t->getCategoryId(), -t->getAmount());
                }

                // Revert Saving Impact
                if (t->getLinkedSavingId() != -1) {
                    for (const Saving& s : DatabaseManager::instance().savingDAO()->getAll()) {
                        if (s.getId() == t->getLinkedSavingId()) {
                            double newCurrent = std::max(0.0, s.getCurrent() - t->getAmount());
                            Saving updatedS(s.getId(), s.getName(), s.getPriority(), s.getDueDate(), s.getTarget(), newCurrent, s.getCategoryId());
                            DatabaseManager::instance().savingDAO()->update(t->getLinkedSavingId(), updatedS);
                            break;
                        }
                    }
                }

                DatabaseManager::instance().transactionDAO()->remove(t->getId());
                break;
            }
        }
    }

    DatabaseManager::instance().billDAO()->remove(id);
    DatabaseManager::instance().triggerDataChanged();
    loadBills();
}

void BillsController::togglePaidStatus(int id)
{
    for (const Bill& existingBill : m_allBills) {
        if (existingBill.getId() == id) {
            bool newStatus = !existingBill.checkPaid();
            Bill updatedBill(existingBill.getId(), existingBill.getName(), existingBill.getAmount(), existingBill.getDueDate(), existingBill.getCategoryId(), newStatus);
            DatabaseManager::instance().billDAO()->update(id, updatedBill);
            
            QString autoTitle = existingBill.getName();
            
            if (newStatus) {
                // Bill marked as Paid -> Check if linked transaction already exists
                bool alreadyExists = false;
                for (const Transaction* t : DatabaseManager::instance().transactionDAO()->getAll()) {
                    if (t && t->getLinkedBillId() == id) {
                        alreadyExists = true;
                        break;
                    }
                }

                if (!alreadyExists) {
                    int maxId = 0;
                    for (const auto* t : DatabaseManager::instance().transactionDAO()->getAll()) {
                        if (t && t->getId() > maxId) maxId = t->getId();
                    }
                    int newTxId = maxId + 1;

                    Transaction* newTx = TransactionFactory::createTransaction(
                        1, newTxId, autoTitle, existingBill.getAmount(), QDateTime::currentDateTime(), "Bill Payment", existingBill.getCategoryId(), existingBill.getId(), -1, -1
                    );
                    DatabaseManager::instance().transactionDAO()->add(newTx);
                    DatabaseManager::instance().budgetDAO()->addExpenseToBudget(existingBill.getCategoryId(), existingBill.getAmount());
                }
            } else {
                // Bill marked as Unpaid -> Find the linked transaction and delete it cleanly
                const auto& transactions = DatabaseManager::instance().transactionDAO()->getAll();
                for (const Transaction* t : transactions) {
                    if (t && t->getLinkedBillId() == id) {
                        if (t->getLinkedBudgetId() != -1) {
                            for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
                                if (b.getId() == t->getLinkedBudgetId()) {
                                    Budget updatedB = b;
                                    double newSpent = std::max(0.0, b.getSpent() - t->getAmount());
                                    updatedB.setSpent(newSpent);
                                    DatabaseManager::instance().budgetDAO()->update(t->getLinkedBudgetId(), updatedB);
                                    break;
                                }
                            }
                        } else {
                            DatabaseManager::instance().budgetDAO()->addExpenseToBudget(t->getCategoryId(), -t->getAmount());
                        }

                        if (t->getLinkedSavingId() != -1) {
                            for (const Saving& s : DatabaseManager::instance().savingDAO()->getAll()) {
                                if (s.getId() == t->getLinkedSavingId()) {
                                    double newCurrent = std::max(0.0, s.getCurrent() - t->getAmount());
                                    Saving updatedS(s.getId(), s.getName(), s.getPriority(), s.getDueDate(), s.getTarget(), newCurrent, s.getCategoryId());
                                    DatabaseManager::instance().savingDAO()->update(t->getLinkedSavingId(), updatedS);
                                    break;
                                }
                            }
                        }

                        DatabaseManager::instance().transactionDAO()->remove(t->getId());
                        break;
                    }
                }
            }
            
            DatabaseManager::instance().triggerDataChanged();
            loadBills();
            return;
        }
    }
}

bool BillsController::exportToCSV(const QString& filePath)
{
    return DatabaseManager::instance().billDAO()->exportToCSV(filePath);
}