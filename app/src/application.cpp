#include "application.h"
#include "global.h" // IWYU pragma: export
#include "helper/roompresethelper.h"
#include "keysequence/keysequencehelper.h"
#include "tray/trayiconmenu.h"
#include "version.h"
#include <QStringBuilder>
#include <QWKQuick/qwkquickglobal.h>
using namespace Qt::StringLiterals;

Q_GLOBAL_STATIC(Application::Modules, windows, {
    {
        u"Main"_s, &Application::handleMainWindowConnections
    }, {
        u"Planner"_s, &Application::handlePlannerWindowConnections
    }, {
        u"RoomPresets"_s, &Application::handleRoomPresetsWindowConnections
    }, {
        u"Puzzle"_s, &Application::handlePuzzleWindowConnections
    }, {
        u"Options"_s, &Application::handleOptionsWindowConnections
    },
});

Application::Application(int& argc, char** argv)
    : QApplication(argc, argv)
{
    init();
}

void Application::init()
{
    qInfo() << "Initialization started";

    qInfo() << "Init Window Kit";
    initWindowKit();

    qInfo() << "Init translations";
    initTranslations();

    qInfo() << "Init resources";
    initResources();
}

void Application::initWindowKit()
{
    if (!qputenv("QT_QUICK_CONTROLS_STYLE", "Basic"))
        qWarning() << "Failed to set environment variable: QT_QUICK_CONTROLS_STYLE";
    QQuickWindow::setDefaultAlphaBuffer(true);
    QWK::registerTypes(&engine);
}

void Application::initTranslations()
{
    QString languageCode;
    const QString languageCodeFromSettings = model.get_settings()->languageCode();
    if (languageCodeFromSettings.isEmpty()) {
        QLocale locale = QLocale::system();
        languageCode = QLocale::languageToCode(locale.language());
        model.get_settings()->setLanguageCode(languageCode);
    }
    else
        languageCode = languageCodeFromSettings;

    updateLanguage(languageCode);
}

void Application::initResources()
{
    QQuickStyle::setStyle(u"Material"_s);

    qmlRegisterType<KeySequenceHelper>("labcompass", 1, 0, "KeySequenceHelper");

    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this](QObject *object) {
        if (!object)
            qFatal() << "Failed to load global accessor";
        global = object->property("o").value<QObject*>();
        global->setProperty("model", QVariant::fromValue<QObject*>(&model));

        onResourcesLoaded();
    }, Qt::QueuedConnection);

    connect(&engine, &QQmlApplicationEngine::objectCreationFailed, this, []() {
        exit(-1);
    }, Qt::QueuedConnection);

    engine.loadFromModule("labcompass", "GlobalAccessor");

    if (!disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr))
        qWarning() << "Failed to disconnect signal for object created (resources)";
    if (!disconnect(&engine, &QQmlApplicationEngine::objectCreationFailed, this, nullptr))
        qWarning() << "Failed to disconnect signal for object creation failed (resources)";

}

void Application::onResourcesLoaded()
{
    qInfo() << "Init fonts";
    initFonts();

    qInfo() << "Init system tray icon";
    initSystemTrayIcon();

    qInfo() << "Init helpers";
    initHelpers();

    qInfo() << "Init workers";
    initWorkers();

    qInfo() << "Init controllers";
    initControllers();

    qInfo() << "Init hotkeys";
    initHotkeys();

    qInfo() << "Init windows";
    initWindows();

    qInfo() << "Initialization finished";
}

void Application::initFonts()
{
    if (-1 == QFontDatabase::addApplicationFont(u":/assets/fonts/Fontin-SmallCaps.ttf"_s))
        qWarning() << "Failed to load font Fontin-SmallCaps.ttf";
    if (-1 == QFontDatabase::addApplicationFont(u":/assets/fonts/OpenSans-Regular.ttf"_s))
        qWarning() << "Failed to load font OpenSans-Regular.ttf";

    QFont font(u"Fontin SmallCaps"_s);
    font.setPixelSize(16);
    setFont(font);
}

void Application::initSystemTrayIcon()
{
    if (QSystemTrayIcon::isSystemTrayAvailable()) {
        trayIcon.reset(new QSystemTrayIcon(QIcon(u":/assets/icons/LabCompass.ico"_s)));
        trayIconMenu.reset(new TrayIconMenu());
        trayIcon->setContextMenu(trayIconMenu.get());
        //: Tooltip for tray icon
        //% "LabCompass"
        //@ TrayIcon
        trayIcon->setToolTip(qtTrId("id-trayicon-labcompass"));
        trayIcon->show();
    } else {
        qInfo() << "   System tray not available";
    }
}

void Application::initHelpers()
{
    RoomPresetHelper::instance = new RoomPresetHelper();
}

void Application::initWorkers()
{
    logWatcher.reset(new LogWatcher(&model));
    versionChecker.reset(new VersionChecker(&model));
    dateChecker.reset(new DateChecker(&model));
}

void Application::initControllers()
{
    labyrinthController.reset(new LabyrinthController(&model));

    connect(labyrinthController.get(), SIGNAL(importFileSuccess(QString,QDate)),
            this, SLOT(onImportFileSuccess(QString,QDate)));
    connect(labyrinthController.get(), SIGNAL(importFileFailed()),
            this, SLOT(onImportFileFailed()));

    navigationController.reset(new NavigationController(&model));

    connect(logWatcher.get(), SIGNAL(plazaEntered()),
        navigationController.get(), SLOT(onPlazaEntered()));
    connect(logWatcher.get(), SIGNAL(labStarted()),
        navigationController.get(),SLOT(onLabStarted()));
    connect(logWatcher.get(), SIGNAL(sectionFinished()),
        navigationController.get(), SLOT(onSectionFinished()));
    connect(logWatcher.get(), SIGNAL(labExit()),
        navigationController.get(), SLOT(onLabExit()));
    connect(logWatcher.get(), SIGNAL(roomChanged(QString)),
        navigationController.get(), SLOT(onRoomChanged(QString)));
    connect(logWatcher.get(), SIGNAL(portalSpawned()),
        navigationController.get(), SLOT(onPortalSpawned()));
}

void Application::initWindows()
{
    QVariantMap initialProperties;
    initialProperties["settings"] = QVariant::fromValue<Settings*>(model.get_settings());
    initialProperties["version"] = VERSION;
    initialProperties["logWatcher"] = QVariant::fromValue<LogWatcher*>(logWatcher.get());
    initialProperties["hotkey"] = QVariant::fromValue<HotkeyBinding*>(toggleHideUiHotkey.get());

    engine.setInitialProperties(initialProperties);

    for (auto [key, value] : windows->asKeyValueRange())
        createWindow(key, value);
}

void Application::initHotkeys()
{
    toggleHideUiHotkey.reset(new HotkeyBinding(global, model.get_settings(), "toggleHideUiHotkey", SIGNAL(toggleHideUiHotkeyChanged(QString))));
}

void Application::restorePreviouslyLoadedMap()
{
    const auto& currentDate = model.get_currentUtcDate();
    const auto& lastLoadedMapDate = model.get_settings()->lastLoadedMapDate();

    if (currentDate == lastLoadedMapDate) {
        qInfo() << "Loading previously loaded map from cache";

        const auto& appData = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        const auto& lastLoadedMap = appData.absoluteFilePath("lastLoaded.map");
        labyrinthController->importFile(lastLoadedMap);
    }
}

void Application::createWindow(QString typeName, Handler handler)
{
    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this, typeName, handler](QObject *object) {
        if (!object)
            qFatal() << "Failed to load from module" << typeName;
        onWindowCreated(static_cast<QWindow*>(object), handler);
    }, Qt::QueuedConnection);

    connect(&engine, &QQmlApplicationEngine::objectCreationFailed, this, []() {
        exit(-1);
    }, Qt::QueuedConnection);

    engine.loadFromModule("labcompass", typeName);

    if (!disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr))
        qWarning() << "Failed to disconnect signal for object created (window)";
    if (!disconnect(&engine, &QQmlApplicationEngine::objectCreationFailed, this, nullptr))
        qWarning() << "Failed to disconnect signal for object creation failed (window)";
}

void Application::updateLanguage(QString languageCode)
{
    if (!translator.isEmpty() && !removeTranslator(&translator))
        qWarning() << "Failed to remove translator" << translator.language();

    const QString applicationName = QApplication::applicationName();
    const QString directory = ":/i18n";

    QLocale locale (languageCode);

    if (!translator.load(locale, applicationName, "_", directory)) {
        qWarning() << "Cannot load translation" << applicationName << "from directory" << directory << "and locale" << locale << ". Fallback to english locale";
        if(translator.load(QLocale("en"), applicationName, "_", directory)) {
            qInfo() << "    Using english as fallback language";
            model.get_settings()->setLanguageCode(languageCode);
            installTranslator(&translator);
            QLocale::setDefault(QLocale("en"));
        }
        else
            qWarning() << "Failed to load default language" << applicationName << "from directory" << directory << "and locale" << QLocale();
    } else if (!installTranslator(&translator)) {
        qWarning() << "Failed to install translator" << translator.language();
    } else {
        QLocale::setDefault(locale);
    }
    qInfo() << "Default locale set to" << QLocale();
}

void Application::onImportFileSuccess([[maybe_unused]] QString fileName, QDate fileDate)
{
    // update last loaded map date
    model.get_settings()->setLastLoadedMapDate(fileDate);
}

void Application::onImportFileFailed()
{
    QMessageBox msgBox(nullptr);

    // Retrieve log file path
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    auto logFilePath = dir.absoluteFilePath(u"log.txt"_s);

    //: Title for import file error
    //% "Failed to import file."
    //@ Error
    msgBox.setText(qtTrId("id-failed-to-import-file-title"));
    msgBox.setIcon(QMessageBox::Warning);
    //: Text for import file error
    //% "JSON file cannot be imported. Please check logs at %1"
    //@ Error
    msgBox.setInformativeText(qtTrId("id-failed-to-import-file-text").arg(logFilePath));
    msgBox.setStandardButtons(QMessageBox::Ok);
    msgBox.exec();
}

void Application::onAboutToQuit(QPoint windowPosition)
{
    model.get_settings()->setMainWindowPosition(windowPosition);
    model.get_settings()->save();
}

void Application::onSettingsUpdated()
{
    QString currentLanguageCode = QLocale::languageToCode(QLocale().language());
    const auto newLanguageCode = model.get_settings()->languageCode();

    if (currentLanguageCode != newLanguageCode) {
        updateLanguage(newLanguageCode);
        engine.retranslate();
    }
}

void Application::onWindowCreated(QWindow* window, Handler handler)
{
    (this->*handler)(window);

    // All handlers have to finish their work before application is ready
    handlersCount++;
    if (handlersCount == windows->size()) {
        restorePreviouslyLoadedMap();
    }
}

void Application::handleMainWindowConnections(QWindow* window)
{
    connect(this, &Application::aboutToQuit,
            this, [this, window]() {
                onAboutToQuit(QPoint(window->x(), window->y()));
            });
}

void Application::handlePlannerWindowConnections(QWindow* window)
{
    connect(window, SIGNAL(importFile(QString)),
            labyrinthController.get(), SLOT(importFile(QString)));
    connect(window, SIGNAL(setRoomIsTarget(QString,bool)),
            navigationController.get(), SLOT(onRoomIsTargetSet(QString,bool)));
    connect(window, SIGNAL(setCurrentRoom(QString)),
            navigationController.get(), SLOT(onRoomIdSet(QString)));
}

void Application::handleRoomPresetsWindowConnections(QWindow* window)
{
    connect(window, SIGNAL(applyPresetButtonClicked(QString,QString)),
            labyrinthController.get(), SLOT(onRoomPresetSet(QString,QString)));
}

void Application::handlePuzzleWindowConnections([[maybe_unused]] QWindow* window)
{
}

void Application::handleOptionsWindowConnections(QWindow* window)
{
    connect(window, SIGNAL(settingsUpdated()),
            this, SLOT(onSettingsUpdated()));
}
