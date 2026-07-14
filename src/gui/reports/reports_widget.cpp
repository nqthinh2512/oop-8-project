#include "reports_widget.h"
#include "ui_reports_widget.h"

ReportsWidget::ReportsWidget(QWidget *parent)
    : QWidget(parent),
    ui(new Ui::ReportsWidget)
{
    ui->setupUi(this);
}

ReportsWidget::~ReportsWidget() {
    delete ui;
}