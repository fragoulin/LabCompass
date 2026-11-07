#include "application.h"
#include "global.h" // IWYU pragma: export
#include "helper/roompresethelper.h"
#include "keysequence/keysequencehelper.h"
#include "tray/trayiconmenu.h"
#include "version.h"
#include <QStringBuilder>
#include <QWKQuick/qwkquickglobal.h>

Q_GLOBAL_STATIC(Application::Windows, windows, {
    {
        "MainWindow",
        Application::Window(
            QUrl(QStringLiteral("qrc:/qt/qml/labcompass/MainWindow.qml")),
            &Application::handleMainWindowConnections)
    }, {
        "PlannerWindow",
        Application::Window(
            QUrl(QStringLiteral("qrc:/qt/qml/labcompass/planner/Planner.qml")),
            &Application::handlePlannerWindowConnections)
    }, {
        "RoomPresetsWindow",
        Application::Window(
            QUrl(QStringLiteral("qrc:/qt/qml/labcompass/roompresets/RoomPresets.qml")),
            &Application::handleRoomPresetsWindowConnections)
    }, {
        "PuzzleWindow",
        Application::Window(
            QUrl(QStringLiteral("qrc:/qt/qml/labcompass/Puzzle.qml")),
            &Application::handlePuzzleWindowConnections)
    }, {
        "OptionsWindow",
        Application::Window(
            QUrl(QStringLiteral("qrc:/qt/qml/labcompass/options/Options.qml")),
            &Application::handleOptionsWindowConnections)
    },
});

Application::Application(int& argc, char** argv)
    : QApplication(argc, argv)
{
    init();
    restorePreviouslyLoadedMap();
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

    qInfo() << "Init system tray icon";
    initSystemTrayIcon();

    qInfo() << "Init helpers";
    initHelpers();

    qInfo() << "Init workers";
    initWorkers();

    qInfo() << "Init controllers";
    initControllers();

    qInfo() << "Init windows";
    initWindows();

    qInfo() << "Init hotkeys";
    initHotkeys();

    qInfo() << "Initialization finished";
}

void Application::initWindowKit()
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");
    QQuickWindow::setDefaultAlphaBuffer(true);
    QWK::registerTypes(&engine);
}

void Application::initTranslations()
{
    QString languageCode;
    const QString languageCodeFromSettings = model.get_settings()->get_languageCode();
    if (languageCodeFromSettings.isEmpty()) {
        QLocale locale = QLocale::system();
        languageCode = QLocale::languageToCode(locale.language());
        model.get_settings()->set_languageCode(languageCode);
    }
    else
        languageCode = languageCodeFromSettings;

    updateLanguage(languageCode);
}

void Application::initResources()
{
    QQuickStyle::setStyle("Material");

    qmlRegisterType<KeySequenceHelper>("labcompass", 1, 0, "KeySequenceHelper");
    engine.load(QUrl("qrc:/qt/qml/labcompass/GlobalAccessor.qml"));
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to initialize global resources";
        quit();
    }

    auto rootObjects = engine.rootObjects();
    global = rootObjects[0]->property("o").value<QObject*>();
    global->setProperty("model", QVariant::fromValue<QObject*>(&model));
    global->setProperty("version", VERSION);
#ifdef QT_DEBUG
    global->setProperty("debug", true);
#endif

    if (-1 == QFontDatabase::addApplicationFont(":/assets/fonts/Fontin-SmallCaps.ttf"))
        qWarning() << "Failed to load font Fontin-SmallCaps.ttf";
    if (-1 == QFontDatabase::addApplicationFont(":/assets/fonts/OpenSans-Regular.ttf"))
        qWarning() << "Failed to load font OpenSans-Regular.ttf";

    QFont font("Fontin SmallCaps");
    font.setPixelSize(16);
    setFont(font);
}

void Application::initSystemTrayIcon()
{
    if (QSystemTrayIcon::isSystemTrayAvailable()) {
        trayIcon.reset(new QSystemTrayIcon(QIcon(":/assets/icons/LabCompass.ico")));
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

void Application::createWindow(QString windowName, QUrl windowUrl)
{
    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this, windowName](QObject *object) {
        onWindowCreated(windowName, static_cast<QWindow*>(object));
    }, Qt::QueuedConnection);
    connect(&engine, &QQmlApplicationEngine::objectCreationFailed, this, []() {
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(windowUrl);

    disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr);
    disconnect(&engine, &QQmlApplicationEngine::objectCreationFailed, this, nullptr);
}

void Application::initWindows()
{
    for (auto i = windows->cbegin(), end = windows->cend(); i != end; ++i)
        createWindow(i.key(), i.value().url);
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

void Application::initHotkeys()
{
    toggleHideUiHotkey.reset(new HotkeyBinding(global, model.get_settings(), "toggleHideUiHotkey", SIGNAL(toggleHideUiHotkeyChanged(QString))));
    connect(toggleHideUiHotkey.get(), &HotkeyBinding::activated, this,
        [this]() {
            bool visible = global->property("compassVisible").toBool();
            global->setProperty("compassVisible", !visible);
        });
}

void Application::restorePreviouslyLoadedMap()
{
    const auto& currentDate = model.get_currentUtcDate();
    const auto& lastLoadedMapDate = model.get_settings()->get_lastLoadedMapDate();

    if (currentDate == lastLoadedMapDate) {
        qInfo() << "Loading previously loaded map from cache";

        const auto& appData = QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
        const auto& lastLoadedMap = appData.absoluteFilePath("lastLoaded.map");
        labyrinthController->importFile(lastLoadedMap);
    }
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
            model.get_settings()->set_languageCode(languageCode);
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

void Application::onImportFileFailed()
{
    QMessageBox msgBox(nullptr);

    // Retrieve log file path
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    auto logFilePath = dir.absoluteFilePath("log.txt");

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
    model.get_settings()->set_mainWindowPosition(windowPosition);
    model.get_settings()->save();
}

void Application::onSettingsUpdated()
{
    const auto languageCode = model.get_settings()->get_languageCode();

    updateLanguage(languageCode);

    engine.retranslate();
}

void Application::onWindowCreated(QString windowName, QWindow* window)
{
    auto handler = windows->value(windowName).connectionsHandler;
    (this->*handler)(window);
}

void Application::handleMainWindowConnections(QWindow* window)
{
    connect(this, &Application::aboutToQuit,
            this, [this, window]() {
                onAboutToQuit(QPoint(window->x(), window->y()));
            });

    auto compass = window->findChild<QQuickItem*>("compass");
    connect(logWatcher.get(), SIGNAL(labStarted()),
            compass, SLOT(restartTimer()));
    connect(logWatcher.get(), SIGNAL(labFinished()),
            compass, SLOT(stopTimer()));
    connect(logWatcher.get(), SIGNAL(labExit()),
            compass, SLOT(closeTimer()));

    auto izaroInstructionItemIcon = window->findChild<QQuickItem*>("izaroInstructionItemIcon");
    connect(logWatcher.get(), SIGNAL(roomChanged(QString)),
            izaroInstructionItemIcon, SLOT(onRoomChanged()));
    connect(logWatcher.get(), SIGNAL(izaroBattleStarted()),
            izaroInstructionItemIcon, SLOT(onIzaroBattleStarted()));
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
