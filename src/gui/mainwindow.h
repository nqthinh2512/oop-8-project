#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "overview/overview_widget.h" // Relative include works perfectly here

class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
private:
    OverviewWidget *overviewWidget;
};

#endif // MAINWINDOW_H