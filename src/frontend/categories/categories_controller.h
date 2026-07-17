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

private:
    CategoriesWidget *m_widget;
    void refreshCategoryList();
};

#endif // CATEGORIES_CONTROLLER_H