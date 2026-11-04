#include "application.h"
#include "global.h" // IWYU pragma: export
#include "helper/roompresethelper.h"
#include "keysequence/keysequencehelper.h"
#include "tray/trayiconmenu.h"
#include "version.h"
#include <QStringBuilder>
#include <QWKQuick/qwkquickglobal.h>

Application::Application(int& argc, char** argv)
    : QApplication(argc, argv)
{
    connect(this, &Application::aboutToQuit,
        this, &Application::onAboutToQuit);

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

    qInfo() << "Init windows";
    initWindows();

    qInfo() << "Init workers";
    initWorkers();

    qInfo() << "Init controllers";
    initControllers();

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

void Application::initWindows()
{
    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this](QObject *object) {
        if (object->objectName() == "MainWindow" && object->isWindowType())
            window = static_cast<QWindow*>(object);
    });
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/labcompass/MainWindow.qml")));
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to load main window";
        quit();
    }
    disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr);

    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this](QObject *object) {
        if (object->objectName() == "PlannerWindow" && object->isWindowType())
            plannerWindow = static_cast<QWindow*>(object);
    });
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/labcompass/planner/Planner.qml")));
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to load planner window";
        quit();
    }
    disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr);

    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this](QObject *object) {
        if (object->objectName() == "RoomPresetsWindow" && object->isWindowType())
            roomPresetsWindow = static_cast<QWindow*>(object);
    });
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/labcompass/roompresets/RoomPresets.qml")));
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to load room presets window";
        quit();
    }
    disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr);

    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this](QObject *object) {
        if (object->objectName() == "PuzzleWindow" && object->isWindowType())
            puzzleWindow = static_cast<QWindow*>(object);
    });
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/labcompass/Puzzle.qml")));
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to load puzzle window";
        quit();
    }
    disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr);

    connect(&engine, &QQmlApplicationEngine::objectCreated, this, [this](QObject *object) {
        if (object->objectName() == "OptionsWindow" && object->isWindowType())
            optionsWindow = static_cast<QWindow*>(object);
    });
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/labcompass/options/Options.qml")));
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "Failed to load options window";
        quit();
    }
    disconnect(&engine, &QQmlApplicationEngine::objectCreated, this, nullptr);

    connect(optionsWindow, SIGNAL(settingsUpdated()),
            this, SLOT(onSettingsUpdated()));
}

void Application::initWorkers()
{
    logWatcher.reset(new LogWatcher(&model));

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

    versionChecker.reset(new VersionChecker(&model));
    dateChecker.reset(new DateChecker(&model));
}

void Application::initControllers()
{
    labyrinthController.reset(new LabyrinthController(&model));
    connect(plannerWindow, SIGNAL(importFile(QString)),
            labyrinthController.get(), SLOT(importFile(QString)));
    connect(roomPresetsWindow, SIGNAL(applyPresetButtonClicked(QString,QString)),
            labyrinthController.get(), SLOT(onRoomPresetSet(QString,QString)));

    connect(labyrinthController.get(), SIGNAL(importFileFailed()),
            this, SLOT(onImportFileFailed()));

    navigationController.reset(new NavigationController(&model));
    connect(logWatcher.get(), &LogWatcher::plazaEntered,
        navigationController.get(), &NavigationController::onPlazaEntered);
    connect(logWatcher.get(), &LogWatcher::labStarted,
        navigationController.get(), &NavigationController::onLabStarted);
    connect(logWatcher.get(), &LogWatcher::sectionFinished,
        navigationController.get(), &NavigationController::onSectionFinished);
    connect(logWatcher.get(), &LogWatcher::labExit,
        navigationController.get(), &NavigationController::onLabExit);
    connect(logWatcher.get(), &LogWatcher::roomChanged,
        navigationController.get(), &NavigationController::onRoomChanged);
    connect(logWatcher.get(), &LogWatcher::portalSpawned,
        navigationController.get(), &NavigationController::onPortalSpawned);
    connect(plannerWindow, SIGNAL(setRoomIsTarget(QString,bool)),
            navigationController.get(), SLOT(onRoomIsTargetSet(QString,bool)));
    connect(plannerWindow, SIGNAL(setCurrentRoom(QString)),
            navigationController.get(), SLOT(onRoomIdSet(QString)));
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
    const QString baseFilename = QApplication::applicationName();
    QString filename = baseFilename % "_" % languageCode;
    const QString directory = ":/i18n";

    if (!translator.load(filename, directory) || !installTranslator(&translator)) {
        qWarning() << "Cannot find translation" << filename << "from directory" << directory << "and language code" << languageCode << ". Fallback to english language";
        languageCode = "en";
        filename = baseFilename % "_" % languageCode;
        if(translator.load(filename, directory)) {
            qInfo() << "Using english as fallback language";
            model.get_settings()->set_languageCode(languageCode);
            installTranslator(&translator);
        }
        else
            qWarning() << "Failed to load english fallback file" << filename << "from directory" << directory;
    }
}

void Application::onImportFileFailed()
{
    QMessageBox msgBox(nullptr);
    //: Title for import file error
    //% "Failed to import file."
    //@ Error
    msgBox.setText(qtTrId("id-failed-to-import-file-title"));
    msgBox.setIcon(QMessageBox::Warning);
    //: Text for import file error
    //% "JSON file cannot be imported. Please check logs."
    //@ Error
    msgBox.setInformativeText(qtTrId("id-failed-to-import-file-text"));
    msgBox.setStandardButtons(QMessageBox::Ok);
    msgBox.exec();
}

void Application::onAboutToQuit()
{
    model.get_settings()->set_mainWindowPosition(QPoint(window->x(), window->y()));
    model.get_settings()->save();
}

void Application::onSettingsUpdated()
{
    const auto languageCode = model.get_settings()->get_languageCode();
    if (!translator.isEmpty())
        removeTranslator(&translator);

    updateLanguage(languageCode);

    engine.retranslate();
}
