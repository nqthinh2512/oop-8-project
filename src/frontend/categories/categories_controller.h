#ifndef CATEGORIES_CONTROLLER_H
#define CATEGORIES_CONTROLLER_H

#include <QObject>

class CategoriesWidget;

class CategoriesController : public QObject {
    Q_OBJECT
public:
    explicit CategoriesController(CategoriesWidget *widget, QObject *parent = nullptr);

private slots:
    void onAddCategoryRequested(const QString &name, int parentId);
    void onFilterChanged(int parentId);
    void onCategoryParentChanged(int id, int newParentId);
    void onRemoveCategoryRequested(int id,const QString& name);

private:
    CategoriesWidget *m_widget;
    int m_currentFilter = 0;
    void refreshCategoryList();
};

#endif // CATEGORIES_CONTROLLER_H