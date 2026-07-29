#ifndef BILLS_WIDGET_H
#define BILLS_WIDGET_H

#include <QWidget>

namespace Ui {
class BillsWidget;
}

class BillsWidget : public QWidget {
    Q_OBJECT

public:
    explicit BillsWidget(QWidget *parent = nullptr);
    ~BillsWidget();

private:
    Ui::BillsWidget *ui;
};

#endif // BILLS_WIDGET_H