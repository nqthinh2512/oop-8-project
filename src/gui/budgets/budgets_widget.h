#ifndef BUDGETS_WIDGET_H
#define BUDGETS_WIDGET_H
#include <QWidget>

namespace Ui {
class BudgetsWidget;
}

class BudgetsWidget : public QWidget {
    Q_OBJECT

public:
    explicit BudgetsWidget(QWidget *parent = nullptr);
    ~BudgetsWidget();

private:
    Ui::BudgetsWidget *ui;
};

#endif // BUDGETS_WIDGET_H