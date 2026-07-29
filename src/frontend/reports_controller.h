#ifndef REPORTS_CONTROLLER_H
#define REPORTS_CONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QString>
#include "../backend/storage/database_manager.h"

class ReportsController : public QObject {
    Q_OBJECT

    Q_PROPERTY(QVariantList categorySpendingReport READ categorySpendingReport NOTIFY reportChanged)

public:
    explicit ReportsController(QObject *parent = nullptr);

    QVariantList categorySpendingReport() const;

    Q_INVOKABLE void refresh();

signals:
    void reportChanged();
};

#endif // REPORTS_CONTROLLER_H