#ifndef BILLS_CONTROLLER_H
#define BILLS_CONTROLLER_H

#include <QAbstractListModel>
#include <QString>
#include <QVector>
#include "../backend/models/bill.h"

class BillsController : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(double totalPaid READ totalPaid NOTIFY statsChanged)
    Q_PROPERTY(double totalOnTime READ totalOnTime NOTIFY statsChanged)
    Q_PROPERTY(double totalOverdue READ totalOverdue NOTIFY statsChanged)
    
    Q_PROPERTY(int filterType READ filterType WRITE setFilterType NOTIFY filterChanged)
    Q_PROPERTY(int categoryIdFilter READ categoryIdFilter WRITE setCategoryIdFilter NOTIFY filterChanged)
    Q_PROPERTY(QString searchKeyword READ searchKeyword WRITE setSearchKeyword NOTIFY filterChanged)

public:
    enum BillRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        AmountRole,
        CategoryRole,
        DateRole,
        StatusRole
    };

    explicit BillsController(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    double totalPaid() const;
    double totalOnTime() const;
    double totalOverdue() const;

    int filterType() const;
    void setFilterType(int type);

    int categoryIdFilter() const;
    void setCategoryIdFilter(int catId);

    QString searchKeyword() const;
    void setSearchKeyword(const QString& keyword);

    Q_INVOKABLE void loadBills();
    Q_INVOKABLE void addBill(const QString& title, double amount, const QString& dateStr, int categoryId);
    Q_INVOKABLE void updateBill(int id, const QString& title, double amount, const QString& dateStr, int categoryId);
    Q_INVOKABLE void deleteBill(int id);
    Q_INVOKABLE void togglePaidStatus(int id); 

signals:
    void statsChanged();
    void filterChanged();

private:
    void calculateStats();
    
    QVector<Bill> m_allBills;
    QVector<const Bill*> m_filteredBills;
    
    double m_totalPaid;
    double m_totalOnTime;
    double m_totalOverdue;

    int m_filterType; // -1: All, 0: Paid, 1: Upcoming, 2: Overdue
    int m_categoryIdFilter; // 0: All
    QString m_searchKeyword;
};

#endif // BILLS_CONTROLLER_H