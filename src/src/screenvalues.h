#ifndef SCREENVALUES_H
#define SCREENVALUES_H

#include <QObject>

#include "system.h"

class ScreenValues : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int statusBarHeight READ statusBarHeight NOTIFY statusBarHeightChanged)
    Q_PROPERTY(int navigationBarHeight READ navigationBarHeight NOTIFY navigationBarHeightChanged)
    Q_PROPERTY(int navigationBarHeightLandscape READ navigationBarHeightLandscape NOTIFY navigationBarHeightLandscapeChanged)
    Q_PROPERTY(int dpi READ dpi WRITE setDpi NOTIFY dpiChanged)
    Q_PROPERTY(float dp READ dp WRITE setDp NOTIFY dpChanged)
    Q_PROPERTY(bool isTablet READ isTablet NOTIFY isTabletChanged)
    Q_PROPERTY(bool navBarVisible READ navBarVisible NOTIFY navBarVisibleChanged)

public:
    explicit ScreenValues(QObject *parent = 0);

    Q_INVOKABLE void updateScreenValues();

    float dp() const;
    void setDp(float dp);

    int dpi() const;
    void setDpi(int dpi);

    int statusBarHeight() const;

    int navigationBarHeight() const;

    int navigationBarHeightLandscape() const;

    bool isTablet() const;
    void setIsTablet(bool isTablet);

    bool navBarVisible() const;

signals:
    void dpChanged();
    void dpiChanged();
    void statusBarHeightChanged();
    void navigationBarHeightChanged();
    void navigationBarHeightLandscapeChanged();
    void isTabletChanged();
    void navBarVisibleChanged();

private:
    System m_system;
    float m_dp;
    int m_dpi;
    int m_statusBarHeight;
    int m_navigationBarHeight;
    int m_navigationBarHeightLandscape;
    bool m_isTablet;
    bool m_navBarVisible;

    int retrieveDpi();
    int getResourceSize(const QString &resource);

    void setStatusBarHeight(int statusBarHeight);
    void setNavigationBarHeight(int navigationBarHeight);
    void setNavigationBarHeightLandscape(int navigationBarHeightLandscape);
    void setNavBarVisible(bool visible);
};

#endif // SCREENVALUES_H
