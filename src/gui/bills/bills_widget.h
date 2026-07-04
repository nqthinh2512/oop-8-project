#ifndef BILLS_WIDGET_H
#define BILLS_WIDGET_H
#include <QWidget>
class BillsWidget : public QWidget {
    Q_OBJECT
public:
    explicit BillsWidget(QWidget *parent = nullptr);
    ~BillsWidget(); };
#endif