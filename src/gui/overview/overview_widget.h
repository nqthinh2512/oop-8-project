#ifndef OVERVIEW_WIDGET_H
#define OVERVIEW_WIDGET_H
#include <QWidget>
class OverviewWidget : public QWidget {
    Q_OBJECT
public:
    explicit OverviewWidget(QWidget *parent = nullptr);
    ~OverviewWidget();
};
#endif