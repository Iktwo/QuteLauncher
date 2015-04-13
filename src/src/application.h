#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>

class Application : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString packageName READ packageName NOTIFY packageNameChanged)
    Q_PROPERTY(QString category READ category NOTIFY categoryChanged)

public:
    explicit Application(QObject *parent = 0);
    Application(const QString &name, const QString &packageName, QObject *parent = 0);

    QString name() const;
    void setName(const QString &name);

    QString packageName() const;
    void setPackageName(const QString &packageName);

    QString category() const;
    void setCategory();

signals:
    void nameChanged();
    void packageNameChanged();
    void categoryChanged();

private:
    QString mName;
    QString mPackageName;
    QString mCategory;
};

#endif // APPLICATION_H
