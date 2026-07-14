#include "transactions_widget.h"
#include "ui_transactions_widget.h"

TransactionsWidget::TransactionsWidget(QWidget *parent)
    : QWidget(parent),
    ui(new Ui::TransactionsWidget)
{
    ui->setupUi(this);
}

TransactionsWidget::~TransactionsWidget() {
    delete ui;
}