#ifndef CATEGORIES_WIDGET_H
#define CATEGORIES_WIDGET_H
#include <QWidget>
#include <QVector>
#include "../../backend/models/category.h"

namespace Ui {
class CategoriesWidget;
}

class CategoriesWidget : public QWidget {
    Q_OBJECT
public:
    explicit CategoriesWidget(QWidget *parent = nullptr);
    ~CategoriesWidget();
    void displayCategories(const QVector<Category>& categories);
    void showError(const QString &message);

signals:
    void addCategoryRequested(const QString &name, int parentId);
    void filterChanged(int parentId);
    void categoryParentChanged(int id, int newParentId);
    void removeCategoryRequested(int id, const QString& name);
    void searchTextChanged(const QString &text);


private slots:
    void onAddButtonClicked();
    void onFilterChanged(int index);

private:
    Ui::CategoriesWidget *ui;
};
#endif