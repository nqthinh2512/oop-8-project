#ifndef ADD_CATEGORY_DIALOG_H
#define ADD_CATEGORY_DIALOG_H

#include <QDialog>

namespace Ui {
class AddCategoryDialog;
}

class AddCategoryDialog : public QDialog {
    Q_OBJECT
public:
    explicit AddCategoryDialog(QWidget *parent = nullptr);
    ~AddCategoryDialog();

    QString getCategoryName() const;
    int getParentId() const;

private:
    Ui::AddCategoryDialog *ui;
};

#endif // ADD_CATEGORY_DIALOG_H