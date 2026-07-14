#ifndef REPORTS_WIDGET_H
#define REPORTS_WIDGET_H

#include <QWidget>

namespace Ui {
class ReportsWidget;
}

class ReportsWidget : public QWidget {
    Q_OBJECT

public:
    explicit ReportsWidget(QWidget *parent = nullptr);
    ~ReportsWidget();

private:
    Ui::ReportsWidget *ui;
};

#endif