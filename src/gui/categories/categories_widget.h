#ifndef CATEGORIES_WIDGET_H
#define CATEGORIES_WIDGET_H
#include <QWidget>
class CategoriesWidget : public QWidget {
    Q_OBJECT
public:
    explicit CategoriesWidget(QWidget *parent = nullptr);
    ~CategoriesWidget();
};
#endif