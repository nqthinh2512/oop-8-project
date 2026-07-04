#ifndef TRANSACTIONS_WIDGET_H
#define TRANSACTIONS_WIDGET_H
#include <QWidget>
class TransactionsWidget : public QWidget {
    Q_OBJECT
public:
    explicit TransactionsWidget(QWidget *parent = nullptr);
    ~TransactionsWidget();
};
#endif