#ifndef TRANSACTIONS_CONTROLLER_H
#define TRANSACTIONS_CONTROLLER_H

#include <QObject>
#include <QAbstractListModel>
#include <QString>
#include <QVector>
#include "../backend/storage/database_manager.h"

// ============================================================================
// TRANSACTION LIST MODEL
// Exposes the list of transactions to QML
// ============================================================================
class TransactionListModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum TransactionRoles {
        IdRole = Qt::UserRole + 1,
        TypeRole,
        TitleRole,
        AmountRole,
        CategoryRole,
        MethodRole,
        DateRole
    };

    explicit TransactionListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setTransactions(const QVector<Transaction*>& transactions);

private:
    QVector<Transaction*> m_transactions;
};

// ============================================================================
// TRANSACTIONS CONTROLLER
// Handles UI logic, filtering, and CRUD operations
// ============================================================================
class TransactionsController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QAbstractListModel* model READ model CONSTANT)
    Q_PROPERTY(int filterType READ filterType WRITE setFilterType NOTIFY filterTypeChanged)
    Q_PROPERTY(QString searchKeyword READ searchKeyword WRITE setSearchKeyword NOTIFY searchKeywordChanged)
    Q_PROPERTY(int categoryIdFilter READ categoryIdFilter WRITE setCategoryIdFilter NOTIFY categoryIdFilterChanged)

public:
    explicit TransactionsController(QObject *parent = nullptr);

    QAbstractListModel* model() const { return m_model; }
    
    int filterType() const { return m_filterType; }
    void setFilterType(int type);

    QString searchKeyword() const { return m_searchKeyword; }
    void setSearchKeyword(const QString& keyword);

    int categoryIdFilter() const { return m_categoryIdFilter; }
    void setCategoryIdFilter(int catId);

    // CRUD Operations
    Q_INVOKABLE void addTransaction(int typeIndex, const QString& title, double amount, const QString& dateStr, int categoryId, const QString& method);
    Q_INVOKABLE void updateTransaction(int id, int typeIndex, const QString& title, double amount, const QString& dateStr, int categoryId, const QString& method);
    Q_INVOKABLE void deleteTransaction(int id);

signals:
    void filterTypeChanged();
    void searchKeywordChanged();
    void categoryIdFilterChanged();

private:
    void loadTransactions();
    void applyFilter();

    TransactionListModel* m_model;
    int m_filterType; // -1: All, 0: Income, 1: Expense, 2: Transfer
    QString m_searchKeyword;
    int m_categoryIdFilter; // 0: All
};

#endif // TRANSACTIONS_CONTROLLER_H