#ifndef SAVINGS_CONTROLLER_H
#define SAVINGS_CONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include "../backend/storage/database_manager.h"

class SavingsController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList savingsList READ savingsList NOTIFY savingsListChanged)
    Q_PROPERTY(QVariantList categoryOptions READ categoryOptions NOTIFY categoriesChanged)
    Q_PROPERTY(QString searchText READ searchText WRITE setSearchText NOTIFY filterChanged)
    // -1 = All, 0 = Low, 1 = Medium, 2 = High
    Q_PROPERTY(int priorityFilter READ priorityFilter WRITE setPriorityFilter NOTIFY filterChanged)
    // 0 = "All Main Categories", còn lại là categoryId thật
    Q_PROPERTY(int categoryFilter READ categoryFilter WRITE setCategoryFilter NOTIFY filterChanged)
    Q_PROPERTY(QString totalSavedText READ totalSavedText NOTIFY totalsChanged)
    Q_PROPERTY(QString totalRemainingText READ totalRemainingText NOTIFY totalsChanged)
    Q_PROPERTY(QString completedText READ completedText NOTIFY totalsChanged)

private:
    QString m_searchText;
    int m_priorityFilter = -1;
    int m_categoryFilter = 0;

    mutable QVariantList m_cachedList;
    mutable bool m_listDirty = true;

public:
    explicit SavingsController(QObject *parent = nullptr);

    QVariantList savingsList() const;
    QVariantList categoryOptions() const;

    QString searchText() const { return m_searchText; }
    void setSearchText(const QString &text);

    int priorityFilter() const { return m_priorityFilter; }
    void setPriorityFilter(int filter);

    int categoryFilter() const { return m_categoryFilter; }
    void setCategoryFilter(int filter);

    QString totalSavedText() const;
    QString totalRemainingText() const;
    QString completedText() const;

    Q_INVOKABLE bool addSaving(const QString &name, int priority, int categoryId,
                               double target, double current,
                               const QString &dueDateStr);
    Q_INVOKABLE bool updateSaving(int id, const QString &name, int priority, int categoryId,
                                  double target, double current,
                                  const QString &dueDateStr);
    Q_INVOKABLE bool removeSaving(int id);
    Q_INVOKABLE void refresh();

signals:
    void savingsListChanged();
    void totalsChanged();
    void categoriesChanged();
    void filterChanged();
};

#endif // SAVINGS_CONTROLLER_H