#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString moviePath READ VideoDirectoryPath CONSTANT)

public:
    explicit BackEnd(QObject *parent = nullptr);
    QString VideoDirectoryPath();

signals:

public slots:
};

#endif // BACKEND_H
