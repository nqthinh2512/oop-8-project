#ifndef TRANSACTIONS_WIDGET_H
#define TRANSACTIONS_WIDGET_H

#include <QWidget>

namespace Ui {
class TransactionsWidget;
}

class TransactionsController;

class TransactionsWidget : public QWidget {
    Q_OBJECT

public:
    explicit TransactionsWidget(QWidget *parent = nullptr);
    ~TransactionsWidget();

private slots:
    void onSearchChanged();
    void onFilterChanged();
    void onAddClicked();
    void onEditClicked(int id);
    void onDeleteClicked(int id);

private:
    Ui::TransactionsWidget *ui;
    TransactionsController* m_controller;
    
    void loadData();
};

#endif