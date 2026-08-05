#include "categories_controller.h"
#include "../backend/models/transaction.h"
#include <QLocale>
#include <algorithm>

CategoriesController::CategoriesController(QObject *parent)
    : QObject(parent), m_searchText(""), m_parentFilter(0), m_statusFilter(0) {
    connect(&DatabaseManager::instance(), &DatabaseManager::dataChanged, this, &CategoriesController::categoriesChanged);
}

void CategoriesController::setSearchText(const QString &text) {
    if (m_searchText != text) {
        m_searchText = text;
        emit filterChanged();
        emit categoriesChanged();
    }
}

void CategoriesController::setParentFilter(int filter) {
    if (m_parentFilter != filter) {
        m_parentFilter = filter;
        emit filterChanged();
        emit categoriesChanged();
    }
}

void CategoriesController::setStatusFilter(int filter) {
    if (m_statusFilter != filter) {
        m_statusFilter = filter;
        emit filterChanged();
        emit categoriesChanged();
    }
}

static QString getParentCategoryName(int parentId) {
    switch (parentId) {
        case 1: return "Income";
        case 2: return "Expense";
        case 3: return "Bill";
        case 4: return "Budget";
        case 5: return "Saving";
        default: return "General";
    }
}

static QString formatVND(double amount) {
    QLocale locale(QLocale::English);
    return locale.toString(static_cast<qlonglong>(qAbs(amount))) + " VND";
}

QVariantList CategoriesController::categoriesList() const {
    const QVector<Category>& categories = DatabaseManager::instance().categoryDAO()->getAll();
    const auto& transactions = DatabaseManager::instance().transactionDAO()->getAll();
    const auto& bills = DatabaseManager::instance().billDAO()->getAll();
    const auto& budgets = DatabaseManager::instance().budgetDAO()->getAll();
    const auto& savings = DatabaseManager::instance().savingDAO()->getAll();

    QMap<int, double> categorySums;
    for (const auto* t : transactions) {
        if (t) categorySums[t->getCategoryId()] += t->getAmount();
    }
    for (const auto& b : bills) {
        categorySums[b.getCategoryId()] += b.getAmount();
    }
    for (const auto& b : budgets) {
        categorySums[b.getCategoryId()] += b.getLimit();
    }
    for (const auto& s : savings) {
        categorySums[s.getCategoryId()] += s.getTarget();
    }

    QVector<QVariantMap> items;

    for (const auto &cat : categories) {
        // Filter by parentId (0 means All Categories)
        if (m_parentFilter > 0 && cat.getParentId() != m_parentFilter) {
            continue;
        }

        // Filter by statusFilter (0: All, 1: Active Only, 2: Inactive Only)
        if (m_statusFilter == 1 && !cat.isActive()) {
            continue;
        }
        if (m_statusFilter == 2 && cat.isActive()) {
            continue;
        }

        // Filter by searchText
        if (!m_searchText.isEmpty() && !cat.getName().contains(m_searchText, Qt::CaseInsensitive)) {
            continue;
        }

        double totalAmt = categorySums.value(cat.getId(), 0.0);

        QVariantMap item;
        item["id"] = cat.getId();
        item["name"] = cat.getName();
        item["parentId"] = cat.getParentId();
        item["parentName"] = getParentCategoryName(cat.getParentId());
        item["active"] = cat.isActive();
        item["status"] = cat.isActive() ? "Active" : "Inactive";
        item["totalAmount"] = totalAmt;
        item["totalAmountFormatted"] = formatVND(totalAmt);

        items.append(item);
    }

    // Sort: 1) Active first, 2) Total Amount descending
    std::sort(items.begin(), items.end(), [](const QVariantMap &a, const QVariantMap &b) {
        bool activeA = a["active"].toBool();
        bool activeB = b["active"].toBool();

        if (activeA != activeB) {
            return activeA > activeB; // true (Active) before false (Inactive)
        }

        double amtA = a["totalAmount"].toDouble();
        double amtB = b["totalAmount"].toDouble();
        return amtA > amtB; // Higher total money first
    });

    QVariantList list;
    for (const auto &item : items) {
        list.append(item);
    }

    return list;
}

bool CategoriesController::isCategoryNameExists(const QString &name, int parentId, int excludeId) const {
    QString trimmed = name.trimmed();
    if (trimmed.isEmpty()) return false;
    for (const Category& c : DatabaseManager::instance().categoryDAO()->getAll()) {
        if (c.getId() != excludeId && c.getParentId() == parentId && c.getName().compare(trimmed, Qt::CaseInsensitive) == 0) {
            return true;
        }
    }
    return false;
}

bool CategoriesController::addCategory(const QString &name, int parentId, bool active) {
    if (name.trimmed().isEmpty()) return false;
    if (isCategoryNameExists(name, parentId, 0)) return false;
    Category cat(0, parentId, name.trimmed());
    cat.setActive(active);
    DatabaseManager::instance().categoryDAO()->add(cat);
    emit categoriesChanged();
    return true;
}

bool CategoriesController::updateCategory(int id, const QString &name, int newParentId, bool active) {
    if (name.trimmed().isEmpty()) return false;
    for (const Category& existing : DatabaseManager::instance().categoryDAO()->getAll()) {
        if (existing.getId() == id) {
            if (isCategoryNameExists(name, existing.getParentId(), id)) return false;
            Category cat(id, existing.getParentId(), name.trimmed());
            cat.setActive(active);
            DatabaseManager::instance().categoryDAO()->update(id, cat);
            emit categoriesChanged();
            return true;
        }
    }
    return false;
}

bool CategoriesController::updateCategoryParent(int id, int newParentId) {
    for (const Category& cat : DatabaseManager::instance().categoryDAO()->getAll()) {
        if (cat.getId() == id) {
            Category updatedCat = cat;
            updatedCat.setParentId(newParentId);
            DatabaseManager::instance().categoryDAO()->update(id, updatedCat);
            break;
        }
    }
    emit categoriesChanged();
    return true;
}

bool CategoriesController::removeCategory(int id) {
    DatabaseManager::instance().categoryDAO()->remove(id);
    emit categoriesChanged();
    return true;
}

bool CategoriesController::migrateAndRemoveCategory(int sourceId, int targetId) {
    for (const Transaction* t : DatabaseManager::instance().transactionDAO()->getAll()) {
        if (t->getCategoryId() == sourceId) {
            Transaction* updatedT = const_cast<Transaction*>(t);
            updatedT->setCategoryId(targetId);
            DatabaseManager::instance().transactionDAO()->update(t->getId(), updatedT);
        }
    }
    for (const Bill& b : DatabaseManager::instance().billDAO()->getAll()) {
        if (b.getCategoryId() == sourceId) {
            Bill updatedB = b;
            updatedB.setCategoryId(targetId);
            DatabaseManager::instance().billDAO()->update(b.getId(), updatedB);
        }
    }
    for (const Budget& b : DatabaseManager::instance().budgetDAO()->getAll()) {
        if (b.getCategoryId() == sourceId) {
            Budget updatedB = b;
            updatedB.setCategoryId(targetId);
            DatabaseManager::instance().budgetDAO()->update(b.getId(), updatedB);
        }
    }
    for (const Saving& s : DatabaseManager::instance().savingDAO()->getAll()) {
        if (s.getCategoryId() == sourceId) {
            Saving updatedS = s;
            updatedS.setCategoryId(targetId);
            DatabaseManager::instance().savingDAO()->update(s.getId(), updatedS);
        }
    }
    DatabaseManager::instance().categoryDAO()->remove(sourceId);
    emit categoriesChanged();
    return true;
}

bool CategoriesController::deactivateCategory(int id) {
    DatabaseManager::instance().categoryDAO()->deactivate(id);
    emit categoriesChanged();
    return true;
}

void CategoriesController::resetFilters() {
    m_searchText = "";
    m_parentFilter = 0;
    m_statusFilter = 0;
    emit filterChanged();
    emit categoriesChanged();
}

void CategoriesController::refresh() {
    emit categoriesChanged();
}

bool CategoriesController::exportToCSV(const QString &filePath) {
    return DatabaseManager::instance().categoryDAO()->exportToCSV(filePath);
}