#ifndef SAVING_H
#define SAVING_H

#include <QString>
#include <QDate>

class Saving
{
private:
    int id;
    int categoryId;
    QString name;
    double targetAmount;
    double currentAmount;
    QDate dueDate;

public:
    static const int parentCategory = 5; // Danh mục cha, tất cả categoryId của class này là con của danh mục này
    // 5 sẽ là số chỉ định cho danh mục cha này

    Saving();
    Saving(int n_id, const QString& n_name, const QDate& n_dueDate, double n_target, double n_current=0.0, int n_categoryid=0);
    //ngoại trừ hàm getter và setter thì các hàm khác không được viết logic của nó trực tiếp ở đây, đi qua .cpp để viết đi.

    //getter
    int getId() const {return id;}
    int getCategoryId() const {return categoryId;}
    QString getName() const {return name;}
    double getTarget() const {return targetAmount;}
    double getCurrent() const{return currentAmount;}
    QDate getDueDate() const {return dueDate;}

    //setter, để tránh lỗi đè cùng ID, đừng viết hàm setId.
};

#endif // SAVING_H
