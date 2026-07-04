#ifndef REPORTS_WIDGET_H
#define REPORTS_WIDGET_H
#include <QWidget>
class ReportsWidget : public QWidget {
    Q_OBJECT
public:
    explicit ReportsWidget(QWidget *parent = nullptr);
    ~ReportsWidget();
};
#endif