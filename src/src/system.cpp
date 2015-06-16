#include "system.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

System::System(QObject *parent) : QObject(parent)
{
    setSdkInt(getSdkInt());
}

int System::sdkInt() const
{
    return m_sdkInt;
}

void System::setSdkInt(int sdkInt)
{
    if (m_sdkInt == sdkInt)
        return;

    m_sdkInt = sdkInt;
    emit sdkIntChanged(sdkInt);
}

int System::getSdkInt()
{
#ifdef Q_OS_ANDROID
    return m_sdkInt = QAndroidJniObject::getStaticField<jint>("android/os/Build$VERSION", "SDK_INT");
#else
    return 0;
#endif
}
