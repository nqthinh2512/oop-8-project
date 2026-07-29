#include "overview_widget.h"
#include "ui_overview_widget.h"

OverviewWidget::OverviewWidget(QWidget *parent)
    : QWidget(parent),
    ui(new Ui::OverviewWidget)
{
    ui->setupUi(this);
}

OverviewWidget::~OverviewWidget() {
    delete ui;
}