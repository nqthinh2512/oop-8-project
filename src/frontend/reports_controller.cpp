#include "reports_controller.h"

ReportsController::ReportsController(QObject *parent)
    : QObject(parent) {}

QVariantList ReportsController::categorySpendingReport() const {
    QVariantList list;
    // Category spending report calculation logic from DatabaseManager
    return list;
}

void ReportsController::refresh() {
    emit reportChanged();
}