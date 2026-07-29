#include "categories_controller.h"
#include "../../gui/categories/categories_widget.h"
#include "../../backend/storage/database_manager.h"
#include <QTimer>
#include <QMessageBox>


CategoriesController::CategoriesController(CategoriesWidget *widget, QObject *parent)
    : QObject(parent), m_widget(widget) {
    refreshCategoryList();
    connect(m_widget, &CategoriesWidget::addCategoryRequested,
            this, &CategoriesController::onAddCategoryRequested);
    connect(m_widget, &CategoriesWidget::filterChanged,
            this, &CategoriesController::onFilterChanged);
    connect(m_widget, &CategoriesWidget::categoryParentChanged,
            this, &CategoriesController::onCategoryParentChanged);
    connect(m_widget, &CategoriesWidget::removeCategoryRequested,
            this, &CategoriesController::onRemoveCategoryRequested);
    connect(m_widget, &CategoriesWidget::searchTextChanged,
            this, &CategoriesController::onSearchTextChanged);
}

void CategoriesController::refreshCategoryList() {
    const QVector<Category>& categories = DatabaseManager::instance().getAllCategories();

    QVector<Category> results;
    for (const Category& cat : categories){
        bool matchesFilter = (m_currentFilter == 0) || (cat.getParentId() == m_currentFilter);
        bool matchesSearch = cat.getName().contains(m_currentSearchText, Qt::CaseInsensitive);

        if (matchesFilter && matchesSearch){
            results.append(cat);
        }
    }

    m_widget->displayCategories(results);
}

void CategoriesController::onSearchTextChanged(const QString &text) {
    m_currentSearchText = text;
    refreshCategoryList();
}

void CategoriesController::onAddCategoryRequested(const QString &name, int parentId) {
    if (name.trimmed().isEmpty()) {
        m_widget->showError("Category name cannot be empty.");
        return;
    }

    DatabaseManager::instance().addUserCustomCategory(name, parentId);
    refreshCategoryList();
}

void CategoriesController::onFilterChanged(int parentId){
    m_currentFilter = parentId;
    refreshCategoryList();
}

void CategoriesController::onCategoryParentChanged(int id,int newParentId){
    DatabaseManager::instance().updateCategoryParent(id, newParentId);

    QTimer::singleShot(0, this, [this]() {
        refreshCategoryList();
    });

}

void CategoriesController::onRemoveCategoryRequested(int id, const QString& name) {
    QString msg = "Are you sure you want to delete " + name + " category";
    QMessageBox::StandardButton reply = QMessageBox::question(
        m_widget,
        "Confirm Deletion",
        msg,
        QMessageBox::Yes | QMessageBox::No
        );

    if (reply == QMessageBox::Yes) {
        DatabaseManager::instance().removeCategory(id);
        refreshCategoryList();
    }
}