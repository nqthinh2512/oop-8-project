#ifndef OVERVIEW_WIDGET_H
#define OVERVIEW_WIDGET_H

#include <QWidget>

namespace Ui {
class OverviewWidget;
}

class OverviewWidget : public QWidget {
    Q_OBJECT

public:
    explicit OverviewWidget(QWidget *parent = nullptr);
    ~OverviewWidget();

private:
    Ui::OverviewWidget *ui;
};

#endif // OVERVIEW_WIDGET_H