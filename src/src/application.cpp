#include "application.h"

#include <QRegularExpression>

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
    name.replace(QRegularExpression("[ÁÀÂÃÄ]"), "A");
    name.replace(QRegularExpression("[áàâãä]"), "a");
    name.replace(QRegularExpression("[ÉÈÊẼË]"), "E");
    name.replace(QRegularExpression("[éèêẽë]"), "e");
    name.replace(QRegularExpression("[ÍÌÎĨÏ]"), "I");
    name.replace(QRegularExpression("[íìîĩï]"), "i");
    name.replace(QRegularExpression("[ÓÒÔÕÖ]"), "O");
    name.replace(QRegularExpression("[óòôõö]"), "o");
    name.replace(QRegularExpression("[ÚÙÛŨÜ]"), "U");
    name.replace(QRegularExpression("[úùûũü]"), "u");
    name.replace(QRegularExpression("[Ç]"), "C");
    name.replace(QRegularExpression("[ç]"), "c");

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
