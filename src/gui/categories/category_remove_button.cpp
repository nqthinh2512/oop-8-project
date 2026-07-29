#include "category_remove_button.h"

CategoryRemoveButton::CategoryRemoveButton(int categoryId, const QString& name, QWidget *parent)
    : QPushButton("Remove", parent), m_categoryId(categoryId), m_name(name) {

    setStyleSheet(
        "QPushButton {"
        "   background-color: #f5f5f5;"
        "   border: 1px solid #cccccc;"
        "   border-radius: 4px;"
        "   padding: 4px 10px;"
        "}"
        "QPushButton:hover {"
        "   background-color: #ff5e5e;"
        "   color: white;"
        "   border: 1px solid #e53935;"
        "}"
        );

    connect(this, &QPushButton::clicked, this, [this]() {
        emit removeRequested(m_categoryId, m_name);
    });
}