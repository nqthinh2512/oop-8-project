#ifndef IBASE_DAO_H
#define IBASE_DAO_H

#include <QVector>

template <typename T>
class IBaseDAO {
public:
    virtual ~IBaseDAO() = default;

    virtual const QVector<T>& getAll() const = 0;
    virtual void add(const T& item) = 0;
    virtual bool update(int id, const T& item) = 0;
    virtual bool remove(int id) = 0;
};

#endif // IBASE_DAO_H
