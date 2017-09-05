#include <QStandardPaths>

#include "backend.h"

/**
 * @brief BackEnd::BackEnd
 * @param parent
 */
BackEnd::BackEnd(QObject *parent) : QObject(parent)
{
}

/**
 * @brief BackEnd::VideoDirectoryPath
 * @return
 */
QString BackEnd::VideoDirectoryPath()
{
    QString strMoviePath;
    QStringList slPaths = QStandardPaths::standardLocations(QStandardPaths::MoviesLocation);
    if (slPaths.count() != 0)
    {
        strMoviePath = slPaths.at(0);
    }
    return strMoviePath;
}
