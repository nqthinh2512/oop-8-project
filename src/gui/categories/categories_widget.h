#ifndef CATEGORIES_WIDGET_H
#define CATEGORIES_WIDGET_H
#include <QWidget>

namespace Ui{
    class CategoriesWidget;
}

class CategoriesWidget : public QWidget {
    Q_OBJECT
public:
    explicit CategoriesWidget(QWidget *parent = nullptr);
    ~CategoriesWidget();
private:
    Ui::CategoriesWidget *ui;
};
#endif