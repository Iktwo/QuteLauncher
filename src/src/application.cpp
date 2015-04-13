#include "application.h"

#include <QRegExp>

Application::Application(QObject *parent) :
    QObject(parent)
{
}

Application::Application(const QString &name, const QString &packageName, QObject *parent) :
    QObject(parent),
    mName(name),
    mPackageName(packageName)
{
    setCategory();
}

QString Application::name() const
{
    return mName;
}

void Application::setName(const QString &name)
{
    if (mName == name)
        return;

    mName = name;
    emit nameChanged();
    setCategory();
}

QString Application::packageName() const
{
    return mPackageName;
}

void Application::setPackageName(const QString &packageName)
{
    if (mPackageName == packageName)
        return;

    mPackageName = packageName;
    emit packageNameChanged();
}

QString Application::category() const
{
    return mCategory;
}

void Application::setCategory()
{
    QString name = mName.simplified();
    name.replace(QRegExp("[ÁÀÂÃÄ]"), "A");
    name.replace(QRegExp("[áàâãä]"), "a");
    name.replace(QRegExp("[ÉÈÊẼË]"), "E");
    name.replace(QRegExp("[éèêẽë]"), "e");
    name.replace(QRegExp("[ÍÌÎĨÏ]"), "I");
    name.replace(QRegExp("[íìîĩï]"), "i");
    name.replace(QRegExp("[ÓÒÔÕÖ]"), "O");
    name.replace(QRegExp("[óòôõö]"), "o");
    name.replace(QRegExp("[ÚÙÛŨÜ]"), "U");
    name.replace(QRegExp("[úùûũü]"), "u");
    name.replace(QRegExp("[Ç]"), "C");
    name.replace(QRegExp("[ç]"), "c");

    if (name.simplified().isEmpty())
        mCategory = " ";
    else if (name.at(0).isDigit())
        mCategory = "#";
    else if (name.at(0) <= 'z')
        mCategory = name.at(0).toUpper();
    else
        mCategory = "%";

    emit categoryChanged();
}
