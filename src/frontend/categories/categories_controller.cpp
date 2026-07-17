#include "categories_controller.h"
#include "../../gui/categories/categories_widget.h"
#include "../../backend/storage/database_manager.h"

CategoriesController::CategoriesController(CategoriesWidget *widget, QObject *parent)
    : QObject(parent), m_widget(widget) {
    refreshCategoryList();
    connect(m_widget, &CategoriesWidget::addCategoryRequested,
            this, &CategoriesController::onAddCategoryRequested);
}

void CategoriesController::refreshCategoryList() {
    const QVector<Category>& categories = DatabaseManager::instance().getAllCategories();
    m_widget->displayCategories(categories);
}

void CategoriesController::onAddCategoryRequested(const QString &name, int parentId) {
    if (name.trimmed().isEmpty()) {
        m_widget->showError("Category name cannot be empty.");
        return;
    }

    DatabaseManager::instance().addUserCustomCategory(name, parentId);
    refreshCategoryList();
}