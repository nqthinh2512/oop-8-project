#ifndef CATEGORIES_CONTROLLER_H
#define CATEGORIES_CONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include "../backend/storage/database_manager.h"

class CategoriesController : public QObject {
    Q_OBJECT

    Q_PROPERTY(QVariantList categoriesList READ categoriesList NOTIFY categoriesChanged)
    Q_PROPERTY(QString searchText READ searchText WRITE setSearchText NOTIFY filterChanged)
    Q_PROPERTY(int parentFilter READ parentFilter WRITE setParentFilter NOTIFY filterChanged)

private:
    QString m_searchText;
    int m_parentFilter; // 0: All, 1: Income, 2: Expense, 3: Bill, 4: Budget, 5: Saving

public:
    explicit CategoriesController(QObject *parent = nullptr);

    QVariantList categoriesList() const;

    QString searchText() const { return m_searchText; }
    void setSearchText(const QString &text);

    int parentFilter() const { return m_parentFilter; }
    void setParentFilter(int filter);

    Q_INVOKABLE bool addCategory(const QString &name, int parentId, bool active = true);
    Q_INVOKABLE bool updateCategory(int id, const QString &name, int newParentId, bool active);
    Q_INVOKABLE bool updateCategoryParent(int id, int newParentId);
    Q_INVOKABLE bool removeCategory(int id);
    Q_INVOKABLE bool migrateAndRemoveCategory(int sourceId, int targetId);
    Q_INVOKABLE bool deactivateCategory(int id);
    Q_INVOKABLE void refresh();

signals:
    void categoriesChanged();
    void filterChanged();
};

#endif // CATEGORIES_CONTROLLER_H