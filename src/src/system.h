#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>

class System : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int sdkInt READ sdkInt NOTIFY sdkIntChanged)

public:
    explicit System(QObject *parent = 0);

    int sdkInt() const;

signals:
    void sdkIntChanged(int sdkInt);

private slots:
    void setSdkInt(int sdkInt);

private:
    int m_sdkInt;

    int getSdkInt();
};

#endif // SYSTEM_H
