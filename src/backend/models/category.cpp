#include "category.h"

Category::Category(): id(0), name(""), iconPath(""){}

Category::Category(int n_id, const QString& n_name, const QString& n_path)
    : id(n_id), name(n_name), iconPath(n_path){}