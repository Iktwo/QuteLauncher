#ifndef SCREENVALUES_H
#define SCREENVALUES_H

#include <QObject>

class ScreenValues : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int dpi READ dpi WRITE setDpi NOTIFY dpiChanged)
    Q_PROPERTY(float dp READ dp WRITE setDp NOTIFY dpChanged)
    Q_PROPERTY(bool isTablet READ isTablet NOTIFY isTabletChanged)
public:
    explicit ScreenValues(QObject *parent = 0);

    int dpi() const;
    void setDpi(int dpi);

    float dp() const;
    void setDp(float dp);

    bool isTablet() const;
    void setIsTablet(bool isTablet);

signals:
    void dpiChanged();
    void dpChanged();
    void isTabletChanged();

private:
    int m_dpi;
    float m_dp;
    bool m_isTablet;

    int retrieveDpi();
};

#endif // SCREENVALUES_H
