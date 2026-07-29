#ifndef CATEGORY_REMOVE_BUTTON_H
#define CATEGORY_REMOVE_BUTTON_H

#include <QPushButton>

class CategoryRemoveButton : public QPushButton {
    Q_OBJECT
public:
    explicit CategoryRemoveButton(int categoryId, const QString& name, QWidget *parent = nullptr);

signals:
    void removeRequested(int categoryId, const QString& name);

private:
    int m_categoryId;
    QString m_name;
};

#endif // CATEGORY_REMOVE_BUTTON_H