#include "database_manager.h"
#include <QDebug>

DatabaseManager::DatabaseManager() {
    qDebug() << "Backend Database Manager: Đang khởi tạo bộ nhớ tạm...";
    loadDataFromStorage();
}

DatabaseManager::~DatabaseManager() {
    saveDataToStorage();
}

bool DatabaseManager::loadDataFromStorage() {
    qDebug() << "Backend: Đang quét và đọc dữ liệu từ file CSV vào RAM... (Tạm thời để trống)";
    return true; 
}

bool DatabaseManager::saveDataToStorage() {
    qDebug() << "Backend: Đang tiến hành ghi toàn bộ dữ liệu trong RAM xuống file CSV... (Tạm thời để trống)";
    return true;
}