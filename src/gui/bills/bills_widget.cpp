#include "bills_widget.h"
#include "ui_bills_widget.h"

BillsWidget::BillsWidget(QWidget *parent)
    : QWidget(parent),
    ui(new Ui::BillsWidget)
{
    ui->setupUi(this);
}

BillsWidget::~BillsWidget() {
    delete ui;
}