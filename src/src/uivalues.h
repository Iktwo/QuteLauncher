#ifndef UIVALUES_H
#define UIVALUES_H

#include <QObject>

class UIValues : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool firstRun READ firstRun WRITE setFirstRun NOTIFY firstRunChanged)
    Q_PROPERTY(int dpi READ dpi WRITE setDpi NOTIFY dpiChanged)
    Q_PROPERTY(float dpMultiplier READ dpMultiplier NOTIFY dpMultiplierChanged)
    Q_PROPERTY(bool isTablet READ isTablet NOTIFY isTabletChanged)
public:
    explicit UIValues(QObject *parent = 0);

    Q_INVOKABLE void showMessage(const QString &message);
    Q_INVOKABLE QString getBestIconSize(int height) const;

    bool firstRun() const;
    void setFirstRun(bool firstRun);

    int dpi() const;
    void setDpi(int dpi);

    float dpMultiplier() const;
    void setDpMultiplier(float dpMultiplier);

    bool isTablet() const;
    void setIsTablet(bool isTablet);

signals:
    void firstRunChanged();
    void dpiChanged();
    void dpMultiplierChanged();
    void isTabletChanged();

private:
    bool m_firstRun;
    int m_dpi;
    float m_dpMultiplier;
    bool m_isTablet;
};

#endif // UIVALUES_H
