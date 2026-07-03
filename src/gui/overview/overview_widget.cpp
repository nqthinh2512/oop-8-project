#include "overview_widget.h"

OverviewWidget::OverviewWidget(QWidget *parent) : QWidget(parent) {
    layout = new QVBoxLayout(this);
    titleLabel = new QLabel("Welcome to your Overview Dashboard!", this);
    titleLabel->setAlignment(Qt::AlignCenter);
    layout->addWidget(titleLabel);
}