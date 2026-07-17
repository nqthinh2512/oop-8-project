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

private slots:
    void onAddButtonClicked();

private:
    Ui::CategoriesWidget *ui;
};
#endif