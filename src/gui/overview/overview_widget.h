#ifndef OVERVIEW_WIDGET_H
#define OVERVIEW_WIDGET_H

#include <QWidget>
#include <QLabel>
#include <QVBoxLayout>

class OverviewWidget : public QWidget {
    Q_OBJECT
public:
    explicit OverviewWidget(QWidget *parent = nullptr);
private:
    QVBoxLayout *layout;
    QLabel *titleLabel;
};

#endif // OVERVIEW_WIDGET_H