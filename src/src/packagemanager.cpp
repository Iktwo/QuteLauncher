#include "packagemanager.h"

#include "application.h"

#include <QDebug>
#include <QImage>
#include <QSettings>

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>

static void packageAdded(JNIEnv *env, jobject thiz, jstring label, jstring packageName, jlong qtObject)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)
    reinterpret_cast<PackageManager*>(qtObject)->emitAddApplication(PackageManager::jstringToQString(label).simplified(), PackageManager::jstringToQString(packageName));
}

static void packageRemoved(JNIEnv *env, jobject thiz, jstring packageName, jlong qtObject)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)
    reinterpret_cast<PackageManager*>(qtObject)->emitRemoveApplication(PackageManager::jstringToQString(packageName));
}
#endif

PackageManager::PackageManager(QObject *parent) :
    QAbstractListModel(parent)
{
#ifdef Q_OS_ANDROID
    mAndroidActivity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    mIntentFilter = QAndroidJniObject("android/content/IntentFilter");
    mBroadcastReceiver = QAndroidJniObject("com/iktwo/qutelauncher/PackageChangedReceiver");
#endif

    connect(this, SIGNAL(newApplicationDetected(QString, QString)), this, SLOT(addApplication(QString, QString)));
    connect(this, SIGNAL(removedApplication(QString)), this, SLOT(removeApplication(QString)));
}

int PackageManager::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mApplications.count();
}

QVariant PackageManager::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mApplications.count())
        return QVariant();

    switch (role) {
    case NameRole:
        return qobject_cast<Application*>(mApplications.at(index.row()))->name();
        break;
    case PackageNameRole:
        return qobject_cast<Application*>(mApplications.at(index.row()))->packageName();
        break;
    case CategoryRole:
        return qobject_cast<Application*>(mApplications.at(index.row()))->category();
        break;
    }
    return QVariant();
}

#ifdef Q_OS_ANDROID
void PackageManager::registerNativeMethods() {
    JNINativeMethod methods[] {{"jpackageRemoved", "(Ljava/lang/String;J)V", reinterpret_cast<void *>(packageRemoved)},
        {"jpackageAdded", "(Ljava/lang/String;Ljava/lang/String;J)V", reinterpret_cast<void *>(packageAdded)}};

    QAndroidJniObject::callStaticMethod<void>("com/iktwo/qutelauncher/PackageChangedReceiver",
                                              "setQtObject", "(J)V",
                                              "(J)V", reinterpret_cast<long>(this));

    QAndroidJniEnvironment env;
    jclass objectClass = env->GetObjectClass(mBroadcastReceiver.object<jobject>());

    if (env->ExceptionCheck())
        env->ExceptionClear();

    env->RegisterNatives(objectClass, methods, sizeof(methods) / sizeof(methods[0]));

    if (env->ExceptionCheck())
        env->ExceptionClear();

    env->DeleteLocalRef(objectClass);

    if (env->ExceptionCheck())
        env->ExceptionClear();
}
#endif

void PackageManager::launchApplication(const QString &application)
{
    // qDebug() << "Trying to launch:" << application;

#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/iktwo/qutelauncher/QuteLauncher",
                                              "launchApplication",
                                              "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(application).object<jstring>());
#else
    Q_UNUSED(application)
#endif
}

QHash<int, QByteArray> PackageManager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[PackageNameRole] = "packageName";
    roles[CategoryRole] = "category";
    return roles;
}

QString GetRandomString()
{
    const QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
    const int randomStringLength = 8; // assuming you want random strings of 12 characters

    QString randomString;
    for(int i=0; i < randomStringLength; ++i)
    {
        int index = qrand() % possibleCharacters.length();
        QChar nextChar = possibleCharacters.at(index);
        randomString.append(nextChar);
    }

    return randomString;
}

void PackageManager::retrievePackages()
{
    beginResetModel();
#ifdef Q_OS_ANDROID
    QAndroidJniObject connectionType = QAndroidJniObject::callStaticObjectMethod("com/iktwo/qutelauncher/QuteLauncher",
                                                                                 "applications",
                                                                                 "()[Lcom/iktwo/qutelauncher/Application;");


    jobjectArray array = connectionType.object<jobjectArray>();

    QAndroidJniEnvironment env;
    jsize size = env->GetArrayLength(array);
    for (int i = 0; i < size; ++i) {
        QAndroidJniObject obj = env->GetObjectArrayElement(array, i);

        QString name = jstringToQString((obj.callObjectMethod<jstring>("getName")).object<jstring>());
        QString packageName = jstringToQString((obj.callObjectMethod<jstring>("getPackageName")).object<jstring>());

        qDebug() << "name:" << name  << " packageName:"  << packageName;

        if (packageName == "com.google.android.launcher")
            continue;

        mApplications.append(new Application(name.simplified(), packageName));
    }
#else
    mApplications.append(new Application("Aero", "com.aero"));
    mApplications.append(new Application("Andale", "com.andale"));
    mApplications.append(new Application("Andate", "com.andate"));
    mApplications.append(new Application("Basurto", "com.basurto"));
    mApplications.append(new Application("Bueno", "com.bueno"));
    mApplications.append(new Application("Casa", "com.casa"));
    mApplications.append(new Application("Cosa", "com.cosa"));
    mApplications.append(new Application("Crosa", "com.crosa"));
    mApplications.append(new Application("Indie", "com.indie"));
    mApplications.append(new Application("Indira", "com.indira"));
    mApplications.append(new Application("Indigo", "com.indigo"));
    mApplications.append(new Application("Juice", "com.juice"));
    mApplications.append(new Application("Kato", "com.kato"));
    mApplications.append(new Application("Keee", "com.keee"));
    mApplications.append(new Application("Kila", "com.kila"));
    mApplications.append(new Application("Kilo", "com.kilo"));
    mApplications.append(new Application("Kudo", "com.kudo"));
    mApplications.append(new Application("Kuelo", "com.kuelo"));
    mApplications.append(new Application("Kuzz", "com.kuzz"));
    mApplications.append(new Application("Locos", "com.locos"));
    mApplications.append(new Application("Lucas", "com.lucas"));
    mApplications.append(new Application("Many", "com.many"));
    mApplications.append(new Application("Mano", "com.mano"));
    mApplications.append(new Application("Mezcla", "com.mezcla"));
    mApplications.append(new Application("Nooooo", "com.nooooo"));
    mApplications.append(new Application("Niurka", "com.niurka"));
    mApplications.append(new Application("Nunca", "com.nunca"));
    mApplications.append(new Application("Tatoo", "com.tatoo"));
    mApplications.append(new Application("Tito", "com.tito"));
    mApplications.append(new Application("Toto", "com.toto"));
    mApplications.append(new Application("Tuto", "com.tuto"));
    mApplications.append(new Application("Radio", "com.radio"));
    mApplications.append(new Application("Rojo", "com.rojo"));
    mApplications.append(new Application("Very long name here", "com.very"));
    mApplications.append(new Application("Zahm", "com.zahm"));
    mApplications.append(new Application("Zooom", "com.zooom"));
#endif

    QSettings settings;
    int packagesSize = settings.beginReadArray("packages");
    settings.endArray();
    QStringList defaultApps;

#ifdef Q_OS_ANDROID
    if (packagesSize == 0) {
        defaultApps << "com.android.dialer";
        defaultApps << "com.android.contacts";
        defaultApps << "com.android.chrome";
        defaultApps << "com.google.android.GoogleCamera";
        defaultApps << "com.google.android.music";
        defaultApps << "com.google.android.youtube";
        defaultApps << "com.google.android.talk";
        defaultApps << "com.google.android.gallery3d";
        defaultApps << "com.facebook.katana";
        defaultApps << "com.whatsapp";
        defaultApps << "com.google.android.gm";
        defaultApps << "com.android.deskclock";
        defaultApps << "com.google.android.keep";
        defaultApps << "com.google.android.calendar";
        defaultApps << "com.google.android.apps.maps";
        defaultApps << "com.google.earth";
        defaultApps << "com.cyanogenmod.filemanager";
        defaultApps << "com.android.providers.downloads.ui";
        defaultApps << "com.android.vending";
        defaultApps << "com.android.settings";
    }
#else
    if (packagesSize == 0) {
        defaultApps << "com.aero";
        defaultApps << "com.andate";
        defaultApps << "com.basurto";
//        defaultApps << "com.bueno";
//        defaultApps << "com.casa";
//        defaultApps << "com.cosa";
//        defaultApps << "com.crosa";
//        defaultApps << "com.indie";
//        defaultApps << "com.indira";
//        defaultApps << "com.indigo";
//        defaultApps << "com.juice";
//        defaultApps << "com.kato";
//        defaultApps << "com.keee";
//        defaultApps << "com.kila";
    }
#endif

    if (packagesSize == 0) {
        foreach (QString app, defaultApps) {
            foreach (QObject *applicationObject, mApplications) {
                Application *application = qobject_cast<Application*>(applicationObject);
                if (app == application->packageName()) {
                    emit addedApplicationToGrid(application->name(), application->packageName());
                    break;
                }
            }
        }
    }

    /// TODO: add code to clean this before retrieving packages, change this foreach with a for
    /// This assumes mApplications is ordered, and it should be..

    int i = 0;
    foreach (QObject *object, mApplications) {
        Application *application = qobject_cast<Application*>(object);

        if (!mSections.contains(application->category())) {
            mSections.append(application->category());
            mSectionsPositions.append(i);
        }

        ++i;
    }

    qDebug() << "mApplications:" << mApplications;

    endResetModel();
    emit sectionsChanged();
}

void PackageManager::registerBroadcast()
{
    retrievePackages();

#ifdef Q_OS_ANDROID
    qDebug() << Q_FUNC_INFO << "registering broadcast";
    QAndroidJniObject addActionString = QAndroidJniObject::fromString("android.intent.action.PACKAGE_ADDED");
    QAndroidJniObject removeActionString = QAndroidJniObject::fromString("android.intent.action.PACKAGE_REMOVED");
    QAndroidJniObject dataSchemeString = QAndroidJniObject::fromString("package");


    mIntentFilter.callMethod<void>("addAction", "(Ljava/lang/String;)V", addActionString.object<jstring>());
    mIntentFilter.callMethod<void>("addAction", "(Ljava/lang/String;)V", removeActionString.object<jstring>());
    mIntentFilter.callMethod<void>("addDataScheme", "(Ljava/lang/String;)V", dataSchemeString.object<jstring>());

    mAndroidActivity.callObjectMethod("registerReceiver",
                                      "(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;",
                                      mBroadcastReceiver.object<jobject>(), mIntentFilter.object<jobject>());

    registerNativeMethods();
#endif
}

int PackageManager::indexOfSection(const QString &section)
{
    return mSectionsPositions.at(mSections.indexOf(section));
}

void PackageManager::openApplicationInfo(const QString &packageName)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticObjectMethod("com/iktwo/qutelauncher/QuteLauncher",
                                              "openApplicationInfo",
                                              "(Ljava/lang/String;)V",
                                              QAndroidJniObject::fromString(packageName).object<jstring>());
#else
    Q_UNUSED(packageName)
#endif
}

void PackageManager::addApplicationToGrid(const QString &name, const QString &packageName)
{
    emit addedApplicationToGrid(name, packageName);
}

void PackageManager::testJNICall()
{
#ifdef Q_OS_ANDROID
    qDebug() << "GEtting instance";
    QAndroidJniObject packageManager = QAndroidJniObject::callStaticObjectMethod("com/iktwo/qutelauncher/QuteLauncher",
                                                                                 "getInstance",
                                                                                 "()Lcom/iktwo/qutelauncher/QuteLauncher;");

    packageManager.callMethod<void>("selectWidget");
    qDebug() << "PM:" << packageManager.toString();
#endif
}

QStringList PackageManager::sections() const
{
    return mSections;
}

#ifdef Q_OS_ANDROID
QString PackageManager::jstringToQString(jstring string)
{
    QAndroidJniEnvironment env;
    jboolean jfalse = false;
    return QString(env->GetStringUTFChars(string, &jfalse));
}
#endif

void PackageManager::addApplication(const QString &name, const QString &packageName)
{
    int i;
    for (i = 0; i < mApplications.length(); ++i) {
        Application *application = qobject_cast<Application*>(mApplications.at(i));
        if (name.compare(application->name()) < 0)
            break;
    }

    qDebug() << Q_FUNC_INFO << "NAME:" << name << " PACKAGE:" << packageName;
    beginInsertRows(QModelIndex(), i, i);
    Application *application = new Application(name, packageName);
    mApplications.insert(i, application);
    endInsertRows();

    if (!mSections.contains(application->category())) {
        mSections.append(application->category());
        mSectionsPositions.append(i);
    }
}

void PackageManager::removeApplication(const QString &packageName)
{
    qDebug() << Q_FUNC_INFO << packageName;
    int i = 0;
    foreach (QObject *object, mApplications) {
        Application *app = qobject_cast<Application*>(object);
        if (app->packageName() == packageName) {
            beginRemoveRows(QModelIndex(), i, i);
            delete mApplications.takeAt(i);
            endRemoveRows();
            i--;
        }
        i++;
    }

    mSections.clear();
    mSectionsPositions.clear();

    i = 0;
    foreach (QObject *object, mApplications) {
        Application *application = qobject_cast<Application*>(object);

        if (!mSections.contains(application->category())) {
            mSections.append(application->category());
            mSectionsPositions.append(i);
        }

        ++i;
    }

    sectionsChanged();
}

void PackageManager::emitAddApplication(const QString &name, const QString &packageName)
{
    emit newApplicationDetected(name, packageName);
}

void PackageManager::emitRemoveApplication(const QString &packageName)
{
    emit removedApplication(packageName);
}
