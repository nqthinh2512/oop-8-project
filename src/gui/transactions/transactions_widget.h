#ifndef TRANSACTIONS_WIDGET_H
#define TRANSACTIONS_WIDGET_H

#include <QWidget>
#include <QTableWidget>
#include <QLineEdit>
#include <QComboBox>
#include <QDateEdit>
#include <QPushButton>

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
    TransactionsController* m_controller;
    
    QLineEdit* m_searchEdit;
    QComboBox* m_categoryFilter;
    QDateEdit* m_startDateEdit;
    QDateEdit* m_endDateEdit;
    QPushButton* m_addBtn;
    
    QTableWidget* m_table;
    
    void setupUI();
    void loadData();
};
#endif