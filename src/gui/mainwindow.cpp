#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent) {
    resize(800, 600);
    setWindowTitle("Personal Finance Dashboard");

    overviewWidget = new OverviewWidget(this);
    setCentralWidget(overviewWidget);
}

MainWindow::~MainWindow() {}