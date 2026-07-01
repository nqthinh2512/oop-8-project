#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    //test commit & push test
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return QApplication::exec();
}
