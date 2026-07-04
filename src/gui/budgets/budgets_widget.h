#ifndef BUDGETS_WIDGET_H
#define BUDGETS_WIDGET_H
#include <QWidget>
class BudgetsWidget : public QWidget {
    Q_OBJECT
public:
    explicit BudgetsWidget(QWidget *parent = nullptr);
    ~BudgetsWidget(); };
#endif